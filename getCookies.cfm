<cffunction name="getCookies" output="false" returnType="array">
	<cfargument name="headers" type="String" required="yes">
	
	<cfset var cookies = arrayNew(1)>
	<cfset var thisCookie = StructNew()>
	<cfset var header = "">
	<cfset var aCookie = "">
	<cfset var crumb = "">
	<cfset var paramName = "">
	<cfset var paramValue = "">
	<cfset count = 1>
	
	<cfloop list="#headers#" delimiters="#Chr(10)#" index="header">
		<cfif reFind("^Set-Cookie: ", header) gt 0>
			<cfset acookie = reReplace(header,"^Set-Cookie: ","","ALL")>
			<cfset thisCookie = StructNew()>
			<cfloop list="#acookie#" delimiters=";" index="crumb">
				<cfset crumb = trim(crumb)>
			<cfif listcontainsnocase(crumb,"=")>
				<cfset paramName = listgetat(crumb,1,"=")>
				<cfif listLen(crumb,"=") GT 1>
					<cfset paramValue = listgetat(crumb,2,"=")>
				<cfelse>
					<cfset paramValue = "">
				</cfif>
				<cfif paramName eq "expires">
					<cfset thisCookie.expires = paramValue>
				<cfelseif paramName eq "path">
					<cfset thisCookie.path = paramValue>
				<cfelseif paramName eq "domain">
					<cfset thisCookie.domain = paramValue>
				<cfelseif paramName eq "secure">
					<cfset thisCookie.secure = paramValue>
				<cfelse>
					<cfset thisCookie.name = paramName>
					<cfset thisCookie.value = paramValue>
				</cfif>
			</cfif>
			</cfloop>
			<cfset arrayAppend(cookies,thisCookie)>
		</cfif>
	</cfloop>
	<cfreturn cookies>
</cffunction>