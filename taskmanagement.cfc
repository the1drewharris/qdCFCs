<cfcomponent hint="This cfc has all the taskmanagement functions">
	
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
	
	<cffunction name="createTaskManagementTables" access="public" hint="Create all tables related to Task Management System. The tables are STATUS, PRIORITY, PROJECT, PROJECT_STATUS, PROJECT_PRIORITY, COMPLETED_PROJECT, PROJECT_MANAGER, TASK, TASK_ON_INCIDENT, TASK_ASSIGNED, TASK_DEADLINE, TASK_STATUS, TASK_PRIORITY, INCIDENT, COMMENTS, SOLUTION, SERVICE">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfquery name="createtaskmanagementtables" datasource="#taskdsn#">
			
			CREATE TABLE BROWSER
			(
				[BROWSERID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[BROWSERNAME] [varchar](256) NOT NULL
			);
			
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Firefox');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Internet Explorer 5');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Internet Explorer 6');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Internet Explorer 7');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Internet Explorer 8');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Safari');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Opera');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Konqueror');
			INSERT INTO BROWSER (BROWSERNAME) VALUES('Other');
			
			
			CREATE TABLE EMAILCLIENT
			(
				[EMAILCLIENTID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[EMAILCLIENTNAME] [varchar](256) NOT NULL
			);
			
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Outlook Express');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('MS Office Outlook');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Apple Mail');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Eudora');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Mozilla Thunderbird');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Pegasus Mail');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('KMail');
			INSERT INTO EMAILCLIENT (EMAILCLIENTNAME) VALUES('Others');
			
			CREATE TABLE OS
			(
				[OSID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[OSNAME] [varchar](256) NOT NULL
			);
			
			INSERT INTO OS (OSNAME) VALUES ('Windows');
			INSERT INTO OS (OSNAME) VALUES ('Mac OS X');
			INSERT INTO OS (OSNAME) VALUES ('Linux');
			INSERT INTO OS (OSNAME) VALUES ('Unix');
			INSERT INTO OS (OSNAME) VALUES ('BSD');
			INSERT INTO OS (OSNAME) VALUES ('Solaris');
			INSERT INTO OS (OSNAME) VALUES ('Others');
			
			CREATE TABLE INCIDENTCATEGORY
			(
				[INCIDENTCATEGORYID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[INCIDENTCATEGORYNAME] [varchar](256) NOT NULL
			);
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Overall Website Design');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Email Delivery');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Website Statistics');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('DeltaSystem');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Accessing Website');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Spam or Antispam Service');
			INSERT INTO INCIDENTCATEGORY (INCIDENTCATEGORYNAME) VALUES ('Website Addon or Feature');
			
			CREATE TABLE SCREENSHOT
			(	
				SCREENSHOTID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
				SCREENSHOTNAME VARCHAR(256) NOT NULL,
				NAMEID BIGINT
			);
			
			CREATE TABLE INCIDENT
			(
				[INCIDENTID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[INCIDENTNAME] [varchar](256) NOT NULL,
				[INCIDENTDESCRIPTION] [ntext] NOT NULL,
				[INCIDENTDOING] [ntext] NULL,
				[INCIDENTURL] [varchar](256) NOT NULL,
				[SCREENSHOTID] [bigint] NULL,
				[SITEID] [bigint] NULL,
				[EMAILCLIENTID] [bigint] NULL,
				[BROWSERID] [bigint] NULL,
				[OSID] [bigint] NULL,
				[NAMEID] [bigint] NOT NULL,
				[INCIDENTCATEGORYID] [bigint] NULL,
				[ERROR] [varchar](16) NULL,
				[ERRORDESCRIPTION] [ntext] NOT NULL,
				[SCREENRES] [varchar](32) NULL,
				[TIMEREPORTED] [varchar](16) NULL,
				[ATTACHMENT] [varchar](256) NULL,
				[STATUSID] [varchar](16) NULL,
				[SOLUTIONID] [bigint] NULL,
				[RESOLVEDON] [varchar](16) NULL,
				[PRIORITYID] [bigint] NULL
			);
			
			ALTER TABLE INCIDENT  WITH NOCHECK ADD  CONSTRAINT [FK_INCIDENT_BROWSER] FOREIGN KEY([BROWSERID])
			REFERENCES BROWSER ([BROWSERID]);
			
			
			ALTER TABLE INCIDENT  WITH NOCHECK ADD  CONSTRAINT [FK_INCIDENT_EMAILCLIENT] FOREIGN KEY([EMAILCLIENTID])
			REFERENCES EMAILCLIENT ([EMAILCLIENTID]);
			
			
			ALTER TABLE INCIDENT  WITH NOCHECK ADD  CONSTRAINT [FK_INCIDENT_INCIDENTCATEGORY] FOREIGN KEY([INCIDENTCATEGORYID])
			REFERENCES INCIDENTCATEGORY ([INCIDENTCATEGORYID]);
			
			ALTER TABLE INCIDENT CHECK CONSTRAINT [FK_INCIDENT_INCIDENTCATEGORY];
			
			
			ALTER TABLE INCIDENT  WITH NOCHECK ADD  CONSTRAINT [FK_INCIDENT_OS] FOREIGN KEY([OSID])
			REFERENCES OS ([OSID]);
			
			ALTER TABLE INCIDENT  WITH NOCHECK ADD  CONSTRAINT [FK_INCIDENT_SCREENSHOT] FOREIGN KEY([SCREENSHOTID])
			REFERENCES SCREENSHOT ([SCREENSHOTID]);
			
			CREATE TABLE STATUS
			(
				STATUS VARCHAR(128) NOT NULL PRIMARY KEY
			)
			
			CREATE TABLE PROJECTTYPE
			(
				TYPE VARCHAR(128) NOT NULL PRIMARY KEY
			)
			
			CREATE TABLE TASKTYPE
			(
				TASK_TYPE VARCHAR(128) NOT NULL PRIMARY KEY
			)
			INSERT INTO TASKTYPE (TASK_TYPE) VALUES ('Incident');
			
			CREATE TABLE SERVICE
			(	
				SERVICEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				SERVICENAME VARCHAR(50) NOT NULL,
				SERVICEDESCRIPTION NTEXT NOT NULL,
				ESTIMATEDFEE MONEY NOT NULL,
				PER INTEGER,
				PAGENAME VARCHAR(50),
				STATUS VARCHAR(50),
				RESELLERPRICE MONEY,
				RESELLERFEE MONEY
			);
			
			CREATE TABLE PROJECT
			(
				PID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				PNAME VARCHAR(50) NOT NULL,
				DESCRIPTION NTEXT NOT NULL ,
				CREATEDON VARCHAR(16) NOT NULL,
				SITE_URL VARCHAR(100),
				TYPE VARCHAR(128) NOT NULL,
				FEE MONEY NOT NULL,
				ETA VARCHAR(16) NOT NULL
			);
			
			ALTER TABLE PROJECT ADD FOREIGN KEY (TYPE) REFERENCES PROJECTTYPE (TYPE);
			
			CREATE TABLE CLIENTS_FOR_PROJECT
			(
				RECORDEDON VARCHAR(16) NOT NULL,
				PID BIGINT NOT NULL,
				CID BIGINT NOT NULL,
				ACTIVE BIT DEFAULT 1 NOT NULL
				
			);
	
			ALTER TABLE CLIENTS_FOR_PROJECT ADD FOREIGN KEY (CID) REFERENCES NAME (NAMEID);
			ALTER TABLE CLIENTS_FOR_PROJECT ADD FOREIGN KEY (PID) REFERENCES PROJECT (PID);
			
			CREATE TABLE PROJECT_STATUS
			(
				PID BIGINT NOT NULL,
				STATUS VARCHAR(128) NOT NULL,
				RECORDEDON VARCHAR(16) NOT NULL
			);
			
			
			ALTER TABLE PROJECT_STATUS ADD FOREIGN KEY (PID) REFERENCES PROJECT(PID); 
			ALTER TABLE PROJECT_STATUS ADD FOREIGN KEY(STATUS) REFERENCES STATUS(STATUS);
			
			CREATE TABLE PROJECT_PRIORITY
			(
				PID BIGINT NOT NULL,
				PRIORITY INT NOT NULL,
				SETON VARCHAR(16) NOT NULL 
			);
			
			ALTER TABLE PROJECT_PRIORITY ADD FOREIGN KEY (PID) REFERENCES PROJECT(PID);
			
			CREATE TABLE PROJECT_MANAGER
			(
				PID BIGINT NOT NULL,
				MANAGERID BIGINT NOT NULL,
				ASSIGNEDON VARCHAR(16) NOT NULL,
				ACTIVE BIT NOT NULL
			);
			
			ALTER TABLE PROJECT_MANAGER ADD FOREIGN KEY (PID) REFERENCES PROJECT(PID);
			ALTER TABLE PROJECT_MANAGER ADD FOREIGN KEY (MANAGERID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE PROJECT_DEADLINE
			(
				PID BIGINT NOT NULL,
				DEADLINE VARCHAR(16) NOT NULL,
				DEADLINE_SETON VARCHAR(16) NOT NULL
			);
			
			ALTER TABLE PROJECT_DEADLINE  ADD FOREIGN KEY (PID) REFERENCES PROJECT(PID);
			
			CREATE TABLE TASK
			(
				TID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				TNAME VARCHAR(256) NOT NULL,
				TASK_DESCRIPTION  NTEXT,
				TASK_TYPE VARCHAR(128) NOT NULL,
				EST_MINS INT NOT NULL,
				FEE MONEY NOT NULL DEFAULT 0,
				CREATEDON VARCHAR(16) NOT NULL
			);
			
			ALTER TABLE TASK ADD FOREIGN KEY (TASK_TYPE) REFERENCES TASKTYPE (TASK_TYPE);
			
			CREATE TABLE EXPENDITURE_TASK
			(
				ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				TID BIGINT NOT NULL,
				EXPENDEDON VARCHAR(256) NOT NULL,
				RECORDEDON VARCHAR(16) NOT NULL,
				AMOUNT INT NOT NULL
			)
			
			ALTER TABLE EXPENDITURE_TASK ADD FOREIGN KEY(TID) REFERENCES TASK(TID);
			
			CREATE TABLE TASK_ON_PROJECT
			(
				TID BIGINT NOT NULL PRIMARY KEY,
				PID BIGINT NOT NULL
			);
			
			ALTER TABLE TASK_ON_PROJECT ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			ALTER TABLE TASK_ON_PROJECT ADD FOREIGN KEY (PID) REFERENCES PROJECT (PID);
			
			CREATE TABLE TASK_ON_INCIDENT
			(
				TID BIGINT NOT NULL PRIMARY KEY,
				INCIDENTID BIGINT NOT NULL 
			);
			
			ALTER TABLE TASK_ON_INCIDENT ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			ALTER TABLE TASK_ON_INCIDENT ADD FOREIGN KEY (INCIDENTID) REFERENCES INCIDENT(INCIDENTID);
			
			CREATE TABLE TASK_ON_SERVICE
			(
				TID BIGINT NOT NULL PRIMARY KEY,
				SERVICEID BIGINT NOT NULL
			);
			ALTER TABLE TASK_ON_SERVICE ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			ALTER TABLE TASK_ON_SERVICE ADD FOREIGN KEY (SERVICEID) REFERENCES SERVICE (SERVICEID);
			
			CREATE TABLE TASK_ASSIGNED
			(
				TASKASSIGNEDID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				TID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				ASSIGNEDON VARCHAR(16) NOT NULL,
				ACTIVE BIT NOT NULL DEFAULT 1
			);
			
			ALTER TABLE TASK_ASSIGNED ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			ALTER TABLE TASK_ASSIGNED ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE TASK_DEADLINE
			(
				TID BIGINT NOT NULL,
				DEADLINE VARCHAR(16) NOT NULL,
				DEADLINE_SETON VARCHAR(16) NOT NULL
			);
			
			ALTER TABLE TASK_DEADLINE ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			
			CREATE TABLE TASK_STATUS
			(
				TID BIGINT NOT NULL,
				STATUS VARCHAR(128) NOT NULL,
				STATUS_RECORDEDON VARCHAR(16) NOT NULL
			);
			
			ALTER TABLE TASK_STATUS ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			
			CREATE TABLE TASK_PRIORITY  
			(
				TID BIGINT NOT NULL,
				PRIORITY INT NOT NULL,
				PRIORITY_SETON VARCHAR(16) NOT NULL
				
			);
			
			ALTER TABLE TASK_PRIORITY ADD FOREIGN KEY (TID) REFERENCES TASK(TID);
			
			CREATE TABLE WORK_PERFORMED
			(
				TASKASSIGNEDID BIGINT NOT NULL,
				TID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				MINS_SPENT BIGINT NOT NULL,
				SERVICE VARCHAR(100),
				WORKEDON VARCHAR(16) NOT NULL,
				COMMENTS NTEXT
			);
			ALTER TABLE WORK_PERFORMED ADD FOREIGN KEY (TASKASSIGNEDID) REFERENCES TASK_ASSIGNED(TASKASSIGNEDID);
			
			CREATE TABLE COMMENTS
			(
				CID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				COMMENT NTEXT NOT NULL,
				CREATEDBY BIGINT NOT NULL,
				RECORDEDON VARCHAR(16) NOT NULL,
				EMAILEDTOCLIENT BIT DEFAULT 0
			);
			
			CREATE TABLE COMMENTS_ON_PROJECT
			(
				CID BIGINT NOT NULL PRIMARY KEY,
				PID BIGINT NOT NULL
			);
			
			ALTER TABLE COMMENTS_ON_PROJECT ADD FOREIGN KEY (PID) REFERENCES PROJECT (PID);
			ALTER TABLE COMMENTS_ON_PROJECT ADD FOREIGN KEY (CID) REFERENCES COMMENTS (CID);
			
			CREATE TABLE COMMENTS_ON_TASK
			(
				CID BIGINT NOT NULL PRIMARY KEY,
				TID BIGINT NOT NULL
			);
			
			ALTER TABLE COMMENTS_ON_TASK ADD FOREIGN KEY (TID) REFERENCES TASK (TID);
			ALTER TABLE COMMENTS_ON_TASK ADD FOREIGN KEY (CID) REFERENCES COMMENTS (CID);
			
			CREATE TABLE COMMENTS_ON_INCIDENT
			(
				CID BIGINT NOT NULL PRIMARY KEY,
				INCIDENTID BIGINT NOT NULL
			);
			
			ALTER TABLE COMMENTS_ON_INCIDENT ADD FOREIGN KEY (INCIDENTID) REFERENCES INCIDENT (INCIDENTID);
			ALTER TABLE COMMENTS_ON_INCIDENT ADD FOREIGN KEY (CID) REFERENCES COMMENTS (CID);
			
			CREATE TABLE SEND_COMMENTS_TO
			(
				CID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL
			);
			
			ALTER TABLE SEND_COMMENTS_TO ADD PRIMARY KEY(CID, NAMEID);
			ALTER TABLE SEND_COMMENTS_TO ADD FOREIGN KEY (CID) REFERENCES COMMENTS (CID);
			ALTER TABLE SEND_COMMENTS_TO ADD FOREIGN KEY (NAMEID) REFERENCES NAME (NAMEID);
			
			CREATE TABLE SOLUTION
			(
				SOLUTIONID BIGINT NOT NULL IDENTITY(1,1),
				INCIDENTID BIGINT NOT NULL,
				CID BIGINT NOT NULL
			);
			ALTER TABLE SOLUTION ADD PRIMARY KEY (INCIDENTID, CID);
			ALTER TABLE SOLUTION ADD FOREIGN KEY (INCIDENTID) REFERENCES INCIDENT (INCIDENTID);
			ALTER TABLE SOLUTION ADD FOREIGN KEY (CID) REFERENCES COMMENTS (CID);
			 
		</cfquery>
	</cffunction>
 	
	<cffunction name="dropTaskManagementTables" access="public" hint="Drops all the tables related to Task management">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfquery name="droptaskmanagementtables" datasource="#taskdsn#">
			DROP TABLE SOLUTION;
			DROP TABLE SEND_COMMENTS_TO;
			DROP TABLE COMMENTS_ON_INCIDENT;
			DROP TABLE COMMENTS_ON_TASK;
			DROP TABLE COMMENTS_ON_PROJECT;
			DROP TABLE COMMENTS;
			DROP TABLE WORK_PERFORMED
			DROP TABLE TASK_PRIORITY;
			DROP TABLE TASK_STATUS;
			DROP TABLE TASK_DEADLINE;
			DROP TABLE TASK_ASSIGNED;
			DROP TABLE TASK_ON_SERVICE;
			DROP TABLE TASK_ON_INCIDENT;
			DROP TABLE TASK_ON_PROJECT;
			DROP TABLE EXPENDITURE_TASK;
			DROP TABLE TASK;
			DROP TABLE PROJECT_MANAGER;
			DROP TABLE PROJECT_PRIORITY;
			DROP TABLE PROJECT_STATUS;
			DROP TABLE CLIENTS_FOR_PROJECT;
			DROP TABLE PROJECT_DEADLINE;
			DROP TABLE PROJECT;
			DROP TABLE SERVICE;
			DROP TABLE PROJECTTYPE;
			DROP TABLE TASKTYPE;
			DROP TABLE STATUS;
			DROP TABLE INCIDENT;
			DROP TABLE SCREENSHOT
			DROP TABLE INCIDENTCATEGORY;
			DROP TABLE OS;
			DROP TABLE EMAILCLIENT;
			DROP TABLE BROWSER;
		</cfquery>
	</cffunction>
	
	<cffunction name="gettasktype" access="public" returntype="query" hint="get all task types. Return field: TASK_TYPE">
		<cfargument name="taskdsn" required="true" type="string" hint="datasource">
		<cfquery name="tasktypes"  datasource="#taskdsn#">
			SELECT TASK_TYPE FROM TASKTYPE
		</cfquery>
		<cfreturn tasktypes>
	</cffunction>
	
	<cffunction name="getprojecttype" access="public" returntype="query" hint="get all project types. Return field: TYPE">
		<cfargument name="taskdsn" required="true" type="string" hint="datasource">
		<cfquery name="projecttypes"  datasource="#taskdsn#">
			SELECT TYPE FROM PROJECTTYPE
		</cfquery>
		<cfreturn projecttypes>
	</cffunction>
	
	<cffunction name="getstatus" access="public" returntype="query" hint="get all status. Return field: STATUS">
		<cfargument name="taskdsn" required="true" type="string" hint="datasource">
		<cfquery name="getstatus"  datasource="#taskdsn#">
			SELECT STATUS FROM STATUS
		</cfquery>
		<cfreturn getstatus>
	</cffunction>
	
	<cffunction name="getclients" access="public" returntype="query" hint="get clients for a project">
		<cfargument name="taskdsn" required="true" type="string" hint="datasource">
		<cfargument name="pid" required="true" type="numeric" hint="projectid">
		<cfquery name="getclients" datasource="#taskdsn#">
			SELECT
				PROJECT.PNAME,
				CLIENTS_FOR_PROJECT.CID,
				CLIENTS_FOR_PROJECT.RECORDEDON,
				NAME.COMPANY, 
				NAME.FIRSTNAME, 
				NAME.LASTNAME, 
				NAME.WEMAIL
			FROM PROJECT, CLIENTS_FOR_PROJECT, NAME
			WHERE CLIENTS_FOR_PROJECT.CID=NAME.NAMEID
			AND CLIENTS_FOR_PROJECT.PID=PROJECT.PID
			AND CLIENTS_FOR_PROJECT.PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			AND CLIENTS_FOR_PROJECT.ACTIVE=1
		</cfquery>
		<cfreturn getclients>
	</cffunction>
	
	<cffunction name="priorities" access="public" hint="Populates the priority table">
		<cfargument name="taskdsn" type="String" required="True" hint="Datasource">
		<cfargument name="max" required="true" type="numeric" hint="Maximum value of priority">
		<cfargument name="min" required="true" type="numeric" hint="Minimum value of priority">
		
		<cfloop  index = "LoopCount" from = "#min#" to = "#max#">
			<cfquery name="intialpriorities" datasource="#taskdsn#">
				INSERT INTO PRIORITY
				(
					PRIORITY
				)
				VALUES
				(
					<cfqueryparam value="#LoopCount#" cfsqltype="cf_sql_integer">
				)
			</cfquery>
		</cfloop>
	</cffunction>
	
	<cffunction name="addProject" access="public" returntype="numeric" hint="Add a project to the database and outputs PID">
		<cfargument name="taskdsn" type="String" required="True" hint="Datasource">
		<cfargument name="pname" type="String" required="True" hint="Name of the project">
		<cfargument name="type" type="String" required="True" hint="Type of project e.g. design, coding etc.">
		<cfargument name="fee" type="numeric" required="True" hint="Amount to charge for the project">
		<cfargument name="description" type="String" required="True" hint="Short description of the project">
		<cfargument name="eta" type="String" required="True" hint="Estimated time for the project to complete">
		<cfargument name="site_url" type="String" required="False" hint="URL of the site for this project">
		
		<cfquery name="addproject" datasource="#taskdsn#">
			INSERT INTO PROJECT
			(
				PNAME,
				DESCRIPTION,
				CREATEDON,
				<cfif isdefined('siteurl')>
				SITE_URL,
				</cfif>
				TYPE,
				FEE,
				ETA
			)
			VALUES
			(
				<cfqueryparam value="#pname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfif isdefined('siteurl')>
				<cfqueryparam value="#site_url#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#fee#">,
				<cfqueryparam value="#eta#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS PID
		</cfquery>
		<cfreturn addproject.PID>
	</cffunction>
	
	<cffunction name="editProject" access="public" returntype="void" hint="Add a project to the database and outputs PID">
		<cfargument name="taskdsn" type="String" required="True" hint="Datasource">
		<cfargument name="pid" type="Numeric" required="True" hint="Name of the project">
		<cfargument name="pname" type="String" required="True" hint="Name of the project">
		<cfargument name="description" type="String" required="false" hint="Short description of the project">
		<cfargument name="site_url" type="String" required="False" hint="URL of the site for this project">
		<cfargument name="type" type="String" required="false" hint="Type of project e.g. design, coding etc.">
		<cfargument name="fee" type="String" required="false" hint="Amount to charge for the project">
		<cfargument name="eta" type="String" required="false" hint="Estimated time for the project to complete">
		<cfquery name="editproject" datasource="#taskdsn#">
			UPDATE PROJECT
			SET
				PNAME=<cfqueryparam value="#pname#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('pname')>
				,DESCRIPTION=<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">
				</cfif>
				<cfif isdefined('site_url')>
				,SITE_URL=<cfqueryparam value="#site_url#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('type')>
				,TYPE=<cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('fee')>
				,FEE=<cfqueryparam value="#fee#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('eta')>
				,ETA=<cfqueryparam value="#eta#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="addClientsForProject" access="public" returntype="void" hint="Add a client for the project">
		<cfargument name="taskdsn" type="String" required="True" hint="Datasource">
		<cfargument name="pid" required="True" type="Numeric" hint="pid of the project">
		<cfargument name="cid" required="True" type="Numeric" hint="nameid of the client">
		
		<cfquery name="checkclient" datasource="#taskdsn#">
			SELECT RECORDEDON
			FROM CLIENTS_FOR_PROJECT
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			AND CID=<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">
			AND ACTIVE=1
		</cfquery>
		
		<cfif checkclient.recordcount EQ 0>
			<cfquery name="addclientsForProject" datasource="#taskdsn#">
				INSERT INTO CLIENTS_FOR_PROJECT
				(
					RECORDEDON,
					PID,
					CID
				)
				VALUES
				(
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">
				)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="addManager" access="public" returntype="void" hint="Add a manager of a project">
		<cfargument name="taskdsn" required="True" type="String" hint="Datasource">
		<cfargument name="pid" required="True" type="Numeric" hint="pid of the project">
		<cfargument name="managerid" required="true" type="Numeric" hint="nameid of the manager">
		
		<cfquery name="checkmanager" datasource="#taskdsn#">
			SELECT PID FROM PROJECT_MANAGER
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			AND MANAGERID=<cfqueryparam value="#managerid#" cfsqltype="cf_sql_bigint">
			AND ACTIVE=1
		</cfquery>
		
		<cfif checkmanager.recordcount EQ 0>
			<cfquery name="addManager" datasource="#taskdsn#">		
				INSERT INTO PROJECT_MANAGER
				(
					PID,
					MANAGERID,
					ASSIGNEDON,
					ACTIVE
				)
				VALUES
				(
					<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#managerid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="1">
				)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getManagers" access="public" returntype="query" hint="Add a manager of a project">
		<cfargument name="taskdsn" required="True" type="String" hint="Datasource">
		<cfargument name="pid" required="True" type="Numeric" hint="pid of the project">
		<cfquery name="getmanagers" datasource="#taskdsn#">
			SELECT
				PROJECT_MANAGER.MANAGERID,
				PROJECT_MANAGER.ASSIGNEDON,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.WEMAIL
			FROM PROJECT_MANAGER,NAME
			WHERE PROJECT_MANAGER.MANAGERID=NAME.NAMEID
			AND PROJECT_MANAGER.PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			AND PROJECT_MANAGER.ACTIVE=1
		</cfquery>
		<cfreturn getmanagers>
	</cffunction>
	
	<cffunction name="removeManager" access="public" returntype="void" hint="Removes a manager from a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="True" type="Numeric" hint="pid of the project">
		<cfargument name="managerid" required="true" type="Numeric" hint="nameid of the manager">
		<cfquery name="removeManager" datasource="#taskdsn#">
			UPDATE PROJECT_MANAGER
			SET ACTIVE=0
			WHERE
			PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint"> 
			AND
			MANAGERID=<cfqueryparam value="#managerid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		
		<cfquery name="updateMangerinfo" datasource="#taskdsn#">
			INSERT INTO PROJECT_MANAGER
			(
				PID,
				MANAGERID,
				ASSIGNEDON,
				ACTIVE
			)
			VALUES
			(
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#managerid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="0">
			)
		</cfquery>
	</cffunction>	

	<cffunction name="setProjectPriority" access="public" returntype="void" hint="Set priority of the project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="pid of the project">
		<cfargument name="priority" required="True" type="numeric" hint="pririty of the project"> 
		<cfquery name="setProjectPriority" datasource="#taskdsn#">
			INSERT INTO PROJECT_PRIORITY
			(
				PID,
				PRIORITY,
				SETON
			)
			VALUES
			(
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#priority#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setProjectStatus" access="public" returntype="void" hint="Set task status">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfargument name="status" required="true" type="String" hint="Status of the project">
		<cfquery name="setProjectStatus" datasource="#taskdsn#">
			INSERT INTO PROJECT_STATUS
			(
				PID,
				STATUS,
				RECORDEDON
			)
			VALUES
			(
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="setProjectDeadline" access="public" returntype="void" hint="Set deadline for a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfargument name="deadline" required="true" type="String" hint="deadline for the project">
		<cfquery name="setProjectStatus" datasource="#taskdsn#">
			INSERT INTO PROJECT_DEADLINE
			(
				PID,
				DEADLINE,
				DEADLINE_SETON
			)
			VALUES
			(
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#deadline#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
			
	<cffunction name="addBrowser" access="public" returntype="numeric" hint="add a browser to database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="browsername" required="true" type="String" hint="Name of the browser">
		<cfquery name="addbrowser" datasource="#taskdsn#">
			INSERT INTO BROWSER
			(
				BROWSERNAME
			)
			VALUES
			(
				<cfqueryparam value="#browsername#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS BROWSERID 			
		</cfquery>
		<cfreturn addbrowser.BROWSERID>
	</cffunction>
	
	<cffunction name="addOs" access="public" returntype="numeric" hint="add a OS to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="osname" required="true" type="String" hint="Name of the operating system">
		<cfquery name="addos" datasource="#taskdsn#">
			INSERT INTO OS
			(
				OSNAME
			)
			VALUES
			(
				<cfqueryparam value="#osname#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addEmailClient" access="public" returntype="numeric" hint="add a email client to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="emailclientname" required="true" type="String" hint="Name of the email client">
		<cfquery name="addemailclient" datasource="#taskdsn#">
			INSERT INTO EMAILCLIENT
			(
				EMAILCLIENTNAME
			)
			VALUES
			(
				<cfqueryparam value="#emailclientname#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS EMAILCLIENTID
		</cfquery>
		<cfreturn addemailclient.EMAILCLIENTID>
	</cffunction>

	<cffunction name="addIncidentCategory" access="public" returntype="numeric" hint="add an Incident Category to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="incidentcategoryname" required="true" type="String" hint="Name of the incident category">
		<cfquery name="addincidentcategory" datasource="#taskdsn#">
			INSERT INTO INCIDENTCATEGORY
			(
				INCIDENTCATEGORYNAME
			)
			VALUES
			(
				<cfqueryparam value="#incidentcategoryname#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS INCIDENTCATEGORYID
		</cfquery>
			<cfreturn addincidentcategory.INCIDENTCATEGORYID>
	</cffunction>

	<cffunction name="addService" access="public" returntype="numeric" hint="add a service to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="servicename" required="true" type="String" hint="Name of the service">
		<cfargument name="servicedescription" required="true" type="String" hint="Description of the service">
		<cfargument name="estimatedfee" required="true" type="numeric" hint="Fee for the service">
		<cfargument name="per" required="true" type="numeric" hint="">
		<cfargument name="pagename" required="true" type="string" hint="Name of the page">
		<cfargument name="status" required="false" type="String" hint="Status of the service">
		<cfargument name="resellerprice" required="false" type="numeric" hint="Price at which reseller should sell the service">
		<cfargument name="resellerfee" required="false" type="numeric" hint="Reseller fee">
		<cfquery name="addservice" datasource="#taskdsn#">
			INSERT INTO SERVICE
			(
				SERVICENAME,
				SERVICEDESCRIPTION,
				ESTIMATEDFEE,
				PER,
				PAGENAME
				<cfif isDefined('status')>
				,STATUS
				</cfif>
				<cfif isDefined('resellerprice')>
				,RESELLERPRICE
				</cfif>
				<cfif isDefined('resellerfee')>
				,RESELLERFEE
				</cfif>
			)
			
			VALUES
			(
				<cfqueryparam value="#servicename#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#servicedescription#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#estimatedfee#" cfsqltype="cf_sql_money">,
				<cfqueryparam value="#per#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#pagename#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('status')>
					,<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('resellerprice')>
					,<cfqueryparam value="#resellerprice#" cfsqltype="cf_sql_money">
				</cfif>
				<cfif isDefined('resellerfee')>
					,<cfqueryparam value="#resellerfee#" cfsqltype="cf_sql_money">
				</cfif>
			)
			SELECT @@IDENTITY AS SERVICEID
		</cfquery>
		<cfreturn addservice.SERVICEID>
	</cffunction>
	
	<cffunction name="addIncident" access="public" returntype="numeric" hint="add an incident to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="incidentname" required="true" type="string" hint="name of the incident">
		<cfargument name="incidentdescription" required="true" type="string" hint="description of the incident">
		<cfargument name="incidenturl" required="true" type="string" hint="URL where the incident occured">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person who is reporting the incident">
		<cfargument name="errordescription" required="true" type="string" hint="Description of the error">
		<cfargument name="incidentdoing" required="false" type="string" hint="what did the incident do">
		<cfargument name="screenshotid" required="false" type="numeric" hint="screenshotid of the incident">
		<cfargument name="siteid" required="false" type="numeric" hint="Id of the site">
		<cfargument name="emailclientid" required="false" type="numeric" hint="email client id of the user when incident occured">
		<cfargument name="browserid" required="false" type="numeric" hint="browser id of the user when incident occured">
		<cfargument name="osid" required="false" type="numeric" hint="os id of the user when incident occured">
		<cfargument name="incidentcategoryid" required="false" type="numeric" hint="Incidentcategory id">
		<cfargument name="error" required="false" type="string" hint="error message generated">
		<cfargument name="screenres" required="false" type="string" hint="resolution of the screen when incident occured">
		<cfargument name="attachment" required="false" type="string" hint="attachment if any">
		<cfargument name="statusid" required="false" type="numeric" hint="status id">
		<cfargument name="solutionid" required="false" type="numeric" hint="solution id">
		<cfargument name="resolvedon" required="false" type="string" hint="date when the problem was resolved">
		<cfargument name="priorityid" required="false" type="numeric" hint="priority of the incident">
		<cfquery name="addincident" datasource="#taskdsn#">
			INSERT INTO INCIDENT
			(
				INCIDENTNAME,
				INCIDENTDESCRIPTION,
				INCIDENTURL,
				NAMEID,
				ERRORDESCRIPTION,
				TIMEREPORTED
				<cfif isDefined('incidentdoing')>
				,INCIDENTDOING
				</cfif>
				<cfif isDefined('SCREENSHOTID')>
				,SCREENSHOTID
				</cfif>
				<cfif isDefined('SITEID')>
				,SITEID
				</cfif>
				<cfif isDefined('EMAILCLIENTID')>
				,EMAILCLIENTID
				</cfif>
				<cfif isDefined('BROWSERID')>
				,BROWSERID
				</cfif>
				<cfif isDefined('OSID')>
				,OSID
				</cfif>
				<cfif isDefined('INCIDENTCATEGORYID')>
				,INCIDENTCATEGORYID
				</cfif>
				<cfif isDefined('ERROR')>
				,ERROR
				</cfif>
				<cfif isDefined('SCREENRES')>
				,SCREENRES
				</cfif>
				<cfif isDefined('TIMEREPORTED')>
				,TIMEREPORTED
				</cfif>
				<cfif isDefined('ATTACHMENT')>
				,ATTACHMENT
				</cfif>
				<cfif isDefined('STATUSID')>
				,STATUSID
				</cfif>
				<cfif isDefined('SOLUTIONID')>
				,SOLUTIONID
				</cfif>
				<cfif isDefined('RESOLVEDON')>
				,RESOLVEDON
				</cfif>
				<cfif isDefined('PRIORITYID')>
				,PRIORITYID
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#incidentname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#incidentdescription#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#incidenturl#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#errordescription#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				<cfif isdefined('incidentdoing')>
					,<cfqueryparam value="#incidentdoing#" cfsqltype="cf_sql_longvarchar">
				</cfif>
				<cfif isdefined('screenshotid')>
					,<cfqueryparam value="#screenshotid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('siteid')>
					,<cfqueryparam value="#siteid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('emailclientid')>
					,<cfqueryparam value="#emailclientid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('browserid')>
					,<cfqueryparam value="#browserid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('osid')>
					,<cfqueryparam value="#osid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('incidentcategoryid')>
					,<cfqueryparam value="#incidentcategoryid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('error')>
					,<cfqueryparam value="#error#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('screenres')>
					,<cfqueryparam value="#screesres#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('timereported')>
					,<cfqueryparam value="#timereported#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('attachment')>
					,<cfqueryparam value="#attachment#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('statusid')>
					,<cfqueryparam value="#statusid#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isdefined('solutionid')>
					,<cfqueryparam value="#solutionid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isdefined('resolvedon')>
					,<cfqueryparam value="#resolvedon#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('priorityid')>
					,<cfqueryparam value="#priorityid#" cfsqltype="cf_sql_integer">
				</cfif>
			)
			SELECT @@IDENTITY AS INCIDENTID
		</cfquery>
		<cfreturn addincident.INCIDENTID>
	</cffunction>
	
	<cffunction name="addTask" access="public" returntype="numeric" hint="add task to the database">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tname" required="true" type="String" hint="name of the task">
		<cfargument name="task_type" required="true" type="String" hint="Type of task">
		<cfargument name="task_description" required="true" type="String" hint="Description of the the task">
		<cfargument name="est_mins" required="true" type="numeric" hint="Estimated number of minutes required for the task">
		<cfargument name="fee" required="true" type="numeric" hint="fee charged for the task">
		<cfquery name="addtask" datasource="#taskdsn#">
			INSERT INTO TASK
			(
				TNAME,
				TASK_TYPE,
				TASK_DESCRIPTION,
				EST_MINS,
				CREATEDON,
				FEE
			)
			VALUES
			(
				<cfqueryparam value="#tname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#task_type#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#task_description#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#est_mins#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#fee#" cfsqltype="cf_sql_integer">
			)
			SELECT @@IDENTITY AS TASKID
			</cfquery>
		<cfreturn addTask.TASKID>
	</cffunction>
	
	<cffunction name="addexpenditureontask" access="public" returntype="void" hint="I add expenditure to task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid of the task">
		<cfargument name="expendedon" required="true" type="String" hint="head on which expenditure is made">
		<cfargument name="amount" required="True" type="numeric" hint="expenditure on the task"> 
		<cfquery name="addexpenditureontask" datasource="#taskdsn#">
			INSERT INTO EXPENDITURE_TASK
			(
				TID,
				EXPENDEDON,
				RECORDEDON,
				AMOUNT
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#expendedon#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#amount#" cfsqltype="cf_sql_integer">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setTaskonProject" access="public" returntype="void" hint="Set the task as a part of project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid from task table">
		<cfargument name="pid" required="true" type="numeric" hint="pid from project table">
		<cfquery name="settaskonproject" datasource="#taskdsn#">
			INSERT INTO TASK_ON_PROJECT
			(
				TID,
				PID
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setTaskonService" access="public" returntype="void" hint="Set the task as a part of Service">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid from task table">
		<cfargument name="serviceid" required="true" type="numeric" hint="serviceid from the service table">
		<cfquery name="settaskonservice" datasource="#taskdsn#">
			INSERT INTO TASK_ON_SERVICE
			(
				TID,
				SERVICEID
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#serviceid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>

	<cffunction name="setTaskonIncident" access="public" returntype="void" hint="Set the task as a solution to incident">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid from task table">
		<cfargument name="incidentid" required="true" type="numeric" hint="incidentid from incident table">
		<cfquery name="settaskonincident" datasource="#taskdsn#">
			INSERT INTO TASK_ON_INCIDENT
			(
				TID,
				INCIDENTID
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>

	<cffunction name="assignTask" access="public" returntype="void" hint="Assign a task to a person. Please check if a person is already assigned the task by running checkTaskAssigned">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid from task table">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who is assigned the task">
		
		<cfquery name="checkworker" datasource="#taskdsn#">
			SELECT TID 
			FROM TASK_ASSIGNED
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
			AND NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">
			AND ACTIVE=1
		</cfquery>
		<cfif checkworker.recordcount EQ 0>
			<cfquery name="settaskasssigned" datasource="#taskdsn#">
				INSERT INTO TASK_ASSIGNED
				(
					TID,
					NAMEID,
					ASSIGNEDON
					
				)
				VALUES
				(
					<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="removePersonFromTask" access="public" returntype="void" hint="remove a perosn from a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid from task table">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who is assigned the task">
		<cfquery name="removefromtask" datasource="#taskdsn#">
			INSERT INTO TASK_ASSIGNED
			(
				TID,
				NAMEID,
				ASSIGNEDON,
				ACTIVE
				
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="0">
			)
			UPDATE TASK_ASSIGNED 
			SET ACTIVE=0 
			WHERE TID=<cfqueryparam value="#tid#"> 
			AND NAMEID=<cfqueryparam value="#nameid#">
		</cfquery>
	</cffunction>

	<cffunction name="setTaskDeadline" access="public" returntype="void" hint="Set task deadline">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="Id of the task">
		<cfargument name="deadline" required="true" type="string" hint="Dead line for the task to be completed">
		<cfquery name="settaskdeadlinee" Datasource="#taskdsn#">
			INSERT INTO TASK_DEADLINE
			(
				TID,
				DEADLINE,
				DEADLINE_SETON
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#deadline#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#">
			)
		</cfquery>
	</cffunction>	
	
	<cffunction name="setTaskStatus" access="public" returntype="void" hint="Set task status">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfargument name="status" required="true" type="String" hint="Status of the task">
		<cfquery name="setProjectStatus" datasource="#taskdsn#">
			INSERT INTO TASK_STATUS
			(
				TID,
				STATUS,
				STATUS_RECORDEDON
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setTaskPriority" access="public" returntype="void" hint="Set priority of the project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid of the task">
		<cfargument name="priority" required="True" type="numeric" hint="pririty of the task"> 
		<cfquery name="settaskpriority" datasource="#taskdsn#">
			INSERT INTO TASK_PRIORITY
			(
				TID,
				PRIORITY,
				PRIORITY_SETON
			)
			VALUES
			(
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#priority#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#timedate#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getTaskassignedId" access="public" returntype="numeric" hint="I get taskassignedid">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid of the task worked on">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who worked on">
		<cfquery name="gettaskassigned" datasource="#taskdsn#">
			SELECT TOP 1 TASKASSIGNEDID, ACTIVE FROM TASK_ASSIGNED
			WHERE NAMEID=<CFQUERYPARAM VALUE="#NAMEID#" Cfsqltype="cf_sql_bigint">
			AND TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
			ORDER BY ASSIGNEDON DESC
		</cfquery>
		<cfif gettaskassigned.recordcount GT 0>
			<cfif gettaskassigned.active EQ 1>
				<cfreturn gettaskassigned.taskassignedid>
			</cfif>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="setWorkPerformed" access="public" returntype="void" hint="Set work performed by each person for a particular task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="taskassignedid" required="true" type="Numeric" hint="taskassignedid for the task assigned">
		<cfargument name="tid" required="true" type="numeric" hint="tid of the task worked on">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who worked on">
		<cfargument name="mins_spent" required="true" type="numeric" hint="time in minutes spent for the task">
		<cfargument name="service" required="false" type="String" hint="type of service given for the task">
		<cfargument name="comments" required="false" type="String" hint="optional comments">
		<cfquery name="setworkperformed" datasource="#taskdsn#">
			INSERT INTO WORK_PERFORMED
			(
				TASKASSIGNEDID,
				TID,
				NAMEID,
				MINS_SPENT,
				<cfif isDefined('service')>
				SERVICE,
				</cfif>
				WORKEDON
				<cfif isDefined('comments')>
				,COMMENTS
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#taskassignedid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#mins_spent#" cfsqltype="cf_sql_integer">,
				<cfif isDefined('service')>
				<cfqueryparam value="#service#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('comments')>
				,<cfqueryparam value="#comments#">
				</cfif>
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getworkperformed" access="public" returntype="query" hint="I get work performed for a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" type="numeric" required="true"  hint="tid of the task">
		<cfquery name="getworkperformed" datasource="#taskdsn#">
			SELECT 
				WORK_PERFORMED.TID, 
				WORK_PERFORMED.NAMEID,
				WORK_PERFORMED.MINS_SPENT,
				WORK_PERFORMED.SERVICE,
				WORK_PERFORMED.WORKEDON,
				WORK_PERFORMED.COMMENTS, 
				NAME.FIRSTNAME, 
				NAME.LASTNAME, 
				NAME.WEMAIL,
				TASK.TASK_DESCRIPTION
			FROM WORK_PERFORMED,TASK,NAME
			WHERE WORK_PERFORMED.TID=TASK.TID
			AND WORK_PERFORMED.NAMEID=NAME.NAMEID
			AND WORK_PERFORMED.TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint"> 
		</cfquery>
		<cfreturn getworkperformed>
	</cffunction>

	<cffunction name="addComment" access="public" returntype="numeric" hint="Write a comment">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="comment" required="true" type="String" hint="Comment">
		<cfargument name="createdby" required="true" type="numeric" hint="Nameid of a person who is making the comment">
		<cfargument name="sendemail" required="false" type="String" hint="pass 1 if email should be sent to client">
		<cfquery name="addcomment" datasource="#taskdsn#">
			INSERT INTO COMMENTS
			(
				COMMENT,
				CREATEDBY,
				RECORDEDON
				<cfif isDefined('sendemail')>
				,EMAILEDTOCLIENT
				</cfif>
				
			)
			VALUES
			(
				<cfqueryparam value="#comment#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#createdby#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('sendemail')>
				,1
				</cfif>
			)
			SELECT @@IDENTITY AS CID
		</cfquery>
		<cfreturn addcomment.CID>
	</cffunction>

	<cffunction name="setCommentsOnProject" access="public" returntype="void" hint="Set a comment for a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="cid" required="true" type="numeric" hint="Comment id"> 
		<cfargument name="pid" required="true" type="numeric" hint="Project id">
		<cfquery name="setcommentsonproject" datasource="#taskdsn#">
			INSERT INTO COMMENTS_ON_PROJECT
			(
				CID,
				PID
			)
			VALUES
			(
				<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setCommentsOnTask" access="public" returntype="void" hint="Set a comment for a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="cid" required="true" type="numeric" hint="Comment id"> 
		<cfargument name="tid" required="true" type="numeric" hint="Task id">
		<cfquery name="setcommentsontask" datasource="#taskdsn#">
			
			INSERT INTO COMMENTS_ON_TASK
			(
				CID,
				TID
			)
			VALUES
			(
				<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="setCommentsOnIncident" access="public" returntype="void" hint="Set a comment for a incident">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="cid" required="true" type="numeric" hint="Comment id"> 
		<cfargument name="incidentid" required="true" type="numeric" hint="Incident id">
		<cfquery name="setcommentsonincident" datasource="#taskdsn#">
			INSERT INTO COMMENTS_ON_INCIDENT
			(
				CID,
				INCIDENTID
			)
			VALUES
			(
				<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="sendCommentTo" access="public" returntype="void" hint="Send comments to certain person">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="cid" required="true" type="numeric" hint="Comment id"> 
		<cfargument name="tonameid" required="true" type="numeric" hint="nameid of the person whom the comment is intended">
		<cfquery name="sendcommentto" datasource="#taskdsn#">
			INSERT INTO SEND_COMMENTS_TO
			(
				CID,
				NAMEID
			)
			VALUES
			(
				<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#tonameid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addSolution" access="public" returntype="numeric" hint="Add a comment as a solution">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="cid" required="true" type="numeric" hint="Comment id"> 
		<cfargument name="incidentid" required="true" type="numeric" hint="Incident id">
		<cfquery name="addSolution" datasource="#taskdsn#">
			INSERT INTO SOLUTION
			(
				CID,
				INCIDENTID
			)
			VALUES
			(
				<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_bigint">
			)
			SELECT @@IDENTITY AS SOLUTIONID
		</cfquery>
		<cfreturn addSolution.SOLUTIONID>
	</cffunction>
	
	<cffunction name="setProjectasComplete" access="public" hint="Set a project as complete">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfargument name="mins_spent">
		<cfquery name="setprojectascomplete" datasource="#taskdsn#">
			INSERT INTO COMPLETED_PROJECT
			(
				PID,
				COMPLETEDON,
				MINS_SPENT
			)
			VALUES
			(
				<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#timedate#">,
				<cfqueryparam value="#mins_spent#" cfsqltype="cf_sql_integer">
			)
			UPDATE TABLE PROJECT_MANAGER 
			SET ACTIVE=0 
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>

	<cffunction name="totalMinsForTask" access="public" returntype="numeric" hint="I calculate the total time taken  to complete a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfquery name="gettotalmins" datasource="#taskdsn#">
			SELECT SUM(MINS_SPENT) AS TOTALMINS
			FROM WORK_PERFORMED
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfif gettotalmins.TOTALMINS NEQ "">
		<cfreturn gettotalmins.TOTALMINS>
		<cfelse>
		<cfreturn 0>
		</cfif>
	</cffunction>

	<cffunction name="totalMinsForProject" access="public" returntype="numeric" output ="false" hint="I calculate the total time taken to complete a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfset sum=0>
		<cfquery name="getalltask" datasource="#taskdsn#">
			SELECT TID
			FROM TASK_ON_PROJECT
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfoutput query="getalltask">
			<cfinvoke method="totalMinsForTask" taskdsn="#taskdsn#" returnvariable="minsfortask" tid="#getalltask.TID#">
			<cfset sum = sum + minsfortask>	
		</cfoutput>
		<cfreturn sum>
	</cffunction>
	
	<cffunction name="getTaskPriority" access="public" returntype="Query" hint="I get the priority of a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfquery name="gettaskpriority" datasource="#taskdsn#">
			SELECT PRIORITY_SETON AS RECORDEDON, 
				PRIORITY 
			FROM TASK_PRIORITY 
			WHERE TID=<cfqueryparam  value="#tid#" cfsqltype="cf_sql_bigint"> 
			ORDER BY PRIORITY_SETON DESC
		</cfquery>
		<cfreturn gettaskpriority>
	</cffunction>
	
	<cffunction name="getProjectPriority" access="public" returntype="query" hint="I get the priority of a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfquery name="getprojectpriority" datasource="#taskdsn#">
			SELECT 
				SETON, 
				PRIORITY 
			FROM PROJECT_PRIORITY 
			WHERE PID=<cfqueryparam  value="#pid#" cfsqltype="cf_sql_bigint"> 
			ORDER BY SETON DESC
		</cfquery>
		<cfreturn getprojectpriority>
	</cffunction>
	
	<cffunction name="getMyTasks" access="public" returntype="query" hint="I get all task a person is assigned. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="true" type="numeric" hint="NAMEID of the project">
		<cfargument name="taskstatus" required="false" type="string" default="0">
		<cfargument name="excludetaskstatus" required="false" type="string" default="0">
		<cfset var getthetasks = 0>
		<cfquery name="getthetasks" datasource="#arguments.taskdsn#">
			SELECT 
				TASK_ASSIGNED.TID, 
				TASK.TASK_TYPE, 
				TASK.TNAME, 
				TASK.TASK_DESCRIPTION, 
				TASK.CREATEDON, 
				TASK.EST_MINS
			FROM TASK_ASSIGNED, TASK
			WHERE TASK_ASSIGNED.NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">
			AND TASK_ASSIGNED.TID=TASK.TID
			AND TASK_ASSIGNED.ACTIVE=1
			<cfif arguments.taskstatus neq 0>
			AND TASK.TID IN
			(SELECT TASK_STATUS.TID 
			FROM TASK_STATUS 
			WHERE STATUS=<cfqueryparam value="#arguments.taskstatus#">)
			</cfif>
			<cfif arguments.excludetaskstatus neq 0>
			AND TASK.TID NOT IN
			(SELECT TASK_STATUS.TID 
			FROM TASK_STATUS 
			WHERE STATUS=<cfqueryparam value="#arguments.excludetaskstatus#">)
			</cfif>			
		</cfquery>
		<cfreturn getthetasks>
	</cffunction>

	<cffunction name="checkTaskAssigned" access="public" returntype="boolean" hint="I check if a task is assigned to a person">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="true" type="numeric" hint="NAMEID of the person">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfquery name="checktaskassigned" datasource="#taskdsn#">
			SELECT TID
			FROM TASK_ASSIGNED
			WHERE TID=<cfqueryparam value="#tid#">
			AND NAMEID=<cfqueryparam value="#nameid#"> 
			AND ACTIVE=1
		</cfquery>
		<cfif checktaskassigned.recordcount gt 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
	
	<cffunction name="getProjectStatus" access="public" returntype="Query" hint="I get the status of the project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the project">
		<cfquery name="getprojectstatus" datasource="#taskdsn#">
			SELECT 
				STATUS, 
				RECORDEDON
			FROM PROJECT_STATUS
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint"> ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn getprojectstatus>
	</cffunction>
	
	<cffunction name="getTaskStatus" access="public" returntype="Query" hint="I get the status of the task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the tasl">
		<cfquery name="gettaskstatus" datasource="#taskdsn#">
			SELECT 
				STATUS, 
				STATUS_RECORDEDON AS RECORDEDON 
			FROM TASK_STATUS
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint"> 
			ORDER BY STATUS_RECORDEDON DESC
		</cfquery>
		<cfreturn gettaskstatus>
	</cffunction>
	
	<cffunction name="getMyProjects" access="public" returntype="query" hint="I get all the projects managed by a person. Output query fields: PID, PNAME, DESCRIPTION, CREATEDON, CLIENTID, SITE_URL, TYPE, FEE, ETA">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="true" type="numeric" hint="NAMEID of the manager">
		<cfquery name="getmyprojects" datasource="#taskdsn#">
			SELECT 
				PROJECT_MANAGER.PID, 
				PROJECT.PNAME, 
				PROJECT.DESCRIPTION, 
				PROJECT.CREATEDON, 
				PROJECT.CLIENTID,
				PROJECT.SITE_URL,
				PROJECT.TYPE,
				PROJECT.FEE,
				PROJECT.ETA   
			FROM PROJECT_MANAGER, PROJECT
			WHERE MANAGERID=<cfqueryparam  value="#nameid#" cfsqltype="cf_sql_bigint">
			AND PROJECT_MANAGER.PID=PROJECT.PID
			AND PROJECT_MANAGER.ACTIVE=1
		</cfquery>
		<cfreturn getmyprojects>
	</cffunction>
	
	<cffunction name="getProjectDeadline" access="public" returntype="query" hint="I return project deadline for a particular project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the Project">
		<cfquery name="gettaskdeadline" datasource="#taskdsn#">
			SELECT  
				DEADLINE, 
				DEADLINE_SETON AS RECORDEDON
			FROM PROJECT_DEADLINE
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint"> ORDER BY DEADLINE_SETON DESC
		</cfquery>
		<cfreturn gettaskdeadline>
	</cffunction>
	
	<cffunction name="getTaskDeadline" access="public" returntype="query" hint="I return task deadline for a particular task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfquery name="gettaskdeadline" datasource="#taskdsn#">
			SELECT 
				DEADLINE, 
				DEADLINE_SETON AS RECORDEDON
			FROM TASK_DEADLINE
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint"> 
			ORDER BY DEADLINE_SETON DESC
		</cfquery>
		<cfreturn gettaskdeadline>
	</cffunction>
	
	<cffunction name="getTasks" access="public" returntype="query" hint="I get all the current tasks. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION, EST_MINS, CREATEDON">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="taskid" required="false" type="numeric" hint="tid of a task">
		<cfquery name="gettasks" datasource="#taskdsn#">
			SELECT  
				TASK.TID, 
				TASK.TNAME, 
				TASK.TASK_TYPE, 
				TASK.TASK_DESCRIPTION, 
				TASK.EST_MINS, 
				TASK.CREATEDON, 
				TASK.FEE,
				<!--- PROJECT.PNAME,
				PROJECT.PID, --->
				(SELECT TOP 1 PRIORITY 
				FROM TASK_PRIORITY 
				WHERE TASK_PRIORITY.TID=TASK.TID
				ORDER BY PRIORITY_SETON DESC) AS PRIORITY,
				(SELECT TOP 1 DEADLINE 
				FROM TASK_DEADLINE 
				WHERE TASK_DEADLINE.TID=TASK.TID
				ORDER BY DEADLINE_SETON DESC) AS DEADLINE,
				(SELECT TOP 1 STATUS 
				FROM TASK_STATUS 
				WHERE TASK_STATUS.TID=TASK.TID
				ORDER BY STATUS_RECORDEDON DESC) AS TASKSTATUS
			FROM TASK<!--- , PROJECT, TASK_ON_PROJECT --->
			WHERE <!--- TASK_ON_PROJECT.TID=TASK.TID
			AND TASK_ON_PROJECT.PID=PROJECT.PID
			AND ---> TASK.TID NOT IN
			(SELECT TASK_STATUS.TID 
			FROM TASK_STATUS 
			WHERE STATUS='complete')
			<cfif isDefined('taskid')>AND TASK.TID=<cfqueryparam value="#taskid#" cfsqltype="cf_sql_bigint"></cfif>
			ORDER BY TASK.CREATEDON DESC
		</cfquery>
		<cfreturn gettasks>
	</cffunction>
	
	<cffunction name="getCompletedTasks" access="public" returntype="query" hint="I get all the completed tasks. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION, EST_MINS, CREATEDON">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="taskid" required="false" type="numeric" hint="tid of the task">
		<cfquery name="getcompletedtasks" datasource="#taskdsn#">
			SELECT  
				TID, 
				TNAME, 
				TASK_TYPE, 
				TASK_DESCRIPTION, 
				EST_MINS, 
				CREATEDON
			FROM TASK
			WHERE TID IN(SELECT TID FROM TASK_STATUS WHERE STATUS='complete')
			<cfif isDefined('taskid')>
			AND TID=<cfqueryparam value="#taskid#" cfsqltype="cf_sql_bigint">
			</cfif>
			ORDER BY CREATEDON
		</cfquery>
		<cfreturn getcompletedtasks>
	</cffunction>
	
	<cffunction name="getProjects" access="public" returntype="query" hint="I get all current projects. Output query fields: PID, PNAME, DESCRIPTION, CREATEDON, SITE_URL, TYPE, FEE, ETA">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="projectid" required="false" type="Numeric" hint="pid of the project">
		<cfquery name="getprojects" datasource="#taskdsn#">
			SELECT 
				PROJECT.PID, 
				PROJECT.PNAME, 
				PROJECT.DESCRIPTION, 
				PROJECT.CREATEDON, 
				PROJECT.SITE_URL,
				PROJECT.TYPE,
				PROJECT.FEE,
				PROJECT.ETA,
				(SELECT TOP 1 PRIORITY 
				FROM PROJECT_PRIORITY 
				WHERE PROJECT_PRIORITY.PID=PROJECT.PID
				ORDER BY SETON DESC) AS PRIORITY,
				(SELECT TOP 1 DEADLINE 
				FROM PROJECT_DEADLINE 
				WHERE PROJECT_DEADLINE.PID=PROJECT.PID
				ORDER BY DEADLINE_SETON DESC) AS DEADLINE,
				(SELECT TOP 1 STATUS 
				FROM PROJECT_STATUS 
				WHERE PROJECT_STATUS.PID=PROJECT.PID
				ORDER BY RECORDEDON DESC) AS PROJECTSTATUS
			FROM PROJECT
			WHERE PID NOT IN(SELECT PID FROM PROJECT_STATUS WHERE STATUS='complete')
			<cfif isDefined('projectid')>
			AND PID=<cfqueryparam value="#projectid#" cfsqltype="cf_sql_bigint">
			</cfif>   
			ORDER BY CREATEDON DESC
		</cfquery>
		<cfreturn getprojects>
	</cffunction>

	<cffunction name="getCompletedProjects" access="public" returntype="query" hint="I get all completed projects. Output query fields: PID, PNAME, DESCRIPTION, CREATEDON, SITE_URL, TYPE, FEE, ETA">
	<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
	<cfargument name="projectid" required="false" type="Numeric" hint="pid of the project">
	<cfquery name="getcompletedprojects" datasource="#taskdsn#">
		SELECT 
			PROJECT.PID, 
			PROJECT.PNAME, 
			PROJECT.DESCRIPTION, 
			PROJECT.CREATEDON, 
			PROJECT.SITE_URL,
			PROJECT.TYPE,
			PROJECT.FEE,
			PROJECT.ETA,
			(SELECT TOP 1 PRIORITY 
			FROM PROJECT_PRIORITY 
			WHERE PROJECT_PRIORITY.PID=PROJECT.PID
			ORDER BY SETON DESC) AS PRIORITY,
			(SELECT TOP 1 DEADLINE 
			FROM PROJECT_DEADLINE 
			WHERE PROJECT_DEADLINE.PID=PROJECT.PID
			ORDER BY DEADLINE_SETON DESC) AS DEADLINE,
			(SELECT TOP 1 STATUS 
			FROM PROJECT_STATUS 
			WHERE PROJECT_STATUS.PID=PROJECT.PID
			ORDER BY RECORDEDON DESC) AS PROJECTSTATUS
		FROM PROJECT
		WHERE PID IN(SELECT PID FROM PROJECT_STATUS WHERE STATUS='complete')
		<cfif isDefined('projectid')>
		AND PID=<cfqueryparam value="#projectid#" cfsqltype="cf_sql_bigint">
		</cfif> 
		ORDER BY CREATEDON  
	</cfquery>
	<cfreturn getcompletedprojects>
</cffunction>

	<cffunction name="getCommentsOnTask" access="public" returntype="query" hint="I get all the comments for a given task. Output query fields: CID, COMMENT, CREATEDBY">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="TID of the task">
		<cfquery name="getallcommentsontask" datasource="#taskdsn#">
			SELECT 
				COMMENTS_ON_TASK.CID,
				COMMENTS.RECORDEDON,
				COMMENTS.COMMENT,
				COMMENTS.CREATEDBY,
				NAME.FIRSTNAME,
				NAME.LASTNAME
			FROM COMMENTS_ON_TASK, COMMENTS, NAME
			WHERE COMMENTS_ON_TASK.TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
			AND COMMENTS.CREATEDBY=NAME.NAMEID
			AND COMMENTS_ON_TASK.CID=COMMENTS.CID
		</cfquery>
		<cfreturn getallcommentsontask>
	</cffunction>
	
	<cffunction name="getAllCommentsMadeByNameid" access="public" returntype="query" hint="I get all the comments made by a person on all tasks. Output query fields: TID, CID, COMMENT">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of a person who made the commenk">
		<cfquery name="getallcommentsmadebynameid" datasource="#taskdsn#">
			SELECT
				COMMENTS_ON_TASK.TID, 
				COMMENTS_ON_TASK.CID,
				COMMENTS.COMMENT
			FROM COMMENTS_ON_TASK, COMMENTS
			WHERE COMMENTS.CREATEDBY=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">
			AND COMMENTS_ON_TASK.CID=COMMENTS.CID
		</cfquery>
		<cfreturn getallcommentsmadebynameid>
	</cffunction>
	
	<cffunction name="getAllCommentsOnIncident" access="public" returntype="query" hint="I get all the comments for a given incident. Output query fields: CID, COMMENT, CREATEDBY">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="incidentid" required="true" type="numeric" hint="INCIDENTID of the INCIDENT">
		<cfquery name="getallcommentsonincident" datasource="#taskdsn#">
			SELECT 
				COMMENTS_ON_INCIDENT.CID,
				COMMENTS.COMMENT,
				COMMENTS.CREATEDBY,
				COMMENTS.RECORDEDON
			FROM COMMENTS_ON_INCIDENT, COMMENTS
			WHERE COMMENTS_ON_INCIDENT.INCIDENTID=<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_bigint">
			AND COMMENTS_ON_INCIDENT.CID=COMMENTS.CID
			ORDER BY COMMENTS_ON_INCIDENT.CID DESC
		</cfquery>
		<cfreturn getallcommentsonincident>
	</cffunction>
	
	<cffunction name="getAllCommentsOnProject" access="public" returntype="query" hint="I get all the comments for a given Project. Output query fields: CID, COMMENT, CREATEDBY">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the Project">
		<cfquery name="getallcommentsonproject" datasource="#taskdsn#">
			SELECT 
				COMMENTS_ON_PROJECT.CID,
				COMMENTS.RECORDEDON,
				COMMENTS.COMMENT,
				COMMENTS.CREATEDBY,
				NAME.FIRSTNAME,
				NAME.LASTNAME
			FROM COMMENTS_ON_PROJECT, COMMENTS, NAME
			WHERE COMMENTS_ON_PROJECT.PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
			AND COMMENTS_ON_PROJECT.CID=COMMENTS.CID
			AND COMMENTS.CREATEDBY=NAME.NAMEID
		</cfquery>
		<cfreturn getallcommentsonproject>
	</cffunction>
	
	<cffunction name="getAllTasksOnProject" access="public" returntype="query" hint="I get all the tasks created for a project. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the Project">
		<cfquery name="getalltasksonproject" datasource="#taskdsn#">
			SELECT 
			TASK.TID, 
			TASK.TASK_TYPE, 
			TASK.TNAME, 
			TASK.TASK_DESCRIPTION, 
			TASK.EST_MINS, 
			TASK.CREATEDON,
			(SELECT TOP 1 PRIORITY 
				FROM TASK_PRIORITY 
				WHERE TASK_PRIORITY.TID=TASK.TID
				ORDER BY PRIORITY_SETON DESC) AS PRIORITY,
				(SELECT TOP 1 DEADLINE 
				FROM TASK_DEADLINE 
				WHERE TASK_DEADLINE.TID=TASK.TID
				ORDER BY DEADLINE_SETON DESC) AS DEADLINE,
				(SELECT TOP 1 STATUS 
				FROM TASK_STATUS 
				WHERE TASK_STATUS.TID=TASK.TID
				ORDER BY STATUS_RECORDEDON DESC) AS TASKSTATUS
			FROM TASK, TASK_ON_PROJECT
			WHERE TASK_ON_PROJECT.TID=TASK.TID
			AND TASK_ON_PROJECT.PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getalltasksonproject>
	</cffunction>
	
	<cffunction name="getUnfinishedTaskonProject" access="public" returntype="query" hint="I get all the unfinished tasks for a project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="PID of the Project">
		<cfquery name="getunfinishedtaskonproject" datasource="#taskdsn#">
			SELECT TASK.TID, TASK.TASK_TYPE, TASK.TNAME, TASK.TASK_DESCRIPTION, TASK.EST_MINS, TASK.CREATEDON
			FROM TASK, TASK_ON_PROJECT, TASK_STATUS
			WHERE TASK_ON_PROJECT.TID=TASK.TID
			AND TASK_ON_PROJECT.TID=TASK_STATUS.TID
			AND TASK_STATUS.STATUS<>'complete'
			AND TASK_ON_PROJECT.PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getunfinishedtaskonproject>
	</cffunction>
	
	<cffunction name="getAllTasksOnIncident" access="public" returntype="query" hint="I get all the tasks created for a incident. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="incidentid" required="true" type="numeric" hint="INCIDENTID of the incident">
		<cfquery name="getalltasksonincident" datasource="#taskdsn#">
			SELECT TASK_ON_INCIDENT.TID, TASK.TASK_TYPE, TASK.TASK_DESCRIPTION
			FROM TASK, TASK_ON_INCIDENT
			WHERE TASK_ON_INCIDENT.TID=TASK.TID
			AND TASK_ON_INCIDENT.INCIDENTID=<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getalltasksonincident>
	</cffunction>
	
	<cffunction name="getAllTasksOnService" access="public" returntype="query" hint="I get all the tasks created for a Service. Output query fields: TID, TASK_TYPE, TASK_DESCRIPTION">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="serviceid" required="true" type="numeric" hint="SERVICEID of the service">
		<cfquery name="getalltasksonservice" datasource="#taskdsn#">
			SELECT TASK_ON_SERVICE.TID, TASK.TASK_TYPE, TASK.TASK_DESCRIPTION
			FROM TASK, TASK_ON_SERVICE
			WHERE TASK_ON_SERVICE.TID=TASK.TID
			AND TASK_ON_SERVICE.SERVICEID=<cfqueryparam value="#serviceid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getalltasksonservice>
	</cffunction>
	
	<cffunction name="updateTask" access="public" returntype="void" hint="I update task">		
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="String" hint="TID of a task">
		<cfargument name="task_type" required="true" type="String" hint="Type of task">
		<cfargument name="task_description" required="true" type="String" hint="Description of the the task">
		<cfargument name="est_mins" required="true" type="numeric" hint="Estimated number of minutes required for the task">
		<cfquery name="updatetask" datasource="#taskdsn#">
			UPDATE TASK
			SET
				TASK_TYPE=<cfqueryparam value="#task_type#" cfsqltype="cf_sql_varchar">,
				TASK_DESCRIPTION=<cfqueryparam value="#task_description#" cfsqltype="cf_sql_longvarchar">,
				EST_MINS=<cfqueryparam value="#est_mins#" cfsqltype="cf_sql_integer">
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>

	<cffunction name="updateService" access="public" returntype="void" hint="I update Service">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="serviceid" required="true" type="numeric" hint="Serviceid of the Service"> 
		<cfargument name="servicename" required="true" type="String" hint="Name of the service">
		<cfargument name="servicedescription" required="true" type="String" hint="Description of the service">
		<cfargument name="estimatedfee" required="true" type="numeric" hint="Fee for the service">
		<cfargument name="per" required="true" type="numeric" hint="">
		<cfargument name="pagename" required="true" type="string" hint="Name of the page">
		<cfargument name="status" required="false" type="String" hint="Status of the service">
		<cfargument name="resellerprice" required="false" type="numeric" hint="Price at which reseller should sell the service">
		<cfargument name="resellerfee" required="false" type="numeric" hint="Reseller fee">
		<cfquery name="updateservice" datasource="#taskdsn#">
			INSERT INTO SERVICE
			SET
				SERVICENAME=<cfqueryparam value="#servicename#" cfsqltype="cf_sql_varchar">,
				SERVICEDESCRIPTION=<cfqueryparam value="#servicedescription#" cfsqltype="cf_sql_longvarchar">,
				ESTIMATEDFEE=<cfqueryparam value="#estimatedfee#" cfsqltype="cf_sql_money">,
				PER=<cfqueryparam value="#per#" cfsqltype="cf_sql_integer">,
				PAGENAME=<cfqueryparam value="#pagename#" cfsqltype="cf_sql_varchar">,
				STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">,
				RESELLERPRICE=<cfqueryparam value="#resellerprice#" cfsqltype="cf_sql_money">,
				RESELLERFEE=<cfqueryparam value="#resellerfee#" cfsqltype="cf_sql_money">
			WHERE SERVICEID=<cfqueryparam value="#serviceid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="getpid" access="public" returntype="Numeric" hint="I get pid from tid">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="Numeric" hint="tid of the task">
		<cfquery name="getpid" datasource="#taskdsn#">
			SELECT PID 
			FROM TASK_ON_PROJECT
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getpid.PID>
	</cffunction>
	
	<cffunction name="edittask_on_project" access="public" returntype="void" hint="I change id in task on project">
	<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
	<cfargument name="tid" required="true" type="Numeric" hint="tid of the task">
	<cfargument name="pid" required="true" type="Numeric" hint="pid of the project">
	<cfquery name="edittask_on_project" datasource="#taskdsn#">
		UPDATE TASK_ON_PROJECT
		SET PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
	</cfquery>
	</cffunction>
	
	<cffunction name="editTask" access="public" returntype="void" hint="edit task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="tid of the task">
		<cfargument name="task_description" required="true" type="String" hint="Description of the task">
		<cfargument name="task_type" required="false" type="String" hint="Type of  task">
		<cfargument name="est_mins" required="false" type="Numeric" hint="Estimated number of minutes required to complete task">
		<cfargument name="fee" required="false" type="Numeric" hint="Fee for the task">
		<cfquery name="edittask" datasource="#taskdsn#">
			UPDATE TASK
			SET TASK_DESCRIPTION=<cfqueryparam value="#task_description#" cfsqltype="cf_sql_longvarchar">
			<cfif isDefined('task_type')>
			,TASK_TYPE=<cfqueryparam value="#task_type#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('est_mins')>
			,EST_MINS=<cfqueryparam value="#est_mins#" cfsqltype="cf_sql_bigint">
			</cfif>
			<cfif isDefined('fee')>
			,FEE=<cfqueryparam value="#fee#" cfsqltype="cf_sql_integer">
			</cfif>
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="getWorkers" access="public" returntype="query" hint="get people working in a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="false" default="0" type="numeric" hint="tid of the task">
		<cfset var getworkers=0>
		<cfquery name="getworkers" datasource="#arguments.taskdsn#">
			SELECT 
				TASK_ASSIGNED.TID, 
				TASK_ASSIGNED.NAMEID, 
				TASK_ASSIGNED.ASSIGNEDON, 
				NAME.FIRSTNAME, 
				NAME.LASTNAME, 
				NAME.WEMAIL
			FROM TASK_ASSIGNED, NAME
			WHERE TASK_ASSIGNED.NAMEID=NAME.NAMEID
			<cfif arguments.tid neq 0>
				AND TASK_ASSIGNED.TID=<cfqueryparam value="#arguments.tid#" cfsqltype="cf_sql_bigint">
				AND TASK_ASSIGNED.ACTIVE=1
			<cfelse>
				ORDER BY TASK_ASSIGNED.NAMEID
			</cfif>
		</cfquery>
		<cfreturn getworkers>
	</cffunction>
	
	<cffunction name="getProjectName" access="public" returntype="String" hint="get name of the project">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="pid of the task">
		<cfquery name="getprojectName" datasource="#taskdsn#">
			SELECT PNAME
			FROM PROJECT
			WHERE PID=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint"> 
		</cfquery>
		<cfreturn getprojectName.PNAME>
	</cffunction>
	
	<cffunction name="getpidanddesc" access="public" returntype="query" hint="get task description">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="pid of the task">
		<cfquery name="getpidanddesc" datasource="#taskdsn#">
			SELECT 
				TASK.TNAME, 
				TASK.TASK_DESCRIPTION, 
				TASK_ON_PROJECT.PID
			FROM TASK, TASK_ON_PROJECT
			WHERE TASK.TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint"> 
			AND TASK_ON_PROJECT.TID=TASK.TID
		</cfquery>
		<cfreturn getpidanddesc>
	</cffunction>
	
	<cffunction name="getexpenditure" access="public" returntype="query" hint="I get all the expenses for a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="pid of the task">
		<cfquery name="getexpenditure" datasource="#taskdsn#">
			SELECT 
				ID, 
				TID, 
				EXPENDEDON, 
				RECORDEDON, 
				AMOUNT
			FROM EXPENDITURE_TASK
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getexpenditure> 
	</cffunction>
	 
	<cffunction name="getsolutions" access="public" returntype="query" hint="I get all the solutions for a incident">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="incidentid" required="true" type="numeric" hint="Incident id">
		<cfset var solutions=0>
		<cfquery name="solutions" datasource="#taskdsn#">
			SELECT 
			CID 
			FROM SOLUTION
			WHERE INCIDENTID=<cfqueryparam value="#incidentid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn solutions>
	</cffunction>
	
	<cffunction name="totalexpenditure_task" access="public" returntype="numeric" hint="I get total expenditure for a task">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="true" type="numeric" hint="pid of the task">
		<cfquery name="totalexpenditure" datasource="#taskdsn#">
			SELECT TID, SUM(AMOUNT) AS TOTAL
			FROM EXPENDITURE_TASK
			WHERE TID=<cfqueryparam value="#tid#" cfsqltype="cf_sql_bigint">
			GROUP BY TID
		</cfquery>
		<cfif totalexpenditure.recordcount EQ 0>
		<cfreturn 0>
		<cfabort>
		</cfif>
		
		<cfreturn totalexpenditure.total>
	</cffunction>
	
	<cffunction name="createclientgroup" access="public" returntype="string" hint="I create a usergroup named client">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		
		<cfquery name="checkclient" datasource="#taskdsn#">
			SELECT USERGROUPID
			FROM USERGROUPS
			WHERE USERGROUPNAME='clients'
		</cfquery>
		<cfif checkclient.recordcount NEQ 0>
		<cfquery name="clientgroup" datasource="#taskdsn#">
			INSERT INTO USERGROUPS
			(
				USERGROUPID,
				USERGROUPNAME
			)
			
			VALUES
			(
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				'clients'
			)
		</cfquery>
		</cfif>
			
	</cffunction>
	
	<cffunction name="removeClient" access="public" returntype="void" hint="I remove a client">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="pid of the project">
		<cfargument name="cid" required="true" type="numeric" hint="nameid of the client">
		<cfquery name="deactivateclient" datasource="#taskdsn#">
			UPDATE CLIENTS_FOR_PROJECT
			SET ACTIVE=0
			WHERE cid=<cfqueryparam value="#cid#" cfsqltype="cf_sql_bigint">
			AND pid=<cfqueryparam value="#pid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfquery name="removeclient" datasource="#taskdsn#">
			INSERT INTO CLIENTS_FOR_PROJECT
			(
				RECORDEDON,
				PID,
				CID,
				ACTIVE
			)
			VALUES
			(
				<CFQUERYPARAM VALUE="#TIMEDATE#" Cfsqltype="cf_sql_bigint">,
				<CFQUERYPARAM VALUE="#PID#" Cfsqltype="Cf_sql_bigint">,
				<CFQUERYparam VALUE="#CID#" Cfsqltype="cf_sql_bigint">,
				0			
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getIncidentFromTask" access="public" returntype="query" hint="I get incidentid from taskid">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="tid" required="false" type="numeric" hint="tid of a task">
		<cfset var incident=0>
		<cfquery name="incident" datasource="#arguments.taskdsn#">
			SELECT 
			INCIDENTID 
			FROM TASK_ON_INCIDENT
			WHERE TID=<cfqueryparam value="#arguments.tid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn incident>
	</cffunction>
	
	<cffunction name="canProjectComplete" access="public" returntype="boolean" hint="checks if all tasks of the project are completed">
		<cfargument name="taskdsn" required="true" type="String" hint="Datasource">
		<cfargument name="pid" required="true" type="numeric" hint="pid of the project">
		<cfinvoke method="getAllTasksOnProject" returnvariable="tasks" taskdsn="#taskdsn#" pid="#pid#">
		<cfloop query="tasks">
			<cfquery name="iscomplete" datasource="#taskdsn#">
				SELECT TID FROM TASK_STATUS
				WHERE STATUS='complete'
				AND TID=#tasks.tid#
			</cfquery>
			<cfif iscomplete.recordcount EQ 0>
			<cfreturn FALSE>
			</cfif>
		</cfloop>
		<cfreturn TRUE>
	</cffunction>
</cfcomponent>

