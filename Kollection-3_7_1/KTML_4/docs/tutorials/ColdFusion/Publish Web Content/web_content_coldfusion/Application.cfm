<cfsetting enableCFoutputOnly="yes">
<cfsilent>
	<cfapplication sessionmanagement="yes" name="#Hash(GetCurrentTemplatePath())#" setclientcookies="no">
	<cfif IsDefined("Session.CFID") AND IsDefined("Session.CFTOKEN")>
		<cfset localCFID = Session.CFID>
		<cfset localCFToken = Session.CFTOKEN>
	<cfelseif IsDefined("Cookie.CFID") AND IsDefined("Cookie.CFTOKEN")>
		<cfset localCFID = Cookie.CFID>
		<cfset localCFToken = Cookie.CFTOKEN>
	</cfif>
	<cfif IsDefined("localCFID") AND IsDefined("localCFToken")>
		<cfcookie name="CFID" value="#localCFID#">
		<cfcookie name="CFTOKEN" value="#localCFToken#">
	</cfif>
</cfsilent>
<cfsetting enableCFoutputOnly="no">