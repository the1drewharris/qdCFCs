<cfcomponent hint="I handle all of the newsletter functions">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions" name="objtextconversions">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="verifyMailServer" returntype="struct" access="public" output="true">
	    <cfargument name="protocol" type="string" required="true" hint="Mail protocol: SMTP, POP3 or IMAP" />
	    <cfargument name="host" type="string" required="true" hint="Mail server name (Example: pop.gmail.com)"/>
	    <cfargument name="port" type="numeric" default="-1" hint="Mail server port number. Default is -1, meaning use the default port for this protocol)" />
	    <cfargument name="user" type="string" required="true" hint="Mail account username" />
	    <cfargument name="password" type="string" required="true" hint="Mail account password" />
	    <cfargument name="useSSL" type="boolean" default="false" hint="If true, use SSL (Secure Sockets Layer)" >
	    <cfargument name="useTLS" type="boolean" default="false" hint="If true, use TLS (Transport Level Security)" >
	    <cfargument name="enforceTLS" type="boolean" default="false" hint="If true, require TLS support" >
	    <cfargument name="timeout" type="numeric" default="0" hint="Maximum milliseconds to wait for connection. Default is 0 (wait forever)" />
	    <cfargument name="debug" type="boolean" default="false" hint="If true, enable debugging. By default information is sent to is sent to System.out." >
	    <cfargument name="logPath" type="string" default="" hint="Send debugging output to this file. Absolute file path. Has no effect if debugging is disabled." >
	    <cfargument name="append" type="boolean" default="true" hint="If false, the existing log file will be overwritten" >
	
	    <cfset var status         = structNew() />
	    <cfset var props         = "" />
	    <cfset var mailSession     = "" />
	    <cfset var store         = "" />
	    <cfset var transport    = "" />
	    <cfset var logFile        = "" />
	    <cfset var fos             = "" />
	    <cfset var ps             = "" />
	    
	    <!--- validate protocol --->
	    <cfset arguments.protocol = lcase( trim(arguments.protocol) ) />
	    <cfif not listFindNocase("pop3,smtp,imap", arguments.protocol)>
	        <cfset status.wasVerified=false>
			<cfset status.errorType="Invalid Protocol">
			<cfset status.errorDetail="Allowed values for protocol: SMTP,IMAP,POP3">
			<cfreturn status>
	    </cfif>
	    
	    <cfscript>
	        // initialize status messages
	        status.wasVerified     = false;
	        status.errorType      = "";
	        status.errorDetail  = "";
	
	        try {
	               props = createObject("java", "java.util.Properties").init();
	
	               // enable securty settings
	               if (arguments.useSSL or arguments.useTLS) {
	
	                    // use the secure protocol
	                    // this will set the property mail.{protocol}.ssl.enable = true
	                    if (arguments.useSSL) {
	                         arguments.protocol = arguments.protocol &"s";            
	                    }
	                
	                    // enable identity check
	                    props.put("mail."& protocol &".ssl.checkserveridentity", "true");
	
	                    // enable transport level security and make it mandatory
	                    // so the connection fails if TLS is not supported
	                    if (arguments.useTLS) {
	                         props.put("mail."& protocol &".starttls.required", "true");
	                         props.put("mail."& protocol &".starttls.enable", "true");
	                    }
	               }
	
	               // force authentication command
	               props.put("mail."& protocol &".auth", "true");
	            
	               // for simple verifications, apply timeout to both socket connection and I/O 
	               if (structKeyExists(arguments, "timeout")) {
	                    props.put("mail."& protocol &".connectiontimeout", arguments.timeout);
	                    props.put("mail."& protocol &".timeout", arguments.timeout);
	               }
	
	               // create a new mail session 
	               mailSession = createObject("java", "javax.mail.Session").getInstance( props );
	
	               // enable debugging
	               if (arguments.debug) {
	                   mailSession.setDebug( true );
	                   
	                   // redirect the output to the given log file
	                   if ( len(trim(arguments.logPath)) ) {
	                        logFile = createObject("java", "java.io.File").init( arguments.logPath );
	                        fos      = createObject("java", "java.io.FileOutputStream").init( logFile, arguments.overwrite );
	                        ps       = createObject("java", "java.io.PrintStream").init( fos ); 
	                        mailSession.setDebugOut( ps );
	                   }
	               }
	            
	               // Connect to an SMTP server ... 
	               if ( left(arguments.protocol, 4) eq "smtp") {
	
	                    transport = mailSession.getTransport( protocol );
	                    transport.connect(arguments.host, arguments.port, arguments.user, arguments.password);
	                    transport.close();
	                    // if we reached here, the credentials should be verified
	                    status.wasVerified     = true;
	
	               }
	               // Otherwise, it is a POP3 or IMAP server
	               else {
	
	                    store = mailSession.getStore( protocol );
	                    store.connect(arguments.host, arguments.port, arguments.user, arguments.password);
	                    store.close();
	                    // if we reached here, the credentials should be verified
	                    status.wasVerified     = true;
	
	               }         
	
	         }
	         //for authentication failures
	         catch(javax.mail.AuthenticationFailedException e) {
	                   status.errorType     = "Authentication";
	                 status.errorDetail     = e;
	            }
	         // some other failure occurred like a javax.mail.MessagingException
	         catch(Any e) {
	                 status.errorType     = "Other";
	                 status.errorDetail     = e;
	         }
	
	
	         // always close the stream ( messy work-around for lack of finally clause prior to CF9...)
	         if ( not IsSimpleValue(ps) ) {
	               ps.close();
	         }
	
	         return status;
	    </cfscript>
	</cffunction>
	
	<cffunction name="assignToken" access="public" returntype="void" output="false" hint="I assign token">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="serverid" required="true" type="string" hint="I assign token to a server">
		<cfset var set=0>
		<cfset var lookup=0>
		<cfquery name="lookup" datasource="#arguments.ds#">
			SELECT COUNT(*) AS C FROM EMAILSERVERS
			WHERE SERVERID=<cfqueryparam value="#arguments.serverid#">
			AND STATUS=<cfqueryparam value="1">
		</cfquery>
		<cfif lookup.C GT 0>
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE EMAILSERVERS SET TOKEN=<cfqueryparam value="0">
			</cfquery>
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE EMAILSERVERS SET TOKEN=<cfqueryparam value="1">
				WHERE SERVERID=<cfqueryparam value="#arguments.serverid#">
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="editEmailServer" access="public" output="false" hint="Edit email server information">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="status" required="true" type="string" hint="1: Active, 0: Inactive">
		<cfargument name="serverid" required="true" type="string" hint="id of the server">
		<cfargument name="servername" required="false" default="0" type="string" hint="url of the server">
		<cfargument name="port" required="false" default="0" type="string" hint="name of the port">
		<cfargument name="username" required="false" default="0" type="string" hint="Username">
		<cfargument name="password" required="false" default="0" type="string" hint="Password">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE EMAILSERVERS SET
				STATUS=<cfqueryparam value="#arguments.status#">
				<cfif arguments.servername neq 0>, SERVERNAME=<cfqueryparam value="#arguments.servername#"></cfif>
				<cfif arguments.port neq 0>, PORT=<cfqueryparam value="#arguments.port#"></cfif>
				<cfif arguments.username neq 0>, USERNAME=<cfqueryparam value="#arguments.username#"></cfif>
				<cfif arguments.password neq 0>, PASSWORD=<cfqueryparam value="#arguments.password#"></cfif>
			WHERE SERVERID=<cfqueryparam value="#arguments.serverid#">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getEmailServerInfo" access="public" returntype="query" output="false" hint="I get email server info">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="serverid" required="false" default="0" type="string" hint="Id of the server">
		<cfargument name="servername" required="false" type="string" default="0" hint="the name of the email server">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				SERVERID,
				SERVERNAME,
				PORT,
				USERNAME,
				PASSWORD,
				STATUS
			FROM EMAILSERVERS
			WHERE 1=1
			<cfif arguments.serverid neq 0>AND SERVERID=<cfqueryparam value="#arguments.serverid#"></cfif>
			<cfif arguments.servername neq 0>AND SERVERNAME=<cfqueryparam value="#arguments.servername#"></cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="addEmailServer" access="public" returntype="void" output="false" hint="I add email server">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="servername" required="true" type="string" hint="url of the server">
		<cfargument name="port" required="true" type="string" hint="name of the port">
		<cfargument name="username" required="true" type="string" hint="Username">
		<cfargument name="password" required="true" type="string" hint="Password">
		<cfargument name="status" required="true" type="string" hint="1: Active, 0: Inactive">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO EMAILSERVERS
			(
				SERVERNAME,
				PORT,
				USERNAME,
				PASSWORD,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.servername#">,
				<cfqueryparam value="#arguments.port#">,
				<cfqueryparam value="#arguments.username#">,
				<cfqueryparam value="#arguments.password#">,
				<cfqueryparam value="#arguments.status#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="checkEmailServer" access="public" returntype="boolean" output="false" hint="return TRUE if email server exists and FALSE if it does not">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="servername" required="true" type="string" hint="Name of the server">
		<cfargument name="serverid" required="false" type="string" default="0" hint="id of the server">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS C FROM EMAILSERVERS
			WHERE SERVERNAME=<cfqueryparam value="#arguments.servername#">
			AND SERVERID<><cfqueryparam value="#arguments.serverid#">
		</cfquery>
		<cfif get.C EQ 0>
			<cfreturn FALSE>
		<cfelse>
			<cfreturn TRUE>
		</cfif>
	</cffunction>
	
	<cffunction name="getAllEmailServers" access="public" output="false" returntype="query" hint="I return all email servers">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				SERVERID,
				SERVERNAME,
				PORT,
				USERNAME,
				PASSWORD,
				TOKEN,
				STATUS
			FROM EMAILSERVERS
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getEmailServer" access="public" output="false" returntype="query" hint="I get the id of the next email server using round robin algorithm">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfset var get=0>
		<cfset var lookup=0>
		<cfset var getCount=0>
		<cfset var set=0>
		<cfset var currentServer=0>
		<cftransaction>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				SERVERID,
				SERVERNAME,
				PORT,
				USERNAME,
				PASSWORD 
			FROM EMAILSERVERS 
			WHERE TOKEN=<cfqueryparam value="1">
			AND STATUS=<cfqueryparam value="1">
		</cfquery>
		<cfset currentServer=get.ServerID>
		<cfquery name="getcount" datasource="#arguments.ds#">
			SELECT COUNT(SERVERID) AS SERVERCOUNT 
			FROM EMAILSERVERS
			WHERE STATUS=<cfqueryparam value="1">
		</cfquery>
		<cfif getcount.SERVERCOUNT GT 1>
			<cfquery name="reset" datasource="#arguments.ds#">
				UPDATE EMAILSERVERS SET TOKEN=<cfqueryparam value="0">
			</cfquery>
			<cfquery name="lookup" datasource="#arguments.ds#">
				SELECT TOP 1 SERVERID 
				FROM EMAILSERVERS
				WHERE SERVERID > <cfqueryparam value="#currentServer#">
			</cfquery>
			<cfif lookup.recordcount GT 0>
				<cfset nextServer=lookup.SERVERID>
				<cfquery name="set" datasource="#arguments.ds#">
					UPDATE EMAILSERVERS SET TOKEN=<cfqueryparam value="1">
					WHERE SERVERID=<cfqueryparam value="#nextServer#">
				</cfquery>
			<cfelse>
				<cfquery name="set" datasource="#arguments.ds#">
					UPDATE EMAILSERVERS SET TOKEN=<cfqueryparam value="1">
					WHERE SERVERID=(SELECT MIN(SERVERID) FROM EMAILSERVERS WHERE STATUS=<cfqueryparam value="1">)
				</cfquery>
			</cfif>
		</cfif>
		</cftransaction>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="wasNewsletterSent" access="public" output="false" returntype="string" hint="returns TRUE if the newsletter was sent, FALSE otherwise">
		<cfargument name="ds" required="true" type="string" hint="Database Name">
		<cfargument name="newsletterid" required="true" type="string" hint="id of the newsletter">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the user">
		<cfargument name="email" required="true" type="string" hint="email id where the newsletter was sent">
		<cfset var get=0>
		<cfset var newsletterWasSent=FALSE>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) C FROM NEWSLETTERTRACKING
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
			AND SENTTOEMAIL=<cfqueryparam value="#arguments.email#">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#">
			AND TIMESENT<><cfqueryparam value="0">
		</cfquery>
		<cfif get.C GT 0>
			<cfset newsletterWasSent=TRUE>
		</cfif>
		<cfreturn newsletterWasSent>
	</cffunction>
	
	<cffunction name="isValidNewsletter" access="public" output="false" returntype="string" hint="-1: No newsletter, 1: already sent, 2:being sent">
		<cfargument name="ds" required="true" type="string" hint="Database Name">
		<cfargument name="newsletterid" required="true" type="string" hint="id of the newsletter">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT SENT FROM NEWSLETTERQUEUE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
			AND NEWSLETTERID NOT IN (SELECT NEWSLETTERID FROM NEWSLETTERDELETEVIRTUAL)
		</cfquery>
		<cfif get.recordcount EQ 1>
			<cfreturn get.SENT>
		<cfelse>
			<cfreturn -1>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setAsBeingSent" access="public" output="false" returntype="string" hint="I set the newsletter as being SENT">
		<cfargument name="ds" required="true" type="string" hint="Database Name">
		<cfargument name="newsletterid" required="true" type="string" hint="id of the newsletter">
		<cfset var set=0>
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE NEWSLETTERQUEUE SET SENT=<cfqueryparam value="2">
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="sendNewsletterInBatch" access="public" output="false" returntype="string" hint="I send newsletter to a batch">
		<cfargument name="ds" required="true" type="string" hint="Database Name">
		<cfargument name="newsletterid" required="true" type="string" hint="id of the newsletter">
		<cfargument name="noOfContacts" required="true" type="string" hint="number of contacts in a batch">
		<cfargument name="fromaddress" type="string" required="false" default="newsletter@#ds#" hint="Email of the person who is sending the newsletter">
		<cfargument name="fromname" type="string" required="false" default="0" hint="name of the person sending the newsletter">
		<cfargument name="viewonsite" type="string" required="false" default="If you are having trouble viewing this email, you may view it online by following this link:" hint="I am the message for the user to view this newsletter on the website, I default to (If you are having trouble viewing this email, you may view it online by following this link:)">
		<cfargument name="disclaimer" type="string" required="false" default="<small>This electronic newsletter has been sent using the QDCMS by Quantum Delta LLC located at 8835 S. Memorial Dr. Tulsa, OK 74133.</small>" hint="I am the message for the user to view this newsletter on the website, I default to (<small>This electronic newsletter has been sent using the QDCMS by Quantum Delta LLC located at 8835 S. Memorial Dr. Tulsa, OK 74133.</small>)">
		<cfargument name="unsubscribe" type="string" required="false" default="To unsubscribe and be placed on the DO NOT EMAIL list, please click here:" hint="I am the message for the user to unsubscribe, I default to (To unsubscribe and be placed on the DO NOT EMAIL list, please click here:)">
		<cfargument name="sendunsubscribelink" type="string" required="false" default="1" hint="0 if unsubscribe link should not be sent">
		
		<cfset var batch=0>
		<cfset var markContacts=0>
		<cfset var more=0>
		<cfset var thereAreMore=FALSE>
		<cfset var unsubscribeLink="">
		<cfset var forwardLink="">
		<cfset var contactname="">
		<cfset var fromcontact="">
		<cfset var timedate="">
		<cfset var nwltruuids="">
		<cfset var thisEmailServer=0>
		<cfset var nwltr=getNewsletter(arguments.ds,arguments.newsletterid)>
		<cfset var e="">
		<cfset var errorlist="">
		<cfset var response=StructNew()>
		
		<cfset thisEmailServer=getEmailServer(arguments.ds)>
		<cfset response=verifyMailServer('smtp',thisEmailServer.SERVERNAME,thisEmailServer.PORT,thisEmailServer.USERNAME,thisEmailServer.PASSWORD)>
		<cfif NOT response.wasverified>
			<cfreturn TRUE>
		</cfif>
		
		<cfoutput>
			<cfsavecontent variable="forwardlink">
				<a href="http://#arguments.ds#/newsletter/#arguments.newsletterid#/forward">Forward this newsletter</a>
			</cfsavecontent>
			
			<cfsavecontent variable="viewonsitelink">
				<a href="http://#arguments.ds#/newsletter/#nwltr.NEWSLETTERID#">http://#arguments.ds#/newsletter/#nwltr.NEWSLETTERID#</a>
			</cfsavecontent>
			
			<cfif arguments.fromname neq 0>
				<cfset fromcontact="#objtextconversions.stripallbut(arguments.fromname, "1234567890abcdefghijklmnopqrstuvwxyz. ", false)#<#arguments.fromaddress#>">
			<cfelse>
				<cfset fromcontact="#objtextconversions.stripallbut(nwltr.sendfromname, "1234567890abcdefghijklmnopqrstuvwxyz. ", false)#<#arguments.fromaddress#>">
			</cfif>
					
			<cfquery name="batch" datasource="#arguments.ds#">
				SELECT TOP #arguments.noOfContacts# 
					N.FIRSTNAME,
					N.LASTNAME,
					NT.NAMEID, 
					NT.SENTTOEMAIL,
					NT.NEWSLETTERUUID
				FROM NEWSLETTERTRACKING NT, NAME N
				WHERE N.NAMEID=NT.NAMEID
				AND NT.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
				AND NT.TIMESENT=<cfqueryparam value="0">
			</cfquery>
			
			<cfloop query="batch">
				<cftry>
					<cfset contactname="#firstname# #lastname#">
					<cfset contactid=nameid>
					<cfinvoke component="addressbook" method="getContactInfo" contactdsn="#arguments.ds#" nameid="#contactid#" returnvariable="myContact">
					<cfif arguments.ds eq "vcientertainment.com">
						<cfsavecontent variable="contactdump">
						nameid=#nameid#<br />
						contactid=#contactid#<br />
						<cfdump var="#myContact#">
						</cfsavecontent>
						<!--- Stuff to send with codes --->
						<cfset my.TEXTNEWSLETTER=reReplace(nwltr.TEXTNEWSLETTER,'@firstname',myContact.firstname)>
						<cfset my.htmlnewsletter=reReplace(nwltr.htmlnewsletter,'@firstname',myContact.firstname)>
						
						<cfset my.TEXTNEWSLETTER=reReplace(my.TEXTNEWSLETTER,'@lastname',myContact.lastname)>
						<cfset my.htmlnewsletter=reReplace(my.htmlnewsletter,'@lastname',myContact.lastname)>
						
						<cfset my.TEXTNEWSLETTER=reReplace(my.TEXTNEWSLETTER,'@email',myContact.hemail)>
						<cfset my.htmlnewsletter=reReplace(my.htmlnewsletter,'@email',myContact.hemail)>
						
						<cfset my.TEXTNEWSLETTER=reReplace(my.TEXTNEWSLETTER,'@username',myContact.username)>
						<cfset my.htmlnewsletter=reReplace(my.htmlnewsletter,'@username',myContact.username)>
						
						<cfif findNoCase('@pass',nwltr.TEXTNEWSLETTER)>
							<cfquery name="findpass" datasource="#arguments.ds#" maxrows="1">
							SELECT PASSWORD AS PASS
							FROM NAME
							WHERE NAMEID=<cfqueryparam value="#contactid#">
							</cfquery>
							<cfif findpass.recordcount eq 1>
								<cfset my.TEXTNEWSLETTER=reReplace(my.TEXTNEWSLETTER,'@pass',findpass.pass)>
								
							<cfelse>
								<cfset my.TEXTNEWSLETTER=reReplace(my.TEXTNEWSLETTER,'@pass','password not found')>
							</cfif>
						</cfif>
						
						<cfif findNoCase('@pass',nwltr.htmlnewsletter)>
							<cfquery name="findpass" datasource="#arguments.ds#" maxrows="1">
							SELECT PASSWORD AS PASS
							FROM NAME
							WHERE NAMEID=<cfqueryparam value="#contactid#">
							</cfquery>
							<cfif findpass.recordcount eq 1>
								<cfset my.htmlnewsletter=reReplace(my.htmlnewsletter,'@pass',findpass.pass)>
								
							<cfelse>
								<cfset my.htmlnewsletter=reReplace(my.htmlnewsletter,'@pass','password not found')>
								
							</cfif>
						</cfif>
						<!--- end send stuff with codes --->
				
					<cfelse>
						<cfset my=nwltr>
						<cfsavecontent variable="contactdump">
						<br />
						</cfsavecontent>
					</cfif>
					<cfsavecontent variable="unsubscribelink">
						<a href="http://#arguments.ds#/newsletter/#arguments.newsletterid#/unsubscribe/#nameid#">http://#arguments.ds#/newsletter/#arguments.newsletterid#/unsubscribe/#nameid#</a>
					</cfsavecontent>
					
					<cfmail server="#thisEmailServer.SERVERNAME#" port="#thisEmailServer.PORT#" username="#thisEmailServer.USERNAME#" password="#thisEmailServer.PASSWORD#" to="#contactname#<#senttoemail#>" from="#fromcontact#" replyto="#nwltr.replyto#" subject="#nwltr.subject#">
						<cfmailpart type="text/plain" wraptext="72">
							#my.textnewsletter#
							<cfif arguments.sendunsubscribelink EQ 1>
							http://#arguments.ds#/newsletter/#arguments.newsletterid#/unsubscribe/#nameid#
							</cfif>		
							#arguments.disclaimer#
						</cfmailpart>
						<cfmailpart type="text/html">
							<html>
								<head>
									<title>#nwltr.subject#</title>
								</head>
								<body>
								#arguments.viewonsite# #viewonsitelink# <br />
								#forwardlink# <br />
								#my.htmlnewsletter# <br />
								#forwardlink# <br />
								<cfif arguments.sendunsubscribelink EQ 1>
								#arguments.unsubscribe# #unsubscribelink# <br />
								</cfif>
								#arguments.disclaimer# <br /><br />
								<img src="http://#arguments.ds#/newsletter/#nwltr.newsletterid#/track/#NEWSLETTERUUID#" height="1" width="1">
								</body>
							</html>
						</cfmailpart>
					</cfmail>
					<cfset nwltruuids=listAppend(nwltruuids,NEWSLETTERUUID)>
					<cfcatch type="any">
						<cfset errorlist=listAppend(errorlist,NEWSLETTERUUID)>
						<cfset e=cfcatch.message>
						<cfset filename="/home/drew/domains/qdcms.com/public_html/log/#arguments.ds#_#arguments.newsletterid#">
						<cfif fileExists(filename)>
							<cffile action="append" file="#filename#" output="#e#">
						<cfelse>
							<cffile action="write" file="#filename#" output="#e#" mode="775">
						</cfif>
					</cfcatch>
				</cftry>
			</cfloop>
		</cfoutput>
		
		<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfif listlen(nwltruuids) GT 0>
			<cfquery name="markContacts" datasource="#arguments.ds#">
				UPDATE NEWSLETTERTRACKING SET
				TIMESENT=<cfqueryparam value="#timedate#">
				WHERE NEWSLETTERUUID IN (#nwltruuids#)
			</cfquery>
		</cfif>
		<cfif listlen(errorlist) GT 0>
			<cfquery name="markContacts" datasource="#arguments.ds#">
				UPDATE NEWSLETTERTRACKING SET
				TIMESENT=<cfqueryparam value="Error">
				WHERE NEWSLETTERUUID IN (#errorlist#)
			</cfquery>
		</cfif>
		<cfquery name="more" datasource="#arguments.ds#">
			SELECT COUNT(*) AS REMAINING FROM NEWSLETTERTRACKING
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
			AND TIMESENT=<cfqueryparam value="0">
		</cfquery>
		<cfif more.REMAINING GT 0>
			<cfset thereAreMore=TRUE>
		</cfif>
		<cfreturn thereAreMore>
	</cffunction>
	
	<cffunction name="populateTrackingTable" access="public" output="false" returntype="void" hint="I populate tracking table">
		<cfargument name="ds" required="true" type="string" hint="I am the database name">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id of the newsletter">
		<cfset var getEmailTypes=0>
		<cfset var includegroups=0>
		<cfset var excludegroups=0>
		<cfset var get=0>
		<cfset var delete=0>
		<cfset var currentEmailtype="">
		
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTRACKING 
			WHERE NEWSLETTERID = <cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="getEmailTypes" datasource="#arguments.ds#">
			SELECT EMAILTYPE FROM NEWSLETTERTOEMAILTYPE 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
		</cfquery>
		
		<cfquery name="includegroups" datasource="#arguments.ds#">	
			SELECT USERGROUPID, EVENTID 
			FROM NEWSLETTERTOUSERGROUP 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="excludegroups" datasource="#arguments.ds#">	
			SELECT USERGROUPID, EVENTID 
			FROM NEWSLETTERTOUSERGROUPEXCLUDE 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfloop query="getEmailTypes">
			<cfset currentEmailType=EMAILTYPE>
			<cfquery name="get" datasource="#arguments.ds#">
				INSERT INTO NEWSLETTERTRACKING (NEWSLETTERID,NAMEID,TIMESENT,SENTTOEMAIL)
				SELECT N,NAMEID,T,#currentEmailType# FROM
				(
					SELECT 
						#arguments.newsletterid# AS N,
						NAMEID,
						0 AS T,
						#currentEmailType#,
						ROW_NUMBER() OVER(PARTITION BY #currentEmailType# ORDER BY NAMEID) AS ROWNUM
					FROM NAME
					WHERE STATUS=1
					AND #currentEmailType# LIKE '%@%'
					AND #currentEmailType# NOT IN (SELECT SENTTOEMAIL FROM NEWSLETTERTRACKING WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">)
					AND NAMEID NOT IN 
					(
						SELECT NAMEID FROM PEOPLE2USERGROUPS 
						WHERE USERGROUPID=(SELECT TOP 1 USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME=<cfqueryparam value='Do Not Email'>)
					)	
					<cfif includegroups.recordcount GT 0>
						AND 
						(
							<cfloop query="includegroups">
								NAMEID IN (
								<cfif EVENTID NEQ ''>
									SELECT NAMEID FROM PEOPLE2EVENT 
									WHERE EVENTID=<cfqueryparam value="#eventid#">
									AND USERGROUPID=<cfqueryparam value="#usergroupid#">
								<cfelse>
									SELECT NAMEID FROM PEOPLE2USERGROUPS
									WHERE USERGROUPID=<cfqueryparam value="#usergroupid#">
								</cfif>
								)
								<cfif currentRow LT recordcount>OR</cfif>
							</cfloop>
						)
					</cfif>
					<cfif excludegroups.recordcount GT 0>
						AND
						(
							<cfloop query="excludegroups">
								NAMEID NOT IN (
								<cfif EVENTID NEQ ''>
									SELECT NAMEID FROM PEOPLE2EVENT
									WHERE EVENTID=<cfqueryparam value="#eventid#">
									AND USERGROUPID=<cfqueryparam value="#usergroupid#">
								<cfelse>
									SELECT NAMEID FROM PEOPLE2USERGROUPS
									WHERE USERGROUPID=<cfqueryparam value="#usergroupid#">
								</cfif>
								)
								<cfif currentRow LT recordcount>AND</cfif>
							</cfloop>
						)
					</cfif>
				) TEMP_TABLE WHERE ROWNUM=<cfqueryparam value="1">
			</cfquery>
		</cfloop>
		<cfreturn>
	</cffunction>

	<cffunction name="virtualdelete" access="public" output="false" returntype="void" hint="I set newsletter as deleted without physically deleteing it">
		<cfargument name="ds" type="string" required="true" hint="I am the database where the newsletter is store">
		<cfargument name="newsletterid" type="string" required="true" hint="I am the id of the newsletter">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERDELETEVIRTUAL
			(
				NEWSLETTERID,
				TIMEDATE	
			)
			VALUES
			(
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="scheduletosend" access="public" output="false" returntype="void" hint="I schedule a newsletter to send to a later date">
		<cfargument name="myusername" required="true" type="string" hint="I am the person who is sending the newsletter">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id of the newsletter that should be sent">
		<cfargument name="startdate" required="true" type="string" hint="I am the date when the newsletter should be sent">
		<cfargument name="starttime" required="true" type="string" hint="I am the time when the newsletter should be sent">
		<cfargument name="ds" type="string" required="true" hint="I am the database where the newsletter is store">
		<cfargument name="taskname" type="string" required="true" hint="I am the taskname">
		<cfschedule action="update" operation="HTTPRequest" task="#arguments.taskname#" url="http://qdcms.com/marketing/newsletter/actions/sendemail.cfm?site=#arguments.ds#&from=#arguments.myusername#" startdate="#arguments.startdate#" starttime="#arguments.starttime#" interval="once" requesttimeout="1000">
	</cffunction>
	
	<cffunction name="getMonthCounts" access="public" returntype="query" hint="I get the blog entry counts for each month for the date range passed to me.">
		<cfargument name="ds" type="string" required="true" hint="database">
		<cfargument name="startrange" type="string" required="false" default="0" hint="the start range needs to be in yyyymmdd format">
		<cfargument name="endrange" type="string" required="false" default="0" hint="the end range needs to be in yyyymmdd format">
		<cfset var monthcount=0>
		<cfquery name="monthcount" datasource="#ds#">
		SELECT
			SUBSTRING(NEWSLETTERQUEUE.SENDDATE, 1,6) SENDMONTH,	
			COUNT(*) AS MONTHCOUNT
		FROM NEWSLETTERQUEUE 
		WHERE NEWSLETTERQUEUE.SENT = 1
		<cfif arguments.startrange NEQ 0>
		AND NEWSLETTERQUEUE.SENDDATE >=<cfqueryparam value="#startrange#%" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif arguments.endrange NEQ 0>
		AND NEWSLETTERQUEUE.SENDDATE <=<cfqueryparam value="#endrange#%" cfsqltype="cf_sql_varchar">
		</cfif>
		GROUP BY 
		SUBSTRING(NEWSLETTERQUEUE.SENDDATE, 1,6)
		ORDER BY SUBSTRING(NEWSLETTERQUEUE.SENDDATE, 1,6) DESC
		</cfquery>
		<cfreturn monthcount>
	</cffunction>
		
	<cffunction name="addnewsletter" access="public" output="false" returntype="numeric" hint="I add Newsletter to the database">
		<cfargument name="ds" required="true" type="String" hint="I am the datasource for updating the newsletter template">
		<cfargument name="name" required="true" type="String" hint="I am the name of the Newsletter">
		<cfargument name="authorid" required="true" type="string" hint="I am the masternameid of the person who created this newsletter">
		<cfargument name="replyto" required="true" type="string" hint="I am the replyto email address for this newsletter">
		<cfargument name="sendfromname" required="false" type="string" default="0" hint="the name the newsletter should be sent from">
		<cfargument name="htmlnewsletter" default="0" required="false" type="String" hint="I am newsletter text in html format">
		<cfargument name="textnewsletter"  default="0"required="false" type="String" hint="I am newletter text in text format">
		<cfargument name="subject" default="0" required="false" type="string" hint="I am the subject of the newletter">
		<cfargument name="newslettertemplateid" default="0" required="false" type="String" hint="I am the template which should be used for newsletter">
		<cfset var addnewsletter=0>
		<cfquery name="addnewsletter" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTER
			(
				NAME,
				CREATEDON,
				UPDATEDON,
				CREATEDBYMASTERID,
				REPLYTO
				<cfif arguments.htmlnewsletter neq 0>
				,HTMLNEWSLETTER
				</cfif>
				<cfif arguments.sendfromname neq 0>
				,SENDFROMNAME
				</cfif>
				<cfif arguments.textnewsletter neq 0>
				,TEXTNEWSLETTER
				</cfif>
				<cfif arguments.subject neq 0>
				,SUBJECT
				</cfif>
				<cfif arguments.newslettertemplateid neq 0>
				,NEWSLETTERTEMPLATEID
				</cfif>	
			)
			VALUES
			(
				<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#arguments.REPLYTO#" cfsqltype="cf_sql_varchar">
				<cfif arguments.htmlnewsletter neq 0>
				,<cfqueryparam value="#arguments.htmlnewsletter#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.SENDFROMNAME neq 0>
				,<cfqueryparam value="#arguments.SENDFROMNAME#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.textnewsletter neq 0>
				,<cfqueryparam value="#arguments.textnewsletter#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.subject neq 0>
				,<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.newslettertemplateid neq 0>
				,<cfqueryparam value="#arguments.newslettertemplateid#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS NEWSLETTERID
		</cfquery>
		<cfreturn addnewsletter.NEWSLETTERID>
	</cffunction>
	
	<cffunction name="addnewslettertousergroup" access="public" output="false" returntype="void" hint="I associate newsletter to a usergroup">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfargument name="usergroupid" type="String" required="true" hint="I am usergroupid"> 
		<cfargument name="eventid" type="String" required="false" default="0" hint="I am eventid">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTOUSERGROUP
			(
				<cfif arguments.eventid NEQ 0>
				EVENTID,
				</cfif>
				NEWSLETTERID,
				USERGROUPID
			)
			VALUES
			(
				<cfif arguments.eventid NEQ 0>
				<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.usergroupid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="excludeusergroup" access="public" output="false" returntype="void" hint="I store the list of groups to which the newsletter should not be sent to">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfargument name="usergroupid" type="String" required="true" hint="I am usergroupid"> 
		<cfargument name="eventid" type="string" required="false" default="0" hint="I am eventid">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTOUSERGROUPEXCLUDE
			(
				<cfif arguments.eventid NEQ 0>
				EVENTID,
				</cfif>
				NEWSLETTERID,
				USERGROUPID
			)
			VALUES
			(
				<cfif arguments.eventid NEQ 0>
				<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.usergroupid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addnewslettertoemailtype" access="public" output="false" returntype="void" hint="I associate newsletter to a email type">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfargument name="emailtype" type="String" required="true" hint="I am usergroupid"> 
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTOEMAILTYPE
			(
				NEWSLETTERID,
				EMAILTYPE
			)
			VALUES
			(
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.emailtype#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getNewsletter" access="public" output="false" returntype="query" hint="I get Newletters from the database, I return a recordset: NEWSLETTERID, NAME, CREATEDON, UPDATEDON, HTMLNEWSLETTER, TEXTNEWSLETTER, SUBJECT">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="false" default="0" hint="I am newsletterid">
		<cfargument name="keyword" type="string" required="false" default="0" hint="I am a search word for Newsletter">
		<cfset var getmynewsletter=0>
		<cfquery name="getmynewsletter" datasource="#arguments.ds#">
			SELECT 
			N.NEWSLETTERID,
			N.NAME,
			N.CREATEDON,
			N.UPDATEDON,
			N.HTMLNEWSLETTER,
			N.TEXTNEWSLETTER,
			N.SUBJECT,
			N.CREATEDBYMASTERID,
			N.REPLYTO,
			N.SENDFROMNAME,
			N.NEWSLETTERTEMPLATEID,
			NQ.SENT
			FROM NEWSLETTER N
			LEFT JOIN NEWSLETTERQUEUE NQ
			ON N.NEWSLETTERID = NQ.NEWSLETTERID
			WHERE N.NEWSLETTERID NOT IN(SELECT NEWSLETTERID FROM NEWSLETTERDELETEVIRTUAL)
			<cfif arguments.newsletterid NEQ 0>
			AND N.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.keyword neq 0>
			AND 
			( 
				N.NAME LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR N.HTMLNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR N.TEXTNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR N.TEXTNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR N.SUBJECT LIKE <cfqueryparam value="%#arguments.keyword#%">
			)
			</cfif>
			ORDER BY CREATEDON DESC
		</cfquery>
		<cfreturn getmynewsletter>
	</cffunction>
	
	<cffunction name="getNewsletterHeaders" access="public" returntype="query" hint="returns: NEWSLETTERID,NAME,SUBJECT,CREATEDON,LASTUPDATED">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfargument name="startvalue" type="string" required="true" hint="start value">
		<cfargument name="recordsperpage" required="true" type="string" hint="no of records to show per page">
		<cfset var get=0>
		<cfset var endvalue=arguments.startvalue + arguments.recordsperpage>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM (
				SELECT 
					N.NEWSLETTERID,
					N.NAME,
					N.SUBJECT,
					N.CREATEDON,
					N.UPDATEDON,
					NQ.SENT,
					ROW_NUMBER() OVER (ORDER BY UPDATEDON DESC) AS ROW
				FROM NEWSLETTER N
				LEFT JOIN NEWSLETTERQUEUE NQ
				ON N.NEWSLETTERID=NQ.NEWSLETTERID
				WHERE N.NEWSLETTERID NOT IN (SELECT NEWSLETTERID FROM NEWSLETTERDELETEVIRTUAL)
			) ALLNEWSLETTERS
			WHERE ROW > <cfqueryparam value="#arguments.startvalue#"> AND ROW <= <cfqueryparam value="#endvalue#">
		</cfquery>
		<cfreturn get>
	</cffunction> 
	
	<cffunction name="getNewsletterCount" access="public" returntype="string" hint="returns no of newsletter in the system">
		<cfargument name="ds" type="string" required="true" hint="database name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS N FROM NEWSLETTER
			WHERE NEWSLETTERID NOT IN (SELECT NEWSLETTERID FROM NEWSLETTERDELETEVIRTUAL)
		</cfquery>
		<cfreturn get.N>
	</cffunction>
	
	<cffunction name="getnewslettergroups" access="public" output="false" returntype="query" hint="I get all the user groups assigned to newsletterid">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				USERGROUPID,
				EVENTID
			FROM NEWSLETTERTOUSERGROUP
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getnewsletterexcludegroups" access="public" output="false" returntype="query" hint="I get all the user groups to whom newsletter should not be sent">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				USERGROUPID,
				EVENTID
			FROM NEWSLETTERTOUSERGROUPEXCLUDE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getnewsletteremailtypes" access="public" output="false" returntype="query" hint="I get all the user groups assigned to newsletterid">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT EMAILTYPE FROM NEWSLETTERTOEMAILTYPE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getQueue" access="public" output="false" returntype="query" hint="I get Newletter queue information">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="newsletterid" type="string" required="false" default="0" hint="I am newsletterid">
		<cfargument name="senddate" type="string" required="false" default="0" hint="I am the date when newsletter should be sent">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				QUEUEID,
				NEWSLETTERID,
				QUEUEDON,
				SENDDATE,
				SENT
			FROM NEWSLETTERQUEUE
			WHERE SENT=0 
			<cfif arguments.newsletterid NEQ "0">
			AND NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.senddate NEQ "0">
			AND SENDDATE<=<cfqueryparam value="#arguments.senddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY QUEUEID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getSentDate" access="public" returntype="string" hint="I get the date when newsletter was sent">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="newsletterid" type="string" required="false" default="0" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT SENDDATE FROM NEWSLETTERQUEUE
			WHERE SENT=1
			AND NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.SENDDATE>
	</cffunction>
	
	<cffunction name="editNewsletter" access="public" output="false" returntype="void" hint="I update newsletter">
		<cfargument name="ds" required="true" type="String" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletterid" required="true" type="String" hint="I am Newsletterid">
		<cfargument name="replyto" default="0" required="false" type="String" hint="I am the reply to email address for this newsletter">
		<cfargument name="name" default="0" required="false" type="String" hint="I am the name of the Newsletter">
		<cfargument name="sendfromname" required="false" type="string" default="0" hint="the name the newsletter should be sent from">
		<cfargument name="htmlnewsletter" default="0" required="false" type="String" hint="I am newsletter text in html format">
		<cfargument name="textnewsletter" default="0" required="false" type="String" hint="I am newletter text in text format">
		<cfargument name="subject" default="0" required="false" type="String" hint="I am the subject of the newletter">
		<cfset var editNewsletter=0>
		<cfquery name="editNewsletter" datasource="#arguments.ds#">
			UPDATE NEWSLETTER
			SET UPDATEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			<cfif arguments.name neq 0>
			,NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.replyto neq 0>
			,REPLYTO=<cfqueryparam value="#arguments.replyto#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.htmlnewsletter neq 0>
			,HTMLNEWSLETTER=<cfqueryparam value="#arguments.htmlnewsletter#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.SENDFROMNAME neq 0>
			,SENDFROMNAME=<cfqueryparam value="#arguments.SENDFROMNAME#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.textnewsletter neq 0>
			,TEXTNEWSLETTER=<cfqueryparam value="#arguments.textnewsletter#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.subject neq 0>
			,SUBJECT=<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="addTemplate" access="public" output="false" returntype="string" hint="I add a Newsletter template to the database, I return the id for the new template">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="Name" type="string" required="true" hint="I am the name of the new newsletter template">
		<cfargument name="template" type="string" required="true" hint="I am the html code for the new newsletter template">
		<cfargument name="description" type="string" required="false" default="" hint="I am the description of this newsletter template">
		<cfargument name="imagepath" type="String" default="" required="false" hint="I am the thumb image of the template">
		<cfargument name="status" type="string" required="false" default="Published" hint="I am the status of the template">
			
		<cfquery name="addMyTemplate" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTEMPLATE
			(
				NAME,
				TEMPLATE,
				DESCRIPTION,
				IMAGEPATH,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.Name#">,
				<cfqueryparam value="#arguments.template#">,
				<cfqueryparam value="#arguments.description#">,
				<cfqueryparam value="#arguments.imagepath#">,
				<cfqueryparam value="#arguments.status#">
			)
			SELECT @@IDENTITY AS TEMPLATEID
		</cfquery>
		<cfreturn addMytemplate.templateid>
	</cffunction>

	<cffunction name="getTemplate" access="public" output="false" returntype="Query" hint="I get the info for the newsletter template">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newslettertemplateid" type="numeric" default="0" required="false" hint="I am the id for the newsletter you are updating">
		<cfargument name="parentsiteid" type="string" required="false" default="0" hint="I am the id of the parentsite">
		<cfset var get =0>
		<cfset var getMytemplate=0>
		<cfset var getTemplatesInParent=0>
		<cfset var compiledtemplates=0>
		<cfset var parentsite=0>
		
		<cfquery name="getMytemplate" datasource="#arguments.ds#">
			SELECT
				NEWSLETTERTEMPLATEID,
				NAME,
				TEMPLATE,
				DESCRIPTION,
				IMAGEPATH,
				STATUS,
				'0' AS INPARENT
			FROM NEWSLETTERTEMPLATE
			<cfif arguments.newslettertemplateid NEQ 0>
				WHERE NEWSLETTERTEMPLATEID=<cfqueryparam value="#arguments.newslettertemplateid#">
			</cfif>
		</cfquery>
		
		<cfif arguments.parentsiteid NEQ "0">
			<cfquery name="get" datasource="deltasystem">
				SELECT SITEURL 
				FROM SITE 
				WHERE SITEID=<cfqueryparam value="#arguments.parentsiteid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif get.recordcount GT 0>
				<cfquery name="getTemplatesInParent" datasource="#get.siteurl#">
					SELECT
						NEWSLETTERTEMPLATEID,
						NAME,
						TEMPLATE,
						DESCRIPTION,
						IMAGEPATH,
						STATUS,
						'#get.siteurl#' AS INPARENT
					FROM NEWSLETTERTEMPLATE
					WHERE STATUS='Shared'
				</cfquery>
				<cfquery name="compiledtemplates" dbtype="query">
					SELECT * FROM getTemplatesInParent
					UNION
					SELECT * FROM getMyTemplate
				</cfquery>
				<cfreturn compiledtemplates>
			</cfif>
		</cfif>
		<cfreturn getMytemplate>
	</cffunction>
	
	<cffunction name="deleteTemplate" access="public" output="false" returntype="string" hint="I update the newsletter template">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="templateid" type="numeric" required="true" hint="I am the id for the newsletter you are updating">
		<cfquery name="updateTemplate" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTEMPLATE
			WHERE NEWSLETTERTEMPLATEID=<cfqueryparam value="#arguments.templateid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="addNewsletterTracking" access="public" output="false" returntype="numeric" hint="I add newslettertracking information">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of the receipient of the newsletter">
		<cfargument name="senttoemail" required="true" type="string" hint="I am the email address where the newsletter is sent">
		<cfquery name="addMynewslettertracking" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTRACKING
			(
				NEWSLETTERID,
				NAMEID,
				TIMESENT,
				SENTTOEMAIL
			)
			VALUES
			(
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.senttoemail#" cfsqltype="cf_sql_varchar">

			)
			SELECT @@IDENTITY AS NEWSLETTERUUID
		</cfquery>
		<cfreturn addMynewslettertracking.NEWSLETTERUUID>	
	</cffunction>
	
	<cffunction name="recordbounce" access="public" output="false" returntype="void" hint="I track bounced newsletters">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletteruuid" required="true" type="string" hint="I am id for newsletter send to each receipient">
		<cfargument name="timebounced" required="true" type="string" hint="I am time when the newsletter was bounced">
		<cfquery name="recordbounce" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERBOUNCED
			(
				NEWSLETTERUUID,
				TIMEBOUNCED
			)
			VALUES
			(
				<cfqueryparam value="#arguments.newsletteruuid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#arguments.timebounced#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="recordviewed" access="public" output="false" returntype="void" hint="I track viewed newsletters">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletteruuid" required="true" type="string" hint="I am id for newsletter send to each receipient">
		<cfset var recordviewed=0>
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				TIMEVIEWED 
			FROM NEWSLETTERVIEWED 
			WHERE NEWSLETTERUUID=<cfqueryparam value="#arguments.newsletteruuid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfquery name="recordviewed" datasource="#arguments.ds#">
				INSERT INTO NEWSLETTERVIEWED
				(
					NEWSLETTERUUID,
					TIMEVIEWED
					
				)
				VALUES
				(
					<cfqueryparam value="#arguments.newsletteruuid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getViewCount" access="public" output="false" returntype="String" hint="I get the number of people who viewed the newsletter">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(NEWSLETTERVIEWED.NEWSLETTERUUID) AS VIEWCOUNT 
			FROM NEWSLETTERVIEWED, NEWSLETTERTRACKING
			WHERE NEWSLETTERVIEWED.NEWSLETTERUUID=NEWSLETTERTRACKING.NEWSLETTERUUID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfreturn get.VIEWCOUNT>
	</cffunction>
	
	<cffunction name="getBounceCount" access="public" output="false" returntype="String" hint="I get the number bounced email">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(NEWSLETTERBOUNCED.NEWSLETTERUUID) AS BOUNCECOUNT 
			FROM NEWSLETTERBOUNCED, NEWSLETTERTRACKING
			WHERE NEWSLETTERBOUNCED.NEWSLETTERUUID=NEWSLETTERTRACKING.NEWSLETTERUUID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfreturn get.BOUNCECOUNT>
	</cffunction>
	
	<cffunction name="getNoOfPeopleSentTo" access="public" output="false" returntype="query" hint="I get the number of people the email was sent to">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(NEWSLETTERTRACKING.NEWSLETTERUUID) AS NOOFEMAILS,
			COUNT(DISTINCT NAMEID) AS NOOFPEOPLE
			FROM NEWSLETTERTRACKING
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			AND TIMESENT<><cfqueryparam value="0">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="newsletterViewedPerDay" access="public" output="false" returntype="query" hint="I get the newsletter viewed per day">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				COUNT(NEWSLETTERVIEWED.NEWSLETTERUUID) AS VIEWPERDAY,
				SUBSTRING(NEWSLETTERVIEWED.TIMEVIEWED,1,8) AS DATEVIEWED
			FROM NEWSLETTERVIEWED, NEWSLETTERTRACKING
			WHERE NEWSLETTERTRACKING.NEWSLETTERUUID=NEWSLETTERVIEWED.NEWSLETTERUUID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			GROUP BY SUBSTRING(NEWSLETTERVIEWED.TIMEVIEWED,1,8)
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getPeopleNewsletterSentTo" access="public" output="false" returntype="query" hint="I get the list of people who viewed the newsletter">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfargument name="sortorder" required="false" type="string" default="0" hint="sortorder of the report">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				NAME.NAMEID,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NEWSLETTERTRACKING.SENTTOEMAIL,
				NEWSLETTERVIEWED.TIMEVIEWED
			FROM NEWSLETTERTRACKING, NAME, NEWSLETTERVIEWED
			WHERE NAME.NAMEID=NEWSLETTERTRACKING.NAMEID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			AND NEWSLETTERTRACKING.NEWSLETTERUUID=NEWSLETTERVIEWED.NEWSLETTERUUID
			UNION
			SELECT
				NAME.NAMEID,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NEWSLETTERTRACKING.SENTTOEMAIL,
				'NOT VIEWED' AS TIMEVIEWED
			FROM NEWSLETTERTRACKING, NAME
			WHERE NAME.NAMEID=NEWSLETTERTRACKING.NAMEID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			AND NEWSLETTERTRACKING.NEWSLETTERUUID NOT IN (SELECT NEWSLETTERUUID FROM NEWSLETTERVIEWED)
			AND NEWSLETTERTRACKING.NEWSLETTERUUID NOT IN (SELECT NEWSLETTERUUID FROM NEWSLETTERBOUNCED)
			UNION
			SELECT
				NAME.NAMEID,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NEWSLETTERTRACKING.SENTTOEMAIL,
				'BOUNCED' AS TIMEVIEWED
			FROM NEWSLETTERTRACKING, NAME
			WHERE NAME.NAMEID=NEWSLETTERTRACKING.NAMEID
			AND NEWSLETTERTRACKING.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			AND NEWSLETTERTRACKING.NEWSLETTERUUID NOT IN (SELECT NEWSLETTERUUID FROM NEWSLETTERVIEWED)
			AND NEWSLETTERTRACKING.NEWSLETTERUUID IN (SELECT NEWSLETTERUUID FROM NEWSLETTERBOUNCED)
			<cfif arguments.sortorder NEQ "0">
			ORDER BY #arguments.sortorder#
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="addNewsletterToQueue" access="public" output="false" returntype="string" hint="I add newsletter to the queue">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id for newsletter">
		<cfargument name="senddate" required="false" type="string" hint="I am the date when the newsletter should be sent">
		<cfargument name="sent" required="false" type="string" default="0" hint="1 if sent and 0 otherwise">
		<cfset var add=0>
		<cfset var update=0>
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT NEWSLETTERID FROM NEWSLETTERQUEUE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfquery name="add" datasource="#arguments.ds#">
				INSERT INTO NEWSLETTERQUEUE
				(
					NEWSLETTERID,
					QUEUEDON,
					SENDDATE,
					SENT
				)
				VALUES
				(
					<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.senddate#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.sent#" cfsqltype="cf_sql_varchar">
				)
				SELECT @@IDENTITY AS QUEUEID
			</cfquery>
			<cfreturn add.QUEUEID>
		<cfelse>
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE NEWSLETTERQUEUE
				SET	QUEUEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				SENDDATE=<cfqueryparam value="#arguments.senddate#" cfsqltype="cf_sql_varchar">,
				SENT=<cfqueryparam value="#arguments.sent#" cfsqltype="cf_sql_varchar">
				WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfreturn 0>	
		</cfif>	
	</cffunction>
	
	<cffunction name="ChangeSendDate" access="public" output="false" returntype="void" hint="I change send date for newsletter put in queue">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="senddate" required="true" type="string" hint="I am the new date when the newsletter should be sent">
		<cfargument name="queueid" required="true" type="string" hint="I am the queueid you want to change">
		<cfquery name="" datasource="#arguments.ds#">
			UPDATE NEWSLETTERQUEUE
			SET
				SENDDATE=<cfqueryparam value="#arguments.newsenddate#" cfsqltype="cf_sql_varchar">
			WHERE QUEUEID=<cfqueryparam value="#arguments.queueid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
	</cffunction> 
	
	<cffunction name="deleteNewsLetter" access="public" output="false" returntype="String" hint="I delete NewsLetter. I return 1 if successful and 0 if not">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="newsletterid" type="string" required="true" hint="Newsletterid of the Newsletter">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTOEMAILTYPE WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			DELETE FROM NEWSLETTERQUEUE WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			DELETE FROM NEWSLETTERTOUSERGROUP WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			DELETE FROM NEWSLETTER WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">			
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="removeFromQueue" access="public" output="false" returntype="void" hint="I delete newsletter from queue">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="newsletterid" type="string" required="true" hint="Newsletterid of the Newsletter">
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERQUEUE 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteNewsLettergroup" access="public" output="false" returntype="String" hint="I delete groups associated with the newsletter">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTOUSERGROUP
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTOUSERGROUPEXCLUDE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="deletenewslettertoemailtype" access="public" output="false" returntype="String" hint="I delete email types associated with the newsletter">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM NEWSLETTERTOEMAILTYPE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="sendnewsletter" access="public" returntype="String" hint="I send newsletter">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="fromaddress" type="string" required="false" default="newsletter@#ds#" hint="Email of the person who is sending the newsletter">
		<cfargument name="fromname" type="string" required="false" default="0" hint="name of the person sending the newsletter">
		<cfargument name="newsletterid" type="String" required="false" default="0" hint="I am newsletterid">
		<cfargument name="toemail" type="String" required="false" default="0" hint="I am the email address the testeamil should be sent to">
		<cfargument name="viewonsite" 
					type="string" 
					required="false" 
					default="If you are having trouble viewing this email, you may view it online by following this link:" 
					hint="I am the message for the user to view this newsletter on the website, I default to (If you are having trouble viewing this email, you may view it online by following this link:)">
		<cfargument name="disclaimer" 
					type="string" 
					required="false" 
					default="<small>This electronic newsletter has been sent using the QDCMS by Quantum Delta LLC located at 8835 S. Memorial Dr. Tulsa, OK 74133.</small>" 
					hint="I am the message for the user to view this newsletter on the website, I default to (<small>This electronic newsletter has been sent using the QDCMS by Quantum Delta LLC located at 8835 S. Memorial Dr. Tulsa, OK 74133.</small>)">
		<cfargument name="unsubscribe" 
					type="string" 
					required="false" 
					default="To unsubscribe and be placed on the DO NOT EMAIL list, please click here:" 
					hint="I am the message for the user to unsubscribe, I default to (To unsubscribe and be placed on the DO NOT EMAIL list, please click here:)">
		<cfargument name="sendunsubscribelink" type="string" required="false" default="1" hint="0 if unsubscribe link should not be sent">
		<cfset var myqueue=0>
		<cfset var args=structNew()>
		<cfset var initialtoemail=arguments.toemail>
		<cfset var filepath='/home/drew/domains/qdcms.com/public_html/marketing/newsletter'>
		<cfoutput>
		<cfset timenow=mytime.createtimedate()>
		
		<cfif arguments.toemail EQ "0">
			<cfinvoke method="getqueue" argumentcollection="#arguments#" returnvariable="myqueue">
		<cfelse>
			<cfquery name="myqueue" datasource="#arguments.ds#">
				SELECT NEWSLETTERID FROM NEWSLETTER WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		
		<cfloop query="myqueue">
			<!--- set the arguments newsletterid equal to the id of the current newsletter we are looking at in our queue recordset now --->
			<cfset arguments.newsletterid=myqueue.newsletterid>
			<!--- get all the information on this particular newsletter --->
			<cfinvoke method="getnewsletter" argumentcollection="#arguments#" returnvariable="thisnewsletter">
			<!--- compile all of the email addresses this newsletter needs to be sent to and return them to me as a list --->
			
			<cfif arguments.toemail EQ "0">
			<cfinvoke method="compileEmail" argumentcollection="#arguments#" returnvariable="emaillist">
			<cfelse>
				<cfset emaillist=arguments.toemail>
			</cfif>
			
			<!--- set the link for viewing this newletter on the clients website --->
			<cfsavecontent variable="args.viewonsitelink">
				<a href="http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#">http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#</a>
			</cfsavecontent>
			
			<cfsavecontent variable="args.forwardlink">
				<a href="http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#/forward">Forward this newsletter</a>
			</cfsavecontent>
			
			<!--- now for each newsletter in our queue recordset, loop over each email address it needs to be emailed to --->
			<cfloop list="#emaillist#" index="emailaddress">
				<cftry>
				<cfset args.nameid=listFirst(emailaddress,':')>
				<cfset args.emailaddress=listLast(emailaddress,':')>
				<cfset args.senttoemail=listLast(emailaddress,':')>
			
				<!--- set name for who this newletter is being sent to --->
				<cfinvoke component="addressbook" method="getContactInfo" contactdsn="#arguments.ds#" nameid="#args.nameid#" returnvariable="myContact">
				<cfset args.contactname = "#objtextconversions.stripallbut(myContact.firstname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)# #objtextconversions.stripallbut(myContact.lastname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)#">
				
				<!--- set who the email is coming from --->
				<cfif arguments.fromname neq 0>
					<cfset args.fromcontact="#objtextconversions.stripallbut(arguments.fromname, "1234567890abcdefghijklmnopqrstuvwxyz. ", false)#<#arguments.fromaddress#>">
				<cfelse>
					<cfset args.fromcontact="#objtextconversions.stripallbut(thisnewsletter.sendfromname, "1234567890abcdefghijklmnopqrstuvwxyz.", false)#<#arguments.fromaddress#>">
				</cfif>
				
				<!--- add the tracking info for this email address --->
				<cfif args.nameid NEQ 0>
					<cfinvoke method="addNewsletterTracking" argumentcollection="#arguments#" senttoemail="#args.senttoemail#" nameid="#args.nameid#" returnvariable="newsUUID">
				<cfelse>
					<cfset newsUUID=0>
				</cfif>
			
				
				<!--- Stuff to send with codes --->
				<cfset thisnewsletter.TEXTNEWSLETTER=reReplace(thisnewsletter.TEXTNEWSLETTER,'@firstname',myContact.firstname)>
				<cfset thisnewsletter.htmlnewsletter=reReplace(thisnewsletter.htmlnewsletter,'@firstname',myContact.firstname)>
				
				<cfset thisnewsletter.TEXTNEWSLETTER=reReplace(thisnewsletter.TEXTNEWSLETTER,'@lastname',myContact.lastname)>
				<cfset thisnewsletter.htmlnewsletter=reReplace(thisnewsletter.htmlnewsletter,'@lastname',myContact.lastname)>
				
				<cfset thisnewsletter.TEXTNEWSLETTER=reReplace(thisnewsletter.TEXTNEWSLETTER,'@email',args.senttoemail)>
				<cfset thisnewsletter.htmlnewsletter=reReplace(thisnewsletter.htmlnewsletter,'@email',args.senttoemail)>
				
				<cfif findNoCase('@pass',thisnewsletter.TEXTNEWSLETTER)>
					<cfquery name="findpass" datasource="#arguments.ds#" maxrows="1">
					SELECT PASSWORD AS PASS
					FROM NAME
					WHERE NAMEID=<cfqueryparam value="#nameid#">
					</cfquery>
					<cfif findpass.recordcount eq 1>
						<cfset thisnewsletter.TEXTNEWSLETTER=reReplace(thisnewsletter.TEXTNEWSLETTER,'@pass',findpass.pass)>
						
					<cfelse>
						<cfset thisnewsletter.TEXTNEWSLETTER=reReplace(thisnewsletter.TEXTNEWSLETTER,'@pass','password not found')>
						
					</cfif>
				</cfif>
				
				<cfif findNoCase('@pass',thisnewsletter.htmlnewsletter)>
					<cfquery name="findpass" datasource="#arguments.ds#" maxrows="1">
					SELECT PASSWORD AS PASS
					FROM NAME
					WHERE NAMEID=<cfqueryparam value="#nameid#">
					</cfquery>
					<cfif findpass.recordcount eq 1>
						<cfset thisnewsletter.htmlnewsletter=reReplace(thisnewsletter.htmlnewsletter,'@pass',findpass.pass)>
						
					<cfelse>
						<cfset thisnewsletter.htmlnewsletter=reReplace(thisnewsletter.htmlnewsletter,'@pass','password not found')>
						
					</cfif>
				</cfif>
				<!--- end send stuff with codes --->
				
					
				<cfsavecontent variable="args.unsubscribelink">
					<a href="http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/unsubscribe/#args.nameid#">http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/unsubscribe/#args.nameid#</a>
				</cfsavecontent>
				
				<!--- text and html to send --->
				<cfif len(#thisnewsletter.TEXTNEWSLETTER#) and len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#args.contactname#<#args.senttoemail#>" from="#args.fromcontact#" replyto="#thisnewsletter.replyto#" subject="#thisnewsletter.subject#">
						<cfmailpart type="text/plain" wraptext="72">
							#arguments.viewonsite# #args.viewonsitelink#
							#thisnewsletter.textnewsletter#
							<cfif arguments.sendunsubscribelink EQ 1>
							#arguments.unsubscribe#
							</cfif>
							#arguments.disclaimer#
						</cfmailpart>
						<cfmailpart type="text/html">
						<html>
							<head>
								<title>#thisnewsletter.subject#</title>
							</head>
							<body>
							#arguments.viewonsite# #args.viewonsitelink#<br />
							#args.forwardlink# <br />
							#thisnewsletter.htmlnewsletter#<br />
							#args.forwardlink# <br />
							<cfif arguments.sendunsubscribelink EQ 1>
							#arguments.unsubscribe# #args.unsubscribelink#<br />
							</cfif>
							#arguments.disclaimer# <br /><br />
							<img src="http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/track/#newsUUID#" height="1" width="1">
							</body>
						</html>
						</cfmailpart>
					</cfmail>
				<!--- text only to send --->
				<cfelseif len(#thisnewsletter.TEXTNEWSLETTER#) and not len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#args.senttoemail#" type="text/plain" wraptext="72" from="#arguments.fromaddress#" replyto="#thisnewsletter.replyto#" subject="#thisnewsletter.subject#">
						#arguments.viewonsite# #args.viewonsitelink#
						#args.forwardlink# 
						#thisnewsletter.textnewsletter#
						<cfif arguments.sendunsubscribelink EQ 1>
						#arguments.unsubscribe# #args.unsubscribelink#
						</cfif>
						#arguments.disclaimer#
					</cfmail>
				<!--- html only to send --->
				<cfelseif not len(#thisnewsletter.TEXTNEWSLETTER#) and len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#args.senttoemail#" type="text/html" from="#arguments.fromaddress#" replyto="#thisnewsletter.replyto#" subject="#thisnewsletter.subject#">
					<html>
						<head>
							<title>#thisnewsletter.subject#</title>
						</head>
						<body>
						#arguments.viewonsite# #args.viewonsitelink#<br />
						#args.forwardlink# <br />
						#thisnewsletter.htmlnewsletter#<br />
						#args.forwardlink# <br />
						<cfif arguments.sendunsubscribelink EQ 1>
						#arguments.unsubscribe# #args.unsubscribelink#<br />
						</cfif>
						#arguments.disclaimer# <br /><br />
						<img src="http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/track/#newsUUID#" height="1" width="1">
						</body>
					</html>
					</cfmail>
				</cfif>
					<cfcatch type="any">
						<cfset e=TimeFormat(now(),'yyyy-mm-dd hh:mmtt') & ' ' & cfcatch.message>
						<cfif NOT fileExists('#filepath#/errorlog.txt')>
							<cffile action="write" mode="775" output="#e#" file="#filepath#/errorlog.txt">
						<cfelse>
							<cffile action="append" output="#e#" file="#filepath#/errorlog.txt">
						</cfif>
					</cfcatch>
				</cftry>
			<!--- end looping over list of email addresses --->
			</cfloop>
			<!--- set this newsletter as sent --->
			<cfif arguments.toemail EQ "0">
				<cfinvoke component="newsletter" method="setAsSent" ds="#arguments.ds#" newsletterid="#arguments.newsletterid#">
			<cfelseif initialtoemail NEQ arguments.toemail>
				<cfset e=TimeFormat(now(),'yyyy-mm-dd h:mmtt') & " toemail changed from #intialtoemail# to #arguments.toemail#">
				<cfif NOT fileExists('#filepath#/errorlog.txt')>
					<cffile action="write" mode="775" output="#e#" file="#filepath#/errorlog.txt">
				<cfelse>
					<cffile action="append" output="#e#" file="#filepath#/errorlog.txt">
				</cfif>
			</cfif>
			<!---end the loop over the newsletter queue recordset --->
		</cfloop>
		</cfoutput>
	</cffunction>

	<cffunction name="forwardNewsletter" access="public" returntype="String" output="false" hint="I forward newsletter to people">
		<cfargument name="ds" required="true" type="string" hint="I am the data source">
		<cfargument name="newsletterid" required="true" type="string" hint="I am the id of the newsletter">
		<cfargument name="forwardlist" required="true" type="string" hint="I am list of people whom the newsletter should be forwarded">
		<cfargument name="frommessage" required="true" type="string" hint="Personal message for the receiver">
		<cfargument name="from" required="true" type="string" hint="email addresss and name of the person forwarding the email">
		<cfargument name="viewonsite" type="string" required="false" 
					default="If you are having trouble viewing this email, you may view it online by following this link:" 
					hint="I am the message for the user to view this newsletter on the website, I default to (If you are having trouble viewing this email, you may view it online by following this link:)">
		<cfset var fowardlink=0>
		<cfset fromname=listfirst(from,':')>
		<cfset fromemail=listLast(from,':')>
		<cfset count=0>
		<cfinvoke method="getnewsletter" argumentcollection="#arguments#" returnvariable="thisnewsletter">
		<cfoutput>
		<cfsavecontent variable="args.viewonsitelink">
			<a href="http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#">http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#</a>
		</cfsavecontent>
		<cfsavecontent variable="forwardlink">
			<a href="http://#arguments.ds#/newsletter/#thisnewsletter.NEWSLETTERID#/forward">Forward this newsletter</a>
		</cfsavecontent>	
			<cfloop list="#arguments.forwardlist#" index="emailaddress">
				<cfset toname=listFirst(emailaddress,':')>
				<cfset toemail=listLast(emailaddress,':')>
					
				<cfif len(#thisnewsletter.TEXTNEWSLETTER#) and len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#toname#<#toemail#>" from="#fromname#<#fromemail#>" replyto="#fromemail#" subject="Fwd - #thisnewsletter.subject#">
						<cfmailpart type="text/plain" wraptext="72">
							#arguments.frommessage#
							#arguments.viewonsite# #args.viewonsitelink#
							#forwardlink# 
							#thisnewsletter.textnewsletter#
						</cfmailpart>
						<cfmailpart type="text/html">
							<html>
								<head>
									<title>#thisnewsletter.subject#</title>
								</head>
								<body>
								#arguments.viewonsite# #args.viewonsitelink#<br /><br />
								Please Note: You have NOT been added to any email lists. If you no longer wish to receive these messages, please contact #fromemail#<br /><br />
								#fromname# has forwarded this email to you with the following message: #arguments.frommessage# <br /><br />
								#forwardlink# <br />
								#thisnewsletter.htmlnewsletter#<br /><br />
								#forwardlink# <br />
								</body>
							</html>
						</cfmailpart>
					</cfmail>
				<!--- text only to send --->
				<cfelseif len(#thisnewsletter.TEXTNEWSLETTER#) and not len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#toname#<#toemail#>" type="text/plain" wraptext="72" from="#fromname#<#fromemail#>" replyto="#fromemail#" subject="Fwd - #thisnewsletter.subject#">
						#arguments.viewonsite# #args.viewonsitelink#
						Please Note: You have NOT been added to any email lists. If you no longer wish to receive these messages, please contact #fromemail#
						#fromname# has forwarded this email to you with the following message: #arguments.frommessage#
						#forwardlink#
						#thisnewsletter.textnewsletter#
					</cfmail>
				<!--- html only to send --->
				<cfelseif not len(#thisnewsletter.TEXTNEWSLETTER#) and len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#toname#<#toemail#>" type="text/html" from="#fromname#<#fromemail#>" replyto="#fromemail#" subject="#thisnewsletter.subject#">
						<html>
							<head>
								<title>#thisnewsletter.subject#</title>
							</head>
							<body>
								#arguments.viewonsite# #args.viewonsitelink#<br /><br />
								Please Note: You have NOT been added to any email lists. If you no longer wish to receive these messages, please contact #fromemail#<br /><br />
								#fromname# has forwarded this email to you with the following message: #arguments.frommessage# <br /><br />
								#forwardlink# <br />
								#thisnewsletter.htmlnewsletter#<br /><br />
								#forwardlink# <br />
							</body>
						</html>
					</cfmail>
				</cfif>
				<cfset count=count+1>
			</cfloop>
		</cfoutput>
		<cfreturn count>
	</cffunction>
		
	<cffunction name="getSentNewsletter" access="public" output="false" returntype="query" hint="I get newsletters that are sent. The output is meant to be shown in website">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="noOfNewsletters" type="string" required="false" default="0" hint="Maximum number of newsletters to display">
		<cfargument name="sendmonth" type="string" required="false" default="0" hint="month when the newsletter was sent">
		<cfargument name="newsletterid" type="String" required="false" default="0" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				<cfif arguments.noOfNewsletters GT 0>
				TOP #arguments.noofNewsletters#
				</cfif>
				NEWSLETTER.NEWSLETTERID,
				NEWSLETTER.NAME,
				NEWSLETTER.CREATEDON,
				NEWSLETTER.UPDATEDON,
				NEWSLETTER.HTMLNEWSLETTER,
				NEWSLETTER.TEXTNEWSLETTER,
				NEWSLETTERQUEUE.SENDDATE 
			FROM NEWSLETTER,NEWSLETTERQUEUE
			WHERE NEWSLETTER.NEWSLETTERID=NEWSLETTERQUEUE.NEWSLETTERID
			AND NEWSLETTERQUEUE.SENT > <cfqueryparam value="0">
			<cfif arguments.newsletterid NEQ "0">
			AND NEWSLETTER.NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#">
			</cfif>
			<cfif arguments.sendmonth NEQ "0">
			AND NEWSLETTERQUEUE.SENDDATE >= <cfqueryparam value="#arguments.sendmonth#0100000000"> 
			AND NEWSLETTERQUEUE.SENDDATE <= <cfqueryparam value="#arguments.sendmonth#3123599999">
			</cfif>
			ORDER BY NEWSLETTERQUEUE.SENDDATE DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="compileEmail" access="public" output="true" returntype="string">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var getemailtypes=0>
		<cfset var includegroups=0>
		<cfset var get=0>
		<cfset var donotemail=0>
		<cfset var excludegroups=0>
		<cfset var getcontacts=0>
		<cfset var emailtypes="">
		<cfset var fieldlist="NAMEID">
		<cfset var ids="">
		<cfset var includelist="">
		<cfset var donotemaillist="">
		<cfset var excludelist="">
		<cfset var thelist="">
		<cfobject component="textconversions" name="objtextconversions">
		<cfquery name="getemailtypes" datasource="#arguments.ds#">
			SELECT EMAILTYPE 
			FROM NEWSLETTERTOEMAILTYPE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset emailtypes=valuelist(getemailtypes.emailtype)>
		<cfset fieldlist=listappend(fieldlist,emailtypes)>
		
		<cfquery name="includegroups" datasource="#arguments.ds#">	
			SELECT USERGROUPID, EVENTID 
			FROM NEWSLETTERTOUSERGROUP 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfloop query="includegroups">
			<cfif EVENTID NEQ ''>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT NAMEID FROM PEOPLE2EVENT 
					WHERE EVENTID=<cfqueryparam value="#eventid#">
					AND USERGROUPID=<cfqueryparam value="#usergroupid#">
				</cfquery>
			<cfelse>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT NAMEID FROM PEOPLE2USERGROUPS
					WHERE USERGROUPID=<cfqueryparam value="#usergroupid#">
				</cfquery>
			</cfif>
			<cfset ids=valuelist(get.nameid)>
			<cfif listlen(ids) GT 0>
				<cfset includelist=listAppend(includelist,ids)>
			</cfif>
		</cfloop>
		
		<cfquery name="donotemail" datasource="#arguments.ds#">
			SELECT NAMEID FROM PEOPLE2USERGROUPS 
			WHERE USERGROUPID=(SELECT TOP 1 USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME=<cfqueryparam value='Do Not Email'>)
		</cfquery>
		
		<cfset donotemaillist=valuelist(donotemail.nameid)>
		
		<cfquery name="excludegroups" datasource="#arguments.ds#">	
			SELECT USERGROUPID, EVENTID 
			FROM NEWSLETTERTOUSERGROUPEXCLUDE 
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfloop query="excludegroups">
			<cfif EVENTID NEQ ''>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT NAMEID FROM PEOPLE2EVENT
					WHERE EVENTID=<cfqueryparam value="#eventid#">
					AND USERGROUPID=<cfqueryparam value="#usergroupid#">
				</cfquery>
			<cfelse>
				<cfquery name="get" datasource="#arguments.ds#">
					SELECT NAMEID FROM PEOPLE2USERGROUPS
					WHERE USERGROUPID=<cfqueryparam value="#usergroupid#">
				</cfquery>
			</cfif>
			<cfset ids=valuelist(get.nameid)>
			<cfif listlen(ids) GT 0>
				<cfset excludelist=listAppend(excludelist,ids)>
			</cfif>
		</cfloop>
		
		<cfset excludelist=listAppend(excludelist,donotemaillist)>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT #fieldlist# FROM NAME
			WHERE STATUS=1
			AND NAMEID IN (#includelist#)
			<cfif listlen(excludelist) GT 0>
			AND NAMEID NOT IN (#excludelist#)
			</cfif>
		</cfquery>
		
		<cfloop query="get">
			<cfset thisnameid=get.NAMEID>
			<cfloop list="#emailtypes#" index="emailtype">
				<cfset selected=FALSE>
				<cfset reason="">
				<cfset email=Trim(Evaluate("get.#emailtype#"))>
				<cfif objtextconversions.isEmail(email)>
					<cfif refind(email,thelist) EQ 0>
						<cfset selected=TRUE>
						<cfset thelist=listAppend(thelist,'#thisnameid#:#email#')>
					<cfelse>
						<cfset reason="Duplicate">
					</cfif>
				<cfelse>
					<cfset reason="Not An Email">
				</cfif>
				<!--- <cfoutput>#nameid#:#email# - #selected# #reason#</cfoutput><br /> --->
			</cfloop>
		</cfloop>
		<cfreturn thelist>
	</cffunction>
	
	<cffunction name="setassent" access="public" output="false" returntype="void" hint="I set newsletter as sent">
		<cfargument name="ds" required="true" type="String" hint="I am the data source">
		<cfargument name="newsletterid" required="true" type="String" hint="I am the newsletterid">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE NEWSLETTERQUEUE
			SET SENT=1
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="editTemplate" access="public" output="false" returntype="string" hint="I update the newsletter template, I return the id of the record you have updated.. if there is no record to update, I will add the record and return the id for that record">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newslettertemplateid" type="numeric" required="true" hint="I am the id for the newsletter you are updating">
		<cfargument name="Name" type="string" required="true" hint="I am the new name for the newsletter template">
		<cfargument name="template" type="string" required="false" default="0" hint="I am the updated template">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the updated template description">
		<cfargument name="imagepath" type="string" required="false" default="0" hint="I am the imagepath of updated template">
		<cfargument name="status" type="string" required="false" default="0" hint="Status of the template">
		<cfset var editTemplate=0>
		
		<cfquery name="editTemplate" datasource="#arguments.ds#">
			UPDATE NEWSLETTERTEMPLATE SET 
			NAME=<cfqueryparam value="#arguments.Name#">
			<cfif arguments.template neq 0>, TEMPLATE=<cfqueryparam value="#arguments.template#"></cfif>
			<cfif arguments.description neq 0>, DESCRIPTION=<cfqueryparam value="#arguments.description#"></cfif>
			<cfif arguments.imagepath neq 0>, IMAGEPATH=<cfqueryparam value="#arguments.imagepath#"></cfif>
			<cfif arguments.status NEQ 0>, STATUS=<cfqueryparam value="#arguments.status#"></cfif>
			WHERE NEWSLETTERTEMPLATEID=<cfqueryparam value="#arguments.newslettertemplateid#"> 
		</cfquery>
		<cfset myTemplateid=arguments.newslettertemplateid>
		<cfreturn myTemplateid>
	</cffunction>
	
	<cffunction name="getnameid" access="public" output="false" returntype="string" hint="I get the nameid from newsletteruuid">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource for updating the newsletter template">
		<cfargument name="newsletteruuid" type="string" required="true" hint="i am newsletteruuid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT NAMEID FROM NEWSLETTERTRACKING WHERE NEWSLETTERUUID=<cfqueryparam value="#arguments.newsletteruuid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.nameid>
	</cffunction>
	
	<cffunction name="myXmlTemplates" access="public" returntype="xml">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<cfargument name="parentsiteid" required="false" type="string" default="0" hint="siteid of the parent">
		<cfinvoke method="getTemplate" argumentcollection="#arguments#" returnvariable="getMyTemplates">
		<cfoutput>
		<cfif getMyTemplates.recordcount gt 0>
			<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
				<Templates>
				 <cfloop query="getMyTemplates">
				  <cfif INPARENT NEQ 0>
					<cfset basepath="http://#inparent#">
			      <cfelse>
				 	<cfset basepath="http://#arguments.ds#">
				  </cfif>
				  <Template title="#name#" image="#basepath#/images/qdcms/#imagepath#">
				    <Description>#description#</Description>
				    <Html>
				      <![CDATA[
				        #template#
				      ]]>
				    </Html>
				  </Template>
				 </cfloop>
				</Templates>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
<!---
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2009 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * This is the sample templates definitions file. It makes the "templates"
 * command completely customizable.
 *
 * See FCKConfig.TemplatesXmlPath in the configuration file.
--->
<Templates imagesBasePath="fck_template/images/">
	<Template title="Image and Title" image="template1.gif">
		<Description>One main image with a title and text that surround the image.</Description>
		<Html>
			<![CDATA[
				<img style="MARGIN-RIGHT: 10px" height="100" alt="" width="100" align="left"/>
				<h3>Type the title here</h3>
				Type the text here
			]]>
		</Html>
	</Template>
	<Template title="Strange Template" image="template2.gif">
		<Description>A template that defines two colums, each one with a title, and some text.</Description>
		<Html>
			<![CDATA[
				<table cellspacing="0" cellpadding="0" width="100%" border="0">
					<tbody>
						<tr>
							<td width="50%">
							<h3>Title 1</h3>
							</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td width="50%">
							<h3>Title 2</h3>
							</td>
						</tr>
						<tr>
							<td>Text 1</td>
							<td>&nbsp;</td>
							<td>Text 2</td>
						</tr>
					</tbody>
				</table>
				More text goes here.
			]]>
		</Html>
	</Template>
	<Template title="Text and Table" image="template3.gif">
		<Description>A title with some text and a table.</Description>
		<Html>
			<![CDATA[
				<table align="left" width="80%" border="0" cellspacing="0" cellpadding="0"><tr><td>
					<h3>Title goes here</h3>
					<p>
					<table style="FLOAT: right" cellspacing="0" cellpadding="0" width="150" border="1">
						<tbody>
							<tr>
								<td align="center" colspan="3"><strong>Table title</strong></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</tbody>
					</table>
					Type the text here</p>
				</td></tr></table>
			]]>
		</Html>
	</Template>
</Templates>
</cfsavecontent>
	</cfif>
	</cfoutput>
	<cfreturn myXml>
	</cffunction>
	
</cfcomponent>