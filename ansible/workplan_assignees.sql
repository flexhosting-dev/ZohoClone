-- ============================================
-- WORKPLAN TASK ASSIGNEES SQL SCRIPT
-- Run this AFTER workplan_data.sql
-- ============================================

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
SET @user_sam = (SELECT id FROM user WHERE email = 'sam@honeyguide.org');
SET @user_admin = (SELECT id FROM user WHERE email = 'admin@honeyguide.org');

-- ============================================
-- ASSIGN TASKS TO USERS
-- Based on the workplan assignments
-- ============================================

-- Project A (Southern WMAs) - Sylvester is assigned
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_sylvester, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
JOIN project p ON m.project_id = p.id
WHERE p.name = 'A. Southern WMAs Portfolio';

-- Project B (Northern WMAs) - Max and Sam are assigned
-- Max handles milestones 2.1-2.5
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_max, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name IN ('2.1 Burunge', '2.2 Makame', '2.3 Randilen', '2.4 Makao WMA', '2.5 Uyumbu WMA');

-- Sam handles milestone 2.6
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_sam, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '2.6 Other new WMAs (UMEMARUWA, Kilolo, Chamwino)';

-- Project C (Technical Innovations) - Various assignees
-- 3.1 Governance - Fatma
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_fatma, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '3.1 Governance';

-- 3.2 Management - Namnyaki
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_namnyaki, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '3.2 Management';

-- 3.3 Protection - Kateto
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_kateto, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '3.3 Protection';

-- 3.4 HWC - Lemuta
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_lemuta, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '3.4 HWC';

-- 3.5 Livelihoods - Glad
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_glad, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '3.5 Livelihoods';

-- 3.6 Learning Hub - No specific assignee (skip)

-- Project D (M&E) - Daudi and Michael
-- 4.1 M&E - Daudi
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_daudi, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '4.1 M&E';

-- 4.2 GIS - Michael
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_michael, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
WHERE m.name = '4.2 GIS and Mapping';

-- Project E (Special Programs) - Meleck
INSERT INTO task_assignee (id, task_id, user_id, assigned_by_id, assigned_at)
SELECT UUID(), t.id, @user_meleck, @user_admin, NOW()
FROM task t
JOIN milestone m ON t.milestone_id = m.id
JOIN project p ON m.project_id = p.id
WHERE p.name = 'E. Special Programs';

-- Projects F, G, H have no specific assignees in the workplan

SELECT 'Task assignees created!' AS status;
SELECT COUNT(*) AS total_assignees FROM task_assignee;
