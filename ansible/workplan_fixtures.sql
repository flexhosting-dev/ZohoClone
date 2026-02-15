-- ============================================
-- PRODUCTION-SAFE WORKPLAN FIXTURES
-- Creates complete workplan structure
-- Safe to run multiple times (idempotent)
-- ============================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Get Sam's ID (the super admin)
SET @sam_id = (SELECT id FROM user WHERE email = 'sam@honeyguide.org');

-- Get role IDs
SET @role_superadmin = (SELECT id FROM role WHERE slug = 'portal-super-admin');
SET @role_admin = (SELECT id FROM role WHERE slug = 'portal-admin');
SET @role_manager = (SELECT id FROM role WHERE slug = 'project-manager');
SET @role_member = (SELECT id FROM role WHERE slug = 'project-member');
SET @role_viewer = (SELECT id FROM role WHERE slug = 'project-viewer');

-- ============================================
-- 1. CREATE PROJECTS
-- ============================================

-- Project A: Southern WMAs Portfolio
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'A. Southern WMAs Portfolio', 'WMAs under Honeyguide management in Southern Tanzania including Ruvuma 5 WMAs, Liwale, Ruaha WMAs, and Ifinga.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'A. Southern WMAs Portfolio');

-- Project B: Northern WMAs Portfolio
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'B. Northern WMAs Portfolio', 'WMAs under Honeyguide management in Northern Tanzania including Burunge, Makame, Randilen, Makao, Uyumbu, and emerging WMAs.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'B. Northern WMAs Portfolio');

-- Project C: Technical Innovations
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'C. Technical Innovations', 'Technical support programs including governance, management, protection, HWC, livelihoods, and Honeyguide Learning Hub.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'C. Technical Innovations');

-- Project D: Monitoring & Evaluation
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'D. Monitoring & Evaluation', 'M&E systems and GIS/Mapping capabilities for tracking conservation outcomes.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'D. Monitoring & Evaluation');

-- Project E: Expanding Honeyguide Footprint
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'E. Expanding Honeyguide Footprint', 'New initiatives including K9 Unit, Rubondo Chimpanzee Project, and Mahale projects.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'E. Expanding Honeyguide Footprint');

-- Project F: External Engagement
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'F. External Engagement', 'Advocacy, policy engagement, and strategic partnerships at national and international levels.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'F. External Engagement');

-- Project G: Operations & HR
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'G. Operations & HR', 'Internal operations including financial management, HR, IT, asset management, and organizational development.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'G. Operations & HR');

-- Project H: Resource Mobilization & Comms
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'H. Resource Mobilization & Comms', 'Fundraising, systems development, and communications both international and national.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name = 'H. Resource Mobilization & Comms');

-- Project I: Board Governance (may already exist)
INSERT INTO project (id, owner_id, name, description, status, start_date, end_date, created_at, updated_at)
SELECT UUID(), @sam_id, 'I. Honeyguide Board Governance', 'An effective board that performs their roles to support and guide the organization.', 'active', '2026-01-01', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM project WHERE name LIKE '%Board Governance%');

-- ============================================
-- 2. GET PROJECT IDs
-- ============================================
SET @proj_a = (SELECT id FROM project WHERE name = 'A. Southern WMAs Portfolio');
SET @proj_b = (SELECT id FROM project WHERE name = 'B. Northern WMAs Portfolio');
SET @proj_c = (SELECT id FROM project WHERE name = 'C. Technical Innovations');
SET @proj_d = (SELECT id FROM project WHERE name = 'D. Monitoring & Evaluation');
SET @proj_e = (SELECT id FROM project WHERE name = 'E. Expanding Honeyguide Footprint');
SET @proj_f = (SELECT id FROM project WHERE name = 'F. External Engagement');
SET @proj_g = (SELECT id FROM project WHERE name = 'G. Operations & HR');
SET @proj_h = (SELECT id FROM project WHERE name = 'H. Resource Mobilization & Comms');
SET @proj_i = (SELECT id FROM project WHERE name LIKE '%Board Governance%');

-- ============================================
-- 3. ADD SAM AS PROJECT MANAGER TO ALL PROJECTS
-- ============================================
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_a, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_a IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_b, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_b IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_c, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_c IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_d, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_d IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_e, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_e IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_f, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_f IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_g, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_g IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_h, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_h IS NOT NULL;
INSERT IGNORE INTO project_member (id, project_id, user_id, role_id, joined_at)
SELECT UUID(), @proj_i, @sam_id, @role_manager, NOW() FROM DUAL WHERE @proj_i IS NOT NULL;

-- ============================================
-- 4. CREATE MILESTONES FOR PROJECT A (Southern WMAs)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_a, '1.1 Ruvuma 5 WMAs', 'Tunduru, Namtumbo, Songea Rural, Mbinga, Nyasa WMAs management and development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_a IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_a AND name = '1.1 Ruvuma 5 WMAs');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_a, '1.2 Liwale', 'Liwale WMA management and community engagement', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_a IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_a AND name = '1.2 Liwale');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_a, '1.3 Ruaha WMAs', 'Ruaha landscape WMA management including MBOMIPA, Pawaga-Idodi, and Wamimbiki', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_a IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_a AND name = '1.3 Ruaha WMAs');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_a, '1.4 Ifinga', 'Ifinga WMA establishment and development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_a IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_a AND name = '1.4 Ifinga');

-- ============================================
-- 5. CREATE MILESTONES FOR PROJECT B (Northern WMAs)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.1 Burunge', 'Burunge WMA management and tourism development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.1 Burunge');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.2 Makame', 'Makame WMA management and wildlife protection', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.2 Makame');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.3 Randilen', 'Randilen WMA management and community programs', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.3 Randilen');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.4 Makao WMA', 'Makao WMA establishment and development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.4 Makao WMA');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.5 Uyumbu WMA', 'Uyumbu WMA establishment and development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.5 Uyumbu WMA');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_b, '2.6 Other new WMAs', 'UMEMARUWA, Kilolo, Chamwino and other emerging WMAs', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_b IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_b AND name = '2.6 Other new WMAs');

-- ============================================
-- 6. CREATE MILESTONES FOR PROJECT C (Technical Innovations)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.1 Governance', 'WMA governance strengthening and capacity building', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.1 Governance');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.2 Management', 'WMA management systems and capacity building', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.2 Management');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.3 Protection', 'Wildlife protection and anti-poaching programs', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.3 Protection');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.4 HWC', 'Human-Wildlife Conflict mitigation and management', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.4 HWC');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.5 Livelihoods', 'Community livelihoods and economic development programs', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.5 Livelihoods');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_c, '3.6 Honeyguide Learning Hub', 'Training center and knowledge management platform', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_c IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_c AND name = '3.6 Honeyguide Learning Hub');

-- ============================================
-- 7. CREATE MILESTONES FOR PROJECT D (M&E)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_d, '4.1 M&E Systems', 'Monitoring and evaluation systems and reporting', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_d IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_d AND name = '4.1 M&E Systems');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_d, '4.2 GIS and Mapping', 'GIS capabilities and spatial analysis for conservation', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_d IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_d AND name = '4.2 GIS and Mapping');

-- ============================================
-- 8. CREATE MILESTONES FOR PROJECT E (Expanding Footprint)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_e, '5.1 Honeyguide K9 Unit', 'Detection dog unit for wildlife protection', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_e IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_e AND name = '5.1 Honeyguide K9 Unit');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_e, '5.2 Rubondo Chimpanzee Project', 'Chimpanzee conservation on Rubondo Island', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_e IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_e AND name = '5.2 Rubondo Chimpanzee Project');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_e, '5.3 Mahale', 'Mahale ecosystem conservation initiatives', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_e IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_e AND name = '5.3 Mahale');

-- ============================================
-- 9. CREATE MILESTONES FOR PROJECT F (External Engagement)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_f, '6.1 National Advocacy', 'Policy engagement at national level', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_f IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_f AND name = '6.1 National Advocacy');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_f, '6.2 International Engagement', 'International partnerships and representation', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_f IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_f AND name = '6.2 International Engagement');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_f, '6.3 Strategic Partnerships', 'Building strategic partnerships with key stakeholders', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_f IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_f AND name = '6.3 Strategic Partnerships');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_f, '6.4 Research Partnerships', 'Academic and research collaborations', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_f IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_f AND name = '6.4 Research Partnerships');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_f, '6.5 Capacity Building', 'External capacity building and training programs', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_f IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_f AND name = '6.5 Capacity Building');

-- ============================================
-- 10. CREATE MILESTONES FOR PROJECT G (Operations & HR)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_g, '7.1 Financial Management', 'Financial systems, reporting, and compliance', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_g IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_g AND name = '7.1 Financial Management');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_g, '7.2 HR Management', 'Human resources, recruitment, and staff development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_g IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_g AND name = '7.2 HR Management');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_g, '7.3 IT Systems', 'Information technology infrastructure and systems', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_g IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_g AND name = '7.3 IT Systems');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_g, '7.4 Asset and Risk Management', 'Asset management, insurance, and risk mitigation', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_g IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_g AND name = '7.4 Asset and Risk Management');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_g, '7.5 Workshops and Retreats', 'Staff workshops, retreats, and team building', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_g IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_g AND name = '7.5 Workshops and Retreats');

-- ============================================
-- 11. CREATE MILESTONES FOR PROJECT H (Resource Mobilization & Comms)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_h, '8.1 Fundraising', 'Grant writing, donor relations, and fundraising campaigns', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_h IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_h AND name = '8.1 Fundraising');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_h, '8.2 Systems Development', 'Organizational systems and tools development', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_h IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_h AND name = '8.2 Systems Development');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_h, '8.3 International Communications', 'International media, publications, and outreach', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_h IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_h AND name = '8.3 International Communications');

INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_h, '8.4 National Communications', 'National media, community outreach, and awareness', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_h IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_h AND name = '8.4 National Communications');

-- ============================================
-- 12. CREATE MILESTONE FOR PROJECT I (Board Governance)
-- ============================================
INSERT INTO milestone (id, project_id, name, description, status, due_date, created_at, updated_at)
SELECT UUID(), @proj_i, '9.0 Board Oversight', 'Board governance, meetings, and strategic oversight', 'open', '2026-12-31', NOW(), NOW()
FROM DUAL WHERE @proj_i IS NOT NULL AND NOT EXISTS (SELECT 1 FROM milestone WHERE project_id = @proj_i AND name = '9.0 Board Oversight');

-- ============================================
-- 13. SUMMARY
-- ============================================
SELECT 'Workplan fixtures loaded successfully!' AS status;
SELECT COUNT(*) AS total_projects FROM project;
SELECT COUNT(*) AS total_milestones FROM milestone;
