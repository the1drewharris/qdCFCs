CREATE TABLE `contact_con` (
  `id_con` tinyint(3) NOT NULL auto_increment,
  `id_dep_con` tinyint(3) NOT NULL default '0',
  `name_con` varchar(128) NOT NULL default '',
  `email_con` varchar(64) NOT NULL default '',
  `phone_con` varchar(16) default NULL,
  `address_con` varchar(128) NOT NULL default '',
  `preferred_con` tinyint(1) NOT NULL default '0',
  `message_con` text NOT NULL,
  PRIMARY KEY  (`id_con`),
  KEY `id_con` (`id_con`)
);



INSERT INTO `contact_con` VALUES (1, 2, 'Lisa Marion', 'lm@somesite.com', '0789759968', '24 Sunset Bd, Los Angeles', 2, 'Hello! I get an error message when I connect to my site. Do you know what is the cause of this problem?');
INSERT INTO `contact_con` VALUES (2, 1, 'Ema Burton', 'ema@somesite.com', '555800011', '33, Roosevelt Avenue, Chicago', 1, 'I just love your new commercial! Great work, guys!');
INSERT INTO `contact_con` VALUES (3, 3, 'John Doe', 'jdoe@john.com', '5550220011', '7, Esplanade Henri de France, Paris', 2, 'I cannot pay through money transfer. Is your account blocked?');
INSERT INTO `contact_con` VALUES (4, 2, 'Jane Doe', 'jdoe@jane.com', '55500780311', 'Viale Mazzini, 23, Roma, Italy', 2, 'You are doing a fine job. Keep it up!');


CREATE TABLE `department_dep` (
  `id_dep` tinyint(3) NOT NULL auto_increment,
  `name_dep` varchar(64) NOT NULL default '',
  `email_dep` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`id_dep`)
);



INSERT INTO `department_dep` VALUES (1, 'Sales&Marketing', 'sales@somesite.com');
INSERT INTO `department_dep` VALUES (2, 'Technical Support', 'technical@somesite.com');
INSERT INTO `department_dep` VALUES (3, 'Financial Department', 'finance@somesite.com');