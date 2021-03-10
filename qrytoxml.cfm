<!--- --> 
 <fusedoc fuse="qrytoxml.cfm"  language="coldfusion"  specification="2.0">
	<responsibilities>
		I recieve a query and convert it to a properly nested XML string.
	</responsibilities>
	<properties>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="20070214" type="Create"/>
	</properties>
	<io>
		<in>
			<file Path="treeUDFs.cfm" Action="Include" comments="Just included CFML file" />
			<string name="attributes.display" default="(blank)">
			<string name="attributes.value" default="0">
			<string name="attributes.parent" default="">
			<string name="attributes.link" default="##">
			<string name="attributes.target" default="_self">
			<string name="attributes.id" default="0">
			<string name="attributes.name" default="(blank)">
			<string name="attributes.keywords" default="">
			<string name="attributes.elementname" default="">
			<string name="attributes.eventcategory" default="">
			<string name="attributes.title" default="">
			<string name="attributes.peerorder" default="">
			<string name="attributes.lastupdated" default="">
			<string name="attributes.description" default="">
			<string name="attributes.pagename" default="">
		</in>
	</io>
</fusedoc>
--->
<cfif not IsDefined("ThisTag.ExecutionMode")>
<cfexit>
</cfif>
<!--- Param attributes --->
<cfparam name="attributes.divname" default="menu">
<cfparam name="attributes.parentclass" default="0">
<cfparam name="attributes.mainulclass" default="0">
<cfif ThisTag.ExecutionMode is "Start"><cfif Not IsDefined("request.treeUDF")>
	<cfinclude template="TreeUDFs.cfm">
</cfif>
<cfif IsDefined("attributes.treename")>
	<cfset attributes.name=attributes.treename>
</cfif>
</cfif>
<cfif ThisTag.ExecutionMode IS "End"><cfscript>
if ( IsDefined("ThisTag.AssocAttribs") ) {
	qItems = arrayOfStructuresToQuery(ThisTag.AssocAttribs);
} else {
	qItems = QueryNew("display,value,parent,link,target");
}
if ( IsDefined("attributes.query") ) {
	qItems = Evaluate("Caller.#attributes.query#");
}
TreeQuery = makeBranches(qItems);
</cfscript>
<cfcontent reset="yes"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cfoutput query="TreeQuery">
<cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] lt TreeQuery.nestLevel[CurrentRow+1]>
<#elementname# name="#name#" id="#id#" link="#link#" title="#title#" peerorder="#peerorder#" lastupdated="#lastupdated#" eventcategory="#eventcategory#" target="#target#" parentid="#parent#" description="#description#" pagename="#pagename#" keywords="#keywords#" actualstarttime="#actualstarttime#" actualendtime="#actualendtime#" starttime="#starttime#" endtime="#endtime#" titleclass="#titleclass#" contentclass="#contentclass#">#text#
<cfelse>
<#elementname# name="#name#" id="#id#" link="#link#" title="#title#" peerorder="#peerorder#" lastupdated="#lastupdated#" eventcategory="#eventcategory#" target="#target#" parentid="#parent#" description="#description#" pagename="#pagename#" keywords="#keywords#" actualstarttime="#actualstarttime#" actualendtime="#actualendtime#" starttime="#starttime#" endtime="#endtime#" titleclass="#titleclass#" contentclass="#contentclass#">#text#</#elementname#>
</cfif>
<cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] gt TreeQuery.nestLevel[CurrentRow+1]>
	<cfset loopFrom = TreeQuery.nestLevel[CurrentRow+1]>
	<cfset loopTo = TreeQuery.nestLevel[CurrentRow] - 1>
	<cfloop index="nestDown" from="#loopFrom#" to="#loopTo#" step="1"></#elementname#></cfloop>
</cfif>
<!--- <cfif CurrentRow eq RecordCount>
<cfloop index="nestDown" from="1" to="#nestLevel#" step="1"></site></cfloop>
</cfif> --->
</cfoutput></site></cfif>