<cfcomponent hint="I have function for franchise Application">
	<cffunction name="createtables" access="public" returntype="void" hint="I create table required for franchise Application">
		<!--- EXEC sp_rename 'business.products_serveices', 'PRODUCTS_SERVICES', 'COLUMN' --->
		<cfquery name="employmenttable" datasource="#arguments.ds#">
			CREATE TABLE PERSONALINFO
			(
				PERSONALINFOID BIGINT NOT NULL IDENTITY(1,1),
				WEMAIL VARCHAR(64) NOT NULL,
				FIRSTNAME VARCHAR(64) NOT NULL,
				LASTNAME VARCHAR(64) NOT NULL,
				MIDDLENAME VARCHAR(64),
				MAIDENNAME VARCHAR(64) NOT NULL,
				HPHONE VARCHAR(64) NOT NULL,
				GENDER VARCHAR(1) DEFAULT 1,
				DOB VARCHAR(16) NOT NULL,
				MARITALSTATUS VARCHAR(1) DEFAULT 2,
				SPOUSENAME VARCHAR(128) NOT NULL
			);
			ALTER TABLE PERSONALINFO ADD CONSTRAINT PK_PERSONALINFO PRIMARY KEY(PERSONALINFOID);
			
			CREATE TABLE RESIDENCEINFO
			(
				RESIDENCEINFOID BIGINT NOT NULL IDENTITY(1,1),
				PERSONALINFOID BIGINT NOT NULL,
				STARTDATE VARCHAR(16) NOT NULL,
				ENDDATE VARCHAR(16) NOT NULL,
				ADDRESS1 VARCHAR(256) NOT NULL,
				ADDRESS2 VARCHAR(256) NOT NULL,
				CITY VARCHAR(256) NOT NULL,
				STATE VARCHAR(32),
				COUNTY VARCHAR(64),
				COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
			);
			ALTER TABLE RESIDENCEINFO ADD CONSTRAINT PK_RESIDENCEINFO PRIMARY KEY(RESIDENCEINFOID);
			ALTER TABLE RESIDENCEINFO ADD CONSTRAINT FK_RESIDENCEINFO_PERSONALINFO FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);
			
			CREATE TABLE EMPLOYMENT
			(
				EMPLOYMENTID BIGINT NOT NULL IDENTITY(1,1),
				PERSONALINFOID BIGINT NOT NULL,
				TITLE VARCHAR(128) NOT NULL,
				COMPANY VARCHAR(128) NOT NULL,
				STARTDATE VARCHAR(16) NOT NULL,
				ENDDATE VARCHAR(16) NOT NULL,
				RESPONSIBILITIES NTEXT NOT NULL,
				SUPERVISOR_NAME VARCHAR(64),
				SUPERVISOR_PH_NUMBER VARCHAR(32),
				ADDRESS1 VARCHAR(256) NOT NULL,
				ADDRESS2 VARCHAR(256),
				CITY VARCHAR(256) NOT NULL,
				STATE VARCHAR(32),
				ZIP VARCHAR(16),
				COUNTY VARCHAR(64),
				COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
			);
			ALTER TABLE EMPLOYMENT ADD CONSTRAINT PK_EMPLOYMENT PRIMARY KEY(EMPLOYMENTID);
			ALTER TABLE EMPLOYMENT ADD CONSTRAINT FK_EMPLOYMENT_NAME FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);

			CREATE TABLE BUSINESS
			(
				BUSINESSID BIGINT NOT NULL IDENTITY(1,1),
				PERSONALINFOID BIGINT NOT NULL,
				TITLE NTEXT NOT NULL,
				PRODUCTS_SERVICES NTEXT NOT NULL,
				RESPONSIBILITIES NTEXT NOT NULL,
				PARTNERSANDNUMBERS NTEXT NOT NULL,
				FID VARCHAR(64),
				COMPANY VARCHAR(128) NOT NULL,
				STARTDATE VARCHAR(16) NOT NULL,
				ENDDATE VARCHAR(16),
				CURRENTINVOLVEMENT VARCHAR(3) NOT NULL,
				CE_EXPLANATION NTEXT NOT NULL,
				PCTOFTIMEUSED INT DEFAULT 0,
				ADDRESS1 VARCHAR(256) NOT NULL,
				ADDRESS2 VARCHAR(256),
				CITY VARCHAR(256) NOT NULL,
				STATE VARCHAR(2),
				ZIP VARCHAR(16),
				COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
			);
			ALTER TABLE BUSINESS ADD CONSTRAINT PK_BUSINESS PRIMARY KEY(BUSINESSID);
			ALTER TABLE BUSINESS ADD CONSTRAINT FK_BUSINESS_NAME FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);
			
			CREATE TABLE SAVEDAPPLICATION
			(
				EMAIL VARCHAR(64) NOT NULL,
				PASSWORD VARCHAR(32) NOT NULL,
				SAVEDDATA NTEXT NOT NULL,
				LOCKED BIT NOT NULL DEFAULT 0	
			);
			ALTER TABLE SAVEDAPPLICATION ADD CONSTRAINT PK_SAVEDAPPLICATION PRIMARY KEY(EMAIL);
		
		</cfquery>
	</cffunction>

	<cffunction name="addEmploymentInfomation" access="public" returntype="String" hint="I add employment Information and return and EMPLOYMENTID">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person whose employment information is being added">
		<cfargument name="title" type="String" required="true" hint="title of the job">
		<cfargument name="company" type="String" required="true" hint="name of the company worked for">
		<cfargument name="startdate" type="String" required="true" hint="Day the job started">
		<cfargument name="responsibilities" type="String" required="true" hint="Responsibilities of the job">
		<cfargument name="address1" type="String" required="true" hint="address line 1">
		<cfargument name="city" type="String" required="true" hint="city where the person was employed">
		<cfargument name="county" type="String" required="false" default="0" hint="name of the county you worked in">
		<cfargument name="supervisor_name" type="String" required="false" default="0" hint="Phone number of the supervisor">
		<cfargument name="supervisor_ph_number" type="String" required="false" default="0" hint="Phone number of the supervisor">
		<cfargument name="enddate" type="String" required="false" default="0" hint="Day when the job was left">
		<cfargument name="address2" type="String" required="false" default="0" hint="address line 2">
		<cfargument name="state" type="String" required="false" default="0" hint="state">
		<cfargument name="zip" type="String" required="false" default="0" hint="zip">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO EMPLOYMENT
			(
				PERSONALINFOID,
				TITLE,
				COMPANY,
				RESPONSIBILITIES,
				STARTDATE,
				ADDRESS1,
				CITY
				<cfif arguments.county NEQ "0">
				,COUNTY
				</cfif>
				<cfif arguments.address2 NEQ "0">
				,ADDRESS2
				</cfif>
				<cfif arguments.state NEQ "0">
				,STATE
				</cfif>
				<cfif arguments.zip NEQ "0">
				,ZIP
				</cfif>
				<cfif arguments.enddate NEQ "0">
				,ENDDATE
				</cfif>
				<cfif arguments.supervisor_name NEQ "0">
				,SUPERVISOR_NAME
				</cfif>
				<cfif arguments.supervisor_ph_number NEQ "0">
				,SUPERVISOR_PH_NUMBER
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.personalInfoId#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.responsibilities#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">
				<cfif arguments.county NEQ "0">
				,<cfqueryparam value="#arguments.county#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.address2 NEQ "0">
				,<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.state NEQ "0">
				,<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.zip NEQ "0">
				,<cfqueryparam value="#arguments.zip#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.enddate NEQ "0">
				,<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.supervisor_name NEQ "0">
				,<cfqueryparam value="#arguments.supervisor_name#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.supervisor_ph_number NEQ "0">
				,<cfqueryparam value="#arguments.supervisor_ph_number#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS EMPLOYMENTID
		</cfquery>
		<cfreturn add.EMPLOYMENTID>	
	</cffunction>
	
	<cffunction name="addBussinessInformation" access="public" returntype="String" hint="I add busniess information for a person">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person whose employment information is being added">
		<cfargument name="title" type="String" required="true" hint="title held in the business">	
		<cfargument name="products_services" type="String" required="true" hint="product or services offered by the busniess">
		<cfargument name="partnersandnumbers" type="String" required="true" hint="Partners and their phone numbers">
		<cfargument name="company" type="String" required="true" hint="Name of the company">
		<cfargument name="startdate" type="String" required="true" hint="Day when company started">
		<cfargument name="currentinvolvement" type="String" required="true" hint="Yes if currently envolved, No if not">
		<cfargument name="ce_explanation" type="String" required="true" hint="Explanation for current involvement">
		<cfargument name="address1" type="String" required="true" hint="Address line 1 of the business">	
		<cfargument name="city" type="String" required="true" hint="city where the business was set up">
		<cfargument name="country" type="String" required="true" hint="country where business was based">
		<cfargument name="fid" type="String" required="false" default="not required" hint="Federal ID Number">		
		<cfargument name="enddate" type="String" required="false" default="0" hint="Day when the business was left or shut down">
		<cfargument name="pctoftimeused" type="String" required="false" default="0" hint="Percentage of time a person will be involved in the business">
		<cfargument name="address2" type="String" required="false" default="0" hint="Address line 2 of the business">
		<cfargument name="state" type="String" required="false" default="0" hint="State where the business was based">		
		<cfargument name="zip" type="String" required="false" default="0" hint="Zip code for business location">
		<cfargument name="responsibilites" type="string" required="false" default="" hint="Responsiblities">
		
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO BUSINESS
			(
				PERSONALINFOID,
				TITLE,
				PRODUCTS_SERVICES,
				PARTNERSANDNUMBERS,
				RESPONSIBILITIES,
				COMPANY,
				STARTDATE,
				CURRENTINVOLVEMENT,
				CE_EXPLANATION,
				ADDRESS1,
				CITY,
				FID,
				COUNTRY
				<cfif arguments.enddate NEQ "0">
				,ENDDATE
				</cfif>
				<cfif arguments.pctoftimeused NEQ "0">
				,PCTOFTIMEUSED
				</cfif>
				<cfif arguments.address2 NEQ "0">
				,ADDRESS2
				</cfif>
				<cfif arguments.state NEQ "0">
				,STATE
				</cfif>
				<cfif arguments.zip NEQ "0">
				,ZIP
				</cfif>
				
			)
			VALUES
			(
				<cfqueryparam value="#arguments.personalInfoId#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.products_services#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.partnersandnumbers#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.responsibilities#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.currentinvolvement#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.ce_explanation#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.fid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">
				<cfif arguments.endday NEQ "0">
				,<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.pctoftimeused NEQ "0">
				,<cfqueryparam value="#arguments.pctoftimeused#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.address2 NEQ "0">
				,<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.state NEQ "0">
				,<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.zip NEQ "0">
				,<cfqueryparam value="#arguments.zip#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS BUSINESSID
		</cfquery>
		<cfreturn add.BUSINESSID>
	</cffunction>
	
	<cffunction name="addPersonalInfo" access="public" returntype="String" hint="I add personal Information and return personalInfoId">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="wemail" type="string" required="true" hint="Home email address of the Appplicant">
		<cfargument name="firstname" type="string" required="true" hint="First Name">
		<cfargument name="lastname" type="String" required="true" hint="Last Name">
		<cfargument name="maidenname" type="String" required="true" hint="Maiden Name">
		<cfargument name="hphone" type="String" required="true" hint="Home phone">
		<cfargument name="gender" type="String" required="true" hint="Gender, 1 for female, 2 for male">
		<cfargument name="dob" type="String" required="true" hint="Date of Birth">
		<cfargument name="maritalstatus" type="String" required="true" hint="Marital Status, 1  for single, 2 married">
		<cfargument name="middlename" type="String" required="false" default="0" hint="Name of the Spouse if married">
		<cfargument name="spousename" type="String" required="false" default="0" hint="Name of the Spouse if married">
		<cfargument name="mphone" type="String" required="false" default="0" hint="Cell phone number">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO PERSONALINFO
			(
				WEMAIL,
				FIRSTNAME,
				LASTNAME,
				MAIDENNAME,
				HPHONE,
				GENDER,
				DOB,
				MARITALSTATUS
				<cfif arguments.middlename NEQ "0">
				,MIDDLENAME
				</cfif>
				<cfif arguments.spousename NEQ "0">
				,SPOUSENAME
				</cfif>
				<cfif arguments.mphone NEQ "0">
				,MPHONE
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.wemail#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.maidenname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.hphone#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.dob#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.maritalstatus#" cfsqltype="cf_sql_varchar">
				<cfif arguments.middlename NEQ "0">
					,<cfqueryparam value="#arguments.middlename#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.spousename NEQ "0">
					,<cfqueryparam value="#arguments.spousename#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.mphone NEQ "0">
					,<cfqueryparam value="#arguments.mphone#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS personalInfoId
		</cfquery>
		<cfreturn add.PERSONALINFOID>
	</cffunction>
	
	<cffunction name="addResidenceInfo" access="public" returntype="string" hint="I add contactInfo">
	<cfargument name="ds" type="String" required="true" hint="Data Source">
	<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person">
	<cfargument name="startdate" type="String" required="true" hint="Start day of the residence">
	<cfargument name="address1" type="String" required="true" hint="Address line 1">
	<cfargument name="city" type="String" required="true" hint="City">
	<cfargument name="country" type="String" required="false" default="US" hint="country">
	<cfargument name="county" type="String" required="false" default="0" hint="country">
	<cfargument name="state" type="String" required="false" default="0" hint="state/province">
	<cfargument name="enddate" type="String" required="false" default="0" hint="End date of residence">
	<cfargument name="address2" type="String" required="false" default="0" hint="Address Line 2">
	<cfargument name="zip" type="String" required="false" default="0" hint="Zip Code">
	<cfset var add=0>
	<cfquery name="add" datasource="#arguments.ds#">
		INSERT INTO RESIDENCEINFO
		(
			PERSONALINFOID,
			STARTDATE,
			ADDRESS1,
			CITY,
			COUNTRY
			<cfif arguments.county NEQ "0">
			,COUNTY
			</cfif>
			<cfif arguments.state NEQ "0">
			,STATE
			</cfif>
			<cfif arguments.enddate NEQ "0">
			,ENDDATE
			</cfif>
			<cfif arguments.address2 NEQ "0">
			,ADDRESS2
			</cfif>
			<cfif arguments.zip NEQ "0">
			,ZIP
			</cfif>
		)
		VALUES
		(
			<cfqueryparam value="#arguments.personalInfoId#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">
			<cfif arguments.county NEQ "0">
			,<cfqueryparam value="#arguments.county#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.state NEQ "0">
			,<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ "0">
			,<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.address2 NEQ "0">
			,<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.ZIP NEQ "0">
			,<cfqueryparam value="#arguments.ZIP#" cfsqltype="cf_sql_varchar">
			</cfif>
		)
		SELECT @@IDENTITY AS RESIDENCEINFOID
	</cfquery>
	<cfreturn add.RESIDENCEINFOID>
</cffunction>
	
	<cffunction name="saveApplication" access="public" returntype="void" hint="I save application form">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="String" required="true" hint="Email of the person who is saving the application">
		<cfargument name="password" type="String" required="true" hint="Password set to retrieve the application">
		<cfargument name="saveddata" type="String" required="true" hint="forms and data to be saved in json format">
		<cfset var save=0>
		<cfquery name="save" datasource="#arguments.ds#">
			INSERT INTO SAVEDAPPLICATION
			(
				EMAIL,
				PASSWORD,
				SAVEDDATA
			)
			VALUES
			(
				<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.saveddata#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteApplication" access="public" returntype="void" hint="I delete application">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="String" required="true" hint="Email of the person who is saving the application">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM SAVEDAPPLICATION
			WHERE EMAIL=<cfqueryparam value="#arguments.email#">
		</cfquery>
	</cffunction>
	
	<cffunction name="getApplication" access="public" returntype="String" hint="I get saved application">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="String" required="true" hint="Email">
		<cfargument name="password" type="String" required="true" hint="Password">
		<cfset var get=0>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT				
				SAVEDDATA
			FROM SAVEDAPPLICATION
			WHERE EMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
			AND PASSWORD=<cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
			AND LOCKED<>1
		</cfquery>
		<cfreturn get.SAVEDDATA>
	</cffunction>
	
	<cffunction name="checkEmail" access="public" returntype="boolean" hint="I check if the wemail address is already registered">
	<cfargument name="ds" required="true" type="String" hint="Datasource">
	<cfargument name="email" type="String" required="true" hint="User's email address">
	<cfargument name="excludeEmail" type="String" required="false" default="0" hint="Email to exclude from search">
	<cfset var checkemail=0>
	<cfquery name="checkemail" datasource="#arguments.ds#">
		SELECT EMAIL
		FROM SAVEDAPPLICATION
		WHERE EMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		<cfif arguments.excludeEmail NEQ "0">
		AND EMAIL<><cfqueryparam value="#arguments.excludeEmail#" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfquery>
	<cfif checkemail.recordcount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
	</cffunction>

	<cffunction name="lockApplication" access="public" returntype="void" hint="I delete application">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="String" required="true" hint="Email of the person who is saving the application">
		<cfset var lock=0>
		<cfquery name="lock" datasource="#arguments.ds#">
			UPDATE SAVEDAPPLICATION
			SET LOCKED=1
			WHERE EMAIL=<cfqueryparam value="#arguments.email#">
		</cfquery>
	</cffunction>
	
	<cffunction name="unlockApplication" access="public" returntype="void" hint="I delete application">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="String" required="true" hint="Email of the person who is saving the application">
		<cfset var unlock=0>
		<cfquery name="unlock" datasource="#arguments.ds#">
			UPDATE SAVEDAPPLICATION
			SET LOCKED=0
			WHERE EMAIL=<cfqueryparam value="#arguments.email#">
		</cfquery>
	</cffunction>

	<cffunction name="updatePersonalInfo" access="public" returntype="void" hint="I update personalInfo">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person whose employment information is being added">
		<cfargument name="wemail" type="string" required="true" hint="Home email address of the Appplicant">
		<cfargument name="firstname" type="string" required="true" hint="First Name">
		<cfargument name="lastname" type="String" required="true" hint="Last Name">
		<cfargument name="maidenname" type="String" required="true" hint="Maiden Name">
		<cfargument name="hphone" type="String" required="true" hint="Home phone">
		<cfargument name="gender" type="String" required="true" hint="Gender, 1 for female, 2 for male">
		<cfargument name="dob" type="String" required="true" hint="Date of Birth">
		<cfargument name="maritalstatus" type="String" required="true" hint="Marital Status, 1  for single, 2 married">
		<cfargument name="middlename" type="String" required="false" default="0" hint="Name of the Spouse if married">
		<cfargument name="spousename" type="String" required="false" default="0" hint="Name of the Spouse if married">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE PERSONALINFO SET 
			WEMAIL=<cfqueryparam value="#arguments.wemail#" cfsqltype="cf_sql_varchar">,
			FIRSTNAME=<cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
			LASTNAME=<cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
			MAIDENNAME=<cfqueryparam value="#arguments.maidenname#" cfsqltype="cf_sql_varchar">,
			HPHONE=<cfqueryparam value="#arguments.hphone#" cfsqltype="cf_sql_varchar">,
			GENDER=<cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
			DOB=<cfqueryparam value="#arguments.dob#" cfsqltype="cf_sql_varchar">,
			MARITALSTATUS=<cfqueryparam value="#arguments.maritalstatus#" cfsqltype="cf_sql_varchar">
			<cfif arguments.middlename NEQ "0">
			,MIDDLENAME=<cfqueryparam value="#arguments.middlename#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.spousename NEQ "0">
			,SPOUSENAME=<cfqueryparam value="#arguments.spousename#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE PERSONALINFOID=<cfqueryparam value="#arguments.personalinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
	</cffunction>
	
	<cffunction name="updateResidenceInfo" access="public" returntype="void" hint="I update residenceInfo">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="residenceinfoid" type="string" required="true" hint="residenceinfoid, unique id for each residence info"> 
		<cfargument name="startdate" type="String" required="true" hint="Start day of the residence">
		<cfargument name="address1" type="String" required="true" hint="Address line 1">
		<cfargument name="city" type="String" required="true" hint="City">
		<cfargument name="country" type="String" default="US" required="false" hint="country">
		<cfargument name="county" type="String" required="false" default="0" hint="country">
		<cfargument name="state" type="String" required="false" default="0" hint="state">
		<cfargument name="enddate" type="String" required="false" default="0" hint="End date of residence">
		<cfargument name="address2" type="String" required="false" default="0" hint="Address Line 2">
		<cfargument name="zip" type="String" required="false" default="0" hint="Zip Code">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE  RESIDENCEINFO SET
			STARTDATE=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
			ADDRESS1=<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
			CITY=<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
			COUNTRY=<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">
			<cfif arguments.county NEQ "0">
			,COUNTY=<cfqueryparam value="#arguments.county#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.state NEQ "0">
			,STATE=<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ "0">
			,ENDDATE=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.address2 NEQ "0">
			,ADDRESS2=<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.zip NEQ "0">
			,ZIP=<cfqueryparam value="#arguments.ZIP#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE RESIDENCEINFOID=<cfqueryparam value="#arguments.residenceinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
	</cffunction>
	
	<cffunction name="updateEmploymentInformation" access="public" returntype="void" hint="I update employment information">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="employmentid" type="String" required="true" hint="Employmentid of the person whose employment information is being updated">
		<cfargument name="title" type="String" required="true" hint="title of the job">
		<cfargument name="company" type="String" required="true" hint="name of the company worked for">
		<cfargument name="startdate" type="String" required="true" hint="Day the job started">
		<cfargument name="responsibilities" type="String" required="true" hint="Responsibilities of the job">
		<cfargument name="address1" type="String" required="true" hint="address line 1">
		<cfargument name="city" type="String" required="true" hint="city where the person was employed">
		<cfargument name="country" type="String" required="false" default="0" hint="name of the country worked in">
		<cfargument name="county" type="String" required="false" default="0" hint="name of the county worked in">
		<cfargument name="supervisor_ph_number" type="String" required="false" default="0" hint="Phone number of the supervisor">
		<cfargument name="enddate" type="String" required="false" default="0" hint="Day when the job was left">
		<cfargument name="address2" type="String" required="false" default="0" hint="address line 2">
		<cfargument name="state" type="String" required="false" default="0" hint="state">
		<cfargument name="zip" type="String" required="false" default="0" hint="zip">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE EMPLOYMENT SET
			TITLE=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
			COMPANY=<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">,
			RESPONSIBILITIES=<cfqueryparam value="#arguments.responsibilities#" cfsqltype="cf_sql_varchar">,
			STARTDATE=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
			ADDRESS1=<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
			CITY=<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">
			<cfif arguments.country NEQ "0">
			,COUNTRY=<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.county NEQ "">
			,COUNTY=<cfqueryparam value="#arguments.county#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.address2 NEQ "0">
			,ADDRESS2=<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.state NEQ "0">
			,STATE=<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.zip NEQ "0">
			,ZIP=<cfqueryparam value="#arguments.zip#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ "0">
			,ENDDATE=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.supervisor_ph_number NEQ "0">
			,SUPERVISOR_PH_NUMBER=<cfqueryparam value="#arguments.supervisor_ph_number#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE EMPLOYMENTID=<cfqueryparam value="#arguments.employmentid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
	</cffunction>
	
	<cffunction name="updateBusinessVenture" access="public" returntype="void" hint="I update Business Venture">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="businessid" type="String" required="true" hint="businessid">
		<cfargument name="title" type="String" required="true" hint="title held in the business">	
		<cfargument name="products_services" type="String" required="true" hint="product or services offered by the busniess">
		<cfargument name="partnersandnumbers" type="String" required="true" hint="Partners and their phone numbers">
		<cfargument name="fid" type="String" required="false" default="0" hint="Federal ID Number, changed as per client's request">
		<cfargument name="company" type="String" required="true" hint="Name of the company">
		<cfargument name="startdate" type="String" required="true" hint="Day when company started">
		<cfargument name="currentinvolvement" type="String" required="true" hint="Yes if currently envolved, No if not">
		<cfargument name="ce_explanation" type="String" required="true" hint="Explanation for current involvement">
		<cfargument name="address1" type="String" required="true" hint="Address line 1 of the business">	
		<cfargument name="city" type="String" required="true" hint="city where the business was set up">
		<cfargument name="country" type="String" required="true" hint="country where business was based">		
		<cfargument name="enddate" type="String" required="false" default="0" hint="Day when the business was left or shut down">
		<cfargument name="pctoftimeused" type="String" required="false" default="0" hint="Percentage of time a person will be involved in the business">
		<cfargument name="address2" type="String" required="false" default="0" hint="Address line 2 of the business">
		<cfargument name="state" type="String" required="false" default="0" hint="State where the business was based">		
		<cfargument name="zip" type="String" required="false" default="0" hint="Zip code for business location">
		<cfargument name="responsibilites" type="string" required="false" default="0" hint="Responsiblities">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE BUSINESS SET
			TITLE=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
			PRODUCTS_SERVICES=<cfqueryparam value="#arguments.products_services#" cfsqltype="cf_sql_varchar">,
			PARTNERSANDNUMBERS=<cfqueryparam value="#arguments.partnersandnumbers#" cfsqltype="cf_sql_varchar">,
			COMPANY=<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">,
			STARTDATE=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
			CURRENTINVOLVEMENT=<cfqueryparam value="#arguments.currentinvolvement#" cfsqltype="cf_sql_varchar">,
			CE_EXPLANATION=<cfqueryparam value="#arguments.ce_explanation#" cfsqltype="cf_sql_varchar">,
			ADDRESS1=<cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar">,
			CITY=<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
			COUNTRY=<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">
			<cfif arguments.fid NEQ "0">
			,FID=<cfqueryparam value="#arguments.fid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ "0">
			,ENDDATE=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.pctoftimeused NEQ "0">
			,PCTOFTIMEUSED=<cfqueryparam value="#arguments.pctoftimeused#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.responsibilites NEQ "0">
			,RESPONSIBILITES=<cfqueryparam value="#arguments.responsibilites#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.address2 NEQ "0">
			,ADDRESS2=<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.state NEQ "0">
			,STATE=<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.zip NEQ "0">
			,ZIP=<cfqueryparam value="#arguments.zip#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE BUSINESSID=<cfqueryparam value="#arguments.businessid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
	</cffunction>
	
	<cffunction name="getPassword" access="public" returntype="String" hint="I return password">
		<cfargument name="ds" required="true" type="String" hint="Datasource">
		<cfargument name="email" type="String" required="true" hint="User's email address">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT PASSWORD FROM SAVEDAPPLICATION
			WHERE EMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 1>
		<cfreturn get.PASSWORD>
		<cfelse>
		<cfreturn "0">
		</cfif>
	</cffunction>
	
	<cffunction name="deleteResidenceInfo" access="public" returntype="string" hint="I delete residenceinfo">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM RESIDENCEINFO WHERE PERSONALINFOID=<cfqueryparam value="#arguments.personalinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="deleteEmploymentInfo" access="public" returntype="string" hint="I delete residenceinfo">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM EMPLOYMENT WHERE PERSONALINFOID=<cfqueryparam value="#arguments.personalinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="deleteBusinessInfo" access="public" returntype="string" hint="I delete residenceinfo">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM BUSINESS WHERE PERSONALINFOID=<cfqueryparam value="#arguments.personalinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 0>
	</cffunction>

	<cffunction name="checkpersonalinfo" access="public" returntype="string" hint="I check if personalinfoid exists">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="personalInfoId" type="String" required="true" hint="personalInfoId of the person">
		<cfset var check=0>
		<cfquery name="check" datasource="#arguments.ds#">
			SELECT 
				WEMAIL
			FROM PERSONALINFO 
			WHERE PERSONALINFOID=<cfqueryparam value="#arguments.personalinfoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif check.recordcount GT 0>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="recordtracking" access="public" returntype="void" hint="Record when users update application">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="email" type="string" required="true" hint="email id">
		<cfargument name="remarks" type="string" required="false" default="Not Submitted" hint="Submitted, Not submitted">
		<cfset var addtracking=0>
		<cfset var ts=Application.objtimedateconversion.createtimedate()>
		<cfquery name="addtracking" datasource="#arguments.ds#">
			INSERT INTO TRACKAPPLICATION
			(
				EMAIL,
				TIMEDATE,
				REMARKS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.email#">,
				<cfqueryparam value="#ts#">,
				<cfqueryparam value="#arguments.remarks#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="changeEmail" access="public" returntype="void" hint="update email address">
		<cfargument name="ds" type="String" required="true" hint="Data Source">
		<cfargument name="oldemail" type="string" required="true" hint="oldemail">
		<cfargument name="newemail" type="string" required="true" hint="newemail">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE TRACKAPPLICATION SET
			EMAIL=<cfqueryparam value="#arguments.newemail#">
			WHERE EMAIL=<cfqueryparam value="#arguments.oldemail#">
		</cfquery>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE SAVEDAPPLICATION SET 
			EMAIL=<cfqueryparam value="#arguments.newemail#">
			WHERE EMAIL=<cfqueryparam value="#arguments.oldemail#">
		</cfquery>
		<cfreturn>
	</cffunction>
</cfcomponent>