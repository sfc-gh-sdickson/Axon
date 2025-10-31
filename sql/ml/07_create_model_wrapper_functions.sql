-- ============================================================================
-- Axon Intelligence Agent - Model Registry Wrapper Functions
-- ============================================================================
-- Purpose: Create SQL procedures that wrap Model Registry models
--          so they can be added as tools to the Intelligence Agent
-- Based on: Model Registry integration pattern
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Procedure 1: Evidence Upload Volume Forecast Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_EVIDENCE_UPLOAD_VOLUME(INT);

CREATE OR REPLACE PROCEDURE PREDICT_EVIDENCE_UPLOAD_VOLUME(
    MONTHS_AHEAD INT
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_evidence_volume'
COMMENT = 'Calls EVIDENCE_VOLUME_PREDICTOR model from Model Registry to forecast evidence uploads'
AS
$$
def predict_evidence_volume(session, months_ahead):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model from registry
    reg = Registry(session)
    model = reg.get_model("EVIDENCE_VOLUME_PREDICTOR").default
    
    # Get recent evidence data for prediction
    recent_data_query = f"""
    SELECT
        MONTH(CURRENT_DATE()) + {months_ahead} AS month_num,
        YEAR(CURRENT_DATE()) AS year_num,
        AVG(upload_count)::FLOAT AS upload_count,
        AVG(deployment_count)::FLOAT AS deployment_count,
        AVG(avg_file_size_mb)::FLOAT AS avg_file_size_mb
    FROM (
        SELECT
            COUNT(DISTINCT evidence_id)::FLOAT AS upload_count,
            COUNT(DISTINCT deployment_id)::FLOAT AS deployment_count,
            AVG(file_size_mb)::FLOAT AS avg_file_size_mb
        FROM RAW.EVIDENCE_UPLOADS
        WHERE upload_date >= DATEADD('month', -6, CURRENT_DATE())
        GROUP BY DATE_TRUNC('month', upload_date)
    )
    """
    
    input_df = session.sql(recent_data_query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Convert to pandas and format as JSON string
    result = predictions.select("PREDICTED_UPLOAD_VOLUME").to_pandas()
    
    return json.dumps({
        "months_ahead": months_ahead,
        "predicted_upload_volume": int(result['PREDICTED_UPLOAD_VOLUME'].iloc[0])
    })
$$;

-- ============================================================================
-- Procedure 2: Agency Churn Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_AGENCY_CHURN(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_AGENCY_CHURN(
    AGENCY_TYPE_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_churn'
COMMENT = 'Calls AGENCY_CHURN_PREDICTOR model from Model Registry to identify at-risk agencies'
AS
$$
def predict_churn(session, agency_type_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("AGENCY_CHURN_PREDICTOR").default
    
    # Build query with optional filter
    type_filter = f"AND a.agency_type = '{agency_type_filter}'" if agency_type_filter else ""
    
    query = f"""
    SELECT
        a.agency_type,
        a.jurisdiction_type,
        a.lifetime_value::FLOAT AS lifetime_value,
        a.population_served::FLOAT AS population_served,
        COUNT(DISTINCT CASE WHEN ord.order_date >= DATEADD('month', -3, CURRENT_DATE()) 
                       THEN ord.order_id END)::FLOAT AS recent_orders,
        (COUNT(DISTINCT CASE WHEN ord.order_date < DATEADD('month', -3, CURRENT_DATE()) 
                        THEN ord.order_id END) / 9.0)::FLOAT AS historical_avg_orders,
        AVG(CASE WHEN st.created_date >= DATEADD('month', -6, CURRENT_DATE()) 
            THEN st.customer_satisfaction_score::FLOAT END) AS avg_csat,
        COUNT(DISTINCT qi.quality_issue_id)::FLOAT AS quality_issue_count,
        COUNT(DISTINCT CASE WHEN dd.deployment_date >= DATEADD('month', -12, CURRENT_DATE()) 
                       THEN dd.deployment_id END)::FLOAT AS recent_deployments,
        FALSE::BOOLEAN AS is_churned
    FROM RAW.AGENCIES a
    LEFT JOIN RAW.ORDERS ord ON a.agency_id = ord.agency_id
    LEFT JOIN RAW.SUPPORT_TICKETS st ON a.agency_id = st.agency_id
    LEFT JOIN RAW.QUALITY_ISSUES qi ON a.agency_id = qi.agency_id
    LEFT JOIN RAW.DEVICE_DEPLOYMENTS dd ON a.agency_id = dd.agency_id
    WHERE a.agency_status = 'ACTIVE' {type_filter}
    GROUP BY a.agency_id, a.agency_type, a.jurisdiction_type, a.lifetime_value, a.population_served
    LIMIT 10
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Count high-risk agencies (assuming 1 = churned)
    result = predictions.select("CHURN_PREDICTION").to_pandas()
    churn_count = int(result['CHURN_PREDICTION'].sum())
    total_count = len(result)
    
    return json.dumps({
        "agency_type_filter": agency_type_filter or "ALL",
        "total_agencies_analyzed": total_count,
        "predicted_to_churn": churn_count,
        "churn_rate_pct": round(churn_count / total_count * 100, 2) if total_count > 0 else 0
    })
$$;

-- ============================================================================
-- Procedure 3: Device Deployment Success Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_DEPLOYMENT_SUCCESS(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_DEPLOYMENT_SUCCESS(
    PRODUCT_FAMILY_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_success'
COMMENT = 'Calls DEPLOYMENT_SUCCESS_PREDICTOR model to predict device deployment success probability'
AS
$$
def predict_success(session, product_family_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("DEPLOYMENT_SUCCESS_PREDICTOR").default
    
    # Build query
    family_filter = f"AND p.product_family = '{product_family_filter}'" if product_family_filter else ""
    
    query = f"""
    SELECT
        p.product_family,
        a.agency_type,
        a.jurisdiction_type,
        o.axon_certified::BOOLEAN AS officer_certified,
        dd.competitive_replacement::BOOLEAN AS is_competitive_replacement,
        TRUE::BOOLEAN AS deployment_success
    FROM RAW.DEVICE_DEPLOYMENTS dd
    JOIN RAW.PRODUCT_CATALOG p ON dd.product_id = p.product_id
    JOIN RAW.AGENCIES a ON dd.agency_id = a.agency_id
    JOIN RAW.OFFICERS o ON dd.officer_id = o.officer_id
    WHERE dd.deployment_status = 'ACTIVE' {family_filter}
    LIMIT 20
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate success rate
    result = predictions.select("SUCCESS_PREDICTION").to_pandas()
    likely_successful = int(result['SUCCESS_PREDICTION'].sum())
    total_deployments = len(result)
    
    return json.dumps({
        "product_family_filter": product_family_filter or "ALL",
        "total_deployments_analyzed": total_deployments,
        "predicted_successful": likely_successful,
        "success_rate_pct": round(likely_successful / total_deployments * 100, 2) if total_deployments > 0 else 0
    })
$$;

-- ============================================================================
-- Display confirmation
-- ============================================================================

SELECT 'ML model wrapper functions created successfully' AS status;

-- ============================================================================
-- Test the wrapper procedures (uncomment after models are registered via notebook)
-- ============================================================================
/*
CALL PREDICT_EVIDENCE_UPLOAD_VOLUME(6);
CALL PREDICT_AGENCY_CHURN('MUNICIPAL_POLICE');
CALL PREDICT_DEPLOYMENT_SUCCESS('BODY_CAMERA');
*/

SELECT 'Execute notebook first to register models, then uncomment tests above' AS instruction;

