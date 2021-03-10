CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `name_usr` varchar(255) NOT NULL default '',
  `email_usr` varchar(255) NOT NULL default '',
  `password_usr` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_usr`)
);

INSERT INTO `user_usr` VALUES (1, 'john', 'john@domain.org', '63a9f0ea7bb98050796b649e85481845');