<!--- -->
|| BEGIN FUSEDOC ||
	
|| Properties ||
Name:  tree.cfm 
Author:  Drew Harris (drewh@pennwell.com)

|| Responsibilities ||
I provide a tree like cftree, except I am html and JavaScipt.
I get all of my tree items from a table in a database called tree.
I am meant to be displayed in a form.
I can provide the client with multiple select by means of checkboxes, or I can provide the user with single select by means of radiobutton, the default is single select.

WARNING:
When you use this tree, you can not have any top level items without children.

|| Attributes ||
==> name: A string
==> (Font: A font)
==> (FontSize: A size)
==> (Italic: A Boolean)
==> (Bold: A Boolean)
==> (required: a Boolean)
==> (delimiter: a string)
==> (MultipleSelect: a Boolean)
<== treeitem: a form variable, can be multiple items in a comma delimited list

|| END FUSEDOC ||
--->


<cftry>
	<cfparam name="attributes.name">
	<cfcatch>
		There was a fatal error. The attributes.name is not present.
		<cfabort>
	</cfcatch>
</cftry>
<!--- Not all of these are currently being used in this version --->
<cfparam name="attributes.Font" default="TimesNewRoman">
<cfparam name="attributes.FontSize" default="12">
<cfparam name="attributes.Italic" default="No">
<cfparam name="attributes.Bold" default="No">
<cfparam name="attributes.Required" default="No">
<cfparam name="attributes.Delimiter" default="/">
<cfparam name="attributes.MultipleSelect" default="No"> 


<cfinclude template="tree/style.cfm"> 

<UL>

<!--- I select the top level of tree items. --->
<cfinclude template="tree/queries/qrySelectTopLevel.cfm">

	<!--- I check to make sure there is at least one top level item --->
	<cfif #qrySelectTopLevel.RecordCount# eq 0>
		<strong>ERROR!
		<br>You must have at least one "top level item" (an item without a parent) in your tree for this tag to work properly!
		</strong>
	</cfif>
<!--- || I am the first top level item, the first item with a parent of zero || --->
<!--- I set a variable equal to the first item of the query above --->
<cfoutput query="qrySelectTopLevel" maxrows="1">
<cfset item.value = "#ITEMVALUE#">
</cfoutput>

<!--- I select the data on the current item --->
<cfinclude template="tree/queries/qrySelectCurrentItem.cfm">

<!--- This is where I first begin to display the tree --->
<cfinclude template="tree/dspSelectCurrentItem.cfm">

<!--- I set the path variable for the item that was just displayed --->
<cfset item.path = #item.value#>

<!--- I update the path field in the database. --->
<cfinclude template="tree/queries/qryUpdatePath.cfm">

<!--- I set a variable called exhausted equal to zero before the loop --->
<cfset exhausted = 0>

<!--- I select all items in the tree --->
<cfinclude template="tree/queries/qryAllItems.cfm">

<!---I set a variable called AllItems equal the recordcount of qryAllItems --->
<cfset AllItems = #qryAllItems.RecordCount#>

<!--- Loop until all items are exhausted --->
<cfloop condition="#exhausted# LESS THAN #AllItems#">

<!--- I find the length of the item.path list --->
<cfset path.length = ListLen(#item.path#, "/")>

<!--- I must first check to see if there are any other top level items --->
<!--- I am a safeguard if statement that will fire whenever a tree will have more than one top level item --->
<cfif path.length eq 0>
		<!--- I select the top level of tree items. --->
		<cfinclude template="tree/queries/qrySelectTopLevel.cfm">
		
		<!--- I check to make sure there is at least one top level item --->
			<cfif #qrySelectTopLevel.RecordCount# eq 0>
				<br>
				<strong>
				<font color="Red">
				ERROR!
				<br>
				This should never happen!  Please contact your Administrator with any other errors on this page!
				</font>
				</strong>
			</cfif>
			
		<!--- I set a variable equal to the first item of the query above --->
		<cfoutput query="qrySelectTopLevel" maxrows="1">
		<cfset item.value = "#ITEMVALUE#">
		</cfoutput>
		
		<!--- I select the data on the current item 	--->
		<cfinclude template="tree/queries/qrySelectCurrentItem.cfm">
		
		<!--- This is where I first begin to display the tree --->
		<cfinclude template="tree/dspSelectCurrentItem.cfm">
		
		<!--- I set the path variable for the item that was just displayed --->
		<cfset item.path = #item.value#>
		
		<!--- I update the path field in the database. --->
		<cfinclude template="tree/queries/qryUpdatePath.cfm">
</cfif>


<!--- I check to see if the current item has any children that are not exhausted --->
<cfinclude template="tree/queries/qryAnyChildren.cfm">
<cfif #qryAnyChildren.RecordCount# Neq 0>
		<cfoutput query="qryAnyChildren" maxrows="1">
		<cfset item.currentitem = "#ITEMVALUE#">
		</cfoutput>

<!--- I check to see if the current item has any children at all --->
<cfinclude template="tree/queries/qryAreThereAnyChildren.cfm">

	<!--- If the above query finds that an item has at least one child I will write run a query that will write "Yes" to the children field of the tree table --->
	<!--- If this item has children that at all --->
	<cfif #qryAreThereAnyChildren.RecordCount# Neq 0>
		<!--- I write "Yes" to the children field of the tree table --->
		<cfinclude template="tree/queries/qryWriteChildren.cfm">
	</cfif>

	<cfinclude template="tree/queries/qrySelectItemCurrentItem.cfm">
	
	<!--- I provide much code and logic, you'd better take a look at me --->
	<cfinclude template="tree/actSelectItemCurrentItem.cfm">
	
	<!--- I append the previous path with the new value of the current item --->
	<cfset item.path = listappend(item.path, #item.value#, "/")>
	
	
	<!--- I update the path in the tree table for the new current item --->
	<cfinclude template="tree/queries/qryUpdatePath.cfm">
	

<!--- If the item has no children or no more children that have been exhausted --->
<cfelse>
	
	<!--- I find the length of the item.path list --->
	<cfset path.length = ListLen(#item.path#, "/")>
	
	<!--- I remove the last item from the item path variable because I need to move up the tree one level --->
	<cfset item.path = ListDeleteAt(#item.path#, #path.length#, "/")>
	
	<!--- I change the exhausted field to yes, because there are no more children for this item. --->
	<cfinclude template="tree/queries/qryItemExhausted.cfm">
	
	<!--- I check to see if the current item has any children --->
	<cfinclude template="tree/queries/qryItemAnyChildren.cfm">
	
	<!--- If the above query returns a recordset, I am an Item with children, the above query will also select all my children ---->
	<cfif #qryItemAnyChildren.RecordCount# Neq 0>
		
		<!--- Are all my children exhausted? 
		 If I am exhausted at this point, all my children are exhausted.
	      I will close the List for this item --->
		</ul>
		
	</cfif>
	
	<!--- I increment the value of exhausted by one, because now there is one more item that is exhausted --->
	<cfset exhausted = #exhausted#+1>
	
	<!--- I set the current item to the previous item.--->
	<cfset item.value = ListLast(#item.path#, "/")>
	
	<!--- I update the path in the tree table for the new current item --->
	<cfinclude template="tree/queries/qryUpdatePath.cfm">

</cfif> 

<!--- End loop --->
</cfloop> 
</ul>
</UL>
<!--- 
This file is sets a cookie so the tree will remember where you were
<cfinclude template="tree/script2.cfm"> 
--->