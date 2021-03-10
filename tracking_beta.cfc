<cfcomponent hint="I handle all the user tracking">
	<cfobject component="timeDateConversion" name="mytime">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="init" access="public" returntype="void" hint="I run createTrackingTables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke component="tracking" method="createTrackingTables" argumentcollection="#arguments#">
	</cffunction>
	
	<cffunction name="createTrackingTables" access="public" returntype="void" hint="I add the security specific tables to database">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfset var createtables=0>
		<!--- 	ALTER TABLE LASTVISITS DROP CONSTRAINT FK_LASTVISITS_SECURITYID;
		DROP TABLE LASTVISITS;--->
		<cfif not tblCheck.tableExists('#arguments.ds#', 'LASTVISITS')>
		<cfquery name="createtables" datasource="#arguments.ds#">
		
		CREATE TABLE LASTVISITS
		(
			SECURITYID BIGINT NOT NULL,
			MASTERNAMEID BIGINT,
			SITEID VARCHAR(16) NOT NULL,
			SEC VARCHAR(128) NOT NULL,
			VMOD VARCHAR(128) NOT NULL,
			TIMEDATE VARCHAR(16) NOT NULL,
			ACT VARCHAR(128) NOT NULL,
			VURL VARCHAR(256) NOT NULL,
			VARURL NTEXT,
			VARFORM NTEXT
		);
		ALTER TABLE LASTVISITS ADD PRIMARY KEY(SECURITYID, SITEID, SEC, MOD, ACT, TIMEDATE);
		ALTER TABLE LASTVISITS ADD CONSTRAINT FK_LASTVISITS_SECURITYID FOREIGN KEY(SECURITYID) REFERENCES SITESECURITY(SECURITYID);	
		</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction  name="addDashStream" access="public" returntype="void" hint="I add a dashboard stream for actions committed inside of qdcms">
		<cfargument name="ds" type="string" required="true" default="0" hint="I am the datasource">
		<cfargument name="masternameid" type="string" required="true" hint="I am the masternameid of the user who just commited an action in qdcms">
		<cfargument name="stream" type="string" required="true" hint="I am the action the user just submitted">
		<cfset var addStream=0>
		<cfquery name="addStream" datasource="#arguments.ds#">
		INSERT INTO DASHBOARD
		(
			TIMEDATE,
			MASTERNAMEID,
			STREAM
		)
		VALUES
		(
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#arguments.masternameid#">,
			<cfqueryparam value="#arguments.stream#">
		)
		</cfquery>
			
		<cfreturn >			
	</cffunction>
	
	<cffunction name="addVisit" access="public" returntype="void" hint="I add a visit record">
		<cfargument name="ds" type="string" required="true" default="0" hint="I am the datasource">
		<cfargument name="securityid" type="String" required="true" default="0" hint="I am the securityid for the user you are adding a visit record">
		<cfargument name="masternameid" type="string" required="true" default="0" hint="I am the masternameid">
		<cfargument name="sec" type="string" required="true" default="0" hint="I am the section of the site the user is visiting">
		<cfargument name="vmod" type="string" required="true" default="0" hint="I am the module of the site the user is visiting">
		<cfargument name="vurl" type="string" required="false" default="0" hint="The CGI.PATH_TRANSLATED and CGI.QUERY_STRING">
		<cfargument name="act" type="string" required="false" default="0" hint="I am the action the user is visiting"> 
		<cfargument name="siteid" type="string" required="false" default="0" hint="I am the site id of the site the person has selected">
		<cfset var varform=0>
		<cfset var varurl=0>
		<cfset var addMyVisit=0>
		<cfset var td = 0>
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="td">

		<!--- if the varurl is not passed in, set it as best as you can yourself --->
		<cfif arguments.vurl eq "0">
			<cfif isDefined("CGI.HTTPS") AND isDefined("CGI.HTTP_HOST") AND isDefined("CGI.SCRIPT_NAME") AND isDefined("CGI.Query_String")>
				<cfsavecontent variable="arguments.vurl"><cfoutput>http<cfif CGI.HTTPS eq "on">s</cfif>://#CGI.HTTP_HOST##CGI.SCRIPT_NAME#<cfif Len(CGI.Query_String)>?#CGI.Query_String#</cfif></cfoutput></cfsavecontent>
			</cfif>
		</cfif>
		<!--- get the Form Variables --->
		<cfif isStruct(form)>
			<cfif StructCount(form) GT 0>
				<cfwddx action="CFML2WDDX" input="#form#" output="variables.varform">
			<cfelse>
				<cfset variables.varform = "">
			</cfif>
		</cfif>
		<!--- get the URL Variables ---> 
		<cfif isStruct(url)>
			<cfif StructCount(url) GT 0>
				<cfwddx action="CFML2WDDX" input="#URL#" output="variables.varurl">
			<cfelse>
				<cfset variables.varurl = "">
			</cfif>
		</cfif>
		<cfquery name="addMyVisit" datasource="#arguments.ds#">
		INSERT INTO LASTVISITS
		(SECURITYID,
		MASTERNAMEID,
		SEC,
		VMOD,
		TIMEDATE,
		ACT,
		VARURL,
		VARFORM,
		VURL,
		SITEID)
		VALUES
		(<cfqueryparam value="#arguments.securityid#">,
		<cfqueryparam value="#arguments.masternameid#">,
		<cfqueryparam value="#arguments.sec#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.vmod#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#td#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.act#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#variables.varurl#">,
		<cfqueryparam value="#variables.varform#">,
		<cfqueryparam value="#arguments.vurl#">,
		<cfqueryparam value="#arguments.siteid#">)
		</cfquery>
	</cffunction>
	
	<cffunction name="getUsersVisits" access="public" returntype="query" hint="I get the users visits, I return a record set: SECURITYID, MASTERNAMEID, SEC, VMOD, TIMEDATE, ACT, VARURL, VARFORM, VURL, SITEID ">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="securityid" type="String" required="true" default="0" hint="I am the securityid for the user you are adding a visit record">
		<cfargument name="nameid" type="string" required="true" default="0" hint="I am the nameid for the local user">
		<cfargument name="sec" type="string" required="false" default="0" hint="I am the section of the site the user is visiting">
		<cfargument name="module" type="string" required="false" default="0" hint="I am the module of the site the user is visiting">
		<cfargument name="siteid" type="string" required="false" default="0" hint="I am the siteid you want data on">
		<cfset var thisUsersVisits=0>
		<cfquery name="thisUsersVisits" datasource="#ds#">
		SELECT
		SECURITYID,
		MASTERNAMEID,
		SEC,
		VMOD,
		TIMEDATE,
		ACT,
		VARURL,
		VARFORM,
		VURL,
		SITEID
		FROM LASTVISITS
		WHERE SECURITYID=<cfqueryparam value="#securityid#">
		<cfif siteid neq 0>
		AND SITEID=<cfqueryparam value="#siteid#">
		</cfif>
		<cfif nameid neq 0>
		AND MASTERNAMEID=<cfqueryparam value="#nameid#">
		</cfif>
		<cfif sec neq 0>
		AND SEC=<cfqueryparam value="#sec#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif module neq 0>
		AND MOD=<cfqueryparam value="#module#" cfsqltype="cf_sql_varchar">
		</cfif>
		ORDER BY TIMEDATE DESC
		</cfquery>
		<cfreturn thisUsersVisits>
	</cffunction>
	
	<cffunction name="getRecentChanges" access="public" returnType="query" hint="I get the recent changes for a specific DSN. I return a record set: SECURITYID,
				MASTERNAMEID, SEC, VMOD, TIMEDATE, ACT, VARURL, VARFORM, VURL, SITEID">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfquery name="recentChanges" datasource="#arguments.ds#">
			SELECT TOP 12
				SECURITYID,
				MASTERNAMEID,
				SEC,
				VMOD,
				TIMEDATE,
				ACT,
				VARURL,
				VARFORM,
				VURL,
				SITEID
			FROM LASTVISITS
			WHERE VARFORM NOT LIKE ''
			AND SEC <><cfqueryparam value="dashboard">
			AND DATALENGTH(VARFORM)<4000
			ORDER BY TIMEDATE DESC
		</cfquery>
		<cfreturn recentChanges>
	</cffunction>

	<cffunction name="updateMasterLastSiteid" access="public" returntype="void" hint="I update the last siteid choosen by the nameid passed to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="nameid" type="string" required="true" hint="I am the nameid for the local user">
		<cfargument name="siteid" type="string" required="true" hint="I am the siteid you want data on">
		<cfset var updateLastSiteid=0>
		<cfquery name="updateLastSiteid" datasource="#ds#">
		UPDATE NAME
		SET LASTSITEID = <cfqueryparam value="#siteid#">
		WHERE NAMEID = <cfqueryparam value="#nameid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="createReferalTables" access="public" returntype="void" hint="I add the referal table to database">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource you want to create the table on">
		<cfset var createtables=0>
		<cfif not tblCheck.tableExists('#arguments.ds#', 'REFERAL')>
		<cfquery name="createtables" datasource="#arguments.ds#">
		CREATE TABLE REFERAL
		(
			REFERALID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			CFID CHAR(64) NOT NULL,
			NAMEID BIGINT,
			USER_AGENT VARCHAR(128) NOT NULL,
			REFERER VARCHAR(128) NOT NULL,
			VISITTIME VARCHAR(16) NOT NULL
		);
		</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="addReferal" access="public" returntype="string" hint="I add the initial referal data.">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource you want to add this referal to">
		<cfset var addMyReferal=0>
		
		<cfquery name="addMyReferal" datasource="#arguments.ds#">
		INSERT INTO REFERAL
		(CFID,
		<cfif isDefined('client.nameid')>NAMEID,</cfif>
		USER_AGENT,
		REFERER,
		VISITTIME)
		VALUES
		(<cfqueryparam value="#client.CFID#">,
		<cfif isDefined('client.nameid')><cfqueryparam value="#client.nameid#">,</cfif>
		<cfqueryparam value="#CGI.HTTP_USER_AGENT#">
		<cfqueryparam value="#CGI.HTTP_REFERER#">,
		<cfqueryparam value="#timedate#">)
		SELECT @@IDENTITY AS REFERALID
		</cfquery>
	<cfreturn addMyReferal.referalid>
	</cffunction>
	
	<cffunction name="updateReferal" access="public" returntype="void" hint="I update the referals with the proper nameid">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource you want to use to update this referal">
		<cfargument name="nameid" type="string" required="true" hint="the nameid of the person you want to update">
		<cfargument name="mycfid" type="string" required="true" hint="the cfid of the person you want to update">
		<cfset var updateMyReferal=0>
		
		<cfquery name="updateReferal" datasource="#arguments.ds#">
		UPDATE REFERAL
		SET NAMEID = <cfqueryparam value="#arguments.nameid#">
		WHERE CFID = <cfqueryparam value="#arguments.mycfid#">
		</cfquery>
	</cffunction>
	
</cfcomponent>