<cfcomponent displayname="CFMX Scheduled Tasks"
hint="CFMX Scheduled Tasks editor" 
lastUpdated="2004-07-09"
author="Elyse Nielsen">
<!--- Initialization --->
<cfset THIS.lockname = CreateUUID()>
<cflock name="#THIS.lockname#" type="exclusive" timeout="10">
<cfscript>
this.factory = CreateObject("java", "coldfusion.server.ServiceFactory");
this.cron_service = this.factory.CronService;
this.Services = this.cron_service.listALL();
</cfscript>
</cflock>
<cfif not IsArray(this.Services)>
<cfthrow message="The template '#lcase(getfilefrompath(getcurrenttemplatepath()))#' can't initialize.">
</cfif>

<cffunction name="getScheduledTask" access="public" output="false" returnType="any"
hint="Returns the structure of the Scheduled Task if found by name">
<cfargument name="taskname" type="string" required="true">
<cflock name="#THIS.lockname#" type="exclusive" timeout="10">
<cfloop from="1" to="#ArrayLen(this.Services)#" index="i">
<cfif this.Services[i].task IS taskname>
<cfreturn this.Services[i]>
</cfif>
</cfloop>
</cflock>
<cfreturn "">
</cffunction>

<cffunction name="showScheduledTasks" access="public" output="false" returntype="array" hint="I return an array of structures of the scheduled tasks">
<cflock name="#THIS.lockname#" type="exclusive" timeout="10">
<cfreturn this.Services>
</cflock>
</cffunction>

</cfcomponent>