<cfcomponent hint="Geography based functions">
	<cffunction name="locatePlace" hint="I take in a location (zip, city, state, country) and return a structure of information about that location. included in the structure:
	woeid (Where on Earth ID), Place Type (type of item passed into function), value (value passed in), country, state, locality type (how local is the result), locality (what is the locale), 
	latitude, longitude" returnType="struct">
		<cfargument name="place" required="true" hint="Place to be located">
		<cfargument name="appID" default="1puOusPV34EK64fy2b5pvm3qln0.abMIOv3G.1NRMwYt9VXCwl5qNXXpyTVRhUtTXWx4Ats-" 
			hint="Yahoo! App ID, its unlikely this will be different than the default." required="false">

		<cfset var theURL = "http://where.yahooapis.com/v1/places.q('#urlEncodedFormat(arguments.place)#')?appid=#arguments.appID#">
		<cfset var location = ''>
		
		<cfhttp url="#theURL#" charset="utf-8" method="get">
		
		<cfset locationXML = XmlParse(cfhttp.fileContent)>
		
		<cfswitch expression="#cfhttp.responseHeader.status_code#">
			<cfcase value="200">

				<cfset location = StructNew()>
				
				<cfif locationXML.places.xmlAttributes['yahoo:count'] GT 0>
					<cfset location.woeid = locationXML.places.place.woeid.xmlText>
					<cfset location.placeType = locationXML.places.place.placeTypeName.xmlText>
					<cfset location.value = locationXML.places.place.name.xmlText>
					<cfset location.country = locationXML.places.place.country.xmlText>
					<cfset location.state = locationXML.places.place.admin1.xmlText>
					<cfif isDefined('locationXML.places.place.locality1.xmlAttributes.type')>
						<cfset location.localityType = locationXML.places.place.locality1.xmlAttributes.type>
					<cfelse>
						<cfset location.localityType = "">
					</cfif>
					<cfset location.locality = locationXML.places.place.locality1.xmlText>
					<cfset location.latitude = locationXML.places.place.centroid.latitude.xmlText>
					<cfset location.longitude = locationXML.places.place.centroid.longitude.xmlText>
					
				<cfelse>
					<cfset location.placeType = 0>
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfset location.placeType = 0>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn location>
	</cffunction>
	<cffunction name="get" access="public" returntype="struct" hint="Get Latitude Longitude from Yahoo Web Service Geocoder (Note: although all four parameters are optional at least one must be filled in)">
		<cfargument name="address" type="string" required="no" default="">
		<cfargument name="city" type="string" required="no" default="">
		<cfargument name="state" type="string" required="no" default="">
		<cfargument name="zip" type="string" required="no" default="">
		
		<cfinvoke component="LatLon" method="get" address="#arguments.address#" city="#arguments.city#" state="#arguments.state#" zip="#arguments.zip#" returnVariable="LatLon">
		
		<cfreturn LatLon>
		
	</cffunction>
	
	<cffunction name="getDistance" access="public" returntype="string" hint="Get Distance between two Locations (Bird's Flight distance, not driving distance)">
		<cfargument name="lat1" type="string" required="yes">
		<cfargument name="lon1" type="string" required="yes">
		<cfargument name="lat2" type="string" required="yes">
		<cfargument name="lon2" type="string" required="yes">
		
		<cfinvoke component="LatLon" method="getDistance" lat1="#arguments.lat1#" lat2="#arguments.lat2#" lon1="#arguments.lon1#" lon2="#arguments.lon2#" returnVariable="distance">

		<cfreturn distance>
	</cffunction>


</cfcomponent>