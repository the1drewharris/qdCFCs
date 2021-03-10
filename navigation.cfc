<cfcomponent hint="navigation" displayName="navigation">
	<cfparam name="variables.ds" default="spiderwebmaster.net">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cffunction name="init" access="public" output="no" returnType="navigation">
		<cfargument name="ds" hint="Datasource">
		<cfset variables.ds = arguments.ds>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createNavigationTables">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<!--- 
			CREATE VIEW UNIQUENAVID AS
			SELECT NAVID, MAX(NAVVERID) AS NAVVERID
			FROM NAVVERSION
			GROUP BY NAVID;
		--->
		<cftransaction>
			<cfif not tblCheck.tableExists('#arguments.ds#', 'NAVVERSION')>
				<cfquery name="createnavversion" datasource="#arguments.ds#">
				CREATE TABLE NAVVERSION
				(	
					NAVID BIGINT NOT NULL,
					NAVVERID VARCHAR(16) NOT NULL,
					NAVNAME VARCHAR(128) NOT NULL,
					STATUS VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL
				);	
				ALTER TABLE NAVVERSION ADD CONSTRAINT NAVVERSION_PK PRIMARY KEY(NAVID,NAVVERID);
				</cfquery>
			</cfif>
			<!--- Checks to see if the table NAVITEMS exists, if it doesn't then create it --->
			<cfif not tblCheck.tableExists('#arguments.ds#', 'NAVITEMS')>
				<cfquery name="createnNAVITEMS" datasource="#arguments.ds#">
				CREATE TABLE NAVITEMS
				(	
					NAVID BIGINT NOT NULL,
					NAVVERID VARCHAR(16) NOT NULL,
					WPID BIGINT NOT NULL,
					NAVITEMID BIGINT NOT NULL,
					SORTORDER VARCHAR(4),
					LINKID BIGINT NOT NULL
				);	
				ALTER TABLE NAVITEMS ADD CONSTRAINT NAVITEMS_PK PRIMARY KEY(NAVITEMID);
				ALTER TABLE NAVITEMS ADD CONSTRAINT NAVITEMS_FK FOREIGN KEY(NAVID,NAVVERID) REFERENCES NAVVERSION(NAVID,NAVVERID);
				</cfquery>
			</cfif>
			<!--- Checks to see if the table NAVITEMPARENT exists, if it doesn't then create it --->
			<cfif not tblCheck.tableExists('#arguments.ds#', 'NAVITEMPARENT')>
				<cfquery name="createNAVITEMPARENT" datasource="#arguments.ds#">
				CREATE TABLE NAVITEMPARENT
				(
					NAVITEMID BIGINT NOT NULL,
					PARENTNAVID BIGINT NOT NULL
				);
				ALTER TABLE NAVITEMPARENT ADD CONSTRAINT NAVITEMPARENT_PK PRIMARY KEY(NAVITEMID,PARENTNAVID);
				</cfquery>
			</cfif>	
			
			<cfif not tblCheck.viewExists('#arguments.ds#', 'UNIQUENAVID')>
				<cfquery name="createUNIQUENAVID" datasource="#arguments.ds#">
				CREATE VIEW UNIQUENAVID AS
					SELECT NAVID, MAX(NAVVERID) AS NAVVERID
					FROM NAVVERSION
					GROUP BY NAVID;
				</cfquery>
			</cfif>		
		</cftransaction>
	</cffunction>
	
	<cffunction name="getNavItemName" access="public" returntype="string" hint="I get the name of navitem">
		<cfargument name="ds" required="true" type="string" hint="I am the name of the database">
		<cfargument name="navitemid" required="true" type="string" hint="I am the name of the navitem">
		<cfset var getNavitem=0>
		<cfset var get=0>
		<cfquery name="getNavitem" datasource="#arguments.ds#">
			SELECT 
				WPID,
				LINKID
			FROM NAVITEMS
			WHERE NAVITEMID=<cfqueryparam value="#arguments.navitemid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif getNavitem.recordcount NEQ 0>
			<cfif getNavitem.wpid NEQ 0>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT TOP 1 NAME FROM WPVERSION 
					WHERE WPID=<cfqueryparam value="#getNavitem.wpid#" cfsqltype="cf_sql_varchar">
					AND WPSTATUS='Published' 
					ORDER BY CREATEDON DESC
				</cfquery>
			<cfelse>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT NAME FROM LINKS WHERE LINKID=<cfqueryparam value="#getNavitem.wpid#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
			<cfif get.recordcount GT 0>
				<cfreturn get.NAME>
			</cfif>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="dropNavigationTables" access="public" returntype="void" hint="I drop the webpage tables">
		<cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
		<cfquery name="dropTables" datasource="#ds#">
			DROP TABLE NAVITEMPARENT;
			DROP TABLE NAVITEMS;
			DROP TABLE NAVVERSION;
		</cfquery>
	</cffunction>
	
	<cffunction name="modifyNavigationStatus" access="public" hint="I change the status of a Navigation">
		<cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
		<cfargument name="navid" required="true" type="string" hint="Navigation ID to modify status">
		<cfargument name="status" required="false" type="string" hint="Status to set" default="1">
		<cfquery name="navigationStatus" datasource="#arguments.ds#">
			UPDATE NAVVERSION 
			SET STATUS = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_bigint">
			WHERE NAVID = <cfqueryparam value="#arguments.navid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="addNavigation" access="public" returntype="array" output="false" hint="Add a Navigation, I return the ID of the navigation added as well as the Nav Version ID. They are on in an Array with var[1] = navid and var[2] = navversionid"> 
	    <cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
	    <cfargument name="name" required="true" type="string" hint="name of the navigation">
	    <cfargument name="authorid" required="true" type="string" hint="ID of the Author of the Navigation">
		<cfargument name="navid" required="false" type="string" hint="I am the id of the navigation you want to create a new version of" default="0">
		<cfargument name="status" required="false" type="string" hint="I am the status of the navigation." default="Publish">
	    <cfset var newID = "0">
	    <cfset var addNavVersion = "0">
	    <cfset var timeAndDate=application.objtimedateconversion.createTimeDate()>
	    <cfquery name="selectMaxID" datasource="#arguments.ds#" maxrows="1">
		    SELECT MAX(NAVID) AS MAXID
		    FROM NAVVERSION
	    </cfquery>
	    <cfif navid EQ 0>
			<cfif selectMaxID.MAXID NEQ ''>
				<cfset newID=selectMaxID.MAXID>
				<cfset newID=IncrementValue(#newID#)>
			<cfelse>
				<cfset newID = 1>
			</cfif>
		<cfelse>
			<cfset newID = arguments.navid>
		</cfif>
	    <cfquery name="addNavVersion" datasource="#arguments.ds#">
	        INSERT INTO NAVVERSION
	        (
				NAVID,
				NAVVERID,
				AUTHORID,
				NAVNAME,
				STATUS
	        )
	        VALUES
	        (
	            <cfqueryparam value="#newID#" cfsqltype="cf_sql_bigint">,
	            <cfqueryparam value="#timeAndDate#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
	        )
		</cfquery>
		<cfset navIDs = ArrayNew(1)>
		<cfset navIDs[1] = newID>
		<cfset navIDs[2] = timeAndDate>
		<cfreturn navIDs>
	</cffunction>
	
	<cffunction name="addNavigationItem" access="public" returntype="numeric" output="false" hint="Add a Navigation, I return the ID and Version ID of the navigation added"> 
	    <cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
	    <cfargument name="wpid" required="false" type="string" hint="Web Page ID of the item" default="0">
	    <cfargument name="linkid" required="false" type="string" hint="Link ID of the item" default="0">
		<cfargument name="navid" required="true" type="string" hint="I am the ID of the navigation that an item is being added to">
		<cfargument name="sortorder" required="false" type="string" hint="I am the sort order number of the nav item" default="0">
		<cfargument name="navverid" required="true" type="string" hint="I am the Nav Version that the item is being added to">
		<cfargument name="parentid" required="false" type="string" hint="I am the parentid of the nav item being passed in." default="-1">
		<cfset var selectMaxID = 0>
		<cfset var addNavItem = 0>
		<cfparam name="navitemid" default="1">
	    <cfquery name="selectMaxID" datasource="#arguments.ds#" maxrows="1">
		    SELECT MAX(NAVITEMID) AS NAVITEMID
		    FROM NAVITEMS
	    </cfquery>
		<cfif selectMaxID.recordcount EQ 1>
			<cfif selectMaxID.NAVITEMID GTE 1>
				<cfset NAVITEMID = selectMaxID.NAVITEMID>
				<cfset NAVITEMID = IncrementValue(#navitemid#)>
			</cfif>
		<cfelse> 
			<cfset navitemid = 1>
		</cfif>
	    <cfquery name="addNavItem" datasource="#arguments.ds#">
	        INSERT INTO NAVITEMS
	        (
				NAVID,
				NAVVERID,
				WPID,
				NAVITEMID,
				SORTORDER,
				LINKID
	        )
	        VALUES
	        (
	            <cfqueryparam value="#arguments.navid#" cfsqltype="cf_sql_bigint">,
	            <cfqueryparam value="#arguments.navverid#" cfsqltype="cf_sql_varchar">,
	            <cfqueryparam value="#arguments.wpid#" cfsqltype="cf_sql_bigint">,
	            <cfqueryparam value="#navitemid#" cfsqltype="CF_SQL_BIGINT">,
	            <cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_bigint">,
	            <cfqueryparam value="#arguments.linkid#" cfsqltype="cf_sql_bigint">
	        )
		</cfquery>		
		<cfif arguments.parentid NEQ -1>
			<cfinvoke component="navigation" method="addNavigationParent" ds="#arguments.ds#" parentid="#arguments.parentid#" navitemid="#navitemid#">
		</cfif>
		<cfreturn navitemid>
	</cffunction>
	
	<cffunction name="addNavigationParent" access="public" returntype="void" output="false"  hint="I add a parent for a specific NavItemID">
		<cfargument name="ds" required="false" hint="Data source" default="#variables.ds#">
		<cfargument name="parentid" required="true" hint="Parent ID of the navitem">
		<cfargument name="navitemid" required="true" hint="NavItemID that is being given a parent">
		<cfquery name="addNavigationParent" dataSource="#ds#">
			INSERT INTO NAVITEMPARENT
			(
				NAVITEMID,
				PARENTNAVID
			)
			VALUES
			(
				<cfqueryparam value="#navitemid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#parentid#" cfsqltype="cf_sql_bigint">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getNavigations" access="public" returntype="query" output="false" hint="I return the most current version of all navigations">
		<cfargument name="ds" required="false" hint="Data Source" default="#variables.ds#">
		<cfargument name="navverid" required="false" hint="Get a specific version of navigation" default="0">
		<cfargument name="navid" required="false" hint="Get a specific Navigation based on ID" default="0">
		<cfquery name="getNavigations" datasource="#ds#">
			SELECT
				NAVID,
				NAVVERID,
				NAVNAME,
				NAVVERSION.STATUS,
				AUTHORID,
				SITESECURITY.FIRSTNAME,
				SITESECURITY.LASTNAME
			FROM
				NAVVERSION,
				SITESECURITY
			WHERE
				1 = 1
				AND SITESECURITY.MASTERNAMEID = NAVVERSION.AUTHORID
				<cfif navverid NEQ 0>
					AND NAVVERID = <cfqueryparam value="#navverid#" cfsqltype="cf_sql_varchar">
					<cfif navid NEQ 0>
					AND NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">
					</cfif>
				<cfelse>
					AND NAVVERID IN ( SELECT NAVVERID FROM UNIQUENAVID <cfif navid NEQ 0>
						WHERE NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">
						</cfif>)
				</cfif>
			ORDER BY NAVID
		</cfquery>
		<cfreturn getNavigations>
	</cffunction>
	
	<cffunction name="getSimpleNavigations" access="public" returntype="query" output="false" hint="I return the most current version of all navigations">
		<cfargument name="ds" required="false" hint="Data Source" default="#variables.ds#">
		<cfargument name="navverid" required="false" hint="Get a specific version of navigation" default="0">
		<cfargument name="navid" required="false" hint="Get a specific Navigation based on ID" default="0">
		<cfquery name="getNavigations" datasource="#ds#">
			SELECT
				NAVID,
				NAVVERID,
				NAVNAME,
				NAVVERSION.STATUS
			FROM
				NAVVERSION
			WHERE
				1 = 1
				<cfif navverid NEQ 0>
					AND NAVVERID = <cfqueryparam value="#navverid#" cfsqltype="cf_sql_varchar">
					<cfif navid NEQ 0>
					AND NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">
					</cfif>
				<cfelse>
					AND NAVVERID IN ( SELECT NAVVERID FROM UNIQUENAVID <cfif navid NEQ 0>
						WHERE NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">
						</cfif>)
				</cfif>
			ORDER BY NAVID
		</cfquery>
		<cfreturn getNavigations>
	</cffunction>
	
	<cffunction name="getNavIDByName" access="public" returntype="numeric" output="false" hint="I return a navid(1) by navigation name">
		<cfargument name="ds" required="false" hint="Data Source" default="#variables.ds#">
		<cfargument name="NavigationName" required="true" hint="the name of the nav you are looking for">
		<cfset var myNavID=0>
		<cfquery name="getNavID" datasource="#arguments.ds#" maxrows="1">
		SELECT
				NAVID,
				NAVNAME
		FROM	
			NAVVERSION
		WHERE NAVNAME = <cfqueryparam value="#arguments.NavigationName#">
		</cfquery>
		<cfif getNavID.recordcount eq 0>
			<cfset myNavID=0>
		<cfelse>
			<cfset myNavID=getNavID.NAVID>
		</cfif>
		<cfreturn myNavID>
	</cffunction>
	
	<cffunction name="getNavItembyWPid" access="public" returntype="query" output="false" hint="I get the nav items by web page id passed to me and return a recordset (navitemid)">
		<cfargument name="ds" required="false" default="#variables.ds#" hint="datasource" >
		<cfargument name="pageid" required="true" type="numeric" hint="wpid for the page you need">
		<cfset var navItems = "">
		<cfquery name="navItems" datasource="#arguments.ds#">
		SELECT
			NAVITEMS.NAVID,
			NAVITEMS.WPID,
			NAVITEMS.NAVITEMID,
			NAVVERSION.NAVVERID,
			NAVVERSION.STATUS,
			NAVVERSION.NAVNAME
		FROM 
			NAVITEMS, NAVVERSION
		WHERE
			NAVITEMS.NAVID=NAVVERSION.NAVID
		AND NAVITEMS.WPID = <cfqueryparam value="#arguments.pageid#">
		AND NAVVERSION.STATUS='Published'
		</cfquery>
	<cfreturn navItems>
	</cffunction>
	
	<cffunction name="getNavigationItems" access="public" returntype="query" output="false" hint="I return the most current version navigation items. (NAVID, NAVVERID, WPID, NAVITEMID, SORTORDER, LINKID, PARENTNAVID)">
		<cfargument name="ds" required="false" hint="Data Source" default="#variables.ds#">
		<cfargument name="navid" required="true" hint="Nav ID that items are part of.">
		<cfargument name="siteid" required="false" hint="ID of the Site this navigation is for." default="0">
		<cfargument name="pageid" required="false" hint="ID of the page you want information for from specific navigation" default="0">
		<cfset var prefixURL = ''>
		<cfif arguments.siteid NEQ 0>
			<cfinvoke component="site" method="getSiteInfo" siteid="#arguments.siteid#" returnVariable="siteInfo" />
			<cfset prefixURL = 'http://www.#siteInfo.siteurl#/pages/'>
		<cfelse>
			<cfset prefixURL = ''>
		</cfif>
		<cfoutput>
		<cfquery name="getNavigationItems" datasource="#arguments.ds#">
			(SELECT 
				NAVITEMS.NAVITEMID,
				'#prefixURL#' + WPVERSION.URLNAME URL,
				WPVERSION.NAME,
				CASE WPVERSION.TITLE WHEN '' THEN WPVERSION.NAME ELSE WPVERSION.TITLE END AS TITLE,
				NAVITEMS.SORTORDER,
				WPVERSION.WPSTATUS AS PAGESTATUS,
				NAVITEMPARENT.PARENTNAVID,
				LINKID,
				NAVITEMS.WPID,
				'_self' AS TARGET
			FROM 
				NAVITEMS,
				NAVITEMPARENT,
				NAVVERSION,
				WPVERSION 
			WHERE 
				NAVVERSION.NAVID = NAVITEMS.NAVID
				AND NAVVERSION.NAVVERID = NAVITEMS.NAVVERID
				AND WPVERSION.WPID = NAVITEMS.WPID
				AND NAVITEMS.NAVITEMID = NAVITEMPARENT.NAVITEMID
				<cfif arguments.pageid NEQ 0>
				AND NAVITEMS.WPID = <cfqueryparam value="#arguments.pageid#" CFSQLType="CF_SQL_VARCHAR">
				</cfif>
				AND NAVITEMS.NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar"> 
				AND NAVITEMS.NAVVERID IN (SELECT NAVVERID FROM UNIQUENAVID 
					WHERE NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">)
				AND CREATEDON IN ( SELECT CREATEDON FROM UNIQUEWPID WHERE WPID=WPVERSION.WPID))
			UNION
			(SELECT
				NAVITEMS.NAVITEMID,
				LINKS.HREF AS URL,
				LINKS.NAME,
				LINKS.TITLE,
				NAVITEMS.SORTORDER,
				'Published' AS PAGESTATUS,
				NAVITEMPARENT.PARENTNAVID,
				NAVITEMS.LINKID,
				NAVITEMS.WPID,
				LINKS.TARGET
			FROM
				NAVITEMS,
				NAVITEMPARENT,
				NAVVERSION,
				LINKS
			WHERE
				NAVVERSION.NAVID = NAVITEMS.NAVID
				AND NAVVERSION.NAVVERID = NAVITEMS.NAVVERID
				AND LINKS.LINKID = NAVITEMS.LINKID
				AND NAVITEMS.NAVITEMID = NAVITEMPARENT.NAVITEMID
				<cfif arguments.pageid NEQ 0>
				AND NAVITEMS.WPID = <cfqueryparam value="#arguments.pageid#" CFSQLType="CF_SQL_VARCHAR">
				</cfif>
				AND NAVITEMS.NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">
				AND NAVITEMS.NAVVERID IN (SELECT NAVVERID FROM UNIQUENAVID 
								WHERE NAVID = <cfqueryparam value="#navid#" cfsqltype="cf_sql_varchar">))
			ORDER BY PARENTNAVID, SORTORDER
		</cfquery>
		</cfoutput>
		<cfreturn getNavigationItems>
	</cffunction>
	
	<cffunction name="getNavigationWithNesting" access="public" returntype="query" output="false" hint="I return the Navigation with a nesting column">
		<cfargument name="ds" required="false" hint="Data Source" default="#variables.ds#">
		<cfargument name="navid" required="true" hint="Nav ID that items are part of.">
		<cfargument name="siteid" required="false" hint="ID of the Site this navigation is for." default="0">
		<cfargument name="parentid" required="false" hint="Parent you want the children for" default="">
		<cfinvoke component="navigation" method="getNavigationItems" ds="#arguments.ds#" siteid="#arguments.siteid#" navid="#arguments.navid#" returnVariable="navigationItems" />
		<cfquery name="makeTree" dbtype="query">
		select 
			parentnavid AS parent,
			navitemid AS id,
			navitemid,
			wpid,
			linkid,
			sortorder,
			url,
			target,
			pagestatus,
			title,
			navitemid AS nestLevel,
			name
		from navigationItems
		where pagestatus = 'Published'
		order by sortorder
		</cfquery>
		<cfinvoke component="tree" method="makeBranches" theQuery="#makeTree#" nestLevel="1" thisBranch="#arguments.parentid#" returnVariable="getPagesWithNesting" />
		<cfreturn getPagesWithNesting>
	</cffunction>
	
	<cffunction name="getNavItemParent" access="public" output="false" returntype="string" hint="I get id of the parent">
		<cfargument name="ds" required="true" type="string" hint="Data Source">
		<cfargument name="navitemid" required="true" type="string" hint="ID of the navitem">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT PARENTNAVID FROM NAVITEMPARENT
			WHERE NAVITEMID=<cfqueryparam value="#arguments.navitemid#">
		</cfquery>
		<cfreturn get.PARENTNAVID>
	</cffunction>
</cfcomponent>