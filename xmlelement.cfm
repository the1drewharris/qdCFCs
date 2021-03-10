<!--- --> 
 <fusedoc fuse="xmlelement.cfm"  language="coldfusion"  specification="2.0">
	<responsibilities>
		I take each xml element data in.
	</responsibilities>
	<properties>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="20070214" type="Create"/>
	</properties>
	<io>
		<in>
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
			<string name="query" scope="attributes" comments="Not Yet Used" />
			<boolean name="queryasroot" scope="attributes" comments="Not Yet Used" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
<cfif not IsDefined("ThisTag.ExecutionMode")><cfexit></cfif>
<cfparam name="attributes.display" default="(blank)">
<cfparam name="attributes.value" default="0">
<cfparam name="attributes.parent" default="">
<cfparam name="attributes.link" default="##">
<cfparam name="attributes.target" default="_self">
<cfparam name="attributes.id" default="0">
<cfparam name="attributes.name" default="(blank)">
<cfparam name="attributes.elementname" default="">
<cfparam name="attributes.eventcategory" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.peerorder" default="">
<cfparam name="attributes.lastupdated" default="">
<cfparam name="attributes.description" default="">
<cfparam name="attributes.text" default="">
<cfparam name="attributes.pagename" default="">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.actualstarttime" default="">
<cfparam name="attributes.actualendtime" default="">
<cfparam name="attributes.starttime" default="">
<cfparam name="attributes.endtime" default="">
<cfparam name="attributes.titleclass" default="">
<cfparam name="attributes.contentclass" default="">
<cfif attributes.parent eq attributes.value><cfthrow message="An item cannot be its own parent." type="CustomTagError" detail="You cannot set the value of parent and the value of value equal to each other."></cfif>
<cfif ThisTag.ExecutionMode is "Start"><cfassociate basetag="CF_qrytoxml"><cfset attributes.nestLevel = 1><cfset attributes.href = "">
</cfif>
</cfsilent>