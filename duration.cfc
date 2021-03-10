<cfcomponent>
<cffunction name="getDuration" access="public" output="true" returntype="string" displayname="getDuration" description="I am a duration function, I take the end time and start time for an event and determine the duration of the event.">
<cfargument name="endtime" type="string" required="yes">
<cfargument name="starttime" type="string" required="yes">
	<cfoutput>
		<cfscript>
			request.endtime = "#endtime#";
			request.starttime = "#starttime#";
			request.endyear = "#left(request.endtime,4)#";
			request.startyear = "#left(request.starttime,4)#";
			request.starthour = "#Mid(request.starttime,9,2)#";
			request.endhour =  "#Mid(request.endtime,9,2)#";
			request.startmonth = "#Mid(request.starttime,5,2)#";
			request.endmonth =  "#Mid(request.endtime,5,2)#";
			request.startday = "#Mid(request.starttime,7,2)#";
			request.endday =  "#Mid(request.endtime,7,2)#";
			request.starthour = "#Mid(request.starttime,9,2)#";
			request.endhour =  "#Mid(request.endtime,9,2)#";
			request.startminute = "#Mid(request.starttime,11,2)#" ;
			request.endminute = "#Mid(request.endtime,11,2)#";
			request.theyear = request.endyear - request.startyear;
			request.themonth = request.endmonth - request.startmonth;
			request.theday = request.endday - request.startday;
			request.thehour = request.endhour - request.starthour;
			request.theminute = request.endminute - request.startminute;
		</cfscript>
		
		<cfsavecontent variable="theDuration">
			
		<cfif request.theyear NEQ 0>
			#request.theyear# Year<cfif request.theyear NEQ 1>s</cfif>
		</cfif>
		<cfif request.themonth NEQ 0>
			#request.themonth# Month<cfif request.themonth NEQ 1>s</cfif>
		</cfif>
		<cfif request.theday NEQ 0>
			#request.theday# Day<cfif request.theday NEQ 1>s</cfif>
		</cfif>
		<cfif request.thehour NEQ 0>
			#request.thehour# Hour<cfif request.thehour NEQ 1>s</cfif> 
		</cfif>
		<cfif request.theminute NEQ 0>
			#request.theminute# Minute<cfif request.theminute NEQ 1>s</cfif>
		</cfif>
		
		</cfsavecontent>
		
		<cfreturn theDuration>
	</cfoutput>
</cffunction>
</cfcomponent>