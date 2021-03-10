<!--- 
|| BEGIN FUSEDOC ||

|| Responsibilities ||
I populate a tree created with the new TREE custom replacement tag.
All ID's (Values) must be unique!

|| Properties ||
Name:  treeitem.cfm 
Author:  Drew Harris (drewh@pennwell.com)

|| ATTRIBUTES ||
==> attributes.Display: a string
==> attributes.Value: a string
==> (attributes.Parent: a string)
==> (attributes.Img: Path to an image)
==> (attributes.checkstatus: a string) if set to yes the item will be checked as a default when the tree loads.


|| END FUSEDOC ||
--->

<cftry>
	<cfparam name="attributes.display">
	<cfparam name="attributes.value">
	
	<cfcatch>
		There was a fatal error. Either the attributes.display, client.userid, and/or attributes.value is not present.
		<cfabort>
	</cfcatch>
</cftry>

<!--- If a parent has not been defined, I will set it equal to zero --->
<cfparam name="attributes.Parent" default="0">

<!--- If an image has not been defined, I will set it equal to zero --->
<cfparam name="attributes.Img" default="0">

<!--- If an image has not been defined, I will set it equal to Yes --->
<cfparam name="attributes.selectable" default="Yes">

<!--- If an image has not been defined, I will set it equal to No --->
<cfparam name="attributes.checkstatus" default="No">

<cfinclude template="tree/queries/QryInsertItem.cfm">  