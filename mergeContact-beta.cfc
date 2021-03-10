<cfcomponent hint="I merge two Contacts">
	<cffunction name="merge" access="public" returntype="string" output="false" hint="I merge two contacts">
		<cfargument name="ds" required="true" type="string" hint="I am the name of the database">
		think about other arguments
	</cffunction>
	
	<cffunction name="updateMergeRecords" access="public" returntype="String" output="false" hint="I update records for merge contacts">
		<cfargument name="ds" required="true" type="string" hint="I am the name of the database">
		<cfargument name="nameid1" required="true" type="string" hint="I am the first contact to be merged">
		<cfargument name="nameid2" required="true" type="string" hint="I am the second contact to be merged">
		<cfargument name="newnameid" required="true" type="string" hint="I am the new nameid of the merged contact">
		<cfset var getTables=0>
		<cfset success=1>
		<cfquery name="getTables" datasource="#arguments.ds#">
			SELECT TABLE_NAME 
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE COLUMN_NAME = 'NAMEID'
		</cfquery>
		<cftry>
		<cfquery name="updateTables">
			<cfloop query="getTables">
				UPDATE #getTables.TABLE_NAME#
				SET NAMEID=<cfqueryparam value="#arguments.newnameid#" cfsqltype="cf_sql_varchar">
				WHERE NAMEID=<cfqueryparam value="#arguments.nameid1#" cfsqltype="cf_sql_varchar">
				OR NAMEID=<cfqueryparam value="#arguments.nameid2#" cfsqltype="cf_sql_varchar">
			</cfloop>
		<cfquery>
			<cfcatch type="any">
				<cfset success=0>
			</cfcatch>
		</cftry>
		<cfreturn success>
	</cffunction>
</cfcomponent>