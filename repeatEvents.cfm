
<cffunction name="repeatEvents">
<cfargument name="start" required="yes" type="string" hint="The date that the recursion begins at.">
<cfargument name="end" required="yes" type="string" hint="The end date that the recursion begins at.">
<cfargument name="repeat" required="yes" type="string">
<cfargument name="repeatend" required="yes" type="string">
<cfargument name="until" required="yes" type="string">
<cfargument name="endafter" required="yes" type="string">

<cfset curmonth = #convertDate(start,"mm")#>
<cfset curday = #convertDate(start,"dd")#>
<cfset curyear = #convertDate(start,"yyyy")#>
<cfset curtime = #convertTime(start,"HHmmss")#>
<cfset curendtime = #convertTime(end,"HHmmss")#>
<cfset curendday = #convertDate(end,"dd")#>
<cfset curendmonth = #convertDate(end,"mm")#>
<cfset curendyear = #convertDate(end,"yyyy")#>
<cfset stopmonth = #convertDate(until,"mm")#>
<cfset stopday = #convertDate(until,"dd")#>
<cfset stopyear = #convertDate(until,"yyyy")#>
<cfset numYears = 0>
<cfset numDays = 1>
<cfset actualYears = 1>
<cfset numMonths = 1>

<cfset diffYear = curendyear - curyear>
<cfset diffMonth = curendmonth - curmonth>
<cfset diffDay = curendday - curday>

<cfif stopyear NEQ curyear>
	<cfset stop = stopyear & "." & stopmonth>
	<cfset current = curyear & "." & curmonth>
	<cfset actualYears = stop - current>
	<cfset numYears = Fix(actualYears)>
</cfif>

<!---This loop finds out the number of times to loop for years --->
<cfset tempYears = 0>
<cfset tempMonth = curMonth>
<cfset tempYear = curYear>
<cfloop from="1" to="#numYears#" index="i">
	<cfset request.date = #CreateDate(tempYear, tempMonth, 1)#>
	<cfset maxDay = DaysInMonth(request.date)>
	<cfif maxDay GTE curday AND i NEQ numMonths>
		<cfset tempYears = tempYears + 1>
	<cfelseif i EQ numYears and stopday EQ curday>
		<cfset tempYears = tempYears + 1>
	</cfif>
	<cfset tempYear = tempYear + 1>
</cfloop>
<cfset numYears = tempYears>

<cfset numMonths = (numYears * 12) + (stopmonth - curmonth) + 1>

<!---This loop finds out the number of times to loop for months --->
<cfoutput>
<cfset tempMonths = 0>
<cfset tempMonth = curMonth>
<cfset tempYear = curYear>

<cfif numMonths GT 1>
	<cfloop from="1" to="#numMonths#" index="i">
		<cfif tempMonth EQ 12>
			<cfset tempMonth = "01">
			<cfset tempYear = tempYear + 1>
		</cfif>
		<cfset request.date = #CreateDate(tempYear, tempMonth, 1)#>
		<cfset maxDay = DaysInMonth(request.date)>
		<cfif i EQ 1>
			<cfset numDays = maxDay - curday + numDays>
		<cfelseif i EQ numMonths>
			<cfset numDays = stopday + numDays>
		<cfelse>
			<cfset numDays = maxDay + numDays>
		</cfif>
		<cfif maxDay GTE curday AND i NEQ numMonths>
			<cfset tempMonths = tempMonths + 1>
		<cfelseif i EQ numMonths and stopday EQ curday>
			<cfset tempMonths = tempMonths + 1>
		</cfif>
			<cfset tempMonth = tempMonth + 1>
	</cfloop>
<cfelse>
	<cfset numDays = stopday - curday + 1>
</cfif>
</cfoutput>


<cfset numMonths = tempMonths>
<cfset numWeeks = Ceiling(numDays/7)>

<!---
	<strong>Loop Information</strong> (numbers to use in order to properly loop)<br />
	<cfoutput>Number of Days: #numDays#<br /></cfoutput>
	<cfoutput>Number of Weeks: #numWeeks#<br /></cfoutput>
	<cfoutput>Number of Months: #numMonths#<br /></cfoutput>
	<cfoutput>Number of Years: #numYears#</cfoutput>
--->

<!--- Checks to see if recursion ends after X number of times or after a certain Day --->
<cfif repeatend EQ "repeat-date">
	<cfswitch expression="#repeat#">
		<cfcase value="Every Day">
			<cfset endafter = numDays>
		</cfcase>
		<cfcase value="Every Week">
			<cfset endafter = numWeeks>
		</cfcase>
		<cfcase value="Every Month">
			<cfset endafter = numMonths>
		</cfcase>
		<cfcase value="Every Year">
			<cfset endafter = numYears>
		</cfcase>
	</cfswitch>
</cfif>

<cfset dates = ArrayNew(2)>

<cfswitch expression="#repeat#">
	<cfcase value="Every Day">
		<cfoutput>
		<cfset curmonth = #convertDate(starttime,"mm")#>
		<cfset curday = #convertDate(starttime,"dd")#>
		<cfset curyear = #convertDate(starttime,"yyyy")#>
		<cfset dayCount = 1>
		<cfloop condition="dayCount LESS THAN OR EQUAL TO endafter">
				<cfset dates[dayCount][1] = "#curyear##curmonth##curday##curtime#00">
				<cfset endyear = curyear + diffYear>
				<cfset endmonth = curmonth + diffMonth>
				<cfset endday = curday + diffDay>
				<cfset dates[dayCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
			<cfset request.date = #CreateDate(curYear, curmonth, curday)#>
			<cfset maxDay = DaysInMonth(request.date)>
			<cfif curmonth EQ "12" AND curday + 1 GT maxDay>
				<cfset curyear = curyear + 1>
				<cfset curday = NumberFormat(1,"00")>
				<cfset curmonth = "01">
			<cfelseif curday + 1 GT maxday>
				<cfset curday = NumberFormat(1,"00")>
				<cfset curmonth = NumberFormat(curmonth + 1,"00")>
			<cfelse>
				<cfset curday =  NumberFormat(curday + 1,"00")>
			</cfif>
				<cfset dayCount = dayCount + 1>
		</cfloop>
		</cfoutput>
	</cfcase>
	<cfcase value="Every Week">
		<cfoutput>
		<cfset curmonth = #convertDate(starttime,"mm")#>
		<cfset curday = #convertDate(starttime,"dd")# - 7>
		<cfset curyear = #convertDate(starttime,"yyyy")#>
		<cfset weekCount = 1>
		<cfloop condition="weekCount LESS THAN OR EQUAL TO endafter">
			<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
			<cfset maxDay = DaysInMonth(request.date)>
			<cfif curmonth EQ "12" AND curday + 7 GT maxDay>
				<cfset curyear = curyear + 1>
				<cfset curday = NumberFormat(7 - (maxDay - curday),"00")>
				<cfset curmonth = "01">
			<cfelseif curday + 7 GT maxday>
				<cfset curday = NumberFormat(7 - (maxDay - curday),"00")>
				<cfset curmonth = NumberFormat(curmonth + 1,"00")>
			<cfelse>
				<cfset curday =  NumberFormat(curday + 7,"00")>
			</cfif>
				<cfset dates[weekCount][1] = "#curyear##curmonth##curday##curtime#00">
				<cfset endyear = curyear + diffYear>
				<cfset endmonth = curmonth + diffMonth>
				<cfset endday = curday + diffDay>
				<cfset dates[weekCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
				<cfset weekCount = weekCount + 1>
		</cfloop>
		</cfoutput>
	</cfcase>
	<cfcase value="Every Month">
		<cfoutput>
		<cfset curmonth = #convertDate(starttime,"mm")# - 1>
		<cfset curday = #convertDate(starttime,"dd")#>
		<cfset curyear = #convertDate(starttime,"yyyy")#>
		<cfset monthCount = 1>
		<cfloop condition="monthCount LESS THAN OR EQUAL TO endafter">
			
			<cfif curmonth EQ "12">
				<cfset curyear = curyear + 1>
				<cfset curmonth = "01">
			<cfelse>
				<cfset curmonth =  NumberFormat(curmonth + 1,"00")>
			</cfif>
			<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
			<cfset maxDay = DaysInMonth(request.date)>
			<cfif maxDay GTE curday>
				<cfset dates[monthCount][1] = "#curyear##curmonth##curday##curtime#00">
				<cfset endyear = curyear + diffYear>
				<cfset endmonth = curmonth + diffMonth>
				<cfset endday = curday + diffDay>
				<cfset dates[monthCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
				<cfset monthCount = monthCount + 1>
			</cfif>
		</cfloop>
		</cfoutput>
	</cfcase>
	<cfcase value="Every Year">
		<cfoutput>
		<cfset curmonth = #convertDate(date,"mm")#>
		<cfset curday = #convertDate(date,"dd")#>
		<cfset curyear = #convertDate(date,"yyyy")# - 1>
		<cfset yearCount = 1>
		<cfloop condition="yearCount LESS THAN OR EQUAL TO endafter">
			<cfset curyear = curyear + 1>
			<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
			<cfset maxDay = DaysInMonth(request.date)>
			<cfif maxDay GTE curday>
				<cfset dates[yearCount][1] = "#curyear##curmonth##curday##curtime#00">
				<cfset endyear = curyear + diffYear>
				<cfset endmonth = curmonth + diffMonth>
				<cfset endday = curday + diffDay>
				<cfset dates[yearCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
				<cfset yearCount = yearCount + 1>
			</cfif>
		</cfloop>
		</cfoutput>
	</cfcase>
</cfswitch>
<cfreturn dates>
</cffunction>