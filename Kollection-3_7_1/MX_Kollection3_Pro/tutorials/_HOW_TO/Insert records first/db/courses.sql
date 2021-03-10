#
# Table structure for table `courses_crs`
#

CREATE TABLE `courses_crs` (
  `id_crs` int(20) NOT NULL auto_increment,
  `name_crs` varchar(255) NOT NULL default '',
  `order_crs` int(20) NOT NULL default '0',
  PRIMARY KEY  (`id_crs`)
);
#
# Dumping data for Table 'courses_crs'
#

INSERT INTO `courses_crs` VALUES (1, 'Mathematics', 1);
INSERT INTO `courses_crs` VALUES (2, 'Physics', 2);
INSERT INTO `courses_crs` VALUES (3, 'Geometry', 3);
INSERT INTO `courses_crs` VALUES (4, 'Chemistry', 4);
INSERT INTO `courses_crs` VALUES (5, 'History', 5);
