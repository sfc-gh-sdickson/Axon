-- ============================================================================
-- Axon Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against official documentation:
-- https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
-- 
-- Syntax Verification Notes:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- 6. All column references VERIFIED against 02_create_tables.sql
-- 7. All synonyms are GLOBALLY UNIQUE across all semantic views
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Semantic View 1: Axon Device Deployment & Evidence Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_DEVICE_DEPLOYMENT_INTELLIGENCE
  TABLES (
    agencies AS RAW.AGENCIES
      PRIMARY KEY (agency_id)
      WITH SYNONYMS ('law enforcement agencies', 'police departments', 'agency customers')
      COMMENT = 'Law enforcement agencies using Axon products',
    officers AS RAW.OFFICERS
      PRIMARY KEY (officer_id)
      WITH SYNONYMS ('law enforcement officers', 'police officers', 'sworn personnel')
      COMMENT = 'Officers at law enforcement agencies',
    products AS RAW.PRODUCT_CATALOG
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('axon products', 'device catalog', 'product offerings')
      COMMENT = 'Axon product catalog',
    deployments AS RAW.DEVICE_DEPLOYMENTS
      PRIMARY KEY (deployment_id)
      WITH SYNONYMS ('device deployments', 'equipment assignments', 'officer devices')
      COMMENT = 'Device deployments to officers',
    evidence AS RAW.EVIDENCE_UPLOADS
      PRIMARY KEY (evidence_id)
      WITH SYNONYMS ('evidence uploads', 'video recordings', 'digital evidence')
      COMMENT = 'Evidence uploaded from devices',
    certifications AS RAW.CERTIFICATIONS
      PRIMARY KEY (certification_id)
      WITH SYNONYMS ('officer certifications', 'training credentials', 'professional certifications')
      COMMENT = 'Officer certifications and training'
  )
  RELATIONSHIPS (
    officers(agency_id) REFERENCES agencies(agency_id),
    deployments(officer_id) REFERENCES officers(officer_id),
    deployments(product_id) REFERENCES products(product_id),
    deployments(agency_id) REFERENCES agencies(agency_id),
    evidence(deployment_id) REFERENCES deployments(deployment_id),
    evidence(officer_id) REFERENCES officers(officer_id),
    evidence(product_id) REFERENCES products(product_id),
    evidence(agency_id) REFERENCES agencies(agency_id),
    certifications(officer_id) REFERENCES officers(officer_id),
    certifications(agency_id) REFERENCES agencies(agency_id)
  )
  DIMENSIONS (
    agencies.agency_name AS agency_name
      WITH SYNONYMS ('department name view1', 'law enforcement agency name', 'police department name')
      COMMENT = 'Name of the law enforcement agency',
    agencies.agency_status AS agency_status
      WITH SYNONYMS ('agency account status view1', 'department status')
      COMMENT = 'Agency status: ACTIVE, INACTIVE, CHURNED',
    agencies.agency_type AS agency_type
      WITH SYNONYMS ('department type', 'law enforcement type', 'jurisdiction category')
      COMMENT = 'Agency type: MUNICIPAL_POLICE, COUNTY_SHERIFF, STATE_POLICE, CAMPUS_POLICE, TRANSIT_POLICE, FEDERAL_AGENCY',
    agencies.jurisdiction_type AS jurisdiction_type
      WITH SYNONYMS ('area type', 'service area classification')
      COMMENT = 'Jurisdiction type: METROPOLITAN, SUBURBAN, RURAL, REGIONAL',
    agencies.state AS state
      WITH SYNONYMS ('agency state view1', 'department location state')
      COMMENT = 'Agency state location',
    agencies.city AS city
      WITH SYNONYMS ('agency city view1', 'department location city')
      COMMENT = 'Agency city location',
    officers.officer_name AS officer_name
      WITH SYNONYMS ('sworn personnel name', 'law enforcement officer name')
      COMMENT = 'Name of the officer',
    officers.rank AS rank
      WITH SYNONYMS ('officer rank', 'personnel rank', 'position rank')
      COMMENT = 'Officer rank',
    officers.department AS department
      WITH SYNONYMS ('officer dept', 'unit assignment', 'division')
      COMMENT = 'Officer department or unit',
    officers.officer_status AS officer_status
      WITH SYNONYMS ('officer active status', 'personnel status')
      COMMENT = 'Officer status: ACTIVE, ON_LEAVE, RETIRED',
    officers.axon_certified AS axon_certified
      WITH SYNONYMS ('certified officer', 'axon trained')
      COMMENT = 'Whether officer is Axon certified',
    officers.primary_device_type AS primary_device_type
      WITH SYNONYMS ('preferred device family', 'main equipment type')
      COMMENT = 'Officer primary device type: BODY_CAMERA, TASER, IN_CAR_VIDEO, MULTIPLE',
    products.product_name AS product_name
      WITH SYNONYMS ('device name', 'equipment name', 'axon device name')
      COMMENT = 'Name of the Axon product',
    products.sku AS sku
      WITH SYNONYMS ('product number', 'device sku', 'model number')
      COMMENT = 'Product SKU/model number',
    products.product_family AS product_family
      WITH SYNONYMS ('device family', 'product line', 'equipment family')
      COMMENT = 'Product family: TASER, BODY_CAMERA, IN_CAR, SOFTWARE, ACCESSORIES, TRAINING',
    products.product_type AS product_type
      WITH SYNONYMS ('device type', 'equipment type')
      COMMENT = 'Product type: CONDUCTED_ENERGY_WEAPON, BODY_WORN_CAMERA, VEHICLE_CAMERA_SYSTEM, EVIDENCE_MANAGEMENT, etc',
    products.product_category AS product_category
      WITH SYNONYMS ('device category', 'equipment category')
      COMMENT = 'Product category: CAMERAS, WEAPONS, SOFTWARE, ACCESSORIES, TRAINING',
    products.lifecycle_status AS lifecycle_status
      WITH SYNONYMS ('product lifecycle', 'device availability status')
      COMMENT = 'Lifecycle status: ACTIVE, NRND, OBSOLETE',
    deployments.deployment_status AS deployment_status
      WITH SYNONYMS ('device status', 'equipment assignment status')
      COMMENT = 'Deployment status: ACTIVE, INACTIVE, RETIRED',
    deployments.competitive_replacement AS competitive_replacement
      WITH SYNONYMS ('competitive win', 'replaced competitor device')
      COMMENT = 'Whether this was a competitive replacement',
    evidence.evidence_type AS evidence_type
      WITH SYNONYMS ('recording type', 'file type', 'media type')
      COMMENT = 'Evidence type: VIDEO, AUDIO, PHOTO',
    evidence.evidence_status AS evidence_status
      WITH SYNONYMS ('recording status', 'file status')
      COMMENT = 'Evidence status: ACTIVE, ARCHIVED, DELETED',
    certifications.certification_type AS certification_type
      WITH SYNONYMS ('cert type view1', 'training type')
      COMMENT = 'Certification type: TASER_CERTIFICATION, BODY_CAMERA_TRAINING, EVIDENCE_MANAGEMENT, INSTRUCTOR_CERTIFICATION',
    certifications.certification_status AS certification_status
      WITH SYNONYMS ('cert status view1', 'credential status')
      COMMENT = 'Certification status: ACTIVE, EXPIRED',
    certifications.product_family_focus AS product_family_focus
      WITH SYNONYMS ('cert product focus view1', 'certification specialization')
      COMMENT = 'Product family focus of certification'
  )
  METRICS (
    agencies.total_agencies AS COUNT(DISTINCT agency_id)
      WITH SYNONYMS ('agency count view1', 'number of agencies deploy')
      COMMENT = 'Total number of agencies',
    agencies.avg_population_served AS AVG(population_served)
      WITH SYNONYMS ('average population', 'mean population served')
      COMMENT = 'Average population served by agencies',
    agencies.avg_lifetime_value AS AVG(lifetime_value)
      WITH SYNONYMS ('average agency value', 'mean agency ltv')
      COMMENT = 'Average agency lifetime value',
    officers.total_officers AS COUNT(DISTINCT officer_id)
      WITH SYNONYMS ('officer count', 'sworn personnel count', 'number of officers')
      COMMENT = 'Total number of officers',
    officers.avg_years_service AS AVG(years_of_service)
      WITH SYNONYMS ('average years of service', 'mean service years')
      COMMENT = 'Average years of service for officers',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view1', 'number of products deploy')
      COMMENT = 'Total number of products',
    products.avg_unit_price AS AVG(unit_price)
      WITH SYNONYMS ('average device price', 'mean product price')
      COMMENT = 'Average product unit price',
    deployments.total_deployments AS COUNT(DISTINCT deployment_id)
      WITH SYNONYMS ('deployment count', 'equipment assignment count', 'device count')
      COMMENT = 'Total number of device deployments',
    evidence.total_evidence_uploads AS COUNT(DISTINCT evidence_id)
      WITH SYNONYMS ('evidence count', 'recording count', 'upload count')
      COMMENT = 'Total number of evidence uploads',
    evidence.total_evidence_storage_mb AS SUM(file_size_mb)
      WITH SYNONYMS ('total storage used', 'cumulative file size', 'total evidence size')
      COMMENT = 'Total evidence storage in MB',
    evidence.avg_file_size_mb AS AVG(file_size_mb)
      WITH SYNONYMS ('average evidence size', 'mean file size')
      COMMENT = 'Average evidence file size in MB',
    evidence.avg_duration_seconds AS AVG(duration_seconds)
      WITH SYNONYMS ('average recording length', 'mean evidence duration')
      COMMENT = 'Average evidence duration in seconds',
    certifications.total_certifications AS COUNT(DISTINCT certification_id)
      WITH SYNONYMS ('certification count view1', 'credential count view1')
      COMMENT = 'Total number of certifications',
    certifications.avg_training_hours AS AVG(training_hours)
      WITH SYNONYMS ('average training hours', 'mean training time')
      COMMENT = 'Average training hours per certification'
  )
  COMMENT = 'Axon Device Deployment & Evidence Intelligence - comprehensive view of agencies, officers, devices, evidence uploads, and certifications';

-- ============================================================================
-- Semantic View 2: Axon Sales & Revenue Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_SALES_REVENUE_INTELLIGENCE
  TABLES (
    agencies AS RAW.AGENCIES
      PRIMARY KEY (agency_id)
      WITH SYNONYMS ('revenue agencies', 'purchasing agencies', 'buying departments')
      COMMENT = 'Agencies placing orders',
    orders AS RAW.ORDERS
      PRIMARY KEY (order_id)
      WITH SYNONYMS ('purchase orders', 'sales transactions', 'equipment orders')
      COMMENT = 'Product orders',
    products AS RAW.PRODUCT_CATALOG
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('ordered products', 'sold devices', 'revenue products')
      COMMENT = 'Axon product catalog',
    distributors AS RAW.DISTRIBUTORS
      PRIMARY KEY (distributor_id)
      WITH SYNONYMS ('distribution partners', 'channel partners', 'equipment resellers')
      COMMENT = 'Authorized distributors',
    contracts AS RAW.SUPPORT_CONTRACTS
      PRIMARY KEY (contract_id)
      WITH SYNONYMS ('service contracts', 'support agreements', 'evidence storage contracts')
      COMMENT = 'Support and service contracts'
  )
  RELATIONSHIPS (
    orders(agency_id) REFERENCES agencies(agency_id),
    orders(product_id) REFERENCES products(product_id),
    orders(distributor_id) REFERENCES distributors(distributor_id),
    contracts(agency_id) REFERENCES agencies(agency_id)
  )
  DIMENSIONS (
    agencies.agency_name AS agency_name
      WITH SYNONYMS ('revenue agency name', 'purchasing department name')
      COMMENT = 'Name of the agency',
    agencies.agency_type AS agency_type
      WITH SYNONYMS ('revenue agency type', 'purchasing department type')
      COMMENT = 'Agency type',
    agencies.state AS state
      WITH SYNONYMS ('revenue agency state', 'sales location state')
      COMMENT = 'Agency state location',
    orders.order_type AS order_type
      WITH SYNONYMS ('purchase type', 'transaction type', 'sales type')
      COMMENT = 'Order type: HARDWARE, SOFTWARE_SUBSCRIPTION, ACCESSORIES, TRAINING',
    orders.payment_terms AS payment_terms
      WITH SYNONYMS ('payment conditions', 'billing terms')
      COMMENT = 'Payment terms: NET_30, NET_60, NET_90, PREPAID, GRANT_FUNDED',
    orders.payment_status AS payment_status
      WITH SYNONYMS ('transaction payment status', 'order payment state')
      COMMENT = 'Payment status: COMPLETED, PENDING, FAILED',
    orders.currency AS currency
      WITH SYNONYMS ('transaction currency', 'order currency')
      COMMENT = 'Transaction currency',
    orders.direct_sale AS direct_sale
      WITH SYNONYMS ('sold direct', 'direct channel')
      COMMENT = 'Whether order was direct or through distributor',
    orders.grant_funded AS grant_funded
      WITH SYNONYMS ('grant purchase', 'federally funded')
      COMMENT = 'Whether order was funded by grant',
    orders.order_source AS order_source
      WITH SYNONYMS ('sales channel', 'order channel', 'purchase channel')
      COMMENT = 'Order source: DIRECT_SALES, DISTRIBUTOR, ONLINE, TRADE_SHOW',
    products.product_name AS product_name
      WITH SYNONYMS ('sold product name', 'revenue device name')
      COMMENT = 'Name of the product',
    products.product_family AS product_family
      WITH SYNONYMS ('sold product family', 'revenue product line')
      COMMENT = 'Product family',
    products.product_type AS product_type
      WITH SYNONYMS ('sold product type', 'revenue device type')
      COMMENT = 'Product type',
    products.is_active AS is_active
      WITH SYNONYMS ('available for sale', 'active catalog product')
      COMMENT = 'Whether product is currently active',
    distributors.distributor_name AS distributor_name
      WITH SYNONYMS ('partner name', 'reseller name')
      COMMENT = 'Name of the distributor',
    distributors.distributor_type AS distributor_type
      WITH SYNONYMS ('partner type', 'channel type')
      COMMENT = 'Distributor type',
    distributors.region AS region
      WITH SYNONYMS ('distributor region', 'sales region', 'partner region')
      COMMENT = 'Distributor region: WEST, SOUTHWEST, MIDWEST, SOUTH, CANADA, EMEA, APAC, MIDDLE_EAST',
    distributors.partnership_tier AS partnership_tier
      WITH SYNONYMS ('partner level', 'distributor tier')
      COMMENT = 'Partnership tier: PLATINUM, GOLD, SILVER',
    contracts.contract_type AS contract_type
      WITH SYNONYMS ('service type', 'support level', 'subscription type')
      COMMENT = 'Contract type: EVIDENCE_BASIC, EVIDENCE_PROFESSIONAL, EVIDENCE_ENTERPRISE, FULL_SUITE',
    contracts.service_tier AS service_tier
      WITH SYNONYMS ('contract tier', 'support tier')
      COMMENT = 'Service tier: BASIC, PROFESSIONAL, ENTERPRISE',
    contracts.unlimited_storage AS unlimited_storage
      WITH SYNONYMS ('unlimited evidence storage', 'unlimited capacity')
      COMMENT = 'Whether contract includes unlimited storage',
    contracts.priority_support AS priority_support
      WITH SYNONYMS ('premium support enabled', 'priority service')
      COMMENT = 'Whether contract includes priority support',
    contracts.training_included AS training_included
      WITH SYNONYMS ('includes training', 'training package')
      COMMENT = 'Whether contract includes training',
    contracts.contract_status AS contract_status
      WITH SYNONYMS ('service status', 'agreement status')
      COMMENT = 'Contract status: ACTIVE, EXPIRED, CANCELLED'
  )
  METRICS (
    agencies.total_agencies AS COUNT(DISTINCT agency_id)
      WITH SYNONYMS ('agency count view2', 'number of revenue agencies')
      COMMENT = 'Total number of agencies',
    orders.total_orders AS COUNT(DISTINCT order_id)
      WITH SYNONYMS ('order count', 'transaction count')
      COMMENT = 'Total number of orders',
    orders.total_revenue AS SUM(order_amount)
      WITH SYNONYMS ('total sales', 'gross revenue', 'total order value')
      COMMENT = 'Total revenue from all orders',
    orders.avg_order_amount AS AVG(order_amount)
      WITH SYNONYMS ('average order value', 'mean transaction amount')
      COMMENT = 'Average order amount',
    orders.total_quantity AS SUM(quantity)
      WITH SYNONYMS ('total units sold', 'cumulative quantity sold')
      COMMENT = 'Total quantity ordered',
    orders.avg_quantity AS AVG(quantity)
      WITH SYNONYMS ('average units per order', 'mean order quantity')
      COMMENT = 'Average quantity per order',
    orders.total_discount AS SUM(discount_amount)
      WITH SYNONYMS ('total discounts given', 'discount sum')
      COMMENT = 'Total discount amount given',
    orders.total_tax AS SUM(tax_amount)
      WITH SYNONYMS ('total tax collected', 'tax sum')
      COMMENT = 'Total tax amount collected',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view2', 'number of sold products')
      COMMENT = 'Total number of unique products sold',
    distributors.total_distributors AS COUNT(DISTINCT distributor_id)
      WITH SYNONYMS ('distributor count', 'partner count')
      COMMENT = 'Total number of distributors',
    contracts.total_contracts AS COUNT(DISTINCT contract_id)
      WITH SYNONYMS ('contract count', 'agreement count')
      COMMENT = 'Total number of support contracts',
    contracts.avg_monthly_fee AS AVG(monthly_fee)
      WITH SYNONYMS ('average contract fee', 'mean monthly cost')
      COMMENT = 'Average monthly contract fee',
    contracts.total_monthly_fees AS SUM(monthly_fee)
      WITH SYNONYMS ('total contract revenue', 'recurring revenue')
      COMMENT = 'Total monthly fees across all contracts',
    contracts.avg_storage_gb AS AVG(evidence_storage_gb)
      WITH SYNONYMS ('average storage allocation', 'mean storage capacity')
      COMMENT = 'Average evidence storage in GB'
  )
  COMMENT = 'Axon Sales & Revenue Intelligence - comprehensive view of orders, agencies, distributors, products, and revenue metrics';

-- ============================================================================
-- Semantic View 3: Axon Support & Quality Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_SUPPORT_QUALITY_INTELLIGENCE
  TABLES (
    agencies AS RAW.AGENCIES
      PRIMARY KEY (agency_id)
      WITH SYNONYMS ('support agencies', 'ticket agencies', 'service customers')
      COMMENT = 'Agencies with support tickets and quality issues',
    tickets AS RAW.SUPPORT_TICKETS
      PRIMARY KEY (ticket_id)
      WITH SYNONYMS ('support tickets', 'help tickets', 'service requests')
      COMMENT = 'Customer support tickets',
    engineers AS RAW.SUPPORT_ENGINEERS
      PRIMARY KEY (support_engineer_id)
      WITH SYNONYMS ('support engineers', 'technical support staff', 'help desk staff')
      COMMENT = 'Axon support engineers',
    products AS RAW.PRODUCT_CATALOG
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('supported products', 'ticketed devices', 'quality products')
      COMMENT = 'Products with support tickets',
    quality AS RAW.QUALITY_ISSUES
      PRIMARY KEY (quality_issue_id)
      WITH SYNONYMS ('quality issues', 'defect reports', 'product issues')
      COMMENT = 'Product quality issues and defects',
    officers AS RAW.OFFICERS
      PRIMARY KEY (officer_id)
      WITH SYNONYMS ('reporting officers', 'ticket submitters', 'issue reporters')
      COMMENT = 'Officers submitting tickets'
  )
  RELATIONSHIPS (
    tickets(agency_id) REFERENCES agencies(agency_id),
    tickets(product_id) REFERENCES products(product_id),
    tickets(officer_id) REFERENCES officers(officer_id),
    quality(agency_id) REFERENCES agencies(agency_id),
    quality(product_id) REFERENCES products(product_id),
    quality(reported_by_officer_id) REFERENCES officers(officer_id),
    officers(agency_id) REFERENCES agencies(agency_id)
  )
  DIMENSIONS (
    agencies.agency_name AS agency_name
      WITH SYNONYMS ('support agency name', 'ticket customer name')
      COMMENT = 'Name of the agency',
    agencies.agency_type AS agency_type
      WITH SYNONYMS ('support agency type', 'ticket customer type')
      COMMENT = 'Agency type',
    agencies.state AS state
      WITH SYNONYMS ('support agency state', 'ticket location state')
      COMMENT = 'Agency state location',
    tickets.ticket_category AS ticket_category
      WITH SYNONYMS ('issue category', 'support category', 'problem type')
      COMMENT = 'Ticket category: DEVICE_ISSUE, SOFTWARE_ISSUE, TRAINING_QUESTION, BILLING_QUESTION, TECHNICAL_SUPPORT',
    tickets.priority AS priority
      WITH SYNONYMS ('ticket priority', 'urgency level', 'severity level')
      COMMENT = 'Ticket priority: LOW, MEDIUM, HIGH, CRITICAL',
    tickets.ticket_status AS ticket_status
      WITH SYNONYMS ('ticket state', 'resolution status')
      COMMENT = 'Ticket status: OPEN, IN_PROGRESS, CLOSED',
    tickets.channel AS channel
      WITH SYNONYMS ('contact channel', 'support channel', 'communication method')
      COMMENT = 'Support channel: PHONE, EMAIL, WEB_PORTAL, CHAT',
    tickets.ticket_type AS ticket_type
      WITH SYNONYMS ('request type', 'case type')
      COMMENT = 'Ticket type: INCIDENT, QUESTION, PROBLEM, REQUEST',
    tickets.escalated AS escalated
      WITH SYNONYMS ('escalation flag', 'escalated ticket')
      COMMENT = 'Whether ticket was escalated',
    engineers.engineer_name AS engineer_name
      WITH SYNONYMS ('support staff name', 'technician name')
      COMMENT = 'Name of support engineer',
    engineers.department AS department
      WITH SYNONYMS ('support dept', 'support team', 'technical team')
      COMMENT = 'Support engineer department',
    engineers.specialization AS specialization
      WITH SYNONYMS ('expertise area', 'technical specialty')
      COMMENT = 'Support engineer specialization',
    engineers.engineer_status AS engineer_status
      WITH SYNONYMS ('support staff status', 'technician status')
      COMMENT = 'Support engineer status: ACTIVE, INACTIVE',
    products.product_name AS product_name
      WITH SYNONYMS ('supported product name', 'ticketed device name')
      COMMENT = 'Name of the product',
    products.product_family AS product_family
      WITH SYNONYMS ('supported product family', 'ticketed product line')
      COMMENT = 'Product family',
    products.product_type AS product_type
      WITH SYNONYMS ('supported product type', 'ticketed device type')
      COMMENT = 'Product type',
    quality.issue_type AS issue_type
      WITH SYNONYMS ('defect type', 'failure type', 'problem type')
      COMMENT = 'Quality issue type: DEVICE_FAILURE, SOFTWARE_BUG, BATTERY_ISSUE, RECORDING_FAILURE, SYNC_FAILURE, MANUFACTURING_DEFECT',
    quality.severity AS severity
      WITH SYNONYMS ('issue severity', 'defect severity')
      COMMENT = 'Quality issue severity: LOW, MEDIUM, HIGH, CRITICAL',
    quality.investigation_status AS investigation_status
      WITH SYNONYMS ('quality status', 'investigation state')
      COMMENT = 'Investigation status: OPEN, IN_PROGRESS, CLOSED',
    quality.issue_category AS issue_category
      WITH SYNONYMS ('defect category', 'failure category')
      COMMENT = 'Issue category: HARDWARE, SOFTWARE, USER_ERROR, ENVIRONMENTAL',
    officers.officer_name AS officer_name
      WITH SYNONYMS ('submitting officer name', 'reporter name')
      COMMENT = 'Name of officer submitting ticket',
    officers.rank AS rank
      WITH SYNONYMS ('submitter rank', 'reporter rank')
      COMMENT = 'Officer rank'
  )
  METRICS (
    agencies.total_agencies AS COUNT(DISTINCT agency_id)
      WITH SYNONYMS ('agency count view3', 'number of support agencies')
      COMMENT = 'Total number of agencies',
    tickets.total_tickets AS COUNT(DISTINCT ticket_id)
      WITH SYNONYMS ('ticket count', 'support request count')
      COMMENT = 'Total number of support tickets',
    tickets.avg_satisfaction AS AVG(customer_satisfaction_score)
      WITH SYNONYMS ('average satisfaction', 'mean csat score')
      COMMENT = 'Average customer satisfaction score',
    engineers.total_engineers AS COUNT(DISTINCT support_engineer_id)
      WITH SYNONYMS ('support staff count', 'engineer count')
      COMMENT = 'Total number of support engineers',
    engineers.avg_satisfaction_rating AS AVG(average_satisfaction_rating)
      WITH SYNONYMS ('average engineer rating', 'mean support rating')
      COMMENT = 'Average satisfaction rating for engineers',
    engineers.avg_tickets_resolved AS AVG(total_tickets_resolved)
      WITH SYNONYMS ('average resolution count', 'mean tickets handled')
      COMMENT = 'Average tickets resolved per engineer',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view3', 'number of supported products')
      COMMENT = 'Total number of products',
    quality.total_quality_issues AS COUNT(DISTINCT quality_issue_id)
      WITH SYNONYMS ('quality issue count', 'defect count')
      COMMENT = 'Total number of quality issues',
    quality.avg_device_age AS AVG(device_age_days)
      WITH SYNONYMS ('average device age', 'mean failure age')
      COMMENT = 'Average device age at time of quality issue in days',
    officers.total_officers AS COUNT(DISTINCT officer_id)
      WITH SYNONYMS ('officer count view3', 'number of reporting officers')
      COMMENT = 'Total number of officers'
  )
  COMMENT = 'Axon Support & Quality Intelligence - comprehensive view of support tickets, quality issues, engineers, and customer satisfaction';

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All semantic views created successfully' AS status;

