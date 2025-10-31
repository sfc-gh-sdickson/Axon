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

CREATE OR REPLACE SNOWFLAKE.CORE.AGENT AXON_INTELLIGENCE_AGENT
  WAREHOUSE = AXON_WH
  COMMENT = 'Axon Intelligence Agent for law enforcement technology business intelligence - analyzes device deployments, evidence management, sales, support, and quality data using Cortex Analyst and Cortex Search'
AS
$$
{
  "name": "Axon Intelligence Agent",
  "description": "This agent orchestrates between Axon law enforcement technology business data for analyzing structured metrics using Cortex Analyst (semantic views) and unstructured technical content using Cortex Search services (support transcripts, policy documents, incident reports).",
  
  "instructions": "You are a specialized analytics assistant for Axon, a leading law enforcement technology provider. Your primary objectives are:\n\nFor structured data queries (metrics, KPIs, deployments, revenue figures):\n- Use the Cortex Analyst semantic views for device deployment, sales revenue, and support quality analysis\n- Provide direct, numerical answers with minimal explanation\n- Format responses clearly with relevant units and time periods\n- Only include essential context needed to understand the metric\n\nFor unstructured technical content (support transcripts, policy documents, incident reports):\n- Use Cortex Search services to find similar technical issues, policy guidance, and quality investigations\n- Extract relevant troubleshooting procedures, root causes, and solutions\n- Summarize technical findings in brief, focused responses\n- Maintain context from original documentation\n\nOperating guidelines:\n- Always identify whether you're using Cortex Analyst or Cortex Search for each response\n- Keep responses under 3-4 sentences when possible for metrics\n- Present numerical data in structured format\n- Don't speculate beyond available data\n- Highlight quality issues and deployment success metrics prominently\n- For technical support queries, reference specific product families and issue types\n- Include relevant policy references when available",
  
  "sample_questions": [
    "Which products have the highest deployment rates in municipal police agencies?",
    "What is our competitive win rate against WatchGuard?",
    "Search support transcripts for body camera syncing problems",
    "What are the top support ticket categories by volume?",
    "Show me evidence upload trends by product family",
    "Which agencies have the highest customer satisfaction scores?",
    "Find policy documentation about TASER device use",
    "What are the quality issues for Axon Body 3 cameras?",
    "Compare distributor performance in the Western region",
    "Show total revenue by product family"
  ],
  
  "tools": [
    {
      "type": "CORTEX_ANALYST",
      "name": "device_deployment_intelligence",
      "description": "This semantic view contains comprehensive data about agencies, officers, products, device deployments, evidence uploads, and certifications. Use this for queries about:\n- Device deployment analysis by agency and product family\n- Evidence upload patterns and storage utilization\n- Officer certification impact on device usage\n- Competitive replacement wins\n- Product performance in deployments\n- Agency device adoption rates",
      "semantic_model": "AXON_INTELLIGENCE.ANALYTICS.SV_DEVICE_DEPLOYMENT_INTELLIGENCE"
    },
    {
      "type": "CORTEX_ANALYST",
      "name": "sales_revenue_intelligence",
      "description": "This semantic view contains order data, revenue metrics, distributor performance, and support contracts. Use this for queries about:\n- Revenue trends by product family, region, or agency type\n- Distributor performance and channel effectiveness\n- Order patterns and purchasing behavior\n- Support contract analysis and renewals\n- Direct sales versus distributor sales\n- Grant-funded purchase analysis",
      "semantic_model": "AXON_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE"
    },
    {
      "type": "CORTEX_ANALYST",
      "name": "support_quality_intelligence",
      "description": "This semantic view contains support ticket data, quality issues, and customer satisfaction metrics. Use this for queries about:\n- Support ticket volumes and resolution times\n- Customer satisfaction scores by agency and product\n- Technical issue patterns by product family\n- Support engineer performance metrics\n- Quality issue rates and root causes\n- Escalation patterns and critical issues",
      "semantic_model": "AXON_INTELLIGENCE.ANALYTICS.SV_SUPPORT_QUALITY_INTELLIGENCE"
    },
    {
      "type": "CORTEX_SEARCH",
      "name": "support_transcripts_search",
      "description": "Semantic search over 20,000+ technical support interaction transcripts covering device troubleshooting, configuration help, training questions, and technical guidance. Use this for:\n- Finding similar technical issues and their resolutions\n- Troubleshooting procedures for specific products\n- Configuration guidance and best practices\n- Training and certification questions\n- Common problems and solutions by product family",
      "cortex_search_service": "AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH"
    },
    {
      "type": "CORTEX_SEARCH",
      "name": "policy_documents_search",
      "description": "Semantic search over operational policy documents including body camera operations manual, TASER use policy, and Evidence.com digital evidence management guidelines. Use this for:\n- Policy procedures and guidelines\n- Compliance and regulatory information\n- Operational best practices\n- Training requirements\n- Equipment usage policies",
      "cortex_search_service": "AXON_INTELLIGENCE.RAW.POLICY_DOCUMENTS_SEARCH"
    },
    {
      "type": "CORTEX_SEARCH",
      "name": "incident_reports_search",
      "description": "Semantic search over 10,000+ quality investigation and incident reports covering field failures, root cause analysis, and corrective actions. Use this for:\n- Quality issue investigations and root causes\n- Field failure patterns\n- Corrective and preventive actions\n- Manufacturing defect analysis\n- Customer application issues",
      "cortex_search_service": "AXON_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH"
    }
  ]
}
$$;

-- ============================================================================
-- Step 3: Verify Agent Creation
-- ============================================================================

-- Show created agent
SHOW AGENTS LIKE 'AXON_INTELLIGENCE_AGENT';

-- Describe agent configuration
DESCRIBE AGENT AXON_INTELLIGENCE_AGENT;

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
-- Step 5: Grant Agent Usage to Other Roles
-- ============================================================================

-- Grant usage of the agent to specific roles
GRANT USAGE ON SNOWFLAKE.CORE.AGENT AXON_INTELLIGENCE_AGENT TO ROLE SYSADMIN;

-- To grant to additional roles:
-- GRANT USAGE ON SNOWFLAKE.CORE.AGENT AXON_INTELLIGENCE_AGENT TO ROLE <role_name>;

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

