#
# Table structure for table `company_com`
#

CREATE TABLE `company_com` (
  `id_com` int(11) NOT NULL auto_increment,
  `name_com` varchar(100) NOT NULL default '',
  `address_com` text NOT NULL,
  PRIMARY KEY  (`id_com`)
);

#
# Dumping data for table `company_com`
#

INSERT INTO `company_com` VALUES (1, 'InterAKT Online', '1-11 Economu Cezarescu ST, AYASH Center, Bucharest, Romania');
INSERT INTO `company_com` VALUES (2, 'Macromedia', 'Macromedia, Inc., 600 Townsend Street, San Francisco, CA 94103, USA');
INSERT INTO `company_com` VALUES (3, 'Oracle', 'Oracle Parkway, Thames Valley Park, London, United Kingdom');

# --------------------------------------------------------

#
# Table structure for table `contact_con`
#

CREATE TABLE `contact_con` (
  `id_con` int(11) NOT NULL auto_increment,
  `idcom_con` int(11) NOT NULL default '0',
  `name_con` varchar(50) NOT NULL default '',
  `job_con` varchar(100) NOT NULL default '',
  `email_con` varchar(255) NOT NULL default '',
  `phone_con` varchar(30) NOT NULL default '',
  `birthday_con` date default NULL,
  PRIMARY KEY  (`id_con`),
  KEY `idcom_con` (`idcom_con`)
);

#
# Dumping data for table `contact_con`
#

INSERT INTO `contact_con` VALUES (1, 1, 'Alex Colorado', 'Programmer', 'alexcolorado@interakt.org', '+4021 333.55.91', '1978-10-30');
INSERT INTO `contact_con` VALUES (2, 1, 'Chris Benton', 'Designer', 'benton@interakt.ro', '+4021 315.14.19', '1980-01-14');
INSERT INTO `contact_con` VALUES (3, 1, 'Nikita Jelinski', 'Sales Manager', 'njelinski@domain.com', '', NULL);
INSERT INTO `contact_con` VALUES (4, 2, 'George Palmer', 'Software Analyst', 'gpalmer@macromedia.net', '', '1966-03-14');
INSERT INTO `contact_con` VALUES (5, 2, 'Tony Norberto', 'HR Recruiter', 'tony@macromedia.net', '+(415) 600-0554', NULL);
INSERT INTO `contact_con` VALUES (6, 3, 'Mark Johnson', 'Programmer', 'mjohnson@oracle.tk', '+(415) 800-201-554', NULL);
INSERT INTO `contact_con` VALUES (7, 3, 'Adrian Segata', 'Technical Writer', 'segata@oracle.tk', '+(410) 450-300-200', '1982-08-25');