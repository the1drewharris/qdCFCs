<!---
	Name         : shipmenttracking.cfc
	Author       : Raymond Camden 
	Created      : December 12, 2006
	Last Updated : January 14, 2007
	History      : shipmentidentificationnumber doesn't exist when using a reference number. Fix by Francisco Mancardi (1/14/07)
	Purpose		 : Shipment Tracking

LICENSE 
Copyright 2006 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfcomponent output="false" extends="base" displayName="Shipment Tracking" hint="Lets you track your shipments.">

<!--- environment variables. These MUST exist. --->
<cfset variables.TEST_URL = "https://wwwcie.ups.com/ups.app/xml/Track">
<cfset variables.LIVE_URL = "https://www.ups.com/ups.app/xml/Track">

<cffunction name="getAddressStruct" access="private" output="false" returnType="struct"
			hint="Takes an XML node and tries to get address info out of it.">
	<cfargument name="xmlnode" type="xml" required="true">
	<cfset var result = structNew()>

	<cfif structKeyExists(arguments.xmlnode, "AddressLine1")>
		<cfset result.addressline1 = arguments.xmlnode.addressline1.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "AddressLine2")>
		<cfset result.addressline2 = arguments.xmlnode.addressline2.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "AddressLine3")>
		<cfset result.addressline3 = arguments.xmlnode.addressline3.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "City")>
		<cfset result.city = arguments.xmlnode.city.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "StateProvinceCode")>
		<cfset result.stateprovince = arguments.xmlnode.stateprovincecode.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "PostalCode")>
		<cfset result.postalcode = arguments.xmlnode.postalcode.xmlText>
	</cfif>
	<cfif structKeyExists(arguments.xmlnode, "CountryCode")>
		<cfset result.countrycode = arguments.xmlnode.countrycode.xmlText>
	</cfif>

	<cfreturn result>
</cffunction>			
					
<cffunction name="getTrackingInformation" access="public" output="false" returnType="struct">
	<cfargument name="number" type="string" required="true">
	<cfargument name="allactivity" type="boolean" required="false" default="true">
	<cfargument name="tracktype" type="string" required="false" default="trackingnumber">
	<cfargument name="destpostalcode" type="string" required="false" default="">
	<cfargument name="destcountrycode" type="string" required="false" default="">
	<cfargument name="pickupbegindate" type="date" required="false">
	<cfargument name="pickupenddate" type="date" required="false">
	<cfargument name="shippernumber" type="string" required="false" default="">
	
	<cfset var header = generateVerificationXML()>
	<cfset var reqxml = "">
	<cfset var xmlResult = "">
	<cfset var results = structNew()>
	<cfset var mnode = "">
	<cfset var x = "">
	<cfset var node = "">
	<cfset var data = "">
	<cfset var y = "">
	<cfset var anode = "">
	<cfset var adata = "">
	<cfset var result = "">
		
	<cfif not listFindNoCase("trackingnumber,referencenumber,shipmentidentificationnumber",arguments.tracktype)>
		<cfthrow message="UPS Shipment Tracking Error: Invalid tracktype (#arguments.tracktype#). Must be one of trackingnumber,referencenumber,shipmentidentificationnumber.">
	</cfif>
	
	<cfif len(trim(arguments.destpostalcode)) and not isValid("zipcode", arguments.destpostalcode)>
		<cfthrow message="UPS Shipment Tracking Error: #arguments.destpostalcode# is not a valid postal code.">
	</cfif>

	<!--- create req xml --->
	<cfsavecontent variable="reqxml">
	<cfoutput>
<?xml version="1.0"?>
<TrackRequest xml:lang="en-US">
	<Request>
		<TransactionReference>
			<CustomerContext>CFUPS Package</CustomerContext>
			<XpciVersion>1.0001</XpciVersion>
		</TransactionReference>
		<RequestAction>Track</RequestAction>
		<RequestOption><cfif arguments.allactivity>activity<cfelse>none</cfif></RequestOption>
	</Request>
	<cfif arguments.tracktype is "trackingnumber">
		<TrackingNumber>#arguments.number#</TrackingNumber>
	<cfelseif arguments.tracktype is "referencenumber">
		<ReferenceNumber><Value>#arguments.number#</Value></ReferenceNumber>
		<cfif len(trim(arguments.destpostalcode))>
		<DestinationPostalCode>#arguments.destpostalcode#</DestinationPostalCode>
		</cfif>
		<cfif len(trim(arguments.destcountrycode))>
		<DestinationCountryCode>#arguments.destcountrycode#</DestinationCountryCode>
		</cfif>
		<cfif structKeyExists(arguments, "pickupbegindate") or structKeyExists(arguments, "pickupenddate")>
		<PickupDateRange>
			<cfif structKeyExists(arguments, "pickupbegindate")><BeginDate>#dateFormat(arguments.pickupbegindate, "YYYYMMDD")#</BeginDate></cfif>
			<cfif structKeyExists(arguments, "pickupenddate")><EndDate>#dateFormat(arguments.pickupenddate, "YYYYMMDD")#</EndDate></cfif>
		</PickupDateRange>
		</cfif>
		<cfif len(trim(arguments.shippernumber))>
		<ShipperNumber>#arguments.shippernumber#</ShipperNumber>
		</cfif>
	<cfelse>
		<ShipmentIdentificationNumber>#arguments.number#</ShipmentIdentificationNumber>
	</cfif>
</TrackRequest>
	</cfoutput>
	</cfsavecontent>

	<cfhttp url="#getURL()#" method="post" result="result">
		<cfhttpparam type="xml" name="data" value="#header##reqxml#">
	</cfhttp>

	<cfset xmlResult = result.filecontent>
	<cfset xmlResult = xmlParse(xmlResult)>

	<cfif structKeyExists(xmlResult, "TrackResponse")>
	
		<cfif structKeyExists(xmlResult.TrackResponse.Response, "Error")>
			<cfthrow message="UPS Shipment Tracking Error: #xmlResult.TrackResponse.Response.Error.ErrorDescription#">
		<cfelse>
			<!--- make a copy --->
			<cfset mnode = xmlResult.TrackResponse.Shipment>
			
			<!--- 
			Our response is a complex struct with info about the shipment
			and activity.
			--->
			
			<!--- Get info about the shipper --->
			<cfset results.shipper = structNew()>
			<cfif structKeyExists(mnode, "shipper")>
				<cfif structKeyExists(mnode.shipper, "shippernumber")>
					<cfset results.shipper.shippernumber = mnode.shipper.shippernumber.xmlText>
				</cfif>
				<cfif structKeyExists(mnode.shipper, "address")>
					<cfset results.shipper.address = getAddressStruct(mnode.shipper.address)>
				</cfif>
			</cfif>
			
			<!--- Get shipto info --->
			<cfset results.shipto = structNew()>
			<cfif structKeyExists(mnode, "shipto") and structKeyExists(mnode.shipto, "address")>
				<cfset results.shipto = getAddressStruct(mnode.shipto.address)>
			</cfif>
			
			<!--- weight info --->
			<cfif structKeyExists(mnode, "shipmentweight")>
				<cfset results.shipmentweight = mnode.shipmentweight.weight.xmlText>
				<cfset results.shipmentweightunit = mnode.shipmentweight.unitofmeasurement.code.xmlText>
			<cfelse>
				<cfset results.shipmentweight = "">
				<cfset results.shipmentweightunit = "">
			</cfif>
						
			<cfset results.servicecode = mnode.service.code.xmltext>
			<cfset results.servicedescription = mnode.service.description.xmltext>
			
			<!--- 20070112 - francisco.mancardi@gruppotesi.com ---> 
			<cfif structKeyExists(mnode, "shipmentidentificationnumber")>
				<cfset results.shipmentidentificationnumber = mnode.shipmentidentificationnumber.xmlText>
			<cfelse>
				<cfset results.shipmentidentificationnumber = "">
			</cfif>
 			
			<cfif structKeyExists(mnode, "referencenumber")>
				<cfset results.referencenumbercode = mnode.referencenumber.code.xmlText>
				<cfset results.referencenumbervalue = mnode.referencenumber.value.xmlText>
			<cfelse>
				<cfset results.referencenumber = "">
			</cfif>
			
			<cfif structKeyExists(mnode, "pickupdate")>
				<cfset results.pickupdate = upsDateParse(mnode.pickupdate.xmlText)>
			<cfelse>
				<cfset results.pickupdate = "">
			</cfif>

			<cfif structKeyExists(mnode, "scheduleddeliverydate")>
				<cfset results.scheduleddeliverydate = upsDateParse(mnode.scheduleddeliverydate.xmlText)>
			<cfelse>
				<cfset results.scheduleddeliverydate = "">
			</cfif>

			<cfif structKeyExists(mnode, "scheduleddeliverytime")>
				<cfset results.scheduleddeliverytime = upsTimeParse(mnode.scheduleddeliverydate.xmlText)>
			<cfelse>
				<cfset results.scheduleddeliverytime = "">
			</cfif>
			
			<!--- Begin the really complex stuff - packages --->
			<cfset results.packages = arrayNew(1)>
			<cfloop index="x" from="1" to="#arrayLen(mnode.package)#">
			
				<cfset node = mnode.package[x]>
				<cfset data = structNew()>
				
				<cfif structKeyExists(node, "trackingnumber")>
					<cfset data.trackingnumber = node.trackingnumber.xmlText>
				<cfelse>
					<cfset data.trackingnumber = "">
				</cfif>

				<cfif structKeyExists(node, "rescheduleddeliverydate")>
					<cfset data.rescheduleddeliverydate = upsDateParse(node.rescheduleddeliverydate.xmlText)>
				<cfelse>
					<cfset data.rescheduleddeliverydate = "">
				</cfif>

				<cfif structKeyExists(node, "rescheduleddeliverytime")>
					<cfset data.rescheduleddeliverytime = upsTimeParse(node.rescheduleddeliverytime.xmlText)>
				<cfelse>
					<cfset data.rescheduleddeliverytime = "">
				</cfif>
				
				<cfset data.returnTo = structNew()>
				<cfif structKeyExists(node, "returnto") and structKeyExists(node.returnto, "address")>
					<cfset data.returnTo = getAddressStruct(node.returnto.address)>
				</cfif>

				<cfset data.activity = arrayNew(1)>
				
				<!--- each package can have N activity items. --->
				<cfif structKeyExists(node, "activity") and arrayLen(node.activity)>
					<cfloop index="y" from="1" to="#arrayLen(node.activity)#">
						<cfset anode = node.activity[y]>
						<cfset adata = structNew()>
						
						<cfset adata.activityLocation = structNew()>
						<cfif structKeyExists(anode, "activitylocation")>
						
							<cfset adata.activitylocation.address = structNew()>
							<cfif structKeyExists(anode.activitylocation, "address")>
								<cfset adata.activitylocation.address = getAddressStruct(anode.activitylocation.address)>
							</cfif>
							
							<!--- to do - artifacts --->

							<cfset adata.activitylocation.code = "">
							<cfif structKeyExists(anode.activitylocation, "code")>
								<cfset adata.activitylocation.code = anode.activitylocation.code.xmltext>
							</cfif>

							<cfset adata.activitylocation.description = "">
							<cfif structKeyExists(anode.activitylocation, "description")>
								<cfset adata.activitylocation.description = anode.activitylocation.description.xmltext>
							</cfif>
							
							<cfset adata.signedforbyname = "">
							<cfif structKeyExists(anode.activitylocation, "signedforbyname")>
								<cfset adata.signedforbyname = anode.activitylocation.signedforbyname.xmlText>
							</cfif>
						</cfif>
						
						<cfset adata.status = structNew()>
						<cfif structKeyExists(anode, "status")>
							<cfif structKeyExists(anode.status, "statustype")>
								<cfif structKeyExists(anode.status.statustype, "code")>
									<cfset adata.status.statustypecode = anode.status.statustype.code.xmlText>
								</cfif>
								<cfif structKeyExists(anode.status.statustype, "description")>
									<cfset adata.status.statustypedescription = anode.status.statustype.description.xmlText>
								</cfif>
							</cfif>
							<cfif structKeyExists(anode.status, "statuscode")>
								<cfif structKeyExists(anode.status.statuscode, "code")>
									<cfset adata.status.statuscodecode = anode.status.statuscode.code.xmlText>
								</cfif>
								<cfif structKeyExists(anode.status.statuscode, "description")>
									<cfset adata.status.statuscodedescription = anode.status.statuscode.description.xmlText>
								</cfif>
							</cfif>
						</cfif>
						
						<cfset adata.date = "">
						<cfif structKeyExists(anode, "date")>
							<cfset adata.date = upsDateParse(anode.date.xmlText)>
						</cfif>
						<cfset adata.time = "">
						<cfif structKeyExists(anode, "time")>
							<cfset adata.time = upsTimeParse(anode.time.xmlText)>
						</cfif>
						
						<cfset arrayAppend(data.activity, adata)>
					</cfloop>
				</cfif>
				
				<cfif structKeyExists(node, "message")>
					<cfset data.messagecode = node.message.code.xmlText>
					<cfif structKeyExists(node.message, "description")>
						<cfset data.message = node.message.description.xmlText>
					</cfif>
				</cfif>

				<cfif structKeyExists(node, "packageweight")>
					<cfif structKeyExists(node.packageweight, "weight")>
						<cfset data.weight = node.packageweight.weight.xmlText>
					</cfif>
					<cfif structKeyExists(node.packageweight, "unitofmeasurement")>
						<cfset data.weightunit = node.packageweight.unitofmeasurement.code.xmltext>
						<cfif structKeyExists(node.packageweight.unitofmeasurement, "description")>
							<cfset data.weightunitdescription = node.packageweight.unitofmeasurement.description.xmlText>
						</cfif>
					</cfif>	
				</cfif>
				
				<cfif structKeyExists(node, "referencenumber")>
					<cfif structKeyExists(node.referencenumber, "code")>
						<cfset data.referencenumbercode = node.referencenumber.code.xmlText>
					</cfif>				
					<cfif structKeyExists(node.referencenumber, "value")>
						<cfset data.referencenumbervalue = node.referencenumber.value.xmlText>
					</cfif>				
				</cfif>
				
				<!--- add the package --->				
				<cfset arrayAppend(results.packages, data)>
			</cfloop>
			<!--- End of Packages loop --->


		</cfif>
	</cfif>

	<cfreturn results>	
</cffunction>

<cffunction name="getDisclaimer" access="public" returnType="string" output="false"
			hint="UPS requires you to return this 'from time to time'. Just output it next to your results.">
	<cfset var msg = "">
	<cfsavecontent variable="msg">
NOTICE: The UPS package tracking systems accessed via this service (the ???Tracking Systems???) and
tracking information obtained through this service (the ???Information???) are the private property of UPS. UPS
authorizes you to use the Tracking Systems solely to track shipments tendered by or for you to UPS for
delivery and for no other purpose. Without limitation, you are not authorized to make the Information
available on any web site or otherwise reproduce, distribute, copy, store, use or sell the Information for
commercial gain without the express written consent of UPS. This is a personal service, thus your right to use
the Tracking Systems or Information is non-assignable. Any access or use that is inconsistent with these terms
is unauthorized and strictly prohibited.
	</cfsavecontent>
	
	<cfreturn msg>				
</cffunction>

</cfcomponent>
