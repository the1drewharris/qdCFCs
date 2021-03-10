#
# Table structure for table `firstproducts_fsp`
#

CREATE TABLE `firstproducts_fsp` (
  `id_fsp` int(11) NOT NULL auto_increment,
  `name_fsp` varchar(255) NOT NULL default '',
  `price_fsp` double(11,3) NOT NULL default '0.000',
  `quantity_fsp` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_fsp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

#
# Dumping data for table `firstproducts_fsp`
#

INSERT INTO `firstproducts_fsp` VALUES (1, '2.4 Ghz processor', '124.000', 50);
INSERT INTO `firstproducts_fsp` VALUES (2, 'Personal Web Cam', '15.000', 100);
INSERT INTO `firstproducts_fsp` VALUES (3, 'Regular camera', '40.000', 15);
INSERT INTO `firstproducts_fsp` VALUES (4, 'Microsoft natural keyboard', '53.000', 20);
INSERT INTO `firstproducts_fsp` VALUES (5, 'Logitec laptop keyboard', '100.000', 10);
INSERT INTO `firstproducts_fsp` VALUES (6, 'Cool-board', '60.000', 20);
INSERT INTO `firstproducts_fsp` VALUES (7, 'Logitec red fury', '25.000', 4);

# --------------------------------------------------------

#
# Table structure for table `secondproducts_scp`
#

CREATE TABLE `secondproducts_scp` (
  `id_scp` int(11) NOT NULL auto_increment,
  `name_scp` varchar(255) NOT NULL default '',
  `price_scp` double(11,3) NOT NULL default '0.000',
  `quantity_scp` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_scp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

#
# Dumping data for table `secondproducts_scp`
#

INSERT INTO `secondproducts_scp` VALUES (1, '2.4 Ghz processor', '124.000', 50);
INSERT INTO `secondproducts_scp` VALUES (2, 'Personal Web Cam', '15.000', 100);
INSERT INTO `secondproducts_scp` VALUES (3, 'Regular camera', '40.000', 15);
INSERT INTO `secondproducts_scp` VALUES (4, 'Microsoft natural keyboard', '53.000', 20);
INSERT INTO `secondproducts_scp` VALUES (5, 'Logitec laptop keyboard', '100.000', 10);
INSERT INTO `secondproducts_scp` VALUES (6, 'Cool-board', '60.000', 20);
INSERT INTO `secondproducts_scp` VALUES (7, 'Logitec red fury', '25.000', 4);
    

