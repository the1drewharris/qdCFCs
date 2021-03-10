#
# Table structure for table `ord_ord`
#

CREATE TABLE `ord_ord` (
  `id_ord` int(20) NOT NULL auto_increment,
  `idusr_ord` int(20) NOT NULL default '0',
  `date_ord` date NOT NULL default '0000-00-00',
  `idsta_ord` int(5) NOT NULL default '0',
  `sesid_ord` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_ord`)
);

# --------------------------------------------------------

#
# Table structure for table `ord_product_opr`
#

CREATE TABLE `ord_product_opr` (
  `id_opr` int(20) NOT NULL auto_increment,
  `idprd_opr` int(20) NOT NULL default '0',
  `idord_opr` int(20) NOT NULL default '0',
  `quantity_opr` int(10) NOT NULL default '0',
  PRIMARY KEY  (`id_opr`)
);

# --------------------------------------------------------

#
# Table structure for table `product_prd`
#

CREATE TABLE `product_prd` (
  `id_prd` int(20) NOT NULL auto_increment,
  `name_prd` varchar(255) NOT NULL default '',
  `price_prd` int(20) NOT NULL default '0',
  `quantity_prd` int(20) NOT NULL default '0',
  PRIMARY KEY  (`id_prd`)
);

# --------------------------------------------------------
INSERT INTO `product_prd` VALUES (1, 'Mouse', 25, 0);
INSERT INTO `product_prd` VALUES (2, 'Keyboard', 30, 13);
INSERT INTO `product_prd` VALUES (3, 'Monitor 17"', 150, 5);

#
# Table structure for table `status_sta`
#

CREATE TABLE `status_sta` (
  `id_sta` int(20) NOT NULL,
  `name_sta` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_sta`)
);

# --------------------------------------------------------

INSERT INTO `status_sta` VALUES (0, 'Initiated'); 
INSERT INTO `status_sta` VALUES (1, 'Pending'); 
INSERT INTO `status_sta` VALUES (2, 'Waiting for acknowledgement'); 
INSERT INTO `status_sta` VALUES (4, 'Processing'); 
INSERT INTO `status_sta` VALUES (3, 'Acknowledged'); 


#
# Table structure for table `user_usr`
#

CREATE TABLE `user_usr` (
  `id_usr` int(20) NOT NULL auto_increment,
  `name_usr` varchar(255) NOT NULL default '',
  `password_usr` varchar(255) NOT NULL default '',
  `active_usr` tinyint(2) NOT NULL default '0',
  `level_usr` tinyint(2) NOT NULL default '0',
  `randomkey_usr` varchar(255) default NULL,
  `email_usr` varchar(255) NOT NULL default '',
  `address_usr` varchar(255) default '',
  PRIMARY KEY  (`id_usr`),
  UNIQUE KEY `name_usr` (`name_usr`),
  UNIQUE KEY `email_usr` (`email_usr`)
);

INSERT INTO `user_usr` VALUES (1, 'John Doe', '63a9f0ea7bb98050796b649e85481845', 0, 0, '361d32a9064ac6cc42351679e8c62f11', 'johndoe@domain.org', '15, Rue Park str. Washington');
INSERT INTO `user_usr` VALUES (2, 'Jane', '63a9f0ea7bb98050796b649e85481845', 0, 0, '97fc297100f83c9b220d156281f8cb84', 'jane@domain.org', '32 Philladelphia street');

