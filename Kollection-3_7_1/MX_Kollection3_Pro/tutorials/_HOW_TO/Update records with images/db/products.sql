#
# Table structure for table `product_prd`
#

CREATE TABLE `product_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `name_prd` varchar(255) default NULL,
  `description_prd` varchar(255) default NULL,
  `image_prd` varchar(255) default NULL,
  `price_prd` float(11,10) NOT NULL default '0.0000000000',
  PRIMARY KEY  (`id_prd`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

#
# Dumping data for table `product_prd`
#

INSERT INTO `product_prd` VALUES (2, 'Skin-Cream', 'Enhance the natural beauty of your skin with this healt-care cream.', 'blast_girl.png', '5.0000000000');
INSERT INTO `product_prd` VALUES (3, 'Dolls', 'Old fashioned mechanical doll that the small kids will love.', 'puppet01.jpg', '10.0000000000');
