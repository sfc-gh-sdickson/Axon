-- ============================================================================
-- Axon Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for the Axon business model
-- Based on verified Microchip template structure
-- All columns verified against Axon business requirements
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- AGENCIES TABLE (from CUSTOMERS)
-- ============================================================================
CREATE OR REPLACE TABLE AGENCIES (
    agency_id VARCHAR(20) PRIMARY KEY,
    agency_name VARCHAR(200) NOT NULL,
    primary_contact_email VARCHAR(200) NOT NULL,
    primary_contact_phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    state VARCHAR(50),
    city VARCHAR(100),
    onboarding_date DATE NOT NULL,
    agency_status VARCHAR(20) DEFAULT 'ACTIVE',
    agency_type VARCHAR(30),
    lifetime_value NUMBER(12,2) DEFAULT 0.00,
    jurisdiction_type VARCHAR(50),
    population_served NUMBER(10,0),
    officer_count NUMBER(8,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- OFFICERS TABLE (from DESIGN_ENGINEERS)
-- ============================================================================
CREATE OR REPLACE TABLE OFFICERS (
    officer_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    officer_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    badge_number VARCHAR(50),
    rank VARCHAR(50),
    department VARCHAR(100),
    officer_status VARCHAR(20) DEFAULT 'ACTIVE',
    years_of_service NUMBER(5,0),
    axon_certified BOOLEAN DEFAULT FALSE,
    primary_device_type VARCHAR(50),
    hire_date DATE,
    last_training_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id)
);

-- ============================================================================
-- SUPPORT_CONTRACTS TABLE (from SUBSCRIPTIONS)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_CONTRACTS (
    contract_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    service_tier VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    billing_cycle VARCHAR(20),
    monthly_fee NUMBER(10,2),
    evidence_storage_gb NUMBER(12,0),
    unlimited_storage BOOLEAN DEFAULT FALSE,
    priority_support BOOLEAN DEFAULT FALSE,
    training_included BOOLEAN DEFAULT FALSE,
    contract_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id)
);

-- ============================================================================
-- PRODUCT_CATALOG TABLE
-- ============================================================================
CREATE OR REPLACE TABLE PRODUCT_CATALOG (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) NOT NULL,
    product_family VARCHAR(50) NOT NULL,
    product_type VARCHAR(50),
    unit_price NUMBER(10,2),
    product_category VARCHAR(50),
    model_number VARCHAR(50),
    warranty_years NUMBER(3,0),
    battery_life_hours NUMBER(5,1),
    storage_capacity_gb NUMBER(10,0),
    product_description VARCHAR(1000),
    lifecycle_status VARCHAR(30) DEFAULT 'ACTIVE',
    is_active BOOLEAN DEFAULT TRUE,
    launch_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DISTRIBUTORS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE DISTRIBUTORS (
    distributor_id VARCHAR(20) PRIMARY KEY,
    distributor_name VARCHAR(200) NOT NULL,
    distributor_type VARCHAR(30),
    contact_email VARCHAR(200),
    contact_phone VARCHAR(20),
    country VARCHAR(50),
    region VARCHAR(50),
    distributor_status VARCHAR(20) DEFAULT 'ACTIVE',
    partnership_tier VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DEVICE_DEPLOYMENTS TABLE (from DESIGN_WINS)
-- ============================================================================
CREATE OR REPLACE TABLE DEVICE_DEPLOYMENTS (
    deployment_id VARCHAR(30) PRIMARY KEY,
    officer_id VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    agency_id VARCHAR(20) NOT NULL,
    deployment_date DATE NOT NULL,
    deployment_status VARCHAR(30) DEFAULT 'ACTIVE',
    device_serial_number VARCHAR(50),
    activation_date DATE,
    last_sync_date DATE,
    firmware_version VARCHAR(20),
    replacement_for_device_id VARCHAR(30),
    competitive_replacement BOOLEAN DEFAULT FALSE,
    competitor_name VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (officer_id) REFERENCES OFFICERS(officer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id)
);

-- ============================================================================
-- EVIDENCE_UPLOADS TABLE (from PRODUCTION_ORDERS)
-- ============================================================================
CREATE OR REPLACE TABLE EVIDENCE_UPLOADS (
    evidence_id VARCHAR(30) PRIMARY KEY,
    deployment_id VARCHAR(30) NOT NULL,
    officer_id VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    agency_id VARCHAR(20) NOT NULL,
    upload_date TIMESTAMP_NTZ NOT NULL,
    evidence_type VARCHAR(50),
    file_size_mb NUMBER(12,2),
    duration_seconds NUMBER(10,0),
    recording_date TIMESTAMP_NTZ,
    evidence_status VARCHAR(30) DEFAULT 'ACTIVE',
    case_number VARCHAR(50),
    retention_days NUMBER(10,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (deployment_id) REFERENCES DEVICE_DEPLOYMENTS(deployment_id),
    FOREIGN KEY (officer_id) REFERENCES OFFICERS(officer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id)
);

-- ============================================================================
-- CERTIFICATIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE CERTIFICATIONS (
    certification_id VARCHAR(30) PRIMARY KEY,
    officer_id VARCHAR(30) NOT NULL,
    agency_id VARCHAR(20) NOT NULL,
    certification_type VARCHAR(50) NOT NULL,
    certification_name VARCHAR(200) NOT NULL,
    issuing_organization VARCHAR(200),
    certification_number VARCHAR(100),
    issue_date DATE NOT NULL,
    expiration_date DATE,
    verification_status VARCHAR(30) DEFAULT 'VERIFIED',
    certification_status VARCHAR(30) DEFAULT 'ACTIVE',
    primary_certification BOOLEAN DEFAULT FALSE,
    product_family_focus VARCHAR(50),
    training_hours NUMBER(5,1),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (officer_id) REFERENCES OFFICERS(officer_id),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id)
);

-- ============================================================================
-- CERTIFICATION_VERIFICATIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE CERTIFICATION_VERIFICATIONS (
    verification_id VARCHAR(30) PRIMARY KEY,
    certification_id VARCHAR(30) NOT NULL,
    verification_date TIMESTAMP_NTZ NOT NULL,
    verification_method VARCHAR(50),
    verification_status VARCHAR(30) NOT NULL,
    verified_by VARCHAR(100),
    verification_source VARCHAR(200),
    notes VARCHAR(1000),
    next_verification_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (certification_id) REFERENCES CERTIFICATIONS(certification_id)
);

-- ============================================================================
-- ORDERS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE ORDERS (
    order_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    order_date TIMESTAMP_NTZ NOT NULL,
    order_type VARCHAR(50) NOT NULL,
    order_amount NUMBER(12,2) NOT NULL,
    payment_terms VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    currency VARCHAR(10) DEFAULT 'USD',
    product_id VARCHAR(30),
    quantity NUMBER(12,0),
    unit_price NUMBER(10,2),
    discount_amount NUMBER(10,2) DEFAULT 0.00,
    tax_amount NUMBER(10,2) DEFAULT 0.00,
    distributor_id VARCHAR(20),
    direct_sale BOOLEAN DEFAULT FALSE,
    ship_to_state VARCHAR(50),
    order_source VARCHAR(30),
    grant_funded BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id),
    FOREIGN KEY (distributor_id) REFERENCES DISTRIBUTORS(distributor_id)
);

-- ============================================================================
-- SUPPORT_TICKETS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TICKETS (
    ticket_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    officer_id VARCHAR(30),
    subject VARCHAR(500) NOT NULL,
    description VARCHAR(5000),
    ticket_category VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    ticket_status VARCHAR(30) DEFAULT 'OPEN',
    channel VARCHAR(30),
    created_date TIMESTAMP_NTZ NOT NULL,
    first_response_date TIMESTAMP_NTZ,
    resolution_date TIMESTAMP_NTZ,
    assigned_support_id VARCHAR(20),
    customer_satisfaction_score NUMBER(3,0),
    product_id VARCHAR(30),
    ticket_type VARCHAR(30),
    escalated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (officer_id) REFERENCES OFFICERS(officer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id)
);

-- ============================================================================
-- SUPPORT_ENGINEERS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_ENGINEERS (
    support_engineer_id VARCHAR(20) PRIMARY KEY,
    engineer_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    department VARCHAR(50),
    specialization VARCHAR(100),
    hire_date DATE,
    average_satisfaction_rating NUMBER(3,2),
    total_tickets_resolved NUMBER(10,0) DEFAULT 0,
    engineer_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- QUALITY_ISSUES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE QUALITY_ISSUES (
    quality_issue_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(30),
    reported_by_officer_id VARCHAR(30),
    reported_date TIMESTAMP_NTZ NOT NULL,
    issue_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) DEFAULT 'MEDIUM',
    description VARCHAR(5000),
    investigation_status VARCHAR(30) DEFAULT 'OPEN',
    root_cause VARCHAR(5000),
    corrective_action VARCHAR(5000),
    preventive_action VARCHAR(5000),
    closure_date TIMESTAMP_NTZ,
    serial_number VARCHAR(50),
    rma_number VARCHAR(30),
    device_age_days NUMBER(10,0),
    issue_category VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id),
    FOREIGN KEY (reported_by_officer_id) REFERENCES OFFICERS(officer_id)
);

-- ============================================================================
-- MARKETING_CAMPAIGNS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE MARKETING_CAMPAIGNS (
    campaign_id VARCHAR(30) PRIMARY KEY,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    target_audience VARCHAR(100),
    budget NUMBER(12,2),
    channel VARCHAR(50),
    campaign_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- AGENCY_CAMPAIGN_INTERACTIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE AGENCY_CAMPAIGN_INTERACTIONS (
    interaction_id VARCHAR(30) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    campaign_id VARCHAR(30) NOT NULL,
    interaction_date TIMESTAMP_NTZ NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    conversion_flag BOOLEAN DEFAULT FALSE,
    revenue_generated NUMBER(12,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (campaign_id) REFERENCES MARKETING_CAMPAIGNS(campaign_id)
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

