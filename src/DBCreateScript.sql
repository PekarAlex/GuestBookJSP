CREATE DATABASE IF NOT EXISTS `guestbook` CHARACTER SET = utf8;
USE guestbook;
CREATE TABLE  IF NOT EXISTS  `users` (
  `userName` char(30) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `password` char(30) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `unique_Id` (`Id`),
  UNIQUE KEY `unique_UserName` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  IF NOT EXISTS `guestmessages` (
  `user_Id` int(11) DEFAULT NULL,
  `text` longtext,
  `createStamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `User_Id` (`user_Id`),
  CONSTRAINT `guestmessages_ibfk_1` FOREIGN KEY (`user_Id`) REFERENCES `users` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;