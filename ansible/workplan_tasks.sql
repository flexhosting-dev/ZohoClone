-- ============================================
-- WORKPLAN TASKS FIXTURES
-- Run AFTER workplan_complete.sql
-- ============================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Get project IDs
SET @proj_a = (SELECT id FROM project WHERE name LIKE 'A.%');
SET @proj_b = (SELECT id FROM project WHERE name LIKE 'B.%');
SET @proj_c = (SELECT id FROM project WHERE name LIKE 'C.%');
SET @proj_d = (SELECT id FROM project WHERE name LIKE 'D.%');
SET @proj_e = (SELECT id FROM project WHERE name LIKE 'E.%');
SET @proj_f = (SELECT id FROM project WHERE name LIKE 'F.%');
SET @proj_g = (SELECT id FROM project WHERE name LIKE 'G.%');
SET @proj_h = (SELECT id FROM project WHERE name LIKE 'H.%');
SET @proj_i = (SELECT id FROM project WHERE name LIKE 'I.%');

-- Get milestone IDs
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
-- TASKS FOR PROJECT A (Southern WMAs)
-- ============================================

-- Milestone 1.1: Ruvuma 5 WMAs
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_1, NULL, '1.1.1 MAT operational efficiency', 'MAT with a focus on achieving >80% Level 3 for operational efficiency, & filling training gaps to Field Officers.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.2 AA leadership & GIA governance', 'Strengthen AA leadership, decision-making and compliance so Ruvuma 5 WMAs meet mandatory GIA standards.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.3 Community-led protection & HWC', 'Developing community-led natural resource protection & HWC strategies that are cost-effective and data-driven.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.4 Community livelihood programs', 'Delivering cost-effective, data-driven community livelihood programs with measurable social impact.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_1, NULL, '1.1.5 SMART engagement strategies', 'Implement SMART engagement strategies to raise awareness, strengthen collaboration, and foster ownership.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.2: Liwale
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_2, NULL, '1.2.1 MAT operational efficiency', 'MAT aiming for >80% Level 3 in operational efficiency, & filling training gaps of Field Officers.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.2 Governance interventions & GIA', 'Implement targeted governance interventions & GIA actions for governance best practices.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.3 Community-led protection', 'Implementing community-led natural resource protection strategies that are cost-effective and data-driven.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.4 Stakeholder engagement & comms', 'Customize and implement SMART stakeholder engagement and communications strategies.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_2, NULL, '1.2.5 SEGA Actions in Liwale', 'Implementing SEGA Actions in Liwale WMA.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.3: Ruaha WMAs
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_3, NULL, '1.3.1 MAT Mbomipa & Waga', 'MAT in Mbomipa and Waga WMAs, to reach 80% MAT level 3.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.2 Governance & GIA interventions', 'Implement targeted governance and GIA interventions addressing SAGE findings.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.3 Alternative financing models', 'Develop alternative financing and business models to ensure WMAs sustainability.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.4 Protection & HWC strategies', 'Exploring cost-effective community-led natural resource protection & HWC strategies.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m1_3, NULL, '1.3.5 Community livelihood programs', 'Implement community-led, cost-effective, data-driven livelihood programs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 1.4: Ifinga
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m1_4, NULL, '1.4.1 WMA establishment support', 'Support Ifinga WMA communities in the establishment of the WMA.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m1_4, NULL, '1.4.2 Basic governance & management training', 'Support WMA basic governance & management trainings.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT B (Northern WMAs)
-- ============================================

-- Milestone 2.1: Burunge
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_1, NULL, '2.1.1 Re-establish Burunge relationship', 'Re-establish a constructive working relationship with Burunge WMA.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW());

-- Milestone 2.2: Makame
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_2, NULL, '2.2.1 Sustainability indicators ≥90%', 'Achieve ≥90% on Makame sustainability indicators and update Sustainability Plan.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_2, NULL, '2.2.2 Carbon & community learning hub', 'Strengthen Makame as a carbon-and-community learning hub.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_2, NULL, '2.2.3 Additional livelihood initiatives', 'Develop additional livelihood initiatives beyond health and education.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.3: Randilen
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_3, NULL, '2.3.1 Sustainability indicators ≥90%', 'Achieve ≥90% on Randilen sustainability indicators.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_3, NULL, '2.3.2 Photographic tourism learning hub', 'Position Randilen as a leading photographic tourism learning hub.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_3, NULL, '2.3.3 Additional livelihood initiatives', 'Develop additional livelihood initiatives for Randilen community.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.4: Makao WMA
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_4, NULL, '2.4.1 Darwin programme completion', 'Finalise the Darwin-funded programme in Makao.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_4, NULL, '2.4.2 Sustainability score ≥80%', 'Raise Makao sustainability score to ≥80%.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_4, NULL, '2.4.3 Financial & community benefits plan', 'Establish financial and community benefits plan.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.5: Uyumbu WMA
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_5, NULL, '2.5.1 Governance to MAT ≥75% L3', 'Strengthen Uyumbu governance to MAT ≥75% L3.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_5, NULL, '2.5.2 Community trust & awareness', 'Rebuild community trust via awareness film and dialogue.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m2_5, NULL, '2.5.3 Protection, HWC & carbon feasibility', 'Pilot protection and HWC operations, complete carbon feasibility.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW());

-- Milestone 2.6: Other new WMAs
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m2_6, NULL, '2.6.1 Governance basics establishment', 'Establish governance basics using light-touch engagement model.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m2_6, NULL, '2.6.2 Scalable livelihood models', 'Explore scalable livelihood models including community banks.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT C (Technical Innovations)
-- ============================================

-- Milestone 3.1: Governance
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_1, NULL, '3.1.1 Pilot & monitor GCBF Module', 'Pilot, Cascade, and Monitor the GCBF Module.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.2 Institutionalize governance docs & tools', 'Package all governance documents and tools for standardized use.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.3 Rapid governance training for new leaders', 'Pilot Rapid Governance Training for New WMA Leaders.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.4 Stakeholder engagement approach pilot', 'Pilot the Stakeholder Engagement & Communication Approach.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.5 Rapid Governance Monitoring Tool', 'Train and support WMA Rapid Governance Monitoring Tool.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m3_1, NULL, '3.1.6 Enhance & scale SAGE', 'Enhance and scale SAGE for wider adoption.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW());

-- Milestone 3.2: Management
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_2, NULL, '3.2.1 FCG Monitoring tool', 'Develop FCG Monitoring tool and testing.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.2 QuickBooks lite setup for WMAs', 'Develop pre-customized Quickbook lite setup file.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.3 Board Financial Oversight Handbook', 'Develop WMA Board Financial Oversight Handbook.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.4 WMA Management Toolbox', 'Design comprehensive WMA Management Toolbox.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_2, NULL, '3.2.5 Leadership Training Program pilot', 'Implement pilot Leadership Training Program.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 3.3: Protection
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_3, NULL, '3.3.1 Package protection docs & tools', 'Package all protection documents and tools.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.2 Low-cost protection strategies', 'Ensure WMAs adopt low-cost effective protection strategies.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.3 Anti-poaching tools monitoring', 'Conduct regular assessments of anti-poaching tools.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_3, NULL, '3.3.4 Anti-poaching improvement checklist', 'Develop anti-poaching improvement recommendations.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- Milestone 3.4: HWC
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_4, NULL, '3.4.1 HEC toolkit innovation', 'Drive toolkit innovation through design and testing.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_4, NULL, '3.4.2 HEC mitigation beyond WMAs', 'Explore HEC mitigation beyond WMAs and outside country.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_4, NULL, '3.4.3 Package HEC methodologies', 'Institutionalize and package HEC methodologies.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW());

-- Milestone 3.5: Livelihoods
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_5, NULL, '3.5.1 Education & Health replication playbook', 'Document Makame Education and Health models into playbook.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.2 Kamitei Education replication', 'Replicate Kamitei Education program into other WMAs.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.3 Agriculture & microcredit pilots', 'Explore and pilot Agriculture and microcredit initiatives.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.4 Livelihood programs inventory', 'Build inventory of 10+ livelihood programs.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m3_5, NULL, '3.5.5 New financing models (CTFs, etc.)', 'Co-design 2 new financing models.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW());

-- Milestone 3.6: Honeyguide Learning Hub
INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m3_6, NULL, '3.6.1 Knowledge repository', 'Develop repository of tools and knowledge.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m3_6, NULL, '3.6.2 Online courses & monitoring', 'Design online courses with monitoring mechanisms.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT D (M&E)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m4_1, NULL, '4.1.1 M&E tools & systems design', 'Design and implement M&E Tools and Systems.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.2 Program impacts & evaluation', 'Program Impacts and Evaluation.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.3 M&E capacity building', 'M&E Capacity Building for WMAs and partners.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.4 Quarterly data quality & reports', 'Ensure accurate, quality data and reports quarterly.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m4_1, NULL, '4.1.5 Ecological monitoring & evidence', 'Ecological Monitoring and Evidence Generation.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m4_2, NULL, '4.2.1 GIS maps & tools for project areas', 'Develop GIS maps and tools for all project areas.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m4_2, NULL, '4.2.2 Map making & navigation capacity', 'Establish Capacity for Map Making and Navigation.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT E (Expanding Footprint)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m5_1, NULL, '5.1.1 Maintain 24/7 standby K9 unit', 'Maintain standby canine unit ready 24/7.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m5_1, NULL, '5.1.2 Strengthen K9 operations & reporting', 'Strengthen K9 unit operations and reporting.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m5_1, NULL, '5.1.3 HGF-Kuru-Manyara collaboration', 'Strengthen collaboration between HGF, Kuru and Manyara.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.1 Northern chimps habituation', 'Continued habituation of northern chimps sub-group.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.2 Southern chimps mapping & monitoring', 'Start habituating southern chimp subgroup.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.3 Chimp tourism & tracker training', 'Strengthen chimpanzee tourism and tracker training.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.4 Marketing with TANAPA', 'Improve marketing with TANAPA.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m5_2, NULL, '5.2.5 New 4-year action plan', 'Develop new 4-year action plan.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT F (External Engagement)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m6_1, NULL, '6.1.1 National & local media awareness', 'National and local media awareness.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m6_2, NULL, '6.2.1 Narrative benchmark assessment', 'Stakeholder narrative benchmark assessment.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m6_3, NULL, '6.3.1 Policy network & facilitation', 'Policy network and facilitation.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m6_4, NULL, '6.4.1 Regional CLC narrative', 'Regional narrative on CLC.', 'todo', 'low', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m6_5, NULL, '6.5.1 Advocacy & media training', 'Training for advocacy and media teams.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT G (Operations & HR)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m7_1, NULL, '7.1.1 Finance & procurement manual awareness', 'Awareness of finance and procurement procedures.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.2 Internal audit & compliance', 'Strengthen internal audit and compliance.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.3 Donor-specific dashboards & automation', 'Introduce donor-specific dashboards.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.4 Long-term financial planning', 'Strategic long-term financial planning.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.5 Budget & cashflow monitoring', 'Annual Budget and Cashflow development.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m7_1, NULL, '7.1.6 e-Asset & e-Procurement rollout', 'Roll out e-Asset and e-procurement systems.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.1 Workforce planning & job evaluation', 'Develop job profiles and competency models.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.2 Performance management improvement', 'Strengthen performance management system.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.3 Staff training & development', 'Implement staff development activities.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.4 HRIS integration & consolidation', 'Consolidate HR systems.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.5 Culture & engagement improvement', 'Launch engagement programs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m7_2, NULL, '7.2.6 HR compliance & data protection', 'Implement data protection compliance.', 'todo', 'medium', '2026-12-31', 5, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.1 App development (Leave, Payroll, etc.)', 'Develop Leave, Payroll, Performance apps.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.2 Data protection & compliance', 'Establish data protection measures.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.3 Tech support & maintenance', 'Deliver regular IT support.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_3, NULL, '7.3.4 Collaboration & knowledge sharing', 'Create shared digital workspace.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_4, NULL, '7.4.1 Asset management system', 'Maintain asset management system.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_4, NULL, '7.4.2 Risk management framework', 'Strengthen risk management framework.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.1 Fleet management & safety', 'Implement Fleet Management System.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.2 Zero lost-time injuries target', 'Achieve Zero Lost-Time Injuries.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.3 Spare parts & lifecycle analysis', 'Analyze spare parts and lifecycle costs.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.4 Fuel & maintenance metrics', 'Monitor fuel and maintenance metrics.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m7_5, NULL, '7.5.5 Quarterly workshop review', 'Quarterly internal workshop review.', 'todo', 'low', '2026-12-31', 4, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT H (Resource Mobilization & Comms)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m8_1, NULL, '8.1.1 Top ten donor engagement', 'Engage top ten donors strategically.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.2 Broaden donor base', 'Broaden donor base with new prospects.', 'todo', 'high', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.3 Funding opportunities & proposals', 'Respond to funding opportunities.', 'todo', 'high', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.4 Joint funding tools & agreements', 'Develop joint funding tools with partners.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m8_1, NULL, '8.1.5 Special programs funding partners', 'Search funding for special programs.', 'todo', 'medium', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.1 Build comms tools capacity', 'Build capacity with new comms tools.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.2 Comms team data training', 'Train comms team on data use.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.3 AI for communications', 'Develop AI knowledge resources for comms.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_2, NULL, '8.2.4 Communications App management', 'Manage Honeyguide Communications App.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.1 Thematic communication campaigns', 'Package thematic communication campaigns.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.2 One-way communications (blogs, etc.)', 'Produce blogs, newsletters, videos.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.3 Two-way communications (webinars, etc.)', 'Produce webinar and meeting materials.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.4 Website updates', 'Ongoing website updates.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW()),
(UUID(), @m8_3, NULL, '8.3.5 2026 Communications plan', 'Create 2026 Communications plan.', 'todo', 'high', '2026-12-31', 4, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.1 Swahili quarterly newsletter', 'Produce quarterly Swahili newsletter.', 'todo', 'medium', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.2 Swahili social media posts', 'Regular Swahili social media posts.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.3 Honeyguide awareness posters', 'Design awareness posters.', 'todo', 'low', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m8_4, NULL, '8.4.4 Swahili website', 'Develop Swahili website.', 'todo', 'medium', '2026-12-31', 3, NOW(), NOW());

-- ============================================
-- TASKS FOR PROJECT I (Board Governance)
-- ============================================

INSERT INTO task (id, milestone_id, parent_id, title, description, status, priority, due_date, position, created_at, updated_at) VALUES
(UUID(), @m9_0, NULL, '9.1.1 Recruit diverse board members', 'Recruit additional board members from diverse backgrounds.', 'todo', 'high', '2026-12-31', 0, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.2 Board training & onboarding', 'Provide board training materials and onboarding.', 'todo', 'medium', '2026-12-31', 1, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.3 Board policies & procedures', 'Develop board guiding policies and procedures.', 'todo', 'medium', '2026-12-31', 2, NOW(), NOW()),
(UUID(), @m9_0, NULL, '9.1.4 Board meetings & AGM management', 'Plan and manage board meetings and AGM.', 'todo', 'high', '2026-12-31', 3, NOW(), NOW());

-- ============================================
-- SUMMARY
-- ============================================
SELECT 'Workplan tasks loaded successfully!' AS status;
SELECT COUNT(*) AS total_tasks FROM task;
