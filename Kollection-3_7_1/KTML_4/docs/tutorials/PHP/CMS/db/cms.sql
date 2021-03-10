-- 
-- Table structure for table `article_art`
-- 

CREATE TABLE `article_art` (
  `id_art` int(11) NOT NULL auto_increment,
  `idtop_art` int(11) NOT NULL default '0',
  `title_art` varchar(255) NOT NULL default '',
  `content_art` text NOT NULL,
  `date_created_art` datetime NOT NULL default '0000-00-00 00:00:00',
  `date_modified_art` datetime default NULL,
  `created_by_art` int(11) NOT NULL default '0',
  `modified_by_art` int(11) default NULL,
  `assigned_to_art` int(11) NOT NULL default '0',
  `status_art` int(2) NOT NULL default '0',
  PRIMARY KEY  (`id_art`)
);

-- 
-- Dumping data for table `article_art`
-- 

INSERT INTO `article_art` VALUES (1, 1, 'MX Navigation Pack', '<a href="http://www.interaktonline.com">InterAKT</a> releases a new extension to help you deal with the navigation issues in your dynamic websites. In the next few lines we will try to explain the types of navigation you can insert in the websites by using <strong>MX Navigation Pack</strong> and what problems you can solve with these navigation elements.asdas', '2005-12-19 15:48:27', '2005-12-19 15:48:27', 2, 2, 2, 1);
INSERT INTO `article_art` VALUES (2, 1, 'MX Kollection 3.6.0 and Kollection 2 Dreamweaver 8 compatible.', 'InterAKT is releasing new bug fixes and improvements on a large list of products (<a href="http://www.interaktonline.com/Support/My-Account/" title="My Account">free download</a> available for existing customers). We advise you to update any of the following products you might have in order to benefit from the latest improvements and bug fixes. The products that have been released are:<br/><p> </p>\r\n<ul>\r\n  <li><a href="http://www.interaktonline.com/Products/Bundles/MXKollection/Whats-new/">MX Kollection 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Bundles/MXKommerce/Whats-new/">MX Kommerce 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXFormValidation/Whats-new/">MX Form Validation 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXFileUpload/Whats-new/">MX File Upload 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXSendE-mail/Whats-new/">MX Send E-mail 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXUserLogin/Whats-new/">MX User Login 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXLooper/Whats-new/">MX Looper 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXWidgets/Whats-new/">MX Widgets 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXQueryBuilder/Whats-new/">MX Query Builder 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXIncludes/Whats-new/">MX Includes 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/NeXTensio/Whats-new/">NeXTensio 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXKart/Whats-new/">MX Kart 3.6.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Web-Applications/MXShop/Whats-new/">MX Shop 3.6.0</a></li>\r\n</ul>\r\n<p>The small products have also been revamped and improved and the list of updates is as follows:<br/></p>\r\n<ul>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCalendar/Whats-new/">MX Calendar 1.2.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCSVImport-Export/Whats-new/">MX CSV Import-Export 1.2.5</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/XMLImport-Export/Whats-new/">XML Import-Export 1.1.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Free-Products/XMLTableExport/Whats-new/">XML Table Export 1.1.0</a></li>\r\n  <li><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCSSDynamicMenus/Whats-new/">MX CSS Dynamic Menus 1.7.7</a></li>\r\n  <li><a href="http:///">MX Tree Menu 1.7.7</a></li>\r\n</ul>\r\n<p>To see the full changes in each of the product click on the product name to get to the What''s new section. There you will find the list of issues that have been corrected and the improvements in each of the extensions.</p>\r\n<p>Holding true to our promise to offer full support for MX Kollection 2 users, we have today released a compatibility version for Dreamweaver 8.</p>\r\n<p>This new release includes:</p>\r\n<ul>\r\n  <li>MX Kollection 2.8.20</li>\r\n  <li>ImpAKT 2.8.20</li>\r\n  <li>NeXTensio 2.8.20</li>\r\n  <li>MX Widgets 2.8.20</li>\r\n  <li>MX Query Builder 2.8.20</li>\r\n  <li>MX Looper 2.8.20</li>\r\n</ul>\r\n<p>For those of you owners of the previous version of MX Kollection the updates are free and available from your accounts.<br/></p>\r\n<p>Hope you will enjoy this new series of updates,</p>\r\n<p><span style="FONT-WEIGHT: bold">The InterAKT Team</span></p>\r\n', '2005-12-12 15:49:04', '2005-12-12 15:49:04', 3, 3, 1, 3);
INSERT INTO `article_art` VALUES (10, 3, 'Xmas Mega Pack', '<p>Build any dynamic website&nbsp;with Xmas Mega Pack 2005. This special bundle includes 21 Dreamweaver extensions that help you easily develop and maintain&nbsp;database applications, saving hundreds of hours of work. In a nutshell - all your Christmas wishes are fulfilled.</p>\r\n<p><u><font color="#0000ff">Check this huge feature list &gt;&gt;</font></u><a href="http://www.interaktonline.com/Products/Bundles/XMASMegaPack/Overview/">here</a></p>\r\n<p><!--StartFragment -->21 Dreamweaver extensions, meaning all our extensions, are available in this big bundle. Here''s the full list:</p>\r\n\r\n<table border="0" cellpadding="0" cellspacing="0" width="576">\r\n<tbody>\r\n<tr valign="top">\r\n<td>\r\n<p><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCSVImport-Export/Overview/" target="_blank">MX CSV Import-Export</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCSSDynamicMenus/Overview/" target="_blank">MX CSS Dynamic Menus</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXDynamicCharts/Overview/" target="_blank">MX Dynamic Charts</a>&nbsp;<br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXRSSReader-Writer/Overview/" target="_blank">MX RSS Reader-Writer</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/XMLImport-Export/Overview/" target="_blank">XML Import-Export</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXFormValidation/Overview/" target="_blank">MX Form Validation</a></p></td>\r\n<td>\r\n<p><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXFileUpload/Overview/" target="_blank">MX File Upload</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXWidgets/Overview/">MX Widgets</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXDynamicTableSorter/Overview/" target="_blank">MX Table Sorter</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCalendar/Overview/" target="_blank">MX Calendar</a><br></p></td>\r\n\r\n<td><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXUserLogin/Overview/">MX User Login</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/NeXTensio/Overview/" target="_blank">NeXTensio</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXCoderPack/Overview/" target="_blank">MX Coder Pack</a><br></td>\r\n<td><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXSendE-mail/Overview/" target="_blank">MX Send E-mail</a>&nbsp;<br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXSiteSearch/Overview/" target="_blank">MX Site Search</a>&nbsp;<br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXQueryBuilder/Overview/">MX Query Builder</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXIncludes/Overview/" target="_blank">MX Includes</a><br><br></td>\r\n<td><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXLooper/Overview/" target="_blank">MX Looper</a><br><a href="http://www.interaktonline.com/Products/Dreamweaver-Extensions/MXKart/Overview/" target="_blank">MX Kart</a><br><a href="http://www.interaktonline.com/Products/KTML/Overview/" target="_blank">KTML</a><br><a href="http://www.interaktonline.com/Products/Web-Applications/MXShop/Overview/" target="_blank">MX Shop</a></td></tr></tbody></table>', '2005-12-08 00:00:00', '2005-12-14 10:41:23', 3, 4, 1, 3);
INSERT INTO `article_art` VALUES (11, 4, 'InterAKT Conferences', '<p>Thousands of&nbsp;designers and developers will <a href="http://www.macromedia.com/macromedia/events/max/" target="_blank">gather at MAX 2005</a>, as they&nbsp;do every fall, to put ideas into action. Join&nbsp;them and InterAKT&nbsp;to learn new skills, explore emerging technologies, share techniques with peers, and put your own ideas in motion.</p>\r\n<p>InterAKT is not only one of the leading sponsors&nbsp;and exhibitors of the event but Mr. Alexandru Costin is also holding a session on the "<a href="http://www.macromedia.com/macromedia/events/max/sessions/sa101h.html" target="_blank">Using the power of XML in Dreamweaver</a>"</p>\r\n<p>Get the latest information on the new Dreamweaver 8 releases and see first hand&nbsp;the InterAKT extensions line compatible with this new Macromedia release.</p>\r\nZend Technologies, Inc., the PHP company, and creator of products and services supporting the development, deployment and management of PHP-based applications, today announced it will host the <a href="http://zend.kbconferences.com/" target="_blank">Zend/PHP Conference</a> and Expo October 18-21, 2005. The conference, “Power Your Business With PHP” will be held at the Hyatt Regency, San Francisco Airport in Burlingame, California. </p>\r\n<p>Since PHP is InterAKT''s largest market, we decided to go out to the Zend conference and connect with the developers and that represent the biggest market out there. Meet us to get the latest on technology and applications from InterAKT and Zend.</p></div>', '2005-12-16 00:00:00', '2005-12-27 10:56:33', 3, 5, 5, 2);

-- --------------------------------------------------------

-- 
-- Table structure for table `status_sta`
-- 

CREATE TABLE `status_sta` (
  `id_sta` int(11) NOT NULL auto_increment,
  `name_sta` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_sta`)
);

-- 
-- Dumping data for table `status_sta`
-- 

INSERT INTO `status_sta` VALUES (1, 'Draft');
INSERT INTO `status_sta` VALUES (2, 'Assigned for review');
INSERT INTO `status_sta` VALUES (3, 'Approved');

-- --------------------------------------------------------

-- 
-- Table structure for table `topic_top`
-- 

CREATE TABLE `topic_top` (
  `id_top` int(11) NOT NULL auto_increment,
  `name_top` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_top`)
);

-- 
-- Dumping data for table `topic_top`
-- 

INSERT INTO `topic_top` VALUES (1, 'Product news');
INSERT INTO `topic_top` VALUES (2, 'Company news');
INSERT INTO `topic_top` VALUES (3, 'General news');
INSERT INTO `topic_top` VALUES (4, 'Conferences');

-- --------------------------------------------------------

-- 
-- Table structure for table `user_usr`
-- 

CREATE TABLE `user_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `email_usr` varchar(255) NOT NULL default '',
  `password_usr` varchar(255) NOT NULL default '',
  `level_usr` int(2) NOT NULL default '0',
  PRIMARY KEY  (`id_usr`)
);

-- 
-- Dumping data for table `user_usr`
-- 

INSERT INTO `user_usr` VALUES (1, 'webmaster@interaktcms.org', '63a9f0ea7bb98050796b649e85481845', 3);
INSERT INTO `user_usr` VALUES (2, 'author@interaktcms.org', '63a9f0ea7bb98050796b649e85481845', 1);
INSERT INTO `user_usr` VALUES (3, 'author2@interaktcms.org', '63a9f0ea7bb98050796b649e85481845', 1);
INSERT INTO `user_usr` VALUES (4, 'editor1@interaktcms.org', '63a9f0ea7bb98050796b649e85481845', 2);
INSERT INTO `user_usr` VALUES (5, 'editor2@interaktcms.org', '63a9f0ea7bb98050796b649e85481845', 2);
        