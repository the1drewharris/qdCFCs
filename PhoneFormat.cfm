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
 * Allows you to specify the mask you want added to your phone number.
 * v2 - code optimized by Ray Camden
 * 
 * @param varInput 	 Phone number to be formatted. (Required)
 * @param varMask 	 Mask to use for formatting. x represents a digit. (Required)
 * @return Returns a string. 
 * @author Derrick Rapley (adrapley@rapleyzone.com) 
 * @version 1, November 14, 2002 
 */
function PhoneFormat (varInput, varMask) {
	var curPosition = "";
	var newFormat = "";
	var i = "";
	
	newFormat = " " & reReplace(varInput,"[^[:digit:]]","","all");

	for (i=1; i lte len(trim(varmask)); i=i+1) {
		curPosition = mid(varMask,i,1);
		if(curPosition neq "x") newFormat = insert(curPosition,newFormat, i) & " ";
	}

	return trim(newFormat);
}
</cfscript>
