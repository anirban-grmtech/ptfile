USE `sc_scr`;


CREATE TABLE `phq9PtResponses` (
  `ptUUID` char(36) NOT NULL,
  `question1` enum('0','1','2','3') DEFAULT NULL,
  `question2` enum('0','1','2','3') DEFAULT NULL,
  `question3` enum('0','1','2','3') DEFAULT NULL,
  `question4` enum('0','1','2','3') DEFAULT NULL,
  `question5` enum('0','1','2','3') DEFAULT NULL,
  `question6` enum('0','1','2','3') DEFAULT NULL,
  `question7` enum('0','1','2','3') DEFAULT NULL,
  `question8` enum('0','1','2','3') DEFAULT NULL,
  `question9` enum('0','1','2','3') DEFAULT NULL,
  `question10` enum('0','1','2','3') DEFAULT NULL,
  `recordChangedByUUID` char(36) DEFAULT NULL,
  `recordChangedFromIPAddress` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ptUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 WITH SYSTEM VERSIONING;



CREATE TABLE `scrAssignedToPts` (
  `uuid` char(36) NOT NULL,
  `scrUUID` char(36) DEFAULT NULL,
  `ptUUID` char(36) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `recordChangedByUUID` char(36) DEFAULT NULL,
  `recordChangedFromIPAddress` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 WITH SYSTEM VERSIONING;



CREATE TABLE `scrListMasters` (
  `uuid` char(36) NOT NULL,
  `scrName` varchar(255) DEFAULT NULL,
  `scientificName` varchar(255) DEFAULT NULL,
  `clinicalStudies` text DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 WITH SYSTEM VERSIONING;

