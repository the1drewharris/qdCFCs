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
 * Capitalizes the first letter in each word.
 * Made udf use strlen, rkc 3/12/02
 * 
 * @param string 	 String to be modified. 
 * @return Returns a string. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 1.1, March 12, 2002 
 */
function CapFirst(str) {
	var newstr = "";
	var word = "";
	var i = 1;
	var strlen = listlen(str," ");
	for(i=1;i lte strlen;i=i+1) {
		word = ListGetAt(str,i," ");
		newstr = newstr & UCase(Left(word,1));
		if(len(word) gt 1) newstr = newstr & Right(word,Len(word)-1);
		if(i lt strlen) newstr = newstr & " ";
	}
	return newstr;
}
</cfscript>
