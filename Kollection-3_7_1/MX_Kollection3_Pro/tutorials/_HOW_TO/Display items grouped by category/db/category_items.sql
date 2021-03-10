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
# Dumping data for table `continent_con`
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

INSERT INTO `country_cnt` VALUES (1, 'Austria', 3);
INSERT INTO `country_cnt` VALUES (2, 'Bangladesh', 1);
INSERT INTO `country_cnt` VALUES (3, 'Egypt', 2);
INSERT INTO `country_cnt` VALUES (4, 'Spain', 3);
INSERT INTO `country_cnt` VALUES (5, 'China', 1);
INSERT INTO `country_cnt` VALUES (6, 'Australia', 6);
INSERT INTO `country_cnt` VALUES (7, 'Norway', 3);
INSERT INTO `country_cnt` VALUES (8, 'Venezuela', 4);
INSERT INTO `country_cnt` VALUES (9, 'Denmark', 3);
INSERT INTO `country_cnt` VALUES (10, 'France', 3);
INSERT INTO `country_cnt` VALUES (11, 'Afghanistan', 1);
INSERT INTO `country_cnt` VALUES (12, 'Mexico', 5);
INSERT INTO `country_cnt` VALUES (13, 'India', 1);
INSERT INTO `country_cnt` VALUES (14, 'Peru', 4);
INSERT INTO `country_cnt` VALUES (15, 'Mozambique', 2);
INSERT INTO `country_cnt` VALUES (16, 'Ethiopia', 2);
INSERT INTO `country_cnt` VALUES (17, 'Zimbabwe', 2);
INSERT INTO `country_cnt` VALUES (18, 'Argentina', 4);
INSERT INTO `country_cnt` VALUES (19, 'Romania', 3);
INSERT INTO `country_cnt` VALUES (20, 'Chile', 4);
INSERT INTO `country_cnt` VALUES (21, 'Japan', 1);
INSERT INTO `country_cnt` VALUES (22, 'Canada', 5);
INSERT INTO `country_cnt` VALUES (23, 'United States', 5);
INSERT INTO `country_cnt` VALUES (24, 'Vanuatu', 6);
INSERT INTO `country_cnt` VALUES (25, 'Solomon Islands', 6);
INSERT INTO `country_cnt` VALUES (26, 'Germany', 3);
INSERT INTO `country_cnt` VALUES (27, 'Greece', 3);
INSERT INTO `country_cnt` VALUES (28, 'Italy', 3);
INSERT INTO `country_cnt` VALUES (29, 'Poland', 3);
INSERT INTO `country_cnt` VALUES (30, 'Portugal', 3);
INSERT INTO `country_cnt` VALUES (31, 'Croatia', 3);
INSERT INTO `country_cnt` VALUES (32, 'Bulgaria', 3);
INSERT INTO `country_cnt` VALUES (33, 'Finland', 3);
