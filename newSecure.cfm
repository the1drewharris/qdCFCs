<!---
|| BEGIN FUSEDOC ||
	
|| Properties ||
Name: Secure.cfm
Author: hal.helms@TeamAllaire.com

|| Responsibilities ||
I am a custom tag that provides security within an XFB framework.

|| Attributes ||
==> attributes.requiredPermission: an INTEGER
==> [attributes.securityFA]: a FUSEACTION
++> client.CurrentUser: a WDDXd STRUCTURE
  < userPermissions: an INTEGER
++> request.self: a FILENAME

|| END FUSEDOC ||--->

<cfoutput>

<cfif NOT IsDefined( 'client.CurrentUser' )>
	<cfset temp = StructNew()>
	<cfset temp.firstName = "Guest">
	<cfset temp.lastName = "">
	<cfset temp.authorizedPermissions = "0">
	
	<cfwddx 
		action="CFML2WDDX" 
		input="#temp#" 
		output="client.CurrentUser">
</cfif>

<cfwddx 
	action="WDDX2CFML" 
	input="#client.currentUser#" 
	output="currentUser">

<cfif NOT BitAnd( CurrentUser.authorizedPermissions, attributes.requiredPermission )>
	<cfif IsDefined( 'attributes.SecurityFA' )>
		<cflocation url="#request.self#?fuseaction=#attributes.SecurityFA#" addtoken="Yes">
	</cfif>
	<cfexit method="EXITtag">
</cfif>

</cfoutput>
