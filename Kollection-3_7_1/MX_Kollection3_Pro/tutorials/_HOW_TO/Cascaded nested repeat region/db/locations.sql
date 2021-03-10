# --------------------------------------------------------

#
# Table structure for table `city_cit`
#

CREATE TABLE `city_cit` (
  `id_cit` int(11) NOT NULL auto_increment,
  `idcnt_cit` int(11) NOT NULL default '0',
  `name_cit` varchar(150) NOT NULL default '',
  PRIMARY KEY  (`id_cit`),
  UNIQUE KEY `name_cit` (`name_cit`)
);

#
# Dumping data for table `city_cit`
#

INSERT INTO `city_cit` VALUES (1, 5, 'Perth');
INSERT INTO `city_cit` VALUES (2, 5, 'Sydney');
INSERT INTO `city_cit` VALUES (3, 5, 'Canberra');
INSERT INTO `city_cit` VALUES (4, 17, 'Paris');
INSERT INTO `city_cit` VALUES (5, 17, 'Lyon');
INSERT INTO `city_cit` VALUES (6, 17, 'Toulouse');
INSERT INTO `city_cit` VALUES (7, 36, 'New York');
INSERT INTO `city_cit` VALUES (8, 36, 'San Francisco');
INSERT INTO `city_cit` VALUES (9, 36, 'Los Angeles');

# --------------------------------------------------------

#
# Table structure for table `continent_con`
#

CREATE TABLE `continent_con` (
  `id_con` tinyint(3) unsigned NOT NULL auto_increment,
  `name_con` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id_con`)
);

#
# Dumping data for table `cotinent_con`
#

INSERT INTO `continent_con` VALUES (1, 'Asia');
INSERT INTO `continent_con` VALUES (2, 'Africa');
INSERT INTO `continent_con` VALUES (3, 'Europe');
INSERT INTO `continent_con` VALUES (4, 'South America');
INSERT INTO `continent_con` VALUES (5, 'North America');
INSERT INTO `continent_con` VALUES (6, 'Australia & Oceania');

# --------------------------------------------------------

#
# Table structure for table `country_cnt`
#

CREATE TABLE `country_cnt` (
  `id_cnt` int(8) unsigned NOT NULL auto_increment,
  `name_cnt` varchar(50) NOT NULL default '',
  `idcon_cnt` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id_cnt`)
);

#
# Dumping data for table `country_cnt`
#

INSERT INTO `country_cnt` VALUES (1, 'Afghanistan', 1);
INSERT INTO `country_cnt` VALUES (2, 'Albania', 3);
INSERT INTO `country_cnt` VALUES (3, 'Algeria', 2);
INSERT INTO `country_cnt` VALUES (4, 'Argentina', 4);
INSERT INTO `country_cnt` VALUES (5, 'Australia', 6);
INSERT INTO `country_cnt` VALUES (6, 'Austria', 3);
INSERT INTO `country_cnt` VALUES (7, 'Bangladesh', 1);
INSERT INTO `country_cnt` VALUES (8, 'Belgium', 3);
INSERT INTO `country_cnt` VALUES (9, 'Brazil', 4);
INSERT INTO `country_cnt` VALUES (10, 'Cameroon', 2);
INSERT INTO `country_cnt` VALUES (11, 'Canada', 5);
INSERT INTO `country_cnt` VALUES (12, 'Chile', 4);
INSERT INTO `country_cnt` VALUES (13, 'China', 1);
INSERT INTO `country_cnt` VALUES (14, 'Denmark', 3);
INSERT INTO `country_cnt` VALUES (15, 'Egypt', 2);
INSERT INTO `country_cnt` VALUES (16, 'Ethiopia', 2);
INSERT INTO `country_cnt` VALUES (17, 'France', 3);
INSERT INTO `country_cnt` VALUES (18, 'Germany', 3);
INSERT INTO `country_cnt` VALUES (19, 'Ghana', 2);
INSERT INTO `country_cnt` VALUES (20, 'Greece', 3);
INSERT INTO `country_cnt` VALUES (21, 'India', 1);
INSERT INTO `country_cnt` VALUES (22, 'Ireland', 3);
INSERT INTO `country_cnt` VALUES (23, 'Italy', 3);
INSERT INTO `country_cnt` VALUES (24, 'Japan', 1);
INSERT INTO `country_cnt` VALUES (25, 'Kenya', 2);
INSERT INTO `country_cnt` VALUES (26, 'Mexico', 5);
INSERT INTO `country_cnt` VALUES (27, 'Mozambique', 2);
INSERT INTO `country_cnt` VALUES (28, 'Namibia', 2);
INSERT INTO `country_cnt` VALUES (29, 'Netherlands', 3);
INSERT INTO `country_cnt` VALUES (30, 'New Zealand', 5);
INSERT INTO `country_cnt` VALUES (31, 'Pakistan', 2);
INSERT INTO `country_cnt` VALUES (32, 'Peru', 4);
INSERT INTO `country_cnt` VALUES (33, 'Solomon Islands', 6);
INSERT INTO `country_cnt` VALUES (34, 'Tonga', 6);
INSERT INTO `country_cnt` VALUES (35, 'Tuvalu', 6);
INSERT INTO `country_cnt` VALUES (36, 'United States', 5);
INSERT INTO `country_cnt` VALUES (37, 'Vanuatu', 6);
INSERT INTO `country_cnt` VALUES (38, 'Venezuela', 4);
INSERT INTO `country_cnt` VALUES (39, 'Zaire', 2);
INSERT INTO `country_cnt` VALUES (40, 'Zambia', 2);
INSERT INTO `country_cnt` VALUES (41, 'Zimbabwe', 2);
