-- ============================================================================
-- Axon Intelligence Agent - Create Snowflake Intelligence Agent (WITHOUT ML)
-- ============================================================================
-- Purpose: Create and configure Snowflake Intelligence Agent with:
--          - Cortex Analyst tools (Semantic Views)
--          - Cortex Search tools (Unstructured Data)
--          - NO ML Model tools (Simplified version)
-- Execution: Run this after completing steps 01-06 (skip step 07)
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
  response: 'You are a specialized analytics assistant for Axon law enforcement technology. For structured data queries use Cortex Analyst semantic views. For unstructured content use Cortex Search services. Keep responses concise and data-driven.'
  orchestration: 'For metrics and KPIs use Cortex Analyst tools. For support transcripts, policies, and incident reports use Cortex Search tools.'
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
    id_column: 'transcript_id'
    title_column: 'ticket_id'
  PolicyDocumentsSearch:
    search_service: 'AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH'
    max_results: 5
    id_column: 'policy_id'
    title_column: 'title'
  IncidentReportsSearch:
    search_service: 'AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH'
    max_results: 10
    id_column: 'incident_report_id'
    title_column: 'incident_type'
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
   - "Compare Body Camera deployments vs TASER deployments"

2. Unstructured queries (Cortex Search):
   - "Search support transcripts for body camera WiFi issues"
   - "Find policy documentation about evidence retention"
   - "Search incident reports for TASER battery problems"
   - "Show me body camera sync troubleshooting steps"
   - "What are the common quality issues for in-car camera systems?"
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

2. All semantic views exist:
   SHOW SEMANTIC VIEWS IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;

3. All Cortex Search services exist and are ready:
   SHOW CORTEX SEARCH SERVICES IN SCHEMA AXON_INTELLIGENCE.RAW;

4. Warehouse is running:
   SHOW WAREHOUSES LIKE 'AXON_WH';

5. Cortex Search services have completed indexing:
   - This can take 5-10 minutes after creation
   - Check status with: DESCRIBE CORTEX SEARCH SERVICE <service_name>;
*/

-- ============================================================================
-- NOTES
-- ============================================================================

/*
IMPORTANT NOTES:

1. This is the SIMPLIFIED version WITHOUT ML models
   - If you want to add ML predictive capabilities later, use:
     sql/agent/08_create_intelligence_agent.sql (full version with ML)

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

6. Adding ML Models Later:
   - If you want to add predictive analytics later:
     a) Follow docs/AGENT_SETUP.md "OPTIONAL: Add ML Models" section
     b) Then run the full version: sql/agent/08_create_intelligence_agent.sql
*/

