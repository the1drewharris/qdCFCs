<cfcomponent displayname="patch" hint="I am a component which upgrades qdcms">
	<cffunction name="init" access="public" returntype="string" hint="This method should be run before any functions should be used">
		<cfset this.masterdsn="deltasystem">
		<cfif isDefined('application.objtimedateconversion')>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>	
	</cffunction>
	
	<cffunction name="addPatch" access="public" returntype="void" hint="adds patch and returns patchId">
		<cfargument name="patchname" required="true" type="String" hint="Name of the patch">
		<cfargument name="filename" required="true" type="String" hint="name of the file which has code for the patch">
		<cfargument name="description" required="true" type="String" hint="description of the patch">
		<cfargument name="status" required="false" type="String" default="1" hint="0 if the patch should not be applied now">
		<cfset var add=0>
		<cfset var ts=application.objtimedateconversion.createTimeDate()>
		<cfquery name="add" datasource="#this.masterdsn#">
			INSERT INTO PATCHES
			(
				PATCHNAME,
				FILENAME,
				DESCRIPTION,
				PATCHADDEDON,
				LASTUPDATEDON,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.patchname#">,
				<cfqueryparam value="#arguments.filename#">,
				<cfqueryparam value="#arguments.description#">,
				<cfqueryparam value="#ts#">,
				<cfqueryparam value="#ts#">,
				<cfqueryparam value="#arguments.status#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="updatePatch" access="public" returntype="void" hint="edits patch">
		<cfargument name="patchid" required="true" type="string" hint="id of the patch">
		<cfargument name="patchname" required="true" type="string" hint="name of the patch">
		<cfargument name="filename" required="true" type="string" hint="name of the file which has code for the patch">
		<cfargument name="description" required="true" type="String" hint="description of the patch">
		<cfargument name="status" required="true" type="string" hint="Status: 0 for inactive and 1: for active">
		<cfset var update=0>
		<cfset var ts=application.objtimedateconversion.createTimeDate()>
		<cfquery name="update" datasource="#this.masterdsn#">
			UPDATE PATCHES SET
				PATCHNAME=<cfqueryparam value="#arguments.patchname#">,
				FILENAME=<cfqueryparam value="#arguments.filename#">,
				DESCRIPTION=<cfqueryparam value="#arguments.description#">,
				LASTUPDATEDON=<cfqueryparam value="#ts#">,
				STATUS=<cfqueryparam value="#arguments.status#">
			WHERE PATCHID=<cfqueryparam value="#arguments.patchid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setPatchAsApplied" access="public" returntype="void" hint="record that the patch has been applied for the site">
		<cfargument name="patchid" required="true" type="string" hint="id of the patch">
		<cfargument name="siteid" required="true" type="string" hint="id of the patch">
		<cfset var add=0>
		<cfset var ts=application.objtimedateconversion.createTimeDate()>
		<cfquery name="add" datasource="#this.masterdsn#">
			INSERT INTO PATCHESTOSITE
			(
				PATCHID,
				SITEID,
				PATCHAPPLIEDON
			)
			VALUES
			(
				<cfqueryparam value="#arguments.patchid#">,
				<cfqueryparam value="#arguments.siteid#">,
				<cfqueryparam value="#ts#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getPatchesToApply" access="public" returntype="query" hint="returns all unapplied patches: PATCHID, PATCHNAME,FILENAME,PATCHADDEDON,LASTUPDATEDON,STATUS">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT 
				PATCHID,
				FILENAME
			FROM PATCHES
			WHERE PATCHID NOT IN(SELECT PATCHID FROM PATCHESTOSITE WHERE SITEID=<cfqueryparam value="#arguments.siteid#">)
			AND STATUS=<cfqueryparam value="1">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getPatches" access="public" returntype="query" hint="return fields: PATCHID, PATCHNAME, FILENAME, PATCHADDEDON,LASTUPDATEDON,STATUS and DESCRIPTION if patchid is passed">
		<cfargument name="patchid" required="false" default="0" type="string" hint="id of the patch">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT
				PATCHID,
				PATCHNAME,
				FILENAME,
				<cfif arguments.patchid NEQ 0>
				DESCRIPTION,
				<cfelse>
				PATCHADDEDON,
				LASTUPDATEDON,
				</cfif>
				STATUS
			FROM PATCHES
			<cfif arguments.patchid NEQ 0>
			WHERE PATCHID=<cfqueryparam value="#arguments.patchid#">
			</cfif>
			ORDER BY PATCHID DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getPatchReport" access="public" returntype="query" hint="returns list of sites the patch has been applied to">
		<cfargument name="patchid" required="true" type="string" hint="id of the patch">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT
				B.SITEURL,
				A.PATCHAPPLIEDON
			FROM PATCHESTOSITE A, SITE B
			WHERE A.PATCHID=<cfqueryparam value="#arguments.patchid#"> 
			AND A.SITEID=B.SITEID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getSitesThePatchHasBeenAppliedTo" access="public" returntype="query" hint="returns list of sites the patch has been applied to">
		<cfargument name="patchid" required="true" type="string" hint="id of the patch">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT
				B.SITEURL
			FROM PATCHESTOSITE A, SITE B
			WHERE A.PATCHID=<cfqueryparam value="#arguments.patchid#"> 
			AND A.SITEID=B.SITEID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getSiteReport" access="public" returntype="query" hint="returns list of patches the site has been applied">
		<cfargument name="siteid" required="true" type="string" hint="id of the patch">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT 
				A.PATCHID,
				A.PATCHNAME,
				A.FILENAME,
				B.PATCHAPPLIEDON
			FROM PATCHES A, PATCHESTOSITE B
			WHERE B.SITEID=<cfqueryparam value="#arguments.siteid#"> 
			AND A.PATCHID=B.PATCHID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getPatchName" access="public" returntype="String" hint="returns name of the patch">
		<cfargument name="patchid" required="true" type="string" hint="id of the patch">
		<cfset var get=0>
		<cfquery name="get" datasource="#this.masterdsn#">
			SELECT PATCHNAME FROM PATCHES
			WHERE PATCHID=<cfqueryparam value="#arguments.patchid#">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn 0>
		<cfelse>
			<cfreturn get.PATCHNAME>
		</cfif>
	</cffunction>
</cfcomponent>