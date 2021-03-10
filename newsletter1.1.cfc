<cfcomponent hint="I handle all of the newsletter functions">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions" name="objtextconversions">
	<cfobject component="qdDataMgr" name="tblCheck">
	
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
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTOUSERGROUP
			(
				NEWSLETTERID,
				USERGROUPID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.usergroupid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="excludeusergroup" access="public" output="false" returntype="void" hint="I store the list of groups to which the newsletter should not be sent to">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfargument name="usergroupid" type="String" required="true" hint="I am usergroupid"> 
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO NEWSLETTERTOUSERGROUPEXCLUDE
			(
				NEWSLETTERID,
				USERGROUPID
			)
			VALUES
			(
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
			NEWSLETTERID,
			NAME,
			CREATEDON,
			UPDATEDON,
			HTMLNEWSLETTER,
			TEXTNEWSLETTER,
			SUBJECT,
			CREATEDBYMASTERID,
			REPLYTO,
			SENDFROMNAME,
			NEWSLETTERTEMPLATEID
			FROM NEWSLETTER
			WHERE 1=1
			<cfif arguments.newsletterid NEQ 0>
			AND NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.keyword neq 0>
			AND 
			( 
				NEWSLETTER.NAME LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR NEWSLETTER.HTMLNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR NEWSLETTER.TEXTNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR NEWSLETTER.TEXTNEWSLETTER LIKE <cfqueryparam value="%#arguments.keyword#%">
				OR NEWSLETTER.SUBJECT LIKE <cfqueryparam value="%#arguments.keyword#%">
			)
			</cfif>
			ORDER BY CREATEDON DESC
		</cfquery>
		<cfreturn getmynewsletter>
	</cffunction>
	
	<cffunction name="getnewslettergroups" access="public" output="false" returntype="query" hint="I get all the user groups assigned to newsletterid">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT USERGROUPID FROM NEWSLETTERTOUSERGROUP
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getnewsletterexcludegroups" access="public" output="false" returntype="query" hint="I get all the user groups to whom newsletter should not be sent">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT USERGROUPID FROM NEWSLETTERTOUSERGROUPEXCLUDE
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
		<cfquery name="getMytemplate" datasource="#arguments.ds#">
			SELECT
				NEWSLETTERTEMPLATEID,
				NAME,
				TEMPLATE,
				DESCRIPTION,
				IMAGEPATH,
				STATUS
			FROM NEWSLETTERTEMPLATE
			<cfif arguments.newslettertemplateid NEQ 0>
			WHERE NEWSLETTERTEMPLATEID=<cfqueryparam value="#arguments.newslettertemplateid#">
			</cfif>
		</cfquery>
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
				'NOT VIEWED' AS TIMEVIEWED
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
		<cfset var myqueue=0>
		<cfset var args=structNew()>
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
				<cfset args.nameid=listFirst(emailaddress,':')>
				<cfset args.emailaddress=listLast(emailaddress,':')>
				<cfset args.senttoemail=listLast(emailaddress,':')>
			
				<!--- set name for who this newletter is being sent to --->
				<cfinvoke component="addressbook" method="getContactInfo" contactdsn="#arguments.ds#" nameid="#args.nameid#" returnvariable="myContact">
				<cfset args.contactname = "#objtextconversions.stripallbut(myContact.firstname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)# #objtextconversions.stripallbut(myContact.lastname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)#">
				
				<!--- set who the email is coming from --->
				<cfif arguments.fromname neq 0>
					<cfset args.fromcontact="#objtextconversions.stripallbut(arguments.fromname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)#<#arguments.fromaddress#>">
				<cfelse>
					<cfset args.fromcontact="#objtextconversions.stripallbut(thisnewsletter.sendfromname, "1234567890abcdefghijklmnopqrstuvwxyz ", false)#<#arguments.fromaddress#>">
				</cfif>
				
				<!--- add the tracking info for this email address --->
				<cfif args.nameid NEQ 0>
					<cfinvoke method="addNewsletterTracking" argumentcollection="#arguments#" senttoemail="#args.senttoemail#" nameid="#args.nameid#" returnvariable="newsUUID">
				<cfelse>
					<cfset newsUUID=0>
				</cfif>
				
				<cfsavecontent variable="args.unsubscribelink">
					<a href="http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/unsubscribe/#args.nameid#">http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/unsubscribe/#args.nameid#</a>
				</cfsavecontent>
				
				<!--- text and html to send --->
				<cfif len(#thisnewsletter.TEXTNEWSLETTER#) and len(#thisnewsletter.htmlnewsletter#)>
					<cfmail to="#args.contactname#<#args.senttoemail#>" from="#args.fromcontact#" replyto="#thisnewsletter.replyto#" subject="#thisnewsletter.subject#">
						<cfmailpart type="text/plain" wraptext="72">
							#arguments.viewonsite# #args.viewonsitelink#
							#thisnewsletter.textnewsletter#
							#arguments.unsubscribe#
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
							#arguments.unsubscribe# #args.unsubscribelink#<br />
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
						#arguments.unsubscribe# #args.unsubscribelink#
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
						#arguments.unsubscribe# #args.unsubscribelink#<br />
						#arguments.disclaimer# <br /><br />
						<img src="http://#arguments.ds#/newsletter/#thisnewsletter.newsletterid#/track/#newsUUID#" height="1" width="1">
						</body>
					</html>
					</cfmail>
				</cfif>
			<!--- end looping over list of email addresses --->
			</cfloop>
			<!--- set this newsletter as sent --->
			<cfif arguments.toemail EQ "0">
				<cfinvoke method="setAsSent" argumentcollection="#arguments#">
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
			AND NEWSLETTERQUEUE.SENT=1
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
	
	<cffunction name="compileEmail" access="public" output="false" returntype="string" hint="I compile email address for a newsletter">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource for the newsletter">
		<cfargument name="newsletterid" type="String" required="true" hint="I am newsletterid">
		<cfset var getemailtype=0>
		<cfset var hemails=0>
		<cfset var wemails=0>
		<cfset var memails=0>
		<cfset var oemails=0>
		<cfset var getnamelist=0>
		<cfset var namelist="">
		<cfset var emaillist="">
		<cfset var emailtypes="">
		<cfset var doNotEmailList="">
		
		<!--- get the list of those in the 'do not email' group --->
		<cfinvoke component="addressbook" method="getGroupContacts" contactdsn="#arguments.ds#" groupname="do not email" returnvariable="doNotEmail">
		<cfif doNotEmail.recordcount gt 0>
			<!--- set the doNotEmailList --->
			<cfset doNotEmailList=ValueList(doNotEmail.userid)>
		</cfif>
		
		<cfquery name="getemailtype" datasource="#arguments.ds#">
			SELECT EMAILTYPE 
			FROM NEWSLETTERTOEMAILTYPE
			WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfloop query="getemailtype">
			<cfset emailtypes=listAppend(emailtypes,emailtype)>
		</cfloop>
		
		<cfquery name="getnamelist" datasource="#arguments.ds#">
			SELECT NAMEID 
			FROM PEOPLE2USERGROUPS 
			WHERE USERGROUPID IN(SELECT USERGROUPID FROM NEWSLETTERTOUSERGROUP WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">)
			AND NAMEID NOT IN (SELECT NAMEID FROM PEOPLE2USERGROUPS WHERE USERGROUPID IN (SELECT USERGROUPID FROM NEWSLETTERTOUSERGROUPEXCLUDE WHERE NEWSLETTERID=<cfqueryparam value="#arguments.newsletterid#" cfsqltype="cf_sql_varchar">))
			<cfif ListLen(doNotEmailList) gt 0>AND NAMEID NOT IN(#doNotEmailList#)</cfif>
		</cfquery>
		
		<cfloop query="getnamelist">
			<cfset namelist=listAppend(namelist,nameid)>
		</cfloop>
		
		<!--- check for HEMAIL --->
		<cfif listfindnocase(emailtypes,"hemail") GT 0>
			<cfquery name="hemails" datasource="#arguments.ds#">
				SELECT 
					NAMEID,
					HEMAIL 
				FROM NAME 
				WHERE NAMEID IN(#namelist#)
				AND HEMAIL LIKE '%@%'
				AND STATUS<>0
			</cfquery>
			<cfloop query="hemails">
				<cfset result=objtextconversions.isEmail(hemail)>
				<cfif result>
					<cfif listfindnocase(emaillist, hemail,",:") EQ 0>
						<cfset emaillist=listAppend(emaillist,'#NAMEID#:#hemail#')>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- check for WEMAIL --->
		<cfif listfindnocase(emailtypes,"wemail") GT 0>
			<cfquery name="wemails" datasource="#arguments.ds#">
				SELECT 
					NAMEID,
					WEMAIL 
				FROM NAME 
				WHERE NAMEID IN(#namelist#)
				AND WEMAIL LIKE '%@%'
				AND STATUS<>0
			</cfquery>
			<cfloop query="wemails">
				<cfset result=objtextconversions.isEmail(wemail)>
				<cfif result>
					<cfif listfindnocase(emaillist, wemail,",:") EQ 0>
						<cfset emaillist=listAppend(emaillist,'#NAMEID#:#wemail#')>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		
		<!--- check for OEMAIL --->
		<cfif listfindnocase(emailtypes,"oemail") GT 0>
			<cfquery name="oemails" datasource="#arguments.ds#">
				SELECT 
					NAMEID,
					OEMAIL 
				FROM NAME 
				WHERE NAMEID IN(#namelist#)
				AND OEMAIL LIKE '%@%'
				AND STATUS<>0
			</cfquery>
			<cfloop query="oemails">
				<cfset result=objtextconversions.isEmail(oemail)>
				<cfif result>
					<cfif listfindnocase(emaillist, oemail,",:") EQ 0>
						<cfset emaillist=listAppend(emaillist,'#NAMEID#:#oemail#')>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		
		<!--- check for MEMAIL --->
		<cfif listfindnocase(emailtypes,"memail") GT 0>
			<cfquery name="memails" datasource="#arguments.ds#">
				SELECT 
					NAMEID,
					MEMAIL 
				FROM NAME 
				WHERE NAMEID IN(#namelist#)
				AND MEMAIL LIKE '%@%'
				AND STATUS<>0
			</cfquery>
			<cfloop query="memails">
				<cfset result=objtextconversions.isEmail(memail)>
				<cfif result>
					<cfif listfindnocase(emaillist, memail,",:") EQ 0>
						<cfset emaillist=listAppend(emaillist,'#NAMEID#:#memail#')>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif listlen(emaillist GT 0)>
			<cfreturn emaillist>
		</cfif>
		<cfreturn "0">
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
		<cfinvoke component="newsletter" method="getTemplate" returnvariable="myTemplate" ds="#arguments.ds#" newslettertemplateid="#arguments.newslettertemplateid#">
		<cfif myTemplate.recordcount gt 0>
			<cfquery name="editTemplate" datasource="#arguments.ds#">
			UPDATE NEWSLETTERTEMPLATE
			SET NAME=<cfqueryparam value="#arguments.Name#">
			<cfif arguments.template neq 0>, TEMPLATE=<cfqueryparam value="#arguments.template#"></cfif>
			<cfif arguments.description neq 0>, DESCRIPTION=<cfqueryparam value="#arguments.description#"></cfif>
			<cfif arguments.imagepath neq 0>, IMAGEPATH=<cfqueryparam value="#arguments.imagepath#"></cfif>
			WHERE NEWSLETTERTEMPLATEID=<cfqueryparam value="#arguments.newslettertemplateid#"> 
			</cfquery>
			<cfset myTemplateid="#arguments.newslettertemplateid#">
		<cfelse>
			<cfinvoke component="newsletter" method="addTemplate" argumentcollection="#arguments#" returnvariable="myTemplateid">
		</cfif>
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
		<cfinvoke component="newsletter" method="getTemplate" ds="#arguments.ds#" returnvariable="getMyTemplates">
		<cfoutput>
		<cfif getMyTemplates.recordcount gt 0>
		<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
		<Templates imagesBasePath="http://#arguments.ds#/">
		 <cfloop query="getMyTemplates">
		  <Template title="#name#" image="images/qdcms/#imagepath#">
		    <Description>#description#</Description>
		    <Html>
		      <![CDATA[
		        #template#
		      ]]>
		    </Html>
		  </Template>
		 </cfloop>
		</Templates></cfsavecontent>
	<cfelse>
		<cfsavecontent variable="myXml"><?xml version="1.0" encoding="utf-8" ?>
<!--
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
-->
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