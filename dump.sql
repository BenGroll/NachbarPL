-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: space_pa_domi
-- ------------------------------------------------------
-- Server version	8.0.39-0ubuntu0.22.04.1

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
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` json NOT NULL,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (1,1,'fe79b2b579824badb072da6f4b1aad68','{}','2024-10-01 19:34:08','2024-10-01 19:34:08'),(2,NULL,'b3e18773799f4cc3a653c6e6c32c2a9a','{}','2024-10-04 16:32:02','2024-10-04 16:32:02'),(3,NULL,'7a4ff903edf84ae3ab8c3d2c03ea269a','{}','2024-10-04 16:32:03','2024-10-04 16:32:03'),(4,NULL,'debb51a8bd4a49d7991072453552fbaa','{}','2024-10-04 16:32:03','2024-10-04 16:32:03'),(5,NULL,'aaedb42b866742ae976e054026bb3868','{}','2024-10-04 16:32:03','2024-10-04 16:32:03'),(6,NULL,'3838e612078b46dc930682356eb1cf52','{}','2024-10-04 16:32:03','2024-10-04 16:32:03'),(7,1,'f17fdcd5a8914c0f9743e47b59283d99','{}','2024-10-04 16:32:14','2024-10-04 16:32:14'),(8,NULL,'d018b296e8144338951a0ec39c5db1e4','{}','2024-10-04 23:04:02','2024-10-04 23:04:02'),(9,NULL,'941b555a442e4bf69d72d6e5b04aaace','{}','2024-10-04 23:04:02','2024-10-04 23:04:02'),(10,NULL,'85b781834d514d689ada1f0e55a69d69','{}','2024-10-04 23:04:02','2024-10-04 23:04:02'),(11,NULL,'c524b7fef8c04bebad21a31fc3ba9340','{}','2024-10-04 23:04:03','2024-10-04 23:04:03'),(12,NULL,'a3a1d072568a47219e796f6561db9d98','{}','2024-10-05 20:07:51','2024-10-05 20:07:51'),(13,NULL,'10d34687d11a4c779ee230563d1d9b08','{}','2024-10-05 20:07:51','2024-10-05 20:07:51'),(14,NULL,'f1d1227fbdda46efb2d742343bab7342','{}','2024-10-05 20:07:51','2024-10-05 20:07:51'),(15,NULL,'c0d36c3cc78445d39ee8c24f47c90894','{}','2024-10-05 20:07:52','2024-10-05 20:07:52'),(16,NULL,'acb95d70aa2d40e9bb512bd6da968b1a','{}','2024-10-06 13:35:52','2024-10-06 13:35:52'),(17,NULL,'ba8d767228d34156b2178006b7288dc1','{}','2024-10-06 13:35:52','2024-10-06 13:35:52'),(18,NULL,'c746bf2f151948958758728bc8d05934','{}','2024-10-06 13:35:52','2024-10-06 13:35:52'),(19,NULL,'22523a4e0e29436687513522c8d407b3','{}','2024-10-06 13:35:53','2024-10-06 13:35:53'),(20,1,'43b5e74cd543470fb80c38323dcbb0a3','{}','2024-10-07 11:15:10','2024-10-07 11:15:10'),(21,NULL,'b966419da5d14150bd75040e69760503','{}','2024-10-07 07:58:16','2024-10-07 07:58:16'),(22,NULL,'6726e14aca6a4f25b426bcab50fc6107','{}','2024-10-07 11:29:58','2024-10-07 11:29:58'),(23,3,'c72c191d1d534173925d4bb90ca7d1e7','{}','2024-10-07 11:51:22','2024-10-07 11:51:22'),(24,NULL,'1e34964380c64e11b7250e6e581784a3','{}','2024-10-07 11:33:32','2024-10-07 11:33:32'),(25,2,'35eea38c37e74951ae4b61962b064244','{}','2024-10-07 11:35:53','2024-10-07 11:35:53'),(26,NULL,'f878ccf615fc4c93b58da6ad84f94172','{}','2024-10-07 16:04:03','2024-10-07 16:04:03'),(27,NULL,'c41abd9137ef4a0aa2ddc2e721ce75ef','{}','2024-10-07 16:49:58','2024-10-07 16:49:58'),(28,NULL,'8f4948ec9b954d0ca39a587bc711e82e','{}','2024-10-07 17:06:08','2024-10-07 17:06:08'),(29,NULL,'3d03294d361a41ffa3c920e793b6910a','{}','2024-10-07 17:06:09','2024-10-07 17:06:09'),(30,NULL,'c3a11c76b4ce44c985082714c3f96499','{}','2024-10-07 17:06:09','2024-10-07 17:06:09'),(31,NULL,'c9f40d9aa330405cb8e21167defc3aed','{}','2024-10-07 17:06:09','2024-10-07 17:06:09'),(32,NULL,'af5ba8b655f24b509ea9d0a4c5f02013','{}','2024-10-07 17:06:10','2024-10-07 17:06:10'),(33,NULL,'689098fea0a24ec283689cda59928eec','{}','2024-10-08 18:30:08','2024-10-08 18:30:08'),(34,NULL,'7976cd01b8934d4f81bbcb951e1a1909','{}','2024-10-08 18:30:08','2024-10-08 18:30:08'),(35,NULL,'bb2223e748194734ac04794fdda047fe','{}','2024-10-08 18:30:09','2024-10-08 18:30:09'),(36,NULL,'8c5177cf04f94018991d838bface92b7','{}','2024-10-08 18:30:09','2024-10-08 18:30:09'),(37,NULL,'92c2196a0daa4d628a70ec2dfef7c8d2','{}','2024-10-08 18:30:10','2024-10-08 18:30:10'),(38,NULL,'f3c4ab4191b04ffe87af1a0b24c81807','{}','2024-10-10 04:55:06','2024-10-10 04:55:06'),(39,NULL,'96296d433c2649949d9bf9e71178be19','{}','2024-10-10 04:55:10','2024-10-10 04:55:10'),(40,1,'3cb8b68f9d5b483eafaca0abe5aebfde','{}','2024-10-14 10:00:29','2024-10-14 10:00:29'),(41,NULL,'9d3499eb108a4cb2aa1ab965ed8a2ea0','{}','2024-10-14 09:23:28','2024-10-14 09:23:28'),(42,NULL,'1da83ad4924f4b5cbf933cb022f37231','{}','2024-10-14 09:23:28','2024-10-14 09:23:28'),(43,NULL,'66189170c3af47fe90e7003def976482','{}','2024-10-14 09:23:28','2024-10-14 09:23:28'),(44,NULL,'fe4940f00b9d483a99730544604366d7','{}','2024-10-14 09:23:28','2024-10-14 09:23:28'),(45,NULL,'3272cf51e8f6422bbeeece1f36f63693','{}','2024-10-14 09:23:29','2024-10-14 09:23:29'),(46,1,'063200e15e02464fa430a2689bce9c43','{}','2024-10-14 09:23:53','2024-10-14 09:23:53'),(47,NULL,'6f62a3fde2634830a0d1008c9cab0fd3','{}','2024-10-14 09:36:10','2024-10-14 09:36:10'),(48,4,'6bc7ec3b0b6f4500975ac6daacac0814','{}','2024-10-14 09:52:34','2024-10-14 09:52:34'),(49,5,'a9fb8a71d88b460ab8899e9c84ffe8c0','{}','2024-10-14 09:41:15','2024-10-14 09:41:15'),(50,3,'ca5e56668964424687814599714b65a4','{}','2024-10-14 09:52:45','2024-10-14 09:52:45'),(51,7,'e5ba995af5764f10ac7bce5f1a20f7a2','{}','2024-10-14 11:28:50','2024-10-14 11:28:50'),(52,NULL,'8d0bb02a793548189418119e7513e8ae','{}','2024-10-14 11:25:00','2024-10-14 11:25:00'),(53,NULL,'6e1d956201664aaaa01cd15eacce92f1','{}','2024-10-14 11:25:00','2024-10-14 11:25:00'),(54,NULL,'884ae9a4123544d2afaef7e9e58c4bbc','{}','2024-10-14 11:25:00','2024-10-14 11:25:00'),(55,8,'14d36d60a25142259c17ceb41f5530c8','{}','2024-10-14 12:32:47','2024-10-14 12:32:47'),(56,11,'4c7a0b6a7ae349c5a2863c1480047e21','{}','2024-10-14 16:12:51','2024-10-14 16:12:51'),(57,10,'2b785813b0e449a088a4bf82c1538221','{}','2024-10-14 16:11:29','2024-10-14 16:11:29'),(58,6,'f79aa6281dcf4669acbc719fe6dfdba0','{}','2024-10-16 10:13:36','2024-10-16 10:13:36');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_nachtderklaenge1`
--

DROP TABLE IF EXISTS `tickets_nachtderklaenge1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_nachtderklaenge1` (
  `id` varchar(8) NOT NULL,
  `options` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `quantity` smallint DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `redeemed` smallint DEFAULT '0',
  `payment_status` varchar(255) NOT NULL,
  `bill_person_name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_nachtderklaenge1`
--

LOCK TABLES `tickets_nachtderklaenge1` WRITE;
/*!40000 ALTER TABLE `tickets_nachtderklaenge1` DISABLE KEYS */;
INSERT INTO `tickets_nachtderklaenge1` VALUES ('2OPDH','Phasen:BLIND TICKETS - Phase I','00052',1,'bes.petsch@gmx.de',0,'Bezahlt','Rafael Petsch',NULL,'2024-10-14 08:49:44'),('3CCGG','Phasen:BLIND TICKETS - Phase I','00052',1,'gabriel.spoerl@googlemail.com',0,'Bezahlt','Gabriel Spörl',NULL,'2024-10-14 08:49:44'),('6QDSI','Phasen:BLIND TICKETS - Phase I','00052',1,'luiszelko23@gmail.com',0,'Bezahlt','Luis Zelko',NULL,'2024-10-14 08:49:44'),('A4NFA','Phasen:Regular - PHASE III','00052',1,'angelina.herrmann1@gmx.de',0,'Bezahlt','Angelina Herrmann',NULL,'2024-10-14 08:49:44'),('AMDYQ','Phasen:Early Tickets - PHASE II','00052',2,'herecomesjuliblue@gmail.com',0,'Bezahlt','Julia Radke',NULL,'2024-10-14 08:49:44'),('B0FWS','Phasen:Early Tickets - PHASE II','00052',1,'stuppyflorian@gmail.com',0,'Bezahlt','Florian Stuppy',NULL,'2024-10-14 08:49:44'),('C7F9H','Phasen:Regular - PHASE III','00052',1,'wolf.charlie@gmx.de',1,'Bezahlt','Charlotte Wolf','2024-10-14 09:24:22','2024-10-14 09:24:22'),('ESUIQ','Phasen:Early Tickets - PHASE II','00052',1,'metz.lukas@gmx.de',0,'Bezahlt','Lukas Metz',NULL,'2024-10-14 08:49:44'),('GLDRA','Phasen:BLIND TICKETS - Phase I','00052',1,'vincentmanhart@gmail.com',0,'Bezahlt','Vincent Manhart',NULL,'2024-10-14 08:49:44'),('IVQSM','Phasen:Early Tickets - PHASE II','00052',1,'stuppyflorian@gmail.com',0,'Bezahlt','Florian Stuppy',NULL,'2024-10-14 08:49:44'),('JULGE','Phasen:Regular - PHASE III','00052',1,'jannikbeeching@gmail.com',0,'Bezahlt','Jannik Beeching',NULL,'2024-10-14 08:49:44'),('KVXI9','Phasen:BLIND TICKETS - Phase I','00052',1,'benni230905@gmail.com',0,'Bezahlt','Benjamin Menning',NULL,'2024-10-14 08:49:44'),('LGFGE','Phasen:BLIND TICKETS - Phase I','00052',1,'vordhosbn@posteo.de',0,'Bezahlt','Adrian Binder',NULL,'2024-10-14 08:49:44'),('LRR1U','Phasen:BLIND TICKETS - Phase I','00052',1,'lugge.lr@gmail.com',0,'Bezahlt','Lucas Reiner',NULL,'2024-10-14 08:49:44'),('PIJWD','Phasen:BLIND TICKETS - Phase I','00052',1,'karin.pia@web.de',0,'Zahlung ausstehend','Karin Klein',NULL,'2024-10-14 08:49:44'),('SDT0N','Phasen:BLIND TICKETS - Phase I','00052',1,'el.shifa98@gmail.com',0,'Bezahlt','Shifa El-Metnawi',NULL,'2024-10-14 08:49:44'),('TK8TR','Phasen:BLIND TICKETS - Phase I','00052',1,'paypal20081125a@morgenbrodt.de',0,'Bezahlt','henrik morgenbrodt',NULL,'2024-10-14 08:49:44'),('XZFUU','Phasen:Early Tickets - PHASE II','00052',1,'paaschevanessa@gmail.com',0,'Bezahlt','Vanessa Paasche',NULL,'2024-10-14 08:49:44'),('ZDZ1O','Phasen:Early Tickets - PHASE II','00052',1,'helena@moendel-online.de',0,'Bezahlt','Helena Möndel',NULL,'2024-10-14 08:49:44');
/*!40000 ALTER TABLE `tickets_nachtderklaenge1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isadmin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'bengroll002@gmail.com','DBsudWjc+86rCRaBcD7Jo/PpZavTdGjmXLM0od0/DqtzN/3wke/MqQucm1ZK0uWtb49h+ChDHYd7ZLHEqzEJBA','Ben','Groll','7bhYDrRVgeUBmtKuW_dWYBr3DdNYExaV',1,'2024-10-07 11:15:35','2024-10-07 11:15:10'),(2,'theresahugenberg@icloud.com','QRiiM4wVJAlbKJvVALyFfWZDEFXulM6ADYMaLoOZ/YxvgOiIcKBFYK6//9NBRu2ISxd5aexLEL49EXeqDJ6Cog','Theresa','Hugenberg','hGZdXDIHahi1q4_wwLegyZZ1Xvm8VLTK',0,'2024-10-07 11:35:53','2024-10-07 11:35:53'),(3,'aileen-hoeckendorf@web.de','CHkWalr/AbmpBxPE6hm3CBO1bUAAF/4k4nKDAWg1H+OU1qV0HHqvC/AeCRJfrw+H10DV1lFBMRbbbS9GRgcTIg','Aileen','aileen','pXlEp4OtqbIYAEHJUfuuEOksn78PpUQU',0,'2024-10-07 11:51:22','2024-10-07 11:51:22'),(4,'helene.deangeli@gmx.de','oXlvM//9EWjF5Kj5JiLInctjFQUUuI/r6jeaU+OgXW8YMiEBFyuFBNsw4g5UqxeFfx2RnUIaS5A64Llblmeafg','Helene Lucia Deangeli','Cuntslayer69','-uyxPBxtWpN58zQzuBHKzAK3qPRi6nct',0,'2024-10-14 09:38:22','2024-10-14 09:38:22'),(5,'miraikikii@gmail.com','iZ+aNI7J93AY9k0ZUem2lJ2Gjdzh+M2+Ji0s33dV7O9baq5zXhZhAGMge1QuKsQpS2cG+tMW8DmdoBd92KU6Fw','Chiara','Glöss','HC0REgI7LmQwMRDnjYSyh4tJWFsVzjer',0,'2024-10-14 09:40:34','2024-10-14 09:40:34'),(6,'testaccount@test','Y3Ik9E1UqimPQ5meSRXiYPMFCONRv50iBxosqLCnX+n9e290058wv7lutcZgqThwRGak0tnskFOuNYrQrfbxsQ','test','test','8x_vIFDXX78Ux_flnjfdm6U_z6N9dC5z',0,'2024-10-14 09:46:00','2024-10-14 09:46:00'),(7,'srsallay@gmail.com','rNc7dg24RRUhmwi8UtYmczAtYkeiDNKtem14Zodi3frWO89uQjeicMuVL/3jc0gSScaasBic0FscSNwMij3bIg','Sara','Sallay','8hWzR7duhlfHwNMQWBJ1lWNUaIWedTY6',0,'2024-10-14 11:28:49','2024-10-14 11:28:49'),(8,'DJK170402@Gmail.com','jdexOA5GOvtv8JMPuZMFn0XunD6y1G1L4mP0LDB6fsMPqaHvGZCsYLMTNGE+18bhCPTIw2AJ8B1SlGX7B1wgxw','Dennis-Jade','Lutzenberger','P3RxAklKHF5LgK_xZbG_Wx_dC1BchRO0',0,'2024-10-14 12:32:47','2024-10-14 12:32:47'),(9,'rosenschon.kora@gmail.com','/BNVdoG4ee3buWKrpP0Xyje3Mj4/Kzye1z/kUkBmCxxYF6oJGuTjjfpHqmqelqxTyiXL2mQSueKAUtyhHcqlnA','Kora','Rosenschon','gzVW66xecsieXOYtPLdMJnmFSeF9HEvF',0,'2024-10-14 16:02:38','2024-10-14 16:02:38'),(10,'chiaratodisco2000@icloud.com','oAkTTqO67ur+szKOzBlfhlE2vA7ZhFo3HgfwHOf8+6vCgpDAMBMNQc92Dhb7dACy6u1MMudlINpfnw1eaIXMxg','Chiara ','Todisco ','GkWQcesq7czTg0OCARkAswatFTn_HQny',0,'2024-10-14 16:11:28','2024-10-14 16:11:28'),(11,'rosenschonkora1@gmail.com','+vQgRiRRQxgzY14+OOyGse4RiyGlXpnJASEnfCtoI0aeQ+RAWoe6fDE9zykGsl/+5fm/NJ2O8w1AEDjqj6W0Tw','Kora','Rosenschon','han8giOn9vP58zV0oOhKrau0Koo9f1b9',0,'2024-10-14 16:12:51','2024-10-14 16:12:51');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_permissions_table`
--

DROP TABLE IF EXISTS `users_permissions_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_permissions_table` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_by` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_permissions_table`
--

LOCK TABLES `users_permissions_table` WRITE;
/*!40000 ALTER TABLE `users_permissions_table` DISABLE KEYS */;
INSERT INTO `users_permissions_table` VALUES (1,1,'NachtDerKlaenge::dashboard.view',1),(2,1,'NachtDerKlaenge::order.scan',1),(3,1,'NachtDerKlaenge',1),(4,6,'NachtDerKlaenge',1);
/*!40000 ALTER TABLE `users_permissions_table` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-16 10:25:17
