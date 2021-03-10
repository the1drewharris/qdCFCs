<cfcomponent hint="I handle all of the interaction with the links table, add, update, delete">
	<cfobject component="timeDateConversion" name="mytime">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="buildTable" hint="I build the links table" access="public" returntype="void" output="false">
		<cfargument name="ds" required="true" type="string" hint="datasource for the links">
		<cfset var createLinksTable=0>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'LINKS')>
		<cfquery name="createLinksTable" datasource="#arguments.ds#">
		CREATE TABLE LINKS
			(
				LINKID INT NOT NULL IDENTITY(1,1),
				NAME VARCHAR(512) NOT NULL,
				HREF VARCHAR(128) NOT NULL,
				TARGET VARCHAR(32),
				TITLE VARCHAR(1024)
			);
		</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="getLinks" access="public" returntype="query" output="false" hint="I get the links you request from me and return a recordset: linkid, name, href, target, title">
		<cfargument name="ds" required="true" type="string" hint="datasource for the links">
		<cfargument name="criteria" required="false" type="string" default="0" hint="the criteria you want to do a fuzzy search on, if passed in I will search each field(NAME, HREF, TITLE) for a partial match">
		<cfargument name="linkid" required="false" type="string" default="0" hint="the id of the link you want">
		<cfargument name="idexcludelist" required="false" type="string" default="0" hint="a list of linkids that you want to exclude">
		<cfargument name="excludecriteria" required="false" type="string" default="0" hint="a word or phrase that you want to exclude in a NOT LIKE where clause">
		<cfset var getMyLinks=0>
		<cfquery name="getMyLinks" datasource="#arguments.ds#">
		SELECT
			LINKID,
			NAME,
			HREF,
			TARGET,
			TITLE
		FROM LINKS
		WHERE 1=1
		<cfif arguments.linkid neq 0>
			AND LINKID = <cfqueryparam value="#arguments.linkid#">
		</cfif>
		<cfif arguments.criteria neq 0>
			AND (NAME LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
			OR HREF LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
			OR TITLE LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">)
		</cfif>
		<cfif arguments.excludecriteria neq 0>
			AND (NAME NOT LIKE <CFQUERYPARAM VALUE="%#arguments.excludecriteria#%">
			OR HREF NOT LIKE <CFQUERYPARAM VALUE="%#arguments.excludecriteria#%">
			OR TITLE NOT LIKE <CFQUERYPARAM VALUE="%#arguments.excludecriteria#%">)
		</cfif>
		<cfif arguments.idexcludelist neq 0>
			AND LINKID NOT IN (<cfqueryparam list="true" value="#arguments.idexcludelist#">)
		</cfif>
		ORDER BY LINKID DESC
		</cfquery>
		<cfreturn getMyLinks>
	</cffunction>
	
	<cffunction name="addLink" access="public" returntype="string" output="false" hint="I add a link to the link table, and I can add a duplicate, but the ID will always be unique, I return the ID of the link I added">
		<cfargument name="ds" required="true" type="string" hint="datasource for the links">
		<cfargument name="name" required="true" type="string" hint="name of the new link">
		<cfargument name="href" required="true" type="string" hint="full URL of where the link is going">
		<cfargument name="target" required="false" type="string" hint="a href target value for this link, I default to (_self)" default="_self">
		<cfargument name="title" required="false" type="string" hint="the title for this link, it will show up on a hover, just as a standard a href title would work" default="0">
		<cfset var addMyLink=0>
		<cfquery name="addMyLink" datasource="#arguments.ds#">
		INSERT INTO LINKS
		(NAME,
		HREF,
		TARGET
		<cfif arguments.title neq 0>, TITLE</cfif>)
		VALUES
		(<cfqueryparam value="#arguments.name#">,
		<cfqueryparam value="#arguments.href#">,
		<cfqueryparam value="#arguments.target#">
		<cfif arguments.title neq 0>, <cfqueryparam value="#arguments.title#"></cfif>)
		SELECT @@IDENTITY AS MYLINKID
		</cfquery>
		<cfreturn addMyLink.MYLINKID>
	</cffunction>
	
	<cffunction name="updateLink" access="public" returntype="void" output="false" hint="I update the link info for the linkid you pass to me">
		<cfargument name="ds" required="true" type="string" hint="datasource for the links">
		<cfargument name="linkid" required="true" type="string" hint="the id of the link you want to update">
		<cfargument name="name" required="true" type="string" hint="name of the new link">
		<cfargument name="href" required="true" type="string" hint="full URL of where the link is going">
		<cfargument name="target" required="false" type="string" hint="a href target value for this link, I default to (_self)" default="_self">
		<cfargument name="title" required="false" type="string" hint="the title for this link, it will show up on a hover, just as a standard a href title would work" default="0">
		<cfset var updateMyLink=0>
		<cfquery name="updateMyLink" datasource="#arguments.ds#">
		UPDATE LINKS
		SET NAME = <cfqueryparam value="#arguments.name#">,
		HREF = <cfqueryparam value="#arguments.href#">,
		TARGET = <cfqueryparam value="#arguments.target#">,
		<cfif arguments.title neq 0>TITLE = <cfqueryparam value="#arguments.title#"></cfif>
		WHERE LINKID = <cfqueryparam value="#arguments.linkid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteLink" access="public" returntype="void" output="false" hint="I delete the link for the linkid you pass to me">
		<cfargument name="ds" required="true" type="string" hint="datasource for the links">
		<cfargument name="linkid" required="true" type="string" hint="the id of the link you want to update">
		<cfset var deleteMyLink=0>
		<cfquery name="deleteMyLink" datasource="#arguments.ds#">
		DELETE FROM LINKS
		WHERE LINKID = <cfqueryparam value="#arguments.linkid#">
		</cfquery>
	</cffunction>
	
</cfcomponent>