<cfcomponent hint="Latitude - Longitude Functions">
	<cffunction name="get" access="public" returntype="struct" hint="Get Latitude Longitude from Yahoo Web Service Geocoder (Note: although all four parameters are optional at least one must be filled in)">
		<cfargument name="address" type="string" required="false" default="">
		<cfargument name="city" type="string" required="false" default="">
		<cfargument name="state" type="string" required="false" default="">
		<cfargument name="zip" type="string" required="false" default="">
		
		<cfif arguments.address EQ "" and arguments.city EQ "" and arguments.state EQ "">
			<CFHttp url="http://where.yahooapis.com/geocode?appid=vNAnjMrV34FfYOUVHTTqU_VD7PEa6Eeo0N28QKVR5MDPeUk_7lDEQ7WGM2WV4G9YZQ9_&location=#arguments.zip#" method="get" charset="utf-8" timeout="3"></CFHttp>
		<cfelse>
			<CFHttp url="http://where.yahooapis.com/geocode?appid=vNAnjMrV34FfYOUVHTTqU_VD7PEa6Eeo0N28QKVR5MDPeUk_7lDEQ7WGM2WV4G9YZQ9_&street=#arguments.address#&city=#arguments.city#&state=#arguments.state#&zip=#arguments.zip#" method="get" charset="utf-8" timeout="3"></CFHttp>
		</cfif>
		<cfset x= cfhttp.filecontent>
		<cftry>
		<cfset xmlDoc = XMLParse(x)>
		<cfcatch type="any">
			<cfset latLon.exist=0>
			<cfset latLon.message="I think the request timed out">
			<cfreturn latLon>
		</cfcatch>
		</cftry>
		<cfif isDefined('xmlDoc.ResultSet')>
			<cfif isDefined('xmlDoc.ResultSet.Result.Latitude.xmlText') and isDefined('xmlDoc.ResultSet.Result.Latitude.xmlText')>
				<cfset latLon.lat = xmlDoc.ResultSet.Result.Latitude.xmlText>
				<cfset latLon.lon = xmlDoc.ResultSet.Result.Longitude.xmlText>
				<cfset latLon.exist = 1>
			<cfelse>
				<cfset latLon.exist = 0>
			</cfif>
		<cfelse>
			<cfset latLon.exist = 0>
		</cfif>
		
		<cfreturn latLon>
	</cffunction>
	
	<cffunction name="getDistance" access="public" returntype="string" hint="Get Distance between two Locations (Bird's Flight distance, not driving distance)">
		<cfargument name="lat1" type="string" required="yes">
		<cfargument name="lon1" type="string" required="yes">
		<cfargument name="lat2" type="string" required="yes">
		<cfargument name="lon2" type="string" required="yes">
		<cfset x = 69.1 * (lat2 - lat1)>
		<cfset y = 53 * (lon2 - lon1) * cos(lat1 / 57.3)>
		<cfset distance = NumberFormat(sqr(x * x + y * y), '999.99')>
		<cfreturn distance>
	</cffunction>
</cfcomponent>