<cfcomponent hint="I have function for modules">
	<cfobject component="timedateconversion" name="mytime">
	
	<cffunction name="addsection" access="public" returntype="string" hint="I add the section to the system. I return sectionid">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="name" type="string" required="true" default="0" hint="I am the name of the section">
		<cfargument name="description" type="string" required="true" default="0" hint="I am the description of the section">
		<cfset var add=0>
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM SECTIONS WHERE NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfquery name="add" datasource="#arguments.ds#">
				INSERT INTO SECTIONS
				(
					NAME,
					DESCRIPTION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
				);
				SELECT @@IDENTITY AS SECTIONID
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn add.SECTIONID>
	</cffunction>
	
	<cffunction name="addModule" access="public" returntype="string" hint="I add module to the system. I return QDMODULEID">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="name" type="string" required="true" hint="I am the name of the module">
		<cfargument name="description" type="string" required="true" default="0" hint="I am the description of the module">
		<cfargument name="sectionid" type="string" required="true" hint="I am the id of the section to which this module belongs">
		<cfset var check=0>
		<cfset var add=0>
		<cfset var get=0>
		<cfset var addtosites=0>
		
		<cfquery name="check" datasource="#arguments.ds#">
			SELECT * FROM QDMODULES WHERE NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif check.recordcount GT 0><cfreturn 0></cfif> <!--- Module already exists --->
		
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO QDMODULES
			(
				NAME,
				DESCRIPTION,
				SECTIONID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS QDMODULEID 
		</cfquery>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT SITEID FROM SITE
		</cfquery>
		
		<cfloop query="get">
			<cfquery name="addtosites" datasource="#arguments.ds#">
				INSERT INTO QDMODULE2SITE
				(
					SITEID,
					QDMODULEID
				)
				VALUES
				(
					<cfqueryparam value="#get.siteid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#add.QDMODULEID#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfloop>
		<cfreturn add.QDMODULEID>
	</cffunction>
	
	<cffunction name="addModuleToSite" access="public" returntype="string" hint="I assign a module to a site">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="QDMODULEID" type="string"  required="true" hint="I am the id of the module">
		<cfargument name="siteid" type="string" required="true" hint="I am the id of the site">
		<cfset var add = 0>
		<cfset var addhistory = 0>
		<cfif get.recordcount NEQ 0>
			<cfquery name="add" datasource="#arguments.ds#">
				UPDATE INTO MODULE2SITE
				SET STATUS = 1
				WHERE SITEID = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
				AND QDMODULEID = <cfqueryparam value="#arguments.QDMODULEID#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setModuleToUpdate" access="public" returntype="void" hint="I set the database of the module to update">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="QDMODULEID" type="string" required="true" hint="I am the id of the module which needs to be upated">
		<cfargument name="siteid" type="string" required="false" default="0" hint="I am the id of the site">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			UPDATE MODULE2SITE
			SET UPDATE_REQUIRED = 1
			WHERE QDMODULEID = <cfqueryparam value="#arguments.QDMODULEID#" cfsqltype="cf_sql_varchar">
			<cfif arguments.QDMODULEID NEQ 0>
			AND SITEID = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="checkforupdate" access="public" returntype="string" hint="I return true if update is required">
		<cfargument name="ds" type="string" required="false" default="I am the data source, should default to deltasystem">
		<cfargument name="modulename" type="string" required="false" default="I am the the name of the module">
		<cfargument name="siteid" type="string" required="false" default="I am the id of the site">
		<cfset var getModule=0>
		<cfset var get=0>
		<cfquery name="getModule" datasource="#arguments.ds#">
			SELECT QDMODULEID FROM QDMODULES
			WHERE NAME=<cfqueryparam value="#arguments.modulename#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif getModule.recordcount GT 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT UPDATE_REQUIRED FROM QDMODULE2SITE
				WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
				AND QDMODULEID=<cfqueryparam value="#getModule.QDMODULEID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfreturn get.UPDATE_REQUIRED>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="deleteModuleFromSite" access="public" returntype="void" hint="I delete / revoke access to a module for a site">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="siteid" type="string" required="true" hint="I am the id of the site">
		<cfargument name="QDMODULEID" type="string" required="true" hint="I am the id of the module">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			UPDATE MODULE2SITE
			SET STATUS=0
			WHERE SITEID = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
			AND QDMODULEID = <cfqueryparam value="#arguments.QDMODULEID#" cfsqltype="cf_sql_varchar">
		</cfquery> 
		<cfreturn>
	</cffunction>

	<cffunction name="editSection" access="public" returntype="void" hint="I edit section">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="sectionid" type="string" required="true" hint="I am the id of the section">
		<cfargument name="name" type="string" required="true" default="0" hint="I am the name of the section">
		<cfargument name="description" type="string" required="true" default="0" hint="I am the description of the section">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE SECTIONS SET
				NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="editModule" access="public" returntype="void" hint="I edit module">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="qdmoduleid" type="string" required="true" hint="I am the id of the module">
		<cfargument name="name" type="string" required="true" hint="I am the name of the module">
		<cfargument name="description" type="string" required="true" default="0" hint="I am the description of the module">
		<cfset var edit=0>
		<cfquery name="edit" datasource="#arguments.ds#">
			UPDATE QDMODULES SET 
			NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
			DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE QDMODULEID=<cfqueryparam value="#arguments.qdmoduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setTablestoUpdate" access="public" returntype="void" hint="I set module tables to update">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="moduleid" type="string" required="true" hint="id of the module">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE QDMODULE2SITE SET
			UPDATE_REQUIRED=1
			WHERE QDMODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setModuleAsUpdatedforSite" access="public" returntype="void" hint="I set module as updated">
		<cfargument name="ds" type="string" required="false" hint="I am the name of the data source">
		<cfargument name="modulename" type="string" required="false" hint="I am the name of the module updated">
		<cfargument name="siteid" type="string" required="false" hint="I am the name of the site updated">
		<cfset var update=0>
		<cfset var get=0>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT QDMODULEID FROM QDMODULES
			WHERE NAME=<cfqueryparam value="#arguments.modulename#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif get.recordcount GT 0>
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE QDMODULE2SITE SET 
				UPDATE_REQUIRED=0
				WHERE QDMODULEID=<cfqueryparam value="#get.QDMODULEID#" cfsqltype="cf_sql_varchar">
				AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="getModules" access="public" returntype="query" hint="I get qdcms modules. Returns:QDMODULEID,NAME,DESCRIPTION">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="qdmoduleid" type="string" required="false" default="0" hint="id of the module accessing">
		<cfargument name="siteid" type="string" required="false" default="0" hint="id of the site whose module are being accessed">
		<cfset var get=0>
		<cfif (arguments.QDMODULEID EQ 0) AND (arguments.siteid EQ 0)>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT
					QDMODULEID,
					NAME,
					DESCRIPTION
				FROM QDMODULES
				ORDER BY QDMODULEID DESC
			</cfquery>
		<cfelseif (arguments.QDMODULEID GT 0)>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT
					QDMODULEID,
					NAME,
					DESCRIPTION
				FROM QDMODULES
				WHERE QDMODULEID=<cfqueryparam value="#arguments.QDMODULEID#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					QDMODULES.QDMODULEID,
					QDMODULES.NAME,
					QDMODULES.DESCRIPTION
				FROM QDMODULES, MODULE2SITE
				WHERE QDMODULES.QDMODULEID=MODULE2SITE.QDMODULEID
				AND MODULE2SITE.STATUS=1
				AND MODULE2SITE.SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		<cfreturn get>
	</cffunction>

	<cffunction name="getSections" access="public" returntype="query" hint="I get qdcms sections. Returns:SECTIONID,NAME,DESCRIPTION">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="sectionid" type="string" required="false" default="0" hint="I am the id of the section">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				SECTIONID,
				NAME,
				DESCRIPTION
			FROM SECTIONS
			<cfif arguments.sectionid NEQ 0>
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="createNavigation" access="public" returntype="any" output="false" hint="I return navigation menu">
		<cfargument name="ds" type="string" required="true" hint="I am the name of the data source">
		<cfargument name="acl"  type="string" required="false" default="0" hint="I am the access control list for a user">
		<cfset var getmodules=0>
		<cfset var getsections=0>
			
		<cfset length=listlen(arguments.acl)>
		<cfquery name="getmodules" datasource="#arguments.ds#">
			SELECT
				QDMODULEID,
				NAME,
				DESCRIPTION,
				SECTIONID
			FROM QDMODULES
			<cfif arguments.acl NEQ "0">
			WHERE NAME IN 
			(
				<cfloop from="1" to="#length#" index="i">
					'#Trim(listgetAt(arguments.acl,i))#' <cfif i LT length>,</cfif>
				</cfloop>
			)
			</cfif>
			ORDER BY SECTIONID, NAME
		</cfquery>
		
		<cfset sectionlist=valuelist(getmodules.sectionid)>
		
		<cfquery name="getsections" datasource="#arguments.ds#">
			SELECT
				SECTIONID,
				NAME,
				DESCRIPTION
			FROM SECTIONS
			WHERE SECTIONID IN (#sectionlist#)
			ORDER BY SECTIONID
		</cfquery>
		
		<cfoutput>
			<cfsavecontent variable="navigation">
				<navigation>
					<cfloop query="getsections">
						<section name="#name#" id="#sectionid#" description="#description#">
							<cfloop query="getmodules">
								<cfif getsections.sectionid EQ getmodules.sectionid>
									<module name="#name#" qdmoduleid="#qdmoduleid#" description="#description#"/>
								</cfif>
							</cfloop>
						</section>
					</cfloop>
				</navigation>
			</cfsavecontent>
		</cfoutput>
		<cfreturn navigation>
	</cffunction>
</cfcomponent>