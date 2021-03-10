# Table structure for table `user_usr`
#

CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `username_usr` varchar(32) NOT NULL default '',
  `password_usr` varchar(32) NOT NULL default '',
  `email_usr` varchar(64) NOT NULL default '',
  `name_usr` varchar(128) NOT NULL default '',
  `bill_address_usr` text,
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `username_usr` (`username_usr`),
  KEY `password_usr` (`password_usr`)
);

#
# Dumping data for table `user_usr`
#

INSERT INTO `user_usr` VALUES (6, 'john', 'root', 'john@domain.org', 'John Doe', 'Sunset BD., no. 150\r\nSan Francisco, USA');
INSERT INTO `user_usr` VALUES (7, 'jane', 'root', 'jane@domain.org', 'Jane Doe', 'East Street, no. 44\r\nLos Angeles, USA');
