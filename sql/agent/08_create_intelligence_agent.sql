-- ============================================================================
-- Axon Intelligence Agent - Create Snowflake Intelligence Agent
-- ============================================================================
-- Purpose: Create and configure Snowflake Intelligence Agent with:
--          - Cortex Analyst tools (Semantic Views)
--          - Cortex Search tools (Unstructured Data)
--          - Optional ML Model tools (Predictions)
-- Execution: Run this after completing steps 01-07
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Step 1: Grant Required Permissions for Cortex Analyst
-- ============================================================================

-- Grant Cortex Analyst user role to your role
-- Replace <your_role> with your actual role name (e.g., SYSADMIN, custom role)
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE SYSADMIN;

-- Grant usage on database and schemas
GRANT USAGE ON DATABASE AXON_INTELLIGENCE TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA AXON_INTELLIGENCE.ANALYTICS TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA AXON_INTELLIGENCE.RAW TO ROLE SYSADMIN;

-- Grant privileges on semantic views for Cortex Analyst
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_DEVICE_DEPLOYMENT_INTELLIGENCE TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW AXON_INTELLIGENCE.ANALYTICS.SV_SUPPORT_QUALITY_INTELLIGENCE TO ROLE SYSADMIN;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE AXON_WH TO ROLE SYSADMIN;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH TO ROLE SYSADMIN;

-- Grant execute on ML model wrapper procedures (if you've created them)
GRANT USAGE ON PROCEDURE AXON_INTELLIGENCE.ANALYTICS.PREDICT_EVIDENCE_UPLOAD_VOLUME(INT) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE AXON_INTELLIGENCE.ANALYTICS.PREDICT_AGENCY_CHURN(VARCHAR) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE AXON_INTELLIGENCE.ANALYTICS.PREDICT_DEPLOYMENT_SUCCESS(VARCHAR, VARCHAR) TO ROLE SYSADMIN;

-- ============================================================================
-- Step 2: Create Snowflake Intelligence Agent
-- ============================================================================

CREATE OR REPLACE AGENT AXON_INTELLIGENCE_AGENT
  COMMENT = 'Axon Intelligence Agent for law enforcement technology business intelligence'
  PROFILE = '{"display_name": "Axon Intelligence Agent", "avatar": "shield-icon.png", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: claude-4-sonnet

orchestration:
  budget:
    seconds: 60
    tokens: 32000

instructions:
  response: 'You are a specialized analytics assistant for Axon law enforcement technology. For structured data queries use Cortex Analyst semantic views. For unstructured content use Cortex Search services. For predictions use ML model procedures. Keep responses concise and data-driven.'
  orchestration: 'For metrics and KPIs use Cortex Analyst tools. For support transcripts, policies, and incident reports use Cortex Search tools. For forecasting use ML function tools.'
  system: 'You help analyze law enforcement technology data including device deployments, evidence management, sales, support, and quality using structured and unstructured data sources.'
  sample_questions:
    - question: 'Analyze device deployments by status. Show me total deployments, breakdown by product family, deployment success rate, average evidence uploads per device, and which product families have highest utilization rates.'
      answer: 'I will use the Device Deployment Intelligence semantic view to analyze deployment patterns across product families and calculate utilization metrics.'
    - question: 'Analyze competitive replacement deployments. Show me total competitive wins by competitor, which product families are winning against which competitors, and our win rate by product type.'
      answer: 'I will query the Device Deployment Intelligence data to analyze competitive replacements and calculate win rates by competitor and product family.'
    - question: 'Analyze evidence upload patterns and storage utilization. Show me total evidence uploads by type, storage consumption trends, and agencies approaching storage limits.'
      answer: 'I will use the Device Deployment Intelligence view to analyze evidence upload patterns, storage trends, and identify agencies with high storage utilization.'
    - question: 'Analyze correlation between officer certifications and device utilization effectiveness. Show me evidence upload rates for certified versus non-certified officers and device sync compliance.'
      answer: 'I will analyze certification data with device deployment and evidence upload patterns to show the impact of officer training on device effectiveness.'
    - question: 'Analyze quality issues and their impact on agency retention. Show me total quality issues by severity, breakdown by product family, and correlation between quality issues and support satisfaction scores.'
      answer: 'I will use the Support Quality Intelligence view to analyze quality issue patterns and correlate them with customer satisfaction metrics.'
    - question: 'Predict evidence upload volume for the next 6 months based on current deployment trends and historical patterns.'
      answer: 'I will use the Evidence Volume Forecasting ML model to predict future upload volumes for capacity planning.'
    - question: 'Which agencies are at highest risk for churn? Show me agencies with declining order patterns, high support ticket ratios, or contract expirations.'
      answer: 'I will use the Agency Churn Prediction ML model to identify at-risk agencies and calculate churn probability scores.'
    - question: 'Predict deployment success probability for officer OFC00012345 with Axon Body 3 cameras. What factors influence the prediction?'
      answer: 'I will use the Deployment Success Prediction ML model to assess likelihood of successful device adoption based on officer training and historical patterns.'
    - question: 'Forecast storage needs for Evidence.com based on current evidence upload trends and planned device deployments for Q1 2026.'
      answer: 'I will use the Evidence Volume Forecasting model with deployment data to project storage capacity requirements.'
    - question: 'Identify agencies likely to reduce device usage or cancel contracts based on usage patterns, support interactions, and satisfaction metrics.'
      answer: 'I will use the Agency Churn Prediction model to analyze agencies showing warning signs of reduced engagement or potential contract non-renewal.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DeviceDeploymentAnalyst'
      description: 'Analyzes device deployments, evidence uploads, officer certifications, and competitive wins across agencies and products'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalyst'
      description: 'Analyzes orders, revenue, distributor performance, and support contracts'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalyst'
      description: 'Analyzes support tickets, quality issues, customer satisfaction, and engineer performance'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearch'
      description: 'Searches 20,000+ technical support transcripts for troubleshooting, configuration help, and training questions'
  - tool_spec:
      type: 'cortex_search'
      name: 'PolicyDocumentsSearch'
      description: 'Searches operational policies including body camera operations, TASER use, and evidence management guidelines'
  - tool_spec:
      type: 'cortex_search'
      name: 'IncidentReportsSearch'
      description: 'Searches 10,000+ quality investigation reports covering failures, root causes, and corrective actions'
  - tool_spec:
      type: 'generic'
      name: 'PredictEvidenceVolume'
      description: 'Predicts future evidence upload volume for capacity planning'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
            description: 'Number of months to forecast (1-12)'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictAgencyChurn'
      description: 'Predicts agency churn risk for retention assessment'
      input_schema:
        type: 'object'
        properties:
          agency_id:
            type: 'string'
            description: 'Agency ID to assess'
        required: ['agency_id']
  - tool_spec:
      type: 'generic'
      name: 'PredictDeploymentSuccess'
      description: 'Predicts deployment success probability for planning'
      input_schema:
        type: 'object'
        properties:
          officer_id:
            type: 'string'
            description: 'Officer ID'
          product_id:
            type: 'string'
            description: 'Product ID'
        required: ['officer_id', 'product_id']

tool_resources:
  DeviceDeploymentAnalyst:
    semantic_view: 'AXON_INTELLIGENCE.ANALYTICS.SV_DEVICE_DEPLOYMENT_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  SalesRevenueAnalyst:
    semantic_view: 'AXON_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  SupportQualityAnalyst:
    semantic_view: 'AXON_INTELLIGENCE.ANALYTICS.SV_SUPPORT_QUALITY_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  SupportTranscriptsSearch:
    search_service: 'AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH'
    max_results: 10
  PolicyDocumentsSearch:
    search_service: 'AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH'
    max_results: 5
  IncidentReportsSearch:
    search_service: 'AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH'
    max_results: 10
  PredictEvidenceVolume:
    type: 'procedure'
    identifier: 'AXON_INTELLIGENCE.ANALYTICS.PREDICT_EVIDENCE_UPLOAD_VOLUME'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  PredictAgencyChurn:
    type: 'procedure'
    identifier: 'AXON_INTELLIGENCE.ANALYTICS.PREDICT_AGENCY_CHURN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  PredictDeploymentSuccess:
    type: 'procedure'
    identifier: 'AXON_INTELLIGENCE.ANALYTICS.PREDICT_DEPLOYMENT_SUCCESS'
    execution_environment:
      type: 'warehouse'
      warehouse: 'AXON_WH'
      query_timeout: 60
  $$;

-- ============================================================================
-- Step 3: Verify Agent Creation
-- ============================================================================

-- Show created agent
SHOW AGENTS LIKE 'AXON_INTELLIGENCE_AGENT';

-- Describe agent configuration
DESCRIBE AGENT AXON_INTELLIGENCE_AGENT;

-- Grant usage
GRANT USAGE ON AGENT AXON_INTELLIGENCE_AGENT TO ROLE SYSADMIN;

-- ============================================================================
-- Step 4: Test Agent (Examples)
-- ============================================================================

-- Note: After agent creation, you can test it in Snowsight:
-- 1. Go to AI & ML > Agents
-- 2. Select AXON_INTELLIGENCE_AGENT
-- 3. Click "Chat" to interact with the agent

-- Example test queries:
/*
1. Structured queries (Cortex Analyst):
   - "What is the total evidence storage in TB?"
   - "Which agencies have the highest deployment counts?"
   - "Show me total revenue by product family"
   - "What is the average customer satisfaction score?"

2. Unstructured queries (Cortex Search):
   - "Search support transcripts for body camera WiFi issues"
   - "Find policy documentation about evidence retention"
   - "Search incident reports for TASER battery problems"

3. Predictive queries (ML Models):
   - "Predict evidence upload volume for the next 6 months"
   - "What is the churn risk for agency AGY00012345?"
   - "Predict deployment success for officer OFC00098765 with product PRD00234567"
*/

-- ============================================================================
-- Step 5: Grant Agent Usage to Other Roles (Already done in Step 3)
-- ============================================================================

-- To grant to additional roles:
-- GRANT USAGE ON AGENT AXON_INTELLIGENCE_AGENT TO ROLE <role_name>;

-- ============================================================================
-- Success Message
-- ============================================================================

SELECT 'Axon Intelligence Agent created successfully! Access it in Snowsight under AI & ML > Agents' AS status;

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

/*
If agent creation fails, verify:

1. Permissions are granted:
   - CORTEX_ANALYST_USER database role
   - REFERENCES and SELECT on all semantic views
   - USAGE on Cortex Search services
   - USAGE on ML procedures (if using)

2. All semantic views exist:
   SHOW SEMANTIC VIEWS IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;

3. All Cortex Search services exist and are ready:
   SHOW CORTEX SEARCH SERVICES IN SCHEMA AXON_INTELLIGENCE.RAW;

4. ML wrapper procedures exist (optional):
   SHOW PROCEDURES IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;

5. Warehouse is running:
   SHOW WAREHOUSES LIKE 'AXON_WH';
*/

-- ============================================================================
-- NOTES
-- ============================================================================

/*
IMPORTANT NOTES:

1. ML Model Tools (OPTIONAL):
   - The agent includes references to ML model procedures
   - If you haven't created the ML models (notebook + wrapper procedures),
     you can either:
     a) Comment out the ML function tools in the agent JSON above
     b) Or create them by following AGENT_SETUP.md "OPTIONAL: Add ML Models" section

2. Role Customization:
   - This script grants permissions to SYSADMIN role
   - Adjust role names throughout to match your organization's role structure

3. Agent Updates:
   - To modify the agent configuration, simply re-run this script
   - CREATE OR REPLACE will update the existing agent

4. Multi-Turn Conversations:
   - The agent maintains context across multiple questions in a chat session
   - You can ask follow-up questions that reference previous responses

5. Performance:
   - First query may take 10-20 seconds as semantic models initialize
   - Subsequent queries are typically faster (2-5 seconds)
   - Cortex Search queries are usually sub-second after index warm-up
*/

