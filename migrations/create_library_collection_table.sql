DROP TABLE IF EXISTS `library_collection`;
CREATE TABLE `library_collection` (
  `id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `artist` varchar(255),
  `type` varchar(255),
  `bpm` float,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
);
