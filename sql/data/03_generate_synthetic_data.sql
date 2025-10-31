-- ============================================================================
-- Axon Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for Axon business operations
-- Volume: ~20K agencies, 200K officers, 400K deployments, 800K evidence uploads
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Step 1: Generate Distributors
-- ============================================================================
INSERT INTO DISTRIBUTORS VALUES
('DIST001', 'Public Safety Equipment Corp', 'AUTHORIZED', 'sales@pse-corp.com', '+1-303-555-4000', 'USA', 'WEST', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST002', 'Law Enforcement Solutions', 'AUTHORIZED', 'sales@lesolutions.com', '+1-480-555-3000', 'USA', 'SOUTHWEST', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST003', 'First Responder Supply', 'AUTHORIZED', 'sales@firstresponder.com', '+1-800-555-4539', 'USA', 'MIDWEST', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST004', 'Safety Technologies Inc', 'AUTHORIZED', 'sales@safetytech.com', '+1-817-555-3800', 'USA', 'SOUTH', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST005', 'Public Safety Direct', 'AUTHORIZED', 'sales@psdirect.com', '+1-514-555-7710', 'CANADA', 'CANADA', 'ACTIVE', 'SILVER', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST006', 'Emergency Equipment UK', 'AUTHORIZED', 'sales@emergencyeq.co.uk', '+44-20-555-1201', 'UK', 'EMEA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST007', 'Police Equipment Europe', 'AUTHORIZED', 'sales@policeequip.eu', '+49-30-555-6311', 'GERMANY', 'EMEA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST008', 'Asia Pacific Safety', 'AUTHORIZED', 'sales@apacsafety.com', '+852-555-5200', 'HONG_KONG', 'APAC', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST009', 'Australian Police Supply', 'AUTHORIZED', 'sales@auspolice.com.au', '+61-2-555-8771', 'AUSTRALIA', 'APAC', 'ACTIVE', 'SILVER', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST010', 'Global Law Enforcement', 'AUTHORIZED', 'sales@globallaw.com', '+971-4-555-7555', 'UAE', 'MIDDLE_EAST', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 2: Generate Product Catalog
-- ============================================================================
INSERT INTO PRODUCT_CATALOG VALUES
-- TASER Family
('PROD001', 'TASER 7', 'TASER7-STD', 'TASER', 'CONDUCTED_ENERGY_WEAPON', 1799.99, 'WEAPONS', 'TASER-7-CQ', 5, 500.0, 0, 'Advanced TASER with improved accuracy and extended range', 'ACTIVE', TRUE, '2018-10-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD002', 'TASER X2', 'TASERX2-DEF', 'TASER', 'CONDUCTED_ENERGY_WEAPON', 1599.99, 'WEAPONS', 'TASERX2', 5, 400.0, 0, 'Dual-shot TASER with backup capacity', 'ACTIVE', TRUE, '2011-03-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD003', 'TASER X26P', 'TASERX26P', 'TASER', 'CONDUCTED_ENERGY_WEAPON', 1299.99, 'WEAPONS', 'X26P', 5, 300.0, 0, 'Compact single-shot TASER for everyday carry', 'ACTIVE', TRUE, '2013-06-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD004', 'TASER 10', 'TASER10-ADV', 'TASER', 'CONDUCTED_ENERGY_WEAPON', 2499.99, 'WEAPONS', 'TASER-10', 5, 600.0, 0, 'Next-generation 10-probe TASER with enhanced capabilities', 'ACTIVE', TRUE, '2022-09-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Body Camera Family
('PROD010', 'Axon Body 3', 'AXONBODY3', 'BODY_CAMERA', 'BODY_WORN_CAMERA', 699.99, 'CAMERAS', 'BODY3-128', 3, 12.0, 128, 'AI-powered body camera with live streaming', 'ACTIVE', TRUE, '2019-05-12', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD011', 'Axon Body 4', 'AXONBODY4', 'BODY_CAMERA', 'BODY_WORN_CAMERA', 899.99, 'CAMERAS', 'BODY4-256', 3, 14.0, 256, 'Latest body camera with advanced AI and extended battery', 'ACTIVE', TRUE, '2023-03-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD012', 'Axon Flex 2', 'AXONFLEX2', 'BODY_CAMERA', 'BODY_WORN_CAMERA', 599.99, 'CAMERAS', 'FLEX2-64', 3, 10.0, 64, 'Flexible mounting body camera for specialized units', 'ACTIVE', TRUE, '2016-08-18', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- In-Car Systems
('PROD020', 'Axon Fleet 3', 'AXONFLEET3', 'IN_CAR', 'VEHICLE_CAMERA_SYSTEM', 3499.99, 'CAMERAS', 'FLEET3-500', 5, 0.0, 500, 'Advanced in-car video system with multi-camera support', 'ACTIVE', TRUE, '2020-02-22', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD021', 'Axon Fleet 4', 'AXONFLEET4', 'IN_CAR', 'VEHICLE_CAMERA_SYSTEM', 4299.99, 'CAMERAS', 'FLEET4-1TB', 5, 0.0, 1000, 'Next-gen in-car system with AI and cloud integration', 'ACTIVE', TRUE, '2023-11-08', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Evidence Management Software
('PROD030', 'Evidence.com Basic', 'EVIDENCE-BASIC', 'SOFTWARE', 'EVIDENCE_MANAGEMENT', 99.99, 'SOFTWARE', 'EVID-BASIC', 0, 0.0, 0, 'Cloud evidence management - Basic tier (1TB storage)', 'ACTIVE', TRUE, '2010-06-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD031', 'Evidence.com Professional', 'EVIDENCE-PRO', 'SOFTWARE', 'EVIDENCE_MANAGEMENT', 199.99, 'SOFTWARE', 'EVID-PRO', 0, 0.0, 0, 'Cloud evidence management - Professional tier (5TB storage)', 'ACTIVE', TRUE, '2010-06-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD032', 'Evidence.com Enterprise', 'EVIDENCE-ENT', 'SOFTWARE', 'EVIDENCE_MANAGEMENT', 499.99, 'SOFTWARE', 'EVID-ENT', 0, 0.0, 0, 'Cloud evidence management - Enterprise tier (Unlimited storage)', 'ACTIVE', TRUE, '2010-06-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Docks and Accessories
('PROD040', 'Axon Dock', 'AXONDOCK-STD', 'ACCESSORIES', 'DOCKING_STATION', 499.99, 'ACCESSORIES', 'DOCK-16', 3, 0.0, 0, 'Multi-device docking station for evidence upload', 'ACTIVE', TRUE, '2015-03-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD041', 'Axon Mount', 'AXONMOUNT', 'ACCESSORIES', 'MOUNTING', 49.99, 'ACCESSORIES', 'MOUNT-UNIV', 3, 0.0, 0, 'Universal mounting kit for body cameras', 'ACTIVE', TRUE, '2014-01-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Interview Room Solutions
('PROD050', 'Axon Interview', 'AXONINTERVIEW', 'INTERVIEW', 'RECORDING_SYSTEM', 2999.99, 'CAMERAS', 'INTERVIEW-HD', 5, 0.0, 500, 'Interview room recording system', 'ACTIVE', TRUE, '2017-09-25', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Real-Time Operations
('PROD060', 'Axon Respond', 'AXONRESPOND', 'SOFTWARE', 'REAL_TIME_OPS', 299.99, 'SOFTWARE', 'RESPOND-V1', 0, 0.0, 0, 'Real-time situational awareness platform', 'ACTIVE', TRUE, '2021-04-12', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD061', 'Axon Records', 'AXONRECORDS', 'SOFTWARE', 'RECORDS_MANAGEMENT', 399.99, 'SOFTWARE', 'RECORDS-V1', 0, 0.0, 0, 'Digital records management system', 'ACTIVE', TRUE, '2020-08-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Training Products
('PROD070', 'VR Training Suite', 'AXONVR-TRAIN', 'TRAINING', 'VR_SIMULATION', 4999.99, 'TRAINING', 'VR-SUITE', 3, 8.0, 0, 'Virtual reality training system for de-escalation', 'ACTIVE', TRUE, '2021-06-18', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD071', 'TASER Training Cartridges', 'TASER-TRAIN-CART', 'TRAINING', 'TRAINING_EQUIPMENT', 199.99, 'TRAINING', 'CART-TRAIN-50', 0, 0.0, 0, 'Training cartridges for TASER certification', 'ACTIVE', TRUE, '2010-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Support Engineers
-- ============================================================================
INSERT INTO SUPPORT_ENGINEERS
SELECT
    'SE' || LPAD(SEQ4(), 5, '0') AS support_engineer_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Chen', 'Michael Johnson', 'Emily Rodriguez', 'David Kim',
                    'Jessica Martinez', 'Robert Lee', 'Amanda Patel', 'Christopher Brown', 'Lisa Anderson',
                    'James Wilson', 'Maria Garcia', 'Daniel Taylor', 'Jennifer White', 'Matthew Harris')[UNIFORM(0, 14, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('Jr.', 'Sr.', '', '', '')[UNIFORM(0, 4, RANDOM())] AS engineer_name,
    'support' || SEQ4() || '@axon.com' AS email,
    ARRAY_CONSTRUCT('CAMERA_SUPPORT', 'TASER_SUPPORT', 'SOFTWARE_SUPPORT', 'FLEET_SUPPORT', 'EVIDENCE_SUPPORT')[UNIFORM(0, 4, RANDOM())] AS department,
    ARRAY_CONSTRUCT('Body Camera Systems', 'TASER Devices', 'Evidence.com Platform', 'In-Car Video', 'Cloud Services', 'Mobile Apps', 'Training Systems')[UNIFORM(0, 6, RANDOM())] AS specialization,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE()) AS hire_date,
    (UNIFORM(40, 50, RANDOM()) / 10.0)::NUMBER(3,2) AS average_satisfaction_rating,
    UNIFORM(300, 10000, RANDOM()) AS total_tickets_resolved,
    'ACTIVE' AS engineer_status,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- ============================================================================
-- Step 4: Generate Agencies (Customers)
-- ============================================================================
INSERT INTO AGENCIES
SELECT
    'AGENCY' || LPAD(SEQ4(), 8, '0') AS agency_id,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN 
            ARRAY_CONSTRUCT('Phoenix', 'Los Angeles', 'Chicago', 'Houston', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas',
                           'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte', 'San Francisco',
                           'Indianapolis', 'Seattle', 'Denver', 'Boston', 'Nashville', 'Detroit', 'Portland', 'Las Vegas',
                           'Memphis', 'Louisville', 'Baltimore', 'Milwaukee', 'Albuquerque', 'Tucson', 'Fresno',
                           'Sacramento', 'Mesa', 'Kansas City', 'Atlanta', 'Miami', 'Raleigh', 'Omaha', 'Cleveland',
                           'Minneapolis', 'Tulsa', 'Arlington', 'New Orleans', 'Wichita', 'Tampa', 'Orlando')[UNIFORM(0, 44, RANDOM())] 
            || ' Police Department'
        WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN
            ARRAY_CONSTRUCT('County', 'County Sheriff', 'Regional', 'Metro', 'Municipal')[UNIFORM(0, 4, RANDOM())] || ' ' ||
            ARRAY_CONSTRUCT('Police', 'Law Enforcement', 'Public Safety', 'Safety Department')[UNIFORM(0, 3, RANDOM())]
        WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN
            ARRAY_CONSTRUCT('State Police', 'Highway Patrol', 'State Patrol', 'State Troopers')[UNIFORM(0, 3, RANDOM())] || ' - ' ||
            ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI', 'NJ', 'VA', 'WA', 'AZ', 'MA')[UNIFORM(0, 14, RANDOM())]
        ELSE
            ARRAY_CONSTRUCT('University', 'Campus', 'Transit', 'Port', 'Airport', 'Capitol', 'Federal')[UNIFORM(0, 6, RANDOM())] || ' Police ' ||
            ARRAY_CONSTRUCT('Department', 'Authority', 'Force', 'Service')[UNIFORM(0, 3, RANDOM())]
    END AS agency_name,
    'chief' || SEQ4() || '@' || ARRAY_CONSTRUCT('police', 'sheriff', 'agency', 'publicsafety', 'lawenforcement')[UNIFORM(0, 4, RANDOM())] || '.gov' AS primary_contact_email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS primary_contact_phone,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'USA'
         WHEN UNIFORM(0, 100, RANDOM()) < 4 THEN 'CANADA'
         WHEN UNIFORM(0, 100, RANDOM()) < 2 THEN ARRAY_CONSTRUCT('UK', 'AUSTRALIA')[UNIFORM(0, 1, RANDOM())]
         ELSE ARRAY_CONSTRUCT('GERMANY', 'FRANCE', 'JAPAN', 'NETHERLANDS')[UNIFORM(0, 3, RANDOM())]
    END AS country,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI', 'NJ', 'VA', 'WA', 'AZ', 'MA', 'TN', 'IN', 'MO', 'MD', 'WI', 
                    'CO', 'MN', 'SC', 'AL', 'LA', 'KY', 'OR', 'OK', 'CT', 'UT', 'IA', 'NV', 'AR', 'MS', 'KS', 'NM', 'NE', 'ID', 'WV', 'HI',
                    'NH', 'ME', 'RI', 'MT', 'DE', 'SD', 'ND', 'AK', 'VT', 'WY')[UNIFORM(0, 49, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Downtown', 'North District', 'South District', 'East Side', 'West Side', 'Central', 'Metro', 'Suburban')[UNIFORM(0, 7, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(30, 7300, RANDOM()), CURRENT_DATE()) AS onboarding_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 96 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'INACTIVE'
         ELSE 'CHURNED' END AS agency_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 'MUNICIPAL_POLICE'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'COUNTY_SHERIFF'
         WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN 'STATE_POLICE'
         ELSE ARRAY_CONSTRUCT('CAMPUS_POLICE', 'TRANSIT_POLICE', 'FEDERAL_AGENCY')[UNIFORM(0, 2, RANDOM())] END AS agency_type,
    (UNIFORM(100000, 10000000, RANDOM()) / 1.0)::NUMBER(12,2) AS lifetime_value,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'METROPOLITAN'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'SUBURBAN'
         ELSE ARRAY_CONSTRUCT('RURAL', 'REGIONAL')[UNIFORM(0, 1, RANDOM())] END AS jurisdiction_type,
    UNIFORM(10000, 5000000, RANDOM()) AS population_served,
    UNIFORM(10, 5000, RANDOM()) AS officer_count,
    DATEADD('day', -1 * UNIFORM(30, 7300, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 20000));

-- ============================================================================
-- Step 5: Generate Officers
-- ============================================================================
INSERT INTO OFFICERS
SELECT
    'OFF' || LPAD(SEQ4(), 10, '0') AS officer_id,
    a.agency_id,
    ARRAY_CONSTRUCT('James', 'Jennifer', 'Michael', 'Michelle', 'David', 'Diana', 'Robert', 'Rachel', 'William', 'Wendy',
                    'Richard', 'Rebecca', 'Daniel', 'Danielle', 'Thomas', 'Tiffany', 'Charles', 'Christine', 'Joseph', 'Jessica',
                    'Christopher', 'Amanda', 'Matthew', 'Melissa', 'Anthony', 'Ashley', 'Mark', 'Sarah', 'Donald', 'Laura',
                    'Steven', 'Nicole', 'Paul', 'Emily', 'Andrew', 'Elizabeth', 'Joshua', 'Linda', 'Kenneth', 'Maria')[UNIFORM(0, 39, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
                    'Wilson', 'Anderson', 'Taylor', 'Thomas', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White',
                    'Harris', 'Clark', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen', 'King', 'Wright', 'Lopez')[UNIFORM(0, 29, RANDOM())] AS officer_name,
    'officer' || SEQ4() || '@' || LOWER(REPLACE(REPLACE(a.agency_name, ' ', ''), '.', '')) || '.gov' AS email,
    LPAD(UNIFORM(100, 9999, RANDOM()), 4, '0') AS badge_number,
    ARRAY_CONSTRUCT('Officer', 'Senior Officer', 'Corporal', 'Sergeant', 'Lieutenant', 'Captain', 'Commander', 'Deputy Chief', 'Chief')[UNIFORM(0, 8, RANDOM())] AS rank,
    ARRAY_CONSTRUCT('Patrol', 'Traffic', 'Detective', 'SWAT', 'K9', 'Training', 'Administration', 'Community Relations', 'Narcotics', 'Special Operations')[UNIFORM(0, 9, RANDOM())] AS department,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE' 
         WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'ON_LEAVE'
         ELSE 'RETIRED' END AS officer_status,
    UNIFORM(1, 30, RANDOM()) AS years_of_service,
    UNIFORM(0, 100, RANDOM()) < 35 AS axon_certified,
    ARRAY_CONSTRUCT('BODY_CAMERA', 'TASER', 'IN_CAR_VIDEO', 'MULTIPLE', 'BODY_CAMERA')[UNIFORM(0, 4, RANDOM())] AS primary_device_type,
    DATEADD('day', -1 * UNIFORM(30, 10950, RANDOM()), CURRENT_DATE()) AS hire_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) ELSE NULL END AS last_training_date,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM AGENCIES a
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))
WHERE UNIFORM(0, 100, RANDOM()) < 100
LIMIT 200000;

-- ============================================================================
-- Step 6: Generate Marketing Campaigns
-- ============================================================================
INSERT INTO MARKETING_CAMPAIGNS
SELECT
    'CAMP' || LPAD(SEQ4(), 5, '0') AS campaign_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 
        ARRAY_CONSTRUCT('TASER 7', 'Axon Body 3', 'Axon Fleet 3', 'Evidence.com', 'Axon Respond')[UNIFORM(0, 4, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Launch', 'Webinar Series', 'Training Program', 'Product Promotion', 'Demo Tour')[UNIFORM(0, 4, RANDOM())]
    ELSE
        ARRAY_CONSTRUCT('Officer Safety Initiative', 'Evidence Management Summit', 'Body Camera Adoption', 'Digital Transformation', 'Community Relations')[UNIFORM(0, 4, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Summit', 'Workshop', 'Conference', 'Roadshow', 'Virtual Event')[UNIFORM(0, 4, RANDOM())]
    END AS campaign_name,
    ARRAY_CONSTRUCT('PRODUCT_LAUNCH', 'WEBINAR', 'CONFERENCE', 'EMAIL_CAMPAIGN', 'TRADE_SHOW', 'TRAINING', 'DEMO_TOUR')[UNIFORM(0, 6, RANDOM())] AS campaign_type,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('day', UNIFORM(7, 90, RANDOM()), DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('MUNICIPAL_POLICE', 'COUNTY_SHERIFF', 'STATE_POLICE', 'FEDERAL_AGENCIES', 'CAMPUS_POLICE', 'ALL')[UNIFORM(0, 5, RANDOM())] AS target_audience,
    (UNIFORM(25000, 1000000, RANDOM()) / 1.0)::NUMBER(12,2) AS budget,
    ARRAY_CONSTRUCT('EMAIL', 'WEBINAR', 'TRADE_SHOW', 'DIRECT_MAIL', 'WEBSITE', 'IN_PERSON')[UNIFORM(0, 5, RANDOM())] AS channel,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 65 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'ACTIVE'
         ELSE 'PLANNED' END AS campaign_status,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 400));

-- ============================================================================
-- Step 7: Generate Support Contracts
-- ============================================================================
INSERT INTO SUPPORT_CONTRACTS
SELECT
    'CONT' || LPAD(SEQ4(), 10, '0') AS contract_id,
    a.agency_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'EVIDENCE_BASIC'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'EVIDENCE_PROFESSIONAL'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'EVIDENCE_ENTERPRISE'
         ELSE 'FULL_SUITE' END AS contract_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 45 THEN 'BASIC'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'PROFESSIONAL'
         ELSE 'ENTERPRISE' END AS service_tier,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('year', UNIFORM(1, 3, RANDOM()), DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('MONTHLY', 'ANNUAL')[UNIFORM(0, 1, RANDOM())] AS billing_cycle,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN (UNIFORM(1000, 5000, RANDOM()) / 1.0)::NUMBER(10,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN (UNIFORM(5000, 15000, RANDOM()) / 1.0)::NUMBER(10,2)
         ELSE (UNIFORM(15000, 50000, RANDOM()) / 1.0)::NUMBER(10,2) END AS monthly_fee,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 1000
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 5000
         ELSE 0 END AS evidence_storage_gb,
    UNIFORM(0, 100, RANDOM()) < 30 AS unlimited_storage,
    UNIFORM(0, 100, RANDOM()) < 45 AS priority_support,
    UNIFORM(0, 100, RANDOM()) < 60 AS training_included,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 88 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN 'EXPIRED'
         ELSE 'CANCELLED' END AS contract_status,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM AGENCIES a
WHERE UNIFORM(0, 100, RANDOM()) < 70;

-- ============================================================================
-- Step 8: Generate Certifications
-- ============================================================================
INSERT INTO CERTIFICATIONS
SELECT
    'CERT' || LPAD(SEQ4(), 10, '0') AS certification_id,
    o.officer_id,
    o.agency_id,
    ARRAY_CONSTRUCT('TASER_CERTIFICATION', 'BODY_CAMERA_TRAINING', 'EVIDENCE_MANAGEMENT', 'INSTRUCTOR_CERTIFICATION', 'ADVANCED_WEAPONS')[UNIFORM(0, 4, RANDOM())] AS certification_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN
        ARRAY_CONSTRUCT('TASER 7', 'TASER X2', 'TASER X26P', 'Body Camera', 'Fleet Systems')[UNIFORM(0, 4, RANDOM())] || ' Certified Operator'
    ELSE
        ARRAY_CONSTRUCT('Master Instructor', 'Evidence Management Specialist', 'Video Systems Expert', 'De-escalation Trainer')[UNIFORM(0, 3, RANDOM())]
    END AS certification_name,
    ARRAY_CONSTRUCT('Axon Training', 'State Police Academy', 'ILEETA', 'FBI Academy')[UNIFORM(0, 3, RANDOM())] AS issuing_organization,
    'CERT-' || LPAD(UNIFORM(100000, 999999, RANDOM()), 6, '0') AS certification_number,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS issue_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('year', 2, DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()))
         ELSE NULL END AS expiration_date,
    'VERIFIED' AS verification_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE' ELSE 'EXPIRED' END AS certification_status,
    UNIFORM(0, 100, RANDOM()) < 40 AS primary_certification,
    o.primary_device_type AS product_family_focus,
    (UNIFORM(8, 40, RANDOM()) / 1.0)::NUMBER(5,1) AS training_hours,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM OFFICERS o
WHERE o.axon_certified = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 100
LIMIT 50000;

-- ============================================================================
-- Step 9: Generate Device Deployments
-- ============================================================================
INSERT INTO DEVICE_DEPLOYMENTS
SELECT
    'DEP' || LPAD(SEQ4(), 12, '0') AS deployment_id,
    o.officer_id,
    p.product_id,
    o.agency_id,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_DATE()) AS deployment_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'INACTIVE'
         ELSE 'RETIRED' END AS deployment_status,
    'SN' || LPAD(UNIFORM(1000000, 9999999, RANDOM()), 7, '0') AS device_serial_number,
    DATEADD('day', UNIFORM(0, 14, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_DATE())) AS activation_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN DATEADD('day', -1 * UNIFORM(0, 7, RANDOM()), CURRENT_DATE()) ELSE NULL END AS last_sync_date,
    ARRAY_CONSTRUCT('1.0.0', '1.1.0', '1.2.0', '2.0.0', '2.1.0', '2.2.0', '3.0.0')[UNIFORM(0, 6, RANDOM())] AS firmware_version,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'DEP' || LPAD(UNIFORM(1, 99999999, RANDOM()), 12, '0') ELSE NULL END AS replacement_for_device_id,
    UNIFORM(0, 100, RANDOM()) < 15 AS competitive_replacement,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 
         THEN ARRAY_CONSTRUCT('WatchGuard', 'Utility', 'Digital Ally', 'Panasonic', 'Motorola', 'Getac')[UNIFORM(0, 5, RANDOM())]
         ELSE NULL END AS competitor_name,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM OFFICERS o
JOIN AGENCIES a ON o.agency_id = a.agency_id
CROSS JOIN PRODUCT_CATALOG p
WHERE o.officer_status = 'ACTIVE'
  AND p.is_active = TRUE
  AND p.product_category IN ('CAMERAS', 'WEAPONS')
  AND UNIFORM(0, 100, RANDOM()) < 2
LIMIT 400000;

-- ============================================================================
-- Step 10: Generate Evidence Uploads
-- ============================================================================
INSERT INTO EVIDENCE_UPLOADS
SELECT
    'EVID' || LPAD(SEQ4(), 12, '0') AS evidence_id,
    d.deployment_id,
    d.officer_id,
    d.product_id,
    d.agency_id,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS upload_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'VIDEO'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'AUDIO'
         ELSE 'PHOTO' END AS evidence_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN (UNIFORM(50, 2000, RANDOM()) / 1.0)::NUMBER(12,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN (UNIFORM(10, 100, RANDOM()) / 1.0)::NUMBER(12,2)
         ELSE (UNIFORM(5, 50, RANDOM()) / 1.0)::NUMBER(12,2) END AS file_size_mb,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN UNIFORM(300, 7200, RANDOM())
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN UNIFORM(60, 1800, RANDOM())
         ELSE 0 END AS duration_seconds,
    DATEADD('minute', -1 * UNIFORM(30, 240, RANDOM()), DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()))) AS recording_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 95 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'ARCHIVED'
         ELSE 'DELETED' END AS evidence_status,
    'CASE-' || UNIFORM(2020, 2025, RANDOM()) || '-' || LPAD(UNIFORM(1, 99999, RANDOM()), 5, '0') AS case_number,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN 2555
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 1825
         ELSE 3650 END AS retention_days,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM DEVICE_DEPLOYMENTS d
WHERE d.deployment_status = 'ACTIVE'
  AND UNIFORM(0, 100, RANDOM()) < 2
LIMIT 800000;

-- ============================================================================
-- Step 11: Generate Orders
-- ============================================================================
INSERT INTO ORDERS
SELECT
    'ORD' || LPAD(SEQ4(), 12, '0') AS order_id,
    a.agency_id,
    DATEADD('minute', UNIFORM(0, 1051200, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS order_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'HARDWARE'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'SOFTWARE_SUBSCRIPTION'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'ACCESSORIES'
         ELSE 'TRAINING' END AS order_type,
    (UNIFORM(1000, 250000, RANDOM()) / 1.0)::NUMBER(12,2) AS order_amount,
    ARRAY_CONSTRUCT('NET_30', 'NET_60', 'NET_90', 'PREPAID', 'GRANT_FUNDED')[UNIFORM(0, 4, RANDOM())] AS payment_terms,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 95 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'PENDING'
         ELSE 'FAILED' END AS payment_status,
    'USD' AS currency,
    p.product_id,
    UNIFORM(1, 100, RANDOM()) AS quantity,
    p.unit_price AS unit_price,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN (UNIFORM(100, 5000, RANDOM()) / 1.0)::NUMBER(10,2) ELSE 0.00 END AS discount_amount,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN (UNIFORM(50, 2000, RANDOM()) / 1.0)::NUMBER(10,2) ELSE 0.00 END AS tax_amount,
    d.distributor_id,
    UNIFORM(0, 100, RANDOM()) < 60 AS direct_sale,
    a.state AS ship_to_state,
    ARRAY_CONSTRUCT('DIRECT_SALES', 'DISTRIBUTOR', 'ONLINE', 'TRADE_SHOW')[UNIFORM(0, 3, RANDOM())] AS order_source,
    UNIFORM(0, 100, RANDOM()) < 35 AS grant_funded,
    DATEADD('minute', UNIFORM(0, 1051200, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM AGENCIES a
CROSS JOIN PRODUCT_CATALOG p
CROSS JOIN DISTRIBUTORS d
WHERE a.agency_status = 'ACTIVE'
  AND p.is_active = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 0.3
LIMIT 600000;

-- ============================================================================
-- Step 12: Generate Support Tickets
-- ============================================================================
INSERT INTO SUPPORT_TICKETS
SELECT
    'TKT' || LPAD(SEQ4(), 12, '0') AS ticket_id,
    a.agency_id,
    o.officer_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'Device not syncing with Evidence.com'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'Video playback issues'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'TASER device malfunction'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'Login issues with Evidence.com'
         WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN 'Low battery life on body camera'
         WHEN UNIFORM(0, 100, RANDOM()) < 7 THEN 'Audio not recording properly'
         ELSE ARRAY_CONSTRUCT('Firmware update required', 'Device mounting issue', 'Storage capacity problem', 'Docking station not charging')[UNIFORM(0, 3, RANDOM())]
    END AS subject,
    'Customer reported issue with device. Further investigation needed.' AS description,
    ARRAY_CONSTRUCT('DEVICE_ISSUE', 'SOFTWARE_ISSUE', 'TRAINING_QUESTION', 'BILLING_QUESTION', 'TECHNICAL_SUPPORT')[UNIFORM(0, 4, RANDOM())] AS ticket_category,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')[UNIFORM(0, 3, RANDOM())] AS priority,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'IN_PROGRESS'
         ELSE 'OPEN' END AS ticket_status,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'WEB_PORTAL', 'CHAT')[UNIFORM(0, 3, RANDOM())] AS channel,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS created_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN 
        DATEADD('hour', UNIFORM(1, 24, RANDOM()), DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())))
    ELSE NULL END AS first_response_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 
        DATEADD('day', UNIFORM(1, 14, RANDOM()), DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())))
    ELSE NULL END AS resolution_date,
    'SE' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS assigned_support_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN UNIFORM(3, 5, RANDOM()) ELSE NULL END AS customer_satisfaction_score,
    p.product_id,
    ARRAY_CONSTRUCT('INCIDENT', 'QUESTION', 'PROBLEM', 'REQUEST')[UNIFORM(0, 3, RANDOM())] AS ticket_type,
    UNIFORM(0, 100, RANDOM()) < 10 AS escalated,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM AGENCIES a
JOIN OFFICERS o ON a.agency_id = o.agency_id
CROSS JOIN PRODUCT_CATALOG p
WHERE a.agency_status = 'ACTIVE'
  AND o.officer_status = 'ACTIVE'
  AND p.is_active = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 0.05
LIMIT 75000;

-- ============================================================================
-- Step 13: Generate Quality Issues
-- ============================================================================
INSERT INTO QUALITY_ISSUES
SELECT
    'QI' || LPAD(SEQ4(), 10, '0') AS quality_issue_id,
    a.agency_id,
    p.product_id,
    o.officer_id,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS reported_date,
    ARRAY_CONSTRUCT('DEVICE_FAILURE', 'SOFTWARE_BUG', 'BATTERY_ISSUE', 'RECORDING_FAILURE', 'SYNC_FAILURE', 'MANUFACTURING_DEFECT')[UNIFORM(0, 5, RANDOM())] AS issue_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')[UNIFORM(0, 3, RANDOM())] AS severity,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'Device stopped working during critical incident'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'Recording failed to save to Evidence.com'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'Battery drain faster than expected'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'Device does not power on'
         ELSE 'Intermittent recording failures' END AS description,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'IN_PROGRESS'
         ELSE 'OPEN' END AS investigation_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 
        ARRAY_CONSTRUCT('Hardware failure', 'Software bug', 'User error', 'Environmental factors', 'Manufacturing defect')[UNIFORM(0, 4, RANDOM())]
    ELSE NULL END AS root_cause,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 
        ARRAY_CONSTRUCT('Replaced device', 'Firmware update', 'User training', 'Design modification')[UNIFORM(0, 3, RANDOM())]
    ELSE NULL END AS corrective_action,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 
        ARRAY_CONSTRUCT('Enhanced quality testing', 'Design improvement', 'Updated training materials', 'Process change')[UNIFORM(0, 3, RANDOM())]
    ELSE NULL END AS preventive_action,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 
        DATEADD('day', UNIFORM(7, 90, RANDOM()), DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())))
    ELSE NULL END AS closure_date,
    'SN' || LPAD(UNIFORM(1000000, 9999999, RANDOM()), 7, '0') AS serial_number,
    'RMA-' || UNIFORM(2020, 2025, RANDOM()) || '-' || LPAD(UNIFORM(1, 99999, RANDOM()), 5, '0') AS rma_number,
    UNIFORM(30, 1825, RANDOM()) AS device_age_days,
    ARRAY_CONSTRUCT('HARDWARE', 'SOFTWARE', 'USER_ERROR', 'ENVIRONMENTAL')[UNIFORM(0, 3, RANDOM())] AS issue_category,
    DATEADD('minute', UNIFORM(0, 525600, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM AGENCIES a
JOIN OFFICERS o ON a.agency_id = o.agency_id
CROSS JOIN PRODUCT_CATALOG p
WHERE a.agency_status = 'ACTIVE'
  AND p.is_active = TRUE
  AND p.product_category IN ('CAMERAS', 'WEAPONS')
  AND UNIFORM(0, 100, RANDOM()) < 0.02
LIMIT 20000;

-- ============================================================================
-- Step 14: Generate Agency Campaign Interactions
-- ============================================================================
INSERT INTO AGENCY_CAMPAIGN_INTERACTIONS
SELECT
    'INT' || LPAD(SEQ4(), 12, '0') AS interaction_id,
    a.agency_id,
    c.campaign_id,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), c.start_date) AS interaction_date,
    ARRAY_CONSTRUCT('EMAIL_OPEN', 'EMAIL_CLICK', 'WEBINAR_ATTENDED', 'DEMO_REQUESTED', 'CONTACT_FORM', 'TRADE_SHOW_VISIT')[UNIFORM(0, 5, RANDOM())] AS interaction_type,
    UNIFORM(0, 100, RANDOM()) < 15 AS conversion_flag,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN (UNIFORM(5000, 250000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE 0.00 END AS revenue_generated,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), c.start_date) AS created_at
FROM AGENCIES a
CROSS JOIN MARKETING_CAMPAIGNS c
WHERE a.agency_status = 'ACTIVE'
  AND UNIFORM(0, 100, RANDOM()) < 2
LIMIT 50000;

-- ============================================================================
-- Step 15: Generate Certification Verifications
-- ============================================================================
INSERT INTO CERTIFICATION_VERIFICATIONS
SELECT
    'VER' || LPAD(SEQ4(), 12, '0') AS verification_id,
    c.certification_id,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), c.issue_date) AS verification_date,
    ARRAY_CONSTRUCT('MANUAL_REVIEW', 'AUTOMATED_CHECK', 'THIRD_PARTY_VERIFICATION')[UNIFORM(0, 2, RANDOM())] AS verification_method,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 95 THEN 'VERIFIED' ELSE 'FAILED' END AS verification_status,
    'Verification System' AS verified_by,
    ARRAY_CONSTRUCT('Axon Training Database', 'State Academy Database', 'Third Party Verification')[UNIFORM(0, 2, RANDOM())] AS verification_source,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 
        ARRAY_CONSTRUCT('Verified successfully', 'Manual review required', 'Documentation missing')[UNIFORM(0, 2, RANDOM())]
    ELSE NULL END AS notes,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('year', 1, DATEADD('day', UNIFORM(1, 30, RANDOM()), c.issue_date))
    ELSE NULL END AS next_verification_date,
    CURRENT_TIMESTAMP() AS created_at
FROM CERTIFICATIONS c
WHERE UNIFORM(0, 100, RANDOM()) < 50;

-- ============================================================================
-- Display data generation completion summary
-- ============================================================================
SELECT 'Data generation completed successfully' AS status,
       (SELECT COUNT(*) FROM AGENCIES) AS agencies,
       (SELECT COUNT(*) FROM OFFICERS) AS officers,
       (SELECT COUNT(*) FROM PRODUCT_CATALOG) AS products,
       (SELECT COUNT(*) FROM DEVICE_DEPLOYMENTS) AS deployments,
       (SELECT COUNT(*) FROM EVIDENCE_UPLOADS) AS evidence_uploads,
       (SELECT COUNT(*) FROM ORDERS) AS orders,
       (SELECT COUNT(*) FROM SUPPORT_TICKETS) AS support_tickets,
       (SELECT COUNT(*) FROM QUALITY_ISSUES) AS quality_issues,
       (SELECT COUNT(*) FROM CERTIFICATIONS) AS certifications;

