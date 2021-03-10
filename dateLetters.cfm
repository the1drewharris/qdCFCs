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
 * Add's the st,nd,rd,th after a day of the month.
 * 
 * @param dateStr 	 Date to use. (Required)
 * @param formatStr 	 Format string for month and year. (Optional)
 * @return Returns a string. 
 * @author Ian Winter (&#105;&#97;&#110;&#64;&#100;&#101;&#102;&#117;&#115;&#105;&#111;&#110;&#120;&#46;&#111;&#109;) 
 * @version 1, May 22, 2003 
 */
function dateLetters(dateStr) {
	var letterList="st,nd,rd,th";
	var domStr=DateFormat(dateStr,"d");
	var domLetters='';
	var formatStr = "";

	if(arrayLen(arguments) gte 2) formatStr = dateFormat(dateStr,arguments[2]);

	switch (domStr) {
		case "1": case "21": case "31":  domLetters=ListGetAt(letterList,'1'); break;
		case "2": case "22": domLetters=ListGetAt(letterList,'2'); break;
		case "3": case "23": domLetters=ListGetAt(letterList,'3'); break;
		default: domLetters=ListGetAt(letterList,'4');
	}

	return trim(domStr & domLetters & " " & formatStr);
}
</cfscript>
