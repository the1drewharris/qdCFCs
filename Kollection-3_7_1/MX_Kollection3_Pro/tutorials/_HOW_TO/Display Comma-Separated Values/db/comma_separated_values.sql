-- 
-- Table structure for table `language_lan`
-- 

CREATE TABLE `language_lan` (
  `id_lan` int(11) NOT NULL auto_increment,
  `name_lan` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_lan`)
);

-- 
-- Dumping data for table `language_lan`
-- 

INSERT INTO `language_lan` VALUES (1, 'English');
INSERT INTO `language_lan` VALUES (2, 'French');
INSERT INTO `language_lan` VALUES (3, 'Spanish');
INSERT INTO `language_lan` VALUES (4, 'Romanian');
INSERT INTO `language_lan` VALUES (5, 'Chinese');
INSERT INTO `language_lan` VALUES (6, 'Japanesse');

-- --------------------------------------------------------

-- 
-- Table structure for table `student_std`
-- 

CREATE TABLE `student_std` (
  `id_std` int(11) NOT NULL auto_increment,
  `name_std` varchar(255) NOT NULL default '',
  `languages_std` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_std`)
);

-- 
-- Dumping data for table `student_std`
-- 

INSERT INTO `student_std` VALUES (1, 'John Doe', '1,4,6');
INSERT INTO `student_std` VALUES (2, 'Jane Doe', '2,3,5');
INSERT INTO `student_std` VALUES (3, 'Danielle Simpson', '2,4');