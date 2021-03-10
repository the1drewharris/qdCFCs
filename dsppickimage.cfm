<cfparam name="recordid" default="">
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
<tr> 
  	<td align="left" colspan="2" class="maintext">
		<!--- Message about which rows are being displayed --->
		Displaying <strong>#attributes.StartRow#</strong> to <strong>#EndRow#</strong> of <strong>#TotalRows#</strong> Records<BR>
	</td>
	<td align="right" colspan="3" class="maintext">
	    <CFIF NOT attributes.ShowAll>
        <!--- Provide Next/Back links --->
            <!--- Provide Next/Back links --->
			  <!--- Show Link for "Back", if appropriate --->
			  <CFIF StartRowBack GT 0>
				<A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&StartRow=#StartRowBack#&layout=popup" class="maintext">
			      <IMG SRC="#request.imagePath#BrowseBack.gif" WIDTH="40" HEIGHT="16" 
			        ALT="Back #RowsPerPage# Records" BORDER="0" CLASS="maintext"></A>
			  </CFIF>
			  <!--- Show Link for "Next", if appropriate --->
			  <CFIF StartRowNext LT TotalRows>
				<A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&StartRow=#StartRowNext#&layout=popup" class="maintext">
			      <IMG SRC="#request.imagePath#BrowseNext.gif" WIDTH="40" HEIGHT="16" 
			        ALT="Next #RowsPerPage# Records" BORDER="0" CLASS="maintext"></A>
			  </CFIF>
        </CFIF>
	</td>
</tr>
</table>
</cfoutput>
<form name=imageid>
<cfparam name="layout" default="popup">
<table width="100%" border="1" cellspacing="0" cellpadding="15" align="center">
	<cfloop query="getlistofimages" startrow="#attributes.startrow#" endrow="#endrow#">
		<cfset offset = getlistofimages.currentRow mod numberofcolumns>
		<cfif offset eq 0><cfset offset = numberofcolumns></cfif>
		<cfif offset eq 1><tr></cfif>
		<cfoutput>
			<td valign="top" align="center" class="intlhead">
				<a href="##" onClick="window.opener.document.myForm.imagealt.value = '#imagealt#'; window.opener.document.myForm.imageid.value = '#imageid#'; window.close();" class="maintext">
				<img src="#request.imagePath#catalog/small/#imagepath#" alt="#imagealt#" border="0">
				</a><br>#imagealt#
			</td>
		</cfoutput>
		<cfif offset eq numberofcolumns></tr></cfif>
	</cfloop>
	<cfif offset neq numberofcolumns><cfoutput>#RepeatString("<td>&nbsp;</td>", numberofcolumns - offset)#</cfoutput></cfif>
</table>
</form>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
	<td align="left" colspan="2" class="maintext">
  		<CFIF NOT attributes.ShowAll>
      			<!--- Shortcut links for "Pages" of search results --->
      			Page 
			<!--- Control Whitespace Output --->
			<CFSETTING ENABLECFOUTPUTONLY="Yes">
			
			<!--- Simple Page counter, starting at first "Page" --->
			<CFSET ThisPage = 1>
			
			<!--- Loop thru row numbers, in increments of RowsPerPage --->
			<CFLOOP FROM="1" TO="#TotalRows#" STEP="#RowsPerPage#" INDEX="PageRow">
			  <!--- Detect whether this "Page" currently being viewed --->
			  <CFSET IsCurrentPage = (PageRow GTE attributes.StartRow) AND (PageRow LTE EndRow)>
			  
			  <!--- If this "Page" is current page, show without link --->
			  <CFIF IsCurrentPage>
			    <strong>#ThisPage#</strong>
			  <!--- Otherwise, show with link so user can go to page  --->  
			  <CFELSE>
			    <A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&StartRow=#PageRow#&layout=popup" class="maintext">#ThisPage#</A>
			  </CFIF>
			
			  <!--- Increment ThisPage variable --->
			  <CFSET ThisPage = ThisPage + 1>
			</CFLOOP>
			
			<!--- Control Whitespace Output --->
			<CFSETTING ENABLECFOUTPUTONLY="No">
      			<!--- Show All link --->
					<cfif rowsperpage LT totalrows>
						<A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&ShowAll=Yes&layout=popup" class="maintext">Show All</A>
					</cfif>
    			</CFIF>
	</td>
	<td align="right" colspan="3" class="maintext" nowrap>
		<CFIF NOT attributes.ShowAll>
      			<!--- Provide Next/Back links --->
      			  <!--- Provide Next/Back links --->
			  <!--- Show Link for "Back", if appropriate --->
			  <CFIF StartRowBack GT 0>
				<A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&StartRow=#StartRowBack#&layout=popup" class="maintext">
			      <IMG SRC="#request.imagePath#BrowseBack.gif" WIDTH="40" HEIGHT="16" 
			        ALT="Back #RowsPerPage# Records" BORDER="0" CLASS="maintext"></A>
			  </CFIF>
			  <!--- Show Link for "Next", if appropriate --->
			  <CFIF StartRowNext LT TotalRows>
				<A HREF="#self#?fuseaction=#fusebox.thisCircuit#.#fusebox.fuseaction#&StartRow=#StartRowNext#&layout=popup" class="maintext">
			      <IMG SRC="#request.imagePath#BrowseNext.gif" WIDTH="40" HEIGHT="16" 
			        ALT="Next #RowsPerPage# Records" BORDER="0" CLASS="maintext"></A>
			  </CFIF>
    	</CFIF>
	</td>
</table>
</cfoutput>
