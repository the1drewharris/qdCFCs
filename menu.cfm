<!--- --> 
 <fusedoc fuse="menu.cfm"  language="coldfusion"  specification="2.0">
	<responsibilities>
		I provide a menu like cfmenu, except I am html and JavaScipt.
		I get all of my menu items from a table in a database called menu.
		I am meant to be displayed in a form.
		I can provide the client with multiple select by means of checkboxes, or I can provide the user with single select by means of radiobutton, the default is single select.
	</responsibilities>
	<properties>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="23-Apr-2003" type="Create"/>
		<history email="steve@bryantwebconsulting.com" author="Steve Bryant" date="23-Apr-2003" type="Create" role="Architect">
			This is a rewrite of Drew's original work.
			This version will reduce the need for external files.
			It will also eliminate the need for a database to use cf_menu.
		</history>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="21-Nov-2003" type="Update">
			I added the CSS to Bold the parent type items that are expandable.
			I also added the CheckStatus back so you can have items in your menu control checked by default.
		</history>
		<history email="steve@bryantwebconsulting.com" author="Steve Bryant" date="04-Apr-2006" type="Update">
			Edited menu to fix some small bugs.
		</history>
	</properties>
	<io>
		<in>
			<file Path="TreeUDFs.cfm" Action="Include" comments="Just included CFML file" />
			<string name="divname" optional="Yes"/>
			<string name="parentclass" optional="Yes"/>
			<string name="mainulclass" optional="Yes"/>
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
<cfparam name="attributes.cfusion" default="no">

<cfif ThisTag.ExecutionMode is "Start">
	<cfif Not IsDefined("request.treeUDF")>
		<cfinclude template="TreeUDFs.cfm">
	</cfif>
	<cfif IsDefined("attributes.treename")><cfset attributes.name=attributes.treename></cfif>
</cfif>
<cfif ThisTag.ExecutionMode IS "End">
<cfscript>
if ( IsDefined("ThisTag.AssocAttribs") ) {
	qItems = arrayOfStructuresToQuery(ThisTag.AssocAttribs);
} else {
	qItems = QueryNew("display,value,parent,link,target,page");
}
if ( IsDefined("attributes.query") ) {
	qItems = Evaluate("Caller.#attributes.query#");
}
TreeQuery = makeBranches(qItems);
</cfscript><cfoutput><div id="#attributes.divname#"><ul id="#attributes.mainulclass#"></cfoutput><cfoutput query="TreeQuery"><cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] lt TreeQuery.nestLevel[CurrentRow+1]><li <cfif attributes.cfusion eq "yes">&gt;cfif url.page EQ "#page#" or pagenameParent EQ "#page#"&lt;class="active" &gt;/cfif&lt;</cfif>class="#attributes.parentclass#" id="#id#"><a href="#link#" target="#target#" id="#id#" title="#title#" >#display#</a><ul><cfelse><li id="#id#"<cfif attributes.cfusion eq "yes">&gt;cfif url.page EQ "#page#" or pagenameParent EQ "#page#"&lt;class="active" &gt;/cfif&lt;</cfif>><cfif link neq ""><a href="#link#" target="#target#" id="#id#" title="#title#" >#display#</a></cfif></li></cfif><cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] gt TreeQuery.nestLevel[CurrentRow+1]><cfset loopFrom = TreeQuery.nestLevel[CurrentRow+1]><cfset loopTo = TreeQuery.nestLevel[CurrentRow] - 1><cfloop index="nestDown" from="#loopFrom#" to="#loopTo#" step="1"></ul></li></cfloop></cfif><cfif CurrentRow eq RecordCount><cfloop index="nestDown" from="1" to="#nestLevel#" step="1"></ul></cfloop></cfif></cfoutput></div></cfif>