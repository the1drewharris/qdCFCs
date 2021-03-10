CREATE TABLE `movie_mov` (
  `id_mov` int(11) NOT NULL auto_increment,
  `title_mov` varchar(255) NOT NULL default '',
  `order_mov` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_mov`)
);

#
# Dumping data for table `movie_mov`
#

INSERT INTO `movie_mov` VALUES (1, 'Titanic', 1);
INSERT INTO `movie_mov` VALUES (2, 'Dune', 2);
INSERT INTO `movie_mov` VALUES (3, 'Children of Dune', 3);
INSERT INTO `movie_mov` VALUES (4, 'Star Trek: Nemesis', 4);
INSERT INTO `movie_mov` VALUES (5, 'Ghost', 5);
INSERT INTO `movie_mov` VALUES (6, 'The Godfather', 6);
INSERT INTO `movie_mov` VALUES (7, 'Jurassic Park', 7);
INSERT INTO `movie_mov` VALUES (8, 'Terminator 3: The Judgement Day', 8);

