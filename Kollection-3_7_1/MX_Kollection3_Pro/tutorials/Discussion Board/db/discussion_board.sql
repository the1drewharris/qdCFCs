-- 
-- Table structure for table `message_msg`
-- 

CREATE TABLE `message_msg` (
  `id_msg` int(11) NOT NULL auto_increment,
  `idtop_msg` int(11) NOT NULL default '0',
  `idmsg_msg` int(11) default NULL,
  `id_init_msg` int(11) NOT NULL default '0',
  `idusr_msg` int(11) NOT NULL default '0',
  `date_msg` datetime NOT NULL default '0000-00-00 00:00:00',
  `subject_msg` varchar(100) default NULL,
  `content_msg` text NOT NULL,
  `subscribe_msg` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id_msg`)
);

-- 
-- Dumping data for table `message_msg`
-- 

INSERT INTO `message_msg` VALUES (1, 1, NULL, 1, 1, '2005-05-17 00:00:00', 'The stock market - an opportunity?', 'A friend recently suggested that the stock market might be a good opportunity.\r\nI tend to agree because the East European economy is expected to grow a lot in the next few years due to the EU accession and on the average stocks will grow more there than they will in the US.\r\nRight now, I don''t know much about the stock market in Eastern Europe.\r\nThere is an opportunity and there is lots of risk, but a question remains. What is the potential of the East European stock market?', 0);
INSERT INTO `message_msg` VALUES (2, 1, NULL, 2, 2, '2005-05-02 10:14:00', 'Adobe purchases Dreamweaver', 'Apart from the official press releases from Macromedia and Adobe as well as their joint conference call there is a lot of talking on this subject and people are very interested on what the future will bring.\r\nAs far as I am concerned, the future looks pretty bright. We are convinced that no matter where the new company is headed, there is a place for dynamic web development in the future of both Macromedia and Adobe.', 1);

-- --------------------------------------------------------

-- 
-- Table structure for table `topic_top`
-- 

CREATE TABLE `topic_top` (
  `id_top` int(11) NOT NULL auto_increment,
  `title_top` varchar(100) NOT NULL default '',
  `description_top` varchar(200) default NULL,
  PRIMARY KEY  (`id_top`),
  UNIQUE KEY `title_top` (`title_top`)
);

-- 
-- Dumping data for table `topic_top`
-- 

INSERT INTO `topic_top` VALUES (1, 'Investment Opportunities', 'Discuss investment opportunities, or look for investors for your business idea.');
INSERT INTO `topic_top` VALUES (2, 'Marketing & Branding', 'Discuss you ideas on advertising, branding, and media.');
INSERT INTO `topic_top` VALUES (3, 'Business Models', 'What are the best business models? What drives the best businesses in the world?');
INSERT INTO `topic_top` VALUES (4, 'Taxes and Legislation', 'Look for advice or offer advice about the taxation legislation.');

-- --------------------------------------------------------

-- 
-- Table structure for table `user_usr`
-- 

CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `name_usr` varchar(100) NOT NULL default '',
  `email_usr` varchar(150) NOT NULL default '',
  `password_usr` varchar(100) NOT NULL default '',
  `active_usr` tinyint(2) NOT NULL default '0',
  `randomkey_usr` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `name_usr` (`name_usr`)
);

-- 
-- Dumping data for table `user_usr`
-- 

INSERT INTO `user_usr` VALUES (1, 'John Doe', 'johndoe@domain.org', '63a9f0ea7bb98050796b649e85481845', 1, '69ac9f1e4a1277e7619a46ec5af8ed3c');
INSERT INTO `user_usr` VALUES (2, 'Jane', 'jane@domain.org', '63a9f0ea7bb98050796b649e85481845', 1, '71d51f767e7a85db98cca26ec3300ad9');