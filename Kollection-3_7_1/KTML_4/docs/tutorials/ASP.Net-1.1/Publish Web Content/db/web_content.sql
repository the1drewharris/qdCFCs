# 
# Table structure for table `product_prd`
# 

CREATE TABLE `product_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `name_prd` varchar(255) NOT NULL default '',
  `presentation_prd` text NOT NULL,
  PRIMARY KEY  (`id_prd`),
  UNIQUE KEY `name_prd` (`name_prd`)
);


# 
# Dumping data for table `product_prd`
# 

INSERT INTO `product_prd` VALUES (1, 'MX Kollection', 'Product presentation');
