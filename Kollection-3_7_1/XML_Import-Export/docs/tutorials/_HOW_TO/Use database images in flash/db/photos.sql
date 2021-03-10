#
# Table structure for table `photo_pht`
#

CREATE TABLE `photo_pht` (
  `id_pht` int(11) NOT NULL auto_increment,
  `file_pht` varchar(255) NOT NULL default '',
  `name_pht` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_pht`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

#
# Dumping data for table `photo_pht`
#

INSERT INTO `photo_pht` VALUES (1, 'images/fan_processor.jpg', 'Processor with cooling fan');
INSERT INTO `photo_pht` VALUES (2, 'images\\ibook.jpg', 'iBook laptop');
INSERT INTO `photo_pht` VALUES (3, 'images\\ipaq.jpg', 'Compaq iPaq');
INSERT INTO `photo_pht` VALUES (4, 'images\\laptop_keyboard.jpg', 'Laptop-like keyboard');
INSERT INTO `photo_pht` VALUES (5, 'images\\microsoft_mouse.jpg', 'Microsoft mouse');
INSERT INTO `photo_pht` VALUES (6, 'images\\natural_keyboard.jpg', 'Microsoft Natural Keyboard');
INSERT INTO `photo_pht` VALUES (7, 'images\\nokia_phone.jpg', 'Nokia Phone');
INSERT INTO `photo_pht` VALUES (8, 'plain_mouse.jpg', 'Simple mouse');
INSERT INTO `photo_pht` VALUES (9, 'images\\powerbook.jpg', 'PowerBook computer');
INSERT INTO `photo_pht` VALUES (10, 'images\\processor.jpg', 'Simple processor');
INSERT INTO `photo_pht` VALUES (11, 'images\\webcam1.jpg', 'Logitech WebCam');
INSERT INTO `photo_pht` VALUES (12, 'images\\wireless_keyboard.jpg', 'Wireless Keyboard');
    


