use sc_g;

DROP TABLE IF EXISTS `g`;

CREATE TABLE `g` (
  `uuid` CHAR(36) NOT NULL,
  `ptUUID` CHAR(36) NOT NULL,
  `description` text DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `discontinuedNotes` text DEFAULT NULL,
  `recordChangedByUUID` CHAR(36) NOT NULL,
  `recordChangedFromIPAddress` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 WITH SYSTEM VERSIONING;
