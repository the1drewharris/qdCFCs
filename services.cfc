<cfcomponent name="services">
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
	
	<cffunction name="sayHelloString" access="remote" returnType="string">
    	<cfreturn "Hello World!">
 	</cffunction>

	<cffunction name="getTime" access="remote" returnType="string">
    	<cfreturn timedate>
 	</cffunction>

</cfcomponent>