#
# Table structure for table `products_prd`
#

CREATE TABLE `products_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `name_prd` varchar(200) NOT NULL default '',
  `price_prd` float NOT NULL default '0',
  `description_prd` text NOT NULL,
  PRIMARY KEY  (`id_prd`),
  UNIQUE KEY `product name` (`name_prd`),
  FULLTEXT KEY `description_prd` (`description_prd`)
);

#
# Dumping data for table `products_prd`
#

INSERT INTO `products_prd` VALUES (40, 'Logitech camera', '100', 'This streamlined Logitech camera will allow you to do videoconferences with friend and partners all over the world');
INSERT INTO `products_prd` VALUES (41, 'Logitech advanced camera', '150', 'The advanced Logitech camera captures video streams directly into DivX 4 format, using an embedded processor that makes videostreaming over a slow Internet connection a reality.');
INSERT INTO `products_prd` VALUES (42, 'Logitech professional camera', '200', 'The Professional Logitech camera captures video streams directly into MPEG 4 - DivX&nbsp;5 format, using an embedded processor and a FireWire connection that makes videostreaming over a slow Internet connection a reality.');
INSERT INTO `products_prd` VALUES (43, 'Snake Camera', '300', '<DIV>This special camera plugs directly into your USB port on your laptop, and also includes a "snake" like cable that will allow you to place the camera in the most innacesible places. \r\n<P></P></DIV>');
INSERT INTO `products_prd` VALUES (44, 'Regular camera', '40', '<DIV>\r\n<P>Use this regular noname camera to transform any home computer into a video capturing workstation.</P></DIV>');
INSERT INTO `products_prd` VALUES (45, 'Microsoft natural keyboard', '53', '<DIV>The most ergonomic keyboard on Earth, the Microsoft Natural Keyboard will transform typing into a pleasure for your hands\r\n<P></P></DIV>');
INSERT INTO `products_prd` VALUES (46, 'Logitec laptop keyboard', '100', '<DIV>If you need a serious replacement for your laptop keyboard, the Logitech choice will offer you the best value and reliability. Compatible with Toshiba, Dell and Acer laptops</DIV>');
INSERT INTO `products_prd` VALUES (47, 'Cool-board', '60', '<DIV>\r\n<P>A blak, slim, keyboard that will fit near your LCD screen in a geeky desktop environment</P></DIV>');
INSERT INTO `products_prd` VALUES (48, 'Logitec red fury', '25', '<DIV>A fine looking mouse that connects using USB or PS2 to your computer. Standard resolution only.\r\n<P></P></DIV>');
INSERT INTO `products_prd` VALUES (49, 'Logitec wireless', '100', 'A fine resolution Logitec mouse that will make your games move much smoother, as the special 800dpi resolution will register your finest moves.');
INSERT INTO `products_prd` VALUES (50, 'Microsoft standard mouse', '25', '<DIV>A simple mouse from Microsoft - reliability for the Office.\r\n<P></P></DIV>');
INSERT INTO `products_prd` VALUES (51, 'Microsoft wireless mouse', '90', '<DIV>A wireless mouse from Microsoft - reliability and flexibility for the home workstation and gamestation. \r\n<P></P></DIV>');
INSERT INTO `products_prd` VALUES (52, 'Athlon XP 2000+', '100', 'A processor based on the Barton core, 1.666 Ghz real frequency, 2000+ Performance Rating, 512 L1 cache and more horsepower for your games and applications');
INSERT INTO `products_prd` VALUES (53, 'Pentium IV 2.6 Ghz', '120', 'A processor based on the Palomino core, 2.6 Ghz real frequency, 512 L1 cache and the SSE optimized instruction set for maximum multimedia performance');
INSERT INTO `products_prd` VALUES (54, 'Nokia communicator', '400', 'This is the most useful mobile device, with phone and handheld capabilities');
INSERT INTO `products_prd` VALUES (55, 'Compaq iPAQ Pocket PC', '200', 'Powerful computing in the palm of your hand');
INSERT INTO `products_prd` VALUES (56, 'DELL Inspiron 5100 PC Notebook', '1850', 'Feel Inspired by this Inspiron! - Desktop Power with Laptop Mobility \r\n<P></P>');
INSERT INTO `products_prd` VALUES (59, 'Toshiba Satellite', '1049', 'Satellite includes entry-level, small business and high-end multimedia');
INSERT INTO `products_prd` VALUES (57, 'Apple iBook', '600', 'Perfect for everything from work to playing games');
INSERT INTO `products_prd` VALUES (58, 'PowerBook', '1500', 'Perfect for the college student or Mobile professional, this PowerBook from Apple gives you a powerful &amp; feature-rich machine, in a lightweight &amp; highly mobile package.');
INSERT INTO `products_prd` VALUES (60, 'PC2100 SDRAM 256 MB', '67', '184-pin DIMMs are used to provide DDR SDRAM memory for desktop computers');
INSERT INTO `products_prd` VALUES (61, 'PC133 SDRAM 256 MB', '60', 'Memory description');
INSERT INTO `products_prd` VALUES (62, 'Motherboard1', '150', 'Motherboard1 description');
INSERT INTO `products_prd` VALUES (63, 'Motherboard2', '160', 'Motherboard2 description');
INSERT INTO `products_prd` VALUES (64, 'Motherboard3', '180', 'Motherboard3 description');
INSERT INTO `products_prd` VALUES (65, 'Motherboard4', '157', 'Motherboard4 description');
INSERT INTO `products_prd` VALUES (66, 'Motherboard5', '170', 'Motherboard5 description');
INSERT INTO `products_prd` VALUES (67, 'Motherboard6', '147', 'Motherboard6 description');
INSERT INTO `products_prd` VALUES (68, 'Hub1', '50', 'Hub1 description');
INSERT INTO `products_prd` VALUES (69, 'Hub2', '47', 'Hub2 description');
INSERT INTO `products_prd` VALUES (70, 'Switch1', '80', 'Switch1 description');
INSERT INTO `products_prd` VALUES (71, 'CD-ROM 1', '35', 'CD-ROM 1 description');
INSERT INTO `products_prd` VALUES (72, 'DVD-ROM 1', '100', 'DVD-ROM 1 description');
INSERT INTO `products_prd` VALUES (73, 'DVD-ROM 2', '87', 'DVD-ROM 2 description');
INSERT INTO `products_prd` VALUES (74, 'HDD1', '73', 'HDD1 description');
INSERT INTO `products_prd` VALUES (75, 'HDD2', '100', 'HDD2 description');
INSERT INTO `products_prd` VALUES (76, 'Flash Drive 1', '100', 'Flash Drive 1 description');
INSERT INTO `products_prd` VALUES (77, 'Flash Drive 2', '99', 'Flash Drive 2 description');
INSERT INTO `products_prd` VALUES (78, 'Video Card 1', '40', 'Video Card 1 description');
INSERT INTO `products_prd` VALUES (79, 'one cent product', '0.01', '<DIV>One cent product \r\n<P></P>\r\n<P>Use for Payment Gateway testing</P></DIV>');