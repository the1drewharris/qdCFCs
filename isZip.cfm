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
 * Tests passed value to see if it is a properly formatted U.S. zip code.
 * 
 * @param str 	 String to be checked. (Required)
 * @return Returns a boolean. 
 * @author Jeff Guillaume (&#106;&#101;&#102;&#102;&#64;&#107;&#97;&#122;&#111;&#111;&#109;&#105;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, May 8, 2002 
 */
function isZipUS(str) {
	return REFind('^[[:digit:]]{5}(( |-)?[[:digit:]]{4})?$', str); 
}
</cfscript>
