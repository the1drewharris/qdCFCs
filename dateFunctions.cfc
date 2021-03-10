<cfcomponent>
	<cffunction name="convertDate">
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
	<cffunction name="convertTime">
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
			newdate = #TimeFormat('#newdate#','#format#')#;
		else
			newdate = #TimeFormat('#newdate#','hh:mm:ss')#;
		</cfscript>
		<cfreturn newdate>
	</cffunction>
</cfcomponent>