# Table structure for table `employee_emp`
#

CREATE TABLE `employees_emp` (
  `id_emp` int(4) NOT NULL auto_increment,
  `name_emp` varchar(50) NOT NULL default '',
  `salary_emp` int(4) NOT NULL default '0',
  PRIMARY KEY `id_emp` (`id_emp`),
  UNIQUE KEY `name_emp` (`name_emp`)
);

#
# Dumping data for table `employees_emp`
#

INSERT INTO `employees_emp` VALUES (1, 'Ben Harrison', 9000);
INSERT INTO `employees_emp` VALUES (2, 'Chris Benton', 1000);
INSERT INTO `employees_emp` VALUES (3, 'Nikita Jelinski', 2500);
INSERT INTO `employees_emp` VALUES (4, 'George Palmer', 2500);
INSERT INTO `employees_emp` VALUES (5, 'John Doe', 3500);
