<!--- 
	Things to do in admanagement 
	1. Create a temporary table for impression record which should last only a day.
	2. At the end of each day, data from the temporary table should be archieved and data should be deleted.
	3. Create another table which keeps the statistics per ad in a table. This table should also be updated
	   at the end of the day, may be 11:59 AM everyday.
	    
--->

<cfcomponent hint="I have functions for ad management">
	<cfobject component="timedateConversion" name="mytime">
	
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
	
	<cffunction name="createTables" access="public" returntype="void" hint="I create tables for ad management">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		
		<cfquery name="checkadvertisergroup" datasource="#admanagementdsn#">
			SELECT USERGROUPNAME
			FROM USERGROUPS
			WHERE GROUPNAME='Advertiser'
		</cfquery>
		
		<cfquery name="createtables" datasource="#admanagementdsn#">
			DROP TABLE IMPRESSION_RECORD;
			DROP TABLE RENEWAD;
			DROP TABLE AD_TO_ZONE;
			DROP TABLE DELETEADS
			DROP TABLE BANNERAD;
			DROP TABLE LAYOUTTOZONECONTAINER;
			DROP TABLE ZONES;
			DROP TABLE ZONECONTAINER;
			DROP TABLE LAYOUT;
			DROP TABLE MODULES;
			
			CREATE TABLE MODULES
			(
				MODULEID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				NAME VARCHAR(256) NOT NULL,
				DESCRIPTION NTEXT,
				CFC VARCHAR(256),
				CUSTOMTAGS VARCHAR(256)
			)
			CREATE TABLE LAYOUT
			(
				LAYOUTID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				TITLE NTEXT NOT NULL,
				DESCRIPTION NTEXT NOT NULL,
				FILENAME NTEXT NOT NULL,
				SCREENSHOTPATH NTEXT NOT NULL
			)
			
			CREATE TABLE ZONECONTAINER
			(
				ZONECONTAINERID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				HEIGHT INT NOT NULL,
				WIDTH INT NOT NULL,
				COLOR INT,
				BGCOLOR INT,
				DESCRIPTION NTEXT,
				CSSID VARCHAR(256) NOT NULL,
				MAXZONES INT NOT NULL DEFAULT 1
			)
			
			CREATE TABLE LAYOUTTOZONECONTAINER
            (
                LAYOUTID INT NOT NULL,
                ZONECONTAINERID INT NOT NULL    
            )
            ALTER TABLE LAYOUTTOZONECONTAINER ADD PRIMARY KEY(LAYOUTID, ZONECONTAINERID);
            ALTER TABLE LAYOUTTOZONECONTAINER ADD FOREIGN KEY(LAYOUTID) REFERENCES LAYOUT(LAYOUTID);
            ALTER TABLE LAYOUTTOZONECONTAINER ADD FOREIGN KEY(ZONECONTAINERID) REFERENCES ZONECONTAINER(ZONECONTAINERID);
				
			CREATE TABLE ZONES
			(
				ZONEID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				ZONECONTAINERID INT NOT NULL,
				DESCRIPTION NTEXT,
				MODULEID INT NOT NULL
			);
			
			ALTER TABLE ZONES ADD FOREIGN KEY(ZONECONTAINERID) REFERENCES ZONECONTAINER(ZONECONTAINERID);
			ALTER TABLE ZONES ADD FOREIGN KEY(MODULEID) REFERENCES MODULES(MODULEID);
			
			CREATE TABLE BANNERAD
			(
				ADID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				ADNAME VARCHAR(256) NOT NULL,
				ADVERTISER_NAMEID BIGINT NOT NULL,
				ZONEID INT NOT NULL,
				TARGET_URL NTEXT NOT NULL,
				IMAGE_PATH VARCHAR(256),
				DISPLAYTEXT NTEXT
			);
			ALTER TABLE BANNERAD ADD FOREIGN KEY(ZONEID) REFERENCES ZONES(ZONEID);
			ALTER TABLE BANNERAD ADD FOREIGN KEY(ADVERTISER_NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE RENEWAD
			(
				RENEWID BIGINT NOT NULL IDENTITY(1,1),
				ADID BIGINT NOT NULL,
				RECORDEDON VARCHAR(16) NOT NULL,
				ACTIVATEDON VARCHAR(16) DEFAULT 'Not Activated',
				STARTDATE VARCHAR(16) NOT NULL,
				ENDDATE VARCHAR(16),
				MAXCLICK BIGINT DEFAULT 0,
				MAXIMPRESSION BIGINT DEFAULT 0,
				CHECK_DATE BIT DEFAULT 0,
				ACTIVE BIT DEFAULT 0
				
			)
			ALTER TABLE RENEWAD ADD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID);
			ALTER TABLE RENEWAD ADD PRIMARY KEY(ADID, ACTIVATEDON);
			
			CREATE TABLE DELETEADS
			(
				ADID BIGINT NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL,
				DELETED BIT NOT NULL
			)
			ALTER TABLE DELETEADS ADD FOREIGN KEY (ADID) REFERENCES BANNERAD(ADID); 
			
			CREATE TABLE IMPRESSION_RECORD
			(
				ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				ADID BIGINT NOT NULL,
				CLICK BIT DEFAULT 0,
				CFID VARCHAR(16) NOT NULL,
				IPADDRESS VARCHAR(24) NOT NULL,
				RECORDEDON  VARCHAR(16) NOT NULL,
				ZONEID INT
			)
			ALTER TABLE IMPRESSION_RECORD ADD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID);
			ALTER TABLE IMPRESSION_RECORD ADD CONSTRAINT FK_IMPRESSION_RECORD_ZONES FOREIGN KEY(ZONEID) REFERENCES ZONES (ZONEID);
			
			CREATE TABLE AD_TO_ZONE
			(
				ADID BIGINT NOT NULL,
				ZONEID INT NOT NULL
			)
			ALTER TABLE AD_TO_ZONE ADD CONSTRAINT PK_AD_TO_ZONE PRIMARY KEY(ADID, ZONEID);
			ALTER TABLE AD_TO_ZONE ADD CONSTRAINT FK_AD_TO_ZONE_BANNERAD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID);
			ALTER TABLE AD_TO_ZONE ADD CONSTRAINT FK_AD_TO_ZONE_ZONES FOREIGN KEY (ZONEID) REFERENCES ZONES(ZONEID);
		
			<!--- this part can be used to update 918moms site 
			<CFQUERY NAME="ADSANDZONES" DATASOURCE="918MOMS.COM">
			SELECT ADID, ZONEID FROM BANNERAD;
			</CFQUERY>
			<CFLOOP QUERY="ADSANDZONES">
				<CFQUERY NAME="INSERT_ADD_TO_ZONE" DATASOURCE="918MOMS.COM">
					INSERT INTO AD_TO_ZONE
					(ADID,ZONEID)
					VALUES
					(#ADID#,#ZONEID#)
				</CFQUERY>
			</CFLOOP>
			
			ALTER TABLE BANNERAD DROP COLUMN ZONEID
			
			this makes database consistent
			--->
		</cfquery>
	</cffunction>
	<cffunction name="addZoneContainer" returnType="numeric" access="public" hint="Add an ad zone container and returns addZoneContainerID">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="height" required="true" type="string" hint="Height of the zone container">
		<cfargument name="width" required="true" type="string" hint="Width of the zone container">
		<cfargument name="color" required="false" type="string" hint="Color of the zone container" default="0">
		<cfargument name="bgcolor" required="false" type="string" hint="BGColor of the zone container" default="0">
		<cfargument name="description" required="true" type="string" hint="Description (name) of the zone container">
		<cfargument name="cssid" required="false" type="string" hint="CSS ID for the zone container" default="0">
		<cfargument name="maxzones" required="false" type="numeric" hint="Maximum number of zones in the zone container" default="1">
		<cfset var addZoneContainer = 0>
		
		<cfquery name="addZoneContainer" datasource="#arguments.admanagementdsn#">
			INSERT INTO ZONECONTAINER
			(
				HEIGHT,
				WIDTH,
				<cfif arguments.color NEQ 0>COLOR,</cfif>
				<cfif arguments.bgcolor NEQ 0>BGCOLOR,</cfif>
				DESCRIPTION,
				CSSID,
				MAXZONES
			)
			VALUES (
				<cfqueryparam value="#arguments.height#" CFSQLType="CF_SQL_INTEGER">,
				<cfqueryparam value="#arguments.width#" CFSQLType="CF_SQL_INTEGER">,
				<cfif arguments.color NEQ 0><cfqueryparam value="#arguments.color#" CFSQLType="CF_SQL_INTEGER">,</cfif>
				<cfif arguments.bgcolor NEQ 0><cfqueryparam value="#arguments.bgcolor#" CFSQLType="CF_SQL_INTEGER">,</cfif>
				<cfqueryparam value="#arguments.description#" CFSQLType="CF_SQL_LONGVARCHAR">,
				<cfqueryparam value="#arguments.cssid#" CFSQLType="CF_SQL_INTEGER">,
				<cfqueryparam value="#arguments.maxzones#" CFSQLType="CF_SQL_INTEGER">
			)
			SELECT @@IDENTITY AS ZONECONTAINERID	
		</cfquery>
		<cfreturn addZoneContainer.ZONECONTAINERID>
	</cffunction>
	<cffunction name="addZone" returntype="numeric" access="public" hint="Add an ad category and returns ADCATEGORYID">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="zonecontainerid" required="true" type="numeric" hint="width of the AD">
		<cfargument name="moduleid" required="true" type="numeric" hint="name of the module that a zone is tied to">
		<cfargument name="description" required="false" type="string" hint="height of the AD">
		<cfset var addzone=0>
			<cfquery name="addzone" datasource="#admanagementdsn#">
				INSERT INTO ZONES
				(
					ZONECONTAINERID,
					MODULEID
					<cfif isDefined('description')>
					,DESCRIPTION
					</cfif>
				)
				VALUES
				(
					<cfqueryparam value="#zonecontainerid#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#moduleid#" cfsqltype="cf_sql_integer">
					<cfif isDefined('description')>
					,<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">
					</cfif>
				)
				SELECT @@IDENTITY AS ZONEID
			</cfquery>
			<cfreturn addzone.ZONEID>
	</cffunction>
	
	<cffunction name="addBannerAd" access="public" returntype="numeric" hint="I add advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adname" required="true" type="string" hint="name of the ad">
		<cfargument name="advertiser_nameid" required="true" type="numeric" hint="nameid of the advertiser">
		<cfargument name="zoneid" required="true" type="numeric" hint="adcategoryid">
		<cfargument name="target_url" required="true" type="string" hint="url where the click on the ad should take">
		<cfargument name="image_path" required="false" type="string" hint="path of the image">
		<cfargument name="displaytext" required="false" type="string" hint="Text to display for text based AD">
		<cfset var addbannerad=0>
		<cfquery name="addbannerad" datasource="#admanagementdsn#">
			INSERT INTO BANNERAD
			(
				ADNAME,
				ADVERTISER_NAMEID,
				ZONEID,
				TARGET_URL
				<cfif isDefined('image_path')>
				,IMAGE_PATH
				</cfif>
				<cfif isDefined('displaytext')>
				,DISPLAYTEXT
				</cfif>
			)
			VALUES
			(	
				<cfqueryparam value="#adname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#advertiser_nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#target_url#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('image_path')>
				,<cfqueryparam value="#image_path#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('displaytext')>
				,<cfqueryparam value="#displaytext#" cfsqltype="cf_sql_longvarchar">
				</cfif>
			)
			SELECT @@IDENTITY AS ADID
		</cfquery>
		<cfreturn addbannerad.ADID>
	</cffunction>
	
	<cffunction name="addadtozone" access="public" returntype="string" hint="I add ad to a zone">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ADID of the advertisement">
		<cfargument name="zoneid" required="true" type="String" hint="zoneid of the zone where ad should show up">
		<cfset var adtozone=0>
		<cfset var check=0>
		<cfquery name="check" datasource="#arguments.admanagementdsn#">
			SELECT ADID FROM AD_TO_ZONE 
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">
			AND ZONEID=<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif check.recordcount GT 0>
			<cfquery name="adtozone" datasource="#arguments.admanagementdsn#">
				INSERT INTO AD_TO_ZONE
				(
					ADID,
					ZONEID
				) 
				VALUES
				(
					<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_varchar">	
				)
			</cfquery>
			<cfreturn "success">
		<cfelse>
			<cfreturn "failure">
		</cfif>
	</cffunction>
	
	<cffunction name="renewAd" access="public" returntype="numeric" hint="I renew advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ADID of the advertisement to be renewed">
		<cfargument name="startdate" required="true" type="string" hint="startdate">
		<cfargument name="enddate" required="true" type="string" hint="enddate">
		<cfargument name="check_date" required="true" type="string" hint="if check_date should be check before displaying">
		<cfargument name="maxclick" required="false" type="numeric" default=0 hint="if click should be check before displaying">
		<cfargument name="maximpression" required="false" default=0 type="numeric" hint="if impression should be check before displaying">
		<cfargument name="active" required="false" default=0 type="Numeric" hint="If the ad should be activated or not. 1 to make active">
		<cfset var renewad=0>
		<cfquery name="renewad" datasource="#admanagementdsn#">
			INSERT INTO RENEWAD
			(
				ADID,
				RECORDEDON,
				STARTDATE,
				ENDDATE,
				MAXCLICK,
				MAXIMPRESSION,
				CHECK_DATE,
				ACTIVE
				<cfif active EQ 1>
				,ACTIVATEDON
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#maxclick#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#maximpression#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#check_date#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
				<cfif active EQ 1>
				,<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS RENEWID
		</cfquery>
		<cfreturn renewad.RENEWID>
	</cffunction>

	<cffunction name="activateAd" access="public" returntype="void" hint="I activate advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ADID of the Ad that needs to be activated">
		<cfset var activatead=0>
		<cfquery name="activatead" datasource="#admanagementdsn#">
			UPDATE TABLE RENEWAD
			SET ACTIVATEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			ACTIVE=1
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			AND ACTIVATEDON='Not Activated'
		</cfquery>
	</cffunction>
	
	<cffunction name="editBannerAd" access="public" returntype="void" hint="I update bannerad table">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="adname" required="true" type="string" hint="name given to ad">
		<cfargument name="advertiser_nameid" required="false" type="numeric" hint="advertiser's nameid">
		<cfargument name="zoneid" required="false" type="numeric" hint="zoneid of the zone where the ad should be displayed">
		<cfargument name="target_url" required="false" type="string" hint="url where the click on ad should direct">
		<cfargument name="image_path" required="false" type="string" hint="path of the ad image">
		<cfargument name="displaytext" required="false" type="string" hint="text to be displayed as Ad">
		<cfset var editbannerad=0>
		<cfquery name="editbannerad" datasource="#admanagementdsn#">
			UPDATE BANNERAD
			SET 
				ADNAME=<cfqueryparam value="#adname#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('advertiser_nameid')>
				,ADVERTISER_NAMEID=<cfqueryparam value="#advertiser_nameid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isDefined('zoneid')>
				,ZONEID=<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isDefined('target_url')>
				,TARGET_URL=<cfqueryparam value="#target_url#" cfsqltype="cf_sql_longvarchar">
				</cfif>
				<cfif isDefined('image_path')>
				,IMAGE_PATH=<cfqueryparam value="#image_path#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('displaytext')>
				,DISPLAYTEXT=<cfqueryparam value="#displaytext#" cfsqltype="cf_sql_longvarchar">
				</cfif>
				WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>

	<cffunction name="editRenewAd" access="public" returntype="void" hint="I edit renewad table">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="renewid" required="true" type="numeric" hint="renewid of the row to be updated">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="startdate" required="false" type="string" hint="new start date">
		<cfargument name="enddate" required="false" type="string" hint="new end date">
		<cfargument name="maxclick" required="false" type="numeric" hint="new max number of click allowed">
		<cfargument name="check_date" required="false" type="string" hint="0 or 1 for date based ADs">
		<cfargument name="active" required="false" type="string" hint="0 or 1 to make an AD active or inactive">
		<cfset var editrenewad=0>
		<cfquery name="editrenewad" datasource="#admanagementdsn#">
			UPDATE RENEWAD
			SET
				ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
				<cfif isDefined('startdate')>
				,STARTDATE=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('enddate')>
				,ENDDATE=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('maxclick')>
				,MAXCLICK=<cfqueryparam value="#maxclick#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined('maximpression')>
				,MAXIMPRESSION=<cfqueryparam value="#maximpression#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('check_date')>
				,CHECK_DATE=<cfqueryparam value="#check_date#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('active')>
				,ACTIVE=<cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE RENEWID=<cfqueryparam value="#renewid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
			
	<cffunction name="getBannerAd" access="public" returntype="query" hint="I get all advertisement information. Return fields: ADID,ADNAME,ADVERTISER_NAMEID,ZONEID,DESCRIPTION,TARGET_URL,IMAGE_PATH">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="false" type="String" hint="adid">
		<cfargument name="advertiser_nameid" required="false" type="String" hint="nameid of the person or company for whom ad was created">
		<cfargument name="zoneid" required="false" type="String" hint="zoneid of the zone where the ads are hosted" default=0>
		<cfset var getbannerad=0>
		<cfquery name="getbannerad" datasource="#admanagementdsn#">
			SELECT
				BANNERAD.ADID,
				ADNAME,
				MAXCLICK,
				MAXIMPRESSION,
				STARTDATE,
				ENDDATE,
				ADVERTISER_NAMEID,
				BANNERAD.ZONEID,
				ZONES.DESCRIPTION,
				TARGET_URL,
				IMAGE_PATH,
				DISPLAYTEXT
			FROM BANNERAD,ZONES,RENEWAD
			WHERE ZONES.ZONEID=BANNERAD.ZONEID
			AND BANNERAD.ADID = RENEWAD.ADID
			AND BANNERAD.ADID NOT IN (SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1)
			<cfif isDefined('adid')>
			AND BANNERAD.ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif zoneid neq 0>
			AND BANNERAD.ZONEID=<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('advertiser_nameid')>
			AND ADVERTISER_NAMEID=<cfqueryparam value="#advertiser_nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY BANNERAD.ZONEID
		</cfquery>
		<cfreturn getbannerad>
	</cffunction>
	
	<cffunction name="getDeletedAds" access="public" returntype="query" hint="I get all advertisement information. Return fields: ADID,ADNAME,ADVERTISER_NAMEID,ZONEID,DESCRIPTION,TARGET_URL,IMAGE_PATH">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="false" type="numeric" hint="adid">
		<cfargument name="advertiser_nameid" required="false" type="numeric" hint="nameid of the person or company for whom ad was created">
		<cfset var getbannerad=0>
		<cfquery name="getbannerad" datasource="#admanagementdsn#">
			SELECT
				BANNERAD.ADID,
				ADNAME,
				MAXCLICK,
				MAXIMPRESSION,
				STARTDATE,
				ENDDATE,
				ADVERTISER_NAMEID,
				BANNERAD.ZONEID,
				ZONES.DESCRIPTION,
				TARGET_URL,
				IMAGE_PATH,
				DISPLAYTEXT
			FROM BANNERAD,ZONES,RENEWAD
			WHERE ZONES.ZONEID=BANNERAD.ZONEID
			AND BANNERAD.ADID = RENEWAD.ADID
			AND BANNERAD.ADID IN (SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1)
			<cfif isDefined('adid')>
			AND BANNERAD.ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			</cfif>
			<cfif isDefined('advertiser_nameid')>
			AND ADVERTISER_NAMEID=<cfqueryparam value="#advertiser_nameid#" cfsqltype="cf_sql_bigint">
			</cfif>
			ORDER BY BANNERAD.ZONEID
		</cfquery>
		<cfreturn getbannerad>
	</cffunction>

	<cffunction name="deleteAd" access="public" returntype="void" hint="I delete Ad logically">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfset var deletead=0>
		<cfquery name="deletead" datasource="#admanagementdsn#">
			INSERT INTO DELETEDADS
			(
				ADID,
				DELETED,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">,
				1,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			)
			
			UPDATE DELETEDADS SET DELETED=1
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="RestoreAd" access="public" returntype="void" hint="Restore Advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfset var restore=0>
		<cfset var restorerecord=0>
		<cftransaction>
			<cfquery name="restore" datasource="#admanagementdsn#">
				UPDATE DELETEDADS
				SET DELETED=0
				WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="restorerecord" datasource="#admanagementdsn#">
				INSERT INTO DELETEDADS
				(
					ADID,
					DELETED,
					TIMEDATE
				)
				VALUES
				(
					<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">,
					0,
					<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="getAdvertiserInfo" access="public" returnType="query" hint="I get advertiser information (If they have an active ad).">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfset var getAdvertiserdata=0>
		<cfquery name="getAdvertiserdata" dataSource="#admanagementdsn#">
			<!--- 
				SELECT BANNERAD.ADVERTISER_NAMEID AS NAMEID, COMPANY, 
				(SELECT COUNT(ACTIVE)
							FROM RENEWAD, BANNERAD
							WHERE RENEWAD.ADID = BANNERAD.ADID 
							AND ACTIVE = 1
							GROUP BY ACTIVE) AS ACTIVE_COUNT, 
				(SELECT COUNT(ACTIVE)
					FROM RENEWAD, BANNERAD
					WHERE RENEWAD.ADID = BANNERAD.ADID 
					AND ACTIVE = 0
					GROUP BY ACTIVE) AS INACTIVE_COUNT
					FROM RENEWAD, BANNERAD, NAME
					WHERE RENEWAD.ADID = BANNERAD.ADID
					AND BANNERAD.ADVERTISER_NAMEID = NAME.NAMEID
				GROUP BY BANNERAD.ADVERTISER_NAMEID, COMPANY
				ORDER BY COMPANY 
			--->
			SELECT DISTINCT
				ADVERTISER_NAMEID AS NAMEID, 
				COMPANY, 
				(SELECT COUNT(ACTIVE) FROM RENEWAD WHERE ADID IN (SELECT ADID FROM BANNERAD WHERE ADVERTISER_NAMEID=X.ADVERTISER_NAMEID) AND ACTIVE=1) AS ACTIVE_COUNT, 
				(SELECT COUNT(ACTIVE) FROM RENEWAD WHERE ADID IN (SELECT ADID FROM BANNERAD WHERE ADVERTISER_NAMEID=X.ADVERTISER_NAMEID) AND ACTIVE=0) AS INACTIVE_COUNT 
			FROM BANNERAD X, NAME
			WHERE X.ADVERTISER_NAMEID = NAME.NAMEID
			ORDER BY COMPANY
		</cfquery>
		<cfreturn getAdvertiserdata>
	</cffunction>
	
	<cffunction name="getImpressionsPerDay" access="public" returnType="query" 
	hint="I get clicks and impression counts per day for a specific ad. Fields Returned: YEARMONTHDAY, CLICK, IMPRESSION">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ad id">
		<cfargument name="startdate" required="true" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="true" type="String" default="0" hint="end date to display report">
		<cfset var getImpressionsPDay=0>
		<cfquery name="getImpressionsPDay" dataSource="#admanagementdsn#">
			SELECT CLICKTABLE.YEARMONTHDAY,
				   CASE WHEN CLICK IS NULL THEN 0 ELSE CLICK END AS CLICK,
				   IMPRESSION
			FROM 
				(SELECT LEFT(RECORDEDON,8) AS YEARMONTHDAY, COUNT(CLICK) AS IMPRESSION , ADID
				FROM IMPRESSION_RECORD
				WHERE CLICK = 0 AND ADID = <cfqueryparam value="#adid#" CFSQLType="CF_SQL_BIGINT">
				GROUP BY LEFT(RECORDEDON,8), ADID) AS CLICKTABLE
			LEFT OUTER JOIN
				(SELECT LEFT(RECORDEDON,8) AS YEARMONTHDAY, COUNT(CLICK) AS CLICK, ADID
				FROM IMPRESSION_RECORD
				WHERE CLICK = 1 AND ADID = <cfqueryparam value="#adid#" CFSQLType="CF_SQL_BIGINT">
				GROUP BY LEFT(RECORDEDON,8), ADID) AS IMPRESSIONTABLE
			ON 
				CLICKTABLE.YEARMONTHDAY = IMPRESSIONTABLE.YEARMONTHDAY
			WHERE 
				CLICKTABLE.ADID = <cfqueryparam value="#adid#" CFSQLType="CF_SQL_BIGINT">
			<cfif startdate NEQ "0">
			AND CLICKTABLE.YEARMONTHDAY>=<cfqueryparam value="#left(startdate,8)#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND CLICKTABLE.YEARMONTHDAY<=<cfqueryparam value="#left(enddate,8)#" cfsqltype="cf_sql_varchar">
			</cfif>
				
		</cfquery>
		<cfreturn getImpressionsPDay>
	</cffunction>
	
	<cffunction name="getCurrent" access="public" returntype="query" hint="I get all current click and impression counts for a specific ad. Fields Returned: current (count of clicks and impressions), click (0 or 1, 0 = Impression, 1 = Click)">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ad id">
		<cfset var getClick=0>
		<cfquery name="getClick" datasource="#admanagementdsn#">
			SELECT count(CLICK) AS 'CURRENT', CLICK FROM IMPRESSION_RECORD
				WHERE ADID = <cfqueryparam value="#adid#" CFSQLType="CF_SQL_BIGINT">
				GROUP BY CLICK
		</cfquery>
		<cfreturn getClick>	
	</cffunction>

	<cffunction name="getRenewAd" access="public" returntype="query" hint="I get all renew information for an ad. Return fields: RENEWID, ADID RECORDEDON, ACTIVATEDON, STARTDATE, ENDDATE, MAXCLICK, MAXIMPRESSION, CHECK_DATE, ACTIVE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ad id">
		<cfset var renewAd=0>
		<cfquery name="renewAd" datasource="#admanagementdsn#">
			SELECT
				RENEWID,
				ADID,
				RECORDEDON,
				ACTIVATEDON,
				STARTDATE,
				ENDDATE,
				MAXCLICK,
				MAXIMPRESSION,
				CHECKDATE,
				ACTIVE
			FROM RENEWAD
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn renewAd>
	</cffunction>
	
	<cffunction name="getLatestRenewAd" access="public" returntype="query" hint="I get all renew information for an ad. Return fields: RENEWID, ADID RECORDEDON, ACTIVATEDON, STARTDATE, ENDDATE, MAXCLICK, MAXIMPRESSION, CHECK_DATE, ACTIVE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ad id">
		<cfset var latestrenewad=0>
		<cfquery name="latestrenewad" datasource="#admanagementdsn#">
			SELECT TOP 1
				RENEWID,
				ADID,
				RECORDEDON,
				ACTIVATEDON,
				STARTDATE,
				ENDDATE,
				MAXCLICK,
				MAXIMPRESSION,
				CHECK_DATE,
				ACTIVE
			FROM RENEWAD
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn latestrenewad>
	</cffunction>
	
	<cffunction name="addImpression" access="public" returntype="void" hint="Add an impression when an ad is shown">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="ipaddress" required="true" type="string" hint="Ip address of the machine where ad is displayed">
		<cfargument name="cfid" required="true" type="numeric" hint="session id">
		<cfargument name="zoneid" required="true" type="string" hint="id of the zone where the ad was displayed">
		<cfargument name="click" required="false" type="string" hint="pass this variable  as 1 for click on the link">
		<cfset var addimpression=0>
		<cfset var makeadinactive=0>
		<cfset var getmaximpression=0>
		<cfset var getTotalImpressions=0>
		<cfset var inactivated=0>
		<cfquery name="addimpression" datasource="#admanagementdsn#">
			INSERT INTO IMPRESSION_RECORD
			(
				ADID,
				CFID,
				IPADDRESS,
				ZONEID,
				RECORDEDON
				<cfif isDefined('click')>
				,CLICK
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#cfid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#ipaddress#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('click')>
				,<cfqueryparam value="#click#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			
		</cfquery>
		
		<!--- get maximpression --->
		<cfquery name="getmaximpression" datasource="#admanagementdsn#">
			SELECT 
				MAXIMPRESSION, 
				MAXCLICK, 
				ENDDATE, 
				CHECK_DATE 
				FROM RENEWAD 
				WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
				AND ACTIVE=1
		</cfquery>
		
		<cfinvoke method="getTotalImpressions" returnvariable="totalimpression" admanagementdsn="#admanagementdsn#" adid="#adid#">
		
		<cfset inactivated=0>
		
		<cfif totalimpression.TOTAL gte getmaximpression.MAXIMPRESSION>
			<cfquery name="makeadinactive" datasource="#admanagementdsn#">
				UPDATE RENEWAD
				SET ACTIVE=0
				WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			</cfquery>
			<cfset inactivated=1>
		
		<cfelseif getmaximpression.MAXCLICK NEQ 0>
			<cfif totalimpression.NOOFCLICKS gte getmaximpression.MAXCLICK >
				<cfquery name="makeadinactive" datasource="#admanagementdsn#">
					UPDATE RENEWAD
					SET ACTIVE=0
					WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
				</cfquery>
				<cfset inactivated=1>
			</cfif>
	
		<cfelseif getmaximpression.CHECK_DATE NEQ 0>
			<cfif getmaximpression.ENDDATE LTE mytime.createtimedate() >
				<cfquery name="makeadinactive" datasource="#admanagementdsn#">
					UPDATE RENEWAD
					SET ACTIVE=0
					WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
				</cfquery>
				<cfset inactivated=1>
			</cfif>
		</cfif>
		
		<cfif inactivated EQ 1>
			<cfquery name="activateRenewed" datasource="#admanagementdsn#">
				UPDATE RENEWAD
				SET ACTIVATEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">, ACTIVE=1
				WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
				AND ACTIVATEDON='Not Activated'
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getZones" access="public" returntype="query" hint="Show all zones. Return fields: ZONEID,ZONECONTAINERID,MODULEID,DESCRIPTION">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="zoneid" required="false" type="string" default="0" hint="Zone ID you want information for">
		<cfset var getadzones=0>
		<cfquery name="getadzones" datasource="#admanagementdsn#">
			SELECT
				ZONES.ZONEID,
				ZONES.ZONECONTAINERID,
				ZONES.MODULEID,
				ZONES.DESCRIPTION,
				ZONECONTAINER.COLOR,
				ZONECONTAINER.BGCOLOR,
				ZONECONTAINER.DESCRIPTION AS ZC_DESCRIPTION,
				ZONECONTAINER.CSSID,
				ZONECONTAINER.MAXZONES,
				ZONECONTAINER.WIDTH,
				ZONECONTAINER.HEIGHT
			FROM ZONES, ZONECONTAINER
			WHERE ZONES.ZONECONTAINERID = ZONECONTAINER.ZONECONTAINERID
			<cfif arguments.zoneid NEQ 0>AND ZONES.ZONEID = <cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar"></cfif>
		</cfquery>
		<cfreturn getadzones>
	</cffunction> 
	
	<cffunction name="getRandomAds" access="public" returntype="query" hint="Show random ads. Return fields: ADID, ADNAME, ADVERTISER_NAMEID, ZONEID, TARGET_URL, IMAGE_PATH, DISPLAYTEXT, ACTIVE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="zoneid" required="true" type="numeric" hint="zoneid of the zone where the ads are to be displayed">
		<cfargument name="noofads" required="true" type="numeric" hint="number of ads that needs to be shown">
		<cfargument name="cfid" required="false" type="string" hint="id of the session">
		<cfset var randomads=0>
		<cfset var expiredad=0>
		<cfset var get=0>
		<cfquery name="expiread" datasource="#admanagementdsn#">
			UPDATE RENEWAD
			SET ACTIVE=0
			WHERE ENDDATE < <cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			AND ACTIVE=1
			AND CHECK_DATE=1
		</cfquery>
		
		<cfquery name="get" datasource="#admanagementdsn#">
			SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1
		</cfquery>
		<!--- 
			<cfinvoke method="getNoofActiveAdsinZone" argumentcollection="#arguments#" returnvariable="noofactiveads">
			<cfif noofactiveads GT 1>
				<cfset less1=noofactiveads-1>
			</cfif>
			
			<cfquery name="get" datasource="#arguments.admanagementdsn#">
				SELECT TOP #less1# ADID 
				FROM IMPRESSION_RECORD 
				WHERE ZONEID=<cfqueryparam Value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
				AND CLICK<>1
				AND CFID=#arguments.cfdi#
				ORDER BY RECORDEDON DESC
			</cfquery>
			
			<cfif get.recordcount NEQ 0>
				<cfset donotincludelist=ValueList(get.ADID)>
			</cfif> 
		--->
		
		<cfquery name="randomads" datasource="#admanagementdsn#">
			SELECT TOP #noofads#
				BANNERAD.ADID,
				BANNERAD.ADNAME,
				BANNERAD.ADVERTISER_NAMEID,
				BANNERAD.ZONEID,
				BANNERAD.TARGET_URL,
				BANNERAD.IMAGE_PATH,
				BANNERAD.DISPLAYTEXT,
				RENEWAD.ACTIVE,
				RENEWAD.ENDDATE,
				RENEWAD.CHECK_DATE
			FROM BANNERAD, RENEWAD
			WHERE RENEWAD.ACTIVE=1
			AND ZONEID =<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_bigint">
			AND BANNERAD.ADID=RENEWAD.ADID
			AND RENEWAD.STARTDATE < <cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_bigint">
			<cfif get.recordcount GT 0>
			AND BANNERAD.ADID NOT IN(SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1)
			</cfif>
			ORDER BY NEWID()
		</cfquery>
		<cfreturn randomads>
	</cffunction>
	
	<cffunction name="getAllZones" access="public" returnType="query" 
		hint="I get all Zones for Ad Management. Return fields: ZONEID, ZONECONTAINERID, DESCRIPTION, MODULEID, WIDTH, HEIGHT, COLOR, BGCOLOR, CSSID, MAXZONES">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfset var getZones=0>
		<cfquery name="getZones" datasource="#admanagementdsn#">
			SELECT
				ZONEID,
				ZONES.ZONECONTAINERID,
				ZONES.DESCRIPTION,
				MODULEID,
				WIDTH,
				HEIGHT,
				COLOR,
				BGCOLOR,
				CSSID,
				MAXZONES,
				(SELECT COUNT(ADID) FROM BANNERAD WHERE ZONEID=ZONES.ZONEID AND ADID NOT IN (SELECT ADID FROM DELETEDADS WHERE DELETED=1)) AS TOTALADS
			FROM ZONES, ZONECONTAINER
			WHERE 
				ZONES.ZONECONTAINERID = ZONECONTAINER.ZONECONTAINERID AND
				MODULEID = 1
			ORDER BY CONVERT(VARCHAR(120),ZONES.DESCRIPTION) ASC
		</cfquery>
		<cfreturn getZones>
	</cffunction>
	
	<cffunction name="getImpressions" access="public" returntype="query" hint="I get impressions for a particular advertisement. Return fields: ID,ADID,CFID,CLICK,IPADDRESS,RECORDEDON">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="startdate" required="true" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="true" type="String" default="0" hint="end date to display report">
		<cfset var impressions=0>
		<cfquery name="impressions" datasource="#arguments.admanagementdsn#">
			SELECT
				ID,
				ADID,
				CFID,
				CLICK,
				IPADDRESS,
				RECORDEDON
			FROM IMPRESSION_RECORD
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_bigint">
			<cfif arguments.startdate NEQ "0">
			AND RECORDEDON>=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ "0">
			AND RECORDEDON<=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn impressions>
	</cffunction>
	
	<cffunction name="getTotalImpressions" access="public" returntype="query" hint="I get impressions for a particular advertisement. Return fields: ID,ADID,CFID,CLICK,IPADDRESS,RECORDEDON">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="startdate" required="true" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="true" type="String" default="0" hint="end date to display report">
		<cfset var totalimpressions=0>
		<cfquery name="totalimpressions" datasource="#admanagementdsn#">
			SELECT
			COUNT(*) AS TOTAL,
			(SELECT COUNT(*) FROM IMPRESSION_RECORD WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar"> AND CLICK=1) AS NOOFCLICKS
			FROM IMPRESSION_RECORD
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			<cfif startdate NEQ "0">
			AND RECORDEDON>=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND RECORDEDON<=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn totalimpressions>
	</cffunction>

	<cffunction name="getUniqueImpressions" access="public" returntype="query" hint="I get impressions for a particular advertisement. Return fields: CFID,TOTAL,FROMTIME,TOTIME">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="adid from bannead">
		<cfargument name="startdate" required="true" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="true" type="String" default="0" hint="end date to display report">
		<cfset var uniqueimpressions=0>
		<cfquery name="uniqueimpressions" datasource="#admanagementdsn#">
			SELECT CFID, COUNT(*) AS TOTAL, MIN(RECORDEDON) AS FROMTIME, MAX(RECORDEDON) AS TOTIME
			FROM IMPRESSION_RECORD
			WHERE ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
			<cfif startdate NEQ "0">
			AND RECORDEDON>=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND RECORDEDON<=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			GROUP BY CFID
		</cfquery>
		<cfreturn uniqueimpressions>
	</cffunction>

	<cffunction name="getZonesforAd" access="public" returntype="query" hint="I get all the zones the ad belongs to. Return fields: ZONEID, ZONECONTAINERID, DESCRIPTION, MODULEID">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="false" type="String" hint="adid">
		<cfset var ZonesforAd=0>
		<cfquery name="ZonesforAd" datasource="#arguments.admanagementdsn#">
			SELECT
				ZONES.ZONEID,
				ZONES.ZONECONTAINERID,
				ZONES.DESCRIPTION,
				ZONES.MODULEID
			FROM ZONES, AD_TO_ZONE
			WHERE AD_TO_ZONE.ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">
			AND ZONES.ZONEID=AD_TO_ZONE.ZONEID
		</cfquery>
		<cfreturn ZonesforAd>
	</cffunction>
	
	<cffunction name="getNoofActiveAdsinZone" access="public" returntype="string" hint="I get the number of active ad in a particular zone">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="zoneid" required="true" type="string" hint="zone id">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.admanagementdsn#">
			SELECT COUNT(BANNERAD.ADID) AS ADCOUNT 
			FROM BANNERAD, RENEWAD
			WHERE BANNERAD.ADID=RENEWAD.ADID
			AND RENEWAD.ACTIVE=1
			AND BANNERAD.ZONEID=<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
			AND BANNERAD.ADID NOT IN (SELECT ADID FROM DELETEDADS)
		</cfquery>
		<cfreturn get.ADCOUNT>
	</cffunction>
	

	<!--- Removed functions --->
	
	<!--- <cffunction name="editAdvertisement" access="public" returntype="void" hint="I add advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="numeric" hint="ad id">
		<cfargument name="adname" required="true" type="string" hint="name of the ad">
		<cfargument name="advertiser_nameid" required="false" type="numeric" hint="nameid of the advertiser">
		<cfargument name="zoneid" required="false" type="numeric" hint="adcategoryid">
		<cfargument name="startdate" required="false" type="string" hint="startdate">
		<cfargument name="enddate" required="false" type="string" hint="enddate">
		<cfargument name="target_url" required="false" type="string" hint="url where the click on the ad should take">
		<cfargument name="image_path" required="false" type="string" hint="path of the image">
		<cfargument name="maxclick" required="false" type="string" hint="if click should be check before displaying">
		<cfargument name="maximpression" required="false" type="string" hint="if impression should be check before displaying">
		<cfargument name="check_date" required="false" type="string" hint="if date should be checked before displaying">
		<cfargument name="active" required="false" type="string" hint="set the date to active or passive">
		<cfquery name="addadvertisement" datasource="#admanagementdsn#">
			UPDATE BANNERAD
			SET
				ADNAME=<cfqueryparam value="#adname#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('advertiser_nameid')>
				,ADVERTISER_NAMEID=<cfqueryparam value="#advertiser_nameid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isDefined('zoneid')>
				,ZONEID=<cfqueryparam value="#zoneid#" cfsqltype="cf_sql_bigint">
				</cfif>
				<cfif isDefined('startdate')>
				,STARTDATE=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('enddate')>
				,ENDDATE=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('target_url')>
				,TARGET_URL=<cfqueryparam value="#target_url#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('image_path')>
				,IMAGE_PATH=<cfqueryparam value="#image_path#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('maxclick')>
				,MAXCLICK=<cfqueryparam value="#maxclick#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('maximpression')>
				,MAXIMPRESSION=<cfqueryparam value="#maximpression#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('check_date')>
				,CHECK_DATE=<cfqueryparam value="#check_date#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('active')> 
				,ACTIVE=<cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE
				ADID=<cfqueryparam value="#adid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction> --->
</cfcomponent>