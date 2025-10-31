-- ============================================================================
-- Axon Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for business intelligence
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Agency 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_AGENCY_360 AS
SELECT
    a.agency_id,
    a.agency_name,
    a.primary_contact_email,
    a.primary_contact_phone,
    a.country,
    a.state,
    a.city,
    a.onboarding_date,
    a.agency_status,
    a.agency_type,
    a.lifetime_value,
    a.jurisdiction_type,
    a.population_served,
    a.officer_count,
    COUNT(DISTINCT o.officer_id) AS active_officers,
    COUNT(DISTINCT sc.contract_id) AS total_support_contracts,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    SUM(ord.order_amount) AS total_revenue,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    AVG(st.customer_satisfaction_score) AS avg_satisfaction_rating,
    COUNT(DISTINCT dd.deployment_id) AS total_device_deployments,
    COUNT(DISTINCT CASE WHEN dd.deployment_status = 'ACTIVE' THEN dd.deployment_id END) AS active_device_deployments,
    COUNT(DISTINCT eu.evidence_id) AS total_evidence_uploads,
    SUM(eu.file_size_mb) AS total_evidence_storage_mb,
    COUNT(DISTINCT qi.quality_issue_id) AS total_quality_issues,
    COUNT(DISTINCT CASE WHEN qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS high_severity_quality_issues,
    a.created_at,
    a.updated_at
FROM RAW.AGENCIES a
LEFT JOIN RAW.OFFICERS o ON a.agency_id = o.agency_id AND o.officer_status = 'ACTIVE'
LEFT JOIN RAW.SUPPORT_CONTRACTS sc ON a.agency_id = sc.contract_id
LEFT JOIN RAW.ORDERS ord ON a.agency_id = ord.agency_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON a.agency_id = st.agency_id
LEFT JOIN RAW.DEVICE_DEPLOYMENTS dd ON a.agency_id = dd.agency_id
LEFT JOIN RAW.EVIDENCE_UPLOADS eu ON a.agency_id = eu.agency_id
LEFT JOIN RAW.QUALITY_ISSUES qi ON a.agency_id = qi.agency_id
GROUP BY
    a.agency_id, a.agency_name, a.primary_contact_email, a.primary_contact_phone,
    a.country, a.state, a.city, a.onboarding_date, a.agency_status,
    a.agency_type, a.lifetime_value, a.jurisdiction_type, a.population_served,
    a.officer_count, a.created_at, a.updated_at;

-- ============================================================================
-- Officer Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_OFFICER_ANALYTICS AS
SELECT
    o.officer_id,
    o.agency_id,
    a.agency_name,
    o.officer_name,
    o.email,
    o.badge_number,
    o.rank,
    o.department,
    o.officer_status,
    o.years_of_service,
    o.axon_certified,
    o.primary_device_type,
    o.hire_date,
    o.last_training_date,
    COUNT(DISTINCT dd.deployment_id) AS total_device_deployments,
    COUNT(DISTINCT CASE WHEN dd.deployment_status = 'ACTIVE' THEN dd.deployment_id END) AS active_deployments,
    COUNT(DISTINCT eu.evidence_id) AS total_evidence_uploads,
    SUM(eu.file_size_mb) AS total_evidence_storage_mb,
    AVG(eu.file_size_mb) AS avg_evidence_file_size_mb,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    COUNT(DISTINCT cert.certification_id) AS total_certifications,
    COUNT(DISTINCT CASE WHEN cert.certification_status = 'ACTIVE' THEN cert.certification_id END) AS active_certifications,
    COUNT(DISTINCT qi.quality_issue_id) AS quality_issues_reported,
    o.created_at,
    o.updated_at
FROM RAW.OFFICERS o
JOIN RAW.AGENCIES a ON o.agency_id = a.agency_id
LEFT JOIN RAW.DEVICE_DEPLOYMENTS dd ON o.officer_id = dd.officer_id
LEFT JOIN RAW.EVIDENCE_UPLOADS eu ON o.officer_id = eu.officer_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON o.officer_id = st.officer_id
LEFT JOIN RAW.CERTIFICATIONS cert ON o.officer_id = cert.officer_id
LEFT JOIN RAW.QUALITY_ISSUES qi ON o.officer_id = qi.reported_by_officer_id
GROUP BY
    o.officer_id, o.agency_id, a.agency_name, o.officer_name,
    o.email, o.badge_number, o.rank, o.department, o.officer_status,
    o.years_of_service, o.axon_certified, o.primary_device_type,
    o.hire_date, o.last_training_date, o.created_at, o.updated_at;

-- ============================================================================
-- Device Deployment Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_DEVICE_DEPLOYMENT_ANALYTICS AS
SELECT
    dd.deployment_id,
    dd.agency_id,
    a.agency_name,
    a.agency_type,
    a.jurisdiction_type,
    dd.officer_id,
    o.officer_name,
    o.rank,
    o.department,
    dd.product_id,
    p.product_name,
    p.sku,
    p.product_family,
    p.product_type,
    dd.deployment_date,
    dd.deployment_status,
    dd.device_serial_number,
    dd.activation_date,
    dd.last_sync_date,
    dd.firmware_version,
    dd.competitive_replacement,
    dd.competitor_name,
    COUNT(DISTINCT eu.evidence_id) AS total_evidence_uploads,
    SUM(eu.file_size_mb) AS total_evidence_storage_mb,
    COUNT(DISTINCT CASE WHEN eu.evidence_type = 'VIDEO' THEN eu.evidence_id END) AS video_uploads,
    COUNT(DISTINCT CASE WHEN eu.evidence_type = 'AUDIO' THEN eu.evidence_id END) AS audio_uploads,
    COUNT(DISTINCT CASE WHEN eu.evidence_type = 'PHOTO' THEN eu.evidence_id END) AS photo_uploads,
    AVG(DATEDIFF('day', dd.activation_date, dd.last_sync_date)) AS avg_days_between_syncs,
    DATEDIFF('day', dd.deployment_date, CURRENT_DATE()) AS device_age_days,
    dd.created_at,
    dd.updated_at
FROM RAW.DEVICE_DEPLOYMENTS dd
JOIN RAW.AGENCIES a ON dd.agency_id = a.agency_id
JOIN RAW.OFFICERS o ON dd.officer_id = o.officer_id
JOIN RAW.PRODUCT_CATALOG p ON dd.product_id = p.product_id
LEFT JOIN RAW.EVIDENCE_UPLOADS eu ON dd.deployment_id = eu.deployment_id
GROUP BY
    dd.deployment_id, dd.agency_id, a.agency_name, a.agency_type,
    a.jurisdiction_type, dd.officer_id, o.officer_name, o.rank,
    o.department, dd.product_id, p.product_name, p.sku,
    p.product_family, p.product_type, dd.deployment_date,
    dd.deployment_status, dd.device_serial_number, dd.activation_date,
    dd.last_sync_date, dd.firmware_version, dd.competitive_replacement,
    dd.competitor_name, dd.created_at, dd.updated_at;

-- ============================================================================
-- Evidence Upload Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_EVIDENCE_UPLOAD_ANALYTICS AS
SELECT
    eu.evidence_id,
    eu.agency_id,
    a.agency_name,
    a.state,
    eu.officer_id,
    o.officer_name,
    o.department,
    eu.deployment_id,
    dd.device_serial_number,
    eu.product_id,
    p.product_name,
    p.product_family,
    eu.upload_date,
    eu.recording_date,
    eu.evidence_type,
    eu.file_size_mb,
    eu.duration_seconds,
    eu.evidence_status,
    eu.case_number,
    eu.retention_days,
    DATEDIFF('minute', eu.recording_date, eu.upload_date) AS minutes_to_upload,
    CASE 
        WHEN DATEDIFF('minute', eu.recording_date, eu.upload_date) <= 60 THEN 'IMMEDIATE'
        WHEN DATEDIFF('minute', eu.recording_date, eu.upload_date) <= 1440 THEN 'SAME_DAY'
        WHEN DATEDIFF('minute', eu.recording_date, eu.upload_date) <= 10080 THEN 'WITHIN_WEEK'
        ELSE 'DELAYED'
    END AS upload_timeliness,
    eu.created_at
FROM RAW.EVIDENCE_UPLOADS eu
JOIN RAW.AGENCIES a ON eu.agency_id = a.agency_id
JOIN RAW.OFFICERS o ON eu.officer_id = o.officer_id
JOIN RAW.DEVICE_DEPLOYMENTS dd ON eu.deployment_id = dd.deployment_id
JOIN RAW.PRODUCT_CATALOG p ON eu.product_id = p.product_id;

-- ============================================================================
-- Product Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_PRODUCT_PERFORMANCE AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    p.product_family,
    p.product_type,
    p.product_category,
    p.unit_price,
    p.lifecycle_status,
    p.launch_date,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    SUM(ord.quantity) AS total_units_sold,
    SUM(ord.order_amount) AS total_revenue,
    AVG(ord.order_amount) AS avg_order_amount,
    COUNT(DISTINCT ord.agency_id) AS unique_agencies,
    COUNT(DISTINCT dd.deployment_id) AS total_deployments,
    COUNT(DISTINCT CASE WHEN dd.deployment_status = 'ACTIVE' THEN dd.deployment_id END) AS active_deployments,
    COUNT(DISTINCT eu.evidence_id) AS total_evidence_uploads,
    SUM(eu.file_size_mb) AS total_evidence_storage_mb,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    AVG(st.customer_satisfaction_score) AS avg_support_satisfaction,
    COUNT(DISTINCT qi.quality_issue_id) AS total_quality_issues,
    COUNT(DISTINCT CASE WHEN qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS high_severity_issues,
    (COUNT(DISTINCT qi.quality_issue_id)::FLOAT / NULLIF(COUNT(DISTINCT dd.deployment_id), 0) * 100)::NUMBER(5,2) AS defect_rate_pct,
    p.created_at,
    p.updated_at
FROM RAW.PRODUCT_CATALOG p
LEFT JOIN RAW.ORDERS ord ON p.product_id = ord.product_id
LEFT JOIN RAW.DEVICE_DEPLOYMENTS dd ON p.product_id = dd.product_id
LEFT JOIN RAW.EVIDENCE_UPLOADS eu ON p.product_id = eu.product_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON p.product_id = st.product_id
LEFT JOIN RAW.QUALITY_ISSUES qi ON p.product_id = qi.product_id
GROUP BY
    p.product_id, p.product_name, p.sku, p.product_family,
    p.product_type, p.product_category, p.unit_price, p.lifecycle_status,
    p.launch_date, p.created_at, p.updated_at;

-- ============================================================================
-- Support Ticket Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUPPORT_TICKET_ANALYTICS AS
SELECT
    st.ticket_id,
    st.agency_id,
    a.agency_name,
    a.state,
    st.officer_id,
    o.officer_name,
    st.subject,
    st.ticket_category,
    st.priority,
    st.ticket_status,
    st.channel,
    st.created_date,
    st.first_response_date,
    st.resolution_date,
    st.assigned_support_id,
    se.engineer_name AS assigned_engineer_name,
    st.customer_satisfaction_score,
    st.product_id,
    p.product_name,
    p.product_family,
    st.ticket_type,
    st.escalated,
    DATEDIFF('hour', st.created_date, st.first_response_date) AS hours_to_first_response,
    DATEDIFF('day', st.created_date, st.resolution_date) AS days_to_resolution,
    CASE 
        WHEN DATEDIFF('hour', st.created_date, st.first_response_date) <= 2 THEN 'EXCELLENT'
        WHEN DATEDIFF('hour', st.created_date, st.first_response_date) <= 24 THEN 'GOOD'
        WHEN DATEDIFF('hour', st.created_date, st.first_response_date) <= 72 THEN 'ACCEPTABLE'
        ELSE 'POOR'
    END AS response_time_rating,
    st.created_at,
    st.updated_at
FROM RAW.SUPPORT_TICKETS st
JOIN RAW.AGENCIES a ON st.agency_id = a.agency_id
LEFT JOIN RAW.OFFICERS o ON st.officer_id = o.officer_id
LEFT JOIN RAW.SUPPORT_ENGINEERS se ON st.assigned_support_id = se.support_engineer_id
LEFT JOIN RAW.PRODUCT_CATALOG p ON st.product_id = p.product_id;

-- ============================================================================
-- Quality Issue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_QUALITY_ISSUE_ANALYTICS AS
SELECT
    qi.quality_issue_id,
    qi.agency_id,
    a.agency_name,
    a.agency_type,
    qi.product_id,
    p.product_name,
    p.product_family,
    p.product_type,
    qi.reported_by_officer_id,
    o.officer_name AS reported_by_officer_name,
    qi.reported_date,
    qi.issue_type,
    qi.severity,
    qi.investigation_status,
    qi.root_cause,
    qi.corrective_action,
    qi.preventive_action,
    qi.closure_date,
    qi.serial_number,
    qi.rma_number,
    qi.device_age_days,
    qi.issue_category,
    DATEDIFF('day', qi.reported_date, qi.closure_date) AS days_to_resolution,
    CASE 
        WHEN qi.device_age_days <= 30 THEN 'INFANT_MORTALITY'
        WHEN qi.device_age_days <= 365 THEN 'EARLY_LIFE'
        WHEN qi.device_age_days <= 1825 THEN 'USEFUL_LIFE'
        ELSE 'END_OF_LIFE'
    END AS failure_lifecycle_phase,
    qi.created_at,
    qi.updated_at
FROM RAW.QUALITY_ISSUES qi
JOIN RAW.AGENCIES a ON qi.agency_id = a.agency_id
LEFT JOIN RAW.PRODUCT_CATALOG p ON qi.product_id = p.product_id
LEFT JOIN RAW.OFFICERS o ON qi.reported_by_officer_id = o.officer_id;

-- ============================================================================
-- Revenue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_ANALYTICS AS
SELECT
    ord.order_id,
    ord.agency_id,
    a.agency_name,
    a.agency_type,
    a.state,
    ord.order_date,
    DATE_TRUNC('month', ord.order_date) AS order_month,
    DATE_TRUNC('quarter', ord.order_date) AS order_quarter,
    DATE_TRUNC('year', ord.order_date) AS order_year,
    ord.order_type,
    ord.order_amount,
    ord.payment_status,
    ord.product_id,
    p.product_name,
    p.product_family,
    p.product_type,
    ord.quantity,
    ord.unit_price,
    ord.discount_amount,
    ord.tax_amount,
    (ord.order_amount - ord.discount_amount + ord.tax_amount) AS net_order_amount,
    ord.distributor_id,
    d.distributor_name,
    d.region AS distributor_region,
    ord.direct_sale,
    ord.grant_funded,
    ord.order_source,
    CASE 
        WHEN ord.direct_sale = TRUE THEN 'DIRECT'
        ELSE 'DISTRIBUTOR'
    END AS sales_channel,
    ord.created_at
FROM RAW.ORDERS ord
JOIN RAW.AGENCIES a ON ord.agency_id = a.agency_id
LEFT JOIN RAW.PRODUCT_CATALOG p ON ord.product_id = p.product_id
LEFT JOIN RAW.DISTRIBUTORS d ON ord.distributor_id = d.distributor_id;

-- ============================================================================
-- Distributor Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_DISTRIBUTOR_PERFORMANCE AS
SELECT
    d.distributor_id,
    d.distributor_name,
    d.distributor_type,
    d.region,
    d.partnership_tier,
    d.distributor_status,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    SUM(ord.order_amount) AS total_revenue,
    AVG(ord.order_amount) AS avg_order_amount,
    COUNT(DISTINCT ord.agency_id) AS unique_agencies,
    COUNT(DISTINCT ord.product_id) AS unique_products_sold,
    COUNT(DISTINCT CASE WHEN ord.payment_status = 'COMPLETED' THEN ord.order_id END) AS completed_orders,
    (COUNT(DISTINCT CASE WHEN ord.payment_status = 'COMPLETED' THEN ord.order_id END)::FLOAT / 
     NULLIF(COUNT(DISTINCT ord.order_id), 0) * 100)::NUMBER(5,2) AS completion_rate_pct,
    d.created_at,
    d.updated_at
FROM RAW.DISTRIBUTORS d
LEFT JOIN RAW.ORDERS ord ON d.distributor_id = ord.distributor_id
GROUP BY
    d.distributor_id, d.distributor_name, d.distributor_type,
    d.region, d.partnership_tier, d.distributor_status,
    d.created_at, d.updated_at;

-- ============================================================================
-- Certification Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CERTIFICATION_ANALYTICS AS
SELECT
    c.certification_id,
    c.officer_id,
    o.officer_name,
    o.rank,
    o.department,
    c.agency_id,
    a.agency_name,
    c.certification_type,
    c.certification_name,
    c.issuing_organization,
    c.certification_number,
    c.issue_date,
    c.expiration_date,
    c.verification_status,
    c.certification_status,
    c.product_family_focus,
    c.training_hours,
    DATEDIFF('day', c.issue_date, CURRENT_DATE()) AS certification_age_days,
    CASE 
        WHEN c.expiration_date IS NOT NULL AND c.expiration_date < CURRENT_DATE() THEN 'EXPIRED'
        WHEN c.expiration_date IS NOT NULL AND DATEDIFF('day', CURRENT_DATE(), c.expiration_date) <= 60 THEN 'EXPIRING_SOON'
        WHEN c.expiration_date IS NOT NULL AND DATEDIFF('day', CURRENT_DATE(), c.expiration_date) <= 180 THEN 'ACTIVE_NEAR_EXPIRY'
        WHEN c.expiration_date IS NOT NULL THEN 'ACTIVE'
        ELSE 'NO_EXPIRATION'
    END AS expiration_status,
    c.created_at,
    c.updated_at
FROM RAW.CERTIFICATIONS c
JOIN RAW.OFFICERS o ON c.officer_id = o.officer_id
JOIN RAW.AGENCIES a ON c.agency_id = a.agency_id;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All analytical views created successfully' AS status;

