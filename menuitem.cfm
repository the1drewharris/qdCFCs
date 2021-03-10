<!--- --> 
 <fusedoc fuse="TreeItem.cfm"  language="coldfusion"  specification="2.0">
	<responsibilities>
		I am an item for the tree tag
	</responsibilities>
	<properties>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="23-Apr-2003" type="Create"/>
		<history email="steve@bryantwebconsulting.com" author="Steve Bryant" date="23-Apr-2003" type="Create" role="Architect">
			This is a rewrite of Drew's original work.
			This version will reduce the need for external files.
			It will also eliminate the need for a database to use cf_tree.
		</history>
		<history email="steve@bryantwebconsulting.com" author="Steve Bryant" date="04-Apr-2006" type="Update">
			Edited menuitem to remove some extraneous code.
		</history>
	</properties>
	<io>
		<in>
			<string name="Display" scope="attributes" default="(blank)" />
			<string name="Value" scope="attributes" />
			<string name="Parent" scope="attributes" />
			<string name="link" scope="attributes" />
			<string name="id" scope="attributes" />
			<string name="target" scope="attributes" comments="Not Yet Used" />
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
<cfparam name="attributes.page" default="unknown">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.target" default="_self">
<cfparam name="attributes.id" default="0">
<cfif attributes.parent eq attributes.value><cfthrow message="An item cannot be its own parent." type="CustomTagError" detail="You cannot set the value of parent and the value of value equal to each other."></cfif>
<cfif ThisTag.ExecutionMode is "Start">
	<cfassociate basetag="CF_menu">
	<cfset attributes.nestLevel = 1>
	<cfset attributes.href = "">
</cfif>
</cfsilent>