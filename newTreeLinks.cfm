<!--- --> 
 <fusedoc fuse="Tree.cfm"  language="coldfusion"  specification="2.0">
	<responsibilities>
		I provide a tree like cftree, except I am html and JavaScipt.
		I get all of my tree items from a table in a database called tree.
		I am meant to be displayed in a form.
		I can provide the client with multiple select by means of checkboxes, or I can provide the user with single select by means of radiobutton, the default is single select.
	</responsibilities>
	<properties>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="23-Apr-2003" type="Create"/>
		<history email="steve@bryantwebconsulting.com" author="Steve Bryant" date="23-Apr-2003" type="Create" role="Architect">
			This is a rewrite of Drew's original work.
			This version will reduce the need for external files.
			It will also eliminate the need for a database to use cf_tree.
		</history>
		<history email="drew@quantumdelta.com" author="Drew Harris" date="21-Nov-2003" type="Update">
			I added the CSS to Bold the parent type items that are expandable.
			I also added the CheckStatus back so you can have items in your tree control checked by default.
		</history>
	</properties>
	<io>
		<in>
			<file Path="TreeUDFs.cfm" Action="Include" comments="Just included CFML file" />
			<string name="divname" optional="Yes"/>
			<string name="parentclass" optional="Yes"/>
			<string name="mainulclass" optional="Yes"/>
			<string name="Name" />
			<boolean name="MultipleSelect" optional="Yes" />
			<string name="CheckStatus" optional="yes" />
			<string name="message" comment="Not Used" />
			<string name="align" comment="Not Used" />
			<string name="delimiter" optional="Yes" comment="Not Used" />
			<number name="height" comment="Not Used" />
			<number name="width" comment="Not Used" />
			<number name="vspace" comment="Not Used" />
			<number name="hspace" comment="Not Used" />
			<string name="Font" optional="Yes" comment="Not Used" />
			<number name="FontSize" optional="Yes" comment="Not Used" />
			<boolean name="Bold" optional="Yes" comment="Not Used" />
			<boolean name="Italic" optional="Yes" comment="Not Used" />
			<boolean name="border" optional="Yes" comment="Not Used" />
			<boolean name="hscroll" optional="Yes" comment="Not Used" />
			<boolean name="vscroll" optional="Yes" comment="Not Used" />
			<boolean name="required" optional="Yes" comment="Not Used" />
			<boolean name="completepath" optional="Yes" comment="Not Used" />
			<boolean name="appendkey" optional="Yes" comment="Not Used" />
			<boolean name="highlighthref" optional="Yes" comment="Not Used" />
		</in>
		<out>
			<string name="#attributes.name#" scope="formorurl" optional="Yes" />
		</out>
	</io>
</fusedoc>
--->
<cfif not IsDefined("ThisTag.ExecutionMode")>
<cfexit>
</cfif>
<!--- Param attributes --->
<cfparam name="attributes.MultipleSelect" type="boolean" default="0">
<cfparam name="attributes.CheckStatus" default="0">
<cfparam name="attributes.divname" default="tree">
<cfparam name="attributes.linkPrefix" default="">
<cfparam name="attributes.linkBefore" default="true">
<cfparam name="attributes.idName" default="id">
<cfparam name="attributes.linkText" default="Go!">
<cfparam name="attributes.parentclass" default="0">
<cfparam name="attributes.mainulclass" default="0">
<cfparam name="attributes.expand" default="0">
<cfif ThisTag.ExecutionMode is "Start">
	<cfif Not IsDefined("request.TreeUDF")>
		<cfinclude template="TreeUDFs.cfm">
	</cfif>
	<cfif IsDefined("attributes.treename")><cfset attributes.name=attributes.treename></cfif>
</cfif>
<cfif ThisTag.ExecutionMode IS "End">

<cfoutput>
<style>
<!--
ul li.parentitem {
	cursor: pointer;
	text-decoration:none;
}
//-->
</style>
</cfoutput><script language="JavaScript1.2">

function expandBranch(txtChildBranch) {
	var childBranch;
	
	if (document.all) {
		childBranch = document.all[txtChildBranch];
	} else {

		childBranch = document.getElementById(txtChildBranch);		
	}

	
	if (childBranch.style.display=="none") {
		childBranch.style.display='';
	} else {
		childBranch.style.display="none";
	}
}
//-->
</script>
<cfscript>
CheckStatus = "#attributes.CheckStatus#";
if ( IsDefined("ThisTag.AssocAttribs") ) {
	qItems = arrayOfStructuresToQuery(ThisTag.AssocAttribs);
} else {
	qItems = QueryNew("display,value,parent,img,checkstatus,selectable,itemclass");
}
if ( IsDefined("attributes.query") ) {
	qItems = Evaluate("Caller.#attributes.query#");
}
TreeQuery = makeBranches(qItems);

if ( attributes.MultipleSelect ) {
	SelectType = "Checkbox";
} else {
	SelectType = "Radio";
}
</cfscript>
<cfoutput>
<ul <cfif attributes.mainulclass neq "0">class="#attributes.mainulclass#"</cfif>></cfoutput>
<cfoutput query="TreeQuery">
<cfsavecontent variable="link">	
	<cfif Len(selectable) and selectable>
	<a href="#attributes.linkPrefix#?#attributes.idName#=#value#">#attributes.linkText#</a>
	</cfif>
</cfsavecontent>
<cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] lt TreeQuery.nestLevel[CurrentRow+1]>
<li class="parentitem"><cfif attributes.linkBefore EQ true>#link#</cfif><a title="click to expand/collapse tree" id="Tree_#attributes.name#_#CurrentRow#" onclick="expandBranch('Tree_#attributes.name#_#CurrentRow#_Child')"><img src="http://spiderwebmaster.net/images/plus.gif" border="0" />&nbsp;<span class="#itemclass#">#display#</span></a><cfif attributes.linkBefore EQ false>#link#</cfif></li>
<ul id="Tree_#attributes.name#_#CurrentRow#_Child" <cfif attributes.expand eq "0">style="display:none;"</cfif>>
<cfelse>
	<li><cfif attributes.linkBefore EQ true>#link#</cfif><cfif Len(Img)><img src="#Img#" border="0" alt="#Display#"></cfif>&nbsp;<span class="#itemclass#">#Display#</span><cfif attributes.linkBefore EQ false>#link#</cfif></li><!--- <a href="#href#">#display#</a> --->
</cfif>
<cfif CurrentRow neq RecordCount AND TreeQuery.nestLevel[CurrentRow] gt TreeQuery.nestLevel[CurrentRow+1]>
	<cfset loopFrom = TreeQuery.nestLevel[CurrentRow+1]>
	<cfset loopTo = TreeQuery.nestLevel[CurrentRow] - 1>
	<cfloop index="nestDown" from="#loopFrom#" to="#loopTo#" step="1"></ul></cfloop>
</cfif>
<cfif CurrentRow eq RecordCount>
<cfloop index="nestDown" from="1" to="#nestLevel#" step="1"></ul></cfloop>
</cfif>
</cfoutput>
</ul>
</cfif>