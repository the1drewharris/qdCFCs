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
 * Simple Validation for Phone Number syntax.
 * version 2 by Ray Camden - added 7 digit support
 * version 3 by Tony Petruzzi &#84;&#111;&#110;&#121;&#95;&#80;&#101;&#116;&#114;&#117;&#122;&#122;&#105;&#64;&#115;&#104;&#101;&#114;&#105;&#102;&#102;&#46;&#111;&#114;&#103;
 * 
 * @param valueIn 	 String to check. (Required)
 * @return Returns a boolean. 
 * @author Alberto Genty (&#84;&#111;&#110;&#121;&#95;&#80;&#101;&#116;&#114;&#117;&#122;&#122;&#105;&#64;&#115;&#104;&#101;&#114;&#105;&#102;&#102;&#46;&#111;&#114;&#103;&#97;&#103;&#101;&#110;&#116;&#121;&#64;&#104;&#111;&#117;&#115;&#116;&#111;&#110;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 3, September 24, 2002 
 */
function IsValidPhone(valueIn) {
 	var re = "^(([0-9]{3}-)|\([0-9]{3}\) ?)?[0-9]{3}-[0-9]{4}$";
 	return	ReFindNoCase(re, valueIn);
}
</cfscript>
