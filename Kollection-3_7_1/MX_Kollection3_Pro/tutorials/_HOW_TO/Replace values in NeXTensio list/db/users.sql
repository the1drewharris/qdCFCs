#
# Table structure for table `user_usr`
#

CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `name_usr` varchar(255) NOT NULL default '',
  `password_usr` varchar(100) NOT NULL default '',
  `level_usr` tinyint(2) NOT NULL default '0',
  `email_usr` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `email_usr` (`email_usr`),
  KEY `name_usr` (`name_usr`)
);

#
# Dumping data for table `user_usr`
#

INSERT INTO `user_usr` VALUES (1, 'John Doe', 'root', 0, 'johndoe@domain.org');
INSERT INTO `user_usr` VALUES (2, 'Jane', 'root', 1, 'jane@domain.org');
INSERT INTO `user_usr` VALUES (3, 'Admin', 'root', 1, 'admin@domain.org');
INSERT INTO `user_usr` VALUES (4, 'reseller1', 'reseller1', 0, 'reseller1@domain.org');
INSERT INTO `user_usr` VALUES (5, 'reseller2', 'reseller2', 0, 'reseller2@domain.org');
    

