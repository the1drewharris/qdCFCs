#
# Table structure for table `ads_ads`
#

CREATE TABLE `ads_ads` (
  `id_ads` int(11) NOT NULL auto_increment,
  `idusr_ads` int(11) NOT NULL default '0',
  `idtyp_ads` int(11) NOT NULL default '0',
  `idcat_ads` tinyint(4) NOT NULL default '0',
  `title_ads` varchar(255) NOT NULL default '',
  `content_ads` text NOT NULL,
  `idloc_ads` int(11) NOT NULL default '0',
  `date_ads` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id_ads`),
  KEY `idusr_ads` (`idusr_ads`)
);

#
# Dumping data for table `ads_ads`
#

INSERT INTO `ads_ads` VALUES (4, 7, 1, 20, '2004 BMW 325i', 'Mileage:  9,394  \r\nExterior Color:  Gray  \r\nBody Style:  Sedan  \r\nDoors:  Four Door  \r\nEngine:  6 Cylinder  \r\nTransmission:  Automatic  \r\nDrive Type:  2 wheel drive  ', 6, '2005-04-11');
INSERT INTO `ads_ads` VALUES (5, 7, 1, 18, '2004 BMW 325i', 'Mileage:  9,394  \r\nExterior Color:  Gray  \r\nBody Style:  Sedan  \r\nDoors:  Four Door  \r\nEngine:  6 Cylinder  \r\nTransmission:  Automatic  \r\nDrive Type:  2 wheel drive  ', 6, '2005-04-11');
INSERT INTO `ads_ads` VALUES (6, 7, 1, 13, 'HDTV Flatscreen', 'Digital Reality Creation\r\n. Reverse 3:2 Pulldown\r\n. SRS Surround Sound\r\n. HDMI & Component Inputs\r\n$1,388\r\n', 5, '2005-04-11');
INSERT INTO `ads_ads` VALUES (7, 7, 1, 23, '8 room House', '$248,500.00', 2, '2005-04-11');

# --------------------------------------------------------

#
# Table structure for table `category_cat`
#

CREATE TABLE `category_cat` (
  `id_cat` tinyint(4) NOT NULL auto_increment,
  `idcat_cat` int(10) NOT NULL default '0',
  `name_cat` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_cat`)
);

#
# Dumping data for table `category_cat`
#

INSERT INTO `category_cat` VALUES (1, 0, 'Mobile');
INSERT INTO `category_cat` VALUES (8, 1, 'Cell phones');
INSERT INTO `category_cat` VALUES (9, 1, 'Car-kits');
INSERT INTO `category_cat` VALUES (10, 1, 'Mobile accessories');
INSERT INTO `category_cat` VALUES (11, 0, 'Electronics');
INSERT INTO `category_cat` VALUES (12, 11, 'Stereo');
INSERT INTO `category_cat` VALUES (13, 11, 'Video');
INSERT INTO `category_cat` VALUES (14, 11, 'Household electronics');
INSERT INTO `category_cat` VALUES (15, 11, 'Computers');
INSERT INTO `category_cat` VALUES (16, 0, 'Automotive');
INSERT INTO `category_cat` VALUES (17, 16, 'Antiques');
INSERT INTO `category_cat` VALUES (18, 16, 'Cars');
INSERT INTO `category_cat` VALUES (19, 16, 'Trucks, SUV`s');
INSERT INTO `category_cat` VALUES (20, 16, 'Motorcycles');
INSERT INTO `category_cat` VALUES (21, 0, 'Real Estates');
INSERT INTO `category_cat` VALUES (22, 21, 'Studios');
INSERT INTO `category_cat` VALUES (23, 21, 'Houses');

# --------------------------------------------------------

#
# Table structure for table `location_loc`
#

CREATE TABLE `location_loc` (
  `id_loc` int(11) NOT NULL auto_increment,
  `name_loc` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_loc`)
);

#
# Dumping data for table `location_loc`
#

INSERT INTO `location_loc` VALUES (1, 'Bucharest');
INSERT INTO `location_loc` VALUES (2, 'Rome');
INSERT INTO `location_loc` VALUES (3, 'Paris');
INSERT INTO `location_loc` VALUES (4, 'Timisoara');
INSERT INTO `location_loc` VALUES (5, 'San Francisco');
INSERT INTO `location_loc` VALUES (6, 'Detroit');
INSERT INTO `location_loc` VALUES (7, 'Washington');

# --------------------------------------------------------

#
# Table structure for table `subscribe_sub`
#

CREATE TABLE `subscribe_sub` (
  `id_sub` int(11) NOT NULL auto_increment,
  `idusr_sub` int(11) NOT NULL default '0',
  `idtyp_sub` int(11) NOT NULL default '0',
  `idcat_sub` tinyint(4) NOT NULL default '0',
  `idloc_sub` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_sub`),
  UNIQUE KEY `subunique_1` (`idusr_sub`,`idtyp_sub`,`idcat_sub`),
  KEY `idusr_sub` (`idusr_sub`),
  KEY `idtyp_sub` (`idtyp_sub`),
  KEY `idcat_sub` (`idcat_sub`)
);

#
# Dumping data for table `subscribe_sub`
#

INSERT INTO `subscribe_sub` VALUES (13, 6, 1, 8, 1);
INSERT INTO `subscribe_sub` VALUES (14, 6, 1, 17, 1);

# --------------------------------------------------------

#
# Table structure for table `type_typ`
#

CREATE TABLE `type_typ` (
  `id_typ` tinyint(4) NOT NULL auto_increment,
  `name_typ` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_typ`)
);

#
# Dumping data for table `type_typ`
#

INSERT INTO `type_typ` VALUES (1, 'For Sale');
INSERT INTO `type_typ` VALUES (2, 'Wanted');
INSERT INTO `type_typ` VALUES (3, 'Exchange');
INSERT INTO `type_typ` VALUES (4, 'Don`t Care');

# --------------------------------------------------------

#
# Table structure for table `user_usr`
#

CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `username_usr` varchar(32) NOT NULL default '',
  `password_usr` varchar(32) NOT NULL default '',
  `active_usr` tinyint(1) NOT NULL default '0',
  `level_usr` tinyint(1) NOT NULL default '0',
  `randomkey_usr` varchar(128) NOT NULL default '',
  `email_usr` varchar(64) NOT NULL default '',
  `name_usr` varchar(128) NOT NULL default '',
  `regdate_usr` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `username_usr` (`username_usr`),
  KEY `level_usr` (`level_usr`),
  KEY `active_usr` (`active_usr`),
  KEY `randomkey_usr` (`randomkey_usr`),
  KEY `password_usr` (`password_usr`)
);

#
# Dumping data for table `user_usr`
#

INSERT INTO `user_usr` VALUES (6, 'john', '63a9f0ea7bb98050796b649e85481845', 1, 0, 'fb515e2794b4b1fcb4726eb0f093287f', 'john@domain.org', 'John Doe', '2005-04-05');
INSERT INTO `user_usr` VALUES (7, 'jane', '63a9f0ea7bb98050796b649e85481845', 1, 0, 'ff6fa0615aff72bcef4b4db159ca79e4', 'jane@domain.org', 'Jane Doe', '2005-04-01');