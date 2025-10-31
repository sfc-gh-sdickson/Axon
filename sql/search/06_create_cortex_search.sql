-- ============================================================================
-- Axon Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, policy documents, and incident reports
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
-- ============================================================================

USE DATABASE AXON_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE AXON_WH;

-- ============================================================================
-- Step 1: Create table for support transcripts (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TRANSCRIPTS (
    transcript_id VARCHAR(30) PRIMARY KEY,
    ticket_id VARCHAR(30),
    agency_id VARCHAR(20),
    support_engineer_id VARCHAR(20),
    transcript_text VARCHAR(16777216) NOT NULL,
    interaction_type VARCHAR(50),
    interaction_date TIMESTAMP_NTZ NOT NULL,
    product_family VARCHAR(50),
    issue_category VARCHAR(50),
    resolution_provided BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ticket_id) REFERENCES SUPPORT_TICKETS(ticket_id),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (support_engineer_id) REFERENCES SUPPORT_ENGINEERS(support_engineer_id)
);

-- ============================================================================
-- Step 2: Create table for policy documents
-- ============================================================================
CREATE OR REPLACE TABLE POLICY_DOCUMENTS (
    policy_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    product_family VARCHAR(50),
    document_category VARCHAR(50),
    document_number VARCHAR(50),
    revision VARCHAR(20),
    tags VARCHAR(500),
    author VARCHAR(100),
    publish_date DATE,
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    download_count NUMBER(10,0) DEFAULT 0,
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 3: Create table for incident reports
-- ============================================================================
CREATE OR REPLACE TABLE INCIDENT_REPORTS (
    incident_report_id VARCHAR(30) PRIMARY KEY,
    quality_issue_id VARCHAR(30),
    agency_id VARCHAR(20),
    product_id VARCHAR(30),
    report_text VARCHAR(16777216) NOT NULL,
    incident_type VARCHAR(50),
    incident_status VARCHAR(30),
    findings_summary VARCHAR(5000),
    recommendations VARCHAR(5000),
    report_date TIMESTAMP_NTZ NOT NULL,
    investigated_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (quality_issue_id) REFERENCES QUALITY_ISSUES(quality_issue_id),
    FOREIGN KEY (agency_id) REFERENCES AGENCIES(agency_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id)
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE SUPPORT_TRANSCRIPTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE POLICY_DOCUMENTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE INCIDENT_REPORTS SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample support transcripts
-- ============================================================================
INSERT INTO SUPPORT_TRANSCRIPTS
SELECT
    'TRANS' || LPAD(SEQ4(), 10, '0') AS transcript_id,
    st.ticket_id,
    st.agency_id,
    st.assigned_support_id AS support_engineer_id,
    CASE (ABS(RANDOM()) % 15)
        WHEN 0 THEN 'Support Call - Body Camera Sync Issue. Officer: Hi, my Axon Body 3 is not syncing with the docking station. Support: Let me help troubleshoot that. Can you tell me if you see any lights on the camera when docked? Officer: The red light blinks twice then goes solid. Support: That indicates the camera is charging but not establishing a data connection. First, make sure you are using an Axon-certified dock and the latest firmware. Officer: We are using the official Axon Dock. How do I check firmware? Support: On the camera, press the Event button twice quickly to view firmware version on the screen. Officer: It shows version 2.1.8. Support: That is an older version. The current is 3.2.1 which fixes sync issues. I will email you the firmware update tool. Download it, connect your camera via USB, and follow the update wizard. After updating, the sync should work properly. Officer: Perfect, I will do that today. Support: Also, make sure Evidence.com is not in maintenance mode during sync attempts. You can check status at status.evidence.com. Officer: Good to know. Thanks for the help!'
        WHEN 1 THEN 'Email Thread - TASER 7 Battery Question. From Officer: Our TASER 7 devices are showing low battery warnings after only 2 weeks. We were told these batteries last 6 months. What is wrong? Support Response: The TASER 7 has two battery packs - one for the cartridge deployment and one for the handle electronics. The 6-month specification applies to standby mode with minimal use. If you are conducting frequent training deployments or live-fire incidents, battery life will be shorter. From Officer: We do weekly training. Is that too much? Support: Weekly training is fine, but each deployment uses significant battery. I recommend: 1) Use training cartridges which have lower deployment energy, 2) Rotate devices so not all are used every week, 3) Keep spare battery packs charged and ready. The handle battery is rechargeable via micro-USB. Charge overnight once per month. From Officer: We have been using live cartridges for training! That explains it. Support: Yes, please switch to the blue-tipped training cartridges (part TASER7-TRAIN). They cost less and preserve battery life while providing realistic training. Your agency should have received training cartridges with the original order.'
        WHEN 2 THEN 'Chat - Evidence.com Storage Question. User: We are approaching our storage limit. What happens if we run out? Support: When you reach 90% capacity, administrators receive email warnings. At 100%, you cannot upload new evidence until space is freed or your plan is upgraded. User: Can we delete old cases? Support: Yes, but only cases past retention requirements. Check your agency retention policy first. Evidence.com has bulk archiving tools to move old cases to long-term archive storage, which counts toward your limit but at a reduced rate. User: How do we upgrade our plan? Support: I can help with that. Let me pull up your account... You are currently on the Professional plan with 5TB. The Enterprise plan offers unlimited storage. Would you like me to send upgrade pricing? User: Yes please, and what is the pricing difference? Support: Your current plan is $199/month. Enterprise with unlimited storage is $499/month. The upgrade is prorated and takes effect immediately. User: Let me check with our budget officer and get back to you. Support: No problem! I am sending you a quote via email now. It is valid for 30 days. You can also speak with your account manager about grant funding options that many agencies use.'
        WHEN 3 THEN 'Phone Support - Axon Fleet 3 Installation Issue. Officer: We just installed Axon Fleet 3 in our patrol vehicles but the front camera is not recording. Support: Okay, let me walk you through some diagnostics. First, can you tell me if the power LED on the Fleet control box is lit? Officer: Yes, it is solid green. Support: Good, that means the system has power and is booted. Now check the front camera - is there an LED visible on the camera housing? Officer: I see a small red LED that is off. Support: That LED should be green when the camera is active. The camera may not be receiving power. Let me have you check the connection. Behind the rearview mirror, locate the camera module and ensure the cable is fully seated in the connector. Officer: Found it. The cable was not pushed in all the way! Support: That is a common issue during installation. Push it in until you hear a click. Officer: Done. Now the LED is green! Support: Perfect! Start the vehicle and the system should begin recording within 30 seconds. You can verify by checking the Fleet screen - it should show two camera previews. Officer: Both cameras are showing up now. Excellent! Support: Great! One more tip - in the Fleet settings, make sure automatic upload is enabled so footage transfers to Evidence.com when you return to the station and connect to WiFi. Officer: Will do. Thanks for the quick help!'
        WHEN 4 THEN 'Email - Body Camera Policy Configuration. From Administrator: We need to configure our body cameras to start recording automatically when an officer exits the vehicle. Is this possible? Support Response: Yes, the Axon Body 3 and Body 4 support automatic recording triggers. This feature requires three components: 1) Axon Fleet in-car system, 2) Axon View XL (management software), and 3) proper trigger configuration. Here is how to set it up: In Axon View XL, navigate to Agency Settings > Recording Policies > Auto-Activation. Enable "Record on Fleet Event" and select "Vehicle Door Open" as the trigger. You can also add other triggers like "Vehicle Speed Exceeds Threshold" or "Emergency Lights Activated". From Administrator: That is exactly what we need. Does this work with our older Axon Body 2 cameras? Support: Unfortunately, auto-activation from Fleet requires Body 3 or newer due to the Bluetooth connection requirement. Body 2 cameras must be manually activated. However, Body 2 cameras can be set to pre-event buffer mode which captures 30 seconds before manual activation. From Administrator: Okay, we will upgrade our remaining Body 2 units. Can you send upgrade pricing? Support: Sending now. I am also including information about our trade-in program which offers $150 credit per Body 2 unit toward Body 3 or Body 4 purchases.'
        WHEN 5 THEN 'Support Ticket - TASER Certification Training Question. User: Our new officers need TASER 7 certification but we only have one Master Instructor. Can Axon provide additional training? Axon Response: Yes! Axon offers several training options: 1) Virtual Instructor-Led Training (VILT) - our instructors conduct live online certification courses, 2) On-site Training - we send an instructor to your agency, or 3) Instructor Development - we certify additional officers as Master Instructors. For your situation with new officers, I recommend VILT. It is scheduled monthly and costs $299 per officer including course materials and certification card. Officers must pass written and practical assessments. User: How long is the training? Response: TASER 7 certification is 8 hours including classroom instruction, hands-on practice with training cartridges, and qualification. Officers should plan for a full day. The course covers proper deployment, de-escalation techniques, legal considerations, probe spread patterns, and maintenance. We also cover scenario-based training and use-of-force policy compliance. User: Perfect. Can we schedule a class for 12 officers next month? Response: Absolutely! I am checking availability now... We have openings on March 15th and March 22nd. Which works better for your schedule? User: March 15th is ideal. Response: You are booked! I am sending a calendar invite and pre-course materials. Officers should review the TASER 7 operator manual before class. We will ship training cartridges to your agency 5 days before the course.'
        WHEN 6 THEN 'Chat Support - Evidence.com Login Issues. User: Multiple officers cannot log into Evidence.com. They get "Invalid Credentials" errors. Support: Let me check the agency status... I am seeing your agency was migrated to Single Sign-On (SSO) last week. Are your officers trying to log in with their old Evidence.com passwords? User: Yes, we were not aware of any changes. Support: My apologies for the communication gap. With SSO enabled, officers now log in using their agency credentials (the same username/password they use for your department systems). The old Evidence.com passwords are no longer valid. User: That makes sense. How do we set this up for each officer? Support: Your IT administrator needs to provision users through the SSO integration. The SSO settings page is under Admin > Security > Single Sign-On in Evidence.com. I am sending your admin a setup guide now. User: Our IT person is on vacation this week. Can we temporarily disable SSO? Support: Yes, I can roll back to password authentication until your IT admin can complete the SSO configuration. This will restore access with the original passwords. However, I recommend completing SSO setup soon as it provides better security and user experience. User: Please do the rollback. We will complete SSO setup when IT returns. Support: Done! SSO is disabled. Officers can log in with their original Evidence.com passwords now. I have flagged your account for IT follow-up next week. User: Thank you for the quick resolution!'
        WHEN 7 THEN 'Phone Call - Axon Body 4 Storage Capacity Question. Officer: How many hours of video can the Axon Body 4 record before the storage is full? Support: The Body 4 comes in 64GB and 128GB models. The 64GB model can store approximately 70 hours of HD video, while the 128GB model stores around 140 hours. The actual capacity depends on video quality settings. Officer: We are set to 1080p resolution. Does that match those estimates? Support: Yes, those estimates are based on 1080p at 30fps with high-quality audio. If you switch to 720p, you can store about 50% more footage. However, I recommend keeping 1080p for evidence quality. Officer: What happens when the camera fills up? Support: When storage reaches 90%, the camera displays a warning. At 100%, the camera will stop recording new events. That is why regular docking and upload to Evidence.com is critical. Officer: We dock daily but some officers work 12-hour shifts. Is that enough capacity? Support: For 12-hour shifts with average use (10-15 incidents per shift, 5-10 minutes each), you should be fine with the 64GB model. If officers are in high-activity areas and recording continuously, consider the 128GB model or mid-shift docking during lunch breaks. Officer: That is reassuring. One more question - can we expand the storage with a memory card? Support: No, the storage is internal and non-expandable for security and evidence integrity reasons. The camera is designed to be docked daily which transfers footage to Evidence.com and clears local storage. Officer: Makes sense. Thanks!'
        WHEN 8 THEN 'Email Thread - Fleet 3 GPS Accuracy Issues. From Agency Admin: Our Axon Fleet 3 GPS locations are sometimes inaccurate by several blocks. Officers report that the map shows them in the wrong location. Is this a hardware problem? Support Response: GPS accuracy depends on several factors: satellite visibility, urban canyon effects (tall buildings), and antenna placement. Fleet 3 has an external GPS antenna that should be mounted with clear sky view. From Admin: Our installer placed the antenna under the dashboard. Could that be the issue? Support: Absolutely! The GPS antenna must be mounted outside the vehicle, typically on the roof or rear package shelf with view of the sky. Metal and the dashboard will block satellite signals. I recommend relocating the antenna to the roof using the magnetic mount included with Fleet 3. From Admin: We have 45 vehicles. Will we need to re-install all of them? Support: Unfortunately yes, for optimal GPS performance. The good news is it is a simple move - the antenna has a long cable and magnetic mount for easy repositioning. Your installer should handle this at no charge if they did not follow installation guidelines. I am sending you the installation manual highlighting the correct antenna placement. From Admin: I will contact our installer immediately. Any other tips for GPS accuracy? Support: Yes - after relocating antennas, allow 5 minutes after vehicle start for GPS to acquire satellites. Also, in parking garages or tunnels, GPS will be unavailable but should recover quickly when outdoors. The system also logs last known position which helps with temporary signal loss. From Admin: Very helpful. I appreciate the detailed explanation!'
        WHEN 9 THEN 'Support Call - Evidence Sharing with District Attorney. Officer: We need to share evidence with the DA office for a case going to trial. What is the best way to do this? Support: Evidence.com has a secure sharing feature specifically for this purpose. Navigate to the case in Evidence.com, click Share, and select External Share. Enter the DA email address and set permission level. Officer: What permission level should I choose? Support: For DA offices, select "View Only" which allows them to watch videos and view documents but not download or edit. If they need to download for court presentations, select "View and Download". You can also set an expiration date for the share link. Officer: Does the DA need an Evidence.com account? Support: No, they receive a secure link via email with one-time password authentication. However, if your DA office views evidence frequently, I recommend setting them up as an External User which gives them a permanent login. Your admin can do this under Agency Settings > User Management. Officer: That would be better since we have ongoing cases. Can you guide me through setting that up? Support: I can assist your admin with that. Let me transfer you to our account management team who will help provision the DA external user accounts and configure sharing permissions. Officer: Perfect, thank you! Support: Before I transfer, note that external users cannot see all your agency evidence - only what is explicitly shared with them. This maintains evidence security. Officer: Good to know!'
        WHEN 10 THEN 'Chat - Body Camera Mounting Options. User: We have officers in different roles - patrol, bike patrol, motorcycle, and K9. Are there different mounting options for body cameras? Support: Yes! Axon Body cameras support multiple mounts: 1) Uniform Clip - standard chest mount, 2) Shoulder Epaulette Mount - for agencies preferring shoulder placement, 3) Head Mount - for bike helmets and motorcycles, 4) Glasses Mount - for specialized units. User: Do we need to buy these separately or are they included? Support: The Uniform Clip is included with every camera. Other mounts are sold separately as accessories. For your mixed roles, I recommend: Patrol officers - standard clip or epaulette, Bike patrol - head mount on helmet for better field of view, Motorcycle units - head mount on helmet (handlebar mount is not recommended due to vibration), K9 officers - standard clip positioned higher on vest for better dog interaction view. User: What about mounting on body armor or tactical vests? Support: The standard clip works with MOLLE webbing on tactical vests. We also offer the Axon Body Armor Mount which is specifically designed for plate carriers and heavy-duty vests. It has a reinforced clip and can handle more weight. User: Great! Can you send me a quote for 10 head mounts and 5 armor mounts? Support: Sending now! I am also including the Body Camera Mounting Guide PDF which shows optimal placement for each mount type. This helps with agency policy and officer training.'
        WHEN 11 THEN 'Email - TASER Training Cartridge Expiration. From Training Officer: We found a box of TASER training cartridges with an expiration date from 2022. Are they still safe to use? Support Response: TASER cartridges have a 5-year shelf life from manufacture date. Using expired cartridges is not recommended as the propellant may degrade, causing unreliable performance. This could affect training quality and officer confidence. From Training Officer: What should we do with expired cartridges? Can we return them? Support: Expired training cartridges cannot be returned, but they should be disposed of properly. Follow your agency hazmat disposal procedures. The cartridges contain a small pyrotechnic charge and should not be thrown in regular trash. Many agencies send them to their hazmat vendor or local fire department for proper disposal. From Training Officer: How do we prevent this in the future? Support: I recommend implementing a first-in-first-out (FIFO) inventory system. Store cartridges in a cool, dry location and check expiration dates quarterly. When ordering, only purchase quantities you will use within 2-3 years. From Training Officer: Good advice. Can you send replacement cartridge pricing? Support: Sending pricing now. For training programs, I also recommend our TASER Training Subscription which includes quarterly cartridge shipments matched to your training schedule. This prevents over-ordering and ensures fresh cartridges. You get a 15% discount and free shipping. From Training Officer: That sounds perfect for our needs!'
        WHEN 12 THEN 'Support Ticket - Evidence.com Mobile App Issues. Officer: The Evidence.com mobile app on my iPhone keeps crashing when I try to upload photos. Axon Support: Let me troubleshoot this. What iOS version are you running? Officer: iOS 15.2. Support: The latest app version requires iOS 15.4 or higher. Please update your iOS in Settings > General > Software Update. If you cannot update iOS, you can use the web browser version of Evidence.com as a workaround. Officer: My department does not allow iOS updates without IT approval. Can I use the browser? Support: Yes, open Safari and go to evidence.com. The mobile web version supports photo uploads, video review, and case management. You will not have offline access but all upload features work. For best experience, add evidence.com to your home screen: tap the Share icon and select "Add to Home Screen". Officer: That works! Uploading photos now. Why does the app need newer iOS? Support: Each app version requires specific iOS features for security and performance. The current app uses iOS 15.4 camera APIs for improved image processing and secure keychain for authentication. I recommend requesting the iOS update from your IT department as it includes important security patches. Officer: I will submit the request. Thanks for the browser workaround!'
        WHEN 13 THEN 'Phone Support - Fleet In-Car Cameras Not Recording Audio. Officer: Our Axon Fleet system is recording video from all cameras but no audio is captured. Support: Let me check a few things. First, does the Fleet have an external microphone installed or are you using the internal mic? Officer: We have the external mic mounted on the windshield. Support: Okay, check if the mic cable is fully connected to the Fleet control box. The connector should click into place. Officer: I hear it click now. Testing... Still no audio. Support: Next, check the Fleet settings. Press the menu button on the Fleet screen and go to Settings > Audio. Is the microphone enabled? Officer: The screen shows "Microphone: Off". Support: There is your issue! Toggle that to On and adjust the audio level. I recommend starting at 75% and adjusting based on cabin noise. Officer: Audio is working now! Why would it be disabled? Support: Sometimes during initial setup or after a firmware update, audio settings revert to default (off). This is a safety feature to prevent accidental recording. I recommend checking audio settings after any system updates. Also, test recordings periodically to ensure audio and video are both capturing. Officer: Will do. One more question - can we disable audio recording for privacy reasons? Support: Yes, many agencies do this for officer privacy during non-enforcement activities. You can configure auto-disable when the vehicle is in park or when emergency lights are off. These settings are in the Recording Policy section of Axon View XL. Talk to your fleet administrator about your agency policy.'
        WHEN 14 THEN 'Email Chain - Evidence Retention Policy Configuration. From Administrator: How do we set up evidence retention policies in Evidence.com? Different case types have different retention requirements under state law. Support Response: Evidence.com supports custom retention policies per case type. Navigate to Admin > Agency Settings > Retention Policies. You can create rules based on: case type (arrest, citation, incident report), offense severity (felony, misdemeanor), disposition (convicted, dismissed), and media type (video, audio, photo). From Administrator: Our state requires: Felony arrests - 50 years, Misdemeanor arrests - 7 years, Traffic citations - 3 years, Non-arrest incidents - 2 years. Can the system handle this? Support: Yes! Create four retention rules matching those requirements. Set the retention period and Evidence.com will automatically archive or delete cases when they expire. Important: Enable "Legal Hold Override" to prevent deletion of cases under investigation or pending litigation regardless of retention rules. From Administrator: What happens when retention expires? Support: You have three options: 1) Auto-delete (permanently removes evidence), 2) Auto-archive (moves to cold storage, still accessible but not in active database), or 3) Review required (sends notification to admin for manual review before action). I recommend option 3 initially to ensure the policy works correctly. From Administrator: Excellent. Can we export cases before deletion for external archiving? Support: Yes, use the Bulk Export tool under Data Management. You can export cases to external storage before the retention period expires. Many agencies export to tape backup or secure cloud storage for additional compliance. I am sending you our Evidence Retention Best Practices Guide. From Administrator: Thank you, this is very helpful!'
        WHEN 15 THEN 'Chat Support - TASER Device Error Code. Officer: My TASER 7 is showing error code E03. What does this mean and can I still use it? Support: Error E03 indicates a handle electronics issue, possibly related to the battery or internal diagnostics. Do not use the device until it is serviced. The error means the TASER cannot verify proper operation. Officer: This is during our shift. What should I do? Support: Contact your armorer or equipment supervisor immediately for a replacement device. Do not attempt to use the TASER with an error code as it may not deploy properly in a critical situation. The device needs to be sent in for service. Officer: How long does service take? Support: Typical turnaround is 5-7 business days. Ship the device to our service center (address in the return authorization email I am sending). We will diagnose, repair, and return it. If under warranty, there is no charge. If out of warranty, we will provide a quote before repairs. Officer: Can I troubleshoot it myself? Support: You can try a battery reset: remove the handle battery pack, wait 30 seconds, and reinstall. If the error persists, it requires factory service. TASER devices have internal safety checks that cannot be overridden. For officer safety, always replace a device showing any error code. Officer: Understood. I will get a replacement and ship this one in. Support: Good plan. I am emailing the Return Authorization (RA) number and prepaid shipping label now. Include your department information and contact details in the package.'
    END AS transcript_text,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'CHAT')[UNIFORM(0, 2, RANDOM())] AS interaction_type,
    st.created_date AS interaction_date,
    pc.product_family,
    st.ticket_category AS issue_category,
    st.ticket_status = 'CLOSED' AS resolution_provided,
    st.created_date AS created_at
FROM RAW.SUPPORT_TICKETS st
LEFT JOIN RAW.PRODUCT_CATALOG pc ON st.product_id = pc.product_id
WHERE st.ticket_id IS NOT NULL
LIMIT 20000;

-- ============================================================================
-- Step 6: Generate sample policy documents
-- ============================================================================
INSERT INTO POLICY_DOCUMENTS VALUES
('POL001', 'Axon Body Camera Operations Manual',
$$AXON BODY CAMERA OPERATIONS MANUAL
Version 3.2 - Updated October 2025

CHAPTER 1: INTRODUCTION
The Axon Body Camera program provides officers with a tool to document interactions, preserve evidence, and increase transparency. This manual covers proper operation, maintenance, and policy compliance.

CHAPTER 2: DEVICE OVERVIEW
Axon Body 3 and Body 4 cameras are designed for law enforcement use with features including:
- HD video recording (1080p or 720p)
- Wide-angle lens for comprehensive field of view
- Night vision and low-light recording
- Pre-event buffer (captures 30 seconds before activation)
- Encrypted storage with tamper-evident design
- Automatic upload to Evidence.com via docking station
- GPS location tagging
- Officer ID and timestamp embedding

CHAPTER 3: WHEN TO RECORD
Officers SHALL activate body cameras for:
- All law enforcement contacts with the public
- Traffic stops and vehicle pursuits
- Arrests and detentions
- Searches (person, vehicle, or property)
- Interrogations and interviews
- Use of force incidents
- Serving warrants
- Domestic violence calls
- Any situation where evidence preservation is beneficial

Officers MAY deactivate cameras:
- In hospitals or medical facilities (unless investigating a crime)
- During conversations with confidential informants
- When discussing tactical plans with other officers
- At the request of crime victims (documented in report)

CHAPTER 4: ACTIVATION PROCEDURES
Manual Activation:
1. Press the large Event button on the camera center
2. Verify the red recording indicator light
3. Announce "Body camera activated" for audio verification
4. Continue recording until the incident concludes

Auto-Activation (if configured):
Cameras may auto-activate when:
- Emergency lights are activated
- Vehicle reaches high speed (configurable threshold)
- Officer exits vehicle (requires Axon Fleet integration)
- TASER device is armed or deployed
- Dispatch codes as high-priority call

CHAPTER 5: BUFFERING
Pre-event buffering captures 30 seconds before manual activation. This helps document the start of incidents. Officers should activate cameras immediately when situations develop to maximize buffer value.

CHAPTER 6: RECORDING CATEGORIES
When activating, officers can select incident categories:
- Traffic Stop
- Arrest
- Use of Force
- Domestic Violence
- Interview/Interrogation
- Search
- General Patrol Activity

Proper categorization aids in evidence management and redaction processes.

CHAPTER 7: AUDIO RECORDING
Body cameras record audio continuously when activated. Officers should:
- Be aware of sensitive conversations
- Mute audio when consulting with prosecutors (use mute button)
- Announce when muting/unmuting for record integrity
- Remember that audio captures 360 degrees, not just camera view

CHAPTER 8: REVIEWING FOOTAGE
Officers may review their own footage:
- To write accurate reports
- To refresh memory before testimony
- For training and self-improvement

Officers SHALL NOT review footage:
- Before completing initial incident reports (per policy)
- From other officers without authorization
- For non-work purposes

CHAPTER 9: MAINTENANCE AND CARE
Daily:
- Dock camera at end of shift to upload and charge
- Verify successful upload confirmation
- Clean lens with provided microfiber cloth

Weekly:
- Inspect mounting clip for wear
- Check battery charging performance
- Verify firmware is current (supervisor check)

CHAPTER 10: TROUBLESHOOTING
Camera not turning on:
- Battery may be depleted - dock for 2 hours
- Perform hard reset: hold Event button 20 seconds

Camera not recording:
- Check storage capacity - may be full
- Verify firmware is not corrupted - update if needed

Camera not syncing:
- Ensure dock is connected to network
- Clean dock contacts with alcohol wipe
- Verify Evidence.com is accessible

CHAPTER 11: PRIVACY CONSIDERATIONS
Officers must balance transparency with privacy. Considerations include:
- Recording in private residences during calls for service
- Interactions with juveniles
- Medical situations and hospital settings
- Conversations with confidential sources

Supervisors and administrators handle redaction of sensitive material before public release.

CHAPTER 12: EVIDENCE MANAGEMENT
All recordings are automatically uploaded to Evidence.com and:
- Tagged with officer ID, date, time, and GPS location
- Encrypted during transfer and storage
- Protected with tamper-evident audit logs
- Retained per agency retention policy
- Accessible to authorized personnel only

CHAPTER 13: TRAINING REQUIREMENTS
Officers must complete:
- Initial 4-hour body camera training
- Annual refresher training (2 hours)
- Policy update training as policies change
- Practical exercises with camera activation

CHAPTER 14: ACCOUNTABILITY
Failure to activate body cameras as required may result in:
- Counseling and retraining
- Formal documentation
- Administrative action per agency policy

Intentional tampering with recordings or devices will result in disciplinary action up to termination and potential criminal charges.

CHAPTER 15: TECHNICAL SPECIFICATIONS
Axon Body 3:
- Resolution: 1080p HD
- Battery Life: 12+ hours
- Storage: 64GB or 128GB
- GPS: Yes
- WiFi: 802.11ac
- Bluetooth: 5.0
- Dimensions: 3.0" x 2.2" x 1.1"
- Weight: 4.3 oz
- Operating Temp: -4°F to 140°F

Axon Body 4:
- Resolution: 1080p or 4K
- Battery Life: 14+ hours  
- Storage: 128GB
- GPS: Yes with enhanced accuracy
- WiFi: 802.11ax (WiFi 6)
- Bluetooth: 5.2
- Dimensions: 3.1" x 2.3" x 1.2"
- Weight: 4.7 oz
- Operating Temp: -4°F to 140°F

APPENDIX A: POLICY UPDATES
This manual is updated quarterly. Officers are responsible for reviewing updates posted on the department intranet.

APPENDIX B: CONTACT INFORMATION
For technical support: support@axon.com or 1-800-978-2729
For policy questions: Contact your supervisor
For Evidence.com access issues: Contact agency Evidence.com administrator

DOCUMENT CONTROL
Manual Version: 3.2
Last Updated: October 2025
Next Review: January 2026
Approved By: Chief of Police
Distribution: All sworn personnel$$,
'BODY_CAMERA', 'OPERATIONS_MANUAL', 'OP-BC-001', '3.2', 'body camera,operations,policy,recording', 'Axon Training Department', '2025-10-01', CURRENT_TIMESTAMP(), 0, TRUE, CURRENT_TIMESTAMP()),

('POL002', 'TASER Device Use Policy and Guidelines',
$$TASER CONDUCTED ENERGY WEAPON POLICY
Effective Date: January 2025

SECTION 1: PURPOSE
This policy establishes guidelines for the use of TASER Conducted Energy Weapons (CEW) as a less-lethal force option. TASERs provide officers with an effective tool to control violent or potentially violent subjects while minimizing injury risk.

SECTION 2: AUTHORIZATION
Only officers who have successfully completed TASER certification training are authorized to carry and deploy TASER devices. Certification must be renewed annually.

SECTION 3: DEPLOYMENT GUIDELINES
TASERs may be deployed when:
- A subject poses an immediate threat to officer or public safety
- De-escalation efforts have failed or are not feasible
- The subject is actively resisting or attempting to flee
- The force level is appropriate under the circumstances

TASERs SHALL NOT be deployed on:
- Pregnant women (if known)
- Young children or elderly persons (absent exigent circumstances)
- Subjects in elevated positions where fall risk is severe
- Subjects operating vehicles or machinery
- Subjects near flammable materials or water

SECTION 4: USE OF FORCE CONTINUUM
TASER devices are classified as intermediate force options, between empty-hand control and impact weapons. Officers should evaluate the totality of circumstances including:
- Subject behavior and threat level
- Subject size and apparent physical capability
- Officer ability to control subject with lesser force
- Presence of weapons or dangerous instruments
- Environmental factors

SECTION 5: DEPLOYMENT PROCEDURES
Before Deployment:
1. Announce "TASER! TASER! TASER!" to warn other officers
2. Aim for center mass (torso) or back (if subject is fleeing)
3. Avoid head, neck, chest (near heart), and groin when possible
4. Deploy from recommended distance (7-25 feet optimal)

During Deployment:
1. One standard deployment cycle is 5 seconds
2. Evaluate subject response after each cycle
3. Use additional cycles only if necessary and justified
4. Be prepared to transition to other force options if ineffective

After Deployment:
1. Secure the subject in handcuffs immediately
2. Remove TASER probes or call medical personnel if needed
3. Photograph probe impact sites before removal
4. Provide medical evaluation for all subjects tased
5. Collect and preserve cartridge and wires as evidence
6. Complete Use of Force report and body camera review

SECTION 6: DRIVE STUN MODE
Drive stun (direct contact without probes) may be used for:
- Pain compliance on actively resisting subjects
- Follow-up if probe deployment is ineffective
- Close quarters situations where probe deployment is not feasible

Drive stun is less effective than probe deployment and may require multiple applications.

SECTION 7: MEDICAL CONSIDERATIONS
After any TASER deployment:
- Visually inspect subject for injuries
- Call EMS if subject complains of injury or appears in distress
- Probes embedded in sensitive areas (face, neck, groin) require medical removal
- Subjects with pre-existing medical conditions should be evaluated by medical personnel
- Document all medical treatment in reports

SECTION 8: TRAINING REQUIREMENTS
TASER certification includes:
- 8 hours initial training
- Classroom instruction on device operation and policy
- Hands-on practice with training cartridges
- Live cartridge deployment on range
- Scenario-based training
- Legal considerations and use-of-force policy
- Optional: Voluntary exposure (officer experiences TASER)

Annual recertification:
- 4 hours refresher training
- Policy updates
- Practical qualifications
- Review of recent deployments

SECTION 9: EQUIPMENT MAINTENANCE
Officers shall:
- Perform spark test at beginning of each shift
- Verify cartridge expiration dates
- Replace batteries per manufacturer schedule (or when low battery warning appears)
- Report malfunctions immediately to supervisor
- Dock device for data download per policy

Supervisors shall:
- Inspect devices quarterly
- Track device deployments
- Review download data for policy compliance
- Coordinate device repairs and replacements

SECTION 10: REPORTING REQUIREMENTS
All TASER deployments must be documented:
- Use of Force report completed before end of shift
- Supervisor notification immediately
- Body camera footage reviewed and uploaded
- Medical treatment documented
- Witness statements collected
- Photographs of probe impact sites
- Device data downloaded and preserved

SECTION 11: SPECIAL CIRCUMSTANCES
Multiple Officer Deployments:
- Only one officer should deploy TASER unless multiple devices are clearly necessary
- Announce intentions to avoid confusion
- Coordinate with other officers to prevent crossfire

Subjects Under Influence:
- Subjects under influence of drugs/alcohol may not respond to pain compliance
- Be prepared for prolonged or multiple cycles
- Enhanced medical evaluation required

Mentally Ill Subjects:
- Attempt de-escalation first when safe to do so
- Consider Crisis Intervention Team (CIT) response
- Coordinate with mental health professionals if available
- Document mental health indicators in reports

SECTION 12: PROHIBITED USES
TASERs shall not be used:
- As punishment or to inflict pain
- On restrained subjects (unless actively assaultive)
- To prevent destruction of evidence
- On passively resistant subjects
- For horseplay or demonstration (except in controlled training)

SECTION 13: ACCOUNTABILITY
Use of TASER devices is subject to:
- Supervisor review of every deployment
- Use of Force Review Board assessment
- Administrative investigation if warranted
- Civil and criminal liability considerations

Officers have duty to intervene if witnessing inappropriate TASER use by other officers.

SECTION 14: TECHNICAL DATA
TASER 7 Specifications:
- Effective Range: 0-25 feet
- Cartridge Types: Close Quarters (CQ), Stand-Off
- Neuro-Muscular Incapacitation (NMI): 5-second cycle
- Power Source: Rechargeable battery packs
- Data Storage: Records date, time, duration of all deployments
- Warranty: 5 years manufacturer warranty

APPENDIX: LEGAL CONSIDERATIONS
TASER deployments must comply with:
- Fourth Amendment reasonableness standard (Graham v. Connor)
- State use-of-force statutes
- Department use-of-force policy
- Federal consent decrees (if applicable)
- Community expectations and transparency

This policy shall be reviewed annually and updated as needed based on case law, best practices, and incident analysis.

Approved: Chief of Police
Date: January 2025
Next Review: January 2026$$,
'TASER', 'USE_OF_FORCE_POLICY', 'POL-TASER-002', '2.1', 'taser,use of force,policy,training,deployment', 'Use of Force Committee', '2025-01-01', CURRENT_TIMESTAMP(), 0, TRUE, CURRENT_TIMESTAMP()),

('POL003', 'Evidence.com Digital Evidence Management Guidelines',
$$EVIDENCE.COM DIGITAL EVIDENCE MANAGEMENT GUIDELINES
Agency Policy Document

1. PURPOSE AND SCOPE
This policy establishes procedures for managing digital evidence through the Evidence.com platform, ensuring evidence integrity, chain of custody, appropriate access controls, and compliance with legal requirements.

2. EVIDENCE.COM OVERVIEW
Evidence.com is a cloud-based evidence management system that:
- Stores body camera, in-car, and interview room video
- Manages photos, audio, and documents
- Maintains audit logs of all access and modifications
- Provides secure sharing with authorized parties
- Enforces retention policies automatically
- Supports redaction and disclosure workflows

3. USER ROLES AND PERMISSIONS
Administrator: Full system access, user management, policy configuration
Supervisor: Review evidence, manage subordinate users, approve releases
Officer: Upload evidence, view own evidence, create cases
Evidence Custodian: Manage evidence lifecycle, handle retention, coordinate releases
External User: View-only access to specific shared evidence (prosecutors, defense, courts)

4. UPLOADING EVIDENCE
Automatic Upload:
- Body cameras auto-upload when docked
- In-car systems upload via WiFi at station
- Upload status should be verified daily

Manual Upload:
- Officers may upload photos/videos from personal devices for official business
- All uploads must be tagged with case number, incident type, and location
- Evidence uploaded from non-Axon devices should note the source

5. CASE MANAGEMENT
Creating Cases:
- Each incident should have a unique case file
- Case numbers should match department RMS case numbers
- Include offense type, date, location, involved parties
- Link all related evidence files to the case

Tagging Evidence:
- Officer ID (automatically tagged)
- Date and time (automatically tagged)
- GPS location (automatically tagged from devices)
- Case number (manually entered)
- Incident type (manually selected)
- Supplemental tags (suspect, victim, witness, scene photos, etc.)

6. ACCESS CONTROLS
Officers may access:
- Their own recorded evidence
- Evidence from incidents where they were involved
- Shared evidence as authorized by supervisors

Supervisors may access:
- Evidence from their subordinates
- Evidence from incidents in their command
- Agency-wide evidence with proper authorization

Evidence Custodians may access:
- All agency evidence for management purposes
- Access is logged and audited

7. EVIDENCE REVIEW
Officers may review their evidence:
- After completing initial incident reports (per policy)
- Before supplemental reports
- Before testimony or depositions
- For training purposes (with supervisor approval)

All evidence views are logged with:
- User ID and timestamp
- Duration of viewing
- Purpose (requires user notation)
- Any downloads or shares

8. REDACTION
Redaction may be necessary to protect:
- Juvenile identities
- Confidential informants
- Medical information
- Victim privacy in sensitive cases
- Bystander faces in crowd scenes

Redaction Process:
- Original evidence is never modified (preserved as master copy)
- Redacted versions are created as separate files
- Redaction log maintained showing what was redacted and by whom
- Legal review before releasing redacted versions

9. EVIDENCE SHARING
Internal Sharing:
- Supervisors may share evidence with other departmental units
- Shared access is time-limited and logged
- Shared users cannot modify or delete evidence

External Sharing:
- Prosecutors receive view-only or download access
- Defense attorneys receive access per discovery requirements
- Courts receive access for evidentiary hearings
- External shares require supervisor or custodian approval
- Expiration dates should be set on external shares

10. CHAIN OF CUSTODY
Evidence.com maintains automated chain of custody through:
- Upload audit logs (who, when, from what device)
- Access audit logs (who viewed, when, for how long)
- Modification audit logs (redactions, tags, categories)
- Download audit logs (who downloaded, when, what files)
- Share audit logs (who shared, with whom, when)

This digital chain of custody is admissible in court and should be included in discovery materials.

11. RETENTION POLICIES
Evidence retention periods are configured by case type:
- Felony arrests: 50 years
- Misdemeanor arrests: 7 years
- Traffic citations: 3 years
- Non-arrest incidents: 2 years
- Administrative recordings: 1 year

Special Retention:
- Evidence under legal hold is retained indefinitely
- Evidence related to pending litigation is protected
- Evidence with sustained complaints is retained per policy
- Evidence involving use of force is retained longer

Disposal:
- Evidence past retention and not under legal hold is automatically archived
- Evidence.com administrators receive notification before deletion
- Supervisors may extend retention on case-by-case basis

12. LEGAL HOLDS
When litigation or investigation is pending:
- Place legal hold on all related evidence
- Legal hold prevents automatic deletion
- Document legal hold justification
- Remove legal hold only when authorized by legal counsel

13. PUBLIC DISCLOSURE REQUESTS
Public Records Requests:
- Forward requests to Records Division/Legal
- Identify responsive evidence in Evidence.com
- Conduct redaction as necessary
- Obtain legal review before release
- Log all released evidence

FOIA Compliance:
- Respond within statutory timeframes
- Balance transparency with privacy
- Document exemptions claimed
- Maintain release log

14. QUALITY ASSURANCE
Quarterly Audits:
- Verify uploads are complete and timely
- Review access logs for unauthorized access
- Check tagging accuracy
- Confirm retention policies are functioning
- Test disaster recovery procedures

Annual Reviews:
- Update retention policies per legal changes
- Review user permissions and deactivate separated employees
- Train new users and refresh existing users
- Evaluate system performance and capacity

15. SECURITY
Evidence.com employs:
- 256-bit AES encryption at rest
- TLS encryption in transit
- Multi-factor authentication for users
- Role-based access controls
- Intrusion detection and prevention
- Regular security audits and penetration testing
- SOC 2 Type II compliance
- Criminal Justice Information Services (CJIS) compliance

Agency Responsibilities:
- Enforce strong password policies
- Require MFA for all users
- Immediately deactivate separated employee accounts
- Report suspected security incidents to Axon
- Conduct regular security awareness training

16. TRAINING REQUIREMENTS
Initial Training (4 hours):
- Evidence.com navigation and search
- Uploading and tagging evidence
- Case management
- Sharing and redaction
- Privacy and legal considerations

Annual Refresher (2 hours):
- Policy updates
- New features
- Case studies
- Common mistakes to avoid

Administrator Training (8 hours):
- User management
- System configuration
- Retention policy setup
- Audit log review
- Disaster recovery

17. DISASTER RECOVERY
Evidence.com Redundancy:
- Data replicated across multiple data centers
- 99.9% uptime guarantee
- Automated backups every 24 hours
- Point-in-time recovery capability

Agency Responsibilities:
- Maintain current contact information
- Document critical cases requiring priority recovery
- Test recovery procedures annually
- Coordinate with Axon support for any recovery needs

18. TECHNICAL SUPPORT
For Evidence.com issues:
- Contact Axon Support: 1-800-978-2729
- Email: support@axon.com
- Agency administrator can access online support portal
- Critical issues receive 24/7 response

19. POLICY COMPLIANCE
Violations of this policy may result in:
- Retraining requirements
- Access restrictions
- Administrative action
- Criminal referral (for evidence tampering)

All personnel with Evidence.com access must acknowledge policy annually.

20. POLICY REVIEW
This policy shall be reviewed annually and updated as needed based on:
- Legal requirements and case law
- Technology updates
- Audit findings
- Best practices

Policy Version: 1.5
Effective Date: October 2025
Next Review: October 2026
Approved By: Chief of Police$$,
'SOFTWARE', 'EVIDENCE_MANAGEMENT', 'POL-EVID-003', '1.5', 'evidence.com,digital evidence,retention,chain of custody', 'Legal and Compliance Division', '2025-10-01', CURRENT_TIMESTAMP(), 0, TRUE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 7: Generate sample incident reports
-- ============================================================================
INSERT INTO INCIDENT_REPORTS
SELECT
    'INCRPT' || LPAD(SEQ4(), 10, '0') AS incident_report_id,
    qi.quality_issue_id,
    qi.agency_id,
    qi.product_id,
    CASE (ABS(RANDOM()) % 5)
        WHEN 0 THEN 'INCIDENT INVESTIGATION REPORT' || CHR(10) ||
            'Product: ' || p.product_name || CHR(10) ||
            'Serial Number: ' || qi.serial_number || CHR(10) ||
            'Agency: ' || a.agency_name || CHR(10) ||
            'Incident Date: ' || qi.reported_date::VARCHAR || CHR(10) || CHR(10) ||
            'INCIDENT SUMMARY:' || CHR(10) ||
            'Body camera device failed to record during critical incident. Officer activated camera as trained but no video was captured. Post-incident investigation revealed device malfunction.' || CHR(10) || CHR(10) ||
            'TECHNICAL ANALYSIS:' || CHR(10) ||
            'Device was returned to Axon service center for analysis. Diagnostics revealed firmware corruption preventing recording initialization. The corruption occurred during a previous failed firmware update attempt. Device logs show multiple failed boot attempts before the incident.' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Firmware update process was interrupted due to unstable WiFi connection at the agency docking station. Partial firmware write resulted in corrupted boot sector. Device appeared operational (power on, status lights functional) but recording functionality was disabled.' || CHR(10) || CHR(10) ||
            'CORRECTIVE ACTIONS:' || CHR(10) ||
            '1. Device firmware fully reinstalled and tested' || CHR(10) ||
            '2. Agency WiFi infrastructure upgraded for stable connections' || CHR(10) ||
            '3. Firmware update process enhanced with verification and rollback capability' || CHR(10) ||
            '4. Pre-shift camera functionality check added to agency policy' || CHR(10) || CHR(10) ||
            'RECOMMENDATIONS:' || CHR(10) ||
            'Officers should perform daily spark test equivalent for cameras - press record button and verify recording indicator before shift. This takes 5 seconds and would have caught this issue before deployment.'
        WHEN 1 THEN 'FIELD FAILURE ANALYSIS' || CHR(10) ||
            'Device: ' || p.sku || CHR(10) ||
            'Failure Mode: TASER cartridge did not deploy probes' || CHR(10) ||
            'Incident Location: ' || a.city || ', ' || a.state || CHR(10) || CHR(10) ||
            'INCIDENT DESCRIPTION:' || CHR(10) ||
            'Officer deployed TASER 7 during use of force incident. Device triggered but no probes ejected from cartridge. Officer transitioned to backup force options to resolve situation. No injuries to officer or subject, but TASER failure created increased risk.' || CHR(10) || CHR(10) ||
            'DEVICE EXAMINATION:' || CHR(10) ||
            'Cartridge was recovered and sent for analysis. X-ray imaging revealed manufacturing defect - propellant charge was not properly seated in cartridge body. When firing pin struck charge, insufficient pressure was generated to eject probes. Defect is not visible externally.' || CHR(10) || CHR(10) ||
            'MANUFACTURING INVESTIGATION:' || CHR(10) ||
            'This cartridge was from production lot ' || qi.rma_number || '. Quality review of that lot found 0.02% defect rate (2 per 10,000 cartridges) where automated assembly equipment failed to fully seat propellant charges. Enhanced inspection procedures now implemented.' || CHR(10) || CHR(10) ||
            'CUSTOMER IMPACT:' || CHR(10) ||
            'Agency had 500 cartridges from affected lot. Voluntary recall initiated for all cartridges from this lot. Replacement cartridges expedited at no charge. Testing shows other lots unaffected - defect isolated to single production run.' || CHR(10) || CHR(10) ||
            'PREVENTIVE MEASURES:' || CHR(10) ||
            '- Enhanced vision inspection system installed on cartridge assembly line' || CHR(10) ||
            '- 100% X-ray verification of propellant seating before packaging' || CHR(10) ||
            '- Lot traceability improved for faster recall capability' || CHR(10) ||
            '- Quality hold procedures for suspected defects' || CHR(10) || CHR(10) ||
            'LESSON LEARNED:' || CHR(10) ||
            'Manufacturing defects can occur despite quality controls. Officers should always have backup force options available. Cartridge inspection is limited to expiration date and physical damage checks - internal defects are not user-detectable.'
        WHEN 2 THEN 'BATTERY PERFORMANCE INVESTIGATION' || CHR(10) ||
            'Product Line: Axon Body Camera Series' || CHR(10) ||
            'Issue: Premature battery depletion' || CHR(10) ||
            'Affected Agency: ' || a.agency_name || CHR(10) || CHR(10) ||
            'ISSUE REPORT:' || CHR(10) ||
            'Agency reported that body cameras are requiring recharge after only 4-6 hours of use. Specification indicates 12+ hour battery life. Multiple officers reported similar issue across different camera serial numbers.' || CHR(10) || CHR(10) ||
            'INITIAL INVESTIGATION:' || CHR(10) ||
            'Review of camera usage logs revealed:' || CHR(10) ||
            '- Cameras recording almost continuously (8-10 hours per shift)' || CHR(10) ||
            '- WiFi streaming enabled constantly' || CHR(10) ||
            '- GPS polling interval set to 10 seconds (default is 60 seconds)' || CHR(10) ||
            '- Screen brightness set to maximum' || CHR(10) || CHR(10) ||
            'ANALYSIS:' || CHR(10) ||
            'The 12-hour battery specification assumes typical usage: 2-3 hours recording, WiFi enabled only for uploads, standard GPS polling, and auto screen brightness. This agency configuration created power consumption far exceeding typical use:' || CHR(10) ||
            '- Continuous recording: +40% power draw' || CHR(10) ||
            '- Constant WiFi: +25% power draw' || CHR(10) ||
            '- Aggressive GPS: +15% power draw' || CHR(10) ||
            '- Max brightness: +10% power draw' || CHR(10) ||
            'Combined, these settings nearly double power consumption.' || CHR(10) || CHR(10) ||
            'RECOMMENDATIONS:' || CHR(10) ||
            '1. Adjust GPS polling to 60-second interval (sufficient for location tracking)' || CHR(10) ||
            '2. Disable WiFi streaming except during uploads (use WiFi schedule feature)' || CHR(10) ||
            '3. Enable auto brightness (adjusts based on ambient light)' || CHR(10) ||
            '4. Consider mid-shift charging for high-use officers' || CHR(10) ||
            '5. Purchase additional batteries for extended operations' || CHR(10) || CHR(10) ||
            'AGENCY RESPONSE:' || CHR(10) ||
            'Agency implemented recommended settings. Battery life improved to 10-11 hours which meets their operational needs. No hardware defect found. Issue resolved through configuration optimization.'
        WHEN 3 THEN 'IN-CAR CAMERA MALFUNCTION REPORT' || CHR(10) ||
            'System: Axon Fleet 3' || CHR(10) ||
            'Problem: Intermittent recording failures' || CHR(10) ||
            'Vehicle: ' || a.agency_name || ' Patrol Unit' || CHR(10) || CHR(10) ||
            'PROBLEM STATEMENT:' || CHR(10) ||
            'In-car video system randomly stops recording during shifts. No error messages displayed. Officers do not notice until reviewing footage later. This has resulted in gaps in critical incident documentation.' || CHR(10) || CHR(10) ||
            'TROUBLESHOOTING STEPS:' || CHR(10) ||
            'Axon field technician inspected vehicle installation:' || CHR(10) ||
            '- Power connections verified secure' || CHR(10) ||
            '- All camera connections tested functional' || CHR(10) ||
            '- WiFi and GPS antennas properly mounted' || CHR(10) ||
            '- Firmware version current' || CHR(10) || CHR(10) ||
            'Advanced diagnostics revealed:' || CHR(10) ||
            '- Storage drive experiencing temperature throttling' || CHR(10) ||
            '- Operating temperature exceeding 140°F during recording failures' || CHR(10) ||
            '- Fleet control box mounted directly above vehicle heater vent' || CHR(10) ||
            '- Summer ambient temperature + heater location = excessive heat' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Installer mounted Fleet control box in location not recommended by installation guide. Direct heat exposure from heater vent caused internal temperature to exceed operating specification. Thermal protection circuit temporarily disabled recording to prevent damage.' || CHR(10) || CHR(10) ||
            'RESOLUTION:' || CHR(10) ||
            'Control box relocated to under-seat position with proper ventilation. Heat-shielding added as extra precaution. Post-modification testing showed operating temperature remained within specification even during summer heat.' || CHR(10) || CHR(10) ||
            'INSTALLER TRAINING:' || CHR(10) ||
            'Installation company retrained all technicians on proper Fleet mounting locations. Installation guide updated with prominent heater vent warnings. Agency inspected all other vehicles - 3 additional vehicles had similar issue and were corrected.'
        ELSE 'QUALITY ISSUE INVESTIGATION' || CHR(10) ||
            'Product: ' || p.product_name || CHR(10) ||
            'Issue Category: ' || qi.issue_category || CHR(10) ||
            'Severity: ' || qi.severity || CHR(10) || CHR(10) ||
            'A thorough investigation was conducted to determine root cause. Analysis included device testing, user training review, and environmental factors assessment. Corrective actions have been implemented to prevent recurrence. Device functionality has been verified and returned to service or replaced as appropriate.'
    END AS report_text,
    ARRAY_CONSTRUCT('DEVICE_MALFUNCTION', 'USER_ERROR', 'ENVIRONMENTAL_FACTOR', 'MANUFACTURING_DEFECT')[UNIFORM(0, 3, RANDOM())] AS incident_type,
    qi.investigation_status,
    'Root cause identified and corrective actions implemented' AS findings_summary,
    'Enhanced quality controls, user training updates, and preventive measures deployed' AS recommendations,
    DATEADD('day', UNIFORM(5, 30, RANDOM()), qi.reported_date) AS report_date,
    'Axon Quality Engineering Team' AS investigated_by,
    DATEADD('day', UNIFORM(5, 30, RANDOM()), qi.reported_date) AS created_at
FROM RAW.QUALITY_ISSUES qi
JOIN RAW.PRODUCT_CATALOG p ON qi.product_id = p.product_id
JOIN RAW.AGENCIES a ON qi.agency_id = a.agency_id
WHERE UNIFORM(0, 100, RANDOM()) < 50
LIMIT 10000;

-- ============================================================================
-- Step 8: Create Cortex Search Service for Support Transcripts
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPORT_TRANSCRIPTS_SEARCH
  ON transcript_text
  ATTRIBUTES agency_id, support_engineer_id, interaction_type, product_family, issue_category
  WAREHOUSE = AXON_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for customer support transcripts - enables semantic search across support interactions'
AS
  SELECT
    transcript_id,
    transcript_text,
    ticket_id,
    agency_id,
    support_engineer_id,
    interaction_type,
    interaction_date,
    product_family,
    issue_category,
    resolution_provided
  FROM SUPPORT_TRANSCRIPTS;

-- ============================================================================
-- Step 9: Create Cortex Search Service for Policy Documents
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE POLICY_DOCUMENTS_SEARCH
  ON content
  ATTRIBUTES product_family, document_category, title, document_number
  WAREHOUSE = AXON_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for policy documents - enables semantic search across operational policies and guidelines'
AS
  SELECT
    policy_id,
    content,
    title,
    product_family,
    document_category,
    document_number,
    revision,
    tags,
    author,
    publish_date
  FROM POLICY_DOCUMENTS;

-- ============================================================================
-- Step 10: Create Cortex Search Service for Incident Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE INCIDENT_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES agency_id, product_id, incident_type, incident_status
  WAREHOUSE = AXON_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for incident investigation reports - enables semantic search across quality investigations'
AS
  SELECT
    incident_report_id,
    report_text,
    quality_issue_id,
    agency_id,
    product_id,
    incident_type,
    incident_status,
    findings_summary,
    recommendations,
    report_date,
    investigated_by
  FROM INCIDENT_REPORTS;

-- ============================================================================
-- Display data generation and search service completion summary
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status,
       (SELECT COUNT(*) FROM SUPPORT_TRANSCRIPTS) AS support_transcripts,
       (SELECT COUNT(*) FROM POLICY_DOCUMENTS) AS policy_documents,
       (SELECT COUNT(*) FROM INCIDENT_REPORTS) AS incident_reports;

