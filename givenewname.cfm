<!--- 
<fusedoc language="ColdFusion 6.1" specification="2.0" fuse="act_strippagename.cfm">
	<responsibilities> 
		I strip out all special chars, replace spaces with underscores, and strip down the size if larger than 32 chars and therefore give a new name.
	</responsibilities>
	<properties>
		<history author="Drew Harris"  email="drew@quantumdelta.com" role="Architect" type="Create"	 date="20061027"/>	
	</properties>
	<io>
		<in>
			<string name="dsn" scope="url" optional="Yes"/>
			<string name="siteurl" scope="url" optional="Yes"/>
		</in>
		<out>
			<string scope="variables" name="whatever" optional="No" comments="whatever"/>
		</out>
	</io>
</fusedoc> 
--->
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

<cfscript>
/**
 * Strips all characters from a string except the ones that you want to keep.
 * 
 * @param strSource 	 The string to strip. (Required)
 * @param strKeep 	 List of  characters to keep. (Required)
 * @param beCS 	 Boolean that determines if the match should be case sensitive. Default is true. (Optional)
 * @return Returns a string. 
 * @author Scott Jibben (scott@jibben.com) 
 * @version 1, July 2, 2002 
 */
function stripAllBut(str,strip) {
	var badList = "\";
	var okList = "\\";
	var bCS = true;

	if(arrayLen(arguments) gte 3) bCS = arguments[3];

	strip = replaceList(strip,badList,okList);
	
	if(bCS) return rereplace(str,"[^#strip#]","","all");
	else return rereplaceNoCase(str,"[^#strip#]","","all");
}
</cfscript>

<cffunction name="givenewname" >
<cfargument name="name" required="yes" type="string">
<!--- I am used to strip page names down to fit. --->
<cfset lowername = "#lcase(arguments.name)#">
<cfset newname = "#StripAllBut(lowername, "1234567890abcdefghijklmnopqrstuvwxyz_ ")#">
<cfif FindNoCase(" ", "#newname#")>
	<cfset newname = "#ReplaceNoCase(newname, " ", "_", "ALL")#">
</cfif>
<cfif len(#newname#) gt 31>
	<cfif mid(#newname#, 31, 1) eq "_">
		<cfset newname = "#left(newname, 31)#">
	<cfelse>
		<cfset newname = "#left(newname, 32)#">
	</cfif> 
</cfif>
<cfreturn newname>
</cffunction>