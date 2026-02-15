-- ============================================
-- WORKPLAN DATA SQL SCRIPT
-- Generated to add missing data to production
-- ============================================

-- Set collation to match database tables
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = utf8mb4_unicode_ci;

-- Get Sam's existing ID for reference
SET @sam_id = (SELECT id FROM user WHERE email = 'sam@honeyguide.org');

-- Role IDs (from production)
SET @role_portal_superadmin = '019c60eb-b599-7224-a12d-8c674bd8d895';
SET @role_portal_admin = '019c60eb-b59a-70c6-af99-9d16254164e9';
SET @role_project_manager = '019c60eb-b59a-70c6-af99-9d16256847d5';
SET @role_project_member = '019c60eb-b59a-70c6-af99-9d16265addce';
SET @role_project_viewer = '019c60eb-b59a-70c6-af99-9d1626b69a85';

-- Project IDs (from production)
SET @proj_a = 'aa2e1ab3-0a63-11f1-ad7d-0050566159a4';
SET @proj_b = 'aa31bcac-0a63-11f1-ad7d-0050566159a4';
SET @proj_c = 'aa36fe41-0a63-11f1-ad7d-0050566159a4';
SET @proj_d = 'aa3a065c-0a63-11f1-ad7d-0050566159a4';
SET @proj_e = 'aa3db03d-0a63-11f1-ad7d-0050566159a4';
SET @proj_f = 'aa40f928-0a63-11f1-ad7d-0050566159a4';
SET @proj_g = 'aa45952e-0a63-11f1-ad7d-0050566159a4';
SET @proj_h = 'aa48d901-0a63-11f1-ad7d-0050566159a4';

-- Milestone IDs (from production)
SET @m1_1 = 'aa307a56-0a63-11f1-ad7d-0050566159a4';  -- 1.1 Ruvuma 5 WMAs
SET @m1_2 = 'aa308580-0a63-11f1-ad7d-0050566159a4';  -- 1.2 Liwale
SET @m1_3 = 'aa3088b0-0a63-11f1-ad7d-0050566159a4';  -- 1.3 Ruaha WMAs
SET @m1_4 = 'aa308972-0a63-11f1-ad7d-0050566159a4';  -- 1.4 Ifinga
SET @m2_1 = 'aa36349b-0a63-11f1-ad7d-0050566159a4';  -- 2.1 Burunge
SET @m2_2 = 'aa363ccf-0a63-11f1-ad7d-0050566159a4';  -- 2.2 Makame
SET @m2_3 = 'aa363ece-0a63-11f1-ad7d-0050566159a4';  -- 2.3 Randilen
SET @m2_4 = 'aa363faf-0a63-11f1-ad7d-0050566159a4';  -- 2.4 Makao WMA
SET @m2_5 = 'aa364071-0a63-11f1-ad7d-0050566159a4';  -- 2.5 Uyumbu WMA
SET @m2_6 = 'aa364131-0a63-11f1-ad7d-0050566159a4';  -- 2.6 Other new WMAs
SET @m3_1 = 'aa3918c4-0a63-11f1-ad7d-0050566159a4';  -- 3.1 Governance
SET @m3_2 = 'aa3920ec-0a63-11f1-ad7d-0050566159a4';  -- 3.2 Management
SET @m3_3 = 'aa39221f-0a63-11f1-ad7d-0050566159a4';  -- 3.3 Protection
SET @m3_4 = 'aa3922c7-0a63-11f1-ad7d-0050566159a4';  -- 3.4 HWC
SET @m3_5 = 'aa392497-0a63-11f1-ad7d-0050566159a4';  -- 3.5 Livelihoods
SET @m3_6 = 'aa39252d-0a63-11f1-ad7d-0050566159a4';  -- 3.6 Honeyguide Learning Hub
SET @m4_1 = 'aa3cb6dd-0a63-11f1-ad7d-0050566159a4';  -- 4.1 M&E
SET @m4_2 = 'aa3cc0bf-0a63-11f1-ad7d-0050566159a4';  -- 4.2 GIS and Mapping
SET @m5_1 = 'aa40264d-0a63-11f1-ad7d-0050566159a4';  -- 5.1 Honeyguide K9 Unit
SET @m5_2 = 'aa403118-0a63-11f1-ad7d-0050566159a4';  -- 5.2 Rubondo Chimpanzee
SET @m6_1 = 'aa444985-0a63-11f1-ad7d-0050566159a4';  -- 6.1 Public Awareness
SET @m6_2 = 'aa44536f-0a63-11f1-ad7d-0050566159a4';  -- 6.2 Stakeholder Perception
SET @m6_3 = 'aa4454a7-0a63-11f1-ad7d-0050566159a4';  -- 6.3 Policy
SET @m6_4 = 'aa4455a0-0a63-11f1-ad7d-0050566159a4';  -- 6.4 Regional Networks
SET @m6_5 = 'aa445679-0a63-11f1-ad7d-0050566159a4';  -- 6.5 Capacity Building
SET @m7_1 = 'aa47d3c2-0a63-11f1-ad7d-0050566159a4';  -- 7.1 Financial Management
SET @m7_2 = 'aa47de99-0a63-11f1-ad7d-0050566159a4';  -- 7.2 HR Management
SET @m7_3 = 'aa47e261-0a63-11f1-ad7d-0050566159a4';  -- 7.3 IT
SET @m7_4 = 'aa47e39b-0a63-11f1-ad7d-0050566159a4';  -- 7.4 Asset and Risk Management
SET @m7_5 = 'aa47e4e2-0a63-11f1-ad7d-0050566159a4';  -- 7.5 Workshop
SET @m8_1 = 'aa4b53b0-0a63-11f1-ad7d-0050566159a4';  -- 8.1 Fundraising
SET @m8_2 = 'aa4b6fcd-0a63-11f1-ad7d-0050566159a4';  -- 8.2 Systems and Tool Development
SET @m8_3 = 'aa4b726f-0a63-11f1-ad7d-0050566159a4';  -- 8.3 Comms International
SET @m8_4 = 'aa4b7408-0a63-11f1-ad7d-0050566159a4';  -- 8.4 Comms National

-- Project I needs to be created (missing from production)
SET @proj_i = UUID();

-- ============================================
-- 1. CREATE USERS
-- ============================================
-- Get existing user IDs from database (use Sam as fallback for admin)
SET @user_admin = COALESCE((SELECT id FROM user WHERE email = 'admin@honeyguide.org'), @sam_id);
SET @user_sylvester = (SELECT id FROM user WHERE email = 'sylvester@honeyguide.org');
SET @user_max = (SELECT id FROM user WHERE email = 'max@honeyguide.org');
SET @user_fatma = (SELECT id FROM user WHERE email = 'fatma@honeyguide.org');
SET @user_namnyaki = (SELECT id FROM user WHERE email = 'namnyaki@honeyguide.org');
SET @user_kateto = (SELECT id FROM user WHERE email = 'kateto@honeyguide.org');
SET @user_lemuta = (SELECT id FROM user WHERE email = 'lemuta@honeyguide.org');
SET @user_glad = (SELECT id FROM user WHERE email = 'glad@honeyguide.org');
SET @user_daudi = (SELECT id FROM user WHERE email = 'daudi@honeyguide.org');
SET @user_michael = (SELECT id FROM user WHERE email = 'michael@honeyguide.org');
SET @user_meleck = (SELECT id FROM user WHERE email = 'meleck@honeyguide.org');

-- NOTE: Users already created in a previous run, skipping INSERT

-- ============================================
-- 2. UPDATE PROJECT OWNERS
-- ============================================
UPDATE project SET owner_id = @user_admin WHERE id = @proj_a;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_b;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_c;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_d;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_e;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_f;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_g;
UPDATE project SET owner_id = @user_admin WHERE id = @proj_h;

-- ============================================
-- 3. CREATE PROJECT MEMBERS (using IGNORE to skip duplicates)
-- ============================================
-- Project A: Southern WMAs - admin (manager), sylvester (member)
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_a, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_a, @user_sylvester, @role_project_member, NOW());

-- Project B: Northern WMAs - admin (manager), max (member), sam (member)
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_b, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_b, @user_max, @role_project_member, NOW()),
(UUID(), @proj_b, @sam_id, @role_project_member, NOW());

-- Project C: Technical Innovations - admin (manager), fatma, namnyaki, kateto, lemuta, glad (members)
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_c, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_c, @user_fatma, @role_project_member, NOW()),
(UUID(), @proj_c, @user_namnyaki, @role_project_member, NOW()),
(UUID(), @proj_c, @user_kateto, @role_project_member, NOW()),
(UUID(), @proj_c, @user_lemuta, @role_project_member, NOW()),
(UUID(), @proj_c, @user_glad, @role_project_member, NOW());

-- Project D: M&E - admin (manager), daudi, michael (members)
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_d, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_d, @user_daudi, @role_project_member, NOW()),
(UUID(), @proj_d, @user_michael, @role_project_member, NOW());

-- Project E: Special Programs - admin (manager), meleck (member)
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_e, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_e, @user_meleck, @role_project_member, NOW());

-- Projects F, G, H: admin as manager only
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_f, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_g, @user_admin, @role_project_manager, NOW()),
(UUID(), @proj_h, @user_admin, @role_project_manager, NOW());

-- ============================================
-- 3b. CREATE PROJECT I (MISSING FROM PRODUCTION)
-- ============================================
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (@proj_i, @user_admin, 'I. Honeyguide Board Governance', 'An effective board that are able to perform their roles to support and guide the organization.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Add admin as project manager for Project I
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_i, @user_admin, @role_project_manager, NOW());

-- Create milestone 9.0 for Project I
SET @m9_0 = UUID();
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
VALUES (@m9_0, @proj_i, '9.0 Honeyguide Oversight', 'An effective board that are able to perform their roles to support and guide the organization.', 'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 4. CREATE MILESTONE TARGETS (DELIVERABLES)
-- ============================================

-- Milestone 1.1: Ruvuma 5 WMAs
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_1, 'MAT report showing management progress (>80% Level 3 by year end)', 0, 0),
(UUID(), @m1_1, 'Capacited 1 Field Officer in governance, MAT, Protection, HWC monitoring', 1, 0),
(UUID(), @m1_1, 'Co-implementation report on financial management capacity building in Ruvuma 5 WMAs with partners', 2, 0),
(UUID(), @m1_1, 'On-demand Governance Training Reports and Periodic GIA Reports for Ruvuma 5 WMAs', 3, 0),
(UUID(), @m1_1, 'Maintained Rangerpost & equipment, vehicles, reports on SOPs, anti-poaching strategy, intelligence Manual and data collection system', 4, 0),
(UUID(), @m1_1, 'Reports on implemented communication strategies, stakeholder engagement strategies and awareness films', 5, 0),
(UUID(), @m1_1, 'HWC toolkits training reports', 6, 0),
(UUID(), @m1_1, 'Joint Livelihood initiative reports', 7, 0),
(UUID(), @m1_1, '4 Meetings in each WMA with pastoralists, inclusion in AA and village committee', 8, 0);

-- Milestone 1.2: Liwale (Magingo WMA)
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_2, 'MAT report showing management progress >80% level 3', 0, 0),
(UUID(), @m1_2, 'Capacitated Field Officer on governance, MAT, Protection, HWC, Livelihood monitoring by Dec 2026', 1, 0),
(UUID(), @m1_2, 'Completed Gov. training reports at least 4 per WMA, SEGA actions development progress report', 2, 0),
(UUID(), @m1_2, 'Customized SOPs and anti-poaching strategy documents, intelligence manual and data collection system. Construction of 1 Ranger Post and formal employment of 10 Rangers', 3, 0),
(UUID(), @m1_2, 'Stakeholder engagement report, implemented communication strategy, and 3 awareness films', 4, 0);

-- Milestone 1.3: Ruaha WMAs
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_3, 'MAT progress reports for Mbomipa and Waga', 0, 0),
(UUID(), @m1_3, 'Trained Field Officer', 1, 0),
(UUID(), @m1_3, 'SEGA actions reports', 2, 0),
(UUID(), @m1_3, 'Carbon & other business prospects reports for Waga & MBOMIPA WMAs', 3, 0),
(UUID(), @m1_3, '1 constructed RP for Waga', 4, 0),
(UUID(), @m1_3, 'Reports on Protection and HWC initiatives for Waga and MBOMIPA WMAs', 5, 0),
(UUID(), @m1_3, 'Livelihood initiatives reports', 6, 0);

-- Milestone 1.4: Ifinga
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_4, 'GMP and user right in place', 0, 0),
(UUID(), @m1_4, 'Reports of initial Ifinga WMA governance and management interventions', 1, 0),
(UUID(), @m1_4, 'Office space secured', 2, 0),
(UUID(), @m1_4, 'Professional staff in place', 3, 0),
(UUID(), @m1_4, 'Governance reports', 4, 0);

-- Milestone 2.1: Burunge
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_1, 'Burunge–Honeyguide light engagement MoU / agreement', 0, 0),
(UUID(), @m2_1, 'Governance meeting calendar and signed minutes', 1, 0),
(UUID(), @m2_1, 'Basic governance status checklist (minimum standards restored)', 2, 0),
(UUID(), @m2_1, 'Stakeholder engagement log (villages, AA, district, partners)', 3, 0);

-- Milestone 2.2: Makame
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_2, 'Updated sustainability scorecard (≥90%)', 0, 0),
(UUID(), @m2_2, 'Revised Makame Sustainability Plan', 1, 0),
(UUID(), @m2_2, 'SP26 partnership review note', 2, 0),
(UUID(), @m2_2, 'Carbon and community learning curriculum pack', 3, 0),
(UUID(), @m2_2, 'Learning centre improvement summary (with photos)', 4, 0),
(UUID(), @m2_2, 'New livelihood initiative concept note(s)', 5, 0);

-- Milestone 2.3: Randilen
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_3, 'Updated sustainability scorecard (≥90%) / human resources', 0, 0),
(UUID(), @m2_3, 'Combined Sustainability Plan + SP26 partnership review', 1, 0),
(UUID(), @m2_3, 'Tourism plan implementation progress report', 2, 0),
(UUID(), @m2_3, 'Photographic tourism learning hub curriculum and materials', 3, 0),
(UUID(), @m2_3, 'Learning centre upgrades summary (with photos)', 4, 0),
(UUID(), @m2_3, 'Livelihood initiatives summary sheet (existing + new) / strategy', 5, 0),
(UUID(), @m2_3, 'Pastoralist engagement summary (meetings, agreements)', 6, 0);

-- Milestone 2.4: Makao WMA
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_4, 'Darwin programme completion report (Makao section)', 0, 0),
(UUID(), @m2_4, 'Updated sustainability scorecard (≥80%)', 1, 0),
(UUID(), @m2_4, 'Governance and management improvement note', 2, 0),
(UUID(), @m2_4, 'Financial resilience snapshot (income vs core and protection costs)', 3, 0),
(UUID(), @m2_4, 'Tools/equipment handover list (HWC and protection)', 4, 0);

-- Milestone 2.5: Uyumbu WMA
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_5, 'Governance and technical training completion report', 0, 0),
(UUID(), @m2_5, 'Uyumbu MAT assessment (≥75% L4)', 1, 0),
(UUID(), @m2_5, 'Core management manuals and policies (ops, finance, HR, patrol/HWC SOPs)', 2, 0),
(UUID(), @m2_5, 'Community awareness film file/link + comms materials', 3, 0),
(UUID(), @m2_5, 'Film screening and dialogue report', 4, 0),
(UUID(), @m2_5, 'Protection and HWC pilot report', 5, 0),
(UUID(), @m2_5, 'Carbon feasibility study', 6, 0),
(UUID(), @m2_5, 'BEST', 7, 0);

-- Milestone 2.6: Other new WMAs
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m2_6, 'Governance basics starter pack (roles, templates, checklist)', 0, 0),
(UUID(), @m2_6, 'Training and governance meeting log', 1, 0),
(UUID(), @m2_6, 'Village mobilisation report (footprint and agreements)', 2, 0),
(UUID(), @m2_6, 'Feasibility and management pack per WMA', 3, 0),
(UUID(), @m2_6, 'Partner engagement summary (CWMAC, others, roles)', 4, 0),
(UUID(), @m2_6, '"Readiness for scaling" checklist per WMA', 5, 0);

-- Milestone 3.1: Governance
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_1, 'GCBF module piloted, revised, and finalized, with staff and partners trained through ToT and cascade sessions, and monitoring system in place', 0, 0),
(UUID(), @m3_1, '1–2 cost-effective awareness campaigns implemented, media collaboration strengthened, community feedback collected', 1, 0),
(UUID(), @m3_1, 'Rapid governance orientation and assessments for new WMA leaders conducted, all field officers trained', 2, 0),
(UUID(), @m3_1, 'Stakeholder engagement approach piloted in selected WMAs, leaders and staff trained', 3, 0),
(UUID(), @m3_1, 'WMA leaders trained to use the Rapid Governance Monitoring Tool, governance reviews conducted', 4, 0),
(UUID(), @m3_1, 'SAGE enhanced and expanded to support additional WMAs and partner programs', 5, 0);

-- Milestone 3.2: Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_2, 'Standardized FCG Monitoring Framework', 0, 0),
(UUID(), @m3_2, 'Pre-customized Quick Book Chart of Accounts', 1, 0),
(UUID(), @m3_2, 'Board financial oversight handbook for WMAs', 2, 0),
(UUID(), @m3_2, 'Packaging & publishing at least 5 additional Management Tools', 3, 0),
(UUID(), @m3_2, 'Pilot leadership training program report', 4, 0);

-- Milestone 3.3: Protection
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_3, 'HGF protection tools (SOPs, Best Practices Booklet, Engagement Strategy, Baseline Survey Template) compiled, packaged, and prepared for dissemination', 0, 0),
(UUID(), @m3_3, 'Standardized Protection Tools Package developed and distributed for all WMAs', 1, 0),
(UUID(), @m3_3, 'WMAs'' protection status monitored with quarterly reports', 2, 0),
(UUID(), @m3_3, 'Quarterly-updated checklist of recommendation for WMA anti-poaching practices developed and shared', 3, 0);

-- Milestone 3.4: HWC
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_4, 'At least 2 new innovative HEC toolkits invented', 0, 0),
(UUID(), @m3_4, 'HEC scaled up and engaged in at least 2 other countries with partners', 1, 0),
(UUID(), @m3_4, 'HEC methods guide compiled and packaged for use', 2, 0);

-- Milestone 3.5: Livelihoods
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_5, 'Education and Health program Framework drafted, reviewed, designed and finalised', 0, 0),
(UUID(), @m3_5, 'Implementation Reports of Kamitei Education Model for Mbomipa, Waga, and each of the Ruvuma 5 WMAs with baseline data', 1, 0),
(UUID(), @m3_5, 'Pilot reports of at least one Agriculture and one Microcredit project designed and launched', 2, 0),
(UUID(), @m3_5, 'Database (PDF and Excel) of 10+ livelihoods models studied and documented', 3, 0),
(UUID(), @m3_5, 'Reports of at least 2 new conservation financing mechanisms developed', 4, 0);

-- Milestone 3.6: Honeyguide Learning Hub
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_6, 'A repository of Honeyguide lessons and courses (PDFs, videos etc)', 0, 0),
(UUID(), @m3_6, 'Online self-paced learning courses', 1, 0),
(UUID(), @m3_6, 'Monitoring tools to measure learning uptake and changes', 2, 0);

-- Milestone 4.1: M&E
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m4_1, 'Updated functional data tracking tools for WMA indicators of success, accessible with sustainability score', 0, 0),
(UUID(), @m4_1, 'Developed Project Impact evaluation tool', 1, 0),
(UUID(), @m4_1, 'Data reflecting Honeyguide''s contribution to national strategy', 2, 0),
(UUID(), @m4_1, 'Evaluation reports for SP26 strategic plan review, assessments for Northern & Southern WMAs HWC', 3, 0),
(UUID(), @m4_1, 'Survey report on narrative change measuring community, stakeholder, and government perceptions', 4, 0),
(UUID(), @m4_1, 'Quarterly data updated and dashboards in Google Drive and Power BI', 5, 0),
(UUID(), @m4_1, 'At least one forum with WMA leaders/managers for feedback', 6, 0),
(UUID(), @m4_1, 'Quarterly presentation on project progress', 7, 0),
(UUID(), @m4_1, 'Quarterly consolidation of organization program reports', 8, 0);

-- Milestone 4.2: GIS and Mapping
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m4_2, 'Well organized, updated and accessible GIS data for programs use', 0, 0),
(UUID(), @m4_2, 'Developed template and trained WMA managers on satellite image data analysis and vegetation index query', 1, 0),
(UUID(), @m4_2, 'Developed specific WMA basemaps for reporting (incident and coverage)', 2, 0),
(UUID(), @m4_2, 'Story Maps to support Honeyguide communications', 3, 0),
(UUID(), @m4_2, 'Consistent, professional-quality maps support communication, M&E, and reporting', 4, 0);

-- Milestone 5.1: Honeyguide K9 Unit
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m5_1, 'Monthly K9 unit reports and quarterly stories', 0, 0),
(UUID(), @m5_1, 'MR training center developed and approved', 1, 0),
(UUID(), @m5_1, 'K9 medical plan and evacuation protocol in place with vaccination and treatment schedules', 2, 0);

-- Milestone 5.2: Rubondo Chimpanzee Habituation
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m5_2, 'Sightings above 100%, visibility 8-12m and 3hrs:45m in Northern Chimps subgroup', 0, 0),
(UUID(), @m5_2, 'Sightings above 50%, visibility 10-15m and 1hr in Southern Chimps subgroup', 1, 0),
(UUID(), @m5_2, '20km+ new trails in Southern Rubondo identified and cleared', 2, 0),
(UUID(), @m5_2, '5 Chimpanzee individuals identified and documented', 3, 0),
(UUID(), @m5_2, '17 chimp trackers trained on guiding techniques, 1st Aid, Navigation, and Botany', 4, 0),
(UUID(), @m5_2, '7 Community trackers attended English courses', 5, 0),
(UUID(), @m5_2, '7 community trackers equipped with Licence D', 6, 0),
(UUID(), @m5_2, '4-year action plan report developed and Reviewed MoU between HGF and TANAPA', 7, 0),
(UUID(), @m5_2, 'New marketing materials for Rubondo chimp products', 8, 0);

-- Milestone 6.1: Public Awareness
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_1, '10 TV shows on WMA related issues', 0, 0),
(UUID(), @m6_1, '3 radio stations broadcasting at local level on WMA issues', 1, 0),
(UUID(), @m6_1, '10 WMAs independently posting on social media', 2, 0);

-- Milestone 6.2: Stakeholder Perception
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_2, 'Benchmarking tool tested', 0, 0);

-- Milestone 6.3: Policy
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_3, '1x Plan and budget developed with clear roles of network team, clear goals, monitoring and outcomes developed and shared', 0, 0),
(UUID(), @m6_3, '4x Quarterly Reports developed', 1, 0);

-- Milestone 6.4: Regional Networks
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_4, 'Attended BCC conference', 0, 0),
(UUID(), @m6_4, 'Engaged in quarterly CLC network calls', 1, 0);

-- Milestone 6.5: Capacity Building
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_5, '2 key persons trained in advocacy and media', 0, 0);

-- Milestone 7.1: Financial Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_1, 'Training on the Financial and Procurement Manual in use', 0, 0),
(UUID(), @m7_1, 'Staff trained on financial systems and reporting', 1, 0),
(UUID(), @m7_1, 'An automated/digitized finance system reduces errors and delays', 2, 0),
(UUID(), @m7_1, 'Procurement Manual developed and approved by the board', 3, 0),
(UUID(), @m7_1, 'Transparent, competitive, and compliant procurement system operational', 4, 0),
(UUID(), @m7_1, 'Stronger donor confidence due to improved accountability and compliance', 5, 0);

-- Milestone 7.2: HR Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_2, 'Job profiles and grades finalized; Competency matrix approved; HR framework published', 0, 0),
(UUID(), @m7_2, '100% of staff appraised bi-annually; 2 training sessions and mentorship program implemented', 1, 0),
(UUID(), @m7_2, 'Succession plan for executives completed; 3 departmental pipelines developed', 2, 0),
(UUID(), @m7_2, '2 leadership workshops delivered; 100% managers trained in decision-making and coaching', 3, 0),
(UUID(), @m7_2, '1 culture survey conducted; Recognition program launched; Engagement index improved by 15%', 4, 0),
(UUID(), @m7_2, 'Data protection policy and registers developed; All staff trained on compliance', 5, 0);

-- Milestone 7.3: IT
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_3, 'All five core modules (Leave, Payroll, Performance, Assets, M&E) developed, tested, and deployed', 0, 0),
(UUID(), @m7_3, 'Data Protection Policy and compliance framework fully developed, approved, and rolled out', 1, 0),
(UUID(), @m7_3, 'ICT infrastructure maintained at 95%+ uptime, with quarterly preventive maintenance and license renewals', 2, 0),
(UUID(), @m7_3, 'Shared digital workspace for WMA resources established and actively used', 3, 0);

-- Milestone 7.4: Asset and Risk Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_4, 'Digital Asset Management System (linked to finance system) operational, with quarterly automated reports and annual physical verification completed', 0, 0),
(UUID(), @m7_4, 'Comprehensive Risk Management Framework finalized and implemented, with quarterly risk review reports and updated risk register', 1, 0);

-- Milestone 7.5: Workshop
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_5, '100% of fleet serviced on schedule, with >95% operational readiness', 0, 0),
(UUID(), @m7_5, '90%+ of repairs completed within 24 hours', 1, 0),
(UUID(), @m7_5, 'Standardized checklist adopted, reducing unscheduled repairs by 15% in Q1', 2, 0),
(UUID(), @m7_5, '100% of vehicles pass safety inspections; zero workshop-related accidents', 3, 0),
(UUID(), @m7_5, '100% of workshop staff trained and adhering to SOPs by year-end', 4, 0),
(UUID(), @m7_5, 'Accurate reports submitted on time with actionable insights', 5, 0);

-- Milestone 8.1: Fundraising
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_1, 'Key long-term donors maintained or increased contribution, at least one donor increased support by 20%', 0, 0),
(UUID(), @m8_1, 'Funding gap for 2026 reduced by 100%', 1, 0),
(UUID(), @m8_1, 'Funding gap for 2027 reduced by 70%', 2, 0),
(UUID(), @m8_1, 'Engaged in productive discussions with at least 2 donors that can contribute >50k per year', 3, 0),
(UUID(), @m8_1, 'Responded to at least 1 large multi-year international call (>400k - Darwin)', 4, 0),
(UUID(), @m8_1, 'MOUs and agreements with partners that include joint fundraising', 5, 0),
(UUID(), @m8_1, 'Raised necessary funds to support Special Programs (K9 + Rubondo) - HWC Lab potential', 6, 0);

-- Milestone 8.2: Systems and Tool Development
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_2, 'Collaborative dashboard with updated information/data tracking organizational impact 2017-2025', 0, 0),
(UUID(), @m8_2, 'Shared dashboard monitoring HGF impact on national WMA strategy 2023-2033', 1, 0),
(UUID(), @m8_2, 'Active online library with easy search and retrieve functions, HGF team trained', 2, 0),
(UUID(), @m8_2, 'Monthly updating from WhatsApp groups and organizing photos on Smugmug', 3, 0);

-- Milestone 8.3: Comms International
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_3, 'Four communication campaigns developed annually, one per quarter', 0, 0),
(UUID(), @m8_3, 'Donor Visibility Guidelines: one-page document per donor', 1, 0),
(UUID(), @m8_3, 'Annual Report produced', 2, 0),
(UUID(), @m8_3, 'Case Studies highlighting key field activities, produced quarterly', 3, 0),
(UUID(), @m8_3, 'Brochures & Presentations updated biannually', 4, 0),
(UUID(), @m8_3, 'Four 5-minute promotional videos produced annually', 5, 0),
(UUID(), @m8_3, 'Website Redesign: Honeyguide Innovation section added', 6, 0),
(UUID(), @m8_3, 'Communications Plan for 2026 created', 7, 0);

-- Milestone 8.4: Comms National
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_4, 'Produced quarterly newsletter in Swahili', 0, 0),
(UUID(), @m8_4, 'Weekly posts in social media and shared reports', 1, 0),
(UUID(), @m8_4, 'Posters designed and shared of Honeyguide work', 2, 0),
(UUID(), @m8_4, 'Honeyguide is live in Swahili', 3, 0);

-- Milestone 9.0: Honeyguide Oversight
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m9_0, 'At least 2 new board members recruited by end of year', 0, 0),
(UUID(), @m9_0, 'An online training course is designed and shared to the board members; all board members have completed the course', 1, 0),
(UUID(), @m9_0, 'Revised constitution in place. Onboarding procedure in place for new members', 2, 0),
(UUID(), @m9_0, 'Annual meeting dates communicated in January. 4 online board meetings held. 1 AGM held. Annual retreat of at least 2 days held', 3, 0);

-- ============================================
-- 5. CREATE TASKS
-- ============================================

-- Milestone 1.1: Ruvuma 5 WMAs Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_1, NULL, '1.1.1 MAT operational efficiency', 'MAT with a focus on achieving >80% Level 3 for operational efficiency, & filling training gaps to Field Officers.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.2 AA leadership & GIA governance', 'Strengthen AA leadership, decision-making and compliance so Ruvuma 5 WMAs meet mandatory GIA standards and uphold transparent, accountable participatory governance.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.3 Community-led protection & HWC', 'Developing and implementing community-led natural resource protection & HWC strategies that are cost-effective, data-driven, and show clear positive results on the ground.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.4 Community livelihood programs', 'Delivering cost-effective, data-driven community livelihood programs with measurable social impact.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.5 SMART engagement strategies', 'Implement SMART engagement strategies to raise awareness, strengthen collaboration, and foster pastoralist WMA ownership.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.2: Liwale Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_2, NULL, '1.2.1 MAT operational efficiency', 'MAT aiming for >80% Level 3 in operational efficiency, & filling training gaps of Field Officers.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.2 Governance interventions & GIA', 'Implement targeted governance interventions & GIA actions to provide an enabling environment for governance best practices in daily WMA operations.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.3 Community-led protection', 'Implementing community-led natural resource protection strategies that are cost-effective, data-driven, and show clear positive results on the ground.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.4 Stakeholder engagement & comms', 'Customize and implement SMART stakeholder engagement and communications strategies to raise awareness, and enhance collaboration and ownership of WMA initiatives.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.5 SEGA Actions in Liwale', 'Implementing SEGA Actions in Liwale WMA.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.3: Ruaha WMAs Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_3, NULL, '1.3.1 MAT Mbomipa & Waga', 'MAT in Mbomipa and Waga WMAs, to reach 80% MAT level 3.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.2 Governance & GIA interventions', 'Implement targeted governance and GIA interventions addressing SAGE findings.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.3 Alternative financing models', 'Develop alternative financing and business models to ensure WMAs'' sustainability.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.4 Protection & HWC strategies', 'Exploring cost-effective community-led natural resource protection & HWC strategies that are data-driven and show clear positive results on the ground.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.5 Community livelihood programs', 'Implement community-led, cost-effective, data-driven livelihood programs showing social and behavioral benefits.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.4: Ifinga Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_4, NULL, '1.4.1 WMA establishment support', 'Support Ifinga WMA communities and relevant stakeholders in the establishment of the WMA.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_4, NULL, '1.4.2 Basic governance & management training', 'Support WMA basic governance & management trainings.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW());

-- Milestone 2.1: Burunge Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_1, NULL, '2.1.1 Re-establish Burunge relationship', 'Re-establish a constructive working relationship with Burunge WMA.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW());

-- Milestone 2.2: Makame Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_2, NULL, '2.2.1 Sustainability indicators ≥90%', 'Achieve ≥90% on Makame sustainability indicators and update the Sustainability Plan and SP26 partnership accordingly.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_2, NULL, '2.2.2 Carbon & community learning hub', 'Strengthen Makame as a carbon-and-community learning hub by improving the curriculum and learning centre infrastructure.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_2, NULL, '2.2.3 Additional livelihood initiatives', 'Develop additional livelihood initiatives that increase Makame community benefits beyond health and education.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.3: Randilen Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_3, NULL, '2.3.1 Sustainability indicators ≥90%', 'Achieve ≥90% on Randilen sustainability indicators and update the Sustainability Plan and renewed partnership / focus on human resources and capacity.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_3, NULL, '2.3.2 Photographic tourism learning hub', 'Position Randilen as a leading photographic tourism learning hub by improving curriculum, learning centre infrastructure, and implementing the tourism plan.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_3, NULL, '2.3.3 Additional livelihood initiatives', 'Develop additional livelihood initiatives that increase Randilen community benefits beyond health and education.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.4: Makao WMA Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_4, NULL, '2.4.1 Darwin programme completion', 'Finalise the Darwin-funded programme, delivering agreed habitat, governance, and livelihood improvements in Makao.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_4, NULL, '2.4.2 Sustainability score ≥80%', 'Raise Makao''s sustainability score to ≥80% by strengthening governance, management, and a cost-effective protection unit.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_4, NULL, '2.4.3 Financial & community benefits plan', 'Establish a simple financial and community benefits plan that supports Makao''s growth and resilience.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.5: Uyumbu WMA Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_5, NULL, '2.5.1 Governance to MAT ≥75% L3', 'Strengthen Uyumbu governance to MAT ≥75% L3 through targeted capacity building (technical training, learning tour) and core management manuals, guidelines, and policies.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_5, NULL, '2.5.2 Community trust & awareness', 'Rebuild community and stakeholder trust via a short awareness film, concise communication materials, and facilitated dialogue screenings.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_5, NULL, '2.5.3 Protection, HWC & carbon feasibility', 'Pilot strategic protection and human–wildlife conflict operations and complete a carbon-business feasibility assessment to secure sustainable revenue streams, including a clear BEST.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.6: Other new WMAs Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_6, NULL, '2.6.1 Governance basics establishment', 'Establish governance basics (clarified roles, minuted decision-making meetings, short practical training) using a light-touch engagement model as time and resources allow.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_6, NULL, '2.6.2 Scalable livelihood models', 'Explore scalable livelihood models for Northern WMAs, including community banks and community training with SAWC.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- Milestone 3.1: Governance Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_1, NULL, '3.1.1 Pilot & monitor GCBF Module', 'Pilot, Cascade, and Monitor the GCBF Module.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.2 Institutionalize governance docs & tools', 'Institutionalize and package all existing governance documents, GIA, tools, and methodologies for standardized use across WMAs.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.3 Rapid governance training for new leaders', 'Pilot and Support Rapid Governance Training for New WMA Leaders.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.4 Stakeholder engagement approach pilot', 'Pilot Testing and Learning from the Stakeholder Engagement & Communication Approach.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.5 Rapid Governance Monitoring Tool', 'Provide initial training and support for the WMA Rapid Governance Monitoring Tool for regular governance assessments.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.6 Enhance & scale SAGE', 'Enhance and scale SAGE for wider adoption across WMAs and partner programs beyond HGF''s primary areas.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW());

-- Milestone 3.2: Management Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_2, NULL, '3.2.1 FCG Monitoring tool', 'Develop FCG Monitoring tool and testing.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.2 QuickBooks lite setup for WMAs', 'Develop pre-customized Quickbook lite setup file for WMAs (to build uniformity across WMAs).', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.3 Board Financial Oversight Handbook', 'Develop WMA Board Financial Oversight Handbook + Tools (Helps governance members challenge management constructively and make informed approvals).', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.4 WMA Management Toolbox', 'Design and consolidate a comprehensive WMA Management Toolbox and publish at least five additional tools guided by sound financial and operational management of WMAs.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.5 Leadership Training Program pilot', 'Implement a pilot of the pre-designed WMA Management Leadership Training Program across selected WMAs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 3.3: Protection Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_3, NULL, '3.3.1 Package protection docs & tools', 'Institutionalize and package all existing protection documents, tools, and methodologies for standardized use across WMAs.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.2 Low-cost protection strategies', 'Ensure all WMAs adopt and comply with low-cost, effective protection strategies and methodologies.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.3 Anti-poaching tools monitoring', 'Conduct regular assessments and monitoring of anti-poaching tools to ensure full functionality and effectiveness.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.4 Anti-poaching improvement checklist', 'Develop a checklist of recommendation for anti-poaching strategic improvement.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- Milestone 3.4: HWC Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_4, NULL, '3.4.1 HEC toolkit innovation', 'Drive toolkit innovation process by gathering insights through listening, creating designs, testing prototypes, validating scientifically, and scaling successful solutions.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_4, NULL, '3.4.2 HEC mitigation beyond WMAs', 'Explore HEC mitigation strategies beyond WMAs and outside the country.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_4, NULL, '3.4.3 Package HEC methodologies', 'Institutionalize and packaging available HEC methodologies.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 3.5: Livelihoods Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_5, NULL, '3.5.1 Education & Health replication playbook', 'Document the Makame Education and Health models into a replication playbook framework while preparing Makame WMA to fully own these programs beyond Honeyguide''s support.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.2 Kamitei Education replication', 'Replicate the Kamitei Education program into Mbomipa, Waga and Ruvuma 5 WMAs, ensuring WMA ownership and financial contributions.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.3 Agriculture & microcredit pilots', 'Explore and pilot Agriculture and microcredit initiatives that can be integrated into WMA livelihood portfolios and scaled as community-owned models.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.4 Livelihood programs inventory', 'Build a detailed, research-backed inventory of at least 10 livelihood-improvement programs suitable for rural WMA communities.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.5 New financing models (CTFs, etc.)', 'Co-design at least 2 new financing models (CTFs, HWC insurance, BD credits etc) for WMAs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 3.6: Honeyguide Learning Hub Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_6, NULL, '3.6.1 Knowledge repository', 'Research and development of a repository of tools, knowledge, and information, including videos, PDFs, and Google Docs.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_6, NULL, '3.6.2 Online courses & monitoring', 'Design online courses and sessions for both individual and group learning, incorporating monitoring mechanisms to track uptake and learning progress.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- Milestone 4.1: M&E Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m4_1, NULL, '4.1.1 M&E tools & systems design', 'Design, Develop, and Implementation of M&E Tools and Systems.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.2 Program impacts & evaluation', 'Program Impacts and Evaluation.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.3 M&E capacity building', 'M&E Capacity Building for WMAs and partners (Training, Mentorship, and Coaching).', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.4 Quarterly data quality & reports', 'Ensure accurate, consistent, quality data and reports quarterly.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.5 Ecological monitoring & evidence', 'Ecological Monitoring and Evidence Generation.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 4.2: GIS and Mapping Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m4_2, NULL, '4.2.1 GIS maps & tools for project areas', 'Develop GIS maps and tools for all project areas to include all potential information for investment and protection.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m4_2, NULL, '4.2.2 Map making & navigation capacity', 'Establishing Capacity for Map Making and Navigation to Support Honeyguide Initiatives.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- Milestone 5.1: Honeyguide K9 Unit Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m5_1, NULL, '5.1.1 Maintain 24/7 standby K9 unit', 'Maintaining a standby canine unit that is 24/7 ready to respond to all calls in our working areas.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m5_1, NULL, '5.1.2 Strengthen K9 operations & reporting', 'Strengthening K9 unit operations and reporting.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m5_1, NULL, '5.1.3 HGF-Kuru-Manyara collaboration', 'Strengthen collaboration between HGF, Kuru and Manyara Board of Trustee.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 5.2: Rubondo Chimpanzee Habituation Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m5_2, NULL, '5.2.1 Northern chimps habituation', 'Continued habituation of the northern chimps sub-group.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.2 Southern chimps mapping & monitoring', 'Start habituating the southern chimp subgroup through mapping and monitoring.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.3 Chimp tourism & tracker training', 'Strengthen chimpanzee tourism through habituation and tracker training.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.4 Marketing with TANAPA', 'Improve marketing and advertising of the Chimp product with TANAPA.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.5 New 4-year action plan', 'Develop a new 4-year action plan that includes a diversified fundraising strategy.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW());

-- Milestone 6.1: Public Awareness Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_1, NULL, '6.1.1 National & local media awareness', 'National and local media and general public awareness.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW());

-- Milestone 6.2: Stakeholder Perception Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_2, NULL, '6.2.1 Narrative benchmark assessment', 'Stakeholder narrative benchmark assessment.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW());

-- Milestone 6.3: Policy Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_3, NULL, '6.3.1 Policy network & facilitation', 'Policy network and facilitation.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW());

-- Milestone 6.4: Regional Networks Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_4, NULL, '6.4.1 Regional CLC narrative', 'Regional narrative on CLC.', 'todo', 'low', '2026-12-31', 0, NOW(), NOW());

-- Milestone 6.5: Capacity Building Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_5, NULL, '6.5.1 Advocacy & media training', 'Training and equipment for advocacy and media teams.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW());

-- Milestone 7.1: Financial Management Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_1, NULL, '7.1.1 Finance & procurement manual awareness', 'Awareness of finance and procurement manual procedures and practices.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.2 Internal audit & compliance', 'Strengthen internal audit and compliance mechanisms and follow up on Audit recommendations.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.3 Donor-specific dashboards & automation', 'Enhance financial reporting by introducing donor-specific dashboards and automating report generation.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.4 Long-term financial planning', 'Strategic long-term financial planning.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.5 Budget & cashflow monitoring', 'Annual Budget and Cashflow development and monitoring.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.6 e-Asset & e-Procurement rollout', 'Roll out e-Asset management (Asset lists, regular inventory, valuation, security, insurance) and improve e-procurement system within the finance system.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW());

-- Milestone 7.2: HR Management Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_2, NULL, '7.2.1 Workforce planning & job evaluation', 'Workforce Planning, Compensation and Benefits – Develop job profiles, competency models, and conduct a comprehensive job evaluation to establish clear job grades.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.2 Performance management improvement', 'Strengthen the performance management system and support employee development through training, mentorship, and cross-department exposure.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.3 Staff training & development', 'Identify organization development priority and ensure implementation of staff development activities and measure its impact.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.4 HRIS integration & consolidation', 'Automate all HR processes and consolidate different HR systems to one system.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.5 Culture & engagement improvement', 'Launch engagement programs with surveys, accountability initiatives, recognition schemes, and a strong Employer Value Proposition.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.6 HR compliance & data protection', 'Implement a personal data protection compliance program with policies, training, registers, and clear oversight roles.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW());

-- Milestone 7.3: IT Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_3, NULL, '7.3.1 App development (Leave, Payroll, etc.)', 'App Development – Leave, Payroll, Performance, Assets, M&E, HGF Website, Honeyguide Learning.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.2 Data protection & compliance', 'Establish strong data protection measures aligned with national and international standards.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.3 Tech support & maintenance', 'Deliver regular IT support for internet, hardware, software, and maintain in-house web/mobile applications. Provide IT equipment and upgrade mobile internet infrastructure.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.4 Collaboration & knowledge sharing', 'Create a shared digital workspace for WMA resources and support the Honeyguide Learning Initiative with platforms, tools, and knowledge-sharing systems.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- Milestone 7.4: Asset and Risk Management Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_4, NULL, '7.4.1 Asset management system', 'Maintain and optimize asset management system for efficiency, accountability, and sustainability.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_4, NULL, '7.4.2 Risk management framework', 'Strengthen organizational risk management framework and implement monitoring processes for financial, cyber, and political risks.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- Milestone 7.5: Workshop Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_5, NULL, '7.5.1 Fleet management & safety', 'Enhancing scheduled Workshop and vehicles by implementing a Fleet Management System, standardize Workshop Processes and Enhance Safety & Compliance Culture.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.2 Zero lost-time injuries target', 'Achieve Zero Lost-Time Injuries in the workshop and for fleet operations.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.3 Spare parts & lifecycle analysis', 'Analyze and consolidate spare part suppliers for bulk discounts and conduct a lifecycle cost analysis for each vehicle.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.4 Fuel & maintenance metrics', 'Monitor and report on key metrics: Fuel Use, Maintenance Cost per Kilometer.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.5 Quarterly workshop review', 'Perform quarterly internal review on workshop practices.', 'todo', 'low', '2026-12-31', 4, NOW(), NOW());

-- Milestone 8.1: Fundraising Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m8_1, NULL, '8.1.1 Top ten donor engagement', 'Strategically engage with our current top ten donors to encourage them to increase their contribution.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.2 Broaden donor base', 'Broaden current donor base by actively pursuing potential donors that have an interest in Honeyguide priority areas.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.3 Funding opportunities & proposals', 'Monitor and respond to active funding opportunities and calls for proposals for financial assistance.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.4 Joint funding tools & agreements', 'Develop tools and agreements with key partners to streamline joint funding applications.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.5 Special programs funding partners', 'Strategically search for funding partners that have an interest in any of the special programs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 8.2: Systems and Tool Development Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m8_2, NULL, '8.2.1 Build comms tools capacity', 'Build capacity with new tools for comms.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.2 Comms team data training', 'Training comms team and coaching on use and access of the data.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.3 AI for communications', 'Design, test, and develop knowledge resource of AI for communications.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.4 Communications App management', 'Manage and maintain the Honeyguide Communications App, training and coach Honeyguide team to participate and update activities in the app.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- Milestone 8.3: Comms International Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m8_3, NULL, '8.3.1 Thematic communication campaigns', 'Package and produce communication campaigns in the form of thematic areas, where each theme is supported by a data sheet and editorial (for blogs, newsletters, social media and webinars).', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.2 One-way communications (blogs, etc.)', 'Produce regular one-way communications (blogs, publications, newsletters, videos) and monitor views.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.3 Two-way communications (webinars, etc.)', 'Produce material to support two-way communications (webinar, 1-1 meetings, presentations).', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.4 Website updates', 'Ongoing updates in the website with current information (introduction Honeyguide Innovation) and organizational development.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.5 2026 Communications plan', 'Create a 2026 Communications plan.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW());

-- Milestone 8.4: Comms National Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m8_4, NULL, '8.4.1 Swahili quarterly newsletter', 'Production of Newsletter (every quarter) in Swahili with project updates and organization news.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.2 Swahili social media posts', 'Regular social media posts in Swahili.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.3 Honeyguide awareness posters', 'Design and develop Honeyguide awareness posters (posters to show Honeyguide work and approach) and publications in Swahili.', 'todo', 'low', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.4 Swahili website', 'Design and develop Honeyguide Swahili website and publish.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- Milestone 9.0: Honeyguide Oversight Tasks
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m9_0, NULL, '9.1.1 Recruit diverse board members', 'Recruit additional board members that come from diverse backgrounds and support our board development plan.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.2 Board training & onboarding', 'Provide the board with training materials and a training and onboarding process to build the capacity of the board members to understand their roles.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.3 Board policies & procedures', 'Develop board guiding policies, procedures and systems that continue to aid the board''s capability to perform their roles.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.4 Board meetings & AGM management', 'Plan and manage all documentation and procedures for board meetings including the committees meetings, AGM and annual retreat.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW());

-- ============================================
-- 6. CREATE TAGS (using IGNORE to skip duplicates)
-- ============================================
INSERT IGNORE INTO tag (id, created_by_id, name, color, created_at) VALUES
(UUID(), @user_admin, 'governance', '#3b82f6', NOW()),
(UUID(), @user_admin, 'management', '#22c55e', NOW()),
(UUID(), @user_admin, 'protection', '#ef4444', NOW()),
(UUID(), @user_admin, 'HWC', '#f97316', NOW()),
(UUID(), @user_admin, 'livelihoods', '#8b5cf6', NOW()),
(UUID(), @user_admin, 'M&E', '#06b6d4', NOW()),
(UUID(), @user_admin, 'GIS', '#14b8a6', NOW()),
(UUID(), @user_admin, 'fundraising', '#eab308', NOW()),
(UUID(), @user_admin, 'communications', '#ec4899', NOW()),
(UUID(), @user_admin, 'finance', '#84cc16', NOW()),
(UUID(), @user_admin, 'HR', '#d946ef', NOW()),
(UUID(), @user_admin, 'IT', '#6b7280', NOW());

-- ============================================
-- 7. CREATE TASK ASSIGNEES
-- Note: This requires task IDs which are generated above.
-- We'll create a separate script for assignees after tasks are created.
-- ============================================

SELECT 'Workplan data import completed!' AS status;
SELECT COUNT(*) AS users_created FROM user;
SELECT COUNT(*) AS targets_created FROM milestone_target;
SELECT COUNT(*) AS tasks_created FROM task;
SELECT COUNT(*) AS members_created FROM project_member;
SELECT COUNT(*) AS tags_created FROM tag;
