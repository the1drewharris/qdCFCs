#
# Table structure for table `category_ctg`
#

CREATE TABLE `category_ctg` (
  `id_ctg` int(11) NOT NULL auto_increment,
  `name_ctg` varchar(100) NOT NULL default '',
  `description_ctg` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_ctg`),
  UNIQUE KEY `unique_name` (`name_ctg`)
);

#
# Dumping data for table `category_ctg`
#

INSERT INTO `category_ctg` VALUES (46, 'Input', 'Input devices');
INSERT INTO `category_ctg` VALUES (47, 'Cameras', 'Computer cameras');
INSERT INTO `category_ctg` VALUES (48, 'Keyboards', 'Computer keyboards');
INSERT INTO `category_ctg` VALUES (49, 'Mice', 'Computer mice');
INSERT INTO `category_ctg` VALUES (50, 'Processors', 'Central Processing Unit');
INSERT INTO `category_ctg` VALUES (51, 'Handheld', 'Portable device');
INSERT INTO `category_ctg` VALUES (52, 'Laptop', 'Portable computers');
INSERT INTO `category_ctg` VALUES (53, 'Memory', 'Memory modules');
INSERT INTO `category_ctg` VALUES (54, 'Motherboard', 'Motherboards');
INSERT INTO `category_ctg` VALUES (55, 'Network', 'Network components and devices');
INSERT INTO `category_ctg` VALUES (56, 'Hub', 'A common connection point for devices in a network');
INSERT INTO `category_ctg` VALUES (57, 'Storage', 'Storage devices');
INSERT INTO `category_ctg` VALUES (58, 'CD', 'CD-ROMs');
INSERT INTO `category_ctg` VALUES (59, 'HDD', 'Hard Disks');
INSERT INTO `category_ctg` VALUES (60, 'FDD', 'Floppy Disks');
INSERT INTO `category_ctg` VALUES (61, 'Flash', 'Flash Drives');
INSERT INTO `category_ctg` VALUES (62, 'DVD', 'DVD-ROMs');
INSERT INTO `category_ctg` VALUES (63, 'Video', 'Video devices');

# --------------------------------------------------------

#
# Table structure for table `product_prd`
#

CREATE TABLE `product_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `idctg_prd` int(11) NOT NULL default '0',
  `name_prd` varchar(200) NOT NULL default '',
  `price_prd` float NOT NULL default '0',
  `description_prd` text NOT NULL,
  PRIMARY KEY  (`id_prd`),
  UNIQUE KEY `product name` (`idctg_prd`,`name_prd`),
  KEY `idctg_prd` (`idctg_prd`),
  FULLTEXT KEY `description_prd` (`description_prd`)
);

#
# Dumping data for table `product_prd`
#

INSERT INTO `product_prd` VALUES (40, 47, 'Logitech camera', '100', 'This streamlined Logitech camera will allow you to do videoconferences with friend and partners all over the world');
INSERT INTO `product_prd` VALUES (41, 47, 'Logitech advanced camera', '150', 'The advanced Logitech camera captures video streams directly into DivX 4 format, using an embedded processor that makes videostreaming over a slow Internet connection a reality.');
INSERT INTO `product_prd` VALUES (42, 47, 'Logitech professional camera', '200', 'The Professional Logitech camera captures video streams directly into MPEG 4 - DivX&nbsp;5 format, using an embedded processor and a FireWire connection that makes videostreaming over a slow Internet connection a reality.');
INSERT INTO `product_prd` VALUES (43, 47, 'Snake Camera', '300', '<DIV>This special camera plugs directly into your USB port on your laptop, and also includes a "snake" like cable that will allow you to place the camera in the most innacesible places. \r\n<P></P></DIV>');
INSERT INTO `product_prd` VALUES (44, 47, 'Regular camera', '40', '<DIV>\r\n<P>Use this regular noname camera to transform any home computer into a video capturing workstation.</P></DIV>');
INSERT INTO `product_prd` VALUES (45, 48, 'Microsoft natural keyboard', '53', '<DIV>The most ergonomic keyboard on Earth, the Microsoft Natural Keyboard will transform typing into a pleasure for your hands\r\n<P></P></DIV>');
INSERT INTO `product_prd` VALUES (46, 48, 'Logitec laptop keyboard', '100', '<DIV>If you need a serious replacement for your laptop keyboard, the Logitech choice will offer you the best value and reliability. Compatible with Toshiba, Dell and Acer laptops</DIV>');
INSERT INTO `product_prd` VALUES (47, 48, 'Cool-board', '60', '<DIV>\r\n<P>A blak, slim, keyboard that will fit near your LCD screen in a geeky desktop environment</P></DIV>');
INSERT INTO `product_prd` VALUES (48, 49, 'Logitec red fury', '25', '<DIV>A fine looking mouse that connects using USB or PS2 to your computer. Standard resolution only.\r\n<P></P></DIV>');
INSERT INTO `product_prd` VALUES (49, 49, 'Logitec wireless', '100', 'A fine resolution Logitec mouse that will make your games move much smoother, as the special 800dpi resolution will register your finest moves.');
INSERT INTO `product_prd` VALUES (50, 49, 'Microsoft standard mouse', '25', '<DIV>A simple mouse from Microsoft - reliability for the Office.\r\n<P></P></DIV>');
INSERT INTO `product_prd` VALUES (51, 49, 'Microsoft wireless mouse', '90', '<DIV>A wireless mouse from Microsoft - reliability and flexibility for the home workstation and gamestation. \r\n<P></P></DIV>');
INSERT INTO `product_prd` VALUES (52, 50, 'Athlon XP 2000+', '100', 'A processor based on the Barton core, 1.666 Ghz real frequency, 2000+ Performance Rating, 512 L1 cache and more horsepower for your games and applications');
INSERT INTO `product_prd` VALUES (53, 50, 'Pentium IV 2.6 Ghz', '120', 'A processor based on the Palomino core, 2.6 Ghz real frequency, 512 L1 cache and the SSE optimized instruction set for maximum multimedia performance');
INSERT INTO `product_prd` VALUES (54, 51, 'Nokia communicator', '400', 'This is the most useful mobile device, with phone and handheld capabilities');
INSERT INTO `product_prd` VALUES (55, 51, 'Compaq iPAQ Pocket PC', '200', 'Powerful computing in the palm of your hand');
INSERT INTO `product_prd` VALUES (56, 52, 'DELL Inspiron 5100 PC Notebook', '1850', 'Feel Inspired by this Inspiron! - Desktop Power with Laptop Mobility \r\n<P></P>');
INSERT INTO `product_prd` VALUES (59, 52, 'Toshiba Satellite', '1049', 'Satellite includes entry-level, small business and high-end multimedia');
INSERT INTO `product_prd` VALUES (57, 52, 'Apple iBook', '600', 'Perfect for everything from work to playing games');
INSERT INTO `product_prd` VALUES (58, 52, 'PowerBook', '1500', 'Perfect for the college student or Mobile professional, this PowerBook from Apple gives you a powerful &amp; feature-rich machine, in a lightweight &amp; highly mobile package.');
