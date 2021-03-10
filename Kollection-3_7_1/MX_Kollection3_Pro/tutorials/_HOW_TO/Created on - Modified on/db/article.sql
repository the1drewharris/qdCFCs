CREATE TABLE `article_art` ( 
	`id_art` int(11) NOT NULL auto_increment, 
	`title_art` varchar(255) NOT NULL default '', 
	`content_art` text NOT NULL, 	
	`createdon_art` datetime NOT NULL default '0000-00-00 00:00:00', 
	`modifiedon_art` datetime NOT NULL default '0000-00-00 00:00:00', 
	PRIMARY KEY (`id_art`) 
 );

#
# Dumping data for table `article_art`
#

INSERT INTO `article_art` VALUES (1, 'MX Kollection3 is out', 'Go get the next big thing in web application development until it is too late!', '2005-06-15 18:14:22', '2005-08-02 14:00:50');
INSERT INTO `article_art` VALUES (2, 'Breaking ImpAKT into modules', 'ImpAKT was one of our main tools in the MX Kollection 2. Along with NeXTensio it provided all you needed to build your administration section. In an attempt to improve the product we decided that it was best to split it into smaller, compact modules, that would each address a very specific need. ', '2005-06-15 18:15:54', '2005-08-02 14:01:25');
INSERT INTO `article_art` VALUES (3, 'QuB turns into MX Query Builder', 'With a change of name from the cryptic QuB to the more user friendly MX Query Builder also comes a change of face. Check out this new interface that will help you develop complex queries with limited knowledge of SQL. You no longer have to be a programming guru to get a dynamic website up and running. Besides being an easy tool for building complex queries, it is also a neat query repository that stores and displays all your previous recordsets.', '2005-07-28 10:49:07', '2005-07-28 10:49:07');
    

