<cfset subpages = xmlsearch(client.mydoc, "//#contenttype#[@parentid='#client.pageid#']")>
<cfif arrayLen(subpages) GT 0>
	<cfset client.hassubs = 1>
<cfelse>
	<cfif client.parentid NEQ client.siteid>
		<cfset client.hassubs = 1>
	<cfelse>
		<cfset client.hassubs = 0>
	</cfif>
</cfif>