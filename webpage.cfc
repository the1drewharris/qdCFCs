<cfcomponent displayName="webpage" hint="webpages">
	<cfinclude template="CFCRemoteDocumenter.cfm">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions" name="txtConvert">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<!--- done, not tested --->
	<cffunction name="init" access="public" returntype="webpage" hint="I run createBlogTables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke component="webpage" method="createtables" argumentcollection="#arguments#">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="droptables" access="public" returntype="void" hint="I drop the webpage tables">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<cfset var dropWPTables=0>
		<cfquery name="dropWPTables" datasource="#ds#">
		DROP TABLE WPSTATUS;
		DROP TABLE WPVERSION;
		DROP TABLE WPPARENT;
		</cfquery>
	</cffunction>
	
	<cffunction name="createtables" access="public" returntype="void" hint="create webpage tables">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<cfargument name="statuslist" required="false" default="Published,Draft,Deactive,Shared">
		<cfset var createWPSTATUS = 0>
		<cfset var createWPVERSION = 0>
		<cfset var createWPPARENT = 0>
		<cfset var createUNIQUEWPID = 0>
		<cfset var addWPStatuses = 0>
		<cfset var CREATEWPTEMPLATE = 0>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'WPSTATUS')>
			<cfquery name="createWPSTATUS" datasource="#arguments.ds#">
				CREATE TABLE WPSTATUS
				(
					WPSTATUS VARCHAR(128) NOT NULL PRIMARY KEY
				);
			</cfquery>
		</cfif>
			
		<cfif not tblCheck.tableExists('#arguments.ds#', 'WPVERSION')>	
			<cfquery name="createWPVERSION" datasource="#arguments.ds#">
				CREATE TABLE WPVERSION
				(
					WPID BIGINT NOT NULL,
					NAME VARCHAR(128) NOT NULL,
					URLNAME VARCHAR(128) NOT NULL,
					WPCONTENT NTEXT NOT NULL,
					TITLE VARCHAR(1024),
					KEYWORDS VARCHAR(1024),
					DESCRIPTION VARCHAR(1024),
					WPSTATUS VARCHAR(128) NOT NULL,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16) NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL,
					IGNOREENDDATE BIT DEFAULT 0 NOT NULL
				);
				
				ALTER TABLE WPVERSION ADD CONSTRAINT WPVERSION_PK PRIMARY KEY(WPID,CREATEDON);
				ALTER TABLE WPVERSION ADD CONSTRAINT WPVERSION_WPSTATUS FOREIGN KEY(WPSTATUS) REFERENCES WPSTATUS(WPSTATUS);
			</cfquery>	
		</cfif>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'WPPARENT')>
			<cfquery name="createWPPARENT" datasource="#arguments.ds#">
				CREATE TABLE WPPARENT
				(
					WPID BIGINT NOT NULL,
					PID BIGINT NOT NULL
				);
			</cfquery>
		</cfif>
			
		<cfloop list="#arguments.statuslist#" index="i">	
			<cfinvoke component="webpage" method="getWPStatusList" webdsn="#arguments.ds#" myStatus="#i#" returnvariable="myStatusList">
			<cfif myStatusList.recordcount eq 0>
			<cfquery name="addWPStatuses" datasource="#arguments.ds#">
				INSERT INTO WPSTATUS
				(WPSTATUS)
				VALUES
				(<cfqueryparam value="#i#">)
			</cfquery>
			</cfif>
		</cfloop>
		
		<cfif not tblCheck.viewExists('#arguments.ds#', 'UNIQUEWPID')>
			<cfquery name="createUNIQUEWPID" datasource="#arguments.ds#">
			CREATE VIEW UNIQUEWPID AS
				SELECT WPID, MAX(CREATEDON) AS CREATEDON
				FROM WPVERSION
				GROUP BY WPID;
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'WPTEMPLATE')>
			<cfquery name="CREATEWPTEMPLATE" datasource="#arguments.ds#">
			CREATE TABLE WPTEMPLATE
			(
				WPTEMPLATEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				NAME VARCHAR(256) NOT NULL,
				DESCRIPTION VARCHAR(1024),
				TEMPLATE NTEXT NOT NULL,
				IMAGEPATH VARCHAR(256),
				STATUS VARCHAR(128) NOT NULL DEFAULT 'Published'
			);
			</cfquery>
		</cfif>
	
	</cffunction>
	
	<cffunction name="getPages" access="public" returntype="query" hint="I get web pages based on parameters passed, I return a recordset (WPID, NAME,URLNAME,WPCONTENT,TITLE,KEYWORDS,DESCRIPTION,WPSTATUS,STARTDATE,ENDDATE,CREATEDON,AUTHORID,IGNOREENDDATE,PID,FIRSTNAME,LASTNAME)">
		<cfargument name="webdsn" required="true" type="string" hint="datasource">
		<cfargument name="urlname" required="false" type="string" hint="name of the page" default="0">
		<cfargument name="status" required="false" type="string" hint="status of the webpage">
		<cfargument name="createdon" required="false" type="String" hint="timestamp when the page was created" default="0">
		<cfargument name="authorid" required="false" type="String" hint="Nameid of the author">
		<cfargument name="parentid" required="false" type="string" default="0" hint="Parent id">
		<cfargument name="exclude" required="false" type="string" default="0" hint="if the pages contain this string exclude them">
		<cfset var pages=0>

		<cfquery name="pages" datasource="#webdsn#">
			SELECT
				WPVERSION.WPID,
				WPVERSION.NAME,
				WPVERSION.URLNAME,
				WPVERSION.WPCONTENT,
				WPVERSION.TITLE,
				WPVERSION.KEYWORDS,
				WPVERSION.DESCRIPTION,
				WPVERSION.WPSTATUS,
				WPVERSION.STARTDATE,
				WPVERSION.ENDDATE,
				WPVERSION.AUTHORID,
				WPVERSION.IGNOREENDDATE,
				WPVERSION.CREATEDON,
				WPPARENT.PID,
				SITESECURITY.FIRSTNAME,
				SITESECURITY.LASTNAME
			FROM WPVERSION 
				LEFT OUTER JOIN WPPARENT ON WPVERSION.WPID=WPPARENT.WPID
				LEFT OUTER JOIN SITESECURITY ON WPVERSION.AUTHORID=SITESECURITY.SECURITYID
			WHERE CREATEDON IN (SELECT CREATEDON FROM UNIQUEWPID WHERE WPID=WPVERSION.WPID)
			<cfif arguments.urlname NEQ "0">
			AND URLNAME = <cfqueryparam value="#arguments.urlname#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isdefined('arguments.status')>
			AND WPVERSION.WPSTATUS IN (<cfqueryparam value="#status#">)
			</cfif>
			<cfif arguments.createdon NEQ 0>
			AND WPVERSION.CREATEDON=<cfqueryparam value="#arguments.createdon#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isdefined('authorid')>
			AND WPVERSION.AUTHORID=<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.parentid NEQ 0>
			AND WPPARENT.PID=<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.exclude neq 0>
			AND WPVERSION.NAME NOT LIKE <cfqueryparam value="%#arguments.exclude#%">
			</cfif>
			ORDER BY WPVERSION.CREATEDON DESC
		</cfquery>
		<cfreturn pages>
	</cffunction>
	
	<cffunction name="addTemplate" access="public" returntype="string" hint="I add the template you pass to me">
		<cfargument name="webdsn" type="string" required="true" hint="datasource">
		<cfargument name="name" type="string" required="true" hint="the name of this template">
		<cfargument name="template" type="string" required="true" hint="the html code for this web page template">
		<cfargument name="status" type="string" required="false" default="Published" hint="I am the status for the template you are adding">
		<cfargument name="imagepath" type="string" required="false" default="0" hint="I am the imagename of the thumb for this template">
		<cfargument name="description" type="string" required="false" default="no description given" hint="I am the description of the template you are adding">
		<cfset var addMyTemplate = 0>
		<cfquery name="addMyTemplate" datasource="#arguments.webdsn#">
		INSERT INTO WPTEMPLATE
		(
			NAME,
			TEMPLATE,
			STATUS,
			IMAGEPATH,
			DESCRIPTION
		)
		VALUES
		(
			<cfqueryparam value="#arguments.name#">,
			<cfqueryparam value="#arguments.template#">,
			<cfqueryparam value="#arguments.status#">,
			<cfqueryparam value="#arguments.imagepath#">,
			<cfqueryparam value="#arguments.description#">
		)
			SELECT @@IDENTITY AS TEMPLATEID
		</cfquery>
	<cfreturn addMyTemplate.templateid>
	</cffunction>
	
	<cffunction name="updateTemplate" access="public" returntype="void" hint="I update the template you pass to me">
		<cfargument name="webdsn" type="string" required="true" hint="datasource">
		<cfargument name="templateid" type="string" required="true" hint="the id of the template you want to update">
		<cfargument name="name" type="string" required="true" hint="the name of this template">
		<cfargument name="imagepath" type="string" required="false" default="0" hint="path of the image for the wp template">
		<cfargument name="template" type="string" required="false" default="0"  hint="the html code for this web page template">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the textual description of this template">
		<cfargument name="status" type="string" required="false" default="0" hint="I am the status for the template you are updating">
		<cfset var updateMyTemplate = 0>
		<cfquery name="updateMyTemplate" datasource="#arguments.webdsn#">
		UPDATE WPTEMPLATE
			SET NAME = <cfqueryparam value="#arguments.name#">
			<cfif arguments.template neq 0>, TEMPLATE = <cfqueryparam value="#arguments.template#"></cfif>
			<cfif arguments.description neq 0>, DESCRIPTION = <cfqueryparam value="#arguments.description#"></cfif>
			<cfif arguments.imagepath neq 0>, IMAGEPATH = <cfqueryparam value="#arguments.imagepath#"></cfif>
			<cfif arguments.status neq 0>, STATUS = <cfqueryparam value="#arguments.status#"></cfif>
		WHERE WPTEMPLATEID = <cfqueryparam value="#arguments.templateid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteTemplate" access="public" returntype="void" hint="I delete the template you pass to me">
		<cfargument name="webdsn" type="string" required="true" hint="datasource">
		<cfargument name="templateid" type="string" required="true" hint="the id of the template you want to update">
		<cfset var deleteMyTemplate = 0>
		<cfquery name="deleteMyTemplate" datasource="#arguments.webdsn#">
		DELETE WPTEMPLATE
		WHERE WPTEMPLATEID = <cfqueryparam value="#arguments.templateid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="getTemplate" access="public" returntype="query" hint="I get the web page templates you are asking for, I return a recordset (WPTEMPLATEID, NAME, TEMPLATE, STATUS, DESCRIPTION, IMAGEPATH)">
		<cfargument name="webdsn" type="string" required="true" hint="datasource">
		<cfargument name="name" type="string" required="false" default="0" hint="the name of this template">
		<cfargument name="templateid" type="string" required="false" default="0" hint="the id of the specific web page template you are looking for">
		<cfargument name="status" type="string" required="false" default="0" hint="I am the status for the templates you are looking form">
		<cfargument name="criteria" type="string" required="false" default="0" hint="the fuzzy search criteria you are searching for, will search in both name and the actual template html code">
		<cfset var getMyTemplate = 0>
		<cfquery name="getMyTemplate" datasource="#arguments.webdsn#">
		SELECT
			WPTEMPLATEID,
			NAME,
			TEMPLATE,
			STATUS,
			DESCRIPTION,
			IMAGEPATH
		FROM WPTEMPLATE
		WHERE 1=1
		<cfif arguments.name neq 0>
		AND NAME = <cfqueryparam value="#arguments.name#">
		</cfif>
		<cfif arguments.status neq 0>
		AND STATUS = <cfqueryparam value="#arguments.status#">
		</cfif>
		<cfif arguments.templateid neq 0>
		AND WPTEMPLATEID = <cfqueryparam value="#arguments.templateid#">
		</cfif>
		<cfif arguments.criteria neq 0>
		AND (NAME LIKE <cfqueryparam value="%#arguments.criteria#%">
		OR TEMPLATE LIKE <cfqueryparam value="%#arguments.criteria#%">)
		</cfif>
		</cfquery>
	<cfreturn getMyTemplate>
	</cffunction>
	
	<cffunction name="updateTemplateStatus" access="public" returntype="void" hint="I update the status of the template">
		<cfargument name="webdsn" type="string" required="true" hint="datasource">
		<cfargument name="templateid" type="string" required="true" hint="the id of this template">
		<cfargument name="status" type="string" required="true" hint="I am the status for the template you are updating">
		<cfset var updateMyTempStatus = 0>
		<cfquery name="updateMyTempStatus" datasource="#arguments.webdsn#">
		UPDATE WPTEMPLATE
		SET STATUS = <cfqueryparam value="#arguments.status#">
		WHERE WPTEMPLATEID = <cfqueryparam value="#arguments.templateid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="addPage" access="public" returntype="numeric" output="false" hint="add a webpage, I return the id of the page added"> 
	    <cfargument name="webdsn" required="true" type="string" hint="datasource">
	    <cfargument name="name" required="true" type="string" hint="name of the webpage">
	    <cfargument name="wpcontent" required="true" type="string" hint="content of the webpage">
	    <cfargument name="wpstatus" required="true" type="string" hint="status of the webpage">
	    <cfargument name="startdate" required="true" type="string" hint="date when the page should be active">
	    <cfargument name="enddate" required="true" type="string" hint="date when the page should be deactivated">
	    <cfargument name="authorid" required="true" type="string" hint="Nameid of the person who created the page">
	    <cfargument name="ignoreenddate" required="true" type="string" hint="1 if end date should be ignored">
	    <cfargument name="title" required="false" type="string" hint="title of the webpage">
	    <cfargument name="keywords" required="false" type="string" hint="keywords">
	    <cfargument name="description" required="false" type="string" hint="description of the webpage">
   	    <cfargument name="urlname" required="false" type="string" hint="name of the url">
		<cfargument name="wpid" required="false" type="numeric" hint="I am the id of the page you want to create a new version of">
   	    <cfargument name="pid" required="false" type="numeric" hint="I am the id of the parent event" default="0">
		<cfset var selectMaxID=0>
		<cfset var addpage=0>
		<cfset var checkParent=0>
		<cfset var removeOldParent=0>
		<cfset var addParent=0>
		<cfset var removeParent=0>
		<cfif NOT isDefined('arguments.urlname')>
	   	    <cfinvoke component="textConversions" method="givenewname" name="#arguments.name#" returnVariable="arguments.urlname">
   	    </cfif>
	    <cfif not isDefined('arguments.wpid')>
	    	<cfparam name="wpid" default="1">
		    <cfquery name="selectMaxID" datasource="#arguments.webdsn#" maxrows="1">
		    SELECT MAX(WPID) AS MAXID
		    FROM WPVERSION
		    </cfquery>
		    <cfif selectMaxID.recordcount EQ 1>
		    	<cfif selectMaxID.MAXID GTE 1>
				    <cfset wpid=selectMaxID.MAXID>
				    <cfset wpid=wpid + 1>
			    </cfif>
		    <cfelse>
		    	<cfset wpid=1>
		    </cfif>
	    </cfif>
	    <cfquery name="addpage" datasource="#arguments.webdsn#">
	        INSERT INTO WPVERSION
	        (WPID,
	        NAME,
	        URLNAME,
	        WPCONTENT,
	        WPSTATUS,
	        STARTDATE,
	        ENDDATE,
	        CREATEDON,
	        AUTHORID,
	        IGNOREENDDATE
	        <cfif isDefined('title')>
	        ,TITLE
	        </cfif>
	        <cfif isDefined('keywords')>
	        ,KEYWORDS
	        </cfif>
	        <cfif isDefined('description')>
	        ,DESCRIPTION
	        </cfif>)
	        VALUES
	        (
	            <cfqueryparam value="#wpid#" cfsqltype="cf_sql_bigint">,
	            <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.urlname#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.wpcontent#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.wpstatus#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#mytime.createTimeDate()#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.ignoreenddate#" cfsqltype="cf_sql_varchar">
	            <cfif isDefined('arguments.title')>
	            ,<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">
	            </cfif>
	            <cfif isDefined('arguments.keywords')>
	            ,<cfqueryparam value="#arguments.keywords#" cfsqltype="cf_sql_varchar">
	            </cfif>
	            <cfif isDefined('description')>
	            ,<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">
	            </cfif>
	        )
		</cfquery>
		
		<cfif pid neq 0>
			<cfquery name="checkParent" datasource="#arguments.webdsn#">
			SELECT WPID
			FROM WPVERSION
			WHERE WPID='#PID#'
			</cfquery>

			<cfif checkParent.recordcount eq 0>
				<cfset wpid="the pid you passed in does not exist as a web page, thus your page can not be added">
			<cfelse>
				<cfquery name="removeOldParent" datasource="#arguments.webdsn#">
				DELETE FROM WPPARENT WHERE WPID = <cfqueryparam  value="#wpid#" cfsqltype="cf_sql_bigint">
				</cfquery>
				<cfquery name="addParent" datasource="#webdsn#">
					INSERT INTO WPPARENT
					(WPID, PID)
					VALUES
					('#WPID#', '#PID#')
				</cfquery>
			</cfif>
		<cfelseif isDefined('wpid') AND pid EQ 0>
			<cfquery name="removeParent" datasource="#arguments.webdsn#">
				DELETE FROM WPPARENT WHERE WPID = <cfqueryparam value="#wpid#" cfsqltype="cf_sql_bigint">
			</cfquery>
		</cfif>
		<cfreturn wpid>
	</cffunction>

	<cffunction name="updatePage" access="public" returntype="void" output="false" hint="I update the  webpage">
		<cfargument name="webdsn" required="true" type="string" hint="datasource">
		<cfargument name="wpid" required="true" type="numeric" hint="id of the webpage">
	    <cfargument name="name" required="false" type="string" hint="name of the webpage">
	    <cfargument name="wpcontent" required="false" type="string" hint="content of the webpage">
	    <cfargument name="wpstatus" required="false" type="string" hint="status of the webpage">
	    <cfargument name="startdate" required="false" type="string" hint="date when the page should be active">
	    <cfargument name="enddate" required="false" type="string" hint="date when the page should be deactivated">
	    <cfargument name="authorid" required="false" type="string" hint="Nameid of the person who created the page">
	    <cfargument name="ignoreenddate" required="false" type="string" hint="1 if end date should be ignored">
	    <cfargument name="title" required="false" type="string" hint="title of the webpage">
	    <cfargument name="keywords" required="false" type="string" hint="keywords">
	    <cfargument name="description" required="false" type="string" hint="description of the webpage">
	    <cfargument name="urlname" required="false" default="0" type="string" hint="name of the url">
	    <cfset var updatepage=0>
   	    <cfif arguments.urlname EQ 0 AND isDefined('arguments.name')>
	   	    <cfinvoke component="textConversions" method="givenewname" name="#arguments.name#" returnVariable="urlname">
   	    </cfif>

	    <cfquery name="updatepage" datasource="#arguments.webdsn#">
	    	UPDATE WPVERSION
	    	SET
	    		WPID=<cfqueryparam value="#wpid#" cfsqltype="cf_sql_bigint">
		    <cfif isDefined('name')>
		    	,NAME=<cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">
		    </cfif>
	    	<cfif isDefined('urlname')>
		    	,URLNAME=<cfqueryparam value="#urlname#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('wpcontent')>
		    	,WPCONTENT=<cfqueryparam value="#wpcontent#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('wpstatus')>
		    	,WPSTATUS=<cfqueryparam value="#wpstatus#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('startdate')>
		    	,STARTDATE=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('enddate')>
		    	,ENDDATE=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('authorid')>
		    	,AUTHORID=<cfqueryparam value="#authorid#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('ignoreenddate')>
		    	,IGNOREENDDATE=<cfqueryparam value="#ignoreenddate#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('title')>
		    	,TITLE=<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('keywords')>
		    	,KEYWORDS=<cfqueryparam value="#keywords#" cfsqltype="cf_sql_varchar">
	    	</cfif>
	    	<cfif isDefined('description')>
		    	,DESCRIPTION=<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">
	    	</cfif>
	    	WHERE WPID=<cfqueryparam value="#wpid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	    
	</cffunction>
	
	<cffunction name="deletePage" access="public" returntype="void" output="false" hint="I delete a webpage">
		<cfargument name="webdsn" required="true" type="string" hint="datasource">
		<cfargument name="wpid" required="true" type="string" hint="id of the webpage">
		<cfset var deletepage=0>
		<cfquery name="deletepage" datasource="#webdsn#">
			DELETE FROM WPVERSION
			WHERE WPID=<cfqueryparam value="#wpid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="getPageInfo" hint="I get all the detailed information for a page passed to me, I return a recordset (WPID, NAME,URLNAME,WPCONTENT,TITLE,KEYWORDS,DESCRIPTION,WPSTATUS,STARTDATE,ENDDATE,CREATEDON,AUTHORID,IGNOREENDDATE,PID,FIRSTNAME,LASTNAME)" output="false" returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfargument name="wpid" default="0" required="false" hint="I am the id for the web page that you want info on">
		<cfargument name="version" default="0" required="false" hint="I am the version of the event you are looking for">
		<cfargument name="urlname" default="0" required="false" hint="I am the urlname of the page you are looking for">
		<cfargument name="name" default="0" required="false" hint="I am the name of the page you are looking for">
		<cfset var pageInfo=0>
		<cfquery name="pageInfo" datasource="#arguments.webdsn#">
		SELECT TOP 1
			WPVERSION.WPID,
			WPVERSION.NAME,
			WPVERSION.URLNAME,
			WPVERSION.WPCONTENT,
			WPVERSION.TITLE,
			WPVERSION.KEYWORDS,
			WPVERSION.DESCRIPTION,
			WPVERSION.WPSTATUS,
			WPVERSION.STARTDATE,
			WPVERSION.ENDDATE,
			WPVERSION.CREATEDON,
			WPVERSION.AUTHORID,
			WPVERSION.IGNOREENDDATE,
			WPPARENT.PID
		FROM
			WPVERSION LEFT OUTER JOIN WPPARENT
			ON WPVERSION.WPID=WPPARENT.WPID
		WHERE 
			1=1
			<cfif arguments.wpid neq 0>
			AND WPVERSION.WPID=<cfqueryparam value="#arguments.wpid#">
			</cfif>
			<cfif arguments.urlname neq 0>
			AND WPVERSION.URLNAME=<cfqueryparam value="#arguments.urlname#">
			</cfif>
			<cfif arguments.name neq 0>
			AND WPVERSION.NAME=<cfqueryparam value="#arguments.name#">
			</cfif>
			<cfif arguments.version neq 0>
			AND WPVERSION.CREATEDON=<cfqueryparam value="#version#">
			<cfelse>
			ORDER BY WPVERSION.CREATEDON DESC
			</cfif>
		</cfquery>
		<cfreturn pageInfo>
	</cffunction>
	
	<cffunction name="getPageVersions" hint="I get all the versions of a page passed to me, I return a recordset (WPID, NAME,URLNAME,WPCONTENT,TITLE,KEYWORDS,DESCRIPTION,WPSTATUS,STARTDATE,ENDDATE,CREATEDON,AUTHORID,IGNOREENDDATE,PID,FIRSTNAME,LASTNAME)" output="false" returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfargument name="wpid" required="true" hint="I am the id for the web page that you want info on">
		<cfset var pageVersion=0>
		<cfquery name="pageVersions" datasource="#webdsn#">
		SELECT
			WPVERSION.WPID,
			WPVERSION.NAME,
			WPVERSION.URLNAME,
			WPVERSION.WPCONTENT,
			WPVERSION.TITLE,
			WPVERSION.KEYWORDS,
			WPVERSION.DESCRIPTION,
			WPVERSION.WPSTATUS,
			WPVERSION.STARTDATE,
			WPVERSION.ENDDATE,
			WPVERSION.CREATEDON,
			WPVERSION.AUTHORID,
			WPVERSION.IGNOREENDDATE,
			WPPARENT.PID
		FROM
			WPVERSION LEFT OUTER JOIN WPPARENT
			ON WPVERSION.WPID=WPPARENT.WPID
		WHERE WPVERSION.WPID=<cfqueryparam value="#wpid#">
		ORDER BY WPVERSION.CREATEDON DESC
		</cfquery>
		<cfreturn pageVersions>
	</cffunction>
	
	<cffunction name="publishHTMLPage" hint="I publish the html page." output="false" returntype="void" access="public">
		<cfargument name="weburl" required="true" type="string" hint="I am the url for the site">
		<cfargument name="basepath" required="false" default="/home/drew/domains/" hint="I am the base path to the domains folder on the server">
		<cfargument name="filename" required="true" hint="I am the filename of the page you want to publish">
		<cfargument name="wpcontent" required="true" type="string" hint="I am the html content for the page you want to publish">
		<cfset var content_html=0>
		<cfsavecontent variable="content_html">#wpcontent#</cfsavecontent>
		<!--- Check to see if the Directory does not exist --->
		<cfif not DirectoryExists(#newDirectory#)>
			<!--- If not then create the directory --->
			<cfdirectory action = "create" directory = "#newDirectory#" >
		</cfif>
		<cffile action="write" mode="775" addnewline="no" file="#newdirectory#/#filename#.html" output="#content_html#" nameconflict="overwrite">
	</cffunction>
	
	<cffunction name="getPageParent" hint="I get the parentid for a page passed to me, I return a recordset (WPID,PID)" output="false" returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfargument name="wpid" required="true" hint="I am the id for the web page that you want info on">
		<cfset var getParent=0>
		<cfquery name="getParent" datasource="#webdsn#">
		SELECT
			WPID,
			PID
		FROM
			WPPARENT
		WHERE
			WPID=<cfqueryparam value="#wpid#">
		</cfquery>
	<cfreturn getParent>
	</cffunction>
	
	<cffunction name="getBastards" hint="I get the ids of the pages that do not have parents (WPID)"  output="false" returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfset var bastards=0>
		<cfquery name="bastards" datasource="#webdsn#">
		SELECT
			WPVERSION.WPID
		FROM
			WPVERSION LEFT OUTER JOIN WPPARENT
			ON WPVERSION.WPID = WPPARENT.WPID
		WHERE
			WPPARENT.WPID IS NULL
		</cfquery>
	<cfreturn bastards>
	</cffunction>
	
	<cffunction name="getPageChildren" hint="I get the children for a page passed to me, I return a recordset (WPID,PID)"  output="false"returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfargument name="wpid" required="true" hint="I am the id for the web page that you want info on">
		<cfset var getChildren=0>
		<cfquery name="getChildren" datasource="#webdsn#">
		SELECT
			WPID,
			PID
		FROM
			WPPARENT
		WHERE
			PID = <cfqueryparam value="#wpid#">
		</cfquery>
	<cfreturn getChildren>
	</cffunction>

	<cffunction name="getWPStatusList"  hint="I get all the statuses for the web pages"  output="false" returntype="query" access="public">
		<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
		<cfargument name="myStatus" required="false" default="0">
		<cfset var statuslist=0>
		<cfquery name="statuslist" datasource="#webdsn#">
		SELECT
			WPSTATUS
		FROM
			WPSTATUS
		<cfif arguments.myStatus neq 0>
		WHERE WPSTATUS = <cfqueryparam value="#arguments.myStatus#">
		</cfif>
		ORDER BY WPSTATUS DESC
		</cfquery>
	<cfreturn statuslist>
	</cffunction>
	
	<cffunction name="writeSiteMapXML" access="public" returntype="void" output="false">
		<cfargument name="weburl" required="true" type="string" hint="I am the url for the site">
		<cfargument name="basepath" required="false" default="/home/drew/domains/" hint="I am the base path to the domains folder on the server">
		<cfargument name="siteid" required="true" default="0" type="string" hint="I am the id for the site you are creating an xml sitema for">
		<cfargument name="sitekeywords" required="false" default="0" type="string" hint="I am the keywords list for the site">
		<cfargument name="sitedescription" required="false" default="0" type="string" hint="I am the Search Engine description for the site">
		<cfargument name="sitename" required="false" default="0" type="string" hint="I am the name of the site">
		<cfargument name="sitetitle" required="false" default="0" type="string" hint="I am the title of the site">
		<cfargument name="sitephone" required="false" default="0" type="string" hint="I am the phone number of the site">
		<cfargument name="siteemailadmin" required="false" default="0" type="string" hint="I am the phone number of the site">
		<cfset var xmlSitemap=0>
		<cfset var eventname=0>
		<cfset var newDirectory=0>
		<cfset var webpages=0>
		<cfif arguments.siteemailadmin eq 0 or arguments.sitekeywords eq 0 or arguments.sitedescription eq 0 or arguments.sitename eq 0 or arguments.sitetitle eq 0 or arguments.sitephone eq 0>
			<cfinvoke component="site" method="getSiteInfo" siteid="#arguments.siteid#" returnvariable="thisSiteInfo">
			<cfif arguments.sitekeywords eq 0>
				<cfset arguments.sitekeywords = thisSiteInfo.sitekeywords>
			</cfif>
			<cfif arguments.sitedescription eq 0>
				<cfset arguments.sitedescription = thisSiteInfo.sitedescription>
			</cfif>
			<cfif arguments.sitename eq 0>
				<cfset arguments.sitename = thisSiteInfo.sitename>
			</cfif>
			<cfif arguments.sitetitle eq 0>
				<cfset arguments.sitetitle = thisSiteInfo.sitetitle>
			</cfif>
			<cfif arguments.sitephone eq 0>
				<cfset arguments.sitephone = thisSiteInfo.orgphone>
			</cfif>
			<cfif arguments.siteemailadmin eq 0>
				<cfset arguments.siteemailadmin = thisSiteInfo.COMMENTEMAIL>
			</cfif>
		</cfif>
		<!--- Check that the directory exists to avoid getting a Coldfusion error message. --->
		<cfif listlen(client.siteurl,'.') LT 3>
			<cfset newDirectory = "#arguments.basepath##weburl#/public_html/xml">
		<cfelse>
			<cfset newDirectory="#arguments.basepath##listgetAt(arguments.weburl,2,'.')#.#listgetAt(arguments.weburl,3,'.')#/public_html/#listfirst(arguments.weburl,'.')#/xml">
		</cfif>
		<!--- Check to see if the Directory does not exist --->
		<cfif not DirectoryExists(#newDirectory#)>
			<!--- If not then create the directory --->
			<cfdirectory action = "create" directory = "#newDirectory#">
		</cfif>
		<cfsavecontent variable="xmlSitemap"><cf_qrytoxml treename="myxmlsitemap"><cfoutput><cf_xmlelement elementname="site" link="#XMLFormat(arguments.weburl)#" name="#XMLFormat(arguments.sitename)#" id="#arguments.siteid#"	value="#arguments.siteid#" parent="0"  />
		<cf_xmlelement elementname="sitekeywords" id="999" parent="#arguments.siteid#" value="999" text="#XMLFormat(sitekeywords)#" />
		<cf_xmlelement elementname="sitetitle" id="998" parent="#arguments.siteid#" value="998" text="#XMLFormat(arguments.SITETITLE)#" />
		<cf_xmlelement elementname="sitedescription" id="997" parent="#arguments.siteid#" value="997" text="#XMLFormat(arguments.sitedescription)#" />
		<cf_xmlelement elementname="sitephone" id="996" parent="#arguments.siteid#" value="996" text="#XMLFormat(arguments.sitephone)# " />
		<cf_xmlelement elementname="siteemailadmin" id="995" parent="#arguments.siteid#" value="995" text="#XMLFormat(arguments.siteemailadmin)# " />
		</cfoutput>
		<cfinvoke component="webpage" method="getPages" returnvariable="webpages" webdsn="#weburl#" exclude="code.">
			<cfoutput query="webpages" group="wpid">
			<cfset name = "#txtConvert.StripAllBut(name, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ (),.")#">
				<cfset title = "#txtConvert.StripAllBut(title, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ (),.")#">
				<cfset keywords = "#txtConvert.StripAllBut(keywords, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ (),.")#">
				<cfset description = "#txtConvert.StripAllBut(description, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ (),.")#">
			<cfif pid eq "0" or pid eq ""><cfset parentid="#siteid#"><cfelse><cfset parentid="#pid#"></cfif>
			<cf_xmlelement elementname="web_page" 
							value="#wpid#" 
							eventcategory="web_page" 
							name="#XMLFormat(name)#" 
							title="#XMLFormat(TITLE)#" 
							id="#wpid#" 
							parent="#parentid#" 
							lastupdated="#CREATEDON#"  
							keywords="#XMLFormat(KEYWORDS)#" 
							description="#XMLFormat(description)#" 
							pagename="#XMLFormat(urlname)#"  
							target="_self" 
							text="#XMLFormat(wpcontent)#" 
							starttime="#STARTDATE#" 
							endtime="#ENDDATE#" />
			</cfoutput>
			<cfoutput><cf_xmlelement parent="#siteid#" 
							elementname="web_page" 
								eventcategory="Web Page" 
								name="Site Map" 
								title="Site Map" 
								value="2999" 
								id="2999" 
								pagename="sitemap" 
								description="Our site map for getting around in the site" 
								lastupdated="#mytime.createTimeDate()#" 
								target="_self" 
								keywords="sitemap,navigation,map,links" 
								link="sitemap.html" />
			</cfoutput>
		</cf_qrytoxml>
	</cfsavecontent>
	<cfoutput><cffile action="write" mode="775" addnewline="no" file="#newDirectory#/cfc_sitemap.xml" output="#xmlSitemap#"></cfoutput>

	</cffunction>
	<!---
	<cffunction name="writeGoogleSiteMapXML" access="public" returntype="void" output="false">
		<cfargument name="weburl" required="true" type="string" hint="I am the url for the site">
		<cfargument name="basepath" required="false" default="/home/drew/domains/" hint="I am the base path to the domains folder on the server">
		<cfargument name="filename" required="true" hint="I am the filename of the page you want to publish">
		<cfargument name="name" required="true" type="string" hint="name of the webpage">
	    <cfargument name="urlname" required="true" type="string" hint="name of the url">
	    <cfargument name="wpcontent" required="true" type="string" hint="content of the webpage">
	    <cfargument name="wpstatus" required="true" type="string" hint="status of the webpage">
	    <cfargument name="startdate" required="true" type="string" hint="date when the page should be active">
	    <cfargument name="enddate" required="true" type="string" hint="date when the page should be deactivated">
	    <cfargument name="authorid" required="true" type="string" hint="Nameid of the person who created the page">
	    <cfargument name="ignoreenddate" required="true" type="string" hint="1 if end date should be ignored">
	    <cfargument name="title" required="false" type="string" hint="title of the webpage">
	    <cfargument name="keywords" required="false" type="string" hint="keywords">
	    <cfargument name="description" required="false" type="string" hint="description of the webpage">
		<!--- google sitemap xml --->
		<cfsavecontent variable="google_xml_sitemap"><?xml version="1.0" encoding="UTF-8"?>
		<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		<url>
		 <cfoutput><loc>http://#weburl#/</loc>
		  <lastmod>#googledate#</lastmod>
		  <changefreq>hourly</changefreq></cfoutput>
		</url>
		<cfoutput query="qryevents" group="eventid">
		   <url>
		      <loc>http://#weburl#/pages/#pagename#.html</loc>
		      <changefreq>weekly</changefreq>
			  <lastmod>#left(VERSIONID,4)#-#mid(VERSIONID,5,2)#-#mid(VERSIONID,7,2)#T#mid(VERSIONID,9,2)#:#mid(VERSIONID,11,2)#-06:00</lastmod>
		   </url>
		</cfoutput>
			<url>
		      <cfoutput><loc>http://#weburl#/pages/sitemap.html</loc>
		      <changefreq>hourly</changefreq>
			  <lastmod>#googledate#</lastmod></cfoutput>
		   </url>
		</urlset>
		</cfsavecontent>
		<cfoutput><cffile action="write" mode="775" addnewline="no" file="#weburl#/googlesitemap.xml" output="#google_xml_sitemap#"></cfoutput>
	</cffunction> --->
	
	<cffunction name="getOldPages" 
				hint="I get all of the old pages from a site, I return a query: EVENTID, EVENTNAME, PAGENAME, STATUS, VERSIONID, STARTTIME,ENDTIME, SEDESCRIPTION, KEYWORDS, TITLE, DESCRIPTION, PREDESSOREVENTID, PARENTEVENTID, FUSEACTIONID, PEERORDERNUMBER, IMAGEID, PERCENTCOMPLETE, CUSTOMCSS, PRINTCSS, SCREENCSS, NAVNUM,PLACEHOLDER,EVENTCATEGORY,EVENTCATEGORYID" 
				output="false" 
				returntype="query" 
				access="public">
		<cfargument name="dsn" required="true" type="string" hint="datasource to look for old pages">
		<cfargument name="parentid" required="false" type="string" hint="the parentid of the pages you are looking for" default="0">
		<cfargument name="category" required="false" type="string" hint="the category of content you are looking for" default="Web Page">
		<cfset var oldPages=0>
		<cfquery name="oldPages" datasource="#dsn#">
		SELECT
			EVENTVERSION.EVENTID, 
			EVENTVERSION.EVENTNAME, 
			EVENTVERSION.PAGENAME, 
			EVENTVERSION.STATUS, 
			EVENTVERSION.VERSIONID, 
			EVENTVERSION.STARTTIME,
			EVENTVERSION.ENDTIME, 
			EVENTVERSION.SEDESCRIPTION, 
			EVENTVERSION.KEYWORDS, 
			EVENTVERSION.TITLE, 
			EVENTVERSION.DESCRIPTION, 
			EVENTVERSION.PREDESSOREVENTID, 
			EVENTVERSION.PARENTEVENTID, 
			EVENTVERSION.FUSEACTIONID, 
			EVENTVERSION.PEERORDERNUMBER, 
			EVENTVERSION.IMAGEID, 
			EVENTVERSION.PERCENTCOMPLETE, 
			EVENTVERSION.CUSTOMCSS, 
			EVENTVERSION.PRINTCSS, 
			EVENTVERSION.SCREENCSS,
			EVENTVERSION.ALTLAYOUT,  
			EVENTVERSION.NAVNUM,
			EVENTVERSION.PLACEHOLDER,
			EVENTCATEGORY.EVENTCATEGORY,
			EVENTCATEGORY.EVENTCATEGORYID
		FROM         
			EVENT,
			EVENTVERSION, 	
			EVENTCATEGORY
		WHERE
			EVENTCATEGORY.EVENTCATEGORYID = EVENTVERSION.EVENTCATEGORYID
		    AND EVENTCATEGORY.EVENTCATEGORY LIKE '%#arguments.category#%'
			AND EVENTVERSION.STATUS <> 'Deleted'
			<cfif parentid neq 0>
			AND EVENTVERSION.PARENTEVENTID = '#parentid#'
			</cfif>
			AND (EVENTVERSION.VERSIONID =
			  (SELECT     MAX(VERSIONID)
				FROM          EVENTVERSION
				WHERE      EVENTID = EVENT.EVENTID
				AND EVENTVERSION.STATUS <> 'Deleted'))
		ORDER BY EVENTVERSION.PEERORDERNUMBER
		</cfquery>
		<cfreturn oldPages>
	</cffunction>
	
	<cffunction name="myXmlTemplates" access="public" returntype="xml">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<cfinvoke component="webpage" method="getTemplate" webdsn="#arguments.ds#" returnvariable="getMyTemplates">
		<cfoutput>
		<cfif getMyTemplates.recordcount gt 0>
		<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
		<Templates imagesBasePath="http://#arguments.ds#/">
		 <cfloop query="getMyTemplates">
		  <Template title="#name#" image="images/qdcms/#imagepath#">
		    <Description>#description#</Description>
		    <Html>
		      <![CDATA[
		        #template#
		      ]]>
		    </Html>
		  </Template>
		 </cfloop>
		</Templates></cfsavecontent>
	<cfelse>
		<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
<!--
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2009 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * This is the sample templates definitions file. It makes the "templates"
 * command completely customizable.
 *
 * See FCKConfig.TemplatesXmlPath in the configuration file.
-->
<Templates imagesBasePath="fck_template/images/">
	<Template title="Image on the left and Title" image="template1.gif">
		<Description>One main image on the left with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<img style="MARGIN-RIGHT: 10px" height="100" alt="" width="100" align="left"/>
				<h3>Type the title here</h3>
				Type the text here
			]]>
		</Html>
	</Template>
	<Template title="Image on the right and Title" image="template4.gif">
		<Description>One main image on the right with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<img style="MARGIN-LEFT: 10px" height="100" alt="" width="100" align="right"/>
				<h3>Type the title here</h3>
				Type the text here
			]]>
		</Html>
	</Template>
	<Template title="Two images on the left and Title" image="template6.gif">
		<Description>Two images on the left with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<div style="float:left">
				<img style="MARGIN-RIGHT: 10px;padding-bottom:10px" height="100" alt="" width="100" align="left"/>
				<div class="clear"></div>
				<img style="MARGIN-RIGHT: 10px;padding-top:10px" height="100" alt="" width="100" align="left"/>
				</div>
				<div style="float:right align=left">
				<h3>Type the title here</h3>
				Type the text here
				</div>
			]]>
		</Html>
	</Template>
	<Template title="Two images on the right and Title" image="template5.gif">
		<Description>Two images on the right with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<div style="float:right">
				<img style="MARGIN-RIGHT: 10px;" height="100" alt="" width="100" align="left"/>
				<div class="clear"></div>
				<img style="MARGIN-RIGHT: 10px;padding-top:10px" height="100" alt="" width="100" align="left"/>
				</div>
				<div style="float:left">
				<h3>Type the title here</h3>
				Type the text here
				</div>
			]]>
		</Html>
	</Template>
	<Template title="Image on the right and Title" image="template1.gif">
		<Description>One main image on the right with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<img style="MARGIN-RIGHT: 10px" height="100" alt="" width="100" align="right"/>
				<h3>Type the title here</h3>
				Type the text here
			]]>
		</Html>
	</Template>
	<!---
	<Template title="Strange Template" image="template2.gif">
		<Description>A template that defines two colums, each one with a title, and some text.</Description>
		<Html>
			<![CDATA[
				<table cellspacing="0" cellpadding="0" width="100%" border="0">
					<tbody>
						<tr>
							<td width="50%">
							<h3>Title 1</h3>
							</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td width="50%">
							<h3>Title 2</h3>
							</td>
						</tr>
						<tr>
							<td>Text 1</td>
							<td>&nbsp;</td>
							<td>Text 2</td>
						</tr>
					</tbody>
				</table>
				More text goes here.
			]]>
		</Html>
	</Template>
	<Template title="Text and Table" image="template3.gif">
		<Description>A title with some text and a table.</Description>
		<Html>
			<![CDATA[
				<table align="left" width="80%" border="0" cellspacing="0" cellpadding="0"><tr><td>
					<h3>Title goes here</h3>
					<p>
					<table style="FLOAT: right" cellspacing="0" cellpadding="0" width="150" border="1">
						<tbody>
							<tr>
								<td align="center" colspan="3"><strong>Table title</strong></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</tbody>
					</table>
					Type the text here</p>
				</td></tr></table>
			]]>
		</Html>
	</Template>
	--->
</Templates>
</cfsavecontent>
	</cfif>
	</cfoutput>
	<cfreturn myXml>
	</cffunction>
</cfcomponent>