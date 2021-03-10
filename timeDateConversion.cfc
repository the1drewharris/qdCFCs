<cfcomponent hint="I provide all of the funtions related to time and date conversions">
	
	<cffunction name="createTimeDate" access="remote" output="false" returntype="string" hint="I return the current server date and time in yyyymmddhhmmssTC format (16 chars)">
		<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfreturn timedate>
	</cffunction>
	
	<cffunction name="convertDate" access="public" returntype="string" hint="I convert string date to real date">
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
	
	<cffunction name="dateToInt" access="remote">
		<cfargument name="date" required="true" type="string">
		<cfargument name="hours" required="false" type="string" default="00">
		<cfargument name="minutes" required="false" type="string" default="00">
		<cfargument name="ampm" required="false" type="string" default="am">
		<!--- trim leading and trailing spaces passed in --->
		<cfset date=trim(date)>
		<cfset date=Dateformat(date,"mm/dd/YYYY")>
		<cfset hours=trim(hours)>
		<cfset minutes=trim(minutes)>
		<cfset ampm=trim(ampm)>
		<!--- begin the function --->
		<cfset time = right(date,4)>
		<cfset time = time & left(date,2)>
		<cfset time = time & mid(date,4,2)>
		<cfif ampm EQ "pm" AND hours lt 12>
			<cfset hours = hours + 12>
		<cfelseif ampm EQ "am" and hours EQ 12>
			<cfset hours = "00">
		</cfif>
		<cfset time = time & hours>
		<cfset time = time & minutes>
		<cfset time = time & "0000">
		
		<cfreturn time>
	</cffunction>
	
	<cffunction name="convertTime"access="remote" >
		<cfargument name="date" required="yes" type="string">
		<cfargument name="format" required="no" type="string">
		<cfscript>
		request.enddate = "#Left(date,4)#-#Mid(date,5,2)#-#Mid(date,7,2)#";
		request.endhour =  "#Mid(date,9,2)#";
		request.endminute = "#Mid(date,11,2)#";
		request.endsecond = "#Mid(date,13,2)#";
		newdate = "#request.enddate# #request.endhour#:#request.endminute#:00";
		newdate = "{ts '#newdate#'}";
		if (isDefined('format'))
			newdate = #TimeFormat('#newdate#','#format#')#;
		else
			newdate = #TimeFormat('#newdate#','hh:mm:ss')#;
		</cfscript>
		<cfreturn newdate>
	</cffunction>
	
	<cffunction name="dateDifference" access="public" output="false" returntype="string" 
		hint="Determines the integer number of units by which date1 is less than date2.">
		<cfargument name="datepart" required="true" hint="String that specifies the units in which to count; for example yyyy requests a 
			date difference in whole years. (yyyy: Years, q: Quarters, m: Months, y: Days of year (same as d), d: Days, 
			w: Weekdays (same as ww), ww: Weeks, h: Hours, n: Minutes, s: Seconds">
		<cfargument name="date1" requited="true" hint="QuantumDelta Time/Date stamp">
		<cfargument name="date2" required="true" hint="QuantumDelta Time/Date stamp">
		
		<cfset date1 = "{ts '#convertDate(arguments.date1,'yyyy-mm-dd')# #convertTime(arguments.date1,'HH:mm:ss')#'}">
		<cfset date2 = "{ts '#convertDate(arguments.date2,'yyyy-mm-dd')# #convertTime(arguments.date2,'HH:mm:ss')#'}">
		<cfset dateDiffStr = DateDiff(arguments.datepart,date1,date2)>
		
		<cfreturn dateDiffStr>
	</cffunction>

	<cffunction name="hoursOfOperationToMilTime" access="public" hint="I convert hours of operation to miltary Time. Output: Structure with elements opentime and closetime" returntype="struct">
		<cfargument name="starthour" required="true" type="String"> 
		<cfargument name="startmin" required="true" type="String"> 
		<cfargument name="startampm" required="true" type="String">
		<cfargument name="endhour" required="true" type="String">
		<cfargument name="endmin" required="true" type="String">
		<cfargument name="endampm" required="true" type="String"> 	
		
		<cfif startampm EQ "PM">
			<cfset starthour = starthour + 12>
		</cfif> 
		
		<cfif endampm EQ "PM">
			<cfset endhour = endhour + 12>
		</cfif>
		
		<cfset opentime = "#starthour##startmin#">
		<cfset closetime = "#endhour##endmin#">
		<cfset hoursofop=structnew()>
		<cfset hoursofop.opentime=opentime>
		<cfset hoursofop.closetime=closetime>
		<cfreturn hoursofop>
	</cffunction>
	
	<cffunction name="stringToDate" access="remote">
		<cfargument name="date" required="yes" type="string">
		<cfscript>
			request.enddate = "#Left(date,4)#-#Mid(date,5,2)#-#Mid(date,7,2)#";
			request.endhour =  "#Mid(date,9,2)#";
			request.endminute = "#Mid(date,11,2)#";
			request.endsecond = "#Mid(date,13,2)#";
			newdate = "#request.enddate# #request.endhour#:#request.endminute#:00";
			newdate = "{ts '#newdate#'}";
		</cfscript>
		<cfreturn newdate>
	</cffunction>

	<cffunction name="getdatepart" access="public" returntype="string" hint="I get part of a date">
		<cfargument name="strdate" type="String" required="true" hint="I am the string date">
		<cfargument name="datepart" type="string" required="true" hint="I am a part of date that needs to be returned. values can be, year, month, day, hr, mins, sec, ms">
		<cfswitch expression="#arguments.datepart#">
			<cfcase value="yyyy">
				<cfset part=Mid(strdate,1,4)>
			</cfcase>
			<cfcase value="m">
				<cfset part=Mid(strdate,5,2)>
			</cfcase>
			<cfcase value="d">
				<cfset part=Mid(strdate,7,2)>
			</cfcase>
			<cfcase value="h">
				<cfset part=Mid(strdate,9,2)>
			</cfcase>
			<cfcase value="n">
				<cfset part=Mid(strdate,11,2)>
			</cfcase>
			<cfcase value="s">
				<cfset part=Mid(strdate,13,2)>
			</cfcase>
			<cfcase value="ms">
				<cfset part=Mid(strdate,15,2)>
			</cfcase>
			<cfdefaultcase>
				<cfset part="error">
			</cfdefaultcase>>
		</cfswitch>
		<cfreturn part>
	</cffunction>
	
	<cffunction name="getDateDiffSentence" hint="I return a string with a common language sentence stating how long ago two dates are from one another">
		<cfargument name="date1" required="true" hint="Start date to compare">
		<cfargument name="date2" required="false" hint="End date to compare, defaults to now" default="#createTimeDate()#">
		<cfset var timeAgo = "">
		
		<cfoutput>
		<cfsavecontent variable="timeAgo">
		<cfswitch expression="#dateDifference('d',date1,arguments.date2)#">
			<cfcase value="0">
				<cfswitch expression="#dateDifference('h',arguments.date1,arguments.date2)#">
				<cfcase value="0">
					<cfset minutes = dateDifference('n',arguments.date1,arguments.date2)>
					<cfif minutes GT 0>
						about #minutes# minute<cfif minutes NEQ 1>s</cfif> ago
					<cfelse>
						less than 1 minute ago
					</cfif>
				</cfcase>
				<cfcase value="1">
					about #dateDifference('h',arguments.date1,arguments.date2)# hour ago
				</cfcase>
				<cfdefaultcase>
					about #dateDifference('h',arguments.date1,arguments.date2)# hours ago
				</cfdefaultcase>
			</cfswitch>
			</cfcase>
			<cfdefaultcase>
				<cfswitch expression="#dateDifference('d',arguments.date1,arguments.date2)#">
					<cfcase value="1,2,3,4,5,6">
						<cfset days = int(dateDifference('h',arguments.date1,arguments.date2) / 24)>
						<cfset hours = dateDifference('h',arguments.date1,arguments.date2) MOD 24>
						about #days# day<cfif days GT 1>s</cfif> <cfif hours GT 0>and #hours# hour<cfif hours GT 1>s</cfif></cfif> ago
					</cfcase>
					<cfdefaultcase>
						<cfswitch expression="#dateDifference('m',arguments.date1,arguments.date2)#">
							<cfcase value="0">
								<cfswitch expression="#dateDifference('w',arguments.date1,arguments.date2)#">
									<cfcase value="1">
										about #dateDifference('w',arguments.date1,arguments.date2)# week ago
									</cfcase>
									<cfcase value="2,3,4,5">
										about #dateDifference('w',arguments.date1,arguments.date2)# weeks ago
									</cfcase>
								</cfswitch>
							</cfcase>
							<cfcase value="1">
								about #dateDifference('m',arguments.date1,arguments.date2)# month ago
							</cfcase>
							<cfdefaultcase>
								about #dateDifference('m',arguments.date1,arguments.date2)# month ago
							</cfdefaultcase>
						</cfswitch>
					</cfdefaultcase>
				</cfswitch>
			</cfdefaultcase>
		</cfswitch>
		</cfsavecontent>
		</cfoutput>
		
		<cfreturn timeAgo>
	</cffunction>
	<cffunction name="unixtimetodatestring" access="public" returntype="string" hint="I convert unix time stamp to string date">
		<cfargument name="unixtimestamp" required="true" type="string" hint="unix time stamp">
		<cfset mytime=dateAdd("s",unixtimestamp,"01/01/1970")>
		<cfset strtime="#Dateformat(mytime,'yyyymmdd')##timeformat(mytime,'HHmmss')#00">
		<cfreturn strtime>
	</cffunction>
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

	<cffunction name="stringDateToDateStruct" access="public" returntype="struct" hint="I take date string and input and return the structure containing date{yyyy-mm-dd}, hh{01-12}, mm{00,59}, ampm{AM,PM}">
		<cfargument name="stringdate" required="true" type="string" hint="16 character long date string">
		<cfset datestruct=structNew()>
		<cfset datestruct.date=convertdate(arguments.stringdate,"mm/dd/yyyy")>
		<cfset hh=Mid(arguments.stringdate,9,2)>
		<cfif hh GT 12>
			<cfset hh=hh-12>
			<cfif hh LT 10>
				<cfset datestruct.hh="0#hh#">
			<cfelse>
				<cfset datestruct.hh=hh>
			</cfif>
			<cfset datestruct.ampm="PM">
		<cfelseif hh EQ 12>
			<cfset datestruct.hh=hh>
			<cfset datestruct.ampm="PM">
		<cfelse>
			<cfif hh EQ '00'>
				<cfset datestruct.hh="12">
			<cfelse>
				<cfset datestruct.hh="#hh#">
			</cfif>
			<cfset datestruct.ampm="AM">
		</cfif>
		<cfset datestruct.mm=Mid(arguments.stringdate,11,2)>
		<cfreturn datestruct>
	</cffunction>
</cfcomponent>