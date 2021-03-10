-- 
-- Table structure for table `menu_mnu`
-- 

CREATE TABLE `menu_mnu` (
  `id_mnu` int(11) NOT NULL auto_increment,
  `idmnu_mnu` int(11) NULL,
  `label_mnu` varchar(50) NOT NULL default '',
  `tooltip_mnu` varchar(100) NOT NULL default '',
  `order_mnu` int(11) default NULL,
  `visible_mnu` int(2) default NULL,
  `url_link_mnu` varchar(20) NOT NULL default '',
  `target_mnu` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`id_mnu`),
	UNIQUE KEY `order_mnu` (`order_mnu`),
	UNIQUE KEY `label_mnu` (`label_mnu`),
	INDEX `visible_mnu` (`visible_mnu`),
	INDEX `idmnu_mnu` (`idmnu_mnu`)
);

-- 
-- Dumping data for table `menu_mnu`
-- 

INSERT INTO `menu_mnu` VALUES (1, NULL, 'Home', 'Home page', 1, 1, 'home.php', '_self');
INSERT INTO `menu_mnu` VALUES (2, NULL, 'Spring Pack', 'Products in MX Spring Pack 2006', 2, 1, '#', '_self');
INSERT INTO `menu_mnu` VALUES (3, NULL, 'Company', 'Company', 3, 1, '#', '_self');
INSERT INTO `menu_mnu` VALUES (4, 2, 'MX RSS Reader-Writer', 'MX RSS Reader-Writer', 4, 1, 'products.php?id=1', '_self');
INSERT INTO `menu_mnu` VALUES (5, 2, 'MX Site Search', 'MX Site Search', 5, 1, 'products.php?id=2', '_self');
INSERT INTO `menu_mnu` VALUES (6, 2, 'MX Looper', 'MX Looper', 6, 1, 'products.php?id=3', '_self');
INSERT INTO `menu_mnu` VALUES (7, 2, 'MX Dynamic Table Sorter', 'MX Dynamic Table Sorter', 7, 1, 'products.php?id=4', '_self');
INSERT INTO `menu_mnu` VALUES (8, 2, 'MX Calendar', 'MX Calendar', 8, 1, 'products.php?id=5', '_self');
INSERT INTO `menu_mnu` VALUES (9, 2, 'MX CSS Dynamic Menus', 'MX CSS Dynamic Menus', 9, 1, 'products.php?id=6', '_self');
INSERT INTO `menu_mnu` VALUES (10, 2, 'MX Navigation Pack', 'MX Navigation Pack', 10, 1, 'products.php?id=7', '_self');
INSERT INTO `menu_mnu` VALUES (11, 3, 'Overview', 'Company overview', 11, 1, 'overview.php', '_self');
INSERT INTO `menu_mnu` VALUES (12, 3, 'Contact', 'Contact', 12, 1, 'contact.php', '_self');


-- 
-- Table structure for table `product_prd`
-- 

CREATE TABLE `product_prd` (
  `id_prd` int(11) NOT NULL auto_increment,
  `name_prd` varchar(100) NOT NULL default '',
  `logo_prd` varchar(40) NOT NULL default '',  
  `tagline_prd` varchar(255) default NULL,
  `shdesc_prd` text,
  `desc_prd` text,
  PRIMARY KEY  (`id_prd`),
  UNIQUE KEY `nume_prod` (`name_prd`)
);

-- 
-- Dumping data for table `product_prd`
-- 

INSERT INTO `product_prd` VALUES (1, 'MX RSS Reader-Writer', 'MX RSS Reader-Writer.gif', 'Use RSS feeds in your sites', 'Syndicate web content fast and easy with MX RSS Reader-Writer', 'Ever wanted to syndicate web content fast and easily? MX RSS Reader-Writer is a 2 in 1 solution. First of all, it allows you to import RSS feeds like podcasts, blog posts and news streams and integrate them in your website, and secondly it allows you to generate RSS feeds for your database-driven websites. This way, you will be able to share news, blog posts and other web content.');
INSERT INTO `product_prd` VALUES (2, 'MX Site Search', 'MX Site Search.gif', 'Search database sites', 'Quick and easy solution for inserting a search form that looks into multiple tables in your dynamic site.', 'If you need to insert search support in your dynamic websites, MX Site Search is the easiest and fastest way to do it. Unlike other products that search only through the HTML files or in a single table, MX Site Search looks through multiple tables of the site database. Moreover, our product allows you to configure tables priorities to make sure the most relevant search results are displayed on top.');
INSERT INTO `product_prd` VALUES (3, 'MX Looper', 'MX Looper.gif', 'Nested Repeats and Horizontal Loopers in Dreamweaver', 'Build Nested Repeat Regions, Horizontal and Vertical Loopers.', 'MX Looper is a Dreamweaver Extension for complex repeat regions. Unlike the Macromedia default repeat region that allows you to create only simple loops, our product helps you easily create dynamic generated web pages including nested repeat regions, horizontal and vertical loopers to help you build image galleries and directory entries.');
INSERT INTO `product_prd` VALUES (4, 'MX Dynamic Table Sorter', 'MX Dynamic Table Sorter.gif', 'Sort your dynamic tables', 'Let website visitors sort your dynamic tables.', 'If your visitors need to sort information from your site by various criteria, MX Dynamic Table Sorter is the solution you are looking for. In the same amount of time it takes to create a dynamic table you will be able to implement one that has a cool sorting feature on the fields you want. In less than a minute, you can offer them the possibility to sort products by price, books by authors or employees by salary.');
INSERT INTO `product_prd` VALUES (5, 'MX Calendar', 'MX Calendar.gif', 'Build web calendars from Dreamweaver', 'Let your clients share their calendar on the web.', 'Do you find it more and more difficult to keep track of what you have to do? We now offer you a tool to help organize your schedule, keep an events agenda or even build a blog archive. MX Calendar is the perfect Dreamweaver extension to add a calendar nugget to your website, or build day, week, month or year calendar views and style them with CSS skins. Start organizing your activity with MX Calendar.');
INSERT INTO `product_prd` VALUES (6, 'MX CSS Dynamic Menus', 'MX CSS Dynamic Menus.gif', 'CSS popup menus from Dreamweaver recordsets', 'Create popup or tabbed menus for your websites.', 'Want to add a dynamic CSS popup menu to your website? MX CSS Dynamic Menus is a Dreamweaver extension that helps you create popup and tabbed menus for your websites. With 14 predefined skins, and the possibility to modify and customize them, this is the perfect solution to your problems. Easy to implement and use, it is surely an eye-catcher.');
INSERT INTO `product_prd` VALUES (7, 'MX Navigation Pack', 'MX Navigation Pack.gif', 'Navigation for dynamic pages', 'Add four different types of navigation bars to your website.', 'MX Navigation Pack is a Dreamweaver extension that allows you to add four different types of navigation bars to your website. Whether you need navigation by category, by page, or A to Z navigation, our tool can help you build and implement it in your site pages.');