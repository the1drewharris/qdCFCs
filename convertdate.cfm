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
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk. --->
<cfinclude template="/func/dateLetters.cfm">

<cffunction name="convertDate" >
<cfargument name="date" required="yes" type="string">
<cfargument name="format" required="no" type="string">
<cftry>
	<cfscript>
	request.enddate = "#Left(date,4)#-#Mid(date,5,2)#-#Mid(date,7,2)#";
	request.endhour =  "#Mid(date,9,2)#";
	request.endminute = "#Mid(date,11,2)#";
	request.endsecond = "#Mid(date,13,2)#";
	newdate = "#request.enddate# #request.endhour#:#request.endminute#:00";
	newdate = "{ts '#newdate#'}";
	if (isDefined('format') and findnocase("th",format) NEQ 0) {
		whattofind = findnocase("th",format) - 2;
		newdateFormat = #left('#format#','#whattofind#')#; 
		newdateFormatLeft = #DateFormat('#newdate#','#newdateFormat#')#;
		newdateFormat = #right(format,len(format) - whattofind - 3)#;
		newdateFormatRight = #DateFormat('#newdate#','#newdateFormat#')#;
		newdateFormat = newdateFormatLeft & dateLetters(newdate) & newdateFormatRight;
		newdate = newdateFormat; 
	} else {
		if (isDefined('format')) {
			newdate = #DateFormat('#newdate#','#format#')#;
		} else {
			newdate = #DateFormat('#newdate#','MM-DD-YY')#;
		}
	}
	</cfscript>
	<cfcatch type="any">
		<cfset tempDate = "1955010108000115">
		<cfscript>
			request.enddate = "#Left(tempDate,4)#-#Mid(tempDate,5,2)#-#Mid(tempDate,7,2)#";
			request.endhour =  "#Mid(tempDate,9,2)#";
			request.endminute = "#Mid(tempDate,11,2)#";
			request.endsecond = "#Mid(tempDate,13,2)#";
			newdate = "#request.enddate# #request.endhour#:#request.endminute#:00";
			newdate = "{ts '#newdate#'}";
			if (isDefined('format') and findnocase("th",format) NEQ 0) {
				whattofind = findnocase("th",format) - 2;
				newdateFormat = #left('#format#','#whattofind#')#; 
				newdateFormatLeft = #DateFormat('#newdate#','#newdateFormat#')#;
				newdateFormat = #right(format,len(format) - whattofind - 3)#;
				newdateFormatRight = #DateFormat('#newdate#','#newdateFormat#')#;
				newdateFormat = newdateFormatLeft & dateLetters(newdate) & newdateFormatRight;
				newdate = newdateFormat; 
			} else {
				if (isDefined('format')) {
					newdate = #DateFormat('#newdate#','#format#')#;
				} else {
					newdate = #DateFormat('#newdate#','MM-DD-YY')#;
				}
			}
		</cfscript>
	</cfcatch>
</cftry>

<cfreturn newdate>
</cffunction>