-- MySQL dump 10.13  Distrib 9.0.1, for macos14.4 (arm64)
--
-- Host: localhost    Database: Mortgage
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `Mortgage`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `Mortgage` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `Mortgage`;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `account_ID` int NOT NULL AUTO_INCREMENT,
  `customer_ID` int NOT NULL,
  `ccy` varchar(3) NOT NULL,
  `open_date` date NOT NULL,
  `status` enum('Active','Inactive','Closed') NOT NULL,
  PRIMARY KEY (`account_ID`),
  KEY `customer_ID` (`customer_ID`),
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,1,'USD','2020-01-15','Active'),(2,1,'EUR','2021-06-20','Active'),(3,2,'GBP','2019-03-10','Closed'),(4,2,'CAD','2022-08-05','Active'),(5,3,'AUD','2021-05-12','Inactive'),(6,3,'JPY','2023-01-01','Active'),(7,4,'NZD','2020-07-23','Active'),(8,5,'USD','2018-11-30','Closed'),(9,5,'USD','2022-02-14','Active'),(10,6,'CHF','2023-03-15','Active'),(11,7,'SGD','2017-09-05','Inactive'),(12,8,'AUD','2021-12-01','Active'),(13,9,'USD','2020-05-19','Active'),(14,10,'EUR','2019-10-20','Closed'),(15,11,'GBP','2022-06-15','Active'),(16,12,'CAD','2023-02-28','Active'),(17,13,'JPY','2021-07-22','Active'),(18,14,'NZD','2020-09-18','Closed'),(19,15,'USD','2019-11-11','Active');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collateral`
--

DROP TABLE IF EXISTS `collateral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collateral` (
  `collateral_ID` int NOT NULL AUTO_INCREMENT,
  `customer_ID` int NOT NULL,
  `type_ID` int NOT NULL,
  `property_type` enum('Residential','Commercial','Industrial','Agricultural') NOT NULL,
  `property_usage` varchar(100) NOT NULL,
  `property_condition` enum('New','Good','Fair','Poor') NOT NULL,
  `year_built` year NOT NULL,
  `address` varchar(255) NOT NULL,
  `area` decimal(10,2) NOT NULL,
  `value` decimal(15,2) NOT NULL,
  `estimate_date` date NOT NULL,
  PRIMARY KEY (`collateral_ID`),
  KEY `customer_ID` (`customer_ID`),
  KEY `type_ID` (`type_ID`),
  CONSTRAINT `collateral_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`),
  CONSTRAINT `collateral_ibfk_2` FOREIGN KEY (`type_ID`) REFERENCES `collateral_type` (`type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collateral`
--

LOCK TABLES `collateral` WRITE;
/*!40000 ALTER TABLE `collateral` DISABLE KEYS */;
INSERT INTO `collateral` VALUES (1,1,1,'Residential','Primary Residence','New',2020,'123 Main St, Springfield, IL',2000.00,300000.00,'2024-09-01'),(2,1,2,'Residential','Investment Property','Good',2015,'456 Elm St, Springfield, IL',1500.00,250000.00,'2024-09-15'),(3,2,3,'Commercial','Office Space','Good',2010,'789 Oak St, Lincoln, NE',3500.00,500000.00,'2024-09-20'),(4,3,4,'Industrial','Warehouse','Fair',2005,'321 Maple Ave, Lincoln, NE',6000.00,750000.00,'2024-09-25'),(5,3,5,'Residential','Primary Residence','New',2022,'654 Pine St, Omaha, NE',2500.00,350000.00,'2024-09-30'),(6,4,1,'Residential','Primary Residence','Good',2018,'987 Birch St, Omaha, NE',1800.00,275000.00,'2024-10-01'),(7,5,2,'Commercial','Retail Space','Good',2016,'135 Spruce St, Kansas City, MO',4000.00,600000.00,'2024-10-05'),(8,6,3,'Agricultural','Farm Land','Fair',2010,'246 Cedar Rd, St. Louis, MO',12000.00,400000.00,'2024-10-10'),(9,6,4,'Residential','Vacation Home','New',2021,'369 Ash Blvd, St. Louis, MO',2300.00,450000.00,'2024-10-15'),(10,7,5,'Industrial','Manufacturing Facility','Good',2015,'852 Willow St, Little Rock, AR',7000.00,800000.00,'2024-10-20'),(11,8,1,'Residential','Primary Residence','New',2023,'159 Oak Dr, Baton Rouge, LA',2200.00,320000.00,'2024-10-25'),(12,9,2,'Commercial','Shopping Center','Good',2019,'753 Maple St, Atlanta, GA',8000.00,950000.00,'2024-10-30'),(13,10,3,'Agricultural','Ranch Land','Fair',2000,'864 Cedar Way, Austin, TX',15000.00,500000.00,'2024-11-01'),(14,11,4,'Residential','Investment Property','Good',2017,'975 Birch Ct, Miami, FL',1900.00,290000.00,'2024-11-05'),(15,12,5,'Commercial','Warehouse','Good',2014,'321 Palm St, Phoenix, AZ',5000.00,700000.00,'2024-11-10'),(16,13,1,'Residential','Primary Residence','New',2021,'432 Oak Ct, Seattle, WA',2100.00,340000.00,'2024-11-15'),(17,14,2,'Industrial','Logistics Center','Good',2018,'678 Pine Ave, Denver, CO',9000.00,850000.00,'2024-11-20'),(18,15,3,'Agricultural','Vineyard','Fair',2012,'543 Maple Blvd, Napa, CA',25000.00,1200000.00,'2024-11-25');
/*!40000 ALTER TABLE `collateral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collateral_type`
--

DROP TABLE IF EXISTS `collateral_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collateral_type` (
  `type_ID` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`type_ID`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collateral_type`
--

LOCK TABLES `collateral_type` WRITE;
/*!40000 ALTER TABLE `collateral_type` DISABLE KEYS */;
INSERT INTO `collateral_type` VALUES (1,'Residential Property','Single-family homes, condos, and townhouses used as primary residences.'),(2,'Commercial Property','Properties used for business purposes, such as office buildings and retail spaces.'),(3,'Vacant Land','Unimproved land intended for future development or investment.'),(4,'Multi-family Units','Residential properties that contain multiple housing units, such as apartments.'),(5,'Industrial Property','Properties used for manufacturing, warehousing, and distribution.'),(6,'Agricultural Land','Land used for farming and agricultural production.'),(7,'Mixed-Use Property','Properties that combine residential, commercial, and sometimes industrial uses.'),(8,'Co-operative Housing','Housing units owned collectively by a group of people, typically in a co-op format.');
/*!40000 ALTER TABLE `collateral_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cust_acc`
--

DROP TABLE IF EXISTS `cust_acc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_acc` (
  `customer_ID` int NOT NULL,
  `account_ID` int NOT NULL,
  `ownership_type` enum('Owner','Joint','Authorized User') NOT NULL,
  `permission_level` enum('Full Access','View Only','Transfer Funds','Limited Access') NOT NULL,
  PRIMARY KEY (`customer_ID`,`account_ID`),
  KEY `account_ID` (`account_ID`),
  CONSTRAINT `cust_acc_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`),
  CONSTRAINT `cust_acc_ibfk_2` FOREIGN KEY (`account_ID`) REFERENCES `account` (`account_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cust_acc`
--

LOCK TABLES `cust_acc` WRITE;
/*!40000 ALTER TABLE `cust_acc` DISABLE KEYS */;
INSERT INTO `cust_acc` VALUES (1,1,'Owner','Full Access'),(1,2,'Joint','Transfer Funds'),(2,3,'Owner','View Only'),(2,4,'Authorized User','Limited Access'),(3,5,'Owner','Full Access'),(3,6,'Joint','Transfer Funds'),(4,7,'Owner','Full Access'),(5,8,'Authorized User','View Only'),(5,9,'Owner','Limited Access'),(6,10,'Joint','Full Access'),(7,11,'Owner','Transfer Funds'),(8,12,'Authorized User','View Only'),(9,13,'Owner','Full Access'),(10,14,'Joint','Limited Access'),(11,15,'Owner','View Only'),(12,1,'Joint','Full Access'),(13,2,'Owner','Transfer Funds'),(14,3,'Authorized User','Limited Access'),(15,4,'Owner','Full Access');
/*!40000 ALTER TABLE `cust_acc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_ID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `middle_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(30) NOT NULL,
  `customer_name` varchar(75) GENERATED ALWAYS AS (concat_ws(_utf8mb4' ',`first_name`,`middle_name`,`last_name`)) STORED,
  `street_number` smallint DEFAULT NULL,
  `street_name` varchar(100) NOT NULL,
  `street` varchar(120) GENERATED ALWAYS AS (concat(`street_number`,_utf8mb4' ',`street_name`)) STORED,
  `apt_number` varchar(10) DEFAULT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(20) NOT NULL,
  `zip_code` varchar(20) NOT NULL,
  `address` varchar(300) GENERATED ALWAYS AS (concat_ws(_utf8mb4' ',`street_number`,`street_name`,`street`,`apt_number`,`city`,`state`,`country`,`zip_code`)) STORED,
  `phone_number` varchar(30) DEFAULT NULL,
  `email_address` varchar(30) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `citizen_status` enum('Citizen','Permanent Resident','Visa Holder','Other') DEFAULT NULL,
  `status` enum('Active','Inactive','Suspended') DEFAULT NULL,
  `creation_date` date DEFAULT NULL,
  `user_ID` int DEFAULT NULL,
  PRIMARY KEY (`customer_ID`),
  KEY `user_ID` (`user_ID`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`user_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` (`customer_ID`, `first_name`, `middle_name`, `last_name`, `street_number`, `street_name`, `apt_number`, `city`, `state`, `country`, `zip_code`, `phone_number`, `email_address`, `date_of_birth`, `citizen_status`, `status`, `creation_date`, `user_ID`) VALUES (1,'John','A','Doe',123,'Main St','None','Austin','TX','USA','73301','555-1234','john.doe@example.com','1980-01-15','Permanent Resident','Active','2024-01-01',1),(2,'Jane',NULL,'Smith',456,'Oak St','1A','Miami','FL','USA','33101','555-5678','jane.smith@example.com','1990-02-20','Permanent Resident','Active','2024-01-02',2),(3,'Michael','B','Johnson',789,'Pine St',NULL,'Seattle','WA','USA','98101','555-8765','michael.johnson@example.com','1985-03-25','Visa Holder','Inactive','2024-01-03',3),(4,'Emily','C','Davis',101,'Elm St','2B','Denver','CO','80201','USA','555-4321','emily.davis@example.com','1995-04-30','Citizen','Active','2024-01-04',1),(5,'Chris',NULL,'Martinez',202,'Maple Ave',NULL,'Chicago','IL','USA','60601','555-3456','chris.martinez@example.com','1988-05-10','Permanent Resident','Active','2024-01-05',2),(6,'Sarah','D','Garcia',303,'Cedar St','3C','Portland','OR','USA','97201','555-6789','sarah.garcia@example.com','1992-06-15','Citizen','Suspended','2024-01-06',3),(7,'David','E','Wilson',404,'Birch Rd',NULL,'Phoenix','AZ','USA','85001','555-9876','david.wilson@example.com','1982-07-20','Visa Holder','Active','2024-01-07',1),(8,'Sophia',NULL,'Anderson',505,'Ash St','4D','Boston','MA','USA','02101','555-5432','sophia.anderson@example.com','1996-08-25','Other','Inactive','2024-01-08',2),(9,'Daniel','F','Thomas',606,'Walnut St',NULL,'Atlanta','GA','USA','30301','555-1111','daniel.thomas@example.com','1993-09-30','Citizen','Active','2024-01-09',3),(10,'Olivia',NULL,'Taylor',707,'Hickory Ln','5E','San Diego','CA','USA','92101','555-2222','olivia.taylor@example.com','1989-10-05','Permanent Resident','Active','2024-01-10',1),(11,'James','G','Moore',808,'Chestnut St',NULL,'Las Vegas','NV','USA','89101','555-3333','james.moore@example.com','1987-11-12','Visa Holder','Suspended','2024-01-11',2),(12,'Ava','H','Jackson',909,'Poplar St','6F','Dallas','TX','USA','75201','555-4444','ava.jackson@example.com','1991-12-15','Citizen','Active','2024-01-12',3),(13,'William',NULL,'White',123,'Fir St',NULL,'Philadelphia','PA','USA','19101','555-5555','william.white@example.com','1984-01-20','Permanent Resident','Active','2024-01-13',1),(14,'Mia','I','Harris',234,'Cypress St','7G','San Antonio','TX','USA','78201','555-6666','mia.harris@example.com','1992-02-22','Other','Inactive','2024-01-14',2),(15,'Liam','J','Martin',345,'Juniper St',NULL,'Indianapolis','IN','USA','46201','555-7777','liam.martin@example.com','1990-03-15','Citizen','Active','2024-01-15',3),(16,'John','Doe','Smith',123,'Main St','Apt 4B','Los Angeles','CA','USA','90001','123-456-7890','john.doe@example.com','1990-01-01','Citizen','Active',NULL,1),(18,'Name','','Modz',3765,'12bb','B11','Be','NO','USA','11218','3456','irma@gmail.com','1987-02-03','Visa Holder','Active',NULL,3);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan` (
  `loan_ID` int NOT NULL AUTO_INCREMENT,
  `customer_ID` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `agreement_amount` decimal(15,2) NOT NULL,
  `withdraw_amount` decimal(15,2) NOT NULL,
  `int_rate` decimal(5,2) NOT NULL,
  `int_rate_type` enum('Fixed','Variable') NOT NULL,
  `loan_type` enum('Conventional','FHA','VA','Jumbo','Adjustable') NOT NULL,
  `loan_purpose` varchar(100) NOT NULL,
  `user_ID` int NOT NULL,
  `status` enum('Active','Closed','Defaulted','Overdue','WrittenOff') NOT NULL,
  `account_ID` int NOT NULL,
  PRIMARY KEY (`loan_ID`),
  KEY `customer_ID` (`customer_ID`),
  CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (1,1,'2024-01-15','2034-01-15',250000.00,250000.00,3.75,'Fixed','Conventional','Home Purchase',1,'Active',1),(2,1,'2024-06-10','2034-06-10',300000.00,300000.00,4.00,'Fixed','FHA','Home Improvement',1,'Active',1),(3,1,'2024-12-20','2034-12-20',200000.00,200000.00,3.50,'Variable','VA','Refinancing',4,'Closed',1),(4,2,'2024-02-20','2034-02-20',150000.00,150000.00,5.20,'Fixed','Jumbo','Home Purchase',2,'Active',2),(5,2,'2024-05-25','2034-05-25',180000.00,180000.00,5.20,'Variable','Adjustable','Home Improvement',2,'Overdue',2),(6,2,'2024-09-15','2034-09-15',220000.00,220000.00,5.20,'Fixed','Conventional','Refinancing',4,'Active',2),(7,3,'2024-03-05','2034-03-05',200000.00,200000.00,3.75,'Fixed','FHA','Home Purchase',3,'Closed',1),(8,3,'2024-07-01','2034-07-01',160000.00,160000.00,4.05,'Variable','VA','Home Improvement',4,'Active',1),(9,4,'2024-01-10','2034-01-10',150000.00,150000.00,3.25,'Fixed','Jumbo','Home Purchase',1,'Active',2),(10,5,'2024-04-15','2034-04-15',400000.00,400000.00,3.80,'Variable','Adjustable','Home Purchase',2,'Overdue',3),(11,6,'2024-02-28','2034-02-28',180000.00,180000.00,7.20,'Fixed','Conventional','Home Purchase',3,'Active',1),(12,7,'2024-03-15','2034-03-15',220000.00,220000.00,7.20,'Variable','FHA','Home Purchase',1,'Defaulted',2),(13,8,'2024-05-01','2034-05-01',280000.00,280000.00,4.10,'Fixed','VA','Home Purchase',2,'WrittenOff',3),(14,9,'2024-01-20','2034-01-20',300000.00,300000.00,3.60,'Fixed','Jumbo','Refinancing',1,'Active',1),(15,10,'2024-02-25','2034-02-25',120000.00,120000.00,3.70,'Variable','Adjustable','Home Improvement',2,'Overdue',2),(16,11,'2024-03-10','2034-03-10',230000.00,230000.00,4.00,'Fixed','Conventional','Home Purchase',3,'Active',3),(17,12,'2024-04-05','2034-04-05',150000.00,150000.00,3.85,'Variable','FHA','Home Purchase',1,'Closed',1),(18,13,'2024-01-30','2034-01-30',170000.00,170000.00,4.15,'Fixed','VA','Home Purchase',2,'Active',2),(19,14,'2024-02-15','2034-02-15',310000.00,310000.00,3.95,'Variable','Jumbo','Refinancing',3,'Defaulted',3),(20,15,'2024-03-25','2034-03-25',200000.00,200000.00,4.05,'Fixed','Adjustable','Home Improvement',1,'Active',1),(21,1,'2024-04-10','2034-04-10',240000.00,240000.00,3.65,'Fixed','Conventional','Home Purchase',1,'Active',1),(22,2,'2024-05-20','2034-05-20',350000.00,350000.00,4.05,'Variable','FHA','Home Purchase',2,'Overdue',2),(23,3,'2024-06-15','2034-06-15',190000.00,190000.00,3.55,'Fixed','VA','Home Purchase',3,'Active',1),(24,4,'2024-07-01','2034-07-01',280000.00,280000.00,3.95,'Variable','Jumbo','Home Improvement',1,'Closed',2),(25,5,'2024-08-20','2034-08-20',150000.00,150000.00,4.20,'Fixed','Adjustable','Home Purchase',2,'Active',3),(26,6,'2024-09-10','2034-09-10',220000.00,220000.00,3.85,'Fixed','Conventional','Home Purchase',1,'Defaulted',1),(27,7,'2024-10-05','2034-10-05',320000.00,320000.00,4.10,'Variable','FHA','Home Purchase',2,'WrittenOff',2),(28,8,'2024-11-15','2034-11-15',260000.00,260000.00,4.00,'Fixed','VA','Refinancing',1,'Active',1),(29,9,'2024-12-01','2034-12-01',300000.00,300000.00,3.75,'Variable','Jumbo','Home Improvement',2,'Overdue',2),(30,10,'2024-01-05','2034-01-05',200000.00,200000.00,4.15,'Fixed','Adjustable','Home Purchase',3,'Closed',3);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_ops`
--

DROP TABLE IF EXISTS `loan_ops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_ops` (
  `operation_ID` int NOT NULL AUTO_INCREMENT,
  `loan_ID` int NOT NULL,
  `operation_date` datetime NOT NULL,
  `operation_type` enum('Payment','Closed','Overdue','Defaulted','WrittenOff') NOT NULL,
  `operation_amount` decimal(15,2) DEFAULT '0.00',
  `operation_status` enum('Pending','Completed','Failed') NOT NULL,
  `user_ID` int NOT NULL,
  PRIMARY KEY (`operation_ID`),
  KEY `loan_ID` (`loan_ID`),
  KEY `user_ID` (`user_ID`),
  CONSTRAINT `loan_ops_ibfk_1` FOREIGN KEY (`loan_ID`) REFERENCES `loan` (`loan_ID`),
  CONSTRAINT `loan_ops_ibfk_2` FOREIGN KEY (`user_ID`) REFERENCES `user` (`user_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_ops`
--

LOCK TABLES `loan_ops` WRITE;
/*!40000 ALTER TABLE `loan_ops` DISABLE KEYS */;
INSERT INTO `loan_ops` VALUES (1,1,'2024-09-01 10:00:00','Payment',1500.00,'Completed',1),(2,1,'2024-09-15 11:00:00','Overdue',0.00,'Pending',1),(3,2,'2024-09-02 14:30:00','Payment',2000.00,'Completed',2),(4,2,'2024-09-20 09:00:00','Payment',500.00,'Completed',2),(5,3,'2024-09-05 12:00:00','Defaulted',0.00,'Completed',3),(6,4,'2024-09-07 15:00:00','WrittenOff',0.00,'Completed',4),(7,5,'2024-09-10 16:30:00','Payment',3000.00,'Completed',5),(8,6,'2024-09-12 10:15:00','Payment',1000.00,'Completed',6),(9,6,'2024-09-25 09:45:00','Overdue',0.00,'Pending',6),(10,7,'2024-09-15 13:00:00','Payment',2500.00,'Completed',7),(11,8,'2024-09-18 08:00:00','Payment',1200.00,'Completed',8),(12,9,'2024-09-20 10:30:00','Defaulted',0.00,'Completed',9),(13,10,'2024-08-21 11:30:00','WrittenOff',0.00,'Completed',10),(14,11,'2024-09-22 12:00:00','Payment',800.00,'Completed',11),(15,12,'2024-09-23 14:00:00','Payment',4000.00,'Completed',12),(16,13,'2024-09-24 15:30:00','Overdue',0.00,'Pending',13),(17,14,'2024-09-25 16:00:00','Payment',2000.00,'Completed',14),(18,15,'2024-09-26 17:00:00','WrittenOff',0.00,'Completed',15);
/*!40000 ALTER TABLE `loan_ops` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `loan_ops_AFTER_INSERT` AFTER INSERT ON `loan_ops` FOR EACH ROW BEGIN
BEGIN
    UPDATE loan
    SET status = CASE 
        WHEN NEW.operation_type = 'Closed' THEN 'updated'
        WHEN NEW.operation_type = 'Overdue' THEN 'Overdue'
        WHEN NEW.operation_type = 'WrittenOff' THEN 'WrittenOff'
        WHEN NEW.operation_type = 'Defaulted' THEN 'Defaulted'
        ELSE 'Active'
    END
    WHERE loan_id = NEW.loan_id;
END; 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `loan_ID` int NOT NULL,
  `payment_date` date NOT NULL,
  `principal_amount` decimal(15,2) NOT NULL,
  `interest_amount` decimal(15,2) NOT NULL,
  `total_payment` decimal(15,2) NOT NULL,
  PRIMARY KEY (`loan_ID`,`payment_date`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`loan_ID`) REFERENCES `loan` (`loan_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'2024-10-01',500.00,150.00,650.00),(1,'2024-11-01',500.00,145.00,645.00),(1,'2024-12-01',500.00,140.00,640.00),(1,'2025-01-01',500.00,135.00,635.00),(1,'2025-02-01',500.00,130.00,630.00),(1,'2025-03-01',500.00,125.00,625.00),(1,'2025-04-01',500.00,120.00,620.00),(1,'2025-05-01',500.00,115.00,615.00),(2,'2024-10-10',700.00,200.00,900.00),(2,'2024-11-10',700.00,195.00,895.00),(2,'2024-12-10',700.00,190.00,890.00),(2,'2025-01-10',700.00,185.00,885.00),(3,'2024-10-15',300.00,75.00,375.00),(3,'2024-11-15',300.00,70.00,370.00),(3,'2024-12-15',300.00,65.00,365.00),(4,'2024-10-20',1000.00,250.00,1250.00),(5,'2024-10-25',600.00,180.00,780.00),(5,'2024-11-25',600.00,175.00,775.00),(6,'2024-11-01',400.00,100.00,500.00),(7,'2024-10-05',550.00,160.00,710.00),(8,'2024-10-15',300.00,90.00,390.00),(9,'2024-10-20',800.00,220.00,1020.00),(10,'2024-10-30',900.00,250.00,1150.00),(11,'2024-11-10',500.00,150.00,650.00),(12,'2024-11-15',750.00,180.00,930.00),(13,'2024-11-20',600.00,170.00,770.00),(14,'2024-12-01',650.00,190.00,840.00),(15,'2024-12-10',500.00,160.00,660.00);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secures`
--

DROP TABLE IF EXISTS `secures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secures` (
  `loan_ID` int NOT NULL,
  `collateral_ID` int NOT NULL,
  `link_date` date NOT NULL,
  `link_status` enum('Active','Inactive','Revoked') NOT NULL,
  `last_update_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`loan_ID`,`collateral_ID`),
  KEY `collateral_ID` (`collateral_ID`),
  CONSTRAINT `secures_ibfk_1` FOREIGN KEY (`loan_ID`) REFERENCES `loan` (`loan_ID`),
  CONSTRAINT `secures_ibfk_2` FOREIGN KEY (`collateral_ID`) REFERENCES `collateral` (`collateral_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secures`
--

LOCK TABLES `secures` WRITE;
/*!40000 ALTER TABLE `secures` DISABLE KEYS */;
INSERT INTO `secures` VALUES (1,1,'2024-09-01','Active','2024-09-27 02:50:17'),(1,2,'2024-09-15','Active','2024-09-27 02:50:17'),(2,3,'2024-09-20','Inactive','2024-09-27 02:50:17'),(3,4,'2024-09-25','Active','2024-09-27 02:50:17'),(3,5,'2024-09-30','Active','2024-09-27 02:50:17'),(4,6,'2024-10-01','Active','2024-09-27 02:50:17'),(5,7,'2024-10-05','Revoked','2024-09-27 02:50:17'),(6,8,'2024-10-10','Active','2024-09-27 02:50:17'),(7,9,'2024-10-15','Active','2024-09-27 02:50:17'),(8,10,'2024-10-20','Inactive','2024-09-27 02:50:17'),(9,11,'2024-10-25','Active','2024-09-27 02:50:17'),(10,12,'2024-10-30','Active','2024-09-27 02:50:17'),(11,13,'2024-11-01','Active','2024-09-27 02:50:17'),(12,14,'2024-11-05','Revoked','2024-09-27 02:50:17'),(13,15,'2024-11-10','Active','2024-09-27 02:50:17');
/*!40000 ALTER TABLE `secures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_ID` int NOT NULL AUTO_INCREMENT,
  `user_role` varchar(20) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  PRIMARY KEY (`user_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Loan Officer','David'),(2,'Loan Officer','Emily'),(3,'Loan Officer','Michael'),(4,'Branch Manager','Sarah'),(5,'Branch Manager','David'),(6,'Branch Manager','Jessica'),(7,'Loan Officer','Daniel'),(8,'Loan Officer','Olivia'),(9,'Loan Officer','Sophia'),(10,'Loan Officer','Matthew'),(11,'Loan Officer','Ava'),(12,'Risk Manager','James'),(13,'Risk Manager','Benjamin'),(14,'Risk Manager','Isabella'),(15,'Risk Manager','Mia'),(16,'Loan Officer','test'),(17,'Branch Manager','test_2'),(18,'Loan Officer','test'),(19,'Loan Officer','test');
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

-- Dump completed on 2024-10-27 23:38:50
