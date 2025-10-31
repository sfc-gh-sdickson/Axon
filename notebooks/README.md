# Axon ML Models - Snowflake Notebook

This directory contains the Jupyter notebook for training and registering ML models to the Snowflake Model Registry.

## Files

- **`axon_ml_models.ipynb`** - Main notebook with 3 ML models:
  - Evidence Upload Volume Forecasting (Linear Regression)
  - Agency Churn Prediction (Random Forest)
  - Deployment Success Prediction (Logistic Regression)

- **`environment.yml`** - Conda environment specification with required packages

---

## Setup Instructions

### Option 1: Using environment.yml (Recommended)

1. **Upload to Snowflake:**
   - In Snowsight → Projects → Notebooks
   - Click **+ Notebook** → **Import .ipynb file**
   - Upload `axon_ml_models.ipynb`

2. **Configure Environment:**
   - In the notebook, click **Packages** (top right)
   - Click **Upload environment file**
   - Upload `environment.yml`
   - Click **Apply**

3. **Set Database Context:**
   - Database: `AXON_INTELLIGENCE`
   - Schema: `ANALYTICS`
   - Warehouse: `AXON_WH`

4. **Run the Notebook:**
   - Click **Run All** or execute cells sequentially

---

### Option 2: Manual Package Selection

If you prefer not to use environment.yml:

1. **Upload Notebook** (same as above)

2. **Add Packages Manually:**
   - Click **Packages** (top right)
   - Search and add each package:
     - `snowflake-ml-python`
     - `scikit-learn`
     - `xgboost`
     - `matplotlib`

3. **Continue with steps 3-4 above**

---

## Required Packages

The notebook requires these packages (all available in Snowflake/Anaconda):

| Package | Version | Purpose |
|---------|---------|---------|
| `snowflake-ml-python` | ≥1.5.0 | Snowflake ML modeling and Model Registry |
| `scikit-learn` | ≥1.3.0 | ML algorithms (Linear/Logistic Regression, Random Forest) |
| `xgboost` | ≥2.0.0 | Gradient boosting (for future enhancements) |
| `matplotlib` | ≥3.7.0 | Visualization (optional) |
| `pandas` | ≥2.0.0 | Data manipulation |
| `numpy` | ≥1.24.0 | Numerical operations |

---

## Models Trained

### 1. Evidence Upload Volume Forecasting
- **Algorithm:** Linear Regression
- **Purpose:** Predict monthly evidence upload counts
- **Features:** Month, deployment count, agency count, avg file size
- **Target:** Total evidence upload volume
- **Registry Name:** `EVIDENCE_VOLUME_PREDICTOR`

### 2. Agency Churn Prediction
- **Algorithm:** Random Forest Classifier
- **Purpose:** Identify agencies at risk of churning
- **Features:** Agency type, jurisdiction, lifetime value, order patterns, support satisfaction
- **Target:** Is churned (Boolean)
- **Registry Name:** `AGENCY_CHURN_PREDICTOR`

### 3. Deployment Success Prediction
- **Algorithm:** Logistic Regression
- **Purpose:** Predict if device deployments will be successful
- **Features:** Product family, agency segment, jurisdiction, officer status, certification
- **Target:** Deployment successful (Boolean)
- **Registry Name:** `DEPLOYMENT_SUCCESS_PREDICTOR`

---

## After Training Models

Once models are trained and registered:

1. **Create ML Wrapper Procedures:**
   ```sql
   -- Run this SQL file:
   @sql/ml/07_create_model_wrapper_functions.sql
   ```

2. **Add to Intelligence Agent:**
   ```sql
   -- Option A: Use pre-configured SQL (includes ML models)
   @sql/agent/08_create_intelligence_agent.sql
   
   -- Option B: Use simplified version (no ML models)
   @sql/agent/08_create_intelligence_agent_no_ml.sql
   ```

3. **Test in Agent:**
   - Go to Snowsight → AI & ML → Agents → `AXON_INTELLIGENCE_AGENT`
   - Try queries like:
     - "Predict evidence upload volume for next 6 months"
     - "Which agencies are at high risk of churn?"
     - "What is the deployment success rate for Axon Body 3?"

---

## Troubleshooting

### Package Not Found Error
**Error:** `ModuleNotFoundError: No module named 'snowflake.ml'`

**Solution:** 
- Ensure `environment.yml` is uploaded and applied
- OR manually add `snowflake-ml-python` in Packages dropdown
- Restart the notebook session

### Column Not Found Error
**Error:** `ValueError: Selected column X is not found in the input dataframe`

**Solution:**
- Make sure you've run SQL scripts 01-06 first
- Verify data exists in tables:
  ```sql
  SELECT COUNT(*) FROM RAW.EVIDENCE_UPLOADS;
  SELECT COUNT(*) FROM RAW.AGENCIES;
  SELECT COUNT(*) FROM RAW.DEVICE_DEPLOYMENTS;
  ```

### Model Registry Permission Error
**Error:** Cannot access Model Registry

**Solution:**
```sql
GRANT CREATE MODEL ON SCHEMA AXON_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON DATABASE AXON_INTELLIGENCE TO ROLE <your_role>;
```

---

## Execution Time

- **Total Runtime:** ~5-10 minutes (depends on data volume)
- **Model 1 Training:** ~2-3 minutes
- **Model 2 Training:** ~2-3 minutes
- **Model 3 Training:** ~2-3 minutes
- **Model Registration:** ~30 seconds per model

---

## Best Practices

1. **Run cells sequentially** - Don't skip cells
2. **Check data counts** - Verify sufficient training data before modeling
3. **Review metrics** - Ensure model performance is acceptable
4. **Test inference** - Run the test cells to verify models work
5. **Document model versions** - Use version names for tracking

---

## Next Steps

After successfully running this notebook:

1. ✅ Models are registered in Snowflake Model Registry
2. ✅ Create SQL wrapper procedures (`07_create_model_wrapper_functions.sql`)
3. ✅ Add models to Intelligence Agent (`08_create_intelligence_agent.sql`)
4. ✅ Test predictions through the agent

---

**Need Help?** See `../docs/AGENT_SETUP.md` for detailed setup instructions.

