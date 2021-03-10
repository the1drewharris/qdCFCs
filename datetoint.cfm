<cffunction name="dateToInt">
<cfargument name="date" required="yes" type="string">
<cfargument name="hours" required="yes" type="string">
<cfargument name="minutes" required="yes" type="string">
<cfargument name="ampm" required="yes" type="string">
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