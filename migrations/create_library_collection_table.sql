DROP TABLE IF EXISTS `library_collection`;
CREATE TABLE `library_collection` (
  `id` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Artist` varchar(255),
  `Kind` varchar(255),
  `AverageBpm` float,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
);
