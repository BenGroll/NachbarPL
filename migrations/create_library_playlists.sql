DROP TABLE IF EXISTS `library_playlists`;
CREATE TABLE `library_playlists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255),
  `trackids` LONGTEXT DEFAULT NULL,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
);
