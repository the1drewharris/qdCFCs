<!---
	
	This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0. For more information,
	please see the web site at:
		
		http://www.cflib.org
		
	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.
		
	License:
	This code may be used freely. 
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->

<cffunction name="convertTime" >
<cfargument name="date" required="yes" type="string">
<cfargument name="format" required="no" type="string">
<cfif mid(date,9,4) eq 2400>
	<cfset request.enddate = "#Left(date,4)#-#Mid(date,5,2)#-#Mid(date,7,2)#">
	<cfset request.endhour =  "23">
	<cfset request.endminute = "59">
	<cfset request.endsecond = "#Mid(date,13,2)#">
	<cfset newdate = "#request.enddate# #request.endhour#:#request.endminute#:00">
	<cfset newdate = "{ts '#newdate#'}">
<cfelse>
	<cfscript>
	request.enddate = "#Left(date,4)#-#Mid(date,5,2)#-#Mid(date,7,2)#";
	request.endhour =  "#Mid(date,9,2)#";
	request.endminute = "#Mid(date,11,2)#";
	request.endsecond = "#Mid(date,13,2)#";
	newdate = "#request.enddate# #request.endhour#:#request.endminute#:00";
	newdate = "{ts '#newdate#'}";
	</cfscript>
</cfif>
<cfscript>
if (isDefined('format'))
	newdate=#TimeFormat('#newdate#','#format#')#;
else
	newdate=#TimeFormat('#newdate#','hh:mm:ss')#;
</cfscript>
<cfreturn newdate>
</cffunction>