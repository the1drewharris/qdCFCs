#
# Table structure for table `company_com`
#

CREATE TABLE `company_com` (
  `id_com` int(8) NOT NULL auto_increment,
  `idusr_com` int(8) NOT NULL default '0',
  `name_com` varchar(20) NOT NULL default '',
  `address_com` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id_com`)
);

#
# Dumping data for table `company_com`
#

INSERT INTO `company_com` VALUES (1, 3, 'InterAKT Online', '1-11 Economu Cezarescu ST, AYASH Center, Bucharest, Romania');
INSERT INTO `company_com` VALUES (2, 4, 'Macromedia', 'Macromedia, Inc., 600 Townsend Street, San Francisco, CA 94103, USA');
INSERT INTO `company_com` VALUES (3, 5, 'Oracle', 'Oracle Parkway, Thames Valley Park, London, United Kingdom');

# --------------------------------------------------------

#
# Table structure for table `cover_cvr`
#

CREATE TABLE `cover_cvr` (
  `id_cvr` int(10) NOT NULL auto_increment,
  `idusr_cvr` int(10) NOT NULL default '0',
  `letter_cvr` text NOT NULL,
  PRIMARY KEY  (`id_cvr`)
);

#
# Dumping data for table `cover_cvr`
#

INSERT INTO `cover_cvr` VALUES (1, 2, 'Dear Mr Atkinson: <br> Your advertisement for a Regional Sales Representative position fits my experience and qualifications perfectly, and I am writing to express my interest in and enthusiasm for the position. As an accomplished sales leader, I have achieved seven-figure revenue growth, international market penetration and successful product launches for leading global corporations during my career. In addition to my desire to join your team, you will find I am a dedicated and driven professional.');

# --------------------------------------------------------

#
# Table structure for table `domain_dom`
#

CREATE TABLE `domain_dom` (
  `id_dom` int(8) NOT NULL default '0',
  `name_dom` varchar(200) NOT NULL default ''
);

#
# Dumping data for table `domain_dom`
#

INSERT INTO `domain_dom` VALUES (1, 'Computers');
INSERT INTO `domain_dom` VALUES (2, 'Sales');
INSERT INTO `domain_dom` VALUES (3, 'Marketing');
INSERT INTO `domain_dom` VALUES (4, 'Finance');
INSERT INTO `domain_dom` VALUES (5, 'Advertising');
# --------------------------------------------------------

#
# Table structure for table `job_job`
#

CREATE TABLE `job_job` (
  `id_job` int(8) NOT NULL auto_increment,
  `idcom_job` int(8) NOT NULL default '0',
  `iddom_job` int(10) NOT NULL default '0',
   `idloc_job` int(20) NOT NULL default '0',
  `title_job` varchar(200) NOT NULL default '',
  `type_job` varchar(20) NOT NULL default '',
  `salary_job` int(11) NOT NULL default '0',
  `deadline_job` date NOT NULL default '0000-00-00',
  `detail_job` varchar(255) default NULL,
  PRIMARY KEY  (`id_job`)
);

#
# Dumping data for table `job_job`
#

INSERT INTO `job_job` VALUES (1, 1, 1, 1, 'Network Administrator', 'Full-time',  1500, '2005-03-25', 'Up to 2 years hardware integration experience required. Network systems experience is a plus. Must have solid PC working knowledge. Must possess interpersonal, organizational, analytical and troubleshooting skills.');
INSERT INTO `job_job` VALUES (2, 1, 2, 1,'Sales Representative', 'Full-time',  2500, '2005-06-12', 'Recent college graduates are welcome to apply. We are looking for producers and winners of sales awards. We want professional sales performers with 0-5 years of experience. Must show prior job stability.');

# --------------------------------------------------------

#
# Table structure for table `job_user_jbu`
#

CREATE TABLE `job_user_jbu` (
  `id_jbu` int(8) NOT NULL auto_increment,
  `idrsm_jbu` int(8) NOT NULL default '0',
  `idjob_jbu` int(8) NOT NULL default '0',
  `date_jbu` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id_jbu`)
);

#
# Dumping data for table `job_user_jbu`
#

INSERT INTO `job_user_jbu` VALUES (1, 1, 2, '2005-03-24');

# --------------------------------------------------------

#
# Table structure for table `location_loc`
#

CREATE TABLE `location_loc` (
  `id_loc` int(8) NOT NULL default '0',
  `name_loc` varchar(200) NOT NULL default ''
);

#
# Dumping data for table `location_loc`
#

INSERT INTO `location_loc` VALUES (1, 'New York');
INSERT INTO `location_loc` VALUES (2, 'Rome');
INSERT INTO `location_loc` VALUES (3, 'Berlin');
INSERT INTO `location_loc` VALUES (4, 'Viena');
INSERT INTO `location_loc` VALUES (5, 'Paris');

# --------------------------------------------------------

#
# Table structure for table `resume_rsm`
#

CREATE TABLE `resume_rsm` (
  `id_rsm` int(4) NOT NULL auto_increment,
  `idusr_rsm` int(4) NOT NULL default '0',
  `name_usr_rsm` varchar(200) NOT NULL default '',
  `phone_usr_rsm` varchar(20) NOT NULL default '0',
  `photo_usr_rsm` varchar(50) default NULL,
  `file_rsm` varchar(255) NOT NULL default '',
  `pref_domain_rsm` int(200) default NULL,
  `pref_location_rsm` int(200) default NULL,
  `pref_salary_rsm` int(20) default NULL,
  PRIMARY KEY  (`id_rsm`)
);

#
# Dumping data for table `resume_rsm`
#

INSERT INTO `resume_rsm` VALUES (1, 2, 'Michael Foster', 724568975, 'Mike.jpg', 'Foster_resume.pdf', '2', '2', 1300);

# --------------------------------------------------------

#
# Table structure for table `subscribe_sub`
#


CREATE TABLE `subscribe_sub` (
  `id_sub` int(10) NOT NULL auto_increment,
  `idusr_sub` int(10) NOT NULL default '0',
  `type_sub` varchar(255) NOT NULL default '',
  `iddom_sub` int(10) NOT NULL default '0',
  `location_sub` varchar(255) NOT NULL default '',
  `minsal_sub` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id_sub`)
);

#
# Table structure for table `user_usr`
#


CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `password_usr` varchar(100) NOT NULL default '',
  `active_usr` tinyint(2) NOT NULL default '0',
  `level_usr` tinyint(2) NOT NULL default '0',
  `email_usr` varchar(100) NOT NULL default '',
  `ntries_usr` smallint(6) NOT NULL default '0',
  `disabledate_usr` datetime NOT NULL default '0000-00-00 00:00:00',
  `registrationdate_usr` datetime NOT NULL default '0000-00-00 00:00:00',
  `expiration_usr` int(11) NOT NULL default '100',
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `email_usr` (`email_usr`)
);

#
# Dumping data for table `user_usr`
#

INSERT INTO `user_usr` VALUES (1, '63a9f0ea7bb98050796b649e85481845', 1, 0, 'admin@domain.org');
INSERT INTO `user_usr` VALUES (2, '63a9f0ea7bb98050796b649e85481845', 1, 0, 'mike@hisbusiness.com');
INSERT INTO `user_usr` VALUES (3, '63a9f0ea7bb98050796b649e85481845', 1, 1, 'hres@interakt.com');
INSERT INTO `user_usr` VALUES (4, '63a9f0ea7bb98050796b649e85481845', 1, 1, 'hr@macromedia.tk');
INSERT INTO `user_usr` VALUES (5, '63a9f0ea7bb98050796b649e85481845', 1, 1, 'recruit@oracle.info');
