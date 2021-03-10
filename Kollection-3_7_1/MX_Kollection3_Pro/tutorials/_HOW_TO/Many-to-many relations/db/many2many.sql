-- Table structure for table `course_crs`
-- 

CREATE TABLE `course_crs` (
  `id_crs` int(4) NOT NULL auto_increment,
  `name_crs` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id_crs`)
);

-- 
-- Dumping data for table `course_crs`
-- 

INSERT INTO `course_crs` VALUES (1, 'Geography');
INSERT INTO `course_crs` VALUES (2, 'Chemistry');
INSERT INTO `course_crs` VALUES (3, 'Physics');
INSERT INTO `course_crs` VALUES (4, 'Mathematics');
INSERT INTO `course_crs` VALUES (5, 'History');
INSERT INTO `course_crs` VALUES (6, 'Biology');
INSERT INTO `course_crs` VALUES (7, 'French Literature');
INSERT INTO `course_crs` VALUES (8, 'Writing');
INSERT INTO `course_crs` VALUES (9, 'Programming');

-- --------------------------------------------------------

-- 
-- Table structure for table `student_std`
-- 

CREATE TABLE `student_std` (
  `id_std` int(4) NOT NULL auto_increment,
  `name_std` varchar(100) NOT NULL default '',
  `email_std` varchar(200) default NULL,
  PRIMARY KEY  (`id_std`),
  UNIQUE KEY `email_std` (`email_std`)
);

-- 
-- Dumping data for table `student_std`
-- 

INSERT INTO `student_std` VALUES (1, 'John Doe', 'john@domain.edu');
INSERT INTO `student_std` VALUES (2, 'Jane Simpson', 'jane@domain.edu');
INSERT INTO `student_std` VALUES (3, 'Sue Palmer', 'sue@domain.edu');
INSERT INTO `student_std` VALUES (4, 'Jim Benson', 'jim@domain.edu');
INSERT INTO `student_std` VALUES (5, 'Gregory Johnson', 'greg@domain.edu');

-- --------------------------------------------------------

-- 
-- Table structure for table `student_to_course_stc`
-- 

CREATE TABLE `student_to_course_stc` (
  `idstd_stc` int(4) NOT NULL default '0',
  `idcrs_stc` int(4) NOT NULL default '0',
  UNIQUE KEY `idstd_stc` (`idstd_stc`,`idcrs_stc`)
);

-- 
-- Dumping data for table `student_to_course_stc`
-- 

INSERT INTO `student_to_course_stc` VALUES (1, 2);
INSERT INTO `student_to_course_stc` VALUES (1, 4);
