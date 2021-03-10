<cffunction name='func_subnavigation' returntype='string' output='no'>
	<cfargument name='menu' required='yes'>
	<cfargument name='type' required='yes'>
	<cfargument name='excludeSelf' required='no'>
	<cfargument name='id' required='no'>
	
	<!--- Local variables --->
	<cfset var i1=0>
	<cfset var i2=0>
	<cfset var item_name=''>
	<cfset var item_link=''>
	<cfset result = ''>
	<cfparam name="active" default="">
	<cfparam name="excludeSelf" default="no">
	
	<cfif type EQ "web_page">
		<cfset type = "pages">
	</cfif>
	<!--- Loop through menu items --->
	<cfif arrayLen(menu) GT 0>
	<cfif isDefined('id') AND id NEQ 0>
		<cfset result='<ul id="#id#">'>
	<cfelse>
		<cfset result='<ul>'>
	</cfif>
	<cfloop from='1' to='#ArrayLen(menu)#' index='i1'>

	<cfif excludeSelf EQ 'yes' AND url.page EQ menu[i1].xmlAttributes.pagename>
	
	<cfelse>
	<cfset request.CountVar = 0>
			<cfset curID = client.pageid>
			<cfset bcPageTitle = "">
			<cfloop condition = "request.CountVar NEQ 10">
				<cfset request.CountVar = request.CountVar + 1>
				<cfset breadcrumbsXML = xmlsearch(client.mydoc, "//#caller.contenttype#[@id='#curID#']")>
				<cfif request.CountVar GT 1>
					<cfset tempTitle = #breadcrumbsXML[1].XmlAttributes.pagename# & "," & #tempTitle#>
				<cfelse>
					<cfset tempTitle = #breadcrumbsXML[1].XmlAttributes.pagename#>
				</cfif>
				<cfset curID = breadcrumbsXML[1].XmlAttributes.parentid>
				<cfif curID EQ client.siteid OR curID EQ 0>
					<cfset request.CountVar = 10>
				</cfif>
			</cfloop>
	<cfif url.page EQ menu[i1].xmlAttributes.pagename OR listcontainsnocase(#tempTitle#,#menu[i1].xmlAttributes.pagename#)>
		<cfset active = ' class="active"'>
	<cfelse>
		<cfset active = ''>
	</cfif>
	<cfif ListLen(menu[i1].xmlattributes.link,"://") GT 1>
	<cfset result = '#result# <li><a href="#menu[i1].xmlAttributes.link#"#active#>#menu[i1].xmlAttributes.name#</a></li>'>
	<cfelse>
	<cfset result = '#result# <li><a href="#caller.site##type#/#menu[i1].xmlAttributes.link#"#active#>#menu[i1].xmlAttributes.name#</a></li>'>
	</cfif>
	<cfif arrayLen(menu[i1].xmlChildren) GT 0>
		<cfset result = '#result# #func_subnavigation(menu[i1].xmlChildren, type)#'>
	</cfif>
	</cfif>
	</cfloop>
	<cfset result = '#result# </ul>'>
	</cfif>
	<cfreturn result>
</cffunction>