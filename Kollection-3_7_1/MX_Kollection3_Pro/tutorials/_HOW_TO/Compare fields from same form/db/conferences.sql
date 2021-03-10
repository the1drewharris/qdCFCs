-- 
-- Table structure for table `conference_con`
-- 

CREATE TABLE conference_con (
  id_con int(11) NOT NULL auto_increment,
  title_con varchar(100) NOT NULL default '',
  start_date_con date NOT NULL default '0000-00-00',
  end_date_con date NOT NULL default '0000-00-00',
  building_con varchar(100) NULL default '',
  address_con varchar(255) NULL default '',
  PRIMARY KEY  (id_con),
  UNIQUE KEY title_con (title_con)
);

-- 
-- Dumping data for table `conference_con`
-- 

INSERT INTO conference_con VALUES (1, 'Macromedia MAX 2005', '2005-10-15', '2005-10-19', 'Anaheim Convention Center', '700 Convention Way, Anaheim, California');
INSERT INTO conference_con VALUES (2, 'Web 2.0 Conference', '2005-10-05', '2005-10-07', 'Argent Hotel', '50 Third Street, San Francisco, California');
INSERT INTO conference_con VALUES (3, 'International Conference on Software Reliability', '2005-04-10', '2005-04-15', 'Annapolis Convention Center', '210 Holiday Court, Annapolis, Maryland');