<cfcomponent hint="I send email to people">
<cfobject component="textConversions" name="txtConversions">
<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">

<cffunction name="addContactNotifyAdmin" access="public" returntype="string" output="false" >
	<cfargument name="contactdsn" required="true" type="String" hint="datasource">
	<cfargument name="emailadmin" required="true" type="String" hint="email for the administrator">
	<cfargument name="ccemailadmin" required="false" type="string" default="0" hint="cc email for the administrator">
	<cfargument name="thankYouSignature" required="false" type="String" hint="Signature for the e-mail" default="">
	<cfargument name="firstname" type="String" required="true" hint="First Name">
	<cfargument name="lastname" type="String" required="true" hint="Last Name">
	<cfargument name="address1" type="String" required="false" hint="Address" default="">
	<cfargument name="Sex" type="String" required="false" hint="sex" default="">
	<cfargument name="maritalstatus" type="String" required="false" hint="marital status" default="">
	<cfargument name="city" type="String" required="false" hint="city" default="">
	<cfargument name="state" type="String" required="false" hint="State" default="">
	<cfargument name="zip" type="String" required="false" hint="Zip" default="">	
	<cfargument name="company" type="String" required="false" hint="Company Name" default="">
	<cfargument name="address2" required="false" type="String" default="" hint="Address second line such as apartment or suite number">
	<cfargument name="wemail" required="true" type="string" hint="Work Email" default="blank">
	<cfargument name="hphone" required="false" type="string" hint="home phone" default="blank">
	<cfargument name="wphone" required="false" type="string" hint="Work Phone" default="blank">
	<cfargument name="mphone" required="false" type="string" hint="Moblile Phone" default="blank">
	<cfargument name="Ophone" required="false" type="string" hint="Other Phone" default="blank">
	<cfargument name="description" required="false" type="string" hint="comments from the person filling out the contact form" default="none">
	<cfargument name="senduser" required="false" type="string" hint="I determine whether or not a user will get an email message" default="true">
	<cfargument name="subject" required="false" type="string" default="0" hint="I am the subject of the email to send">
	<cfif arguments.subject EQ '0'>
		<cfset arguments.subject="#arguments.contactdsn# - Contact Form Submission">
	</cfif>
	<cfset yourname = "#arguments.firstname# #arguments.lastname#">
	<cfoutput>
		<!---Message to sales--->
		<cfsavecontent variable="message1">
			<html>
			<head>
				<title>#arguments.contactdsn# - Contact Form Submission</title>
			</head>
			<body>
			<p>Name: #yourname#</p>
			
			<cfif sex NEQ "">
			<p>Sex: <cfif sex EQ 1>Male<cfelseif sex EQ 0>Female<cfelse>NA</cfif></p>
			</cfif>
			
			<cfif maritalstatus NEQ "">
			<p>Marital Status: <cfif maritalstatus EQ 1>Married<cfelseif maritalstatus EQ 0>Single<cfelse>NA</cfif></p>
			</cfif>
			
			<p>Company: #arguments.company#</p>
			<p>Email: #arguments.wemail#</p>
			<cfif arguments.hphone NEQ 'blank'>
			<p>Home Phone: #arguments.hphone#</p>
			</cfif>
			<cfif arguments.wphone NEQ 'blank'>
			<p>Work Phone: #arguments.wphone#</p>
			</cfif>
			<cfif arguments.mphone NEQ 'blank'>
			<p>Mobile Phone: #arguments.mphone#</p>
			</cfif>
			<cfif arguments.ophone NEQ 'blank'>
			<p>Other Phone: #arguments.ophone#</p>
			</cfif>
			<p>Address: #arguments.address1# #arguments.address2#</p>
			<p>City: #arguments.city#</p>
			<p>State: #arguments.state#</p>
			<p>Zip: #arguments.zip#</p>
			<p>#arguments.description#</p>
			</body>
			</html>
		</cfsavecontent>
		
		<cfif arguments.ccemailadmin EQ "0">
			<cfmail type="html" from="#yourname#<#arguments.emailadmin#>" replyto="#yourname#<#arguments.wemail#>" to="#arguments.contactdsn#<#arguments.emailadmin#>" subject="#arguments.subject#">#message1#</cfmail>
		<cfelse>
			<cfmail type="html" from="#yourname#<#arguments.emailadmin#>" replyto="#yourname#<#arguments.wemail#>" to="#arguments.contactdsn#<#arguments.emailadmin#>" cc="#contactdsn#<#arguments.ccemailadmin#>" subject="#arguments.subject#">#message1#</cfmail>
		</cfif>
		
		<!--- Message to person --->
		<cfsavecontent variable="message2">
			<html>
				<head>
					<title>#arguments.contactdsn# Automatic Response</title>
				</head>
				<body>
				#yourname#,<br />
				<p>Thank you for contacting us!</p>
				<p>We have received your information and will respond shortly.</p>
				<p>
				<cfif len(thankYouSignature)>
					#arguments.thankYouSignature#
				<cfelse>
					Thank you,
					<br /><a href="mailto:#arguments.emailadmin#">#arguments.emailadmin#</a>
				</cfif>
				</p>
				</body>
			</html>
		</cfsavecontent>
		<cfif senduser eq "true">
			<cfmail type="html"  from="#arguments.contactdsn#<#arguments.emailadmin#>" to="#yourname#<#arguments.wemail#>" subject="#arguments.contactdsn# - Contact Form Submission">#message2#</cfmail>
		</cfif>
	</cfoutput>
	<cfreturn message2>
</cffunction>

<cffunction name="submitImageNotifyAdmin" access="public" returntype="void" output="false" >
	<cfargument name="site" required="true" type="String" hint="site the image was submitted from">
	<cfargument name="emailadmin" required="true" type="String" hint="email for the administrator">
	<cfargument name="subemail" required="true" type="string" hint="email address of the person who submitted the image">
	<cfargument name="firstname" type="String" required="true" hint="First Name">
	<cfargument name="lastname" type="String" required="true" hint="Last Name">
	<cfargument name="imageid" type="String" required="true" hint="The ID of the image submitted">	
	<cfargument name="imagetitle" required="false" type="String" default="" hint="The title submitted with the image">
	<cfargument name="caption" required="false" type="string" hint="The caption submitted with the image" default="none">
	<cfset yourname = "#firstname# #lastname#">
	<cfoutput>
	<!---Message to sales--->
	<cfsavecontent variable="message1">
	<html>
	<head>
		<title>#site# - Image Submission</title>
	</head>
	<body>
	<p>Name: #firstname# #lastname#</p>
	<p>Submitted an Image</p>
	<p>Image is Non-Active and waiting on your review.</p>
	<p>Image Title Submitted: #imagetitle#</p>
	<p>Caption: #caption#</p>
	<p>Imageid: #imageid#</p>
	</body>
	</html>
	</cfsavecontent>
	<cfmail type="html" from="#yourname#<#emailadmin#>" replyto="#yourname#<#subemail#>" to="#site#<#emailadmin#>" subject="#site# - Image Submission">#message1#</cfmail>
	</cfoutput>
</cffunction>
	
<cffunction name="sendContactNotifyUser" access="public" returntype="void" output="false">
		<cfargument name="first_name" default="blank"> 	<!--- Edited by binod. argument was param --->
		<cfargument name="last_name" default="blank">
		<cfargument name="phone" default="blank">
		<cfargument name="email" default="blank">
		<cfargument name="address" default="blank">
		<cfargument name="city" default="blank">
		<cfset yourname = "#first_name# #last_name#">
		<cfoutput>
			<cfif first_name neq "" and email neq "">
			<!---Message to sales--->
				<cfsavecontent variable="message1">
					<html>
					<head>
						<title>#site# - Form Information</title>
					</head>
					<body>
					<p>Here is the data that has been submitted:</p>
					<p>Company: #mycompany#</p>
					<p>Email: #email#</p>
					<p>Phone: #phone#</p>
					<p>Address: #address#</p>
					<p>City: #city#</p>
					<p>State: #state#</p>
					<p>Zip: #zip#</p>
					<p>Project Description: #proj_desc#</p>
					<p>Deadline: #deadline#</p>
					</body>
					</html>
				</cfsavecontent>
				<cfmail type="html" from="#yourname#<#request.emailadmin#>" replyto="#yourname#<#email#>" to="#sitename#<#request.emailadmin#>" subject="#sitename# - Request for Quote">#message1#</cfmail>
				
				<!--- Message to person --->
				<cfsavecontent variable="message2">
					<html>
					<head>
						<title>#sitename# Automatic Response</title>
					</head>
					<body>
					#yourname#,<br />
					<p>Thank you for contacting us!</p>
					<p>We have received your information and should respond shortly.</p>
					<p>Thank you,
					<br /><a href="mailto:#request.emailadmin#">#request.emailadmin#</a>
					</p>
					</body>
					</html>
				</cfsavecontent>
				<cfmail type="html"  from="#sitename#<#request.emailadmin#>" to="#yourname#<#email#>" subject="#sitename# - Request for Quote">#message2#</cfmail>
				#message2#
			<cfelse>
				<h1>Sorry</h1>
				<p>Sorry, please provide the required fields, the form can not be processed unless all required fields are filled in.</p><br>
				<br>
				<br>
			</cfif>
		</cfoutput>
</cffunction>
	
<cffunction name="addContactNotifyDump" access="public" returntype="string" output="false" >
	<cfargument name="contactdsn" required="true" type="String" hint="datasource">
	<cfargument name="emailadmin" required="true" type="String" hint="email for the administrator">
	<cfargument name="yourname" required="false" type="String" hint="name of person">
	<cfargument name="address1" type="String" required="false" hint="Address" default="">
	<cfargument name="city" type="String" required="false" hint="city" default="">
	<cfargument name="state" type="String" required="false" hint="State" default="">
	<cfargument name="zip" type="String" required="false" hint="Zip" default="">	
	<cfargument name="company" type="String" required="false" hint="Company Name" default="">
	<cfargument name="address2" required="false" type="String" default="" hint="Address second line such as apartment or suite number">
	<cfargument name="wemail" required="true" type="string" hint="Work Email" default="blank">
	<cfargument name="wphone" required="false" type="string" hint="Work Phone" default="blank">
	<cfargument name="description" required="false" type="string" hint="comments from the person filling out the contact form" default="none">
	<cfargument name="senduser" required="false" type="string" hint="I determine whether or not a user will get an email message" default="true">
	<cfset yourname = "#firstname# #lastname#">
	<cfoutput>
	<!---Message to sales--->
	<cfsavecontent variable="message1">
	<html>
	<head>
		<title>#contactdsn# - Form Submission</title>
	</head>
	<body>
	<p>This is the data that was submitted via your web form:</p>
	<p><cfdump var="#arguments#"></p>
	</body>
	</html>
	</cfsavecontent>
	<cfmail type="html" from="#yourname#<#emailadmin#>" replyto="#yourname#<#wemail#>" to="#contactdsn#<#emailadmin#>" subject="#sitename# - Contact Form Submission">#message1#</cfmail>
	
	<!--- Message to person --->
	<cfsavecontent variable="message2">
	<html>
	<head>
		<title>#contactdsn# Automatic Response</title>
	</head>
	<body>
	#yourname#,<br />
	<p>Thank you for contacting us!</p>
	<p>We have received your information and should respond shortly.</p>
	<p>Thank you,
	<br /><a href="mailto:#emailadmin#">#emailadmin#</a>
	</p>
	</body>
	</html>
	</cfsavecontent>
	<cfif senduser eq "true">
		<cfmail type="html"  from="#sitename#<#emailadmin#>" to="#yourname#<#wemail#>" subject="#sitename# - Contact Form Submission">#message2#</cfmail>
	</cfif>
	</cfoutput>
	<cfreturn message2>
</cffunction>	

<cffunction name="sendConfirmationEmail" returntype="void" access="public" output="false">
<cfargument name="contactdsn" required="true" type="String" hint="Datasource">	
<cfargument name="myurl" required="true" type="Sting" hint="URL">
	
	<cfif txtConversions.isEmail(hemail)>
		<cfset toemail = "#hemail#">
		<cfloop list="#confirmation#" index="thiseventid">
			<cfset myurl.eventid = thiseventid>
			<!--- <cfinclude template="/events/queries/thisevent.cfm"> --->
			<cfquery name="thisevent" datasource="#contactdsn#" maxrows="1">
				SELECT
					EVENT.URL,
					EVENT.CONTACTID,
					EVENTVERSION.LOCATIONID,
					EVENTVERSION.EVENTID, 
					EVENTVERSION.EVENTNAME, 
					EVENTVERSION.PAGENAME, 
					EVENTVERSION.STATUS, 
					EVENTVERSION.VERSIONID, 
					EVENTVERSION.STARTTIME,
					EVENTVERSION.ENDTIME, 
					EVENTVERSION.ACTUALSTARTTIME, 
					EVENTVERSION.ACTUALENDTIME, 
					EVENTVERSION.SEDESCRIPTION, 
					EVENTVERSION.KEYWORDS, 
					EVENTVERSION.TITLE, 
					EVENTVERSION.DESCRIPTION, 
					EVENTVERSION.MENUIMAGECAPTION, 
					EVENTVERSION.MENUIMAGELINK, 
					EVENTVERSION.PREDESSOREVENTID, 
					EVENTVERSION.PARENTEVENTID, 
					EVENTVERSION.FUSEACTIONID, 
					EVENTVERSION.PEERORDERNUMBER, 
					EVENTVERSION.IMAGEID, 
					EVENTVERSION.PERCENTCOMPLETE, 
					EVENTVERSION.CUSTOMCSS,
					EVENTVERSION.PRINTCSS,
					EVENTVERSION.SCREENCSS,
					EVENTVERSION.NAVNUM,
					EVENTVERSION.PLACEHOLDER,
					EVENTVERSION.ALTLAYOUT,
					EVENTVERSION.SITEID,
					EVENTVERSION.FREQUENCY,
					EVENTVERSION.FROMEMAIL,
					EVENTVERSION.CC,
					EVENTVERSION.SUBJECT,
					EVENTVERSION.MESSAGE,
					EVENTVERSION.DEFAULTPRICE,
					EVENTVERSION.DISCOUNTTYPE,
					EVENTVERSION.PERCENTOFF,
					EVENTVERSION.DISCOUNTPRICE,
					EVENTVERSION.GUESTPRICE,
					EVENTVERSION.INTERVAL,
					EVENTVERSION.COUNT,
					EVENTVERSION.UNTIL,
					EVENTVERSION.REPEATEND,
					EVENTCATEGORY.EVENTCATEGORYID,
					EVENTCATEGORY.EVENTCATEGORY,
					EL.COMPANY AS LOCATIONNAME,
					EL.WEMAIL AS LOCATIONEMAIL,
					EL.WPHONE AS LOCATIONPHONE,
					EL.ADDRESS1 AS LOCATIONADDRESS1,
					EL.ADDRESS2 AS LOCATIONADDRESS2,
					EL.CITY AS LOCATIONCITY,
					EL.STATE AS LOCATIONSTATE,
					EL.COUNTRY AS LOCATIONCOUNTRY,
					EL.ZIP AS LOCATIONZIP,
					EL.INTERSECTION AS LOCATIONINTERSECTION,
					EL.LAT AS LOCATIONLAT,
					EL.LON AS LOCATIONLON,
					EC.FIRSTNAME AS CONTACTFIRSTNAME,
					EC.LASTNAME AS CONTACTLASTNAME,
					EC.WPHONE AS CONTACTPHONE,
					EC.WEMAIL AS CONTACTEMAIL,
					EC.ADDRESS1 AS CONTACTADDRESS1,
					EC.ADDRESS2 AS CONTACTADDRESS2,
					EC.CITY AS CONTACTCITY,
					EC.STATE AS CONTACTSTATE,
					EC.COUNTRY AS CONTACTCOUNTRY,
					EC.ZIP AS CONTACTZIP,
					EC.INTERSECTION AS CONTACTINTERSECTION,
					EC.LAT AS CONTACTLAT,
					EC.LON AS CONTACTLON
				FROM         
					EVENT
					LEFT JOIN vwNameAddress as EC
					ON EC.NAMEID = EVENT.CONTACTID,
					EVENTVERSION 
					LEFT JOIN vwNameAddress as EL
					ON EL.nameid = EVENTVERSION.LOCATIONID,
					EVENTCATEGORY
				WHERE
					EVENT.EVENTID = EVENTVERSION.EVENTID
					AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
					AND EVENT.EVENTID = <cfqueryparam value="#myurl.eventid#">
				ORDER BY EVENTVERSION.VERSIONID DESC
			</cfquery>
			<!--- ends here --->
			
			<!--- <cfinclude template="../groups/queries/qry_myeventgroups.cfm"> --->
			<cfquery name="qrymyeventgroups" datasource="#contactdsn#">
				SELECT		
					USERGROUPS.USERGROUPID AS GROUPID,
					USERGROUPS.USERGROUPNAME AS NAME,
					USERGROUPS.USERGROUPDESCRIPTION AS DESCRIPTION,
					PEOPLE2EVENT.EVENTID,
					PEOPLE2EVENT.PRICE
				FROM 
					USERGROUPS,
					PEOPLE2EVENT
				WHERE USERGROUPS.USERGROUPID = PEOPLE2EVENT.USERGROUPID
				AND PEOPLE2EVENT.NAMEID = '#myurl.nameid#'
				<cfif isdefined('myurl.eventid')>AND PEOPLE2EVENT.EVENTID = '#URL.EVENTID#'</cfif>
			</cfquery>
			<!--- ends here --->
			<cfmail to="#firstname# #lastname#<#toemail#>" bcc="#thisevent.fromemail#" from="#thisevent.fromemail#" subject="#thisevent.subject#" type="html">
	<html>
		<head>
			<title>#thisevent.subject#</title>
		</head>
		<body>
		#firstname# #lastname#,
		<p>Thanks for signing up for #thisevent.eventname#.</p>
		#thisevent.message#
		</body>
	</html>
			</cfmail>
			<cfif thisevent.cc neq "">
			<cfmail to="#thisevent.cc#" from="#thisevent.fromemail#" subject="#thisevent.subject#" type="html">
	<html>
		<head>
			<title>#thisevent.subject#</title>
		</head>
		<body>
		#firstname# #lastname#,
		<p>Thanks for signing up for #thisevent.eventname#.</p>
		#thisevent.message#
		</body>
	</html>
			</cfmail>
			</cfif>
		</cfloop> 
	</cfif>
</cffunction>
	
<cffunction name="sendLoginInfo" returntype="string" access="public" output="false" hint="I send the the username and password for the email address passed to me to that email address, I return a message one of the following (Your password has been emailed to you., The email you entered was not a valid email address, Username not found.">
	<cfargument name="contactdsn" required="true" type="string" hint="The datasource to look for the username and password in">
	<cfargument name="adminEmail" required="true" type="string" hint="I am the email address you want to send this email from">
	<cfargument name="email" required="false" type="string" hint="The email address of the person looking for thier login account information">
	<cfargument name="myusername" required="false" type="string" hint="The username of the person looking for thier login account information">
	<cfargument name="loginAddress" required="false" default="#contactdsn#" type="string" hint="I am the place your user needs to go to login, if you do not pass something to me I will use the contactdsn you pass me, I need to be a web address withou the http:// (i.e. samssystem.com/login or houseofpancakes.org/vendors/login)">
	<!--- 
		DevNote:2008060609:drew@quantumdelta.com
		This function should be soon updated:Since the name table allows duplicate email addresses, 
		you could have more than one contact sharing the same email address
	--->
	<cfset var getmail=0>
	<cfif isdefined('arguments.myusername')>
		<cfquery name="getemail" datasource="#arguments.contactdsn#" maxrows="1">
			SELECT
				NAMEID,
				USERNAME,
				FIRSTNAME,
				LASTNAME,
				WEMAIL,
				HEMAIL,
				OEMAIL,
				PASSWORD
			FROM NAME
			WHERE USERNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.myusername#">
			AND STATUS=1
		</cfquery>
	<cfelse>
		<cfquery name="getemail" datasource="#arguments.contactdsn#" maxrows="1">
		SELECT
			NAMEID,
			USERNAME,
			FIRSTNAME,
			LASTNAME,
			WEMAIL,
			HEMAIL,
			OEMAIL,
			PASSWORD
			FROM NAME
			WHERE STATUS=1
			AND
			( 
				USERNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR WEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR HEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR OEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			)
		</cfquery>
	</cfif>
	<cfset message="">
	<cfif getemail.recordcount gt 0>
		<cfoutput  query="getemail"> 
			<cfif txtConversions.isEmail(USERNAME)>
				<cfset email = username>
			<cfelseif txtConversions.isEmail(HEMAIL)>
				<cfset email = hemail>
			<cfelseif txtConversions.isEmail(WEMAIL)>
				<cfset email = wemail>
			<cfelseif txtConversions.isEmail(OEMAIL)>
				<cfset email = oemail>
			<cfelse>
				<cfset message="Email address you entered was not valid">
			</cfif>
			
			<cfif Trim(username) EQ "">
				<cfset message=ListAppend(message,"Username for this account is not set")>
			</cfif>
			<cfif Trim(password) EQ "">	
				<cfset message=ListAppend(message,"Password for this account is not set")>
			</cfif>
			
			<cfif listlen(message) EQ 0>
				<cfset name = "#firstname# #lastname#">
				<cfmail to="#txtConversions.stripallbut(name, "1234567890abcdefghijklmnopqrstuvwxyz ", false)#<#email#>"  from="#adminEmail#" subject="Your #loginAddress# password" type="html">
					<html>
						<head>
							<title>Your #loginAddress# password</title>
						</head>
						<body>
							#firstname# #lastname#, you requested your login information.<br>Your username is <font color="##FF0000">#username#</font><br />Your password is: <font color="##FF0000">#password#</font>
							<p>You can login at <a href="http://#loginAddress#">http://#loginAddress#</a></p>
							<p>Thank you,<br>#adminEmail#</p>
						</body>
					</html>
				</cfmail>
			</cfif>
		</cfoutput>
	<cfelse>
		<cfset message="Email address not found."/>
	</cfif>
	<cfif len(message)>
		<cfset message=ListPrepend(message,"Please contact site administrator for following problems")>
	<cfelse>
		<cfset message="You login information has been emailed to you">
	</cfif>
	<cfreturn message>
</cffunction>

<cffunction name="sendLoginInfo918moms" access="public" returntype="string" output="false" hint="I am written especially for 918moms. I send username and password information for a user">
	<cfargument name="email" required="true" type="string" hint="The email address of the person looking for their login account information">
	<cfargument name="adminEmail" required="true" type="string" hint="I am the email address you want to send this email from">
	<cfargument name="ds" required="false" type="string" default="918moms.com" hint="name of the site">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.ds#">
		SELECT
			FIRSTNAME,
			LASTNAME,
			USERNAME,
			PASSWORD
		FROM NAME
		WHERE STATUS=1
		AND USERNAME IS NOT NULL
		AND PASSWORD IS NOT NULL
		AND DATALENGTH(USERNAME)>0
		AND DATALENGTH(PASSWORD)>0
		AND
		( 
			USERNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			OR WEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			OR HEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			OR OEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
		)
	</cfquery>
	<cfif get.recordcount GT 0>
		<cfset loginAddress="http://#arguments.ds#/login">
		<cfoutput>
			<cfmail to="#arguments.email#" from="#arguments.adminEmail#" subject="You request login information" type="html">
				<html>
					<head>
						<title>Your request login information</title>
					</head>
					<body>
						<cfif get.recordcount EQ 1>
							#get.firstname# #get.lastname#, <br />					
							Your username is <b>#get.username#</b> and your password is <b>#get.password#</b>. <br /><br />
						<cfelse>
							Dear user, <br />
							We found multiple records associated with your email.Here are your usernames and passwords: <br /> <br />
							<ul>
								<cfloop query="get">
									<li>Username: #username# Password: #password#</li>
								</cfloop>
							</ul>
							If you would like to delete one or more of your multiple usernames, please send your request to info@#arguments.ds#.
						</cfif>
						<p>You can login at <a href="#loginAddress#">#loginAddress#</a></p>
						<p>Thank you,<br />#adminEmail#</p>
					</body>
				</html>
			</cfmail>
		</cfoutput>
		<cfset message="You login information has been emailed to you">
	<cfelse>
		<cfset message="Your login information was not found.">
	</cfif>
	<cfreturn message>
</cffunction>

<!--- <cffunction name="emailConfirmation" returntype="string" access="public" output="false" hint="I am not written yet, but I will send an event email confirmation to a registered user">
</cffunction>

<cffunction name="sendNote" returntype="string" access="public" output="false" hint="I am not written yet, but I will send a simple note">
</cffunction>

<cffunction name="incidentClient" returntype="string" access="public" output="false" hint="I am not written yet, but I will send a copy of the incident to the client who reported it">
</cffunction>

<cffunction name="incidentAdmin" returntype="string" access="public" output="false" hint="I am not written yet, but I will send an incident that has been reported to the administrator">
</cffunction>

<cffunction name="taskSolutionClient" returntype="string" access="public" output="false" hint="I am not written yet, but I will send the reported solution for a task the the client or clients the task is tied to">
</cffunction>

<cffunction name="quickDesignAdmin" returntype="string" access="public" output="false" hint="I am not written yet, but I will send notification of a QuickDesign to the administrator">
</cffunction>

<cffunction name="quickDesignClient" returntype="string" access="public" output="false" hint="I am not written yet, but I will send notification of a QuickDesign to the Client who created it">
</cffunction> --->

</cfcomponent>