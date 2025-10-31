<img src="Snowflake_Logo.svg" width="200">

# Axon Intelligence Agent Solution

## About Axon

Axon Enterprise, Inc. is a leading provider of law enforcement technology solutions. Their comprehensive product portfolio includes TASER conducted energy weapons, body-worn cameras (Axon Body), in-car video systems (Axon Fleet), digital evidence management (Evidence.com), and real-time operations software serving law enforcement agencies worldwide.

### Key Product Lines

- **TASER Devices**: TASER 7, X2, X26P, TASER 10 - conducted energy weapons for less-lethal force
- **Body Cameras**: Axon Body 3, Body 4, Flex 2 - officer-worn video recording devices
- **In-Car Systems**: Axon Fleet 3, Fleet 4 - vehicle-mounted video systems
- **Evidence Management**: Evidence.com - cloud-based digital evidence platform
- **Software Solutions**: Axon Respond, Axon Records - real-time operations and records management
- **Training Systems**: VR Training Suite - virtual reality de-escalation training

### Market Position

- Leading provider of body-worn cameras and conducted energy weapons for law enforcement
- Strong presence in municipal police, county sheriff, and state police markets
- Comprehensive cloud ecosystem for evidence management and operations
- Industry-leading training and certification programs

## Project Overview

This Snowflake Intelligence solution demonstrates how Axon can leverage AI agents to analyze:

- **Device Deployment Intelligence**: Officer device assignments, utilization patterns, deployment success
- **Evidence Management**: Upload patterns, storage utilization, retention compliance
- **Sales Analytics**: Revenue trends, grant-funded purchases, product performance
- **Agency Health**: Retention risk, satisfaction scores, contract renewals
- **Support Operations**: Ticket resolution, technical issue patterns, training effectiveness
- **Quality Intelligence**: Device issues, investigation reports, corrective actions
- **Officer Certifications**: Training effectiveness, certification impact on device utilization
- **Unstructured Data Search**: Semantic search over support transcripts, policy documents, and incident reports using Cortex Search

## Database Schema

The solution includes:

1. **RAW Schema**: Core business tables
   - AGENCIES: Law enforcement agencies (customers)
   - OFFICERS: Officers at agencies using Axon devices
   - PRODUCT_CATALOG: Complete Axon product SKUs and specifications
   - DISTRIBUTORS: Authorized distribution partners
   - DEVICE_DEPLOYMENTS: Device assignments to officers
   - EVIDENCE_UPLOADS: Evidence files uploaded from devices
   - ORDERS: Product orders through distributors and direct
   - SUPPORT_CONTRACTS: Evidence.com subscriptions and support agreements
   - CERTIFICATIONS: Officer certifications (TASER, Body Camera, etc.)
   - CERTIFICATION_VERIFICATIONS: Verification records
   - SUPPORT_TICKETS: Customer support cases
   - SUPPORT_ENGINEERS: Axon technical support staff
   - QUALITY_ISSUES: Device failures, defect reports
   - MARKETING_CAMPAIGNS: Product launches, training programs
   - AGENCY_CAMPAIGN_INTERACTIONS: Marketing engagement tracking
   - SUPPORT_TRANSCRIPTS: Unstructured technical support interactions (20K transcripts)
   - POLICY_DOCUMENTS: Operational policies and guidelines (3 comprehensive documents)
   - INCIDENT_REPORTS: Detailed quality investigation documentation (10K reports)

2. **ANALYTICS Schema**: Curated views and semantic models
   - Agency 360 views
   - Officer analytics
   - Device deployment metrics
   - Evidence upload tracking
   - Product performance analysis
   - Support efficiency metrics
   - Quality issue analysis
   - Certification impact views
   - Semantic views for AI agents

3. **Cortex Search Services**: Semantic search over unstructured data
   - SUPPORT_TRANSCRIPTS_SEARCH: Search 20K technical support interactions
   - POLICY_DOCUMENTS_SEARCH: Search operational policies and procedures
   - INCIDENT_REPORTS_SEARCH: Search 10K quality investigations

## Files

### Core Files
- `README.md`: This comprehensive solution documentation
- `docs/AGENT_SETUP.md`: Complete agent configuration instructions
- `docs/questions.md`: 13 complex test questions

### SQL Files
- `sql/setup/01_database_and_schema.sql`: Database and schema creation
- `sql/setup/02_create_tables.sql`: Table definitions with proper constraints
- `sql/data/03_generate_synthetic_data.sql`: Realistic law enforcement sample data
- `sql/views/04_create_views.sql`: Analytical views
- `sql/views/05_create_semantic_views.sql`: Semantic views for AI agents (verified syntax)
- `sql/search/06_create_cortex_search.sql`: Unstructured data tables and Cortex Search services
- `sql/ml/07_create_model_wrapper_functions.sql`: ML model wrapper procedures

### ML Models (Optional)
- `notebooks/axon_ml_models.ipynb`: Snowflake Notebook for training ML models

## Setup Instructions

1. Execute SQL files in order (01 through 06)
   - 01: Database and schema setup
   - 02: Create tables
   - 03: Generate synthetic data (10-20 min)
   - 04: Create analytical views
   - 05: Create semantic views
   - 06: Create Cortex Search services (5-10 min)
2. Follow docs/AGENT_SETUP.md for agent configuration
3. Test with questions from docs/questions.md

## Data Model Highlights

### Structured Data
- Realistic law enforcement business scenarios
- 20K agencies across municipal, county, and state segments
- 200K officers with Axon certifications
- 20+ product SKUs across TASER, Body Camera, In-Car, Software, and Training families
- 400K device deployments with usage tracking
- 800K evidence uploads with storage metrics
- 600K orders through distributors and direct sales channels
- 75K support tickets covering technical support, training, and billing
- 20K quality issues with investigation tracking
- 50K officer certifications (TASER, Body Camera, Evidence Management)
- 10 major distributors

### Unstructured Data
- 20,000 technical support transcripts with realistic troubleshooting scenarios
- 3 comprehensive policy documents (Body Camera Operations, TASER Use Policy, Evidence Management)
- 10,000 quality investigation reports with root cause analysis
- Semantic search powered by Snowflake Cortex Search
- RAG (Retrieval Augmented Generation) ready for AI agents

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured technical content  
✅ **Semantic Search**: Find similar technical issues and solutions by meaning, not keywords  
✅ **RAG-Ready**: Agent can retrieve context from support transcripts and policy documents  
✅ **Production-Ready Syntax**: All SQL verified against Snowflake documentation  
✅ **Comprehensive Demo**: 600K+ orders, 400K deployments, 20K support transcripts  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified against official Snowflake documentation  
✅ **No Duplicate Synonyms**: All semantic view synonyms globally unique across all three views

## Complex Questions Examples

The agent can answer sophisticated questions like:

### Structured Data Analysis (Semantic Views)
1. **Device Deployment Analysis**: Utilization rates by product family and agency type
2. **Competitive Intelligence**: Replacement wins by competitor and revenue impact
3. **Evidence Management**: Upload patterns, storage utilization, compliance tracking
4. **Certification Impact**: Correlation between officer training and device utilization
5. **Quality Metrics**: Issue rates by product family, resolution times, agency impact
6. **Revenue Trends**: Month-over-month growth, seasonal patterns, agency segmentation
7. **Agency Health**: Retention risk scoring based on order trends, support, quality
8. **Grant-Funded Analysis**: Purchase patterns, state utilization, conversion rates
9. **Support Efficiency**: Resolution times, escalation rates, documentation needs
10. **Training Effectiveness**: ROI analysis, adoption success, certification correlation

### Unstructured Data Search (Cortex Search)
11. **Support Troubleshooting**: Common syncing issues, resolution procedures, successful fixes
12. **Policy Guidance**: Body camera activation requirements, TASER use guidelines
13. **Quality Investigations**: Battery performance issues, root causes, corrective actions

## Semantic Views

The solution includes three verified semantic views:

1. **SV_DEVICE_DEPLOYMENT_INTELLIGENCE**: Comprehensive view of agencies, officers, products, deployments, evidence uploads, and certifications
2. **SV_SALES_REVENUE_INTELLIGENCE**: Revenue, orders, distributors, products, and support contracts
3. **SV_SUPPORT_QUALITY_INTELLIGENCE**: Support tickets, quality issues, engineers, and satisfaction metrics

All semantic views follow the verified syntax structure:
- TABLES clause with PRIMARY KEY definitions
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)
- **NO DUPLICATE SYNONYMS** - All synonyms globally unique

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

1. **SUPPORT_TRANSCRIPTS_SEARCH**: Search 20,000 technical support interactions
   - Find similar technical issues by description
   - Retrieve troubleshooting procedures from successful resolutions
   - Analyze support patterns and best practices
   - Searchable attributes: agency_id, support_engineer_id, interaction_type, product_family, issue_category

2. **POLICY_DOCUMENTS_SEARCH**: Search operational policies and guidelines
   - Retrieve policy requirements and procedures
   - Find compliance guidelines and best practices
   - Access operational specifications and recommendations
   - Searchable attributes: product_family, document_category, title, document_number

3. **INCIDENT_REPORTS_SEARCH**: Search 10,000 quality investigations
   - Find similar quality issues and root causes
   - Identify effective corrective actions
   - Retrieve investigation procedures and learnings
   - Searchable attributes: agency_id, product_id, incident_type, incident_status

All Cortex Search services use verified syntax:
- ON clause specifying search column
- ATTRIBUTES clause for filterable columns
- WAREHOUSE assignment
- TARGET_LAG for refresh frequency
- AS clause with source query

## Syntax Verification

All SQL syntax has been verified against official Snowflake documentation:

- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Cortex Search Overview**: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview

Key verification points:
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns verified to exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns
- ✅ All column references verified against table definitions
- ✅ No duplicate synonyms across all three semantic views

## Getting Started

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse

### Quick Start
```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (10-20 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (5-10 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent
Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources (Cortex Analyst)
3. Configure Cortex Search services
4. Set up system prompts and instructions
5. Test with sample questions

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA AXON_INTELLIGENCE.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'AXON_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "body camera syncing problems", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "Which products have the highest deployment rates in municipal police agencies?"
2. "What is our competitive win rate against WatchGuard?"
3. "Show me agencies at risk of churn based on declining order patterns."
4. "Search support transcripts for TASER battery issues and recommended solutions."

## Data Volumes

- **Agencies**: 20,000
- **Officers**: 200,000
- **Product Catalog**: 20+ SKUs with detailed specifications
- **Distributors**: 10 major partners
- **Device Deployments**: 400,000
- **Evidence Uploads**: 800,000
- **Orders**: 600,000
- **Support Contracts**: 14,000
- **Certifications**: 50,000
- **Support Tickets**: 75,000
- **Quality Issues**: 20,000
- **Support Transcripts**: 20,000 (unstructured)
- **Policy Documents**: 3 comprehensive guides
- **Incident Reports**: 10,000 (unstructured)

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Refer to Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax
  - Verified Cortex Search syntax
  - 20K agencies, 200K officers, 400K deployments, 600K orders
  - 20K support transcripts with semantic search
  - 3 policy documents with operational guidance
  - 10K quality investigation reports
  - 13 complex test questions (10 structured + 3 unstructured)
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: Microchip Intelligence Demo  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Axon law enforcement technology business intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅  
**NO DUPLICATE SYNONYMS - ALL GLOBALLY UNIQUE** ✅

