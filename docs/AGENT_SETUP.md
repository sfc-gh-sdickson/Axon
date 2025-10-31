<img src="../Snowflake_Logo.svg" width="200">

# Axon Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Axon's law enforcement technology business intelligence solution covering device deployments, evidence management, sales revenue, support operations, and quality analytics.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: AGENCIES, OFFICERS, PRODUCT_CATALOG, DISTRIBUTORS,
--         DEVICE_DEPLOYMENTS, EVIDENCE_UPLOADS, ORDERS, SUPPORT_CONTRACTS,
--         CERTIFICATIONS, SUPPORT_TICKETS, QUALITY_ISSUES, etc.
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 20,000 agencies
--   - 200,000 officers
--   - 400,000 device deployments
--   - 800,000 evidence uploads
--   - 600,000 orders
--   - 50,000 certifications
--   - 75,000 support tickets
--   - 20,000 quality issues
-- Execution time: 10-20 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_AGENCY_360
--   - V_OFFICER_ANALYTICS
--   - V_DEVICE_DEPLOYMENT_ANALYTICS
--   - V_EVIDENCE_UPLOAD_ANALYTICS
--   - V_PRODUCT_PERFORMANCE
--   - V_SUPPORT_TICKET_ANALYTICS
--   - V_QUALITY_ISSUE_ANALYTICS
--   - V_REVENUE_ANALYTICS
--   - V_DISTRIBUTOR_PERFORMANCE
--   - V_CERTIFICATION_ANALYTICS
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_DEVICE_DEPLOYMENT_INTELLIGENCE
--   - SV_SALES_REVENUE_INTELLIGENCE
--   - SV_SUPPORT_QUALITY_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - SUPPORT_TRANSCRIPTS (20,000 technical support interactions)
--   - POLICY_DOCUMENTS (3 comprehensive operational policies)
--   - INCIDENT_REPORTS (10,000 investigation reports)
-- Creates Cortex Search services for semantic search:
--   - SUPPORT_TRANSCRIPTS_SEARCH
--   - POLICY_DOCUMENTS_SEARCH
--   - INCIDENT_REPORTS_SEARCH
-- Execution time: 5-10 minutes (data generation + index building)
```

---

## Step 2: Grant Cortex Analyst Permissions

Before creating the agent, ensure proper permissions are configured:

### 2.1 Grant Database Role for Cortex Analyst

```sql
USE ROLE ACCOUNTADMIN;

-- Grant Cortex Analyst user role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE <your_role>;

-- Grant usage on database and schemas
GRANT USAGE ON DATABASE AXON_INTELLIGENCE TO ROLE <your_role>;
GRANT USAGE ON SCHEMA AXON_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON SCHEMA AXON_INTELLIGENCE.RAW TO ROLE <your_role>;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_DEVICE_DEPLOYMENT_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_SUPPORT_QUALITY_INTELLIGENCE TO ROLE <your_role>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE AXON_WH TO ROLE <your_role>;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH TO ROLE <your_role>;
```

---

## Step 3: Create Snowflake Intelligence Agent

### Step 3.1: Create the Agent

1. In Snowsight, click on **AI & ML** > **Agents**
2. Click on **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `AXON_INTELLIGENCE_AGENT`
   - **Display Name**: `Axon Intelligence Agent`
5. Click **Create**

### Step 3.2: Add Description and Instructions

1. Click on **AXON_INTELLIGENCE_AGENT** to open the agent
2. Click **Edit** on the top right corner
3. In the **Description** section, add:
   ```
   This agent orchestrates between Axon law enforcement technology business data for analyzing 
   structured metrics using Cortex Analyst (semantic views) and unstructured technical 
   content using Cortex Search services (support transcripts, policy documents, incident reports).
   ```

### Step 3.3: Configure Response Instructions

1. Click on **Instructions** in the left pane
2. Enter the following **Response Instructions**:
   ```
   You are a specialized analytics assistant for Axon, a leading law enforcement technology 
   provider. Your primary objectives are:

   For structured data queries (metrics, KPIs, deployments, revenue figures):
   - Use the Cortex Analyst semantic views for device deployment, sales revenue, and support 
     quality analysis
   - Provide direct, numerical answers with minimal explanation
   - Format responses clearly with relevant units and time periods
   - Only include essential context needed to understand the metric

   For unstructured technical content (support transcripts, policy documents, incident reports):
   - Use Cortex Search services to find similar technical issues, policy guidance, and 
     quality investigations
   - Extract relevant troubleshooting procedures, root causes, and solutions
   - Summarize technical findings in brief, focused responses
   - Maintain context from original documentation

   Operating guidelines:
   - Always identify whether you're using Cortex Analyst or Cortex Search for each response
   - Keep responses under 3-4 sentences when possible for metrics
   - Present numerical data in structured format
   - Don't speculate beyond available data
   - Highlight quality issues and deployment success metrics prominently
   - For technical support queries, reference specific product families and issue types
   - Include relevant policy references when available
   ```

3. **Add Sample Questions** (click "Add a question" for each):
   - "Which products have the highest deployment rates in municipal police agencies?"
   - "What is our competitive win rate against WatchGuard?"
   - "Search support transcripts for body camera syncing problems"

---

### Step 3.4: Add Cortex Analyst Tools (Semantic Views)

1. Click on **Tools** in the left pane
2. Find **Cortex Analyst** and click **+ Add**

**Add Semantic View 1: Device Deployment & Evidence Intelligence**

1. **Select semantic view**: `AXON_INTELLIGENCE.ANALYTICS.SV_DEVICE_DEPLOYMENT_INTELLIGENCE`
2. **Add a description**:
   ```
   This semantic view contains comprehensive data about agencies, officers, products, 
   device deployments, evidence uploads, and certifications. Use this for queries about:
   - Device deployment analysis by agency and product family
   - Evidence upload patterns and storage utilization
   - Officer certification impact on device usage
   - Competitive replacement wins
   - Product performance in deployments
   - Agency device adoption rates
   ```
3. **Save**

**Add Semantic View 2: Sales & Revenue Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `AXON_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains order data, revenue metrics, distributor performance, and support 
   contracts. Use this for queries about:
   - Revenue trends by product family, region, or agency type
   - Distributor performance and channel effectiveness
   - Order patterns and purchasing behavior
   - Support contract analysis and renewals
   - Direct sales versus distributor sales
   - Grant-funded purchase analysis
   ```
4. **Save**

**Add Semantic View 3: Support & Quality Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `AXON_INTELLIGENCE.ANALYTICS.SV_SUPPORT_QUALITY_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains support ticket data, quality issues, and customer 
   satisfaction metrics. Use this for queries about:
   - Support ticket volumes and resolution times
   - Customer satisfaction scores by agency and product
   - Technical issue patterns by product family
   - Support engineer performance metrics
   - Quality issue rates and root causes
   - Issue resolution effectiveness
   ```
4. **Save**

---

### Step 3.5: Add Cortex Search Tools (Unstructured Data)

1. While still in **Tools**, find **Cortex Search** and click **+ Add**

**Add Cortex Search 1: Support Transcripts**

1. **Select Cortex Search Service**: `AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH`
2. **Add a description**:
   ```
   Search 20,000 technical support interaction transcripts for troubleshooting procedures, 
   common issues, and successful resolutions. Use for queries about:
   - Body camera syncing and recording issues
   - TASER device malfunctions and battery problems
   - Evidence.com access and upload issues
   - Fleet in-car system installation and configuration
   - Device firmware and software troubleshooting
   - Specific error messages and diagnostic procedures
   ```
3. **Configure search settings**:
   - **ID Column**: `transcript_id`
   - **Title Column**: `ticket_id`
   - **Max Results**: 10
4. **Save**

**Add Cortex Search 2: Policy Documents**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH`
3. **Add a description**:
   ```
   Search operational policies and guidelines for procedures, requirements, and best practices. 
   Use for queries about:
   - Body camera activation requirements and procedures
   - TASER use-of-force policies and deployment guidelines
   - Evidence.com retention policies and compliance
   - Recording categories and privacy considerations
   - Training requirements and certification standards
   - Equipment maintenance and care procedures
   ```
4. **Configure search settings**:
   - **ID Column**: `policy_id`
   - **Title Column**: `title`
   - **Max Results**: 5
5. **Save**

**Add Cortex Search 3: Incident Reports**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH`
3. **Add a description**:
   ```
   Search quality investigation reports for root cause analysis, corrective actions, and 
   lessons learned. Use for queries about:
   - Device malfunction investigations
   - Battery performance issues
   - Recording failure root causes
   - Installation and configuration problems
   - Firmware corruption incidents
   - Manufacturing defect analysis
   ```
4. **Configure search settings**:
   - **ID Column**: `incident_report_id`
   - **Title Column**: `quality_issue_id`
   - **Max Results**: 10
5. **Save**

---

## Step 4: Test the Agent

### Step 4.1: Test Structured Data Queries (Cortex Analyst)

1. In the agent interface, click **Chat**
2. Try these test questions:

**Test 1: Device Deployment Analysis**
```
Which product families have the highest deployment rates in municipal police agencies?
```
Expected: Uses SV_DEVICE_DEPLOYMENT_INTELLIGENCE, returns counts by product_family filtered by agency_type = 'MUNICIPAL_POLICE'

**Test 2: Competitive Intelligence**
```
Show me our competitive replacement wins. What is our win rate against WatchGuard?
```
Expected: Uses SV_DEVICE_DEPLOYMENT_INTELLIGENCE, filters by competitive_replacement = TRUE

**Test 3: Revenue Trends**
```
Analyze revenue trends over the past 12 months by product type
```
Expected: Uses SV_SALES_REVENUE_INTELLIGENCE, groups by product_type with time-series

**Test 4: Support Efficiency**
```
What is the average support ticket resolution time by ticket category?
```
Expected: Uses SV_SUPPORT_QUALITY_INTELLIGENCE, calculates averages by ticket_category

### Step 4.2: Test Unstructured Data Queries (Cortex Search)

**Test 5: Technical Support Search**
```
Search support transcripts for body camera syncing problems and common solutions
```
Expected: Uses SUPPORT_TRANSCRIPTS_SEARCH, returns relevant troubleshooting transcripts

**Test 6: Policy Document Search**
```
What do our policy documents say about when officers must activate body cameras?
```
Expected: Uses POLICY_DOCUMENTS_SEARCH, retrieves body camera activation requirements

**Test 7: Quality Investigation Search**
```
Find incident reports about TASER battery issues. What were the root causes?
```
Expected: Uses INCIDENT_REPORTS_SEARCH, returns relevant quality reports

---

## Verification Steps

### Verify Semantic Views
```sql
SHOW SEMANTIC VIEWS IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;
-- Should show 3 semantic views
```

### Verify Cortex Search Services
```sql
SHOW CORTEX SEARCH SERVICES IN SCHEMA AXON_INTELLIGENCE.RAW;
-- Should show 3 search services
```

### Test Cortex Search Directly
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "body camera syncing problems", "limit":5}'
  )
)['results'] as results;
```

---

## Troubleshooting

### Agent Not Finding Data
1. Verify permissions on semantic views and search services
2. Check that warehouse is assigned and running
3. Ensure semantic views have data (check row counts)

### Cortex Search Not Working
1. Verify change tracking is enabled on tables
2. Check that search services are in READY state
3. Allow 5-10 minutes for initial indexing after creation

### Slow Response Times
1. Increase warehouse size for data generation
2. Verify Cortex Search indexes have built
3. Check query complexity in Cortex Analyst

---

## Next Steps

1. **Customize Questions**: Add agency-specific questions to the agent
2. **Integrate with Applications**: Use agent via API for custom applications
3. **Monitor Usage**: Track which queries are most common
4. **Expand Data**: Add more agencies, products, or time periods
5. **Enhance Search**: Add more unstructured content (training materials, case studies)

---

**Version:** 1.0  
**Created:** October 2025  
**Verified:** All syntax verified against Snowflake documentation

**Setup Time Estimate**: 30-45 minutes (including data generation)

---

## OPTIONAL: Add ML Models (Evidence Forecasting, Churn, Deployment Success)

This section is optional but adds powerful ML prediction capabilities to your agent.

### Prerequisites for ML Models

- Core setup (Steps 1-3) completed
- Files 01-06 executed successfully
- Agent configured with semantic views and Cortex Search

### ML Setup Overview

1. Upload and run Snowflake Notebook to train models
2. Execute SQL wrapper functions file
3. Add 3 ML procedures to agent as tools

**Time:** 20-30 minutes

---

### ML Step 1: Upload Notebook to Snowflake (5 min)

1. In Snowsight, click **Projects** → **Notebooks**
2. Click **+ Notebook** → **Import .ipynb file**
3. Upload: `notebooks/axon_ml_models.ipynb`
4. Name it: `Axon ML Models`
5. Configure:
   - **Database:** AXON_INTELLIGENCE
   - **Schema:** ANALYTICS
   - **Warehouse:** AXON_WH
6. Click **Create**

### ML Step 2: Add Required Packages

1. In the notebook, click **Packages** dropdown (upper right)
2. Search and add each package:
   - `snowflake-ml-python`
   - `scikit-learn`
   - `xgboost`
   - `matplotlib`
3. Click **Start** to activate the notebook

### ML Step 3: Run Notebook to Train Models (10 min)

1. Click **Run All** (or run each cell sequentially)
2. Wait for training to complete (2-3 minutes per model)
3. Verify output shows:
   - "✅ Evidence upload volume forecasting model trained"
   - "✅ Agency churn classification model trained"
   - "✅ Deployment success prediction model trained"
   - "✅ Evidence volume model registered to Model Registry as EVIDENCE_VOLUME_PREDICTOR"
   - "✅ Churn model registered to Model Registry as AGENCY_CHURN_PREDICTOR"
   - "✅ Deployment model registered to Model Registry as DEPLOYMENT_SUCCESS_PREDICTOR"

**Models created:**
- EVIDENCE_VOLUME_PREDICTOR (Linear Regression for evidence upload forecasting)
- AGENCY_CHURN_PREDICTOR (Random Forest for churn classification)
- DEPLOYMENT_SUCCESS_PREDICTOR (Logistic Regression for deployment success prediction)

### ML Step 4: Create Wrapper Procedures (2 min)

Execute the SQL wrapper functions:

```sql
@sql/ml/07_create_model_wrapper_functions.sql
```

This creates 3 stored procedures that wrap the Model Registry models so the agent can call them.

**Procedures created:**
- PREDICT_EVIDENCE_UPLOAD_VOLUME(months_ahead)
- PREDICT_AGENCY_CHURN(agency_type_filter)
- PREDICT_DEPLOYMENT_SUCCESS(product_family_filter)

### ML Step 5: Add ML Procedures to Agent (10 min)

#### Navigate to Agent Tools

1. In your agent editor (AXON_INTELLIGENCE_AGENT)
2. Click **Tools** (left sidebar)

#### Add Procedure 1: PREDICT_EVIDENCE_UPLOAD_VOLUME

1. Click **+ Add** button (top right)
2. Click **Procedure** tile (NOT Function)
3. In dropdown, select: `AXON_INTELLIGENCE.ANALYTICS.PREDICT_EVIDENCE_UPLOAD_VOLUME`
4. Paste in Description:
   ```
   Evidence Upload Volume Forecasting Procedure
   
   Predicts future evidence upload volume using the EVIDENCE_VOLUME_PREDICTOR model from Model Registry.
   The model uses Linear Regression trained on historical evidence upload patterns.
   
   Use when users ask to:
   - Forecast evidence uploads
   - Predict future storage needs
   - Project evidence volume
   - Estimate upcoming evidence capacity
   
   Parameter:
   - months_ahead: Number of months to forecast (1-12 recommended)
   
   Returns: JSON with predicted upload volume
   
   Example: "Forecast evidence upload volume for the next 6 months"
   ```
5. Click **Add**

#### Add Procedure 2: PREDICT_AGENCY_CHURN

1. Click **+ Add** → **Procedure**
2. Select: `AXON_INTELLIGENCE.ANALYTICS.PREDICT_AGENCY_CHURN`
3. Description:
   ```
   Agency Churn Prediction Procedure
   
   Predicts which agencies are at risk of churning using the AGENCY_CHURN_PREDICTOR model
   from Model Registry. Uses Random Forest classifier trained on behavior patterns.
   
   Use when users ask to:
   - Identify at-risk agencies
   - Predict agency churn
   - Find agencies likely to cancel
   - Calculate churn risk
   
   Parameter:
   - agency_type_filter: Filter by type (MUNICIPAL_POLICE, COUNTY_SHERIFF, STATE_POLICE)
     or empty string for all agencies
   
   Returns: JSON with churn count and churn rate percentage
   
   Example: "Which municipal police agencies are predicted to churn?"
   ```
4. Click **Add**

#### Add Procedure 3: PREDICT_DEPLOYMENT_SUCCESS

1. Click **+ Add** → **Procedure**
2. Select: `AXON_INTELLIGENCE.ANALYTICS.PREDICT_DEPLOYMENT_SUCCESS`
3. Description:
   ```
   Device Deployment Success Prediction Procedure
   
   Predicts which device deployments are likely to be successful using the
   DEPLOYMENT_SUCCESS_PREDICTOR model from Model Registry. Uses Logistic Regression.
   
   Use when users ask to:
   - Predict deployment success probability
   - Identify high-probability deployments
   - Find deployments likely to succeed
   - Prioritize deployment resources
   
   Parameter:
   - product_family_filter: Filter by family (TASER, BODY_CAMERA, IN_CAR, etc.)
     or empty string for all families
   
   Returns: JSON with success count and success rate percentage
   
   Example: "Which body camera deployments will likely be successful?"
   ```
4. Click **Add**

#### Verify ML Procedures Added

Your agent's **Tools** section should now show:
- **Cortex Analyst (3):** Semantic views
- **Cortex Search (3):** Search services
- **Procedures (3):** ML prediction procedures

**Total: 9 tools**

### ML Step 6: Test ML Capabilities

Ask your agent:

```
"Forecast evidence upload volume for the next 6 months"
"Which agencies are predicted to churn?"
"Show me device deployments with high success probability for body cameras"
```

The agent will call the appropriate ML procedures and return predictions!

---

## Complete Setup Summary

### Core Setup (Required - 45 minutes):
1. Execute SQL files 01-06
2. Configure agent with semantic views and Cortex Search

### ML Setup (Optional - 30 minutes):
1. Upload and run ML notebook
2. Execute wrapper functions SQL
3. Add 3 procedures to agent

**Total with ML: ~75 minutes**

