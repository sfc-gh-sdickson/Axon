<img src="../Snowflake_Logo.svg" width="200">

# Axon Intelligence Agent - Complex Questions

These 10 complex questions demonstrate the intelligence agent's ability to analyze Axon's device deployments, evidence management, revenue, support operations, and quality metrics across multiple dimensions.

---

## 1. Device Deployment and Evidence Upload Analysis

**Question:** "Analyze device deployments by status. Show me total deployments, breakdown by product family (TASER, BODY_CAMERA, IN_CAR, SOFTWARE), deployment success rate, average evidence uploads per device, and which product families have highest utilization rates. Calculate potential storage needs for evidence uploads in the next quarter."

**Why Complex:**
- Multi-table joins (DEVICE_DEPLOYMENTS, AGENCIES, PRODUCT_CATALOG, EVIDENCE_UPLOADS)
- Status progression analysis
- Usage pattern calculations
- Multi-dimensional breakdown (product family, agency type)
- Storage forecasting estimation

**Data Sources:** DEVICE_DEPLOYMENTS, EVIDENCE_UPLOADS, AGENCIES, PRODUCT_CATALOG

---

## 2. Competitive Replacement Win Analysis

**Question:** "Analyze competitive replacement deployments. Show me total competitive wins by competitor (WatchGuard, Utility, Digital Ally, Panasonic, Motorola), which product families are winning against which competitors, estimated revenue value of competitive wins, and which agency types show highest competitive success. What is our win rate by product type?"

**Why Complex:**
- Competitive intelligence analysis
- Multi-dimensional segmentation
- Revenue impact calculation
- Win rate analysis by multiple factors
- Competitor-specific patterns

**Data Sources:** DEVICE_DEPLOYMENTS, PRODUCT_CATALOG, AGENCIES, ORDERS

---

## 3. Evidence Management and Storage Analytics

**Question:** "Analyze evidence upload patterns and storage utilization. Show me total evidence uploads by type (VIDEO, AUDIO, PHOTO), storage consumption trends over the last 12 months, agencies approaching storage limits, average time from recording to upload, and evidence retention compliance. Which agencies have the highest evidence-per-officer ratios?"

**Why Complex:**
- Multi-metric evidence analysis
- Storage trend analysis
- Compliance tracking
- Time-based patterns
- Utilization normalization per officer

**Data Sources:** EVIDENCE_UPLOADS, AGENCIES, OFFICERS, DEVICE_DEPLOYMENTS, SUPPORT_CONTRACTS

---

## 4. Officer Certification Impact on Device Utilization

**Question:** "Analyze correlation between officer certifications and device utilization effectiveness. Show me evidence upload rates for certified versus non-certified officers, breakdown by certification type, device sync compliance, and average incident documentation quality. Do certified officers have fewer support tickets?"

**Why Complex:**
- Correlation analysis
- Certification level segmentation
- Success rate calculations
- Quality analysis
- Multi-dimensional comparison

**Data Sources:** CERTIFICATIONS, OFFICERS, DEVICE_DEPLOYMENTS, EVIDENCE_UPLOADS, SUPPORT_TICKETS

---

## 5. Quality Issue Impact and Agency Satisfaction

**Question:** "Analyze quality issues and their impact on agency retention. Show me total quality issues by severity, breakdown by product family, affected agency count, issue resolution times, agencies with recurring quality problems, and correlation between quality issues and support satisfaction scores. Which product families have highest quality issue rates relative to deployments?"

**Why Complex:**
- Multi-metric quality analysis
- Impact assessment
- Correlation analysis
- Time-based trending
- Agency health scoring

**Data Sources:** QUALITY_ISSUES, PRODUCT_CATALOG, AGENCIES, SUPPORT_TICKETS, DEVICE_DEPLOYMENTS

---

## 6. Revenue Trend Analysis with Product Portfolio Performance

**Question:** "Analyze revenue trends over past 12 months by product type (CONDUCTED_ENERGY_WEAPON, BODY_WORN_CAMERA, VEHICLE_CAMERA_SYSTEM, EVIDENCE_MANAGEMENT, SOFTWARE, TRAINING). Show me month-over-month growth rates, seasonal patterns, average order values, unit volume trends, and which product types show strongest growth. Compare revenue by agency type (MUNICIPAL_POLICE, COUNTY_SHERIFF, STATE_POLICE)."

**Why Complex:**
- Time-series analysis (12 months)
- Growth rate calculations (MoM)
- Product portfolio analysis
- Seasonal pattern detection
- Customer segment comparison

**Data Sources:** ORDERS, PRODUCT_CATALOG, AGENCIES

---

## 7. Support Ticket Efficiency and Product Documentation Needs

**Question:** "Analyze support ticket patterns by product family. Show me average resolution times, ticket volumes by product type, correlation between quality issues and support tickets, products generating highest support load relative to deployment volume, and ticket escalation rates. Which products need improved training or documentation based on recurring ticket categories?"

**Why Complex:**
- Support efficiency analysis
- Product-level correlation
- Volume-normalized comparison
- Root cause identification
- Resource allocation insights

**Data Sources:** SUPPORT_TICKETS, PRODUCT_CATALOG, QUALITY_ISSUES, DEVICE_DEPLOYMENTS, POLICY_DOCUMENTS

---

## 8. Agency Health Score and Retention Risk Assessment

**Question:** "Calculate agency health scores and identify at-risk agencies. Show me agencies with declining order patterns (3+ month trend), agencies with high support ticket to deployment ratio, agencies with unresolved high-severity quality issues, support contract expirations in next 60 days, and agencies with no new deployments in 12+ months. Prioritize by lifetime value and calculate potential churn revenue impact."

**Why Complex:**
- Multi-factor health scoring
- Trend analysis (order patterns)
- Risk factor aggregation
- Time-based filtering (expirations, gaps)
- Revenue impact prioritization

**Data Sources:** AGENCIES, ORDERS, SUPPORT_TICKETS, QUALITY_ISSUES, SUPPORT_CONTRACTS, DEVICE_DEPLOYMENTS

---

## 9. Grant-Funded Purchase Analysis and Forecast

**Question:** "Analyze grant-funded equipment purchases. Show me total grant-funded revenue by product family, which states have highest grant utilization, average grant-funded order size versus non-grant orders, seasonal patterns in grant purchases, and agencies likely to pursue grant funding in the next fiscal year based on patterns. What is the grant funding conversion rate?"

**Why Complex:**
- Funding source analysis
- Geographic segmentation
- Comparative analysis (grant vs non-grant)
- Seasonal pattern identification
- Predictive analysis

**Data Sources:** ORDERS, AGENCIES, PRODUCT_CATALOG, AGENCY_CAMPAIGN_INTERACTIONS

---

## 10. Training Effectiveness and Device Adoption Success

**Question:** "Analyze the relationship between agency training participation and device adoption success. Show me agencies with high training attendance rates versus low attendance, correlation with evidence upload compliance, average time to full deployment adoption, support ticket frequency post-training, and training ROI by agency size. Which training types show highest impact on successful deployments?"

**Why Complex:**
- Training effectiveness analysis
- Multi-factor correlation
- Time-to-value analysis
- ROI calculation
- Segmentation by agency characteristics

**Data Sources:** CERTIFICATIONS, AGENCIES, DEVICE_DEPLOYMENTS, EVIDENCE_UPLOADS, SUPPORT_TICKETS, MARKETING_CAMPAIGNS

---

## Unstructured Data Search Questions (Cortex Search)

These questions test the agent's ability to search and retrieve insights from unstructured data using Cortex Search services.

### Question 11: Support Transcript Search - Syncing Issues

**Question:** "Search support transcripts for body camera syncing problems. What are the most common root causes? What troubleshooting steps do support engineers recommend? What are the successful resolution patterns?"

**Why Complex:**
- Semantic search over technical support text
- Root cause pattern extraction
- Procedure identification
- Success factor analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### Question 12: Policy Document Search - Recording Activation

**Question:** "What do our policy documents say about when officers must activate body cameras? What are the exceptions? Search policy documents for body camera activation requirements."

**Why Complex:**
- Policy interpretation from unstructured text
- Exception handling identification
- Compliance requirement extraction
- Multi-document synthesis

**Data Source:** POLICY_DOCUMENTS_SEARCH

---

### Question 13: Incident Report Search - Battery Performance

**Question:** "Find incident investigation reports about battery life issues. What were the common root causes? What recommendations were made to agencies? Search for battery performance problems."

**Why Complex:**
- Technical issue pattern recognition
- Root cause correlation
- Recommendation synthesis
- Quality trend analysis

**Data Source:** INCIDENT_REPORTS_SEARCH

---

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting agencies, officers, products, deployments, orders, support, quality
2. **Temporal analysis** - revenue trends, deployment patterns, evidence upload timing
3. **Segmentation & classification** - agency types, product families, officer roles
4. **Derived metrics** - success rates, growth calculations, health scores
5. **Competitive intelligence** - replacement analysis, win rates by competitor
6. **Performance benchmarking** - deployment success, product quality metrics
7. **Correlation analysis** - certifications vs. success, quality vs. support, order trends
8. **Opportunity identification** - upsell, training needs, grant funding
9. **Risk assessment** - agency churn, quality impact, contract expiration
10. **Quality metrics** - issue resolution, satisfaction ratings, defect rates
11. **Semantic search** - technical problem pattern recognition in unstructured data
12. **Policy extraction** - operational procedures, compliance requirements
13. **Root cause analysis** - quality investigations, support escalations

These questions reflect realistic business intelligence needs for Axon's law enforcement technology sales, support, and quality operations.

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** Microchip Intelligence Agent Template  
**Target Use Case:** Axon law enforcement technology business intelligence

