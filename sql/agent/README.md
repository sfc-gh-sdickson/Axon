# Agent Creation SQL Script

This directory contains the SQL script for creating the Axon Snowflake Intelligence Agent.

## File

### 📄 `08_create_intelligence_agent.sql`

**Complete agent with all features including ML models**

- ✅ 3 Cortex Analyst tools (Semantic Views)
- ✅ 3 Cortex Search tools (Unstructured Data)
- ✅ 3 ML Model tools (Predictions)

**Prerequisites:**
- Complete ALL steps 01-07
- Upload and run the Jupyter notebook (`notebooks/axon_ml_models.ipynb`)
- Create ML wrapper procedures (step 07)
- Warehouse `AXON_WH` must exist

---

## Quick Start

```sql
-- Execute in order:
-- 1. Run steps 01-07 first
-- 2. Then run:
@sql/agent/08_create_intelligence_agent.sql
```

---

## What This Script Does

This script will:

1. **Grant Required Permissions**
   - Cortex Analyst user role
   - Semantic view privileges
   - Cortex Search service access
   - Warehouse usage

2. **Create the Agent Object**
   - Configure agent name and description
   - Set up instructions for AI behavior
   - Add sample questions
   - Register all tools (semantic views, search services, and optionally ML models)

3. **Verify Creation**
   - Show the created agent
   - Describe configuration

4. **Grant Usage**
   - Allow specified roles to use the agent

---

## After Creation

Once created, access your agent in Snowsight:

1. Navigate to **AI & ML** > **Agents**
2. Select **AXON_INTELLIGENCE_AGENT**
3. Click **Chat** to start asking questions

### Example Questions

**Structured Data (Cortex Analyst):**
- "What is the total evidence storage in TB?"
- "Which agencies have the highest deployment counts?"
- "Show me total revenue by product family"
- "What is the average customer satisfaction score?"

**Unstructured Data (Cortex Search):**
- "Search support transcripts for body camera WiFi issues"
- "Find policy documentation about evidence retention"
- "Search incident reports for TASER battery problems"

**Predictions (ML Models):**
- "Predict evidence upload volume for the next 6 months"
- "What is the churn risk for agency AGY00012345?"
- "Predict deployment success for officer OFC00098765 with product PRD00234567"

---

## Customization

### Change Role Names

The script grants permissions to `SYSADMIN` by default. To use a different role:

1. Search for `SYSADMIN` in the SQL file
2. Replace with your role name (e.g., `AXON_ADMIN`, `BUSINESS_ANALYST`)

### Update Agent Configuration

To modify the agent after creation:
- Edit the JSON configuration in the script
- Re-run the script (CREATE OR REPLACE updates the existing agent)

---

## Troubleshooting

If agent creation fails:

1. ✅ **Check Permissions**
   ```sql
   SHOW GRANTS TO ROLE <your_role>;
   ```

2. ✅ **Verify Semantic Views Exist**
   ```sql
   SHOW SEMANTIC VIEWS IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;
   ```

3. ✅ **Verify Cortex Search Services**
   ```sql
   SHOW CORTEX SEARCH SERVICES IN SCHEMA AXON_INTELLIGENCE.RAW;
   ```

4. ✅ **Check ML Procedures**
   ```sql
   SHOW PROCEDURES IN SCHEMA AXON_INTELLIGENCE.ANALYTICS;
   ```

5. ✅ **Verify Warehouse**
   ```sql
   SHOW WAREHOUSES LIKE 'AXON_WH';
   ```

---

## Next Steps

After creating your agent:

1. **Test with Sample Questions** - Use the provided examples
2. **Explore Capabilities** - Try different query types
3. **Monitor Performance** - Check query response times
4. **Expand Data** - Add more agencies, products, or time periods
5. **Customize Instructions** - Adjust agent behavior for your needs

---

**Need Help?** See `docs/AGENT_SETUP.md` for detailed setup instructions.

