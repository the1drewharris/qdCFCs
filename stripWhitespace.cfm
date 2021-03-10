<!--stripWhitespace-->
<CFSETTING ENABLECFOUTPUTONLY="YES"><!--- Suspend whitespace output --->

  <!--- Make sure a closing tag exists in calling template --->
  <CFIF NOT ThisTag.HasEndTag>
    <CFABORT SHOWERROR="You need to supply a closing &lt;CF_FileWriteText&gt; tag.">
  </CFIF>  
  
  
  <!--- When the closing tag is encountered... --->
  <CFIF ThisTag.ExecutionMode is "End">
    <!--- Replace multiple whitespace characters with a single space --->
    <cfset ThisTag.GeneratedContent = ReplaceNoCase(ThisTag.GeneratedContent, Chr(13), " ", "ALL")>
		<CFSET ThisTag.GeneratedContent = REReplace(ThisTag.GeneratedContent, "[[:space:]]{2,}", " ", "ALL")> 
		<cfset ThisTag.GeneratedContent = ReplaceNoCase(ThisTag.GeneratedContent, "> <", "><", "ALL")>
  </CFIF>


<CFSETTING ENABLECFOUTPUTONLY="NO"><!--- Re-enable whitespace output --->



