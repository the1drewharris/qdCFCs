-- 
-- Table structure for table `feature_fet`
-- 

CREATE TABLE `feature_fet` (
  `id_fet` int(11) NOT NULL auto_increment,
  `idprd_fet` int(11) NOT NULL default '0',
  `description_fet` text NOT NULL,
  `media_fet` varchar(255) default NULL,
  PRIMARY KEY  (`id_fet`)
);

-- 
-- Dumping data for table `feature_fet`
-- 

INSERT INTO `feature_fet` VALUES (1, 1, 'MX Kollection 3 is a bundle of our most popular MX extensions that will change the way you build dynamic websites with Dreamweaver. If you are a ColdFusion, ASP VB or PHP developer you will find that our product will enable you to develop e-Commerce, CMS, CRM, back-end and other web-based solutions with increased efficiency, quality and capability. Our customers think of it as the next level in Dreamweaver MX visual software development.', 'mx_kollection3.swf');
INSERT INTO `feature_fet` VALUES (2, 1, 'Using MX File Upload you can now create your own image galleries or file repositories within minutes. You can select how to resize the image, allowed only specific file types, set maximum file size and choose how to save the file names in the database without any programming knowledge.', 'file_upload_v3small.swf');

-- --------------------------------------------------------

-- 
-- Table structure for table `product_prd`
-- 

CREATE TABLE `product_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `name_prd` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_prd`)
);

-- 
-- Dumping data for table `product_prd`
-- 

INSERT INTO `product_prd` VALUES (1, 'MX Kollection');
INSERT INTO `product_prd` VALUES (2, 'MX Kommerce');
INSERT INTO `product_prd` VALUES (3, 'MX Includes');
INSERT INTO `product_prd` VALUES (4, 'MX Spring Pack');