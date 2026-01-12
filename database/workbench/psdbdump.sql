-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: pet_sematary_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `active_burials`
--

DROP TABLE IF EXISTS `active_burials`;
/*!50001 DROP VIEW IF EXISTS `active_burials`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `active_burials` AS SELECT 
 1 AS `pet_name`,
 1 AS `species`,
 1 AS `owner_name`,
 1 AS `section_name`,
 1 AS `plot_number`,
 1 AS `danger_level`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `burial_plot`
--

DROP TABLE IF EXISTS `burial_plot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `burial_plot` (
  `section_name` varchar(50) NOT NULL,
  `plot_number` int NOT NULL,
  `soil_type` varchar(50) DEFAULT NULL,
  `inscription` text,
  `has_marker` bit(1) DEFAULT NULL,
  `date_of_burial` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`section_name`,`plot_number`),
  CONSTRAINT `burial_plot_ibfk_1` FOREIGN KEY (`section_name`) REFERENCES `section` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `burial_plot`
--

LOCK TABLES `burial_plot` WRITE;
/*!40000 ALTER TABLE `burial_plot` DISABLE KEYS */;
INSERT INTO `burial_plot` VALUES ('Forest Perimeter',1,'Rocky soil','Hachiko, eternal loyalty',_binary '','1935-03-08'),('Forest Perimeter',2,'Loose soil','Stuart Little, too small',_binary '\0','2000-07-15'),('Micmac Grounds',1,'Black cotton soil','Here Lies Brian Griffin. Beloved Friend, Failed Author',_binary '','2013-11-30'),('Micmac Grounds',2,'Clay soil',NULL,_binary '\0','1999-10-05'),('Micmac Grounds',3,'Dark soil','Laika, lost to the stars',_binary '\0','1960-04-12'),('Micmac Grounds',4,'Cold soil','Salem, returned differently',_binary '\0','1997-10-31'),('Micmac Grounds',5,'Ancient soil','Toothless, silent shadow',_binary '\0','2019-03-22'),('Pet Memorial Park',1,'Black cotton soil','Herein lies Garfield. May his rest finally be… uninterrupted',_binary '','2016-12-26'),('Pet Memorial Park',2,'Soft soil','Here lies Snoopy, faithful dreamer',_binary '','1999-10-10'),('Pet Memorial Park',3,'Soft soil','Scooby-Doo, forever afraid',_binary '','2005-04-02'),('Pet Memorial Park',4,'Soft soil','Bolt, good boy',_binary '','2010-08-18'),('Pet Memorial Park',5,'Soft soil','Tom, finally at rest',_binary '','2002-06-01'),('Pet Memorial Park',6,'Soft soil','Snowball II, again',_binary '','1992-02-13');
/*!40000 ALTER TABLE `burial_plot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caretaker`
--

DROP TABLE IF EXISTS `caretaker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caretaker` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `years_of_service` int DEFAULT NULL,
  `knows_secret` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caretaker`
--

LOCK TABLES `caretaker` WRITE;
/*!40000 ALTER TABLE `caretaker` DISABLE KEYS */;
INSERT INTO `caretaker` VALUES (1,'Jud Crandall',33,_binary ''),(2,'Joe Strummer',2,_binary '\0');
/*!40000 ALTER TABLE `caretaker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `forbidden_paths`
--

DROP TABLE IF EXISTS `forbidden_paths`;
/*!50001 DROP VIEW IF EXISTS `forbidden_paths`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `forbidden_paths` AS SELECT 
 1 AS `visitor_name`,
 1 AS `visitor_type`,
 1 AS `section_name`,
 1 AS `access_restrictions`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owner` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `mental_state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1,'Peter Griffin','31 Spooner Street','Sad'),(2,'Jon Arbuckle','Muncie, Indiana','Kinda Happy'),(3,'Mickey Mouse','Disneyland','Distraught'),(4,'Charlie Brown','Peanuts Street','Melancholic'),(5,'Shaggy Rogers','Crystal Cove','Anxious'),(6,'Professor Ueno','Tokyo, Japan','Grieving'),(7,'Unnamed Soviet Astronaut','Baikonur Cosmodrome','Guilt'),(8,'Penny','Hollywood','Hopeful'),(9,'Sabrina Spellman','Greendale','Uneasy'),(10,'Jerry','Unknown Wall Hole','Relieved'),(11,'Homer Simpson','742 Evergreen Terrace','Confused'),(12,'Little Family','New York City','Worried'),(13,'Hiccup Horrendous Haddock','Berk','Determined');
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `owner_id` int DEFAULT NULL,
  `species` varchar(50) DEFAULT NULL,
  `date_of_birth` varchar(10) DEFAULT NULL,
  `date_of_death` varchar(10) DEFAULT NULL,
  `cause_of_death` text,
  `resurrection_status` bit(1) DEFAULT NULL,
  `temperament` varchar(50) DEFAULT NULL,
  `appearance_changes` text,
  `section_name` varchar(50) DEFAULT NULL,
  `plot_number` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `section_name` (`section_name`,`plot_number`),
  CONSTRAINT `pet_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `pet_ibfk_2` FOREIGN KEY (`section_name`, `plot_number`) REFERENCES `burial_plot` (`section_name`, `plot_number`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (1,'Brian Griffin',1,'Dog','1999-01-31','2013-11-24','Car Accident',_binary '','Angry','Mouth sewn shut','Micmac Grounds',1),(2,'Garfield',2,'Cat','1978-01-02','2016-12-24','Choking',_binary '','Hungry','Slit Stomach','Pet Memorial Park',1),(3,'Pluto',3,'Dog','1930-05-09','1999-09-25',NULL,_binary '\0',NULL,NULL,'Micmac Grounds',2),(4,'Snoopy',4,'Dog','1950-10-04','1999-10-04','Old age',_binary '\0','Calm',NULL,'Pet Memorial Park',2),(5,'Scooby-Doo',5,'Dog','1969-09-13','2005-03-28','Fright-induced heart failure',_binary '','Fearful','Eyes refuse to close','Pet Memorial Park',3),(6,'Toothless',13,'Dragon','2010-03-26','2019-03-22','Unknown ritual side effect',_binary '','Unnaturally Calm','Scales darkened permanently','Micmac Grounds',5),(7,'Tom',10,'Cat','1940-02-10','2002-06-01','Blunt trauma',_binary '\0','Aggressive',NULL,'Pet Memorial Park',5),(8,'Bolt',8,'Dog','2008-11-21','2010-08-18','Accident',_binary '\0','Energetic',NULL,'Pet Memorial Park',4),(9,'Salem',9,'Cat','1996-01-01','1997-10-31','Unknown',_binary '','Hostile','Eyes glow faintly red','Micmac Grounds',4),(10,'Laika',7,'Dog','1954-01-01','1960-04-12','Orbital failure',_binary '','Silent','Burn marks beneath fur','Micmac Grounds',3),(11,'Snowball II',11,'Cat','1989-04-19','1992-02-13','Multiple incidents',_binary '','Unstable','Missing fur patches','Pet Memorial Park',6),(12,'Stuart Little',12,'Mouse','1999-12-17','2000-07-15','Predation',_binary '\0','Nervous',NULL,'Forest Perimeter',2),(13,'Hachiko',6,'Dog','1923-11-10','1935-03-08','Starvation',_binary '\0','Loyal',NULL,'Forest Perimeter',1);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resurrection_event`
--

DROP TABLE IF EXISTS `resurrection_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resurrection_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `ritual_name` varchar(50) DEFAULT NULL,
  `date` varchar(10) DEFAULT NULL,
  `time` varchar(5) DEFAULT NULL,
  `moon_phase` enum('New Moon','First Quarter','Full Moon','Last Quarter') DEFAULT NULL,
  `weather` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pet_id` (`pet_id`),
  KEY `ritual_name` (`ritual_name`),
  CONSTRAINT `resurrection_event_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `resurrection_event_ibfk_2` FOREIGN KEY (`ritual_name`) REFERENCES `ritual` (`name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resurrection_event`
--

LOCK TABLES `resurrection_event` WRITE;
/*!40000 ALTER TABLE `resurrection_event` DISABLE KEYS */;
INSERT INTO `resurrection_event` VALUES (1,1,'Moonlit Return','2003-05-18','01:30','Full Moon','Storm'),(2,2,'Ancestral Awakening','2015-09-30','12:05','New Moon','Cloudy'),(3,5,'Echo of Loyalty','2005-04-01','22:45','Full Moon','Fog'),(4,10,'Moonlit Return','1960-04-13','01:10','New Moon','Clear'),(5,9,'Gravebound Whisper','1997-11-01','23:59','Full Moon','Windy'),(6,11,'Gravebound Whisper','1992-02-14','21:30','Last Quarter','Snow'),(7,6,'Ancestral Awakening','2019-03-23','00:05','New Moon','Storm'),(8,7,'Echo of Loyalty','2002-06-02','21:00','Last Quarter','Clear');
/*!40000 ALTER TABLE `resurrection_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ritual`
--

DROP TABLE IF EXISTS `ritual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ritual` (
  `name` varchar(50) NOT NULL,
  `required_items` varchar(255) DEFAULT NULL,
  `chant` text,
  `origin_legend` text,
  `success_rate` decimal(5,2) DEFAULT NULL,
  `forbidden` bit(1) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ritual`
--

LOCK TABLES `ritual` WRITE;
/*!40000 ALTER TABLE `ritual` DISABLE KEYS */;
INSERT INTO `ritual` VALUES ('Ancestral Awakening','Red-sage ceremonial herb, stone circle, drop of owner blood','Ekoran thulei, spirits near awaken kin we hold so dear','An ancient ceremony practiced by tribes',74.00,_binary '\0'),('Echo of Loyalty','Personal belonging of the pet, lock of fur','Return not as you were, but as you remember','A ritual believed to work only on animals with extreme loyalty.',55.00,_binary '\0'),('Gravebound Whisper','Black candle, soil from first grave','Mortis voca, terra audi','An old Micmac burial chant used only when the ground has already tasted death.',22.50,_binary ''),('Moonlit Return','An animal shaped candle, a whisker from the pet','Tusen takk for gild helsing, Knut!','Ancient tribes believed that the full moon opened a passage through which loyal animals could return to the living world.',45.26,_binary ''),('Whispered Passage','A small clay tube, the ashes of a sacred herb, the pet\'s collar','Saelon vora, hear my call Cross the veil and rise from fall','It is said that the old forest guardians would leave whispered messages on the graves so that wandering spirits could find their way back.',28.30,_binary '\0');
/*!40000 ALTER TABLE `ritual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `ritual_corruption`
--

DROP TABLE IF EXISTS `ritual_corruption`;
/*!50001 DROP VIEW IF EXISTS `ritual_corruption`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ritual_corruption` AS SELECT 
 1 AS `name`,
 1 AS `success_rate`,
 1 AS `total_uses`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section` (
  `name` varchar(50) NOT NULL,
  `caretaker_id` int DEFAULT NULL,
  `danger_level` enum('low','mid','high','cursed') DEFAULT NULL,
  `access_restrictions` text,
  PRIMARY KEY (`name`),
  KEY `caretaker_id` (`caretaker_id`),
  CONSTRAINT `section_ibfk_1` FOREIGN KEY (`caretaker_id`) REFERENCES `caretaker` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` VALUES ('Forest Perimeter',2,'low','Open to public.'),('Micmac Grounds',1,'cursed','Authorized personnel only.'),('Pet Memorial Park',2,'mid','Daytime access only.');
/*!40000 ALTER TABLE `section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `visitor_type` enum('Tourist','Researcher','Miscellaneous','Family') DEFAULT NULL,
  `purpose_of_visit` text,
  `is_alive` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor`
--

LOCK TABLES `visitor` WRITE;
/*!40000 ALTER TABLE `visitor` DISABLE KEYS */;
INSERT INTO `visitor` VALUES (1,'Marjorie Holloway',62,'Family','Visiting the grave of her childhood dog',_binary ''),(2,'Elias Crowe',34,'Researcher','Documenting unexplained events',_binary '\0'),(3,'Timothy Wexler',12,'Miscellaneous','Looking for his missing cat',_binary '\0'),(4,'Dana Creed',38,'Family','Checking old burial grounds',_binary ''),(5,'Mark Petrie',29,'Researcher','Studying resurrection patterns',_binary ''),(6,'Eleanor Finch',67,'Tourist','Visiting famous graves',_binary ''),(7,'Lucas Bell',15,'Miscellaneous','Exploring forbidden areas',_binary ''),(8,'Jane Doe',20,'Miscellaneous','Unidentified presence',_binary '\0');
/*!40000 ALTER TABLE `visitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitoraccess`
--

DROP TABLE IF EXISTS `visitoraccess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitoraccess` (
  `visitor_id` int NOT NULL,
  `section_name` varchar(50) NOT NULL,
  `access_duration` int DEFAULT NULL,
  PRIMARY KEY (`visitor_id`,`section_name`),
  KEY `section_name` (`section_name`),
  CONSTRAINT `visitoraccess_ibfk_1` FOREIGN KEY (`visitor_id`) REFERENCES `visitor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visitoraccess_ibfk_2` FOREIGN KEY (`section_name`) REFERENCES `section` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitoraccess`
--

LOCK TABLES `visitoraccess` WRITE;
/*!40000 ALTER TABLE `visitoraccess` DISABLE KEYS */;
INSERT INTO `visitoraccess` VALUES (1,'Micmac Grounds',5),(1,'Pet Memorial Park',10),(2,'Micmac Grounds',3),(2,'Pet Memorial Park',12),(4,'Pet Memorial Park',30),(5,'Forest Perimeter',60),(5,'Micmac Grounds',15),(6,'Pet Memorial Park',20),(7,'Forest Perimeter',10);
/*!40000 ALTER TABLE `visitoraccess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `witnessevent`
--

DROP TABLE IF EXISTS `witnessevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `witnessevent` (
  `visitor_id` int NOT NULL,
  `resurrection_id` int NOT NULL,
  `severity` enum('Low','Mid','High','Fatal') DEFAULT NULL,
  `casualties` int DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`visitor_id`,`resurrection_id`),
  KEY `resurrection_id` (`resurrection_id`),
  CONSTRAINT `witnessevent_ibfk_1` FOREIGN KEY (`visitor_id`) REFERENCES `visitor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `witnessevent_ibfk_2` FOREIGN KEY (`resurrection_id`) REFERENCES `resurrection_event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `witnessevent`
--

LOCK TABLES `witnessevent` WRITE;
/*!40000 ALTER TABLE `witnessevent` DISABLE KEYS */;
INSERT INTO `witnessevent` VALUES (1,1,'High',5,'No one lived to tell the tale'),(3,1,'Mid',2,'I think I see something coming… DUCK!'),(3,2,'Low',0,'A kid saw something weird and fell'),(4,3,'High',1,'Subject emerged altered and aggressive'),(4,6,'Low',0,'Subject showed recognition behavior'),(5,1,'Mid',0,'Subject responded to owner voice'),(5,2,'Fatal',3,'Resurrection caused structural collapse'),(6,4,'Low',0,'Witness reported strange sounds'),(6,7,'High',2,'Multiple injuries reported'),(7,8,'Mid',1,'Entity moved unnaturally fast'),(8,5,'Fatal',2,'No physical remains recovered');
/*!40000 ALTER TABLE `witnessevent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `active_burials`
--

/*!50001 DROP VIEW IF EXISTS `active_burials`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `active_burials` AS select `p`.`name` AS `pet_name`,`p`.`species` AS `species`,`o`.`name` AS `owner_name`,`p`.`section_name` AS `section_name`,`p`.`plot_number` AS `plot_number`,`s`.`danger_level` AS `danger_level` from ((`pet` `p` join `owner` `o` on((`p`.`owner_id` = `o`.`id`))) join `section` `s` on((`p`.`section_name` = `s`.`name`))) where (`p`.`resurrection_status` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `forbidden_paths`
--

/*!50001 DROP VIEW IF EXISTS `forbidden_paths`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `forbidden_paths` AS select `v`.`name` AS `visitor_name`,`v`.`visitor_type` AS `visitor_type`,`s`.`name` AS `section_name`,`s`.`access_restrictions` AS `access_restrictions` from ((`visitor` `v` join `section` `s`) left join `visitoraccess` `a` on(((`v`.`id` = `a`.`visitor_id`) and (`s`.`name` = `a`.`section_name`)))) where (`a`.`visitor_id` is null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ritual_corruption`
--

/*!50001 DROP VIEW IF EXISTS `ritual_corruption`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ritual_corruption` AS select `r`.`name` AS `name`,`r`.`success_rate` AS `success_rate`,ifnull(`c`.`total`,0) AS `total_uses` from (`ritual` `r` left join (select `resurrection_event`.`ritual_name` AS `ritual_name`,count(0) AS `total` from `resurrection_event` group by `resurrection_event`.`ritual_name`) `c` on((`r`.`name` = `c`.`ritual_name`))) where ((`c`.`total` = 0) or ((`r`.`success_rate` < 30) and (`c`.`total` >= 3)) or ((`r`.`success_rate` < 50) and (`c`.`total` >= 1))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-18 15:44:14
