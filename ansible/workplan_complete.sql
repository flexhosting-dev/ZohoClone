-- ============================================
-- COMPLETE WORKPLAN FIXTURES
-- Production-safe, idempotent
-- Includes: Projects, Milestones, Deliverables, Tasks, Users, Tags
-- ============================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Get Sam's ID (the super admin)
SET @sam_id = (SELECT id FROM user WHERE email = 'sam@honeyguide.org');

-- Get role IDs
SET @role_superadmin = (SELECT id FROM role WHERE slug = 'portal-super-admin');
SET @role_admin = (SELECT id FROM role WHERE slug = 'portal-admin');
SET @role_manager = (SELECT id FROM role WHERE slug = 'project-manager');
SET @role_member = (SELECT id FROM role WHERE slug = 'project-member');

-- ============================================
-- 1. CREATE TEAM MEMBERS (if they don't exist)
-- ============================================

-- Helper to create users safely
INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'sylvester@honeyguide.org', '["ROLE_USER"]', 'Sylvester', 'Mwehozi', 1, NOW(), NOW(), @role_admin, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'sylvester@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'max@honeyguide.org', '["ROLE_USER"]', 'Max', 'Chami', 1, NOW(), NOW(), @role_admin, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'max@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'fatma@honeyguide.org', '["ROLE_USER"]', 'Fatma', 'Mfinanga', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'fatma@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'namnyaki@honeyguide.org', '["ROLE_USER"]', 'Namnyaki', 'Laizer', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'namnyaki@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'kateto@honeyguide.org', '["ROLE_USER"]', 'Kateto', 'Olekashe', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'kateto@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'lemuta@honeyguide.org', '["ROLE_USER"]', 'Lemuta', 'Laizer', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'lemuta@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'glad@honeyguide.org', '["ROLE_USER"]', 'Gladness', 'Kayombo', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'glad@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'daudi@honeyguide.org', '["ROLE_USER"]', 'Daudi', 'Peterson', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'daudi@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'michael@honeyguide.org', '["ROLE_USER"]', 'Michael', 'Madoshi', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'michael@honeyguide.org');

INSERT INTO user (id, email, roles, first_name, last_name, is_verified, created_at, updated_at, portal_role_id, ui_theme, favourite_project_ids, recent_project_ids, notification_preferences)
SELECT UUID(), 'meleck@honeyguide.org', '["ROLE_USER"]', 'Meleck', 'Mwansasu', 1, NOW(), NOW(), @role_member, 'gradient', '[]', '[]', '{"email":true,"inApp":true}'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'meleck@honeyguide.org');

-- Get user IDs
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

-- ============================================
-- 2. CREATE/UPDATE PROJECTS
-- ============================================

-- Delete existing projects (except Sam's Personal Project) and recreate for clean slate
DELETE FROM project WHERE name LIKE 'A.%' OR name LIKE 'B.%' OR name LIKE 'C.%' OR name LIKE 'D.%' OR name LIKE 'E.%' OR name LIKE 'F.%' OR name LIKE 'G.%' OR name LIKE 'H.%' OR name LIKE 'I.%';

-- Project A
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'A. Southern WMAs Portfolio',
'Wildlife Management Areas under Honeyguide management in Southern Tanzania. This portfolio includes:
- Ruvuma 5 WMAs (Tunduru, Namtumbo, Songea Rural, Mbinga, Nyasa)
- Liwale (Magingo WMA)
- Ruaha WMAs (MBOMIPA, Pawaga-Idodi, Wamimbiki)
- Ifinga WMA (new establishment)

Focus areas: MAT operational efficiency, governance strengthening, community-led protection, HWC mitigation, and sustainable livelihoods.',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project B
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'B. Northern WMAs Portfolio',
'Wildlife Management Areas under Honeyguide management in Northern Tanzania. This portfolio includes:
- Burunge WMA
- Makame WMA (carbon and community learning hub)
- Randilen WMA (photographic tourism hub)
- Makao WMA (Darwin-funded programme)
- Uyumbu WMA (governance strengthening)
- Emerging WMAs: UMEMARUWA, Kilolo, Chamwino

Focus areas: Sustainability indicators, tourism development, carbon initiatives, and community benefits.',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project C
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'C. Technical Innovations',
'Cross-cutting technical support programs that strengthen WMA operations across all landscapes:
- Governance: GCBF module, SAGE system, rapid governance training
- Management: FCG monitoring, QuickBooks setup, leadership training
- Protection: Anti-poaching tools, SOPs, monitoring systems
- HWC: Human-Elephant Conflict toolkits and mitigation strategies
- Livelihoods: Education, health, agriculture, microcredit programs
- Honeyguide Learning Hub: Online courses, knowledge repository',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project D
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'D. Monitoring & Evaluation',
'M&E systems and GIS capabilities for tracking conservation outcomes:
- M&E Systems: Data tracking tools, impact evaluation, dashboards
- GIS and Mapping: Spatial analysis, basemaps, story maps
- Program evaluation and stakeholder perception monitoring
- Quarterly reporting and data quality assurance',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project E
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'E. Expanding Honeyguide Footprint',
'New and expanding conservation initiatives:
- Honeyguide K9 Unit: Detection dog unit for wildlife protection
- Rubondo Chimpanzee Project: Habituation and tourism development
- Mahale: Ecosystem conservation initiatives

These special programs extend Honeyguide''s impact beyond traditional WMA support.',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project F
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'F. External Engagement',
'Advocacy, policy engagement, and strategic partnerships:
- National Advocacy: Media engagement, public awareness, policy influence
- International Engagement: Global conservation networks, conferences
- Strategic Partnerships: Key stakeholder relationships
- Research Partnerships: Academic collaborations
- Capacity Building: Training partners and stakeholders',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project G
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'G. Operations & HR',
'Internal operations and organizational development:
- Financial Management: Systems, reporting, compliance, audit
- HR Management: Workforce planning, performance, training, culture
- IT Systems: Application development, data protection, infrastructure
- Asset and Risk Management: Fleet, equipment, risk mitigation
- Workshop: Vehicle maintenance, safety, fleet management',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project H
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
VALUES (UUID(), @sam_id, 'H. Resource Mobilization & Comms',
'Fundraising and communications:
- Fundraising: Donor engagement, grant writing, partnerships
- Systems Development: Dashboards, knowledge management, AI tools
- International Communications: Campaigns, publications, website
- National Communications: Swahili content, local media, social media',
'active', '2026-01-01', '2026-12-31', NOW(), NOW());

-- Project I
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'I. Honeyguide Board Governance',
'Board oversight and organizational governance:
- Board recruitment and development
- Training and onboarding processes
- Constitution and policy development
- Meeting management and AGM coordination
- Strategic oversight and guidance',
'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'I. Honeyguide Board Governance');

-- ============================================
-- 3. GET PROJECT IDs
-- ============================================
SET @proj_a = (SELECT id FROM project WHERE name LIKE 'A.%');
SET @proj_b = (SELECT id FROM project WHERE name LIKE 'B.%');
SET @proj_c = (SELECT id FROM project WHERE name LIKE 'C.%');
SET @proj_d = (SELECT id FROM project WHERE name LIKE 'D.%');
SET @proj_e = (SELECT id FROM project WHERE name LIKE 'E.%');
SET @proj_f = (SELECT id FROM project WHERE name LIKE 'F.%');
SET @proj_g = (SELECT id FROM project WHERE name LIKE 'G.%');
SET @proj_h = (SELECT id FROM project WHERE name LIKE 'H.%');
SET @proj_i = (SELECT id FROM project WHERE name LIKE 'I.%');

-- ============================================
-- 4. ADD PROJECT MEMBERS
-- ============================================

-- Sam as manager for all projects
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_a, @sam_id, @role_manager, NOW()),
(UUID(), @proj_b, @sam_id, @role_manager, NOW()),
(UUID(), @proj_c, @sam_id, @role_manager, NOW()),
(UUID(), @proj_d, @sam_id, @role_manager, NOW()),
(UUID(), @proj_e, @sam_id, @role_manager, NOW()),
(UUID(), @proj_f, @sam_id, @role_manager, NOW()),
(UUID(), @proj_g, @sam_id, @role_manager, NOW()),
(UUID(), @proj_h, @sam_id, @role_manager, NOW()),
(UUID(), @proj_i, @sam_id, @role_manager, NOW());

-- Sylvester - Southern WMAs lead
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_a, @user_sylvester, @role_manager, NOW());

-- Max - Northern WMAs lead
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_b, @user_max, @role_manager, NOW());

-- Fatma - Governance
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_c, @user_fatma, @role_member, NOW());

-- Namnyaki - Protection
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_c, @user_namnyaki, @role_member, NOW());

-- Kateto - HWC
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_c, @user_kateto, @role_member, NOW());

-- Glad - M&E
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_d, @user_glad, @role_member, NOW());

-- Michael - GIS
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_d, @user_michael, @role_member, NOW());

-- Meleck - K9 Unit
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_e, @user_meleck, @role_member, NOW());

-- Daudi - Finance
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_g, @user_daudi, @role_member, NOW());

-- Lemuta - Comms
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at) VALUES
(UUID(), @proj_h, @user_lemuta, @role_member, NOW());

-- ============================================
-- 5. CREATE MILESTONES FOR PROJECT A
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_a, '1.1 Ruvuma 5 WMAs',
'Tunduru, Namtumbo, Songea Rural, Mbinga, Nyasa WMAs - achieving >80% Level 3 MAT, strengthening governance, community-led protection, and sustainable livelihoods.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_a, '1.2 Liwale (Magingo WMA)',
'Liwale/Magingo WMA management - MAT implementation, governance training, SEGA actions, and stakeholder engagement.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_a, '1.3 Ruaha WMAs',
'Mbomipa, Pawaga-Idodi, and Wamimbiki WMAs - MAT progress, alternative financing, protection strategies, and livelihood programs.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_a, '1.4 Ifinga',
'Ifinga WMA establishment - GMP development, user rights, governance and management training, office setup.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 6. CREATE MILESTONES FOR PROJECT B
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_b, '2.1 Burunge',
'Re-establishing Honeyguide-Burunge relationship, governance meetings, minimum standards restoration.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_b, '2.2 Makame',
'Carbon and community learning hub - ≥90% sustainability score, curriculum development, livelihood initiatives.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_b, '2.3 Randilen',
'Photographic tourism learning hub - ≥90% sustainability, tourism plan implementation, pastoralist engagement.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_b, '2.4 Makao WMA',
'Darwin programme completion, ≥80% sustainability score, governance strengthening, HWC tools deployment.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_b, '2.5 Uyumbu WMA',
'Governance capacity to MAT ≥75% L3, community awareness, protection pilot, carbon feasibility assessment.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_b, '2.6 Other new WMAs',
'UMEMARUWA, Kilolo, Chamwino - governance basics, village mobilisation, feasibility studies, partner engagement.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 7. CREATE MILESTONES FOR PROJECT C
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_c, '3.1 Governance',
'GCBF module piloting, awareness campaigns, rapid governance training, SAGE enhancement.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_c, '3.2 Management',
'FCG monitoring framework, QuickBooks setup, board oversight handbook, management toolbox.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_c, '3.3 Protection',
'Protection tools package, standardized methodologies, quarterly monitoring, improvement recommendations.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_c, '3.4 HWC',
'HEC toolkit innovation, expansion to other countries, methodology packaging.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_c, '3.5 Livelihoods',
'Education/health framework, Kamitei replication, agriculture pilots, livelihood inventory, financing models.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_c, '3.6 Honeyguide Learning Hub',
'Knowledge repository, online courses, learning monitoring tools.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 8. CREATE MILESTONES FOR PROJECT D
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_d, '4.1 M&E Systems',
'Data tracking tools, impact evaluation, national strategy contribution, quarterly dashboards.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_d, '4.2 GIS and Mapping',
'GIS data organisation, satellite analysis training, WMA basemaps, story maps.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 9. CREATE MILESTONES FOR PROJECT E
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_e, '5.1 Honeyguide K9 Unit',
'24/7 standby canine unit, training center development, medical protocols.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_e, '5.2 Rubondo Chimpanzee Project',
'Northern/southern chimps habituation, tracker training, marketing, 4-year action plan.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_e, '5.3 Mahale',
'Mahale ecosystem conservation initiatives development.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 10. CREATE MILESTONES FOR PROJECT F
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_f, '6.1 National Advocacy',
'TV shows, radio broadcasts, WMA social media presence.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_f, '6.2 International Engagement',
'Stakeholder perception benchmarking and assessment.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_f, '6.3 Strategic Partnerships',
'Policy network planning, budget development, quarterly reporting.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_f, '6.4 Research Partnerships',
'BCC conference, CLC network engagement.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_f, '6.5 Capacity Building',
'Advocacy and media training for key personnel.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 11. CREATE MILESTONES FOR PROJECT G
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_g, '7.1 Financial Management',
'Finance manual training, audit compliance, automation, procurement system.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_g, '7.2 HR Management',
'Job profiles, performance management, succession planning, culture improvement.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_g, '7.3 IT Systems',
'Application development (Leave, Payroll, etc.), data protection, infrastructure.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_g, '7.4 Asset and Risk Management',
'Digital asset management, risk framework, quarterly reviews.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_g, '7.5 Workshops and Retreats',
'Fleet management, safety compliance, maintenance optimization.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 12. CREATE MILESTONES FOR PROJECT H
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at) VALUES
(UUID(), @proj_h, '8.1 Fundraising',
'Donor engagement, funding gap reduction, partnership development.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_h, '8.2 Systems Development',
'Dashboards, AI tools, communications app, knowledge management.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_h, '8.3 International Communications',
'Campaigns, annual report, case studies, videos, website redesign.',
'open', '2026-12-31', NOW(), NOW()),

(UUID(), @proj_h, '8.4 National Communications',
'Swahili newsletter, social media, posters, Swahili website.',
'open', '2026-12-31', NOW(), NOW());

-- ============================================
-- 13. CREATE MILESTONE FOR PROJECT I
-- ============================================

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_i, '9.0 Board Oversight',
'Board recruitment, training, constitution review, meeting management, AGM coordination.',
'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_i AND name = '9.0 Board Oversight');

-- ============================================
-- 14. GET MILESTONE IDs
-- ============================================
SET @m1_1 = (SELECT id FROM milestone WHERE project_id = @proj_a AND name LIKE '1.1%');
SET @m1_2 = (SELECT id FROM milestone WHERE project_id = @proj_a AND name LIKE '1.2%');
SET @m1_3 = (SELECT id FROM milestone WHERE project_id = @proj_a AND name LIKE '1.3%');
SET @m1_4 = (SELECT id FROM milestone WHERE project_id = @proj_a AND name LIKE '1.4%');

SET @m2_1 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.1%');
SET @m2_2 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.2%');
SET @m2_3 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.3%');
SET @m2_4 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.4%');
SET @m2_5 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.5%');
SET @m2_6 = (SELECT id FROM milestone WHERE project_id = @proj_b AND name LIKE '2.6%');

SET @m3_1 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.1%');
SET @m3_2 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.2%');
SET @m3_3 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.3%');
SET @m3_4 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.4%');
SET @m3_5 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.5%');
SET @m3_6 = (SELECT id FROM milestone WHERE project_id = @proj_c AND name LIKE '3.6%');

SET @m4_1 = (SELECT id FROM milestone WHERE project_id = @proj_d AND name LIKE '4.1%');
SET @m4_2 = (SELECT id FROM milestone WHERE project_id = @proj_d AND name LIKE '4.2%');

SET @m5_1 = (SELECT id FROM milestone WHERE project_id = @proj_e AND name LIKE '5.1%');
SET @m5_2 = (SELECT id FROM milestone WHERE project_id = @proj_e AND name LIKE '5.2%');
SET @m5_3 = (SELECT id FROM milestone WHERE project_id = @proj_e AND name LIKE '5.3%');

SET @m6_1 = (SELECT id FROM milestone WHERE project_id = @proj_f AND name LIKE '6.1%');
SET @m6_2 = (SELECT id FROM milestone WHERE project_id = @proj_f AND name LIKE '6.2%');
SET @m6_3 = (SELECT id FROM milestone WHERE project_id = @proj_f AND name LIKE '6.3%');
SET @m6_4 = (SELECT id FROM milestone WHERE project_id = @proj_f AND name LIKE '6.4%');
SET @m6_5 = (SELECT id FROM milestone WHERE project_id = @proj_f AND name LIKE '6.5%');

SET @m7_1 = (SELECT id FROM milestone WHERE project_id = @proj_g AND name LIKE '7.1%');
SET @m7_2 = (SELECT id FROM milestone WHERE project_id = @proj_g AND name LIKE '7.2%');
SET @m7_3 = (SELECT id FROM milestone WHERE project_id = @proj_g AND name LIKE '7.3%');
SET @m7_4 = (SELECT id FROM milestone WHERE project_id = @proj_g AND name LIKE '7.4%');
SET @m7_5 = (SELECT id FROM milestone WHERE project_id = @proj_g AND name LIKE '7.5%');

SET @m8_1 = (SELECT id FROM milestone WHERE project_id = @proj_h AND name LIKE '8.1%');
SET @m8_2 = (SELECT id FROM milestone WHERE project_id = @proj_h AND name LIKE '8.2%');
SET @m8_3 = (SELECT id FROM milestone WHERE project_id = @proj_h AND name LIKE '8.3%');
SET @m8_4 = (SELECT id FROM milestone WHERE project_id = @proj_h AND name LIKE '8.4%');

SET @m9_0 = (SELECT id FROM milestone WHERE project_id = @proj_i AND name LIKE '9.0%' LIMIT 1);

-- ============================================
-- 15. CREATE MILESTONE TARGETS (DELIVERABLES)
-- ============================================

-- Milestone 1.1: Ruvuma 5 WMAs
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_1, 'MAT report showing management progress (>80% Level 3 by year end)', 0, 0),
(UUID(), @m1_1, 'Capacited 1 Field Officer in governance, MAT, Protection, HWC monitoring', 1, 0),
(UUID(), @m1_1, 'Co-implementation report on financial management capacity building with partners', 2, 0),
(UUID(), @m1_1, 'On-demand Governance Training Reports and Periodic GIA Reports', 3, 0),
(UUID(), @m1_1, 'Maintained Rangerpost & equipment, SOPs, anti-poaching strategy, intelligence Manual', 4, 0),
(UUID(), @m1_1, 'Communication strategies, stakeholder engagement strategies and awareness films', 5, 0),
(UUID(), @m1_1, 'HWC toolkits training reports', 6, 0),
(UUID(), @m1_1, 'Joint Livelihood initiative reports', 7, 0),
(UUID(), @m1_1, '4 Meetings in each WMA with pastoralists, inclusion in AA and village committee', 8, 0);

-- Milestone 1.2: Liwale
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_2, 'MAT report showing management progress >80% level 3', 0, 0),
(UUID(), @m1_2, 'Capacitated Field Officer on governance, MAT, Protection, HWC, Livelihood monitoring', 1, 0),
(UUID(), @m1_2, 'Completed Gov. training reports at least 4 per WMA, SEGA actions progress', 2, 0),
(UUID(), @m1_2, 'Customized SOPs, anti-poaching strategy, 1 Ranger Post, 10 Rangers employed', 3, 0),
(UUID(), @m1_2, 'Stakeholder engagement report, communication strategy, 3 awareness films', 4, 0);

-- Milestone 1.3: Ruaha WMAs
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_3, 'MAT progress reports for Mbomipa and Waga', 0, 0),
(UUID(), @m1_3, 'Trained Field Officer', 1, 0),
(UUID(), @m1_3, 'SEGA actions reports', 2, 0),
(UUID(), @m1_3, 'Carbon & other business prospects reports for Waga & MBOMIPA', 3, 0),
(UUID(), @m1_3, '1 constructed Ranger Post for Waga', 4, 0),
(UUID(), @m1_3, 'Reports on Protection and HWC initiatives', 5, 0),
(UUID(), @m1_3, 'Livelihood initiatives reports', 6, 0);

-- Milestone 1.4: Ifinga
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m1_4, 'GMP and user right in place', 0, 0),
(UUID(), @m1_4, 'Reports of initial governance and management interventions', 1, 0),
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
(UUID(), @m2_3, 'Livelihood initiatives summary sheet', 5, 0),
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
(UUID(), @m2_5, 'Core management manuals and policies', 2, 0),
(UUID(), @m2_5, 'Community awareness film + comms materials', 3, 0),
(UUID(), @m2_5, 'Film screening and dialogue report', 4, 0),
(UUID(), @m2_5, 'Protection and HWC pilot report', 5, 0),
(UUID(), @m2_5, 'Carbon feasibility study', 6, 0);

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
(UUID(), @m3_1, 'GCBF module piloted, revised, staff and partners trained through ToT', 0, 0),
(UUID(), @m3_1, '1–2 cost-effective awareness campaigns, media collaboration', 1, 0),
(UUID(), @m3_1, 'Rapid governance orientation for new WMA leaders', 2, 0),
(UUID(), @m3_1, 'Stakeholder engagement approach piloted in selected WMAs', 3, 0),
(UUID(), @m3_1, 'WMA leaders trained on Rapid Governance Monitoring Tool', 4, 0),
(UUID(), @m3_1, 'SAGE enhanced and expanded to support additional WMAs', 5, 0);

-- Milestone 3.2: Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_2, 'Standardized FCG Monitoring Framework', 0, 0),
(UUID(), @m3_2, 'Pre-customized QuickBook Chart of Accounts', 1, 0),
(UUID(), @m3_2, 'Board financial oversight handbook for WMAs', 2, 0),
(UUID(), @m3_2, 'At least 5 additional Management Tools packaged', 3, 0),
(UUID(), @m3_2, 'Pilot leadership training program report', 4, 0);

-- Milestone 3.3: Protection
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_3, 'HGF protection tools compiled and packaged for dissemination', 0, 0),
(UUID(), @m3_3, 'Standardized Protection Tools Package distributed', 1, 0),
(UUID(), @m3_3, 'WMAs protection status monitored with quarterly reports', 2, 0),
(UUID(), @m3_3, 'Quarterly checklist of anti-poaching recommendations', 3, 0);

-- Milestone 3.4: HWC
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_4, 'At least 2 new innovative HEC toolkits invented', 0, 0),
(UUID(), @m3_4, 'HEC scaled up in at least 2 other countries with partners', 1, 0),
(UUID(), @m3_4, 'HEC methods guide compiled and packaged', 2, 0);

-- Milestone 3.5: Livelihoods
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_5, 'Education and Health program Framework finalized', 0, 0),
(UUID(), @m3_5, 'Kamitei Education Model implementation reports for all WMAs', 1, 0),
(UUID(), @m3_5, 'Pilot reports for Agriculture and Microcredit projects', 2, 0),
(UUID(), @m3_5, 'Database of 10+ livelihoods models documented', 3, 0),
(UUID(), @m3_5, 'At least 2 new conservation financing mechanisms', 4, 0);

-- Milestone 3.6: Honeyguide Learning Hub
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m3_6, 'Repository of Honeyguide lessons and courses', 0, 0),
(UUID(), @m3_6, 'Online self-paced learning courses', 1, 0),
(UUID(), @m3_6, 'Monitoring tools to measure learning uptake', 2, 0);

-- Milestone 4.1: M&E
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m4_1, 'Updated functional data tracking tools with sustainability score', 0, 0),
(UUID(), @m4_1, 'Project Impact evaluation tool developed', 1, 0),
(UUID(), @m4_1, 'Data reflecting Honeyguide contribution to national strategy', 2, 0),
(UUID(), @m4_1, 'Evaluation reports for SP26 strategic plan review', 3, 0),
(UUID(), @m4_1, 'Survey report on narrative change', 4, 0),
(UUID(), @m4_1, 'Quarterly dashboards in Google Drive and Power BI', 5, 0),
(UUID(), @m4_1, 'At least one forum with WMA leaders for feedback', 6, 0),
(UUID(), @m4_1, 'Quarterly presentation on project progress', 7, 0),
(UUID(), @m4_1, 'Quarterly consolidation of organization program reports', 8, 0);

-- Milestone 4.2: GIS and Mapping
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m4_2, 'Well organized, updated GIS data for programs use', 0, 0),
(UUID(), @m4_2, 'Template and training on satellite image analysis', 1, 0),
(UUID(), @m4_2, 'Specific WMA basemaps for reporting', 2, 0),
(UUID(), @m4_2, 'Story Maps to support Honeyguide communications', 3, 0),
(UUID(), @m4_2, 'Professional-quality maps for communication and reporting', 4, 0);

-- Milestone 5.1: K9 Unit
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m5_1, 'Monthly K9 unit reports and quarterly stories', 0, 0),
(UUID(), @m5_1, 'MR training center developed and approved', 1, 0),
(UUID(), @m5_1, 'K9 medical plan and evacuation protocol in place', 2, 0);

-- Milestone 5.2: Rubondo Chimpanzee
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m5_2, 'Northern Chimps: >100% sightings, 8-12m visibility, 3hrs:45m', 0, 0),
(UUID(), @m5_2, 'Southern Chimps: >50% sightings, 10-15m visibility, 1hr', 1, 0),
(UUID(), @m5_2, '20km+ new trails in Southern Rubondo cleared', 2, 0),
(UUID(), @m5_2, '5 Chimpanzee individuals identified', 3, 0),
(UUID(), @m5_2, '17 chimp trackers trained on guiding, 1st Aid, Navigation', 4, 0),
(UUID(), @m5_2, '7 Community trackers attended English courses', 5, 0),
(UUID(), @m5_2, '7 community trackers equipped with Licence D', 6, 0),
(UUID(), @m5_2, '4-year action plan and reviewed MoU with TANAPA', 7, 0),
(UUID(), @m5_2, 'New marketing materials for Rubondo chimp products', 8, 0);

-- Milestone 6.1: National Advocacy
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_1, '10 TV shows on WMA related issues', 0, 0),
(UUID(), @m6_1, '3 radio stations broadcasting on WMA issues', 1, 0),
(UUID(), @m6_1, '10 WMAs independently posting on social media', 2, 0);

-- Milestone 6.2-6.5
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m6_2, 'Benchmarking tool tested', 0, 0),
(UUID(), @m6_3, 'Plan and budget with clear network team roles', 0, 0),
(UUID(), @m6_3, '4x Quarterly Reports developed', 1, 0),
(UUID(), @m6_4, 'Attended BCC conference', 0, 0),
(UUID(), @m6_4, 'Engaged in quarterly CLC network calls', 1, 0),
(UUID(), @m6_5, '2 key persons trained in advocacy and media', 0, 0);

-- Milestone 7.1: Financial Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_1, 'Training on Financial and Procurement Manual', 0, 0),
(UUID(), @m7_1, 'Staff trained on financial systems and reporting', 1, 0),
(UUID(), @m7_1, 'Automated/digitized finance system operational', 2, 0),
(UUID(), @m7_1, 'Procurement Manual developed and board approved', 3, 0),
(UUID(), @m7_1, 'Transparent procurement system operational', 4, 0),
(UUID(), @m7_1, 'Stronger donor confidence through improved accountability', 5, 0);

-- Milestone 7.2: HR Management
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_2, 'Job profiles and grades finalized; HR framework published', 0, 0),
(UUID(), @m7_2, '100% staff appraised bi-annually; training sessions implemented', 1, 0),
(UUID(), @m7_2, 'Succession plan for executives; departmental pipelines developed', 2, 0),
(UUID(), @m7_2, '2 leadership workshops; 100% managers trained', 3, 0),
(UUID(), @m7_2, 'Culture survey; Recognition program; Engagement improved 15%', 4, 0),
(UUID(), @m7_2, 'Data protection policy; All staff trained on compliance', 5, 0);

-- Milestone 7.3: IT
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_3, 'All five core modules developed, tested, deployed', 0, 0),
(UUID(), @m7_3, 'Data Protection Policy fully rolled out', 1, 0),
(UUID(), @m7_3, 'ICT infrastructure at 95%+ uptime', 2, 0),
(UUID(), @m7_3, 'Shared digital workspace for WMA resources', 3, 0);

-- Milestone 7.4-7.5
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m7_4, 'Digital Asset Management System operational', 0, 0),
(UUID(), @m7_4, 'Risk Management Framework implemented', 1, 0),
(UUID(), @m7_5, '100% fleet serviced on schedule, >95% operational', 0, 0),
(UUID(), @m7_5, '90%+ repairs completed within 24 hours', 1, 0),
(UUID(), @m7_5, 'Standardized checklist reducing unscheduled repairs', 2, 0),
(UUID(), @m7_5, '100% vehicles pass safety inspections', 3, 0),
(UUID(), @m7_5, '100% workshop staff trained and adhering to SOPs', 4, 0),
(UUID(), @m7_5, 'Accurate reports with actionable insights', 5, 0);

-- Milestone 8.1: Fundraising
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_1, 'Key long-term donors maintained; one increased by 20%', 0, 0),
(UUID(), @m8_1, 'Funding gap for 2026 reduced by 100%', 1, 0),
(UUID(), @m8_1, 'Funding gap for 2027 reduced by 70%', 2, 0),
(UUID(), @m8_1, 'Engaged with 2+ donors that can contribute >50k/year', 3, 0),
(UUID(), @m8_1, 'Responded to at least 1 large multi-year call', 4, 0),
(UUID(), @m8_1, 'MOUs with partners including joint fundraising', 5, 0),
(UUID(), @m8_1, 'Funds raised for Special Programs (K9 + Rubondo)', 6, 0);

-- Milestone 8.2-8.4
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m8_2, 'Dashboard tracking organizational impact 2017-2025', 0, 0),
(UUID(), @m8_2, 'Dashboard monitoring HGF impact on national strategy', 1, 0),
(UUID(), @m8_2, 'Active online library with search functions', 2, 0),
(UUID(), @m8_2, 'Monthly WhatsApp and Smugmug photo updates', 3, 0),
(UUID(), @m8_3, 'Four communication campaigns per year', 0, 0),
(UUID(), @m8_3, 'Donor Visibility Guidelines per donor', 1, 0),
(UUID(), @m8_3, 'Annual Report produced', 2, 0),
(UUID(), @m8_3, 'Quarterly Case Studies', 3, 0),
(UUID(), @m8_3, 'Brochures & Presentations updated biannually', 4, 0),
(UUID(), @m8_3, 'Four 5-minute promotional videos', 5, 0),
(UUID(), @m8_3, 'Website Redesign with Honeyguide Innovation section', 6, 0),
(UUID(), @m8_3, 'Communications Plan for 2026', 7, 0),
(UUID(), @m8_4, 'Quarterly newsletter in Swahili', 0, 0),
(UUID(), @m8_4, 'Weekly social media posts; shared reports', 1, 0),
(UUID(), @m8_4, 'Honeyguide awareness posters', 2, 0),
(UUID(), @m8_4, 'Honeyguide Swahili website live', 3, 0);

-- Milestone 9.0: Board Oversight
INSERT INTO milestone_target (id, milestone_id, description, position, completed) VALUES
(UUID(), @m9_0, 'At least 2 new board members recruited', 0, 0),
(UUID(), @m9_0, 'Online training course for board members', 1, 0),
(UUID(), @m9_0, 'Revised constitution and onboarding procedure', 2, 0),
(UUID(), @m9_0, '4 online board meetings, 1 AGM, annual retreat', 3, 0);

-- ============================================
-- 16. CREATE TAGS
-- ============================================
INSERT IGNORE INTO tag (id, created_by_id, name, color, created_at) VALUES
(UUID(), @sam_id, 'governance', '#3b82f6', NOW()),
(UUID(), @sam_id, 'management', '#22c55e', NOW()),
(UUID(), @sam_id, 'protection', '#ef4444', NOW()),
(UUID(), @sam_id, 'HWC', '#f97316', NOW()),
(UUID(), @sam_id, 'livelihoods', '#8b5cf6', NOW()),
(UUID(), @sam_id, 'M&E', '#06b6d4', NOW()),
(UUID(), @sam_id, 'GIS', '#14b8a6', NOW()),
(UUID(), @sam_id, 'fundraising', '#eab308', NOW()),
(UUID(), @sam_id, 'communications', '#ec4899', NOW()),
(UUID(), @sam_id, 'finance', '#84cc16', NOW()),
(UUID(), @sam_id, 'HR', '#d946ef', NOW()),
(UUID(), @sam_id, 'IT', '#6b7280', NOW()),
(UUID(), @sam_id, 'K9', '#0ea5e9', NOW()),
(UUID(), @sam_id, 'Rubondo', '#10b981', NOW()),
(UUID(), @sam_id, 'carbon', '#78716c', NOW()),
(UUID(), @sam_id, 'tourism', '#f59e0b', NOW());

-- ============================================
-- 17. SUMMARY
-- ============================================
SELECT 'Workplan complete fixtures loaded successfully!' AS status;
SELECT COUNT(*) AS total_users FROM user;
SELECT COUNT(*) AS total_projects FROM project;
SELECT COUNT(*) AS total_milestones FROM milestone;
SELECT COUNT(*) AS total_deliverables FROM milestone_target;
SELECT COUNT(*) AS total_tags FROM tag;
