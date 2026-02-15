/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: projects_db
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `project_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `user_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `entity_type` varchar(50) NOT NULL,
  `entity_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `entity_name` varchar(255) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_AC74095A166D1F9C` (`project_id`),
  KEY `IDX_AC74095AA76ED395` (`user_id`),
  KEY `idx_activity_created_at` (`created_at`),
  CONSTRAINT `FK_AC74095A166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_AC74095AA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity`
--

LOCK TABLES `activity` WRITE;
/*!40000 ALTER TABLE `activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachment`
--

DROP TABLE IF EXISTS `attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attachment` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `uploaded_by_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `original_name` varchar(255) NOT NULL,
  `stored_name` varchar(255) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `file_size` int(11) NOT NULL,
  `path` varchar(500) NOT NULL,
  `attachable_type` varchar(50) NOT NULL,
  `attachable_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_795FD9BBA2B28FE8` (`uploaded_by_id`),
  KEY `idx_attachment_attachable` (`attachable_type`,`attachable_id`),
  CONSTRAINT `FK_795FD9BBA2B28FE8` FOREIGN KEY (`uploaded_by_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachment`
--

LOCK TABLES `attachment` WRITE;
/*!40000 ALTER TABLE `attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `changelog` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `version` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `changes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`changes`)),
  `release_date` date NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changelog`
--

LOCK TABLES `changelog` WRITE;
/*!40000 ALTER TABLE `changelog` DISABLE KEYS */;
/*!40000 ALTER TABLE `changelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `task_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `author_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `content` longtext NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `mentioned_user_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`mentioned_user_ids`)),
  PRIMARY KEY (`id`),
  KEY `IDX_9474526C8DB60186` (`task_id`),
  KEY `IDX_9474526CF675F31B` (`author_id`),
  CONSTRAINT `FK_9474526C8DB60186` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_9474526CF675F31B` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctrine_migration_versions`
--

DROP TABLE IF EXISTS `doctrine_migration_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctrine_migration_versions`
--

LOCK TABLES `doctrine_migration_versions` WRITE;
/*!40000 ALTER TABLE `doctrine_migration_versions` DISABLE KEYS */;
INSERT INTO `doctrine_migration_versions` VALUES
('DoctrineMigrations\\Version20260117230755','2026-02-15 20:42:04',548),
('DoctrineMigrations\\Version20260120133346','2026-02-15 20:42:04',17),
('DoctrineMigrations\\Version20260120140000','2026-02-15 20:42:04',4),
('DoctrineMigrations\\Version20260124120000','2026-02-15 20:42:04',37),
('DoctrineMigrations\\Version20260124150000','2026-02-15 20:42:04',78),
('DoctrineMigrations\\Version20260127073003','2026-02-15 20:42:04',35),
('DoctrineMigrations\\Version20260127174145','2026-02-15 20:42:04',245),
('DoctrineMigrations\\Version20260127194703','2026-02-15 20:42:05',12),
('DoctrineMigrations\\Version20260128033134','2026-02-15 20:42:05',15),
('DoctrineMigrations\\Version20260128040047','2026-02-15 20:42:05',18),
('DoctrineMigrations\\Version20260128041926','2026-02-15 20:42:05',16),
('DoctrineMigrations\\Version20260128043434','2026-02-15 20:42:05',25),
('DoctrineMigrations\\Version20260128182227','2026-02-15 20:42:05',38),
('DoctrineMigrations\\Version20260131123653','2026-02-15 20:42:05',36),
('DoctrineMigrations\\Version20260131164127','2026-02-15 20:42:05',56),
('DoctrineMigrations\\Version20260131184254','2026-02-15 20:42:05',64),
('DoctrineMigrations\\Version20260203120000','2026-02-15 20:42:05',10),
('DoctrineMigrations\\Version20260203150000','2026-02-15 20:42:05',11),
('DoctrineMigrations\\Version20260203180000','2026-02-15 20:42:05',15),
('DoctrineMigrations\\Version20260204120000','2026-02-15 20:42:05',63),
('DoctrineMigrations\\Version20260206120000','2026-02-15 20:42:05',14),
('DoctrineMigrations\\Version20260208121624','2026-02-15 20:42:05',10),
('DoctrineMigrations\\Version20260208131448','2026-02-15 20:42:05',13),
('DoctrineMigrations\\Version20260208142048','2026-02-15 20:42:05',46),
('DoctrineMigrations\\Version20260208142100','2026-02-15 20:42:05',2),
('DoctrineMigrations\\Version20260208143000','2026-02-15 20:42:05',17),
('DoctrineMigrations\\Version20260208160000','2026-02-15 20:42:05',1);
/*!40000 ALTER TABLE `doctrine_migration_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestone`
--

DROP TABLE IF EXISTS `milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `milestone` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `project_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `due_date` date DEFAULT NULL COMMENT '(DC2Type:date_immutable)',
  `status` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_4FAC8382166D1F9C` (`project_id`),
  CONSTRAINT `FK_4FAC8382166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestone`
--

LOCK TABLES `milestone` WRITE;
/*!40000 ALTER TABLE `milestone` DISABLE KEYS */;
INSERT INTO `milestone` VALUES
('019c630a-c808-706a-9f45-2c5792460277','019c630a-c808-706a-9f45-2c5790f2b9bf','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c808-706a-9f45-2c5793f4d7fa','019c630a-c808-706a-9f45-2c5792bf872c','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c808-706a-9f45-2c579493a8c5','019c630a-c808-706a-9f45-2c5794188a14','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3eb97923f4','019c630a-c809-7126-8fba-dc3eb8e24ed5','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ebb36149e','019c630a-c809-7126-8fba-dc3eba372d0a','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ebd886102','019c630a-c809-7126-8fba-dc3ebbc5cc1f','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ebeab09b0','019c630a-c809-7126-8fba-dc3ebdb9238d','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec001570e','019c630a-c809-7126-8fba-dc3ebf326fa5','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec2384ddf','019c630a-c809-7126-8fba-dc3ec0fed519','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec388ac3c','019c630a-c809-7126-8fba-dc3ec2e42897','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec4e5406f','019c630a-c809-7126-8fba-dc3ec3ac40cd','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec719ce32','019c630a-c809-7126-8fba-dc3ec5e13161','General',NULL,NULL,'open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c809-7126-8fba-dc3ec986e91f','019c630a-c809-7126-8fba-dc3ec7d6266e','1.1 Ruvuma 5 WMAs','Ruvuma\'s 5 WMAs achieve >80% Level 3 MAT performance through improved operational efficiency, strengthened AA leadership and GIA-compliant governance, effective community-led protection and HWC strategies, impactful data-driven livelihood programs, and SMART engagement efforts that enhance collaboration and pastoralist ownership.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd399a561da4','019c630a-c809-7126-8fba-dc3ec7d6266e','1.2 Liwale (Magingo WMA)','Integrating Governance and Management Best Practices into Magingo WMA operations to strengthen governance, management, and efficiency for developing their long-term vision to sustainability.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a285ff43','019c630a-c809-7126-8fba-dc3ec7d6266e','1.3 Ruaha WMAs (MBOMIPA & Waga)','Waga WMA and Mbomipa WMA have fully integrated their governance practices and professional management systems, ensuring data-driven operations and broader stakeholder engagement in decision-making.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a9044769b8','019c630a-c809-7126-8fba-dc3ec7d6266e','1.4 Ifinga','Support the establishment, feasibility assessment and initial interventions to prepare Ifinga for Honeyguide\'s capacity-building approach.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a90aae2828','019c630a-c80b-719c-b519-a3a908ba4763','2.1 Burunge','Burunge WMA has a restored working relationship with Honeyguide, basic governance meetings are back on track, and conditions for deeper engagement are agreed.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a90ed07aa3','019c630a-c80b-719c-b519-a3a908ba4763','2.2 Makame','Makame maintains a ≥90% sustainability score, runs an active carbon-and-community learning hub, and has at least one additional livelihood initiative beyond health and education in place.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a9145b6baf','019c630a-c80b-719c-b519-a3a908ba4763','2.3 Randilen','Randilen reaches ≥90% on sustainability indicators, implements its tourism plan, and operates a functional photographic tourism learning hub with complementary livelihood initiatives.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d4541fa39a','019c630a-c80b-719c-b519-a3a908ba4763','2.4 Makao WMA','The Darwin habitat and livelihood programme is completed and Makao reaches at least 80% on the sustainability indicators.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d45a06e81b','019c630a-c80b-719c-b519-a3a908ba4763','2.5 Uyumbu WMA','Uyumbu reaches MAT ≥75% (L3), has core management manuals and policies in place, has rebuilt basic trust with communities and authorities, and has tested protection/HWC operations with a completed carbon feasibility study.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d460aea695','019c630a-c80b-719c-b519-a3a908ba4763','2.6 Other new WMAs (UMEMARUWA, Kilolo, Chamwino)','At least two new WMAs have basic governance structures in place, an expanded village footprint, and a short feasibility and management pack agreed with partners.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119f2f10d04','019c630a-c80d-7011-bb25-f119ef792fab','3.1 Governance','Develop replicable governance capacity-building tools with partners, including training, monitoring frameworks, and tools to strengthen and scale community-led governance initiatives.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119fc2384f8','019c630a-c80d-7011-bb25-f119ef792fab','3.2 Management','Develop and packaging the replicable tools and frameworks for professional WMA management that can be applied across diverse CBNRM contexts.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1040851aa2','019c630a-c80d-7011-bb25-f119ef792fab','3.3 Protection','Review, develop, and packaging the Honeyguide\'s capacity-building process for the Protection of WMAs, and ensure the implementation at each of our partner sites is strategic and cost-effective.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1046ac0939','019c630a-c80d-7011-bb25-f119ef792fab','3.4 HWC','Research, develop and packaging of replicable, innovative, low-cost yet effective solutions for communities to mitigate HWC.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af104cb35aab','019c630a-c80d-7011-bb25-f119ef792fab','3.5 Livelihoods','Develop and package Honeyguide\'s Education and Health Livelihoods models for replication, while expanding exploration of new income-enhancing opportunities for WMA communities.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19dda9ef9c4','019c630a-c80d-7011-bb25-f119ef792fab','3.6 Honeyguide Learning Hub','Establish the Honeyguide Learning Platform with a community-driven, project-based approach, featuring an online system, collaboration tools, and interactive learning activities.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19ddeea6c91','019c630a-c80f-7295-abc2-c19ddceaf933','4.1 M&E','Strengthened the Monitoring and Evaluation (M&E) system and data management framework to align with SP26, ensuring greater simplicity, accessibility, and usability.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3cd83402a','019c630a-c80f-7295-abc2-c19ddceaf933','4.2 GIS and Mapping','Enhance and streamline GIS and mapping services to produce essential maps for field operations and reporting needs.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d54b2cef','019c630a-c810-7295-986e-b7a3d3a7b70c','5.1 Honeyguide K9 Unit','Expanding the impact and reach of Honeyguide\'s K9 unit for combatting wildlife crime in partnership with TANAPA, TAWA and other conservation partners.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3da449b51','019c630a-c810-7295-986e-b7a3d3a7b70c','5.2 Rubondo Chimpanzee Habituation','Support Rubondo National Park\'s chimpanzee habituation project to improve chimps\' visibility and contact for tourism experience.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9f6716c79','019c630a-c811-71eb-932e-17c9f4f8d6e2','6.1 Public Awareness','Develop a smart communication strategies, providing a structured approach to evaluate progress, measure outcomes, and determine whether desired goals have been achieved.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9f835c1a7','019c630a-c811-71eb-932e-17c9f4f8d6e2','6.2 Stakeholder Perception','Develop a stakeholder narrative benchmark tool and test.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9faa359d9','019c630a-c811-71eb-932e-17c9f4f8d6e2','6.3 Policy','Initiate and facilitate a forum for Advocacy and policy reform.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9fc154259','019c630a-c811-71eb-932e-17c9f4f8d6e2','6.4 Regional Networks','Engage with regional CLC networks to continue to share Honeyguide tools and approaches.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9fcdfd5cd','019c630a-c811-71eb-932e-17c9f4f8d6e2','6.5 Capacity Building','Building capacity in HGF for policy and narrative change.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17ca00134fc7','019c630a-c811-71eb-932e-17c9ff36f341','7.1 Financial Management','Strengthen Financial Management Systems and Procedures to ensure efficiency, transparency, and accountability.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17ca073ee40d','019c630a-c811-71eb-932e-17c9ff36f341','7.2 HR Management','To strengthen HR foundations by improving systems, structures, and culture moving from the current baseline to a significantly higher level of efficiency by the end of 2026.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c812-7391-a168-119f4a8cff16','019c630a-c811-71eb-932e-17c9ff36f341','7.3 IT','Strengthen IT infrastructure and digital tools by enhancing automation, optimizing HR and asset management processes, ensuring compliance with data protection standards, and improving system reliability.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c812-7391-a168-119f4ee0404f','019c630a-c811-71eb-932e-17c9ff36f341','7.4 Asset and Risk Management','Enhance and digitalize asset and risk management systems to ensure real-time accountability, proactive risk monitoring, and long-term sustainability of organizational resources.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c812-7391-a168-119f520535b3','019c630a-c811-71eb-932e-17c9ff36f341','7.5 Workshop','Well equipped and professionally-run workshop Operations for Better Vehicle and Equipment Management.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c812-7391-a168-119f58d94e13','019c630a-c812-7391-a168-119f57830fac','8.1 Fundraising','Design + develop systems to enhance collaborative fundraising efforts.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c813-73d0-8ed3-9de56080ae92','019c630a-c812-7391-a168-119f57830fac','8.2 Systems and Tool Development','Design and develop systems and tools (AI) for the organization to support its communications and fundraising efforts.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c813-73d0-8ed3-9de5631187d0','019c630a-c812-7391-a168-119f57830fac','8.3 Comms International','Design and produce creative, informative materials highlighting our unique approach and impact.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c813-73d0-8ed3-9de569fc979e','019c630a-c812-7391-a168-119f57830fac','8.4 Comms National','Design, test, and develop knowledge resources to be shared both internally + externally.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c813-73d0-8ed3-9de57059f7e8','019c630a-c813-73d0-8ed3-9de56fb890da','9.0 Honeyguide Oversight','An effective board that are able to perform their roles to support and guide the organization.','2026-12-31','open','2026-02-15 20:42:56','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc2c87d70','Website Redesign','Complete website redesign with nested task structure','2026-06-30','open','2026-02-15 20:42:56','2026-02-15 20:42:56');
/*!40000 ALTER TABLE `milestone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestone_target`
--

DROP TABLE IF EXISTS `milestone_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `milestone_target` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `milestone_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `description` longtext NOT NULL,
  `position` int(11) NOT NULL,
  `completed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_4E516F2E4B3E2EDA` (`milestone_id`),
  CONSTRAINT `FK_4E516F2E4B3E2EDA` FOREIGN KEY (`milestone_id`) REFERENCES `milestone` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestone_target`
--

LOCK TABLES `milestone_target` WRITE;
/*!40000 ALTER TABLE `milestone_target` DISABLE KEYS */;
INSERT INTO `milestone_target` VALUES
('019c630a-c809-7126-8fba-dc3ec9a11781','019c630a-c809-7126-8fba-dc3ec986e91f','MAT report showing management progress (>80% Level 3 by year end)',0,0),
('019c630a-c809-7126-8fba-dc3eca3a1ce5','019c630a-c809-7126-8fba-dc3ec986e91f','Capacited 1 Field Officer in governance, MAT, Protection, HWC monitoring',1,0),
('019c630a-c809-7126-8fba-dc3eca7f1cd5','019c630a-c809-7126-8fba-dc3ec986e91f','Co-implementation report on financial management capacity building in Ruvuma 5 WMAs with partners',2,0),
('019c630a-c809-7126-8fba-dc3ecb4eba29','019c630a-c809-7126-8fba-dc3ec986e91f','On-demand Governance Training Reports and Periodic GIA Reports for Ruvuma 5 WMAs',3,0),
('019c630a-c809-7126-8fba-dc3ecb99a362','019c630a-c809-7126-8fba-dc3ec986e91f','Maintained Rangerpost & equipment, vehicles, reports on SOPs, anti-poaching strategy, intelligence Manual and data collection system',4,0),
('019c630a-c809-7126-8fba-dc3ecbdd7217','019c630a-c809-7126-8fba-dc3ec986e91f','Reports on implemented communication strategies, stakeholder engagement strategies and awareness films',5,0),
('019c630a-c809-7126-8fba-dc3ecc2a1884','019c630a-c809-7126-8fba-dc3ec986e91f','HWC toolkits training reports',6,0),
('019c630a-c80a-702b-ba6c-cd3992c482b7','019c630a-c809-7126-8fba-dc3ec986e91f','Joint Livelihood initiative reports',7,0),
('019c630a-c80a-702b-ba6c-cd399338389a','019c630a-c809-7126-8fba-dc3ec986e91f','4 Meetings in each WMA with pastoralists, inclusion in AA and village committee',8,0),
('019c630a-c80a-702b-ba6c-cd399ab5a604','019c630a-c80a-702b-ba6c-cd399a561da4','MAT report showing management progress >80% level 3',0,0),
('019c630a-c80a-702b-ba6c-cd399afd8cfe','019c630a-c80a-702b-ba6c-cd399a561da4','Capacitated Field Officer on governance, MAT, Protection, HWC, Livelihood monitoring by Dec 2026',1,0),
('019c630a-c80a-702b-ba6c-cd399bc06c2d','019c630a-c80a-702b-ba6c-cd399a561da4','Completed Gov. training reports at least 4 per WMA, SEGA actions development progress report',2,0),
('019c630a-c80a-702b-ba6c-cd399c2dfcdc','019c630a-c80a-702b-ba6c-cd399a561da4','Customized SOPs and anti-poaching strategy documents, intelligence manual and data collection system. Construction of 1 Ranger Post and formal employment of 10 Rangers',3,0),
('019c630a-c80a-702b-ba6c-cd399cc43363','019c630a-c80a-702b-ba6c-cd399a561da4','Stakeholder engagement report, implemented communication strategy, and 3 awareness films',4,0),
('019c630a-c80a-702b-ba6c-cd39a328409a','019c630a-c80a-702b-ba6c-cd39a285ff43','MAT progress reports for Mbomipa and Waga',0,0),
('019c630a-c80a-702b-ba6c-cd39a3a82a0e','019c630a-c80a-702b-ba6c-cd39a285ff43','Trained Field Officer',1,0),
('019c630a-c80a-702b-ba6c-cd39a4615cd1','019c630a-c80a-702b-ba6c-cd39a285ff43','SEGA actions reports',2,0),
('019c630a-c80a-702b-ba6c-cd39a4d8e886','019c630a-c80a-702b-ba6c-cd39a285ff43','Carbon & other business prospects reports for Waga & MBOMIPA WMAs',3,0),
('019c630a-c80a-702b-ba6c-cd39a51b83cb','019c630a-c80a-702b-ba6c-cd39a285ff43','1 constructed RP for Waga',4,0),
('019c630a-c80a-702b-ba6c-cd39a5bf4297','019c630a-c80a-702b-ba6c-cd39a285ff43','Reports on Protection and HWC initiatives for Waga and MBOMIPA WMAs',5,0),
('019c630a-c80a-702b-ba6c-cd39a63f008e','019c630a-c80a-702b-ba6c-cd39a285ff43','Livelihood initiatives reports',6,0),
('019c630a-c80b-719c-b519-a3a905165a1c','019c630a-c80b-719c-b519-a3a9044769b8','GMP and user right in place',0,0),
('019c630a-c80b-719c-b519-a3a9053984e6','019c630a-c80b-719c-b519-a3a9044769b8','Reports of initial Ifinga WMA governance and management interventions',1,0),
('019c630a-c80b-719c-b519-a3a90597837b','019c630a-c80b-719c-b519-a3a9044769b8','Office space secured',2,0),
('019c630a-c80b-719c-b519-a3a90603441a','019c630a-c80b-719c-b519-a3a9044769b8','Professional staff in place',3,0),
('019c630a-c80b-719c-b519-a3a906d122f5','019c630a-c80b-719c-b519-a3a9044769b8','Governance reports',4,0),
('019c630a-c80b-719c-b519-a3a90b5bed36','019c630a-c80b-719c-b519-a3a90aae2828','Burunge–Honeyguide light engagement MoU / agreement',0,0),
('019c630a-c80b-719c-b519-a3a90b97c280','019c630a-c80b-719c-b519-a3a90aae2828','Governance meeting calendar and signed minutes',1,0),
('019c630a-c80b-719c-b519-a3a90c2b7d33','019c630a-c80b-719c-b519-a3a90aae2828','Basic governance status checklist (minimum standards restored)',2,0),
('019c630a-c80b-719c-b519-a3a90c406276','019c630a-c80b-719c-b519-a3a90aae2828','Stakeholder engagement log (villages, AA, district, partners)',3,0),
('019c630a-c80b-719c-b519-a3a90f1933ff','019c630a-c80b-719c-b519-a3a90ed07aa3','Updated sustainability scorecard (≥90%)',0,0),
('019c630a-c80b-719c-b519-a3a90fdc6a75','019c630a-c80b-719c-b519-a3a90ed07aa3','Revised Makame Sustainability Plan',1,0),
('019c630a-c80b-719c-b519-a3a9104d1284','019c630a-c80b-719c-b519-a3a90ed07aa3','SP26 partnership review note',2,0),
('019c630a-c80b-719c-b519-a3a9107c830d','019c630a-c80b-719c-b519-a3a90ed07aa3','Carbon and community learning curriculum pack',3,0),
('019c630a-c80b-719c-b519-a3a910df412c','019c630a-c80b-719c-b519-a3a90ed07aa3','Learning centre improvement summary (with photos)',4,0),
('019c630a-c80b-719c-b519-a3a91112f0d8','019c630a-c80b-719c-b519-a3a90ed07aa3','New livelihood initiative concept note(s)',5,0),
('019c630a-c80b-719c-b519-a3a914b8dba7','019c630a-c80b-719c-b519-a3a9145b6baf','Updated sustainability scorecard (≥90%) / human resources',0,0),
('019c630a-c80b-719c-b519-a3a9155ea408','019c630a-c80b-719c-b519-a3a9145b6baf','Combined Sustainability Plan + SP26 partnership review',1,0),
('019c630a-c80b-719c-b519-a3a9165d4b12','019c630a-c80b-719c-b519-a3a9145b6baf','Tourism plan implementation progress report',2,0),
('019c630a-c80b-719c-b519-a3a91740109d','019c630a-c80b-719c-b519-a3a9145b6baf','Photographic tourism learning hub curriculum and materials',3,0),
('019c630a-c80b-719c-b519-a3a91741bb32','019c630a-c80b-719c-b519-a3a9145b6baf','Learning centre upgrades summary (with photos)',4,0),
('019c630a-c80b-719c-b519-a3a917689bc0','019c630a-c80b-719c-b519-a3a9145b6baf','Livelihood initiatives summary sheet (existing + new) / strategy',5,0),
('019c630a-c80b-719c-b519-a3a917bd18e0','019c630a-c80b-719c-b519-a3a9145b6baf','Pastoralist engagement summary (meetings, agreements)',6,0),
('019c630a-c80c-7072-925c-47d454aa6870','019c630a-c80c-7072-925c-47d4541fa39a','Darwin programme completion report (Makao section)',0,0),
('019c630a-c80c-7072-925c-47d455444749','019c630a-c80c-7072-925c-47d4541fa39a','Updated sustainability scorecard (≥80%)',1,0),
('019c630a-c80c-7072-925c-47d455d2febf','019c630a-c80c-7072-925c-47d4541fa39a','Governance and management improvement note',2,0),
('019c630a-c80c-7072-925c-47d456bc8327','019c630a-c80c-7072-925c-47d4541fa39a','Financial resilience snapshot (income vs core and protection costs)',3,0),
('019c630a-c80c-7072-925c-47d45766df5c','019c630a-c80c-7072-925c-47d4541fa39a','Tools/equipment handover list (HWC and protection)',4,0),
('019c630a-c80c-7072-925c-47d45acc1e69','019c630a-c80c-7072-925c-47d45a06e81b','Governance and technical training completion report',0,0),
('019c630a-c80c-7072-925c-47d45b58759a','019c630a-c80c-7072-925c-47d45a06e81b','Uyumbu MAT assessment (≥75% L4)',1,0),
('019c630a-c80c-7072-925c-47d45b5c0b05','019c630a-c80c-7072-925c-47d45a06e81b','Core management manuals and policies (ops, finance, HR, patrol/HWC SOPs)',2,0),
('019c630a-c80c-7072-925c-47d45be2d6f8','019c630a-c80c-7072-925c-47d45a06e81b','Community awareness film file/link + comms materials',3,0),
('019c630a-c80c-7072-925c-47d45ccad88e','019c630a-c80c-7072-925c-47d45a06e81b','Film screening and dialogue report',4,0),
('019c630a-c80c-7072-925c-47d45cfc3d2b','019c630a-c80c-7072-925c-47d45a06e81b','Protection and HWC pilot report',5,0),
('019c630a-c80c-7072-925c-47d45d30e631','019c630a-c80c-7072-925c-47d45a06e81b','Carbon feasibility study',6,0),
('019c630a-c80c-7072-925c-47d45de83370','019c630a-c80c-7072-925c-47d45a06e81b','BEST',7,0),
('019c630a-c80c-7072-925c-47d46189c6ad','019c630a-c80c-7072-925c-47d460aea695','Governance basics starter pack (roles, templates, checklist)',0,0),
('019c630a-c80d-7011-bb25-f119ec3fd65e','019c630a-c80c-7072-925c-47d460aea695','Training and governance meeting log',1,0),
('019c630a-c80d-7011-bb25-f119ec7895cc','019c630a-c80c-7072-925c-47d460aea695','Village mobilisation report (footprint and agreements)',2,0),
('019c630a-c80d-7011-bb25-f119ecf32e90','019c630a-c80c-7072-925c-47d460aea695','Feasibility and management pack per WMA',3,0),
('019c630a-c80d-7011-bb25-f119ed318983','019c630a-c80c-7072-925c-47d460aea695','Partner engagement summary (CWMAC, others, roles)',4,0),
('019c630a-c80d-7011-bb25-f119ed420616','019c630a-c80c-7072-925c-47d460aea695','\"Readiness for scaling\" checklist per WMA',5,0),
('019c630a-c80d-7011-bb25-f119f3ad7811','019c630a-c80d-7011-bb25-f119f2f10d04','GCBF module piloted, revised, and finalized, with staff and partners trained through ToT and cascade sessions, and monitoring system in place',0,0),
('019c630a-c80d-7011-bb25-f119f3b1c876','019c630a-c80d-7011-bb25-f119f2f10d04','1–2 cost-effective awareness campaigns implemented, media collaboration strengthened, community feedback collected',1,0),
('019c630a-c80d-7011-bb25-f119f468570c','019c630a-c80d-7011-bb25-f119f2f10d04','Rapid governance orientation and assessments for new WMA leaders conducted, all field officers trained',2,0),
('019c630a-c80d-7011-bb25-f119f50eb044','019c630a-c80d-7011-bb25-f119f2f10d04','Stakeholder engagement approach piloted in selected WMAs, leaders and staff trained',3,0),
('019c630a-c80d-7011-bb25-f119f5205d41','019c630a-c80d-7011-bb25-f119f2f10d04','WMA leaders trained to use the Rapid Governance Monitoring Tool, governance reviews conducted',4,0),
('019c630a-c80d-7011-bb25-f119f5b417e1','019c630a-c80d-7011-bb25-f119f2f10d04','SAGE enhanced and expanded to support additional WMAs and partner programs',5,0),
('019c630a-c80d-7011-bb25-f119fce5d474','019c630a-c80d-7011-bb25-f119fc2384f8','Standardized FCG Monitoring Framework',0,0),
('019c630a-c80d-7011-bb25-f119fd2b656d','019c630a-c80d-7011-bb25-f119fc2384f8','Pre-customized Quick Book Chart of Accounts',1,0),
('019c630a-c80d-7011-bb25-f119fdce6953','019c630a-c80d-7011-bb25-f119fc2384f8','Board financial oversight handbook for WMAs',2,0),
('019c630a-c80d-7011-bb25-f119fde88f4f','019c630a-c80d-7011-bb25-f119fc2384f8','Packaging & publishing at least 5 additional Management Tools',3,0),
('019c630a-c80d-7011-bb25-f119fe116f75','019c630a-c80d-7011-bb25-f119fc2384f8','Pilot leadership training program report',4,0),
('019c630a-c80e-7131-9c8f-af104139476c','019c630a-c80e-7131-9c8f-af1040851aa2','HGF protection tools (SOPs, Best Practices Booklet, Engagement Strategy, Baseline Survey Template) compiled, packaged, and prepared for dissemination',0,0),
('019c630a-c80e-7131-9c8f-af1041440d3b','019c630a-c80e-7131-9c8f-af1040851aa2','Standardized Protection Tools Package developed and distributed for all WMAs',1,0),
('019c630a-c80e-7131-9c8f-af1041606793','019c630a-c80e-7131-9c8f-af1040851aa2','WMAs\' protection status monitored with quarterly reports',2,0),
('019c630a-c80e-7131-9c8f-af1041d601e4','019c630a-c80e-7131-9c8f-af1040851aa2','Quarterly-updated checklist of recommendation for WMA anti-poaching practices developed and shared',3,0),
('019c630a-c80e-7131-9c8f-af1046fd35c1','019c630a-c80e-7131-9c8f-af1046ac0939','At least 2 new innovative HEC toolkits invented',0,0),
('019c630a-c80e-7131-9c8f-af1047bdb50c','019c630a-c80e-7131-9c8f-af1046ac0939','HEC scaled up and engaged in at least 2 other countries with partners',1,0),
('019c630a-c80e-7131-9c8f-af10487007bc','019c630a-c80e-7131-9c8f-af1046ac0939','HEC methods guide compiled and packaged for use',2,0),
('019c630a-c80e-7131-9c8f-af104d1ecb51','019c630a-c80e-7131-9c8f-af104cb35aab','Education and Health program Framework drafted, reviewed, designed and finalised',0,0),
('019c630a-c80e-7131-9c8f-af104d22cc85','019c630a-c80e-7131-9c8f-af104cb35aab','Implementation Reports of Kamitei Education Model for Mbomipa, Waga, and each of the Ruvuma 5 WMAs with baseline data',1,0),
('019c630a-c80e-7131-9c8f-af104db6e6c0','019c630a-c80e-7131-9c8f-af104cb35aab','Pilot reports of at least one Agriculture and one Microcredit project designed and launched',2,0),
('019c630a-c80e-7131-9c8f-af104e25b9e9','019c630a-c80e-7131-9c8f-af104cb35aab','Database (PDF and Excel) of 10+ livelihoods models studied and documented',3,0),
('019c630a-c80e-7131-9c8f-af104eaca8e3','019c630a-c80e-7131-9c8f-af104cb35aab','Reports of at least 2 new conservation financing mechanisms developed',4,0),
('019c630a-c80f-7295-abc2-c19ddb15b523','019c630a-c80f-7295-abc2-c19dda9ef9c4','A repository of Honeyguide lessons and courses (PDFs, videos etc)',0,0),
('019c630a-c80f-7295-abc2-c19ddb1d6b8b','019c630a-c80f-7295-abc2-c19dda9ef9c4','Online self-paced learning courses',1,0),
('019c630a-c80f-7295-abc2-c19ddb7ff876','019c630a-c80f-7295-abc2-c19dda9ef9c4','Monitoring tools to measure learning uptake and changes',2,0),
('019c630a-c80f-7295-abc2-c19ddef926d2','019c630a-c80f-7295-abc2-c19ddeea6c91','Updated functional data tracking tools for WMA indicators of success, accessible with sustainability score',0,0),
('019c630a-c80f-7295-abc2-c19ddf3c017f','019c630a-c80f-7295-abc2-c19ddeea6c91','Developed Project Impact evaluation tool',1,0),
('019c630a-c80f-7295-abc2-c19ddf4b75c2','019c630a-c80f-7295-abc2-c19ddeea6c91','Data reflecting Honeyguide\'s contribution to national strategy',2,0),
('019c630a-c80f-7295-abc2-c19ddfde4df6','019c630a-c80f-7295-abc2-c19ddeea6c91','Evaluation reports for SP26 strategic plan review, assessments for Northern & Southern WMAs HWC',3,0),
('019c630a-c80f-7295-abc2-c19de05dbc28','019c630a-c80f-7295-abc2-c19ddeea6c91','Survey report on narrative change measuring community, stakeholder, and government perceptions',4,0),
('019c630a-c80f-7295-abc2-c19de0939998','019c630a-c80f-7295-abc2-c19ddeea6c91','Quarterly data updated and dashboards in Google Drive and Power BI',5,0),
('019c630a-c80f-7295-abc2-c19de0cffc9f','019c630a-c80f-7295-abc2-c19ddeea6c91','At least one forum with WMA leaders/managers for feedback',6,0),
('019c630a-c80f-7295-abc2-c19de0d55d84','019c630a-c80f-7295-abc2-c19ddeea6c91','Quarterly presentation on project progress',7,0),
('019c630a-c80f-7295-abc2-c19de1b99594','019c630a-c80f-7295-abc2-c19ddeea6c91','Quarterly consolidation of organization program reports',8,0),
('019c630a-c810-7295-986e-b7a3cdfa46dd','019c630a-c810-7295-986e-b7a3cd83402a','Well organized, updated and accessible GIS data for programs use',0,0),
('019c630a-c810-7295-986e-b7a3cee0f929','019c630a-c810-7295-986e-b7a3cd83402a','Developed template and trained WMA managers on satellite image data analysis and vegetation index query',1,0),
('019c630a-c810-7295-986e-b7a3cf8f0418','019c630a-c810-7295-986e-b7a3cd83402a','Developed specific WMA basemaps for reporting (incident and coverage)',2,0),
('019c630a-c810-7295-986e-b7a3d00f5ce6','019c630a-c810-7295-986e-b7a3cd83402a','Story Maps to support Honeyguide communications',3,0),
('019c630a-c810-7295-986e-b7a3d0d9bac2','019c630a-c810-7295-986e-b7a3cd83402a','Consistent, professional-quality maps support communication, M&E, and reporting',4,0),
('019c630a-c810-7295-986e-b7a3d6481e84','019c630a-c810-7295-986e-b7a3d54b2cef','Monthly K9 unit reports and quarterly stories',0,0),
('019c630a-c810-7295-986e-b7a3d68b58cd','019c630a-c810-7295-986e-b7a3d54b2cef','MR training center developed and approved',1,0),
('019c630a-c810-7295-986e-b7a3d7161c48','019c630a-c810-7295-986e-b7a3d54b2cef','K9 medical plan and evacuation protocol in place with vaccination and treatment schedules',2,0),
('019c630a-c810-7295-986e-b7a3db17c2f8','019c630a-c810-7295-986e-b7a3da449b51','Sightings above 100%, visibility 8-12m and 3hrs:45m in Northern Chimps subgroup',0,0),
('019c630a-c810-7295-986e-b7a3db9f1a1f','019c630a-c810-7295-986e-b7a3da449b51','Sightings above 50%, visibility 10-15m and 1hr in Southern Chimps subgroup',1,0),
('019c630a-c810-7295-986e-b7a3dbaaf8c4','019c630a-c810-7295-986e-b7a3da449b51','20km+ new trails in Southern Rubondo identified and cleared',2,0),
('019c630a-c810-7295-986e-b7a3dc6cb702','019c630a-c810-7295-986e-b7a3da449b51','5 Chimpanzee individuals identified and documented',3,0),
('019c630a-c810-7295-986e-b7a3dd3101ec','019c630a-c810-7295-986e-b7a3da449b51','17 chimp trackers trained on guiding techniques, 1st Aid, Navigation, and Botany',4,0),
('019c630a-c810-7295-986e-b7a3dd393f9d','019c630a-c810-7295-986e-b7a3da449b51','7 Community trackers attended English courses',5,0),
('019c630a-c810-7295-986e-b7a3ddda8383','019c630a-c810-7295-986e-b7a3da449b51','7 community trackers equipped with Licence D',6,0),
('019c630a-c810-7295-986e-b7a3de82c13e','019c630a-c810-7295-986e-b7a3da449b51','4-year action plan report developed and Reviewed MoU between HGF and TANAPA',7,0),
('019c630a-c810-7295-986e-b7a3dec2e845','019c630a-c810-7295-986e-b7a3da449b51','New marketing materials for Rubondo chimp products',8,0),
('019c630a-c811-71eb-932e-17c9f67ab1fb','019c630a-c811-71eb-932e-17c9f6716c79','10 TV shows on WMA related issues',0,0),
('019c630a-c811-71eb-932e-17c9f7436fc0','019c630a-c811-71eb-932e-17c9f6716c79','3 radio stations broadcasting at local level on WMA issues',1,0),
('019c630a-c811-71eb-932e-17c9f7898549','019c630a-c811-71eb-932e-17c9f6716c79','10 WMAs independently posting on social media',2,0),
('019c630a-c811-71eb-932e-17c9f8f8206e','019c630a-c811-71eb-932e-17c9f835c1a7','Benchmarking tool tested',0,0),
('019c630a-c811-71eb-932e-17c9faab0d33','019c630a-c811-71eb-932e-17c9faa359d9','1x Plan and budget developed with clear roles of network team, clear goals, monitoring and outcomes developed and shared',0,0),
('019c630a-c811-71eb-932e-17c9fb1c667e','019c630a-c811-71eb-932e-17c9faa359d9','4x Quarterly Reports developed',1,0),
('019c630a-c811-71eb-932e-17c9fc3222f2','019c630a-c811-71eb-932e-17c9fc154259','Attended BCC conference',0,0),
('019c630a-c811-71eb-932e-17c9fc8ee6ed','019c630a-c811-71eb-932e-17c9fc154259','Engaged in quarterly CLC network calls',1,0),
('019c630a-c811-71eb-932e-17c9fdc8913d','019c630a-c811-71eb-932e-17c9fcdfd5cd','2 key persons trained in advocacy and media',0,0),
('019c630a-c811-71eb-932e-17ca00f6d996','019c630a-c811-71eb-932e-17ca00134fc7','Training on the Financial and Procurement Manual in use',0,0),
('019c630a-c811-71eb-932e-17ca016aa881','019c630a-c811-71eb-932e-17ca00134fc7','Staff trained on financial systems and reporting',1,0),
('019c630a-c811-71eb-932e-17ca022ebdba','019c630a-c811-71eb-932e-17ca00134fc7','An automated/digitized finance system reduces errors and delays',2,0),
('019c630a-c811-71eb-932e-17ca02dd4dc4','019c630a-c811-71eb-932e-17ca00134fc7','Procurement Manual developed and approved by the board',3,0),
('019c630a-c811-71eb-932e-17ca03d2255a','019c630a-c811-71eb-932e-17ca00134fc7','Transparent, competitive, and compliant procurement system operational',4,0),
('019c630a-c811-71eb-932e-17ca03dcaf22','019c630a-c811-71eb-932e-17ca00134fc7','Stronger donor confidence due to improved accountability and compliance',5,0),
('019c630a-c811-71eb-932e-17ca083a0094','019c630a-c811-71eb-932e-17ca073ee40d','Job profiles and grades finalized; Competency matrix approved; HR framework published',0,0),
('019c630a-c811-71eb-932e-17ca08ddf0e4','019c630a-c811-71eb-932e-17ca073ee40d','100% of staff appraised bi-annually; 2 training sessions and mentorship program implemented',1,0),
('019c630a-c811-71eb-932e-17ca09d59440','019c630a-c811-71eb-932e-17ca073ee40d','Succession plan for executives completed; 3 departmental pipelines developed',2,0),
('019c630a-c812-7391-a168-119f4569ca87','019c630a-c811-71eb-932e-17ca073ee40d','2 leadership workshops delivered; 100% managers trained in decision-making and coaching',3,0),
('019c630a-c812-7391-a168-119f45d6c14d','019c630a-c811-71eb-932e-17ca073ee40d','1 culture survey conducted; Recognition program launched; Engagement index improved by 15%',4,0),
('019c630a-c812-7391-a168-119f46261f55','019c630a-c811-71eb-932e-17ca073ee40d','Data protection policy and registers developed; All staff trained on compliance',5,0),
('019c630a-c812-7391-a168-119f4a983f54','019c630a-c812-7391-a168-119f4a8cff16','All five core modules (Leave, Payroll, Performance, Assets, M&E) developed, tested, and deployed',0,0),
('019c630a-c812-7391-a168-119f4b822790','019c630a-c812-7391-a168-119f4a8cff16','Data Protection Policy and compliance framework fully developed, approved, and rolled out',1,0),
('019c630a-c812-7391-a168-119f4bf206ec','019c630a-c812-7391-a168-119f4a8cff16','ICT infrastructure maintained at 95%+ uptime, with quarterly preventive maintenance and license renewals',2,0),
('019c630a-c812-7391-a168-119f4c740665','019c630a-c812-7391-a168-119f4a8cff16','Shared digital workspace for WMA resources established and actively used',3,0),
('019c630a-c812-7391-a168-119f4f23bded','019c630a-c812-7391-a168-119f4ee0404f','Digital Asset Management System (linked to finance system) operational, with quarterly automated reports and annual physical verification completed',0,0),
('019c630a-c812-7391-a168-119f5000c7c5','019c630a-c812-7391-a168-119f4ee0404f','Comprehensive Risk Management Framework finalized and implemented, with quarterly risk review reports and updated risk register',1,0),
('019c630a-c812-7391-a168-119f52602fe3','019c630a-c812-7391-a168-119f520535b3','100% of fleet serviced on schedule, with >95% operational readiness',0,0),
('019c630a-c812-7391-a168-119f5260b5db','019c630a-c812-7391-a168-119f520535b3','90%+ of repairs completed within 24 hours',1,0),
('019c630a-c812-7391-a168-119f533e7c66','019c630a-c812-7391-a168-119f520535b3','Standardized checklist adopted, reducing unscheduled repairs by 15% in Q1',2,0),
('019c630a-c812-7391-a168-119f543abf62','019c630a-c812-7391-a168-119f520535b3','100% of vehicles pass safety inspections; zero workshop-related accidents',3,0),
('019c630a-c812-7391-a168-119f548f8b70','019c630a-c812-7391-a168-119f520535b3','100% of workshop staff trained and adhering to SOPs by year-end',4,0),
('019c630a-c812-7391-a168-119f54a96175','019c630a-c812-7391-a168-119f520535b3','Accurate reports submitted on time with actionable insights',5,0),
('019c630a-c812-7391-a168-119f59d7f4c5','019c630a-c812-7391-a168-119f58d94e13','Key long-term donors maintained or increased contribution, at least one donor increased support by 20%',0,0),
('019c630a-c812-7391-a168-119f5a4723c4','019c630a-c812-7391-a168-119f58d94e13','Funding gap for 2026 reduced by 100%',1,0),
('019c630a-c812-7391-a168-119f5ae93f14','019c630a-c812-7391-a168-119f58d94e13','Funding gap for 2027 reduced by 70%',2,0),
('019c630a-c812-7391-a168-119f5bd8a747','019c630a-c812-7391-a168-119f58d94e13','Engaged in productive discussions with at least 2 donors that can contribute >50k per year',3,0),
('019c630a-c812-7391-a168-119f5c405b34','019c630a-c812-7391-a168-119f58d94e13','Responded to at least 1 large multi-year international call (>400k - Darwin)',4,0),
('019c630a-c813-73d0-8ed3-9de55c4a81b9','019c630a-c812-7391-a168-119f58d94e13','MOUs and agreements with partners that include joint fundraising',5,0),
('019c630a-c813-73d0-8ed3-9de55cf5baa4','019c630a-c812-7391-a168-119f58d94e13','Raised necessary funds to support Special Programs (K9 + Rubondo) - HWC Lab potential',6,0),
('019c630a-c813-73d0-8ed3-9de5608f5eba','019c630a-c813-73d0-8ed3-9de56080ae92','Collaborative dashboard with updated information/data tracking organizational impact 2017-2025',0,0),
('019c630a-c813-73d0-8ed3-9de56098bf87','019c630a-c813-73d0-8ed3-9de56080ae92','Shared dashboard monitoring HGF impact on national WMA strategy 2023-2033',1,0),
('019c630a-c813-73d0-8ed3-9de560e5813c','019c630a-c813-73d0-8ed3-9de56080ae92','Active online library with easy search and retrieve functions, HGF team trained',2,0),
('019c630a-c813-73d0-8ed3-9de5612f9829','019c630a-c813-73d0-8ed3-9de56080ae92','Monthly updating from WhatsApp groups and organizing photos on Smugmug',3,0),
('019c630a-c813-73d0-8ed3-9de563489fb6','019c630a-c813-73d0-8ed3-9de5631187d0','Four communication campaigns developed annually, one per quarter',0,0),
('019c630a-c813-73d0-8ed3-9de563b78c2e','019c630a-c813-73d0-8ed3-9de5631187d0','Donor Visibility Guidelines: one-page document per donor',1,0),
('019c630a-c813-73d0-8ed3-9de56465ba19','019c630a-c813-73d0-8ed3-9de5631187d0','Annual Report produced',2,0),
('019c630a-c813-73d0-8ed3-9de564eadb75','019c630a-c813-73d0-8ed3-9de5631187d0','Case Studies highlighting key field activities, produced quarterly',3,0),
('019c630a-c813-73d0-8ed3-9de565670231','019c630a-c813-73d0-8ed3-9de5631187d0','Brochures & Presentations updated biannually',4,0),
('019c630a-c813-73d0-8ed3-9de565a9344d','019c630a-c813-73d0-8ed3-9de5631187d0','Four 5-minute promotional videos produced annually',5,0),
('019c630a-c813-73d0-8ed3-9de5663e6cfe','019c630a-c813-73d0-8ed3-9de5631187d0','Website Redesign: Honeyguide Innovation section added',6,0),
('019c630a-c813-73d0-8ed3-9de5669acdca','019c630a-c813-73d0-8ed3-9de5631187d0','Communications Plan for 2026 created',7,0),
('019c630a-c813-73d0-8ed3-9de56a71c71d','019c630a-c813-73d0-8ed3-9de569fc979e','Produced quarterly newsletter in Swahili',0,0),
('019c630a-c813-73d0-8ed3-9de56b08e307','019c630a-c813-73d0-8ed3-9de569fc979e','Weekly posts in social media and shared reports',1,0),
('019c630a-c813-73d0-8ed3-9de56b8caeaa','019c630a-c813-73d0-8ed3-9de569fc979e','Posters designed and shared of Honeyguide work',2,0),
('019c630a-c813-73d0-8ed3-9de56c8676c7','019c630a-c813-73d0-8ed3-9de569fc979e','Honeyguide is live in Swahili',3,0),
('019c630a-c813-73d0-8ed3-9de570ab3a03','019c630a-c813-73d0-8ed3-9de57059f7e8','At least 2 new board members recruited by end of year',0,0),
('019c630a-c813-73d0-8ed3-9de57107ce2a','019c630a-c813-73d0-8ed3-9de57059f7e8','An online training course is designed and shared to the board members; all board members have completed the course',1,0),
('019c630a-c813-73d0-8ed3-9de5719a2ea6','019c630a-c813-73d0-8ed3-9de57059f7e8','Revised constitution in place. Onboarding procedure in place for new members',2,0),
('019c630a-c814-7066-a341-03bfba825922','019c630a-c813-73d0-8ed3-9de57059f7e8','Annual meeting dates communicated in January. 4 online board meetings held. 1 AGM held. Annual retreat of at least 2 days held',3,0);
/*!40000 ALTER TABLE `milestone_target` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `recipient_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `actor_id` char(36) DEFAULT NULL COMMENT '(DC2Type:uuid)',
  `type` varchar(255) NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `entity_name` varchar(255) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`data`)),
  `read_at` datetime DEFAULT NULL COMMENT '(DC2Type:datetime_immutable)',
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_BF5476CAE92F8F78` (`recipient_id`),
  KEY `IDX_BF5476CA10DAF24A` (`actor_id`),
  KEY `idx_notification_recipient_read` (`recipient_id`,`read_at`),
  KEY `idx_notification_recipient_created` (`recipient_id`,`created_at`),
  CONSTRAINT `FK_BF5476CA10DAF24A` FOREIGN KEY (`actor_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_BF5476CAE92F8F78` FOREIGN KEY (`recipient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pending_registration_request`
--

DROP TABLE IF EXISTS `pending_registration_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pending_registration_request` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `reviewed_by_id` char(36) DEFAULT NULL COMMENT '(DC2Type:uuid)',
  `email` varchar(180) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `domain` varchar(100) NOT NULL,
  `registration_type` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `reviewed_at` datetime DEFAULT NULL COMMENT '(DC2Type:datetime_immutable)',
  `note` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_C17B1042FC6B21F1` (`reviewed_by_id`),
  KEY `idx_pending_reg_status` (`status`),
  KEY `idx_pending_reg_email` (`email`),
  CONSTRAINT `FK_C17B1042FC6B21F1` FOREIGN KEY (`reviewed_by_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pending_registration_request`
--

LOCK TABLES `pending_registration_request` WRITE;
/*!40000 ALTER TABLE `pending_registration_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_registration_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_setting`
--

DROP TABLE IF EXISTS `portal_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portal_setting` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `setting_key` varchar(100) NOT NULL,
  `value` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_9EB160815FA1E697` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_setting`
--

LOCK TABLES `portal_setting` WRITE;
/*!40000 ALTER TABLE `portal_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `portal_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `owner_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `start_date` date DEFAULT NULL COMMENT '(DC2Type:date_immutable)',
  `end_date` date DEFAULT NULL COMMENT '(DC2Type:date_immutable)',
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `is_personal` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `IDX_2FB3D0EE7E3C61F9` (`owner_id`),
  CONSTRAINT `FK_2FB3D0EE7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES
('019c630a-c808-706a-9f45-2c5790f2b9bf','019c630a-b05c-72c9-9b73-eb6bfce09b51','System\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c808-706a-9f45-2c5792bf872c','019c630a-b257-7268-aac4-4e21d730bcef','Sylvester\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c808-706a-9f45-2c5794188a14','019c630a-b453-7069-9342-8fe43b87ae79','Max\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3eb8e24ed5','019c630a-b64b-719b-8407-dd421c0d9fa0','Fatma\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3eba372d0a','019c630a-b844-73a1-bbe9-987ab3f2c539','Namnyaki\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ebbc5cc1f','019c630a-ba72-7038-a67b-a4c9b9097c41','Kateto\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ebdb9238d','019c630a-bc5f-7032-8698-b1c1a8efcdf9','Lemuta\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ebf326fa5','019c630a-be4c-7084-a19e-3f6cb3c11d10','Glad\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ec0fed519','019c630a-c039-70a0-b3ef-8ba7a5f9946b','Daudi\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ec2e42897','019c630a-c22c-73dc-91d7-3dcb60740f03','Michael\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ec3ac40cd','019c630a-c423-71ad-802f-3381781a4193','Meleck\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ec5e13161','019c630a-c614-70ea-a11b-5c4247321a54','Sam\'s Personal Project','Your personal workspace for tasks and projects.','active',NULL,NULL,'2026-02-15 20:42:56','2026-02-15 20:42:56',0,1),
('019c630a-c809-7126-8fba-dc3ec7d6266e','019c630a-b05c-72c9-9b73-eb6bfce09b51','A. Southern WMAs Portfolio','Goal 1: Southern WMAs achieve improved governance, management, protection, HWC mitigation, livelihoods, and stakeholder engagement.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c80b-719c-b519-a3a908ba4763','019c630a-b05c-72c9-9b73-eb6bfce09b51','B. Northern WMAs Portfolio','Goal 1: Northern WMAs achieve sustainability through improved governance, management, protection, livelihoods, and stakeholder engagement.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c80d-7011-bb25-f119ef792fab','019c630a-b05c-72c9-9b73-eb6bfce09b51','C. Technical Innovations (Honeyguide Lab)','Develop and package replicable tools, frameworks, and innovations for governance, management, protection, HWC, livelihoods, and learning across WMAs.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c80f-7295-abc2-c19ddceaf933','019c630a-b05c-72c9-9b73-eb6bfce09b51','D. Monitoring, Evaluation & Learning','Strengthen M&E systems, data management, GIS and mapping services aligned with SP26.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c810-7295-986e-b7a3d3a7b70c','019c630a-b05c-72c9-9b73-eb6bfce09b51','E. Special Programs','K9 Unit operations and Rubondo Chimpanzee Habituation Project.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c811-71eb-932e-17c9f4f8d6e2','019c630a-b05c-72c9-9b73-eb6bfce09b51','F. Narrative Change & Strategic Influence','Goal 2: Narrative change and strategic influence through public awareness, stakeholder perception, policy, regional networks, and capacity building.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c811-71eb-932e-17c9ff36f341','019c630a-b05c-72c9-9b73-eb6bfce09b51','G. Finance and Admin','Financial management, HR, IT infrastructure, asset/risk management, and workshop operations.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c812-7391-a168-119f57830fac','019c630a-b05c-72c9-9b73-eb6bfce09b51','H. Communication and Fundraising','Fundraising, systems/tools development, international and national communications.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c813-73d0-8ed3-9de56fb890da','019c630a-b05c-72c9-9b73-eb6bfce09b51','I. Honeyguide Board Governance','An effective board that are able to perform their roles to support and guide the organization.','active','2026-01-01','2026-12-31','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0),
('019c630a-c814-7066-a341-03bfc2c87d70','019c630a-b05c-72c9-9b73-eb6bfce09b51','Gantt Test Project','Project with nested tasks for testing Gantt chart display','active','2026-01-01','2026-06-30','2026-02-15 20:42:56','2026-02-15 20:42:56',1,0);
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_member`
--

DROP TABLE IF EXISTS `project_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_member` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `project_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `user_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `joined_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `role_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_user_unique` (`project_id`,`user_id`),
  KEY `IDX_67401132166D1F9C` (`project_id`),
  KEY `IDX_67401132A76ED395` (`user_id`),
  KEY `IDX_67401132D60322AC` (`role_id`),
  CONSTRAINT `FK_67401132166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_67401132A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_67401132D60322AC` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_member`
--

LOCK TABLES `project_member` WRITE;
/*!40000 ALTER TABLE `project_member` DISABLE KEYS */;
INSERT INTO `project_member` VALUES
('019c630a-c808-706a-9f45-2c579171ca4d','019c630a-c808-706a-9f45-2c5790f2b9bf','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c808-706a-9f45-2c57936e5edc','019c630a-c808-706a-9f45-2c5792bf872c','019c630a-b257-7268-aac4-4e21d730bcef','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c808-706a-9f45-2c57948d8bef','019c630a-c808-706a-9f45-2c5794188a14','019c630a-b453-7069-9342-8fe43b87ae79','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3eb8e47420','019c630a-c809-7126-8fba-dc3eb8e24ed5','019c630a-b64b-719b-8407-dd421c0d9fa0','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ebab7c198','019c630a-c809-7126-8fba-dc3eba372d0a','019c630a-b844-73a1-bbe9-987ab3f2c539','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ebcac420d','019c630a-c809-7126-8fba-dc3ebbc5cc1f','019c630a-ba72-7038-a67b-a4c9b9097c41','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ebe7fd849','019c630a-c809-7126-8fba-dc3ebdb9238d','019c630a-bc5f-7032-8698-b1c1a8efcdf9','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ebfbad863','019c630a-c809-7126-8fba-dc3ebf326fa5','019c630a-be4c-7084-a19e-3f6cb3c11d10','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec1d10293','019c630a-c809-7126-8fba-dc3ec0fed519','019c630a-c039-70a0-b3ef-8ba7a5f9946b','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec3869c1f','019c630a-c809-7126-8fba-dc3ec2e42897','019c630a-c22c-73dc-91d7-3dcb60740f03','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec4680975','019c630a-c809-7126-8fba-dc3ec3ac40cd','019c630a-c423-71ad-802f-3381781a4193','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec67f58c8','019c630a-c809-7126-8fba-dc3ec5e13161','019c630a-c614-70ea-a11b-5c4247321a54','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec85281db','019c630a-c809-7126-8fba-dc3ec7d6266e','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c809-7126-8fba-dc3ec88dcdd7','019c630a-c809-7126-8fba-dc3ec7d6266e','019c630a-b257-7268-aac4-4e21d730bcef','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80b-719c-b519-a3a90980d6f7','019c630a-c80b-719c-b519-a3a908ba4763','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c80b-719c-b519-a3a909842b8c','019c630a-c80b-719c-b519-a3a908ba4763','019c630a-b453-7069-9342-8fe43b87ae79','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80b-719c-b519-a3a90a0dbede','019c630a-c80b-719c-b519-a3a908ba4763','019c630a-c614-70ea-a11b-5c4247321a54','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80d-7011-bb25-f119efa072a5','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c80d-7011-bb25-f119f0255741','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-b64b-719b-8407-dd421c0d9fa0','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80d-7011-bb25-f119f0629b92','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-b844-73a1-bbe9-987ab3f2c539','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80d-7011-bb25-f119f147f728','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-ba72-7038-a67b-a4c9b9097c41','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80d-7011-bb25-f119f245553e','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-bc5f-7032-8698-b1c1a8efcdf9','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80d-7011-bb25-f119f2645c19','019c630a-c80d-7011-bb25-f119ef792fab','019c630a-be4c-7084-a19e-3f6cb3c11d10','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80f-7295-abc2-c19ddd061f84','019c630a-c80f-7295-abc2-c19ddceaf933','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c80f-7295-abc2-c19ddda123da','019c630a-c80f-7295-abc2-c19ddceaf933','019c630a-c039-70a0-b3ef-8ba7a5f9946b','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c80f-7295-abc2-c19dde0baa49','019c630a-c80f-7295-abc2-c19ddceaf933','019c630a-c22c-73dc-91d7-3dcb60740f03','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c810-7295-986e-b7a3d451d669','019c630a-c810-7295-986e-b7a3d3a7b70c','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c810-7295-986e-b7a3d496b0db','019c630a-c810-7295-986e-b7a3d3a7b70c','019c630a-c423-71ad-802f-3381781a4193','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9'),
('019c630a-c811-71eb-932e-17c9f59e7fd5','019c630a-c811-71eb-932e-17c9f4f8d6e2','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c811-71eb-932e-17c9ffbeff39','019c630a-c811-71eb-932e-17c9ff36f341','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c812-7391-a168-119f57f1cb81','019c630a-c812-7391-a168-119f57830fac','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c813-73d0-8ed3-9de56fd1fe21','019c630a-c813-73d0-8ed3-9de56fb890da','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c814-7066-a341-03bfc2cbacd9','019c630a-c814-7066-a341-03bfc2c87d70','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b30b4b9ab'),
('019c630a-c814-7066-a341-03bfc339f602','019c630a-c814-7066-a341-03bfc2c87d70','019c630a-b453-7069-9342-8fe43b87ae79','2026-02-15 20:42:56','019c630a-b035-700b-b59a-615b319e0cf9');
/*!40000 ALTER TABLE `project_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reset_password_request`
--

DROP TABLE IF EXISTS `reset_password_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reset_password_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `selector` varchar(20) NOT NULL,
  `hashed_token` varchar(100) NOT NULL,
  `requested_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `expires_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_7CE748AA76ED395` (`user_id`),
  CONSTRAINT `FK_7CE748AA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reset_password_request`
--

LOCK TABLES `reset_password_request` WRITE;
/*!40000 ALTER TABLE `reset_password_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `reset_password_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `is_system_role` tinyint(1) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`permissions`)),
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_ROLE_SLUG` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES
('019c630a-b033-7165-b5d5-ba106f0a75c6','Portal SuperAdmin','portal-super-admin','Full system access with all permissions','portal',1,'[\"project.view\",\"project.create\",\"project.edit\",\"project.delete\",\"project.manage_members\",\"project.archive\",\"milestone.view\",\"milestone.create\",\"milestone.edit\",\"milestone.delete\",\"milestone.complete\",\"task.view\",\"task.create\",\"task.edit\",\"task.delete\",\"task.assign\",\"task.change_status\",\"task.change_priority\",\"checklist.view\",\"checklist.create\",\"checklist.edit\",\"checklist.delete\",\"checklist.toggle\",\"comment.view\",\"comment.create\",\"comment.edit_own\",\"comment.edit_any\",\"comment.delete_own\",\"comment.delete_any\",\"tag.view\",\"tag.create\",\"tag.edit\",\"tag.delete\",\"tag.assign\",\"user.view\",\"user.create\",\"user.edit\",\"user.delete\",\"user.manage_roles\",\"role.view\",\"role.create\",\"role.edit\",\"role.delete\"]','2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b035-700b-b59a-615b2fbeabac','Portal Admin','portal-admin','Manage users and access all projects','portal',1,'[\"user.view\",\"user.create\",\"user.edit\",\"user.manage_roles\",\"role.view\",\"project.view\",\"project.create\",\"project.edit\",\"project.delete\",\"project.manage_members\",\"project.archive\",\"project.view\",\"project.create\",\"project.edit\",\"project.delete\",\"project.manage_members\",\"project.archive\",\"milestone.view\",\"milestone.create\",\"milestone.edit\",\"milestone.delete\",\"milestone.complete\",\"task.view\",\"task.create\",\"task.edit\",\"task.delete\",\"task.assign\",\"task.change_status\",\"task.change_priority\",\"checklist.view\",\"checklist.create\",\"checklist.edit\",\"checklist.delete\",\"checklist.toggle\",\"comment.view\",\"comment.create\",\"comment.edit_own\",\"comment.edit_any\",\"comment.delete_own\",\"comment.delete_any\",\"tag.view\",\"tag.create\",\"tag.edit\",\"tag.delete\",\"tag.assign\"]','2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b035-700b-b59a-615b30b4b9ab','Project Manager','project-manager','Full control over assigned projects','project',1,'[\"project.view\",\"project.edit\",\"project.delete\",\"project.manage_members\",\"project.archive\",\"milestone.view\",\"milestone.create\",\"milestone.edit\",\"milestone.delete\",\"milestone.complete\",\"task.view\",\"task.create\",\"task.edit\",\"task.delete\",\"task.assign\",\"task.change_status\",\"task.change_priority\",\"checklist.view\",\"checklist.create\",\"checklist.edit\",\"checklist.delete\",\"checklist.toggle\",\"comment.view\",\"comment.create\",\"comment.edit_own\",\"comment.edit_any\",\"comment.delete_own\",\"comment.delete_any\",\"tag.view\",\"tag.create\",\"tag.edit\",\"tag.delete\",\"tag.assign\"]','2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b035-700b-b59a-615b319e0cf9','Project Member','project-member','Work on tasks and collaborate','project',1,'[\"project.view\",\"milestone.view\",\"milestone.complete\",\"task.view\",\"task.create\",\"task.edit\",\"task.assign\",\"task.change_status\",\"task.change_priority\",\"checklist.view\",\"checklist.create\",\"checklist.edit\",\"checklist.delete\",\"checklist.toggle\",\"comment.view\",\"comment.create\",\"comment.edit_own\",\"comment.delete_own\",\"tag.view\",\"tag.create\",\"tag.assign\"]','2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b035-700b-b59a-615b32017ee3','Project Viewer','project-viewer','Read-only access to project','project',1,'[\"project.view\",\"milestone.view\",\"task.view\",\"checklist.view\",\"comment.view\",\"tag.view\"]','2026-02-15 20:42:50','2026-02-15 20:42:50');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `created_by_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `name` varchar(50) NOT NULL,
  `color` varchar(7) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_389B7835E237E06` (`name`),
  KEY `IDX_389B783B03A8386` (`created_by_id`),
  CONSTRAINT `FK_TAG_CREATED_BY` FOREIGN KEY (`created_by_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES
('019c630a-c814-7066-a341-03bfbc90a6b4','019c630a-b05c-72c9-9b73-eb6bfce09b51','governance','#3b82f6','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbce0842f','019c630a-b05c-72c9-9b73-eb6bfce09b51','management','#22c55e','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbd36da58','019c630a-b05c-72c9-9b73-eb6bfce09b51','protection','#ef4444','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbe0b6746','019c630a-b05c-72c9-9b73-eb6bfce09b51','HWC','#f97316','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbe6f4621','019c630a-b05c-72c9-9b73-eb6bfce09b51','livelihoods','#8b5cf6','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbec763ac','019c630a-b05c-72c9-9b73-eb6bfce09b51','M&E','#06b6d4','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbfaa8fa8','019c630a-b05c-72c9-9b73-eb6bfce09b51','GIS','#14b8a6','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfbfb54126','019c630a-b05c-72c9-9b73-eb6bfce09b51','fundraising','#eab308','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc02d709d','019c630a-b05c-72c9-9b73-eb6bfce09b51','communications','#ec4899','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc0f5b9b3','019c630a-b05c-72c9-9b73-eb6bfce09b51','finance','#84cc16','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc1145127','019c630a-b05c-72c9-9b73-eb6bfce09b51','HR','#d946ef','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc20d1bd6','019c630a-b05c-72c9-9b73-eb6bfce09b51','IT','#6b7280','2026-02-15 20:42:56');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `milestone_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `parent_id` char(36) DEFAULT NULL COMMENT '(DC2Type:uuid)',
  `title` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `priority` varchar(255) NOT NULL,
  `due_date` date DEFAULT NULL COMMENT '(DC2Type:date_immutable)',
  `position` int(11) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `start_date` date DEFAULT NULL COMMENT '(DC2Type:date_immutable)',
  `status_type_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_527EDB254B3E2EDA` (`milestone_id`),
  KEY `IDX_527EDB25727ACA70` (`parent_id`),
  KEY `idx_task_status` (`status`),
  KEY `idx_task_priority` (`priority`),
  KEY `idx_task_due_date` (`due_date`),
  KEY `IDX_527EDB2570A22CE8` (`status_type_id`),
  CONSTRAINT `FK_527EDB254B3E2EDA` FOREIGN KEY (`milestone_id`) REFERENCES `milestone` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_527EDB2570A22CE8` FOREIGN KEY (`status_type_id`) REFERENCES `task_status_type` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_527EDB25727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES
('019c630a-c80a-702b-ba6c-cd3993aae401','019c630a-c809-7126-8fba-dc3ec986e91f',NULL,'1.1.1 MAT operational efficiency','MAT with a focus on achieving >80% Level 3 for operational efficiency, & filling training gaps to Field Officers.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd399426cc0b','019c630a-c809-7126-8fba-dc3ec986e91f',NULL,'1.1.2 AA leadership & GIA governance','Strengthen AA leadership, decision-making and compliance so Ruvuma 5 WMAs meet mandatory GIA standards and uphold transparent, accountable participatory governance.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd3995a2addf','019c630a-c809-7126-8fba-dc3ec986e91f',NULL,'1.1.3 Community-led protection & HWC','Developing and implementing community-led natural resource protection & HWC strategies that are cost-effective, data-driven, and show clear positive results on the ground.','todo','high','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd3996ba7fab','019c630a-c809-7126-8fba-dc3ec986e91f',NULL,'1.1.4 Community livelihood programs','Delivering cost-effective, data-driven community livelihood programs with measurable social impact.','todo','medium','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd399882ae49','019c630a-c809-7126-8fba-dc3ec986e91f',NULL,'1.1.5 SMART engagement strategies','Implement SMART engagement strategies to raise awareness, strengthen collaboration, and foster pastoralist WMA ownership.','todo','medium','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd399d5b50d1','019c630a-c80a-702b-ba6c-cd399a561da4',NULL,'1.2.1 MAT operational efficiency','MAT aiming for >80% Level 3 in operational efficiency, & filling training gaps of Field Officers.','todo','high','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd399df35389','019c630a-c80a-702b-ba6c-cd399a561da4',NULL,'1.2.2 Governance interventions & GIA','Implement targeted governance interventions & GIA actions to provide an enabling environment for governance best practices in daily WMA operations.','todo','high','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd399e7d8a82','019c630a-c80a-702b-ba6c-cd399a561da4',NULL,'1.2.3 Community-led protection','Implementing community-led natural resource protection strategies that are cost-effective, data-driven, and show clear positive results on the ground.','todo','high','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd39a0386950','019c630a-c80a-702b-ba6c-cd399a561da4',NULL,'1.2.4 Stakeholder engagement & comms','Customize and implement SMART stakeholder engagement and communications strategies to raise awareness, and enhance collaboration and ownership of WMA initiatives.','todo','medium','2026-12-31',8,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd39a11a4da8','019c630a-c80a-702b-ba6c-cd399a561da4',NULL,'1.2.5 SEGA Actions in Liwale','Implementing SEGA Actions in Liwale WMA.','todo','medium','2026-12-31',9,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd39a6c0bf15','019c630a-c80a-702b-ba6c-cd39a285ff43',NULL,'1.3.1 MAT Mbomipa & Waga','MAT in Mbomipa and Waga WMAs, to reach 80% MAT level 3.','todo','high','2026-12-31',10,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd39a7b43846','019c630a-c80a-702b-ba6c-cd39a285ff43',NULL,'1.3.2 Governance & GIA interventions','Implement targeted governance and GIA interventions addressing SAGE findings.','todo','high','2026-12-31',11,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80a-702b-ba6c-cd39a869107b','019c630a-c80a-702b-ba6c-cd39a285ff43',NULL,'1.3.3 Alternative financing models','Develop alternative financing and business models to ensure WMAs\' sustainability.','todo','medium','2026-12-31',12,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a901d5007f','019c630a-c80a-702b-ba6c-cd39a285ff43',NULL,'1.3.4 Protection & HWC strategies','Exploring cost-effective community-led natural resource protection & HWC strategies that are data-driven and show clear positive results on the ground.','todo','high','2026-12-31',13,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a902aafe9c','019c630a-c80a-702b-ba6c-cd39a285ff43',NULL,'1.3.5 Community livelihood programs','Implement community-led, cost-effective, data-driven livelihood programs showing social and behavioral benefits.','todo','medium','2026-12-31',14,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a9076bd2aa','019c630a-c80b-719c-b519-a3a9044769b8',NULL,'1.4.1 WMA establishment support','Support Ifinga WMA communities and relevant stakeholders in the establishment of the WMA.','todo','high','2026-12-31',15,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a90832dd08','019c630a-c80b-719c-b519-a3a9044769b8',NULL,'1.4.2 Basic governance & management training','Support WMA basic governance & management trainings.','todo','high','2026-12-31',16,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a90d0afad4','019c630a-c80b-719c-b519-a3a90aae2828',NULL,'2.1.1 Re-establish Burunge relationship','Re-establish a constructive working relationship with Burunge WMA.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a91209a3e3','019c630a-c80b-719c-b519-a3a90ed07aa3',NULL,'2.2.1 Sustainability indicators ≥90%','Achieve ≥90% on Makame sustainability indicators and update the Sustainability Plan and SP26 partnership accordingly.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a913241fe1','019c630a-c80b-719c-b519-a3a90ed07aa3',NULL,'2.2.2 Carbon & community learning hub','Strengthen Makame as a carbon-and-community learning hub by improving the curriculum and learning centre infrastructure.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a913ec7efa','019c630a-c80b-719c-b519-a3a90ed07aa3',NULL,'2.2.3 Additional livelihood initiatives','Develop additional livelihood initiatives that increase Makame community benefits beyond health and education.','todo','medium','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80b-719c-b519-a3a9186f4f3b','019c630a-c80b-719c-b519-a3a9145b6baf',NULL,'2.3.1 Sustainability indicators ≥90%','Achieve ≥90% on Randilen sustainability indicators and update the Sustainability Plan and renewed partnership / focus on human resources and capacity.','todo','high','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d4522ed07b','019c630a-c80b-719c-b519-a3a9145b6baf',NULL,'2.3.2 Photographic tourism learning hub','Position Randilen as a leading photographic tourism learning hub by improving curriculum, learning centre infrastructure, and implementing the tourism plan.','todo','medium','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d452c995b4','019c630a-c80b-719c-b519-a3a9145b6baf',NULL,'2.3.3 Additional livelihood initiatives','Develop additional livelihood initiatives that increase Randilen community benefits beyond health and education.','todo','medium','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d4576fde59','019c630a-c80c-7072-925c-47d4541fa39a',NULL,'2.4.1 Darwin programme completion','Finalise the Darwin-funded programme, delivering agreed habitat, governance, and livelihood improvements in Makao.','todo','high','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d458b73eb9','019c630a-c80c-7072-925c-47d4541fa39a',NULL,'2.4.2 Sustainability score ≥80%','Raise Makao\'s sustainability score to ≥80% by strengthening governance, management, and a cost-effective protection unit.','todo','high','2026-12-31',8,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d459cbdfda','019c630a-c80c-7072-925c-47d4541fa39a',NULL,'2.4.3 Financial & community benefits plan','Establish a simple financial and community benefits plan that supports Makao\'s growth and resilience.','todo','medium','2026-12-31',9,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d45e8503a7','019c630a-c80c-7072-925c-47d45a06e81b',NULL,'2.5.1 Governance to MAT ≥75% L3','Strengthen Uyumbu governance to MAT ≥75% L3 through targeted capacity building (technical training, learning tour) and core management manuals, guidelines, and policies.','todo','high','2026-12-31',10,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d45f3d4451','019c630a-c80c-7072-925c-47d45a06e81b',NULL,'2.5.2 Community trust & awareness','Rebuild community and stakeholder trust via a short awareness film, concise communication materials, and facilitated dialogue screenings.','todo','medium','2026-12-31',11,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80c-7072-925c-47d45fab6a02','019c630a-c80c-7072-925c-47d45a06e81b',NULL,'2.5.3 Protection, HWC & carbon feasibility','Pilot strategic protection and human–wildlife conflict operations and complete a carbon-business feasibility assessment to secure sustainable revenue streams, including a clear BEST.','todo','high','2026-12-31',12,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119eddb6969','019c630a-c80c-7072-925c-47d460aea695',NULL,'2.6.1 Governance basics establishment','Establish governance basics (clarified roles, minuted decision-making meetings, short practical training) using a light-touch engagement model as time and resources allow.','todo','medium','2026-12-31',13,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119eedec85b','019c630a-c80c-7072-925c-47d460aea695',NULL,'2.6.2 Scalable livelihood models','Explore scalable livelihood models for Northern WMAs, including community banks and community training with SAWC.','todo','medium','2026-12-31',14,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119f644ecda','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.1 Pilot & monitor GCBF Module','Pilot, Cascade, and Monitor the GCBF Module.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119f75232ac','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.2 Institutionalize governance docs & tools','Institutionalize and package all existing governance documents, GIA, tools, and methodologies for standardized use across WMAs.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119f92caa9b','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.3 Rapid governance training for new leaders','Pilot and Support Rapid Governance Training for New WMA Leaders.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119f9d6719e','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.4 Stakeholder engagement approach pilot','Pilot Testing and Learning from the Stakeholder Engagement & Communication Approach.','todo','medium','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119fa58f7d1','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.5 Rapid Governance Monitoring Tool','Provide initial training and support for the WMA Rapid Governance Monitoring Tool for regular governance assessments.','todo','medium','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119fb4c78f5','019c630a-c80d-7011-bb25-f119f2f10d04',NULL,'3.1.6 Enhance & scale SAGE','Enhance and scale SAGE for wider adoption across WMAs and partner programs beyond HGF\'s primary areas.','todo','medium','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119fea7c364','019c630a-c80d-7011-bb25-f119fc2384f8',NULL,'3.2.1 FCG Monitoring tool','Develop FCG Monitoring tool and testing.','todo','high','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80d-7011-bb25-f119ff2e8392','019c630a-c80d-7011-bb25-f119fc2384f8',NULL,'3.2.2 QuickBooks lite setup for WMAs','Develop pre-customized Quickbook lite setup file for WMAs (to build uniformity across WMAs).','todo','medium','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af103e37e4a4','019c630a-c80d-7011-bb25-f119fc2384f8',NULL,'3.2.3 Board Financial Oversight Handbook','Develop WMA Board Financial Oversight Handbook + Tools (Helps governance members challenge management constructively and make informed approvals).','todo','medium','2026-12-31',8,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af103f02844f','019c630a-c80d-7011-bb25-f119fc2384f8',NULL,'3.2.4 WMA Management Toolbox','Design and consolidate a comprehensive WMA Management Toolbox and publish at least five additional tools guided by sound financial and operational management of WMAs.','todo','high','2026-12-31',9,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af103fb92496','019c630a-c80d-7011-bb25-f119fc2384f8',NULL,'3.2.5 Leadership Training Program pilot','Implement a pilot of the pre-designed WMA Management Leadership Training Program across selected WMAs.','todo','medium','2026-12-31',10,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af104276907d','019c630a-c80e-7131-9c8f-af1040851aa2',NULL,'3.3.1 Package protection docs & tools','Institutionalize and package all existing protection documents, tools, and methodologies for standardized use across WMAs.','todo','high','2026-12-31',11,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af10437ab079','019c630a-c80e-7131-9c8f-af1040851aa2',NULL,'3.3.2 Low-cost protection strategies','Ensure all WMAs adopt and comply with low-cost, effective protection strategies and methodologies.','todo','high','2026-12-31',12,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af104497afb8','019c630a-c80e-7131-9c8f-af1040851aa2',NULL,'3.3.3 Anti-poaching tools monitoring','Conduct regular assessments and monitoring of anti-poaching tools to ensure full functionality and effectiveness.','todo','medium','2026-12-31',13,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af1045752a3d','019c630a-c80e-7131-9c8f-af1040851aa2',NULL,'3.3.4 Anti-poaching improvement checklist','Develop a checklist of recommendation for anti-poaching strategic improvement.','todo','medium','2026-12-31',14,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af104885986c','019c630a-c80e-7131-9c8f-af1046ac0939',NULL,'3.4.1 HEC toolkit innovation','Drive toolkit innovation process by gathering insights through listening, creating designs, testing prototypes, validating scientifically, and scaling successful solutions.','todo','high','2026-12-31',15,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af1049a27103','019c630a-c80e-7131-9c8f-af1046ac0939',NULL,'3.4.2 HEC mitigation beyond WMAs','Explore HEC mitigation strategies beyond WMAs and outside the country.','todo','medium','2026-12-31',16,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af104b1df305','019c630a-c80e-7131-9c8f-af1046ac0939',NULL,'3.4.3 Package HEC methodologies','Institutionalize and packaging available HEC methodologies.','todo','medium','2026-12-31',17,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af104eeedff3','019c630a-c80e-7131-9c8f-af104cb35aab',NULL,'3.5.1 Education & Health replication playbook','Document the Makame Education and Health models into a replication playbook framework while preparing Makame WMA to fully own these programs beyond Honeyguide\'s support.','todo','high','2026-12-31',18,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af1050666f66','019c630a-c80e-7131-9c8f-af104cb35aab',NULL,'3.5.2 Kamitei Education replication','Replicate the Kamitei Education program into Mbomipa, Waga and Ruvuma 5 WMAs, ensuring WMA ownership and financial contributions.','todo','high','2026-12-31',19,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80e-7131-9c8f-af1051633a7b','019c630a-c80e-7131-9c8f-af104cb35aab',NULL,'3.5.3 Agriculture & microcredit pilots','Explore and pilot Agriculture and microcredit initiatives that can be integrated into WMA livelihood portfolios and scaled as community-owned models.','todo','medium','2026-12-31',20,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19dd8162baa','019c630a-c80e-7131-9c8f-af104cb35aab',NULL,'3.5.4 Livelihood programs inventory','Build a detailed, research-backed inventory of at least 10 livelihood-improvement programs suitable for rural WMA communities.','todo','medium','2026-12-31',21,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19dd92a06b6','019c630a-c80e-7131-9c8f-af104cb35aab',NULL,'3.5.5 New financing models (CTFs, etc.)','Co-design at least 2 new financing models (CTFs, HWC insurance, BD credits etc) for WMAs.','todo','medium','2026-12-31',22,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19ddc000163','019c630a-c80f-7295-abc2-c19dda9ef9c4',NULL,'3.6.1 Knowledge repository','Research and development of a repository of tools, knowledge, and information, including videos, PDFs, and Google Docs.','todo','medium','2026-12-31',23,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19ddcc5f9f6','019c630a-c80f-7295-abc2-c19dda9ef9c4',NULL,'3.6.2 Online courses & monitoring','Design online courses and sessions for both individual and group learning, incorporating monitoring mechanisms to track uptake and learning progress.','todo','medium','2026-12-31',24,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19de2618b1e','019c630a-c80f-7295-abc2-c19ddeea6c91',NULL,'4.1.1 M&E tools & systems design','Design, Develop, and Implementation of M&E Tools and Systems.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19de2eb6b92','019c630a-c80f-7295-abc2-c19ddeea6c91',NULL,'4.1.2 Program impacts & evaluation','Program Impacts and Evaluation.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c80f-7295-abc2-c19de3e2ffaa','019c630a-c80f-7295-abc2-c19ddeea6c91',NULL,'4.1.3 M&E capacity building','M&E Capacity Building for WMAs and partners (Training, Mentorship, and Coaching).','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3cc928788','019c630a-c80f-7295-abc2-c19ddeea6c91',NULL,'4.1.4 Quarterly data quality & reports','Ensure accurate, consistent, quality data and reports quarterly.','todo','high','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3cd66a989','019c630a-c80f-7295-abc2-c19ddeea6c91',NULL,'4.1.5 Ecological monitoring & evidence','Ecological Monitoring and Evidence Generation.','todo','medium','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3d1713be1','019c630a-c810-7295-986e-b7a3cd83402a',NULL,'4.2.1 GIS maps & tools for project areas','Develop GIS maps and tools for all project areas to include all potential information for investment and protection.','todo','high','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3d2a5eb47','019c630a-c810-7295-986e-b7a3cd83402a',NULL,'4.2.2 Map making & navigation capacity','Establishing Capacity for Map Making and Navigation to Support Honeyguide Initiatives.','todo','medium','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3d7e5d4d2','019c630a-c810-7295-986e-b7a3d54b2cef',NULL,'5.1.1 Maintain 24/7 standby K9 unit','Maintaining a standby canine unit that is 24/7 ready to respond to all calls in our working areas.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3d890ab51','019c630a-c810-7295-986e-b7a3d54b2cef',NULL,'5.1.2 Strengthen K9 operations & reporting','Strengthening K9 unit operations and reporting.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3d91b825a','019c630a-c810-7295-986e-b7a3d54b2cef',NULL,'5.1.3 HGF-Kuru-Manyara collaboration','Strengthen collaboration between HGF, Kuru and Manyara Board of Trustee.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3dfa74970','019c630a-c810-7295-986e-b7a3da449b51',NULL,'5.2.1 Northern chimps habituation','Continued habituation of the northern chimps sub-group.','todo','high','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3e067eff7','019c630a-c810-7295-986e-b7a3da449b51',NULL,'5.2.2 Southern chimps mapping & monitoring','Start habituating the southern chimp subgroup through mapping and monitoring.','todo','high','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3e191575c','019c630a-c810-7295-986e-b7a3da449b51',NULL,'5.2.3 Chimp tourism & tracker training','Strengthen chimpanzee tourism through habituation and tracker training.','todo','medium','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3e24ebb43','019c630a-c810-7295-986e-b7a3da449b51',NULL,'5.2.4 Marketing with TANAPA','Improve marketing and advertising of the Chimp product with TANAPA.','todo','medium','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c810-7295-986e-b7a3e383b407','019c630a-c810-7295-986e-b7a3da449b51',NULL,'5.2.5 New 4-year action plan','Develop a new 4-year action plan that includes a diversified fundraising strategy.','todo','high','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17c9f7b20bc0','019c630a-c811-71eb-932e-17c9f6716c79',NULL,'6.1.1 National & local media awareness','National and local media and general public awareness.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17c9f9ad35d2','019c630a-c811-71eb-932e-17c9f835c1a7',NULL,'6.2.1 Narrative benchmark assessment','Stakeholder narrative benchmark assessment.','todo','medium','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17c9fbd98e16','019c630a-c811-71eb-932e-17c9faa359d9',NULL,'6.3.1 Policy network & facilitation','Policy network and facilitation.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17c9fcc37421','019c630a-c811-71eb-932e-17c9fc154259',NULL,'6.4.1 Regional CLC narrative','Regional narrative on CLC.','todo','low','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17c9fe5da0f7','019c630a-c811-71eb-932e-17c9fcdfd5cd',NULL,'6.5.1 Advocacy & media training','Training and equipment for advocacy and media teams.','todo','medium','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca03f149da','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.1 Finance & procurement manual awareness','Awareness of finance and procurement manual procedures and practices.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca041caacd','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.2 Internal audit & compliance','Strengthen internal audit and compliance mechanisms and follow up on Audit recommendations.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca050ed5b6','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.3 Donor-specific dashboards & automation','Enhance financial reporting by introducing donor-specific dashboards and automating report generation.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca0569e8dd','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.4 Long-term financial planning','Strategic long-term financial planning.','todo','high','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca0627458a','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.5 Budget & cashflow monitoring','Annual Budget and Cashflow development and monitoring.','todo','high','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c811-71eb-932e-17ca071ca037','019c630a-c811-71eb-932e-17ca00134fc7',NULL,'7.1.6 e-Asset & e-Procurement rollout','Roll out e-Asset management (Asset lists, regular inventory, valuation, security, insurance) and improve e-procurement system within the finance system.','todo','medium','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f46e253f3','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.1 Workforce planning & job evaluation','Workforce Planning, Compensation and Benefits – Develop job profiles, competency models, and conduct a comprehensive job evaluation to establish clear job grades.','todo','high','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f479fbc1c','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.2 Performance management improvement','Strengthen the performance management system and support employee development through training, mentorship, and cross-department exposure.','todo','high','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f47b78516','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.3 Staff training & development','Identify organization development priority and ensure implementation of staff development activities and measure its impact.','todo','medium','2026-12-31',8,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f489e5b33','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.4 HRIS integration & consolidation','Automate all HR processes and consolidate different HR systems to one system.','todo','medium','2026-12-31',9,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f49546bc4','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.5 Culture & engagement improvement','Launch engagement programs with surveys, accountability initiatives, recognition schemes, and a strong Employer Value Proposition.','todo','medium','2026-12-31',10,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f4a26fc2b','019c630a-c811-71eb-932e-17ca073ee40d',NULL,'7.2.6 HR compliance & data protection','Implement a personal data protection compliance program with policies, training, registers, and clear oversight roles.','todo','medium','2026-12-31',11,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f4d69a2a4','019c630a-c812-7391-a168-119f4a8cff16',NULL,'7.3.1 App development (Leave, Payroll, etc.)','App Development – Leave, Payroll, Performance, Assets, M&E, HGF Website, Honeyguide Learning.','todo','high','2026-12-31',12,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f4dddba09','019c630a-c812-7391-a168-119f4a8cff16',NULL,'7.3.2 Data protection & compliance','Establish strong data protection measures aligned with national and international standards.','todo','high','2026-12-31',13,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f4dfcfc82','019c630a-c812-7391-a168-119f4a8cff16',NULL,'7.3.3 Tech support & maintenance','Deliver regular IT support for internet, hardware, software, and maintain in-house web/mobile applications. Provide IT equipment and upgrade mobile internet infrastructure.','todo','medium','2026-12-31',14,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f4e02a778','019c630a-c812-7391-a168-119f4a8cff16',NULL,'7.3.4 Collaboration & knowledge sharing','Create a shared digital workspace for WMA resources and support the Honeyguide Learning Initiative with platforms, tools, and knowledge-sharing systems.','todo','medium','2026-12-31',15,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f50a74547','019c630a-c812-7391-a168-119f4ee0404f',NULL,'7.4.1 Asset management system','Maintain and optimize asset management system for efficiency, accountability, and sustainability.','todo','medium','2026-12-31',16,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f51500b2c','019c630a-c812-7391-a168-119f4ee0404f',NULL,'7.4.2 Risk management framework','Strengthen organizational risk management framework and implement monitoring processes for financial, cyber, and political risks.','todo','medium','2026-12-31',17,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f553c7ad0','019c630a-c812-7391-a168-119f520535b3',NULL,'7.5.1 Fleet management & safety','Enhancing scheduled Workshop and vehicles by implementing a Fleet Management System, standardize Workshop Processes and Enhance Safety & Compliance Culture.','todo','high','2026-12-31',18,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f563b03fb','019c630a-c812-7391-a168-119f520535b3',NULL,'7.5.2 Zero lost-time injuries target','Achieve Zero Lost-Time Injuries in the workshop and for fleet operations.','todo','high','2026-12-31',19,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f56620553','019c630a-c812-7391-a168-119f520535b3',NULL,'7.5.3 Spare parts & lifecycle analysis','Analyze and consolidate spare part suppliers for bulk discounts and conduct a lifecycle cost analysis for each vehicle.','todo','medium','2026-12-31',20,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f56aa441a','019c630a-c812-7391-a168-119f520535b3',NULL,'7.5.4 Fuel & maintenance metrics','Monitor and report on key metrics: Fuel Use, Maintenance Cost per Kilometer.','todo','medium','2026-12-31',21,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c812-7391-a168-119f573dc9b5','019c630a-c812-7391-a168-119f520535b3',NULL,'7.5.5 Quarterly workshop review','Perform quarterly internal review on workshop practices.','todo','low','2026-12-31',22,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de55d022686','019c630a-c812-7391-a168-119f58d94e13',NULL,'8.1.1 Top ten donor engagement','Strategically engage with our current top ten donors to encourage them to increase their contribution.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de55da3e293','019c630a-c812-7391-a168-119f58d94e13',NULL,'8.1.2 Broaden donor base','Broaden current donor base by actively pursuing potential donors that have an interest in Honeyguide priority areas.','todo','high','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de55e5b9d98','019c630a-c812-7391-a168-119f58d94e13',NULL,'8.1.3 Funding opportunities & proposals','Monitor and respond to active funding opportunities and calls for proposals for financial assistance.','todo','high','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de55f54d25e','019c630a-c812-7391-a168-119f58d94e13',NULL,'8.1.4 Joint funding tools & agreements','Develop tools and agreements with key partners to streamline joint funding applications.','todo','medium','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56028cf36','019c630a-c812-7391-a168-119f58d94e13',NULL,'8.1.5 Special programs funding partners','Strategically search for funding partners that have an interest in any of the special programs.','todo','medium','2026-12-31',4,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de561a907da','019c630a-c813-73d0-8ed3-9de56080ae92',NULL,'8.2.1 Build comms tools capacity','Build capacity with new tools for comms.','todo','medium','2026-12-31',5,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56200a48d','019c630a-c813-73d0-8ed3-9de56080ae92',NULL,'8.2.2 Comms team data training','Training comms team and coaching on use and access of the data.','todo','medium','2026-12-31',6,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de5620b4649','019c630a-c813-73d0-8ed3-9de56080ae92',NULL,'8.2.3 AI for communications','Design, test, and develop knowledge resource of AI for communications.','todo','medium','2026-12-31',7,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de562fd62a7','019c630a-c813-73d0-8ed3-9de56080ae92',NULL,'8.2.4 Communications App management','Manage and maintain the Honeyguide Communications App, training and coach Honeyguide team to participate and update activities in the app.','todo','medium','2026-12-31',8,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de566bcba22','019c630a-c813-73d0-8ed3-9de5631187d0',NULL,'8.3.1 Thematic communication campaigns','Package and produce communication campaigns in the form of thematic areas, where each theme is supported by a data sheet and editorial (for blogs, newsletters, social media and webinars).','todo','high','2026-12-31',9,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de566ec3174','019c630a-c813-73d0-8ed3-9de5631187d0',NULL,'8.3.2 One-way communications (blogs, etc.)','Produce regular one-way communications (blogs, publications, newsletters, videos) and monitor views.','todo','medium','2026-12-31',10,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de567dfc8cd','019c630a-c813-73d0-8ed3-9de5631187d0',NULL,'8.3.3 Two-way communications (webinars, etc.)','Produce material to support two-way communications (webinar, 1-1 meetings, presentations).','todo','medium','2026-12-31',11,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de568d137cc','019c630a-c813-73d0-8ed3-9de5631187d0',NULL,'8.3.4 Website updates','Ongoing updates in the website with current information (introduction Honeyguide Innovation) and organizational development.','todo','medium','2026-12-31',12,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de568fddcf5','019c630a-c813-73d0-8ed3-9de5631187d0',NULL,'8.3.5 2026 Communications plan','Create a 2026 Communications plan.','todo','high','2026-12-31',13,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56d7247b1','019c630a-c813-73d0-8ed3-9de569fc979e',NULL,'8.4.1 Swahili quarterly newsletter','Production of Newsletter (every quarter) in Swahili with project updates and organization news.','todo','medium','2026-12-31',14,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56de62d60','019c630a-c813-73d0-8ed3-9de569fc979e',NULL,'8.4.2 Swahili social media posts','Regular social media posts in Swahili.','todo','medium','2026-12-31',15,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56e7943fe','019c630a-c813-73d0-8ed3-9de569fc979e',NULL,'8.4.3 Honeyguide awareness posters','Design and develop Honeyguide awareness posters (posters to show Honeyguide work and approach) and publications in Swahili.','todo','low','2026-12-31',16,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c813-73d0-8ed3-9de56ed6ce78','019c630a-c813-73d0-8ed3-9de569fc979e',NULL,'8.4.4 Swahili website','Design and develop Honeyguide Swahili website and publish.','todo','medium','2026-12-31',17,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c814-7066-a341-03bfbaf5e427','019c630a-c813-73d0-8ed3-9de57059f7e8',NULL,'9.1.1 Recruit diverse board members','Recruit additional board members that come from diverse backgrounds and support our board development plan.','todo','high','2026-12-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c814-7066-a341-03bfbb7d924c','019c630a-c813-73d0-8ed3-9de57059f7e8',NULL,'9.1.2 Board training & onboarding','Provide the board with training materials and a training and onboarding process to build the capacity of the board members to understand their roles.','todo','medium','2026-12-31',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c814-7066-a341-03bfbbb5e336','019c630a-c813-73d0-8ed3-9de57059f7e8',NULL,'9.1.3 Board policies & procedures','Develop board guiding policies, procedures and systems that continue to aid the board\'s capability to perform their roles.','todo','medium','2026-12-31',2,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c814-7066-a341-03bfbbdaeb8a','019c630a-c813-73d0-8ed3-9de57059f7e8',NULL,'9.1.4 Board meetings & AGM management','Plan and manage all documentation and procedures for board meetings including the committees meetings, AGM and annual retreat.','todo','high','2026-12-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL),
('019c630a-c814-7066-a341-03bfc420a305','019c630a-c814-7066-a341-03bfc38972c2',NULL,'1 Planning Phase','Initial planning and requirements gathering','completed','high','2026-01-31',0,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-06',NULL),
('019c630a-c814-7066-a341-03bfc51a1b03','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc420a305','1.1 Requirements Analysis','Gather and document requirements','completed','high','2026-01-17',1,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-06',NULL),
('019c630a-c814-7066-a341-03bfc595979b','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc420a305','1.2 Create Wireframes','Design wireframes for all pages','completed','medium','2026-01-24',2,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-13',NULL),
('019c630a-c814-7066-a341-03bfc5f838ae','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc420a305','1.3 Technical Specification','Write technical specs','completed','high','2026-01-31',3,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-20',NULL),
('019c630a-c814-7066-a341-03bfc7784e43','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc51a1b03','1.1.1 Stakeholder Interviews','Interview key stakeholders','completed','high','2026-01-10',4,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-06',NULL),
('019c630a-c814-7066-a341-03bfc90e00da','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc51a1b03','1.1.2 Document Current System','Document existing system','completed','medium','2026-01-14',5,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-08',NULL),
('019c630a-c814-7066-a341-03bfca64a8bc','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc51a1b03','1.1.3 Define User Stories','Create user stories','completed','high','2026-01-17',6,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-13',NULL),
('019c630a-c814-7066-a341-03bfcb82261b','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc595979b','1.2.1 Homepage Wireframe','Design homepage layout','completed','high','2026-01-17',7,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-13',NULL),
('019c630a-c815-7053-b34c-75537f677e61','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc595979b','1.2.2 Dashboard Wireframe','Design dashboard layout','completed','high','2026-01-20',8,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-15',NULL),
('019c630a-c815-7053-b34c-755380924d6f','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c814-7066-a341-03bfc595979b','1.2.3 Mobile Wireframes','Design mobile responsive layouts','completed','medium','2026-01-24',9,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-01-20',NULL),
('019c630a-c815-7053-b34c-755381ad4708','019c630a-c814-7066-a341-03bfc38972c2',NULL,'2 Design Phase','Visual design and prototyping','in_progress','high','2026-02-28',10,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-01',NULL),
('019c630a-c815-7053-b34c-75538281e2b3','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755381ad4708','2.1 Visual Design','Create visual designs','in_progress','high','2026-02-14',11,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-01',NULL),
('019c630a-c815-7053-b34c-755383a61876','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755381ad4708','2.2 Interactive Prototype','Build clickable prototype','todo','medium','2026-02-21',12,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-10',NULL),
('019c630a-c815-7053-b34c-755384c48428','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755381ad4708','2.3 Design Review','Review and approve designs','todo','high','2026-02-28',13,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-22',NULL),
('019c630a-c815-7053-b34c-7553864f1a5a','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538281e2b3','2.1.1 Color Palette','Define color scheme','completed','medium','2026-02-03',14,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-01',NULL),
('019c630a-c815-7053-b34c-75538803648d','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538281e2b3','2.1.2 Typography','Select fonts and type scale','completed','medium','2026-02-05',15,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-03',NULL),
('019c630a-c815-7053-b34c-755388c5d259','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538281e2b3','2.1.3 Icon Design','Design custom icons','in_progress','low','2026-02-10',16,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-05',NULL),
('019c630a-c815-7053-b34c-755389e054c9','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538281e2b3','2.1.4 Component Library','Build UI component library','in_progress','high','2026-02-14',17,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-08',NULL),
('019c630a-c815-7053-b34c-75538b54dea6','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755388c5d259','2.1.3.1 Navigation Icons','Design nav icons','completed','medium','2026-02-07',18,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-05',NULL),
('019c630a-c815-7053-b34c-75538c5dc138','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755388c5d259','2.1.3.2 Action Icons','Design action icons','in_progress','medium','2026-02-09',19,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-07',NULL),
('019c630a-c815-7053-b34c-75538c8aa601','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-755388c5d259','2.1.3.3 Status Icons','Design status indicators','todo','low','2026-02-10',20,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-02-09',NULL),
('019c630a-c815-7053-b34c-75538d08ff56','019c630a-c814-7066-a341-03bfc38972c2',NULL,'3 Development Phase','Frontend and backend development','todo','high','2026-05-31',21,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-01',NULL),
('019c630a-c815-7053-b34c-75538dc41760','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538d08ff56','3.1 Frontend Development','Build frontend components','todo','high','2026-04-15',22,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-01',NULL),
('019c630a-c815-7053-b34c-75538f654ddb','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538d08ff56','3.2 Backend Development','Build API and services','todo','high','2026-05-15',23,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-15',NULL),
('019c630a-c815-7053-b34c-755390527bd0','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538d08ff56','3.3 Integration Testing','Test frontend/backend integration','todo','high','2026-05-31',24,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-05-01',NULL),
('019c630a-c815-7053-b34c-755390fe3ac3','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538dc41760','3.1.1 Setup Build System','Configure webpack/vite','todo','high','2026-03-05',25,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-01',NULL),
('019c630a-c815-7053-b34c-755391ac6f10','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538dc41760','3.1.2 Implement Components','Build reusable components','todo','high','2026-03-25',26,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-05',NULL),
('019c630a-c816-7187-a273-ce914b1e6eda','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538dc41760','3.1.3 Page Templates','Build page templates','todo','medium','2026-04-10',27,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-20',NULL),
('019c630a-c816-7187-a273-ce914b8bf2c4','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538dc41760','3.1.4 Responsive Testing','Test on all devices','todo','medium','2026-04-15',28,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-04-08',NULL),
('019c630a-c816-7187-a273-ce914ccb49ee','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538f654ddb','3.2.1 Database Schema','Design and implement DB','todo','high','2026-03-25',29,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-15',NULL),
('019c630a-c816-7187-a273-ce914de50d01','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538f654ddb','3.2.2 API Endpoints','Build REST API','todo','high','2026-04-20',30,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-03-22',NULL),
('019c630a-c816-7187-a273-ce914ea01108','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538f654ddb','3.2.3 Authentication','Implement auth system','todo','high','2026-05-01',31,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-04-15',NULL),
('019c630a-c816-7187-a273-ce914ff44b85','019c630a-c814-7066-a341-03bfc38972c2','019c630a-c815-7053-b34c-75538f654ddb','3.2.4 Performance Optimization','Optimize queries and caching','todo','medium','2026-05-15',32,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-05-01',NULL),
('019c630a-c816-7187-a273-ce91506827ee','019c630a-c814-7066-a341-03bfc38972c2',NULL,'4 Launch Phase','Deployment and go-live','todo','high','2026-06-30',33,'2026-02-15 20:42:56','2026-02-15 20:42:56','2026-06-01',NULL);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_assignee`
--

DROP TABLE IF EXISTS `task_assignee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_assignee` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `task_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `user_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `assigned_by_id` char(36) DEFAULT NULL COMMENT '(DC2Type:uuid)',
  `assigned_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_user_unique` (`task_id`,`user_id`),
  KEY `IDX_3C5D16408DB60186` (`task_id`),
  KEY `IDX_3C5D1640A76ED395` (`user_id`),
  KEY `IDX_3C5D16406E6F1246` (`assigned_by_id`),
  CONSTRAINT `FK_3C5D16406E6F1246` FOREIGN KEY (`assigned_by_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_3C5D16408DB60186` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_3C5D1640A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_assignee`
--

LOCK TABLES `task_assignee` WRITE;
/*!40000 ALTER TABLE `task_assignee` DISABLE KEYS */;
INSERT INTO `task_assignee` VALUES
('019c630a-c80a-702b-ba6c-cd3993ef0034','019c630a-c80a-702b-ba6c-cd3993aae401','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd3994be02db','019c630a-c80a-702b-ba6c-cd399426cc0b','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd3995efd81d','019c630a-c80a-702b-ba6c-cd3995a2addf','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd3997b683f3','019c630a-c80a-702b-ba6c-cd3996ba7fab','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd3999779d66','019c630a-c80a-702b-ba6c-cd399882ae49','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd399d90aa2e','019c630a-c80a-702b-ba6c-cd399d5b50d1','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd399e5bf5da','019c630a-c80a-702b-ba6c-cd399df35389','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd399f47bf99','019c630a-c80a-702b-ba6c-cd399e7d8a82','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a10e2380','019c630a-c80a-702b-ba6c-cd39a0386950','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a1e19c77','019c630a-c80a-702b-ba6c-cd39a11a4da8','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a770da63','019c630a-c80a-702b-ba6c-cd39a6c0bf15','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a854e247','019c630a-c80a-702b-ba6c-cd39a7b43846','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80a-702b-ba6c-cd39a8900e57','019c630a-c80a-702b-ba6c-cd39a869107b','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a9029fe760','019c630a-c80b-719c-b519-a3a901d5007f','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a903980f68','019c630a-c80b-719c-b519-a3a902aafe9c','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a90796e89a','019c630a-c80b-719c-b519-a3a9076bd2aa','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a908aace49','019c630a-c80b-719c-b519-a3a90832dd08','019c630a-b257-7268-aac4-4e21d730bcef','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a90deba1cb','019c630a-c80b-719c-b519-a3a90d0afad4','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a91251c3f8','019c630a-c80b-719c-b519-a3a91209a3e3','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a9134a3743','019c630a-c80b-719c-b519-a3a913241fe1','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80b-719c-b519-a3a914374438','019c630a-c80b-719c-b519-a3a913ec7efa','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d451f1a76a','019c630a-c80b-719c-b519-a3a9186f4f3b','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d4529cce59','019c630a-c80c-7072-925c-47d4522ed07b','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d4534e331b','019c630a-c80c-7072-925c-47d452c995b4','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d45840e2b3','019c630a-c80c-7072-925c-47d4576fde59','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d459b246cd','019c630a-c80c-7072-925c-47d458b73eb9','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d45a020a87','019c630a-c80c-7072-925c-47d459cbdfda','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d45e9278ad','019c630a-c80c-7072-925c-47d45e8503a7','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d45f450a3f','019c630a-c80c-7072-925c-47d45f3d4451','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80c-7072-925c-47d460a72820','019c630a-c80c-7072-925c-47d45fab6a02','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119ee535800','019c630a-c80d-7011-bb25-f119eddb6969','019c630a-c614-70ea-a11b-5c4247321a54','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119ef37b30e','019c630a-c80d-7011-bb25-f119eedec85b','019c630a-c614-70ea-a11b-5c4247321a54','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119f6f76e2f','019c630a-c80d-7011-bb25-f119f644ecda','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119f8349a0b','019c630a-c80d-7011-bb25-f119f75232ac','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119f9cf6ea8','019c630a-c80d-7011-bb25-f119f92caa9b','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119f9f5f893','019c630a-c80d-7011-bb25-f119f9d6719e','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119fb37d929','019c630a-c80d-7011-bb25-f119fa58f7d1','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119fc196cda','019c630a-c80d-7011-bb25-f119fb4c78f5','019c630a-b64b-719b-8407-dd421c0d9fa0','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80d-7011-bb25-f119fec77506','019c630a-c80d-7011-bb25-f119fea7c364','019c630a-b844-73a1-bbe9-987ab3f2c539','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af103d49c7c4','019c630a-c80d-7011-bb25-f119ff2e8392','019c630a-b844-73a1-bbe9-987ab3f2c539','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af103ef410a3','019c630a-c80e-7131-9c8f-af103e37e4a4','019c630a-b844-73a1-bbe9-987ab3f2c539','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af103f719075','019c630a-c80e-7131-9c8f-af103f02844f','019c630a-b844-73a1-bbe9-987ab3f2c539','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af104013253c','019c630a-c80e-7131-9c8f-af103fb92496','019c630a-b844-73a1-bbe9-987ab3f2c539','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1042e683cb','019c630a-c80e-7131-9c8f-af104276907d','019c630a-ba72-7038-a67b-a4c9b9097c41','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af10446f8f93','019c630a-c80e-7131-9c8f-af10437ab079','019c630a-ba72-7038-a67b-a4c9b9097c41','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af10449d6d74','019c630a-c80e-7131-9c8f-af104497afb8','019c630a-ba72-7038-a67b-a4c9b9097c41','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1045e0b128','019c630a-c80e-7131-9c8f-af1045752a3d','019c630a-ba72-7038-a67b-a4c9b9097c41','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1049542f94','019c630a-c80e-7131-9c8f-af104885986c','019c630a-bc5f-7032-8698-b1c1a8efcdf9','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af104a782669','019c630a-c80e-7131-9c8f-af1049a27103','019c630a-bc5f-7032-8698-b1c1a8efcdf9','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af104bf94eb8','019c630a-c80e-7131-9c8f-af104b1df305','019c630a-bc5f-7032-8698-b1c1a8efcdf9','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af104f7ab01e','019c630a-c80e-7131-9c8f-af104eeedff3','019c630a-be4c-7084-a19e-3f6cb3c11d10','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80e-7131-9c8f-af1050ca485b','019c630a-c80e-7131-9c8f-af1050666f66','019c630a-be4c-7084-a19e-3f6cb3c11d10','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19dd7c78a69','019c630a-c80e-7131-9c8f-af1051633a7b','019c630a-be4c-7084-a19e-3f6cb3c11d10','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19dd82c8718','019c630a-c80f-7295-abc2-c19dd8162baa','019c630a-be4c-7084-a19e-3f6cb3c11d10','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19dd9db7dec','019c630a-c80f-7295-abc2-c19dd92a06b6','019c630a-be4c-7084-a19e-3f6cb3c11d10','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19de2b86228','019c630a-c80f-7295-abc2-c19de2618b1e','019c630a-c039-70a0-b3ef-8ba7a5f9946b','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c80f-7295-abc2-c19de3985208','019c630a-c80f-7295-abc2-c19de2eb6b92','019c630a-c039-70a0-b3ef-8ba7a5f9946b','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3cbfc9ab7','019c630a-c80f-7295-abc2-c19de3e2ffaa','019c630a-c039-70a0-b3ef-8ba7a5f9946b','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3cd1b54b3','019c630a-c810-7295-986e-b7a3cc928788','019c630a-c039-70a0-b3ef-8ba7a5f9946b','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3cd82bc6b','019c630a-c810-7295-986e-b7a3cd66a989','019c630a-c039-70a0-b3ef-8ba7a5f9946b','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d1caef5f','019c630a-c810-7295-986e-b7a3d1713be1','019c630a-c22c-73dc-91d7-3dcb60740f03','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d2bd1b09','019c630a-c810-7295-986e-b7a3d2a5eb47','019c630a-c22c-73dc-91d7-3dcb60740f03','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d86a83b7','019c630a-c810-7295-986e-b7a3d7e5d4d2','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d8bc7e8f','019c630a-c810-7295-986e-b7a3d890ab51','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3d947f773','019c630a-c810-7295-986e-b7a3d91b825a','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3e054c879','019c630a-c810-7295-986e-b7a3dfa74970','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3e10cafbd','019c630a-c810-7295-986e-b7a3e067eff7','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3e1dbdc1d','019c630a-c810-7295-986e-b7a3e191575c','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c810-7295-986e-b7a3e31f44b5','019c630a-c810-7295-986e-b7a3e24ebb43','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c811-71eb-932e-17c9f4772e09','019c630a-c810-7295-986e-b7a3e383b407','019c630a-c423-71ad-802f-3381781a4193','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc42996cd','019c630a-c814-7066-a341-03bfc420a305','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc529feab','019c630a-c814-7066-a341-03bfc51a1b03','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc5b13204','019c630a-c814-7066-a341-03bfc595979b','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc6dd1969','019c630a-c814-7066-a341-03bfc5f838ae','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc84954c7','019c630a-c814-7066-a341-03bfc7784e43','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfc972267f','019c630a-c814-7066-a341-03bfc90e00da','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfcb182ba5','019c630a-c814-7066-a341-03bfca64a8bc','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c814-7066-a341-03bfcc166b18','019c630a-c814-7066-a341-03bfcb82261b','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755380437cc3','019c630a-c815-7053-b34c-75537f677e61','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-7553817c3139','019c630a-c815-7053-b34c-755380924d6f','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-7553825a2022','019c630a-c815-7053-b34c-755381ad4708','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538312fcfa','019c630a-c815-7053-b34c-75538281e2b3','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755383e7443c','019c630a-c815-7053-b34c-755383a61876','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755385b2f922','019c630a-c815-7053-b34c-755384c48428','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-7553872f2e93','019c630a-c815-7053-b34c-7553864f1a5a','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755388b2420d','019c630a-c815-7053-b34c-75538803648d','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755389931b8d','019c630a-c815-7053-b34c-755388c5d259','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538aca0acb','019c630a-c815-7053-b34c-755389e054c9','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538c204f3c','019c630a-c815-7053-b34c-75538b54dea6','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538c7641d5','019c630a-c815-7053-b34c-75538c5dc138','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538c9dec13','019c630a-c815-7053-b34c-75538c8aa601','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538d8006ff','019c630a-c815-7053-b34c-75538d08ff56','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538e8df910','019c630a-c815-7053-b34c-75538dc41760','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-75538f65fc47','019c630a-c815-7053-b34c-75538f654ddb','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-7553905f0ade','019c630a-c815-7053-b34c-755390527bd0','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c815-7053-b34c-755391694834','019c630a-c815-7053-b34c-755390fe3ac3','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914b11a200','019c630a-c815-7053-b34c-755391ac6f10','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914b56dfe4','019c630a-c816-7187-a273-ce914b1e6eda','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914c2354fa','019c630a-c816-7187-a273-ce914b8bf2c4','019c630a-b453-7069-9342-8fe43b87ae79','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914d79d2c1','019c630a-c816-7187-a273-ce914ccb49ee','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914e87c6b4','019c630a-c816-7187-a273-ce914de50d01','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce914f90ad7b','019c630a-c816-7187-a273-ce914ea01108','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce9150244fcb','019c630a-c816-7187-a273-ce914ff44b85','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56'),
('019c630a-c816-7187-a273-ce9150814c08','019c630a-c816-7187-a273-ce91506827ee','019c630a-b05c-72c9-9b73-eb6bfce09b51','019c630a-b05c-72c9-9b73-eb6bfce09b51','2026-02-15 20:42:56');
/*!40000 ALTER TABLE `task_assignee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_checklist`
--

DROP TABLE IF EXISTS `task_checklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_checklist` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `task_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `title` varchar(500) NOT NULL,
  `is_completed` tinyint(1) NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_2343A07E8DB60186` (`task_id`),
  CONSTRAINT `FK_TASK_CHECKLIST_TASK` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_checklist`
--

LOCK TABLES `task_checklist` WRITE;
/*!40000 ALTER TABLE `task_checklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_checklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_status_type`
--

DROP TABLE IF EXISTS `task_status_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_status_type` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `parent_type` varchar(20) NOT NULL,
  `color` varchar(7) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `sort_order` int(11) NOT NULL,
  `is_default` tinyint(1) NOT NULL,
  `is_system` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_TASK_STATUS_SLUG` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_status_type`
--

LOCK TABLES `task_status_type` WRITE;
/*!40000 ALTER TABLE `task_status_type` DISABLE KEYS */;
INSERT INTO `task_status_type` VALUES
('019c630a-b055-7352-a595-9673ad23f685','To Do','todo','open','#6B7280','circle',NULL,0,1,1,'2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b055-7352-a595-9673adedcf7a','In Progress','in_progress','open','#3B82F6','clock',NULL,1,0,1,'2026-02-15 20:42:50','2026-02-15 20:42:50'),
('019c630a-b055-7352-a595-9673ae36fadb','Completed','completed','closed','#10B981','check-circle',NULL,2,0,1,'2026-02-15 20:42:50','2026-02-15 20:42:50');
/*!40000 ALTER TABLE `task_status_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_tag`
--

DROP TABLE IF EXISTS `task_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_tag` (
  `task_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `tag_id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  PRIMARY KEY (`task_id`,`tag_id`),
  KEY `IDX_6C0B4F048DB60186` (`task_id`),
  KEY `IDX_6C0B4F04BAD26311` (`tag_id`),
  CONSTRAINT `FK_TASK_TAG_TAG` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_TASK_TAG_TASK` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_tag`
--

LOCK TABLES `task_tag` WRITE;
/*!40000 ALTER TABLE `task_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:uuid)',
  `email` varchar(180) NOT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`roles`)),
  `password` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `updated_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `google_id` varchar(255) DEFAULT NULL,
  `portal_role_id` char(36) DEFAULT NULL COMMENT '(DC2Type:uuid)',
  `avatar` varchar(255) DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `hidden_recent_project_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`hidden_recent_project_ids`)),
  `ui_theme` varchar(50) NOT NULL DEFAULT 'gradient',
  `favourite_project_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`favourite_project_ids`)),
  `recent_project_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`recent_project_ids`)),
  `notification_preferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '(DC2Type:json)' CHECK (json_valid(`notification_preferences`)),
  `hidden_project_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`hidden_project_ids`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  KEY `IDX_8D93D649D7C6FAB5` (`portal_role_id`),
  CONSTRAINT `FK_8D93D649D7C6FAB5` FOREIGN KEY (`portal_role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
('019c630a-b05c-72c9-9b73-eb6bfce09b51','ceo@honeyguide.org','[\"ROLE_ADMIN\"]','$2y$13$Mggfi4B/HrS8HKNRFeSUVOnBpx.nQrXC.JEYxJsNykweIhDfT9Zx2','System','Admin',1,'2026-02-15 20:42:51','2026-02-15 20:42:51',NULL,'019c630a-b033-7165-b5d5-ba106f0a75c6',NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-b257-7268-aac4-4e21d730bcef','sylvester@honeyguide.org','[]','$2y$13$gJmk2Nmv227HBEvYgGHaq.1fOWfgJsdS.mu2UQkDb5of4Bj8Eko0S','Sylvester','Mselle',1,'2026-02-15 20:42:51','2026-02-15 20:42:51',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-b453-7069-9342-8fe43b87ae79','max@honeyguide.org','[]','$2y$13$jDwx/zMJ6Ge2CD2my6Sf6.gYfhdV9htQHeRWyjaGxAf6GRsirBPJO','Max','Msack',1,'2026-02-15 20:42:52','2026-02-15 20:42:52',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-b64b-719b-8407-dd421c0d9fa0','fatma@honeyguide.org','[]','$2y$13$8gV3EfDIwWYnUEyCeewt8.N8LoWEJ813wx42kEIvGpCaUdGmiJsWW','Fatma','Kitine',1,'2026-02-15 20:42:52','2026-02-15 20:42:52',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-b844-73a1-bbe9-987ab3f2c539','namnyaki@honeyguide.org','[]','$2y$13$6jwn.p.khdn6Rj3TryQSjOQHd9kD9gPv0hiJ15wd/OTQXLK/onrk6','Namnyaki','Mattasia',1,'2026-02-15 20:42:53','2026-02-15 20:42:53',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-ba72-7038-a67b-a4c9b9097c41','kateto@honeyguide.org','[]','$2y$13$C9poGGoJrEFDGuk519PhS.0vTmq7fmxeG4kyMJIkkw.F/4tYLw7zK','Kateto','Ole Kashe',1,'2026-02-15 20:42:53','2026-02-15 20:42:53',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-bc5f-7032-8698-b1c1a8efcdf9','lemuta@honeyguide.org','[]','$2y$13$/swL4Aml9FLoZi/jMKdWaOHYje/HrejVPFNZQabxjQrzyWQhMUfV.','Lemuta','Mengoru',1,'2026-02-15 20:42:54','2026-02-15 20:42:54',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-be4c-7084-a19e-3f6cb3c11d10','glad@honeyguide.org','[]','$2y$13$Ttj0JJhJVfY1K8D8IZABFeGfZWohj3Vkct94L4UJVYwrps7WPZsbG','Glad','Kampa',1,'2026-02-15 20:42:54','2026-02-15 20:42:54',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-c039-70a0-b3ef-8ba7a5f9946b','daudi@honeyguide.org','[]','$2y$13$kZNBb3fi6NsacepcTtILxOEcwSP4yDMa4GwfpGj9GDphcovFcl/ry','Daudi','Mollel',1,'2026-02-15 20:42:55','2026-02-15 20:42:55',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-c22c-73dc-91d7-3dcb60740f03','michael@honeyguide.org','[]','$2y$13$D5M6uRr02PLCCqLcuFWnP.bup1n4sfxQLLcwekswtk1TF7HVB5vsK','Michael','Kambosha',1,'2026-02-15 20:42:55','2026-02-15 20:42:55',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-c423-71ad-802f-3381781a4193','meleck@honeyguide.org','[]','$2y$13$l18T7aFtMr/631eCeVFsquQxNuesU1TEwbj1iNt.fAOZSG48z6gnO','Meleck','Laizer',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]'),
('019c630a-c614-70ea-a11b-5c4247321a54','sam@honeyguide.org','[]','$2y$13$QEHdli6NIKTWv9ZiNaW7Wu65Ug.OiW.HEni7vSviny/BVey7ShtqC','Sam','Shaba',1,'2026-02-15 20:42:56','2026-02-15 20:42:56',NULL,NULL,NULL,NULL,NULL,'[]','gradient','[]','[]','[]','[]');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-15 23:43:07
