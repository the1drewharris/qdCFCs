#
# Table structure for table `album_alb`
#

CREATE TABLE `album_alb` (
  `id_alb` int(11) NOT NULL auto_increment,
  `title_alb` varchar(100) NOT NULL default '',
  `description_alb` varchar(255) NOT NULL default '',
  `date_alb` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id_alb`),
  UNIQUE KEY `title_alb` (`title_alb`)
);

#
# Dumping data for table `album_alb`
#

INSERT INTO `album_alb` VALUES (1, 'Vacations', 'Whether in mountains, or at the seaside, I always spend a wonderful time with my family.', '2004-12-09');
INSERT INTO `album_alb` VALUES (2, 'Conferences', 'Last year I participated in several IT conferences. Here are some of the events I attended.', '2003-10-05');
INSERT INTO `album_alb` VALUES (3, 'Home, sweet home', 'Some pictures with my house, my wife, my kids and my dog.', '2005-02-01');

# --------------------------------------------------------

#
# Table structure for table `image_img`
#

CREATE TABLE `image_img` (
  `id_img` int(11) NOT NULL auto_increment,
  `idalb_img` int(11) NOT NULL default '0',
  `filename_img` varchar(100) NOT NULL default '',
  `description_img` varchar(255) NOT NULL default '',
  `date_img` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id_img`)
);

#
# Dumping data for table `image_img`
#

INSERT INTO `image_img` VALUES (1, 3, 'Laura.jpg', 'My daughter, Laura, and our dog, Dino.', '2005-03-01 09:38:32');
INSERT INTO `image_img` VALUES (2, 3, 'Dino.gif', 'Dino playing in the garden.', '2005-04-01 16:38:32');
INSERT INTO `image_img` VALUES (3, 1, 'Winter.jpg', 'Christmas morning in the Alps.', '2005-04-01 16:45:17');
INSERT INTO `image_img` VALUES (4, 1, 'Sunset.jpg', 'Breath-taking sunset in Malibu.', '2005-02-14 17:40:21');
INSERT INTO `image_img` VALUES (5, 2, 'London.jpg', 'Urban Transportation Conference in London.', '2005-03-25 16:38:25');
INSERT INTO `image_img` VALUES (6, 2, 'Paris.jpg', 'Environmental Protection Conference in Paris', '2005-04-01 10:38:10');