CREATE TABLE `logger_log` (
  `id_log` int(11) NOT NULL auto_increment,
  `idusr_log` int(11) NOT NULL default '0',
  `ip_log` varchar(15) NOT NULL default '',
  `datein_log` datetime NOT NULL default '0000-00-00 00:00:00',
  `dateout_log` datetime default NULL,
  `session_log` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_log`)
);

  
  CREATE TABLE `users_usr` (
  `id_usr` int(11) NOT NULL auto_increment,
  `email_usr` varchar(33) NOT NULL default '',
  `name_usr` varchar(85) NOT NULL default '',
  `password_usr` varchar(255) NOT NULL default '',
  `ntries_usr` smallint(6) NOT NULL default '0',
  `disabledate_usr` datetime NOT NULL default '0000-00-00 00:00:00',
  `registrationdate_usr` datetime NOT NULL default '0000-00-00 00:00:00',
  `expiration_usr` int(11) NOT NULL default '100',
  `random_usr` varchar(32) NOT NULL default '',
  `active_usr` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id_usr`)
);

