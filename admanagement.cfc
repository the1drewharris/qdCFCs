<!--- 
	Things to do in admanagement 
	1. Create a temporary table for impression record which should last only a day.
	2. At the end of each day, data from the temporary table should be archieved and data should be deleted.
	3. Create another table which keeps the statistics per ad in a table. This table should also be updated
	   at the end of the day, may be 11:59 AM everyday.
	    
--->

<cfcomponent hint="I have functions for ad management">
	<cfobject component="timedateConversion" name="mytime">
	
	<cffunction name="addZoneContainer" returnType="string" access="public" hint="Add an ad zone container and returns addZoneContainerID">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="height" required="true" type="string" hint="Height of the zone container">
		<cfargument name="width" required="true" type="string" hint="Width of the zone container">
		<cfargument name="color" required="false" type="string" hint="Color of the zone container" default="0">
		<cfargument name="bgcolor" required="false" type="string" hint="BGColor of the zone container" default="0">
		<cfargument name="description" required="true" type="string" hint="Description (name) of the zone container">
		<cfargument name="cssid" required="false" type="string" hint="CSS ID for the zone container" default="0">
		<cfargument name="maxzones" required="false" type="string" hint="Maximum number of zones in the zone container" default="1">
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
				<cfqueryparam value="#arguments.height#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.width#" CFSQLType="CF_SQL_varchar">,
				<cfif arguments.color NEQ 0><cfqueryparam value="#arguments.color#" CFSQLType="CF_SQL_varchar">,</cfif>
				<cfif arguments.bgcolor NEQ 0><cfqueryparam value="#arguments.bgcolor#" CFSQLType="CF_SQL_varchar">,</cfif>
				<cfqueryparam value="#arguments.description#" CFSQLType="CF_SQL_LONGVARCHAR">,
				<cfqueryparam value="#arguments.cssid#" CFSQLType="CF_SQL_varchar">,
				<cfqueryparam value="#arguments.maxzones#" CFSQLType="CF_SQL_varchar">
			)
			SELECT @@IDENTITY AS ZONECONTAINERID	
		</cfquery>
		<cfreturn addZoneContainer.ZONECONTAINERID>
	</cffunction>
	
	<cffunction name="addZone" returntype="string" access="public" hint="Add an ad category and returns ADCATEGORYID">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="zonecontainerid" required="true" type="string" hint="width of the AD">
		<cfargument name="moduleid" required="true" type="string" hint="name of the module that a zone is tied to">
		<cfargument name="description" required="false" type="string" default="0" hint="height of the AD">
		<cfset var addzone=0>
			<cfquery name="addzone" datasource="#arguments.admanagementdsn#">
				INSERT INTO ZONES
				(
					ZONECONTAINERID,
					MODULEID
					<cfif arguments.description NEQ "0">
					,DESCRIPTION
					</cfif>
				)
				VALUES
				(
					<cfqueryparam value="#arguments.zonecontainerid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
					<cfif arguments.description NEQ "0">
					,<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">
					</cfif>
				)
				SELECT @@IDENTITY AS ZONEID
			</cfquery>
			<cfreturn addzone.ZONEID>
	</cffunction>
	
	<cffunction name="addBannerAd" access="public" returntype="string" hint="I add advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adname" required="true" type="string" hint="name of the ad">
		<cfargument name="advertiser_nameid" required="true" type="string" hint="nameid of the advertiser">
		<cfargument name="zoneid" required="true" type="string" hint="adcategoryid">
		<cfargument name="target_url" required="true" type="string" hint="url where the click on the ad should take">
		<cfargument name="image_path" required="false" type="string" default="0" hint="path of the image">
		<cfargument name="displaytext" required="false" type="string" default="0" hint="Text to display for text based AD">
		<cfset var addbannerad=0>
		<cfset var add=0>
		<cfquery name="addbannerad" datasource="#arguments.admanagementdsn#">
			INSERT INTO BANNERAD
			(
				ADNAME,
				ADVERTISER_NAMEID,
				ZONEID,
				TARGET_URL
				<cfif arguments.image_path NEQ "0">
				,IMAGE_PATH
				</cfif>
				<cfif arguments.displaytext NEQ "0">
				,DISPLAYTEXT
				</cfif>
			)
			VALUES
			(	
				<cfqueryparam value="#arguments.adname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.advertiser_nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.target_url#" cfsqltype="cf_sql_varchar">
				<cfif arguments.image_path NEQ "0">
				,<cfqueryparam value="#arguments.image_path#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.displaytext NEQ "0">
				,<cfqueryparam value="#arguments.displaytext#" cfsqltype="cf_sql_longvarchar">
				</cfif>
			)
			SELECT @@IDENTITY AS ADID
		</cfquery>
		
		<cfquery name="add" datasource="#arguments.admanagementdsn#">
			INSERT INTO IMPRESSION_COUNTS
			(
				ADID
			)
			VALUES
			(
				<cfqueryparam value="#addbannerad.adid#" cfsqltype="cf_sql_varchar">
			)
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
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			AND ZONEID=<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
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
					<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">	
				)
			</cfquery>
			<cfreturn "success">
		<cfelse>
			<cfreturn "failure">
		</cfif>
	</cffunction>
	
	<cffunction name="renewAd" access="public" returntype="string" hint="I renew advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ADID of the advertisement to be renewed">
		<cfargument name="startdate" required="true" type="string" hint="startdate">
		<cfargument name="enddate" required="true" type="string" hint="enddate">
		<cfargument name="check_date" required="false" default="0" type="string" hint="if check_date should be check before displaying">
		<cfargument name="maxclick" required="false" type="string" default=0 hint="if click should be check before displaying">
		<cfargument name="maximpression" required="false" default=0 type="string" hint="if impression should be check before displaying">
		<cfargument name="active" required="false" default=0 type="string" hint="If the ad should be activated or not. 1 to make active">
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
				<cfif arguments.active EQ 1>
				,ACTIVATEDON
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.maxclick#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.maximpression#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.check_date#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_varchar">
				<cfif arguments.active EQ 1>
				,<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS RENEWID
		</cfquery>
		<cfreturn renewad.RENEWID>
	</cffunction>

	<cffunction name="activateAd" access="public" returntype="void" hint="I activate advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ADID of the Ad that needs to be activated">
		<cfset var activatead=0>
		<cfquery name="activatead" datasource="#arguments.admanagementdsn#">
			UPDATE TABLE RENEWAD SET 
			ACTIVATEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
			ACTIVE=1
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			AND ACTIVATEDON='Not Activated'
		</cfquery>
	</cffunction>
	
	<cffunction name="editBannerAd" access="public" returntype="void" hint="I update bannerad table">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfargument name="adname" required="true" type="string" hint="name given to ad">
		<cfargument name="advertiser_nameid" required="false" type="string" default="0" hint="advertiser's nameid">
		<cfargument name="zoneid" required="false" type="string" default="0" hint="zoneid of the zone where the ad should be displayed">
		<cfargument name="target_url" required="false" type="string" default="0" hint="url where the click on ad should direct">
		<cfargument name="image_path" required="false" type="string" default="0" hint="path of the ad image">
		<cfargument name="displaytext" required="false" type="string" default="0" hint="text to be displayed as Ad">
		<cfset var editbannerad=0>
		<cfquery name="editbannerad" datasource="#arguments.admanagementdsn#">
			UPDATE BANNERAD
			SET 
				ADNAME=<cfqueryparam value="#arguments.adname#" cfsqltype="cf_sql_varchar">
				<cfif arguments.advertiser_nameid NEQ 0>
				,ADVERTISER_NAMEID=<cfqueryparam value="#arguments.advertiser_nameid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.zoneid NEQ 0>
				,ZONEID=<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.target_url NEQ 0>
				,TARGET_URL=<cfqueryparam value="#arguments.target_url#" cfsqltype="cf_sql_longvarchar">
				</cfif>
				<cfif arguments.image_path NEQ 0>
				,IMAGE_PATH=<cfqueryparam value="#arguments.image_path#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.displaytext NEQ 0>
				,DISPLAYTEXT=<cfqueryparam value="#arguments.displaytext#" cfsqltype="cf_sql_longvarchar">
				</cfif>
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="editRenewAd" access="public" returntype="void" hint="I edit renewad table">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="renewid" required="true" type="string" hint="renewid of the row to be updated">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfargument name="startdate" required="false" type="string" default="0" hint="new start date">
		<cfargument name="enddate" required="false" type="string" default="0" hint="new end date">
		<cfargument name="maxclick" required="false" type="string" default="0" hint="new max number of click allowed">
		<cfargument name="check_date" required="false" type="string" default="-1" hint="0 or 1 for date based ADs">
		<cfargument name="active" required="false" type="string" default="-1" hint="0 or 1 to make an AD active or inactive">
		<cfset var editrenewad=0>
		<cfquery name="editrenewad" datasource="#arguments.admanagementdsn#">
			UPDATE RENEWAD
			SET
				ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
				<cfif arguments.startdate NEQ 0>
				,STARTDATE=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.enddate NEQ 0>
				,ENDDATE=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.maxclick NEQ 0>
				,MAXCLICK=<cfqueryparam value="#arguments.maxclick#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.maximpression NEQ 0>
				,MAXIMPRESSION=<cfqueryparam value="#arguments.maximpression#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.check_date NEQ -1>
				,CHECK_DATE=<cfqueryparam value="#arguments.check_date#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.active NEQ -1>
				,ACTIVE=<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE RENEWID=<cfqueryparam value="#arguments.renewid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
			
	<cffunction name="getBannerAd" access="public" returntype="query" hint="I get all advertisement information. Return fields: ADID,ADNAME,ADVERTISER_NAMEID,COMPANY,ZONEID,DESCRIPTION,TARGET_URL,IMAGE_PATH,ACTIVE,CHECK_DATE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="false" default=0 type="String" hint="adid">
		<cfargument name="advertiser_nameid" required="false" type="String" default="0" hint="nameid of the person or company for whom ad was created">
		<cfargument name="zoneid" required="false" type="String" hint="zoneid of the zone where the ads are hosted" default=0>
		<cfargument name="sortorder" required="false" type="string" default="BANNERAD.ZONEID" hint="Sort order">
		<cfset var getbannerad=0>
		<cfquery name="getbannerad" datasource="#arguments.admanagementdsn#">
			SELECT
				BANNERAD.ADID,
				ADNAME,
				MAXCLICK,
				MAXIMPRESSION,
				STARTDATE,
				ENDDATE,
				ADVERTISER_NAMEID,
				NAME.COMPANY,
				BANNERAD.ZONEID,
				ZONES.DESCRIPTION,
				TARGET_URL,
				IMAGE_PATH,
				DISPLAYTEXT,
				RENEWAD.ACTIVE,
				RENEWAD.CHECK_DATE
			FROM BANNERAD,ZONES,RENEWAD,NAME
			WHERE ZONES.ZONEID=BANNERAD.ZONEID
			AND BANNERAD.ADID = RENEWAD.ADID
			AND BANNERAD.ADVERTISER_NAMEID=NAME.NAMEID
			AND BANNERAD.ADID NOT IN (SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1)
			<cfif arguments.adid NEQ 0>
			AND BANNERAD.ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.zoneid NEQ 0>
			AND BANNERAD.ZONEID=<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.advertiser_nameid NEQ 0>
			AND ADVERTISER_NAMEID=<cfqueryparam value="#arguments.advertiser_nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY #arguments.sortorder#
		</cfquery>
		<cfreturn getbannerad>
	</cffunction>
	
	<cffunction name="getDeletedAds" access="public" returntype="query" hint="I get all advertisement information. Return fields: ADID,ADNAME,ADVERTISER_NAMEID,ZONEID,DESCRIPTION,TARGET_URL,IMAGE_PATH">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="false" default="0" type="string" hint="adid">
		<cfargument name="advertiser_nameid" required="false" default="0" type="string" hint="nameid of the person or company for whom ad was created">
		<cfset var getbannerad=0>
		<cfquery name="getbannerad" datasource="#arguments.admanagementdsn#">
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
			<cfif arguments.adid NEQ 0>
			AND BANNERAD.ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.advertiser_nameid NEQ 0>
			AND ADVERTISER_NAMEID=<cfqueryparam value="#arguments.advertiser_nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY BANNERAD.ZONEID
		</cfquery>
		<cfreturn getbannerad>
	</cffunction>

	<cffunction name="deleteAd" access="public" returntype="void" hint="I delete Ad logically">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfset var deletead=0>
		<cfquery name="deletead" datasource="#arguments.admanagementdsn#">
			INSERT INTO DELETEDADS
			(
				ADID,
				DELETED,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">,
				1,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			)
			
			UPDATE DELETEDADS SET DELETED=1
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="RestoreAd" access="public" returntype="void" hint="Restore Advertisement">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfset var restore=0>
		<cfset var restorerecord=0>
		<cftransaction>
			<cfquery name="restore" datasource="#arguments.admanagementdsn#">
				UPDATE DELETEDADS
				SET DELETED=0
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="restorerecord" datasource="#arguments.admanagementdsn#">
				INSERT INTO DELETEDADS
				(
					ADID,
					DELETED,
					TIMEDATE
				)
				VALUES
				(
					<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">,
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
			SELECT DISTINCT
				ADVERTISER_NAMEID AS NAMEID, 
				COMPANY, 
				(
					SELECT COUNT(ACTIVE) 
					FROM RENEWAD 
					WHERE ADID IN(SELECT ADID FROM BANNERAD WHERE ADVERTISER_NAMEID=X.ADVERTISER_NAMEID) 
					AND ACTIVE=1
					AND STARTDATE<<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
					AND ADID NOT IN(SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS ACTIVE_COUNT, 
				(
					SELECT COUNT(ACTIVE) 
					FROM RENEWAD 
					WHERE ADID IN(SELECT ADID FROM BANNERAD WHERE ADVERTISER_NAMEID=X.ADVERTISER_NAMEID) 
					AND ACTIVE=1
					AND STARTDATE><cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
					AND ADID NOT IN(SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS FUTURE_COUNT, 
				(
					SELECT COUNT(ACTIVE) 
					FROM RENEWAD 
					WHERE ADID IN (SELECT ADID FROM BANNERAD WHERE ADVERTISER_NAMEID=X.ADVERTISER_NAMEID) 
					AND ACTIVE=0
					AND ADID NOT IN(SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS INACTIVE_COUNT 
			FROM BANNERAD X, NAME
			WHERE X.ADVERTISER_NAMEID = NAME.NAMEID
			ORDER BY COMPANY
		</cfquery>
		<cfreturn getAdvertiserdata>
	</cffunction>
	
	<cffunction name="getImpressionsPerDay" access="public" returnType="query" hint="I get clicks and impression counts per day for a specific ad. Fields Returned: YEARMONTHDAY, CLICK, IMPRESSION">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ad id">
		<cfargument name="startdate" required="true" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="true" type="String" default="0" hint="end date to display report">
		<cfset var getImpressionsPDay=0>
		<cfquery name="getImpressionsPDay" dataSource="#arguments.admanagementdsn#">
			SELECT 
				ADID,
				IMPRESSIONDATE,
				NOOFIMPRESSIONS,
				NOOFUNIQUEIMPRESSIONS,
				NOOFCLICKS
			FROM DAILY_IMPRESSIONS
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.startdate NEQ 0>
			AND IMPRESSIONDATE>=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.enddate NEQ 0>
			AND IMPRESSIONDATE<=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn getImpressionsPDay>
	</cffunction>
	
	<cffunction name="getCurrent" access="public" returntype="query" hint="I get all current click and impression counts for a specific ad. Fields Returned: current (count of clicks and impressions), click (0 or 1, 0 = Impression, 1 = Click)">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ad id">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.admanagementdsn#">
			SELECT
				ADID,
				NOOFCLICKS,
				NOOFIMPRESSIONS,
				NOOFUNIQUEIMPRESSIONS
			FROM IMPRESSION_COUNTS
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>	
	</cffunction>

	<cffunction name="getRenewAd" access="public" returntype="query" hint="I get all renew information for an ad. Return fields: RENEWID, ADID RECORDEDON, ACTIVATEDON, STARTDATE, ENDDATE, MAXCLICK, MAXIMPRESSION, CHECK_DATE, ACTIVE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ad id">
		<cfset var renewAd=0>
		<cfquery name="renewAd" datasource="#arguments.admanagementdsn#">
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
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn renewAd>
	</cffunction>
	
	<cffunction name="getLatestRenewAd" access="public" returntype="query" hint="I get all renew information for an ad. Return fields: RENEWID, ADID RECORDEDON, ACTIVATEDON, STARTDATE, ENDDATE, MAXCLICK, MAXIMPRESSION, CHECK_DATE, ACTIVE">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="ad id">
		<cfset var latestrenewad=0>
		<cfquery name="latestrenewad" datasource="#arguments.admanagementdsn#">
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
			WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			ORDER BY RECORDEDON DESC
		</cfquery>
		<cfreturn latestrenewad>
	</cffunction>
	
	<cffunction name="addImpression" access="public" returntype="void" hint="Add an impression when an ad is shown">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfargument name="ipaddress" required="true" type="string" hint="Ip address of the machine where ad is displayed">
		<cfargument name="cfid" required="true" type="string" hint="session id">
		<cfargument name="zoneid" required="true" type="string" hint="id of the zone where the ad was displayed">
		<cfargument name="click" required="false" type="string" default="0" hint="pass this variable  as 1 for click on the link">
		<cfset var addimpression=0>
		<cfset var makeadinactive=0>
		<cfset var getmaximpression=0>
		<cfset var getTotalImpressions=0>
		<cfset var check=0>
		<cfset var inactivated=0>
		
		<cfif arguments.click NEQ 1>
			<cfset arguments.click=0>
		</cfif>
			
		<!--- <cfif ipaddress NEQ "64.207.230.206"> --->
			<cfquery name="addimpression" datasource="#arguments.admanagementdsn#">
				INSERT INTO IMPRESSION_TEMP
				(
					ADID,
					CFID,
					IPADDRESS,
					ZONEID,
					RECORDEDON,
					CLICK
				)
				VALUES
				(
					<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.cfid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.ipaddress#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.click#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			
			<cfquery name="check" datasource="#arguments.admanagementdsn#">
				SELECT TOP 2 * FROM IMPRESSION_TEMP
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
				AND CFID=<cfqueryparam value="#arguments.cfid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		
			<cfquery name="addimpression" datasource="#arguments.admanagementdsn#">
				UPDATE IMPRESSION_COUNTS SET 
					<cfif arguments.click NEQ 0>
						NOOFCLICKS=((SELECT NOOFCLICKS FROM IMPRESSION_COUNTS WHERE ADID=<cfqueryparam value="#arguments.adid#">)+1)
					<cfelse>
						NOOFIMPRESSIONS=((SELECT NOOFIMPRESSIONS FROM IMPRESSION_COUNTS WHERE ADID=<cfqueryparam value="#arguments.adid#">)+1)
						<cfif check.recordcount LT 2>
						,NOOFUNIQUEIMPRESSIONS=((SELECT NOOFUNIQUEIMPRESSIONS FROM IMPRESSION_COUNTS WHERE ADID=<cfqueryparam value="#arguments.adid#">)+1)
						</cfif>
					</cfif>
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- get maximpression --->
			<cfquery name="getmaximpression" datasource="#arguments.admanagementdsn#">
				SELECT 
					MAXIMPRESSION, 
					MAXCLICK, 
					ENDDATE, 
					CHECK_DATE 
				FROM RENEWAD 
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="totalimpressions" datasource="#arguments.admanagementdsn#">
				SELECT
					ADID,
					NOOFIMPRESSIONS,
					NOOFCLICKS
				FROM IMPRESSION_COUNTS
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif getmaximpression.MAXIMPRESSION NEQ 0>
				<cfif totalimpressions.NOOFIMPRESSIONS GTE getmaximpression.MAXIMPRESSION>
					<cfquery name="makeadinactive" datasource="#arguments.admanagementdsn#">
						UPDATE RENEWAD SET 
							ACTIVE=0
						WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
			<cfif getmaximpression.MAXCLICK NEQ 0>
				<cfif (totalimpressions.NOOFCLICKS GTE getmaximpression.MAXCLICK)>
					<cfquery name="makeadinactive" datasource="#arguments.admanagementdsn#">
						UPDATE RENEWAD
						SET ACTIVE=0
						WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
			<cfif getmaximpression.CHECK_DATE NEQ 0>
				<cfif getmaximpression.ENDDATE LTE mytime.createtimedate()>
					<cfquery name="makeadinactive" datasource="#arguments.admanagementdsn#">
						UPDATE RENEWAD
						SET ACTIVE=0
						WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		<!--- </cfif> --->
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
		<cfargument name="zoneid" required="true" type="string" hint="zoneid of the zone where the ads are to be displayed">
		<cfargument name="cfid" required="true" type="string" hint="id of the session">
		<cfargument name="noofads" required="false" type="string"  default="1" hint="number of ads that needs to be shown">
		<cfset var randomads=0>
		<cfset var get=0>
		
		<!--- while shuffling we can get only one ad. Thats how we should use it from now onwards --->
		<cfset arguments.noofads=1> 
		
		<cfquery name="get" datasource="#admanagementdsn#">
			SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1
		</cfquery>
		
		<cfif get.recordcount GT 0>
			<cfset deleted=ValueList(get.ADID)>
		<cfelse>
			<cfset deleted=0>
		</cfif>
		
		<cfinvoke method="getNoofActiveAdsinZone" argumentcollection="#arguments#" returnvariable="noofactiveads">
		
		<cfif noofactiveads GT 1>
			<cfset less1=noofactiveads-1>
		<cfelse>
			<cfset less1=0>
			<cfset donotincludelist=0>
		</cfif>
		
		<cfif less1 GTE 1>
			<cfquery name="get" datasource="#arguments.admanagementdsn#">
				SELECT TOP #less1# ADID 
				FROM IMPRESSION_TEMP
				WHERE ZONEID=<cfqueryparam Value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
				AND CLICK<>1
				AND CFID=#arguments.cfid#
				ORDER BY RECORDEDON DESC
			</cfquery>
			
			<cfif get.recordcount NEQ 0>
				<cfset donotincludelist=ValueList(get.ADID)>
			<cfelse>
				<cfset donotincludelist=0>
			</cfif> 
		</cfif>
		
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
			AND ZONEID =<cfqueryparam value="#arguments.zoneid#" cfsqltype="cf_sql_varchar">
			AND BANNERAD.ADID=RENEWAD.ADID
			AND RENEWAD.STARTDATE < <cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			<cfif deleted NEQ 0>
			AND BANNERAD.ADID NOT IN(#deleted#)
			</cfif>
			<cfif donotincludelist NEQ 0>
			AND BANNERAD.ADID NOT IN (#donotincludelist#)
			</cfif>
			ORDER BY NEWID()
		</cfquery>
		<cfreturn randomads>
	</cffunction>
	
	<cffunction name="getAllZones" access="public" returnType="query" 
		hint="I get all Zones for Ad Management. Return fields: ZONEID, ZONECONTAINERID, DESCRIPTION, MODULEID, WIDTH, HEIGHT, COLOR, BGCOLOR, CSSID, MAXZONES, ACTIVEADS, INACTIVEADS">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfset var getZones=0>
		<cfquery name="getZones" datasource="#arguments.admanagementdsn#">
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
				(
					SELECT COUNT(BANNERAD.ADID) 
					FROM BANNERAD, RENEWAD 
					WHERE ZONEID=ZONES.ZONEID
					AND BANNERAD.ADID=RENEWAD.ADID 
					AND BANNERAD.ADID NOT IN (SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS TOTALADS,
				(
					SELECT COUNT(BANNERAD.ADID) 
					FROM BANNERAD,RENEWAD 
					WHERE BANNERAD.ZONEID=ZONES.ZONEID 
					AND RENEWAD.ACTIVE=1 
					AND BANNERAD.ADID=RENEWAD.ADID 
					AND RENEWAD.STARTDATE<<cfqueryparam value="#mytime.createtimedate()#"> 
					AND BANNERAD.ADID NOT IN (SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS ACTIVEADS,
				(
					SELECT COUNT(BANNERAD.ADID) 
					FROM BANNERAD,RENEWAD 
					WHERE BANNERAD.ZONEID=ZONES.ZONEID 
					AND RENEWAD.ACTIVE=1 
					AND BANNERAD.ADID=RENEWAD.ADID 
					AND RENEWAD.STARTDATE><cfqueryparam value="#mytime.createtimedate()#"> 
					AND BANNERAD.ADID NOT IN (SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS FUTUREADS,
				(
					SELECT COUNT(BANNERAD.ADID) 
					FROM BANNERAD,RENEWAD 
					WHERE BANNERAD.ZONEID=ZONES.ZONEID 
					AND RENEWAD.ACTIVE=0 
					AND BANNERAD.ADID=RENEWAD.ADID 
					AND BANNERAD.ADID NOT IN (SELECT ADID FROM DELETEDADS WHERE DELETED=1)
				) AS INACTIVEADS
			FROM ZONES, ZONECONTAINER
			WHERE ZONES.ZONECONTAINERID = ZONECONTAINER.ZONECONTAINERID 
			AND MODULEID = 1
			ORDER BY CONVERT(VARCHAR(120),ZONES.DESCRIPTION) ASC
		</cfquery>
		<cfreturn getZones>
	</cffunction>
	
	<cffunction name="getImpressions" access="public" returntype="query" hint="I get impressions for a particular advertisement. Return fields: ADID, NOOFCLICKS, NOOFIMPRESSIONS, NOOFUNIQUEIMPRESSIONS">
		<cfargument name="admanagementdsn" required="true" type="string" hint="datasource">
		<cfargument name="adid" required="true" type="string" hint="adid from bannead">
		<cfargument name="startdate" required="false" type="String" default="0" hint="start date to display report">
		<cfargument name="enddate" required="false" type="String" default="0" hint="end date to display report">
		<cfset var totalimpressions=0>
		<cfif (arguments.startdate EQ 0) AND (arguments.enddate EQ 0)>
			<cfquery name="totalimpressions" datasource="#arguments.admanagementdsn#">
				SELECT
					ADID,
					NOOFCLICKS,
					NOOFIMPRESSIONS,
					NOOFUNIQUEIMPRESSIONS
				FROM IMPRESSION_COUNTS
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfquery name="totalimpressions" datasource="#arguments.admanagementdsn#">
				SELECT 
					ADID,
					SUM(NOOFIMPRESSIONS) AS NOOFIMPRESSIONS,
					SUM(NOOFUNIQUEIMPRESSIONS) AS NOOFUNIQUEIMPRESSIONS,
					SUM(NOOFCLICKS) AS NOOFCLICKS
				FROM DAILY_IMPRESSIONS
				WHERE ADID=<cfqueryparam value="#arguments.adid#" cfsqltype="cf_sql_varchar">
				<cfif arguments.startdate NEQ 0>
				AND IMPRESSIONDATE>=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.enddate NEQ 0>
				AND IMPRESSIONDATE<=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				GROUP BY ADID
			</cfquery>
		</cfif>
		<cfreturn totalimpressions>
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
			AND BANNERAD.ADID NOT IN (SELECT DISTINCT ADID FROM DELETEDADS WHERE DELETED=1)
			AND RENEWAD.STARTDATE < <cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.ADCOUNT>
	</cffunction>
	
	<cffunction name="moveimpressions" access="public" returntype="string" hint="I move impressions from IMPRESSION_TODAY to IMPRESSION_RECORD">
		<cfargument name="ds" required="true" type="string" hint="Data Source">
		<cfargument name="yesterday" required="true" type="string" hint="yesterday's 8 digit date string">
		<cfset var move=0>
		<cfset var get=0>
		<cfquery name="move" datasource="#arguments.ds#">
			INSERT INTO IMPRESSION_RECORD
			(
				ADID,
				CLICK,
				CFID,
				IPADDRESS,
				RECORDEDON,
				ZONEID
			)
			SELECT ADID, CLICK,CFID,IPADDRESS,RECORDEDON,ZONEID 
			FROM IMPRESSION_TEMP WHERE RECORDEDON LIKE <cfqueryparam value="#arguments.yesterday#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				ADID, 
				COUNT(*) AS NOOFIMPRESSIONS,
				(SELECT COUNT(*) FROM IMPRESSION_TEMP X WHERE X.ADID=Y.ADID AND CLICK=1) AS NOOFCLICKS,
				(SELECT COUNT(DISTINCT CFID) FROM IMPRESSION_TEMP Z WHERE Z.ADID=Y.ADID AND CLICK=0) AS NOOFUNIQUEIMPRESSIONS
			FROM IMPRESSION_TEMP Y
			WHERE CLICK<>1
			AND RECORDEDON LIKE <cfqueryparam value="#arguments.yesterday#%" cfsqltype="cf_sql_varchar">
			GROUP BY ADID	
		</cfquery>
		
		<cfloop query="get">
			<cfquery name="add" datasource="#arguments.ds#">
				INSERT INTO DAILY_IMPRESSIONS
				(
					ADID,
					IMPRESSIONDATE,
					NOOFIMPRESSIONS,
					NOOFUNIQUEIMPRESSIONS,
					NOOFCLICKS
				)
				VALUES
				(
					<cfqueryparam value="#adid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.yesterday#00000000" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#noofimpressions#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#noofuniqueimpressions#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#noofclicks#" cfsqltype="cf_sql_varchar">	
				)
			</cfquery>
		</cfloop>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM IMPRESSION_TEMP WHERE RECORDEDON LIKE <cfqueryparam value="#arguments.yesterday#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 1>
	</cffunction>

	<cffunction name="deActivateExpired" access="public" returntype="void" hint="I deactivate expired ads">
		<cfargument name="admanagementdsn" required="true" type="string" hint="data source">
		<cfset var deactivateExpiredAds=0>
		
		<cfquery name="deactivateExpiredAds" datasource="#arguments.admanagementdsn#">
			UPDATE RENEWAD 
			SET ACTIVE=0
			WHERE CHECK_DATE=1
			AND ENDDATE < <cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
</cfcomponent>