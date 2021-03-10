# --------------------------------------------------------

#
# Table structure for table `document_doc`
#

CREATE TABLE `document_doc` (
  `id_doc` int(11) NOT NULL auto_increment,
  `filename_doc` varchar(100) NOT NULL default '',
  `description_doc` varchar(200) default NULL,
  PRIMARY KEY  (`id_doc`)
);

