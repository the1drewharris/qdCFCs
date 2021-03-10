<cfcomponent hint="New Forum CFC">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textconversions" name="objtextconversions">

	<cffunction name="getUnapprovedPostIds" access="public" output="false" returntype="query" hint="I get unapproved postids">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT POSTID FROM POSTS 
			WHERE POSTAPPROVED=0
			AND POSTDELETED=0
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="removeImage" access="public" output="false" returntype="void" hint="I remove image from the post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="I am the id of the post">
		<cfargument name="imageid" type="string" required="true" hint="ID of the image">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE POSTIMAGE SET STATUS=0
			WHERE POSTID=<cfqueryparam value="#arguments.postid#">
			AND IMAGEID=<cfqueryparam value="#arguments.imageid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getPoster" access="public" output="false" returntype="string" hint="I get id of the poster">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="I am the id of the post">
		<cfset var get=0>
		<cfset var posterid=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT POSTERID FROM POSTS
			WHERE POSTID=<cfqueryparam value="#arguments.postid#">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset posterid=get.POSTERID>
		</cfif>
		<cfreturn posterid>
	</cffunction>

	<cffunction name="getImages" access="public" output="false" returntype="query" hint="I get images for a post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="I am the id of the post">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT IMAGEID,IMAGEPATH FROM IMAGE
			WHERE IMAGEID IN 
			(
				SELECT IMAGEID FROM POSTIMAGE 
				WHERE POSTID=<cfqueryparam value="#arguments.postid#">
				AND STATUS=<cfqueryparam value="1">
			)
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="addimage" access="public" output="false" returntype="void" hint="I associate image with post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="I am the id of the post">
		<cfargument name="imageid" type="string" required="true" hint="I am the id of the image">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO POSTIMAGE
			(
				POSTID,
				IMAGEID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.postid#">,
				<cfqueryparam value="#arguments.imageid#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="unapprovePost" access="public" returntype="void" hint="I unapprove post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="I am the id of the post">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE POSTS SET POSTAPPROVED=0 
			WHERE POSTID =<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="unapproveTopic" access="public" returntype="void" hint="I unapprove post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="topicid" type="string" required="true" hint="I am the id of the topic">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE TOPICS SET TOPICAPPROVED=0 
			WHERE TOPICID =<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getdeletedTopicCount" access="public" returntype="string" hint="I get the count of deleted Topics">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS DELETEDCOUNT FROM TOPICS WHERE TOPICDELETED=1
		</cfquery>
		<cfreturn get.DELETEDCOUNT>
	</cffunction>
	
	<cffunction name="getdeletedPostCount" access="public" returntype="string" hint="I get hte count of delete Posts">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS DELETEDCOUNT FROM POSTS WHERE POSTDELETED=1
		</cfquery>
		<cfreturn get.DELETEDCOUNT>
	</cffunction>
	
	<cffunction name="getdeletedforumcount" access="public" returntype="string" hint="I get the count of deleted forums">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS DELETEDCOUNT FROM FORUMS WHERE STATUS=0
		</cfquery>
		<cfreturn get.DELETEDCOUNT>
	</cffunction>
	
	<cffunction name="gettopicid" access="public" returntype="string" hint="I get topicid from postid">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="postid" required="true" type="string" hint="I am the the postid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT TOPICID FROM POSTS WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.topicid>
	</cffunction>
	
	<cffunction name="getforumid" access="public" returntype="string" hint="I get forumid from postid or topicid">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="postid" required="false" type="string" default="0" hint="I am the the postid">
		<cfargument name="topicid" required="false" type="string" default="0" hint="I am the topicid">
		<cfset var get=0>
		<cfif arguments.postid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID FROM POSTS WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif arguments.topicid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID FROM TOPCIS WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn get.topicid>
	</cffunction>
	
	<cffunction name="commentsandsmiles" access="public" returntype="string" hint="I bring the bbcode back">
		<cfargument name="input" required="true" type="string" hint="string to strip of html">
		<cfset message=arguments.input>
		<cfset message=REReplaceNoCase(message,"\<![ \r\n\t]*?(--.*?--[ \r\n\t]*?)\>","","ALL")>
		
		<cfset arrow_image='<img src="{SMILIES_PATH}/icon_arrow.gif" alt=":arrow:" title="Arrow" />'>
		<cfset cool_image='<img src="{SMILIES_PATH}/icon_cool.gif" alt="8-)" title="Cool" />'>
		<cfset cry_image='<img src="{SMILIES_PATH}/icon_cry.gif" alt=":cry:" title="Crying or Very Sad" />'>
		<cfset biggrin_image='<img src="{SMILIES_PATH}/icon_e_biggrin.gif" alt=":D" title="Very Happy" />'>
		<cfset confused_image='<img src="{SMILIES_PATH}/icon_e_confused.gif" alt=":?" title="Confused" />'>
		<cfset geek_image='<img src="{SMILIES_PATH}/icon_e_geek.gif" alt=":geek:" title="Geek" />'>
		<cfset sad_image='<img src="{SMILIES_PATH}/icon_e_sad.gif" alt=":(" title="Sad" />'>
		<cfset smile_image='<img src="{SMILIES_PATH}/icon_e_smile.gif" alt=":)" title="Smile" />'>
		<cfset surprised_image='<img src="{SMILIES_PATH}/icon_e_surprised.gif" alt=":o" title="Surprised" />'>
		<cfset ugeek_image='<img src="{SMILIES_PATH}/icon_e_ugeek.gif" alt=":ugeek:" title="Uber Geek" />'>
		<cfset wink_image='<img src="{SMILIES_PATH}/icon_e_wink.gif" alt=";)" title="Wink" />'>
		<cfset eek_image='<img src="{SMILIES_PATH}/icon_eek.gif" alt=":shock:" title="Shocked">'>
		<cfset evil_image='<img src="{SMILIES_PATH}/icon_evil.gif" alt=":evil:" title="Evil or Very Mad" />'>
		<cfset exclaim_image='<img src="{SMILIES_PATH}/icon_exclaim.gif"  alt=":!:" title="Exclamation" />'>
		<cfset idea_image='<img src="{SMILIES_PATH}/icon_idea.gif" alt=":idea:" title="Idea" />'>
		<cfset lol_image='<img src="{SMILIES_PATH}/icon_lol.gif" alt=":lol:" title="Laughing" />'>
		<cfset mad_image='<img src="{SMILIES_PATH}/icon_mad.gif" alt=":x" title="Mad" />'>
		<cfset mrgreen_image='<img src="{SMILIES_PATH}/icon_mrgreen.gif" alt=":mrgreen:" title="Mr. Green" />'>
		<cfset neutral_image='<img src="{SMILIES_PATH}/icon_neutral.gif" alt=":|" title="Neutral" />'>
		<cfset question_image1='<img src="{SMILIES_PATH}/icon_question.gif" alt=":?:" title="Question" />'>
		<cfset question_image='<img src="{SMILIES_PATH}/icon_question.gif" alt=":?" title="Question" />'>
		<cfset razz_image='<img src="{SMILIES_PATH}/icon_razz.gif" alt=":P" title="Razz" />'>
		<cfset redface_image='<img src="{SMILIES_PATH}/icon_redface.gif" alt=":oops:" title="Embarrassed" />'>
		<cfset rolleyes_image='<img src="{SMILIES_PATH}/icon_rolleyes.gif" alt=":roll:" title="Rolling Eyes" />'>
		<cfset twisted_image='<img src="{SMILIES_PATH}/icon_twisted.gif" alt=":twisted:" title="Twisted Evil" />'>
		
		
		<cfset message = ReplaceNoCase(message, arrow_image, ":arrow:", "ALL")>
		<cfset message = ReplaceNoCase(message, cool_image, "8-)", "ALL")>
		<cfset message = ReplaceNoCase(message, cry_image, ":cry:", "ALL")>
		<cfset message = ReplaceNoCase(message, biggrin_image, ":D", "ALL")>
		<cfset message = ReplaceNoCase(message, confused_image, ":?", "ALL")>
		<cfset message = ReplaceNoCase(message, geek_image, ":geek:", "ALL")>
		<cfset message = ReplaceNoCase(message, sad_image, ":(", "ALL")>
		<cfset message = ReplaceNoCase(message, smile_image, ":)", "ALL")>
		<cfset message = ReplaceNoCase(message, surprised_image, ":o", "ALL")>
		<cfset message = ReplaceNoCase(message, ugeek_image, ":ugeek:", "ALL")>
		<cfset message = ReplaceNoCase(message, wink_image, ";)", "ALL")>
		<cfset message = ReplaceNoCase(message, eek_image, ":shock:", "ALL")>
		<cfset message = ReplaceNoCase(message, evil_image, ":evil:", "ALL")>
		<cfset message = ReplaceNoCase(message, exclaim_image, ":!:", "ALL")>
		<cfset message = ReplaceNoCase(message, idea_image, ":idea:", "ALL")>
		<cfset message = ReplaceNoCase(message, lol_image, ":lol:", "ALL")>
		<cfset message = ReplaceNoCase(message, mad_image, ":x", "ALL")>
		<cfset message = ReplaceNoCase(message, mrgreen_image, ":mrgreen:", "ALL")>
		<cfset message = ReplaceNoCase(message, neutral_image, ":|", "ALL")>
		<cfset message = ReplaceNoCase(message, question_image, ":?", "ALL")>
		<cfset message = ReplaceNoCase(message, question_image1, ":?", "ALL")>
		<cfset message = ReplaceNoCase(message, razz_image, ":P", "ALL")>
		<cfset message = ReplaceNoCase(message, redface_image, ":oops:", "ALL")>
		<cfset message = ReplaceNoCase(message, rolleyes_image, ":roll:", "ALL")>
		<cfset message = ReplaceNoCase(message, twisted_image, ":twisted:", "ALL")>
		
		<cfreturn message>
	</cffunction>
	
	<cffunction name="subscribeTopic" access="public" returntype="void" hint="I subscribe to the forum topic">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="topicid" type="string" required="true" hint="topicid of the topic">
		<cfargument name="nameid" type="string" required="true" hint="Id of the person who made the post">
		<cfset var subscribe=0>
		<cfset var check=0>
		<cfquery name="check" datasource="#arguments.ds#">
			SELECT NOTIFYSTATUS FROM TOPICWATCH 
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif check.recordcount GT 0>
			<cfquery name="subscribe" datasource="#arguments.ds#">
				UPDATE TOPICWATCH SET NOTIFYSTATUS=1
				WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
				AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfquery name="subscribe" datasource="#arguments.ds#">
				INSERT INTO TOPICWATCH
				(
					TOPICID,
					NAMEID,
					NOTIFYSTATUS
				)
				VALUES
				(
					<cfqueryparam value="#arguments..topicid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
					1
				)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="unsubscribeTopic" access="public" returntype="void" hint="I unsubscribe the forum topic">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="topicid" type="string" required="true" hint="topicid of the topic">
		<cfargument name="nameid" type="string" required="true" hint="Id of the person who made the post">
		<cfset var unsubscribe=0>
		<cfset var check=0>
		<cfquery name="check" datasource="#arguments.ds#">
			SELECT NOTIFYSTATUS FROM TOPICWATCH 
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif check.recordcount GT 0>
		<cfquery name="unsubscribe" datasource="#arguments.ds#">
			UPDATE TOPICWATCH SET NOTIFYSTATUS=0 
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="notifySubscribers" access="public" returntype="void" hint="I email subscribers">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="topicid" type="string" required="true" hint="topicid of the topic">
		<cfargument name="username" type="string" required="true" hint="username of the person posting">
		<cfargument name="postid" type="string" required="true" hint="Id of the post made">
		
		<cfset var users=0>
		<cfset var wemails=0>
		<cfset var namelist="">
		<cfset var emaillist="">
		<!--- get users who have subscribed to the topic --->
		<cfquery name="users" datasource="#arguments.ds#">
			SELECT NAMEID FROM TOPICWATCH
			WHERE NOTIFYSTATUS=1
			AND TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">		
		</cfquery>
		
		<cfloop query="users">
			<cfset namelist=listAppend(namelist,nameid)>
		</cfloop>
		<cfdump var="#namelist#">
		<cfif len(namelist)>
			<cfquery name="wemails" datasource="#arguments.ds#">
				SELECT 
					NAMEID,
					WEMAIL 
				FROM NAME 
				WHERE NAMEID IN (#namelist#)
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
			
			<cfquery name="gettopic" datasource="#arguments.ds#">
				SELECT TOPICTITLE FROM TOPICS WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfloop list="#emaillist#" index="emailaddress">
				<cfset nameid=listFirst(emailaddress,':')>
				<cfset emailaddress=listLast(emailaddress,':')>
				<cfset unsubscribelink="http://#arguments.ds#/forum/unsubscribe/#arguments.topicid#/#nameid#">
				
				<cfmail to="#emailaddress#" from="#application.emailadmin#" subject="New post made on topic you subscribed to" type="html">
					Dear Forum user, <br />
					#arguments.username# recently made a post to a forum topic <b>#gettopic.topictitle#</b>.<br />
					To view the post, <a href="http://#arguments.ds#/forum/post/#arguments.topicid#/?tp=l">click here.</a><br /><br />
					
					Forum Administrator <br />
					#arguments.ds# <br /> <br />
					
					<i>
						You received this email because you subscribed to it. If you no longer want to receive an email when somebody
						makes a post to this topic, <a href="#unsubscribelink#">click here</a>
					</i>
				</cfmail>
			</cfloop>
		</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="SearchForum" access="public" returntype="query" hint="I search">
		<cfargument name="keywords" required="false" default="0" type="string" hint="words to look for">
		<cfargument name="authorlist" required="false" type="string" default="0" hint="Author of the post">
		<cfargument name="topicid" required="false" type="string" default="0" hint="Id of the topic">
		<cfargument name="forumlist" required="false" type="string" default="0" hint="list of forums to look into">
		<cfargument name="sortfield" required="false" type="string"  default="postid" hint="name of the field">
		<cfargument name="sortorder" required="false" type="string" default="ASC" hint="ASC OR DESC">
		<cfargument name="limitresult" required="false" type="string" default="1" hint="1: All Available, 2: 1 Day 3: 1 Week, 4: 2 Weeks, 5: 1 Month, 6: 3 Months, 7: 6 Months, 8: 1 Year">
		<cfargument name="lowerlimit" required="false" type="string" default="0" hint="lower limit of the result">
		<cfargument name="resultsperpage" required="false" type="string" default="10" hint="no of results per page, default is 10">
		
		<cfset var get=0>
		<cfset arguments.keywords=rereplace(arguments.keywords,"[\s]+",",","All")>	
		<cfset arguments.authorlist=rereplace(arguments.authorlist,"[\s]+",",","All")>
			
		<cfset upperlimit=arguments.lowerlimit + arguments.resultsperpage>
		<!--- set starttime and endtime --->
		<cfif arguments.limitresult NEQ "1">
			<cfset endtime=mytime.createtimedate()>
			<cfswitch expression="#arguments.limitresult#">
				<cfcase value="2">
					<cfset starttime=DateAdd("d",-1,now())>
				</cfcase>
				<cfcase value="3">
					<cfset starttime=DateAdd("d",-7,now())>
				</cfcase>
				<cfcase value="4">
					<cfset starttime=DateAdd("d",-14,now())>
				</cfcase>
				<cfcase value="5">
					<cfset starttime=DateAdd("m",-1,now())>
				</cfcase>
				<cfcase value="6">
					<cfset starttime=DateAdd("m",-3,now())>
				</cfcase>
				<cfcase value="7">
					<cfset starttime=DateAdd("m",-6,now())>
				</cfcase>
				<cfcase value="8">
					<cfset starttime=DateAdd("yyyy",-1,now())>
				</cfcase>
			</cfswitch>
			<cfset starttime=mytime.datetoint(starttime)>
		</cfif>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM (
				SELECT
					POSTS.POSTID,
					POSTS.TOPICID,
					POSTS.FORUMID,
					POSTS.POSTERID,
					NAME.USERNAME AS POSTERNAME,
					POSTS.POSTERIP,
					POSTS.POSTTIME,
					POSTS.POSTAPPROVED,
					POSTS.POSTREPORTED,
					POSTS.POSTSUBJECT,
					POSTS.POSTTEXT,
					TOPICS.TOPICTITLE,
					FORUMS.NAME,
					ROW_NUMBER() OVER (ORDER BY #arguments.sortfield# #arguments.sortorder#) AS ROW
				FROM POSTS, NAME, TOPICS, FORUMS
				WHERE POSTS.POSTAPPROVED=1
				AND POSTS.POSTDELETED=0
				AND POSTS.TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)
				AND POSTS.FORUMID NOT IN (SELECT FORUMID FROM FORUMS WHERE STATUS=0 )
				AND POSTS.POSTERID=NAME.NAMEID
				AND TOPICS.TOPICID=POSTS.TOPICID
				AND FORUMS.FORUMID=POSTS.FORUMID
				<cfif arguments.limitresult NEQ 1>
				AND POSTS.POSTTIME>=<cfqueryparam value="#starttime#" cfsqltype="cf_sql_varchar">
				AND POSTS.POSTTIME<=<cfqueryparam value="#endtime#" cfsqltype="cf_sql_varchar">
				</cfif>  
				
				<cfif arguments.topicid NEQ "0">
				AND POSTS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
				</cfif>
				
				<cfif arguments.authorlist NEQ "0">
				AND 
				(
					<cfloop list="#arguments.authorlist#" index="author" delimiters=",+">
						NAME.USERNAME LIKE <cfqueryparam value="%#author#%" cfsqltype="cf_sql_varchar">
						<cfif listlast(arguments.authorlist) NEQ author>
						OR
						</cfif>
					</cfloop>
				)
				</cfif>
				
				<cfif arguments.forumlist NEQ "0">
				AND POSTS.FORUMID IN (#arguments.forumlist#)	
				</cfif>
				<cfif arguments.keywords NEQ 0>
				AND 
				(
					<cfloop list="#arguments.keywords#" index="keyword" delimiters=",+">
						POSTTEXT LIKE <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_varchar">
						OR
						POSTSUBJECT LIKE <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_varchar">
						<cfif listlast(arguments.keywords) NEQ keyword>
						OR
						</cfif>
					</cfloop>
				)
				</cfif>
				) ALLPOSTS WHERE ROW > <cfqueryparam value="#arguments.lowerlimit#"> AND ROW <= <cfqueryparam value="#upperlimit#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="searchResultCount" access="public" returntype="string" hint="I search">
		<cfargument name="keywords" required="false" default="0" type="string" hint="words to look for">
		<cfargument name="authorlist" required="false" type="string" default="0" hint="Author of the post">
		<cfargument name="topicid" required="false" type="string" default="0" hint="Id of the topic">
		<cfargument name="forumlist" required="false" type="string" default="0" hint="list of forums to look into">
		<cfargument name="sortfield" required="false" type="string"  default="postid" hint="name of the field">
		<cfargument name="sortorder" required="false" type="string" default="ASC" hint="ASC OR DESC">
		<cfargument name="limitresult" required="false" type="string" default="1" hint="1: All Available, 2: 1 Day 3: 1 Week, 4: 2 Weeks, 5: 1 Month, 6: 3 Months, 7: 6 Months, 8: 1 Year">
		
		<cfset var get=0>
		<cfset arguments.keywords=rereplace(arguments.keywords,"[\s]+",",","All")>	
		<cfset arguments.authorlist=rereplace(arguments.authorlist,"[\s]+",",","All")>
			
		<!--- set starttime and endtime --->
		<cfif arguments.limitresult NEQ "1">
			<cfset endtime=mytime.createtimedate()>
			<cfswitch expression="#arguments.limitresult#">
				<cfcase value="2">
					<cfset starttime=DateAdd("d",-1,now())>
				</cfcase>
				<cfcase value="3">
					<cfset starttime=DateAdd("d",-7,now())>
				</cfcase>
				<cfcase value="4">
					<cfset starttime=DateAdd("d",-14,now())>
				</cfcase>
				<cfcase value="5">
					<cfset starttime=DateAdd("m",-1,now())>
				</cfcase>
				<cfcase value="6">
					<cfset starttime=DateAdd("m",-3,now())>
				</cfcase>
				<cfcase value="7">
					<cfset starttime=DateAdd("m",-6,now())>
				</cfcase>
				<cfcase value="8">
					<cfset starttime=DateAdd("yyyy",-1,now())>
				</cfcase>
			</cfswitch>
			<cfset starttime=mytime.datetoint(starttime)>
		</cfif>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				COUNT(*) AS NOOFPOSTS
			FROM POSTS, NAME
			WHERE POSTS.POSTAPPROVED=1
			AND POSTS.POSTDELETED=0
			AND POSTS.TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)
			AND POSTS.POSTERID=NAME.NAMEID
			<cfif arguments.limitresult NEQ 1>
			AND POSTS.POSTTIME>=<cfqueryparam value="#starttime#" cfsqltype="cf_sql_varchar">
			AND POSTS.POSTTIME<=<cfqueryparam value="#endtime#" cfsqltype="cf_sql_varchar">
			</cfif>  
			
			<cfif arguments.topicid NEQ "0">
			AND POSTS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfif>
			
			<cfif arguments.authorlist NEQ "0">
			AND 
			(
				<cfloop list="#arguments.authorlist#" index="author" delimiters=",+">
					NAME.USERNAME LIKE <cfqueryparam value="%#author#%" cfsqltype="cf_sql_varchar">
					<cfif listlast(arguments.authorlist) NEQ author>
					OR
					</cfif>
				</cfloop>
			)
			</cfif>
			
			<cfif arguments.forumlist NEQ "0">
			AND POSTS.FORUMID IN (#arguments.forumlist#)	
			</cfif>
			<cfif arguments.keywords NEQ 0>
			AND 
			(
				<cfloop list="#arguments.keywords#" index="keyword" delimiters=",+">
					POSTTEXT LIKE <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_varchar">
					OR
					POSTSUBJECT LIKE <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_varchar">
					<cfif listlast(arguments.keywords) NEQ keyword>
					OR
					</cfif>
				</cfloop>
			)
			</cfif>
		</cfquery>
		<cfreturn get.NOOFPOSTS>
	</cffunction>
	 
	<cffunction name="stringTosmilies" access="public" returntype="string" description="replace the smily characters with smily images">
		<cfargument name="message" type="string" required="true" hint="I am the string on which smily characters should be looked for and replaced">
		<cfargument name="site" type="string" required="true" hint="I am the site where smily images should be looked for">
		<cfset arrow_image='<img src="{SMILIES_PATH}/icon_arrow.gif" alt=":arrow:" title="Arrow" />'>
		<cfset cool_image='<img src="{SMILIES_PATH}/icon_cool.gif" alt="8-)" title="Cool" />'>
		<cfset cry_image='<img src="{SMILIES_PATH}/icon_cry.gif" alt=":cry:" title="Crying or Very Sad" />'>
		<cfset biggrin_image='<img src="{SMILIES_PATH}/icon_e_biggrin.gif" alt=":D" title="Very Happy" />'>
		<cfset confused_image='<img src="{SMILIES_PATH}/icon_e_confused.gif" alt=":? " title="Confused" />'>
		<cfset geek_image='<img src="{SMILIES_PATH}/icon_e_geek.gif" alt=":geek:" title="Geek" />'>
		<cfset sad_image='<img src="{SMILIES_PATH}/icon_e_sad.gif" alt=":(" title="Sad" />'>
		<cfset smile_image='<img src="{SMILIES_PATH}/icon_e_smile.gif" alt=":)" title="Smile" />'>
		<cfset ugeek_image='<img src="{SMILIES_PATH}/icon_e_ugeek.gif" alt=":ugeek:" title="Uber Geek" />'>
		<cfset wink_image='<img src="{SMILIES_PATH}/icon_e_wink.gif" alt=";)" title="Wink" />'>
		<cfset eek_image='<img src="{SMILIES_PATH}/icon_eek.gif" alt=":shock:" title="Shocked">'>
		<cfset evil_image='<img src="{SMILIES_PATH}/icon_evil.gif" alt=":evil:" title="Evil or Very Mad" />'>
		<cfset exclaim_image='<img src="{SMILIES_PATH}/icon_exclaim.gif"  alt=":!:" title="Exclamation" />'>
		<cfset idea_image='<img src="{SMILIES_PATH}/icon_idea.gif" alt=":idea:" title="Idea" />'>
		<cfset lol_image='<img src="{SMILIES_PATH}/icon_lol.gif" alt=":lol:" title="Laughing" />'>
		<cfset mad_image='<img src="{SMILIES_PATH}/icon_mad.gif" alt=":x" title="Mad" />'>
		<cfset mrgreen_image='<img src="{SMILIES_PATH}/icon_mrgreen.gif" alt=":mrgreen:" title="Mr. Green" />'>
		<cfset neutral_image='<img src="{SMILIES_PATH}/icon_neutral.gif" alt=":|" title="Neutral" />'>
		<cfset question_image='<img src="{SMILIES_PATH}/icon_question.gif" alt=":?:" title="Question" />'>
		<cfset razz_image='<img src="{SMILIES_PATH}/icon_razz.gif" alt=":P" title="Razz" />'>
		<cfset redface_image='<img src="{SMILIES_PATH}/icon_redface.gif" alt=":oops:" title="Embarrassed" />'>
		<cfset rolleyes_image='<img src="{SMILIES_PATH}/icon_rolleyes.gif" alt=":roll:" title="Rolling Eyes" />'>
		<cfset twisted_image='<img src="{SMILIES_PATH}/icon_twisted.gif" alt=":twisted:" title="Twisted Evil" />'>
		<cfset surprised_image='<img src="{SMILIES_PATH}/icon_e_surprised.gif" alt=":o " title="Surprised" />'>
		
		<cfset message = ReplaceNoCase(message, ":arrow:", arrow_image, "ALL")>
		<cfset message = ReplaceNoCase(message, "8-)", cool_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":cry:", cry_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":D", biggrin_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":? ", confused_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":geek:", geek_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":(", sad_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":)", smile_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":ugeek:", ugeek_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ";)", wink_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":shock:", eek_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":evil:", evil_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":!:", exclaim_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":idea:", idea_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":lol:", lol_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":x", mad_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":mrgreen:", mrgreen_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":|", neutral_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":?:", question_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":P", razz_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":oops:", redface_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":roll:", rolleyes_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":twisted:", twisted_image, "ALL")>
		<cfset message = ReplaceNoCase(message, ":o ", surprised_image, "ALL")>
		<cfreturn message>
	</cffunction>
	
	<cffunction name="smiliesTostring" access="public" returntype="string" description="replace smily images with smily characters">
		<cfargument name="message" type="string" required="true" hint="I am the string on which smily characters should be looked for and replaced">
		<cfargument name="site" type="string" required="true" hint="I am the site where smily images should be looked for">
		<cfset arrow_image='<img src="{SMILIES_PATH}/icon_arrow.gif" alt=":arrow:" title="Arrow" />'>
		<cfset cool_image='<img src="{SMILIES_PATH}/icon_cool.gif" alt="8-)" title="Cool" />'>
		<cfset cry_image='<img src="{SMILIES_PATH}/icon_cry.gif" alt=":cry:" title="Crying or Very Sad" />'>
		<cfset biggrin_image='<img src="{SMILIES_PATH}/icon_e_biggrin.gif" alt=":D" title="Very Happy" />'>
		<cfset confused_image='<img src="{SMILIES_PATH}/icon_e_confused.gif" alt=":? " title="Confused" />'>
		<cfset geek_image='<img src="{SMILIES_PATH}/icon_e_geek.gif" alt=":geek:" title="Geek" />'>
		<cfset sad_image='<img src="{SMILIES_PATH}/icon_e_sad.gif" alt=":(" title="Sad" />'>
		<cfset smile_image='<img src="{SMILIES_PATH}/icon_e_smile.gif" alt=":)" title="Smile" />'>
		<cfset surprised_image='<img src="{SMILIES_PATH}/icon_e_surprised.gif" alt=":o " title="Surprised" />'>
		<cfset ugeek_image='<img src="{SMILIES_PATH}/icon_e_ugeek.gif" alt=":ugeek:" title="Uber Geek" />'>
		<cfset wink_image='<img src="{SMILIES_PATH}/icon_e_wink.gif" alt=";)" title="Wink" />'>
		<cfset eek_image='<img src="{SMILIES_PATH}/icon_eek.gif" alt=":shock:" title="Shocked">'>
		<cfset evil_image='<img src="{SMILIES_PATH}/icon_evil.gif" alt=":evil:" title="Evil or Very Mad" />'>
		<cfset exclaim_image='<img src="{SMILIES_PATH}/icon_exclaim.gif"  alt=":!:" title="Exclamation" />'>
		<cfset idea_image='<img src="{SMILIES_PATH}/icon_idea.gif" alt=":idea:" title="Idea" />'>
		<cfset lol_image='<img src="{SMILIES_PATH}/icon_lol.gif" alt=":lol:" title="Laughing" />'>
		<cfset mad_image='<img src="{SMILIES_PATH}/icon_mad.gif" alt=":x" title="Mad" />'>
		<cfset mrgreen_image='<img src="{SMILIES_PATH}/icon_mrgreen.gif" alt=":mrgreen:" title="Mr. Green" />'>
		<cfset neutral_image='<img src="{SMILIES_PATH}/icon_neutral.gif" alt=":|" title="Neutral" />'>
		<cfset question_image='<img src="{SMILIES_PATH}/icon_question.gif" alt=":?:" title="Question" />'>
		<cfset razz_image='<img src="{SMILIES_PATH}/icon_razz.gif" alt=":P" title="Razz" />'>
		<cfset redface_image='<img src="{SMILIES_PATH}/icon_redface.gif" alt=":oops:" title="Embarrassed" />'>
		<cfset rolleyes_image='<img src="{SMILIES_PATH}/icon_rolleyes.gif" alt=":roll:" title="Rolling Eyes" />'>
		<cfset twisted_image='<img src="{SMILIES_PATH}/icon_twisted.gif" alt=":twisted:" title="Twisted Evil" />'>
		
		<cfset message = ReplaceNoCase(message, arrow_image, ":arrow:", "ALL")>
		<cfset message = ReplaceNoCase(message, cool_image, "8-)", "ALL")>
		<cfset message = ReplaceNoCase(message, cry_image, ":cry:", "ALL")>
		<cfset message = ReplaceNoCase(message, biggrin_image, ":D", "ALL")>
		<cfset message = ReplaceNoCase(message, confused_image, ":? ", "ALL")>
		<cfset message = ReplaceNoCase(message, geek_image, ":geek:", "ALL")>
		<cfset message = ReplaceNoCase(message, sad_image, ":(", "ALL")>
		<cfset message = ReplaceNoCase(message, smile_image, ":)", "ALL")>
		<cfset message = ReplaceNoCase(message, ugeek_image, ":ugeek:", "ALL")>
		<cfset message = ReplaceNoCase(message, wink_image, ";)", "ALL")>
		<cfset message = ReplaceNoCase(message, eek_image, ":shock:", "ALL")>
		<cfset message = ReplaceNoCase(message, evil_image, ":evil:", "ALL")>
		<cfset message = ReplaceNoCase(message, exclaim_image, ":!:", "ALL")>
		<cfset message = ReplaceNoCase(message, idea_image, ":idea:", "ALL")>
		<cfset message = ReplaceNoCase(message, lol_image, ":lol:", "ALL")>
		<cfset message = ReplaceNoCase(message, mad_image, ":x", "ALL")>
		<cfset message = ReplaceNoCase(message, mrgreen_image, ":mrgreen:", "ALL")>
		<cfset message = ReplaceNoCase(message, neutral_image, ":|", "ALL")>
		<cfset message = ReplaceNoCase(message, question_image, ":?:", "ALL")>
		<cfset message = ReplaceNoCase(message, razz_image, ":P", "ALL")>
		<cfset message = ReplaceNoCase(message, redface_image, ":oops:", "ALL")>
		<cfset message = ReplaceNoCase(message, rolleyes_image, ":roll:", "ALL")>
		<cfset message = ReplaceNoCase(message, twisted_image, ":twisted:", "ALL")>
		<cfset message = ReplaceNoCase(message, surprised_image, ":o ", "ALL")>
		<cfreturn message>
	</cffunction>
	
	<cffunction name="displaypost" access="public" output="false" returntype="string" hint="I display posttext">
		<cfargument name="posttext" required="true" type="string"  hint="I am the posttext of the forum">
		<cfset thispost=arguments.posttext>
        
		<cfset thispost=REReplace(thispost,"(:[A-Za-z0-9]+\])","]","ALL")>
		<cfset thispost=REReplace(thispost,"\[\/quote\]","</div> <br />","ALL")>	
		<cfset thispost=REReplace(thispost,"\[quote=&quot;","<div style=""background-color:##ccc;border-style:solid;border-width:1px;padding:10px"">","ALL")>
		<cfset thispost=REReplace(thispost,"&quot;\]", " wrote <br />","ALL")>
		
<!--- 		<cfset thispost=REReplaceNocase(thispost,"\[quote=&quot;(.*?)&quot;:(.*?)\](.*?)\[/quote:(.*?)\](.*?)","<div style='background-color:##ccc;border-style:solid;border-width:1px;padding:10px'>\1 Wrote: <br /> \3 </div> \5","All")>
 --->	
 		
		<cfset thispost=REReplace(thispost,"{SMILIES_PATH}","http://quantumdelta.com/siteimages/smilies","ALL")>
		
		<cfset thispost=REReplaceNoCase(thispost,"\[b\](.*?)\[/b\]",'<span style="font-weight:bold;">\1</span>',"ALL")>
		<cfset thispost=REReplaceNoCase(thispost,"\[i\](.*?)\[/i\]",'<span style="font-style:italic;">\1</span>',"ALL")>
		<cfset thispost=REReplaceNoCase(thispost,"\[u\](.*?)\[/u\]",'<span style="text-decoration:underline;">\1</span>',"ALL")>
		
		<cfset thispost=REReplaceNoCase(thispost,"\[img\]\s*http://(.*?)\[/img\]", "<img src='http://\1' />", "ALL")>
		
		<cfset thispost=REReplaceNoCase(thispost,"\[url\]\s*http://(.*?)\[/url\]", "<a href=""http://\1"" target=""_blank"">\1</a>", "ALL")>
		<cfset thispost=REReplaceNoCase(thispost,"\[url=http://(.*?)\](.*?)\[/url\]", "<a href=""http://\1"" target=""_blank"">\2</a>", "ALL")>
		
		<cfset thispost=REReplaceNoCase(thispost,"\[url\](.*?)\[/url\]", "<a href=""http://\1"" target=""_blank"">\1</a>", "ALL")>
		<cfset thispost=REReplaceNoCase(thispost,"\[url=(.*?)\](.*?)\[/url\]", "<a href=""http://\1"" target=""_blank"">\2</a>", "ALL")>
		
		<cfset thispost=REReplace(thispost,"\[list=(.)\](.*?)\[/list\]","<ol type=\1>\2</ol>","ALL")>
		<cfset thispost=REReplace(thispost,"\[list\](.*?)\[/list\]","<ul>\1</ul>","ALL")>
		<cfset thispost=REReplace(thispost,"\[\*\]([^#chr(13)##chr(10)#]+)","<li>\1</li>","ALL")>
		
		<cfset thispost=REReplace(thispost,"#chr(10)#","<br />","All")>
		
		<!--- and finally remove all bbcodes in they are not yet processed. --->
		<cfset thispost=REReplace(thispost,"\[(.*?)\]","","ALL")>
		<cfreturn thispost>	
	</cffunction>
	
	<cffunction name="addforum" access="public" returntype="string" output="false" hint="I add forum">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="name" type="string" required="true" hint="I am the name of the forum">
		<cfargument name="description" type="string" required="true" hint="I am the description of the forum">
		<cfargument name="status" type="string" required="false" default="1" hint="I am the status of the query">
		<cfargument name="parentid" type="string" required="false" default="0" hint="I am the id of the parent of the forum">
		<cfset var add=0>
		<cfset var addchild=0>
		<cfset var timenow=mytime.createtimedate()>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO FORUMS
			(
				NAME,
				DESCRIPTION,
				CREATEDON,
				LASTUPDATED,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#Trim(arguments.name)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS FORUMID
		</cfquery>
		<cfif arguments.parentid NEQ 0>
			<cfquery name="addchild" datasource="#arguments.ds#">
				INSERT INTO FORUMS_RELATIONS
				(
					FORUMID,
					PARENTID
				)
				VALUES
				(
					<cfqueryparam value="#add.forumid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfif>
		<cfreturn add.FORUMID>
	</cffunction>
	
	<cffunction name="editforum" access="public" returntype="string" output="false" hint="I edit forum">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="forumid" type="string" required="true" hint="I am the id of the forum you are trying to change">
		<cfargument name="name" type="string" required="false" default="0" hint="I am the name of the forum">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description of the forum">
		<cfargument name="status" type="string" required="false" default="-1" hint="I am the status of the query">
		<cfargument name="parentid" type="string" required="false" default="0" hint="I am the parentid of the forum">
		<cfset var edit=0>
		<cfset var get=0>
		<cfquery name="edit" datasource="#arguments.ds#">
			UPDATE FORUMS
			SET LASTUPDATED=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			<cfif arguments.name NEQ "0">
				,NAME=<cfqueryparam value="#Trim(arguments.name)#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.description NEQ "0">
				,DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.status NEQ "-1">
				,STATUS=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#arguments.forumid#" returnvariable="oldparentid">
		
		<cfif oldparentid EQ parentid><cfreturn 1></cfif>

		<cfif arguments.parentid EQ 0>
			<cfquery name="edit" datasource="#arguments.ds#">
				DELETE FROM FORUMS_RELATIONS 
				WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT PARENTID FROM FORUMS_RELATIONS
				WHERE FORUMID=<cfqueryparam value="#arguments.forumid#">
			</cfquery>
			<cfif get.recordcount GT 0>
				<cfquery name="edit" datasource="#arguments.ds#">
					UPDATE FORUMS_RELATIONS
					SET PARENTID=<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
					WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
				</cfquery>
			<cfelse>
				<cfquery name="edit" datasource="#arguments.ds#">
					INSERT INTO FORUMS_RELATIONS
					(
						FORUMID,
						PARENTID
					)
					VALUES
					(
						<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif oldparentid NEQ parentid>
			<cfif oldparentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#oldparentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#oldparentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#oldparentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				<cfelse>
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=0,
							NOOFPOSTS=0,
							LASTPOSTID=NULL,
							LASTPOSTERID=NULL,
							LASTPOSTERNAME=NULL,
							LASTPOSTDATE=NULL
						WHERE FORUMID=<cfqueryparam value="#oldparentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
			
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="deleteforum" access="public" returntype="string" output="false" hint="I edit forum">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="forumlist" type="string" required="true" hint="List of forums to delete">
		<cfset var delete=0>
		<cfloop list="#arguments.forumlist#" index="forumid">
			<cfquery name="delete" datasource="#arguments.ds#">
				UPDATE FORUMS SET
				STATUS=0 
				WHERE FORUMID=<cfqueryparam value="#forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#) AND STATUS=1),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#) AND STATUS=1),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				<cfelse>
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=0,
							NOOFPOSTS=0,
							LASTPOSTID=NULL,
							LASTPOSTERID=NULL,
							LASTPOSTERNAME=NULL,
							LASTPOSTDATE=NULL
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn>
	</cffunction>
	
	<cffunction name="Undeleteforum" access="public" returntype="string" output="false" hint="I edit forum">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="forumlist" type="string" required="true" hint="List of forums to delete">
		<cfset var undelete=0>
		<cfloop list="#arguments.forumlist#" index="forumid">
			<cfquery name="undelete" datasource="#arguments.ds#">
				UPDATE FORUMS 
				SET STATUS=1 
				WHERE FORUMID=<cfqueryparam value="#forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfquery name="undelete" datasource="#arguments.ds#">
					UPDATE FORUMS
					SET STATUS=1
					WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#) AND STATUS=1),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#) AND STATUS=1),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getAllforums" access="public" returntype="query" output="false" hint="I get all forums;FORUMID,NAME,DESCRIPTION,PARENTID,NOOFPOSTS,NOOFTOPICS">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				FORUMS.FORUMID,
				FORUMS.NAME,
				FORUMS.DESCRIPTION,
				FORUMS.NOOFTOPICS,
				FORUMS.NOOFPOSTS,
				FORUMS_RELATIONS.PARENTID
			FROM FORUMS 
			LEFT OUTER JOIN FORUMS_RELATIONS
			ON FORUMS.FORUMID=FORUMS_RELATIONS.FORUMID
			WHERE FORUMS.STATUS=1
			ORDER BY FORUMS.NAME
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getForums" access="public" returntype="query" output="false" hint="I return forum;FORUMID,PARENTID,NAME,DESCRIPTION,CREATEDON,STATUS,LASTUPDATED,NOOFTOPICS,NOOFPOSTS,LASTPOSTID,LASTPOSTERID,LASTPOSTERNAME,LASTPOSTDATE,NOOFSUBFORUMS,ROW">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="forumid" required="false" type="string" default="0" hint="Id of the forum if you want to get information about an specific forum">
		<cfargument name="orderby" required="false" type="string" default="NAME" hint="Order by for forum">
		<cfargument name="ascdesc" required="false" type="string" default="ASC" hint="ASC or DESC">
		<cfargument name="lowerlimit" required="false" type="string" default="0" hint="lower limit of topics">
		<cfargument name="status" required="false" type="string" default="1" hint="status of the forum">
		<cfargument name="choice" required="false" type="string" default="0" hint="1: no parent, 2: only parents, 3: only childs, 4:all top levels, 0:All">
		<cfargument name="excludelist" required="false" type="string" default="0" hint="list of forums to exclude">
		<cfset var get=0>
		<cfset upperlimit=arguments.lowerlimit + 50>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM
			(
			SELECT 
				FORUMID,
				NAME,
				DESCRIPTION,
				CREATEDON,
				STATUS,
				LASTUPDATED,
				NOOFTOPICS,
				NOOFPOSTS,
				LASTPOSTID,
				LASTPOSTERID,
				LASTPOSTERNAME,
				LASTPOSTDATE,
				(SELECT PARENTID FROM FORUMS_RELATIONS WHERE FORUMID=FORUMS.FORUMID) AS PARENTID,
				(SELECT COUNT(*) FROM FORUMS_RELATIONS, FORUMS F WHERE PARENTID=FORUMS.FORUMID AND F.FORUMID=FORUMS_RELATIONS.FORUMID AND F.STATUS=1) AS NOOFSUBFORUMS,
				ROW_NUMBER() OVER (ORDER BY #orderby# #ascdesc#) AS ROW
			FROM FORUMS
			WHERE STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			<cfif arguments.forumid NEQ "0">
			AND FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.choice EQ 1>
			AND FORUMID NOT IN (SELECT PARENTID FROM FORUMS_RELATIONS)
			<cfelseif arguments.choice EQ 2>
			AND FORUMID IN (SELECT PARENTID FROM FORUMS_RELATIONS)
			<cfelseif arguments.choice EQ 3>
			AND FORUMID IN (SELECT FORUMID FROM FORUMS_RELATIONS)
			<cfelseif arguments.choice EQ 4>
			AND FORUMID NOT IN (SELECT FORUMID FROM FORUMS_RELATIONS)
			</cfif>
			<cfif arguments.excludeList NEQ 0>
			AND FORUMID NOT IN (#excludelist#)
			</cfif>
			) ALLFORUMS WHERE ROW > <cfqueryparam value="#arguments.lowerlimit#"> AND ROW <= <cfqueryparam value="#upperlimit#">
		</cfquery>
		<cfreturn get>
	</cffunction>
				
	<cffunction name="addtopic" access="public" returntype="string" output="false" hint="I add topic">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="forumid" type="string" required="true" hint="I am the forumid">
		<cfargument name="topictitle" type="string" required="true" hint="I am title of the topic">
		<cfargument name="topicposter" type="string" required="true" hint="Id of the the person who posted the topic">
		<cfset var add=0>
		<cfset var get=0>
		<cfset var editforum=0>
		<cfset controlcode=0>
		<cfset topicapproved=1>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				NAMEID 
			FROM PEOPLE2USERGROUPS 
			WHERE NAMEID=<cfqueryparam value="#arguments.topicposter#" cfsqltype="cf_sql_varchar">
			AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='Banned From Forum')
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset controlcode=2>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					NAMEID
				FROM PEOPLE2USERGROUPS
				WHERE NAMEID=<cfqueryparam value="#arguments.topicposter#" cfsqltype="cf_sql_varchar">
				AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='In Probation')
			</cfquery>
			<cfif get.recordcount GT 0><cfset controlcode=1><cfset topicapproved=0></cfif>
		</cfif>
		
		<cfif controlcode EQ 2><cfreturn 0></cfif> <!--- This means the user is banned --->
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT USERNAME FROM NAME WHERE NAMEID=<cfqueryparam value="#arguments.topicposter#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO TOPICS
			(
				FORUMID,
				TOPICTITLE,
				TOPICPOSTER,
				TOPICPOSTERNAME,
				TOPICAPPROVED,
				CREATEDON,
				LASTUPDATED
			)
			VALUES
			(
				<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.topictitle#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.topicposter#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#get.username#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#topicapproved#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS TOPICID
		</cfquery>
		
		<cfif controlcode EQ 0>
			<cfquery name="editforum" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID = <cfqueryparam value="#arguments.forumid#"> AND TOPICDELETED=0) 
				WHERE FORUMID=<cfqueryparam value="#arguments.forumid#">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#arguments.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn add.TOPICID>
	</cffunction>

	<cffunction name="getTopics" access="public" returntype="query" output="false" hint="I return forum topics;TOPICID,FORUMID,FORUMNAMETOPICAPPROVED;TOPICREPORTED">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="forumid" required="false" type="string" default="0" hint="Id of the forum">
		<cfargument name="topicid" required="false" type="string" default="0" hint="Id of the topic if you want to get information about an specific topic">
		<cfargument name="approved" required="false" type="string" default="1" hint="I get all topics. 1: all approved 0: all unapproved, -1:All">
		<cfargument name="orderby" required="false" type="string" default="TOPICS.LASTPOSTDATE" hint="Order by for forum">
		<cfargument name="ascdesc" required="false" type="string" default="DESC" hint="ASC or DESC">
		<cfargument name="lowerlimit" required="false" type="string" default="0" hint="lower limit of topics">
		<cfargument name="recordlimit" required="false" type="string" default="0" hint="the max number of records you want to retrieve, I default to 0, but if I am zero, I will get all records">
		<cfargument name="deleted" required="false" type="string" default="0" hint="0 existing topic, 1 deleted topic, -1 all topics">
		<cfargument name="topicsperpage" required="false" type="string" default="10" hint="no of topics to get per page">
		<cfset var get=0>
		<cfset upperlimit=arguments.lowerlimit + arguments.topicsperpage>
		<cfif arguments.approved NEQ 0><cfset arguments.approved=1></cfif>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM (	
			SELECT
			<cfif recordlimit NEQ 0>top #recordlimit#</cfif>
				TOPICS.TOPICID,
				TOPICS.FORUMID,
				FORUMS.NAME AS FORUMNAME,
				TOPICS.TOPICAPPROVED,
				TOPICS.TOPICREPORTED,
				TOPICS.TOPICDELETED,
				TOPICS.TOPICTITLE,
				TOPICS.TOPICPOSTER,
				(SELECT USERNAME FROM NAME WHERE NAMEID=TOPICS.TOPICPOSTER) AS TOPICPOSTERNAME,
				TOPICS.CREATEDON,
				TOPICS.NOOFVIEWS,
				TOPICS.NOOFREPLIES,
				TOPICS.LASTPOSTID,
				TOPICS.LASTPOSTERID,
				TOPICS.LASTPOSTERNAME,
				TOPICS.LASTPOSTDATE,
				TOPICS.LASTUPDATED,
				ROW_NUMBER() OVER (ORDER BY #arguments.orderby# #arguments.ascdesc#) AS ROW
			FROM TOPICS, FORUMS
			WHERE FORUMS.FORUMID=TOPICS.FORUMID
			<cfif arguments.approved NEQ "-1">
			AND TOPICS.TOPICAPPROVED=<cfqueryparam value="#arguments.approved#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.deleted NEQ "-1">
			AND TOPICS.TOPICDELETED=<cfqueryparam value="#arguments.deleted#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.forumid NEQ "0">
			AND TOPICS.FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.topicid NEQ "0">
			AND TOPICS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfif>
			) FORUMTOPICS WHERE ROW > <cfqueryparam value="#arguments.lowerlimit#"> AND ROW <= <cfqueryparam value="#upperlimit#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="addtopicview" access="public" returntype="string" output="false" hint="I add no of views">
		<cfargument name="ds" required="true" type="string" hint="I add the topic view">
		<cfargument name="topicid" required="true" type="string" hint="I am the topic id whose view is to be increased">
		<cfset var addview=0>
		<cfquery name="addview" datasource="#arguments.ds#">
			UPDATE TOPICS
			SET NOOFVIEWS=((SELECT NOOFVIEWS FROM TOPICS WHERE TOPICID = <cfqueryparam value="#arguments.topicid#">) + 1)
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#">
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="addpost" access="public" returntype="string" output="false" hint="I add post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="forumid" type="string" required="true" hint="I am the ID of the forum">
		<cfargument name="topicid" type="string" required="true"  hint="I am the id of the topic">
		<cfargument name="posterid" type="string" required="true" hint="ID of the person who is posting the post">
		<cfargument name="posterip" type="string" required="true" hint="IP address of the device which is used">
		<cfargument name="subject" type="string" required="true" hint="subject of the post">
		<cfargument name="posttext" type="string" required="true" hint="Topic which is being posted">
		<cfargument name="subscribe" type="string" required="false" default="0" hint="0:Do not subscribe, 1: Subscribe">
		<cfset var subscribetotopic=0>
		<cfset var getname=0>
		<cfset var add=0>
		<cfset var get=0>
		<cfset var edittopic=0>
		<cfset var editforum=0>
		<cfset var updatepost=0>
		<cfset var timenow=mytime.createtimedate()>
		<cfset var approved=1>
		
		<cfset arguments.posttext=REReplace(arguments.posttext,"""","&quot;","All")>
		
		<cfset arguments.posttext=stringTosmilies(arguments.posttext,arguments.ds)>
		<cfquery name="getname" datasource="#arguments.ds#">
			SELECT 
				FIRSTNAME,
				LASTNAME,
				USERNAME
			FROM NAME 
			WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset controlcode=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				NAMEID 
			FROM PEOPLE2USERGROUPS 
			WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
			AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='Banned From Forum')
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset controlcode=2>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					NAMEID
				FROM PEOPLE2USERGROUPS
				WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
				AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='In Probation')
			</cfquery>
			<cfif get.recordcount GT 0><cfset controlcode=1><cfset approved=0></cfif>
		</cfif>
		
		<cfif controlcode EQ 2><cfreturn 0></cfif> <!--- This means the user is banned --->
		
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO POSTS
			(
				FORUMID,
				TOPICID,
				POSTERID,
				POSTAPPROVED,
				POSTERIP,
				POSTTIME,
				POSTSUBJECT,
				POSTTEXT
				
			)
			VALUES
			(
				<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#approved#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posterip#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posttext#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS POSTID
		</cfquery>
		
		<cfif controlcode EQ 0>
			<cfquery name="edittopic" Datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					LASTPOSTID=<cfqueryparam value="#add.postid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#getname.username#">,
					LASTPOSTDATE=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">
				WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="editforum" datasource="#arguments.ds#">
				UPDATE FORUMS SET
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#arguments.forumid#"> AND POSTDELETED=0),
					LASTPOSTID=<cfqueryparam value="#add.postid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTSUBJECT=<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#getname.username#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#arguments.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#add.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#arguments.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#getname.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		
		<cfset toname="#getname.firstname# #getname.lastname#">
		
		<cfif Trim(toname) NEQ "">
			<cfset toname=getname.username>
		</cfif>
		
		<cfif controlcode EQ 1>
			<!--- Write code to notify admin --->
			<cfset mailtext="#toname# has posted a new post in the forum. He/she is in probation and the post needs approval.">
			<cfmail to="#application.emailadmin#" from="support@quantumdelta.com" type="text" subject="User in probation made post">
				#mailtext#
			</cfmail>
		</cfif>
		
		<cfif arguments.subscribe EQ 1>
			<cfset args=Structnew()>
			<cfset args.ds=arguments.ds>
			<cfset args.nameid=arguments.posterid>
			<cfset args.topicid=arguments.topicid>
			<cfinvoke method="subscribeTopic" argumentcollection="#args#">
		</cfif>
		<cfreturn add.POSTID>
	</cffunction>
	
	<cffunction name="editpost" access="public" returntype="void" output="false" hint="I add post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postid" type="string" required="true" hint="ID of the post to edit">
		<cfargument name="subject" type="string" required="true" hint="subject of the post">
		<cfargument name="posttext" type="string" required="true" hint="Topic which is being posted">
		<cfargument name="editorid" type="string" required="false" default="0" hint="Id of the user editing the post">
		<cfargument name="subscribe" type="string" required="false" default="0" hint="1 if you want to subscribe to this replies for this topic">
		<cfset var edit=0>
		<cfset var get=0>
		<cfset arguments.posttext=REReplace(arguments.posttext,"""","&quot;","All")>
		<cfset arguments.posttext=stringTosmilies(arguments.posttext,arguments.ds)>
		
		<cfquery name="edit" datasource="#arguments.ds#">
			UPDATE POSTS SET
				POSTSUBJECT=<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
				POSTTEXT=<cfqueryparam value="#arguments.posttext#" cfsqltype="cf_sql_varchar">
			WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.editorid NEQ 0>
			AND POSTERID=<cfqueryparam value="#arguments.editorid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS POSTCOUNT 
			FROM TOPICS 
			WHERE TOPICID=(SELECT TOPICID FROM POSTS WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		
		<cfif get.postcount EQ 1>
			<cfquery name="edit" datasource="#arguments.ds#">
				UPDATE TOPICS SET TOPICTITLE=<cfqueryparam value="#subject#" cfsqltype="cf_sql_varchar">
				WHERE TOPICID=(SELECT TOPICID FROM POSTS WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">)
			</cfquery>
		</cfif>
		
		<cfif arguments.subscribe EQ 1 AND arguments.editorid NEQ 0>
			<cfinvoke method="getposts" ds="#arguments.ds#" postid="#arguments.postid#" returnvariable="thispost">
			<cfif thispost.posterid EQ arguments.editorid>
				<cfset args=StructNew()>
				<cfset args.ds=arguments.ds>
				<cfset args.nameid=arguments.editorid>
				<cfset args.topicid=thispost.topicid>
				<cfinvoke method="subscribeTopic" argumentcollection="#args#">
			</cfif>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="replypost" access="public" returntype="string" output="true" hint="I add post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="posterid" type="string" required="true" hint="ID of the person who is posting the post">
		<cfargument name="topicid" type="string" required="true" hint="ID of the topic">
		<cfargument name="posterip" type="string" required="true" hint="IP address of the device which is used">
		<cfargument name="subject" type="string" required="true" hint="Subject of the post">
		<cfargument name="posttext" type="string" required="true" hint="Topic which is being posted">
		<cfargument name="replyid" type="string" required="false" default="0" hint="Id of the post replying to if it is a reply">
		<cfargument name="subscribe" type="string" required="false" default="0" hint="0:Do not subscribe, 1: Subscribe">
		<cfset var subscribetotopic=0>
		<cfset var getname=0>
		<cfset var add=0>
		<cfset var get=0>
		<cfset var getpost=0>
		<cfset var edittopic=0>
		<cfset var editforum=0>
		<cfset var timenow=mytime.createtimedate()>
		<cfset arguments.posttext=stringTosmilies(arguments.posttext,arguments.ds)>
		<cfinvoke component="Security" method="getRandomUsername" returnvariable="randomName">
		
		<cfset arguments.posttext=REReplace(arguments.posttext,"\/quote\]","/quote:#randomName#]","All")>	
		<cfset arguments.posttext=REReplace(arguments.posttext,"&quot;\]","&quot;:#randomName#]","All")>	
		<cfquery name="getname" datasource="#arguments.ds#">
			SELECT 
				FIRSTNAME, 
				LASTNAME,
				USERNAME 
			FROM NAME 
			WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset controlcode=0>
		<cfset approved=1>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				NAMEID 
			FROM PEOPLE2USERGROUPS 
			WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
			AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='Banned From Forum')
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset controlcode=2>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					NAMEID
				FROM PEOPLE2USERGROUPS
				WHERE NAMEID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
				AND USERGROUPID IN (SELECT USERGROUPID FROM USERGROUPS WHERE USERGROUPNAME='In Probation')
			</cfquery>
			<cfif get.recordcount GT 0><cfset controlcode=1><cfset approved=0></cfif>
		</cfif>
		
		<cfif controlcode EQ 2><cfreturn 0></cfif> <!--- This means the user is banned --->
		
		<cfif replyid NEQ 0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				TOPICID, 
				FORUMID 
			FROM POSTS 
			WHERE POSTID=<cfqueryparam value="#arguments.replyid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					TOPICID, 
					FORUMID 
				FROM TOPICS
				WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO POSTS
			(
				FORUMID,
				TOPICID,
				POSTERID,
				POSTAPPROVED,
				POSTERIP,
				POSTTIME,
				POSTSUBJECT,
				POSTTEXT
			)
			VALUES
			(
				<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#get.topicid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#approved#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posterip#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.posttext#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS POSTID
		</cfquery>
		
		<cfif controlcode EQ 0>
			<cfquery name="edittopic" Datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					LASTPOSTID=<cfqueryparam value="#add.postid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#getname.username#">,
					LASTPOSTDATE=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
					LASTUPDATED=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">,
					NOOFREPLIES=((SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE TOPICID = <cfqueryparam value="#get.topicid#"> AND POSTDELETED=0) -1)
				WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="editforum" datasource="#arguments.ds#">
				UPDATE FORUMS SET
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND POSTDELETED=0),
					LASTPOSTID=<cfqueryparam value="#add.postid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#getname.username#">,
					LASTPOSTDATE=<cfqueryparam value="#timenow#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#"  status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif controlcode EQ 1>
			<!--- Write code to notify admin --->
			<cfset mailtext="#getname.username# has posted a new post in the forum. He/she is in prabation and the post needs approval.">
			<cfmail to="#application.emailadmin#" from="support@quantumdelta.com" type="text" subject="User in probation made post">
				#mailtext#
			</cfmail>
		</cfif>
		
		<cfset args=StructNew()>
		<cfset args.ds=arguments.ds>
		<cfset args.username=getname.username>
		<cfset args.postid=add.postid>
		<cfset args.topicid=arguments.topicid>
		<cfinvoke method="notifySubscribers" argumentcollection="#args#">
		
		<cfif arguments.subscribe EQ 1>
			<cfset args=Structnew()>
			<cfset args.ds=arguments.ds>
			<cfset args.nameid=arguments.posterid>
			<cfset args.topicid=arguments.topicid>
			<cfinvoke method="subscribeTopic" argumentcollection="#args#">
		</cfif>
		<cfreturn add.POSTID>
	</cffunction>
	
	<cffunction name="getPosts" access="public" returntype="query" output="false" hint="I return posts based on inputs. Pass approved=0 to get all unapproved post, postid to get a particular post and topicid to get posts on the topic. If you pass topicid and approve=0, you will get all unapproved post on the topic">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="topicid" required="false"  default="0" type="string" hint="Id of the topic">
		<cfargument name="postid" required="false" type="string" default="0" hint="id of the post if you want to get information about an specific post">
		<cfargument name="approved" required="false" type="string" default="1" hint="pass 0 to get unapproved posts">
		<cfargument name="orderby" required="false" type="string" default="POSTID" hint="Order by for forum">
		<cfargument name="ascdesc" required="false" type="string" default="ASC" hint="ASC or DESC">
		<cfargument name="lowerlimit" required="false" type="string" default="0" hint="lower limit of topics">
		<cfargument name="deleted" required="false" type="string" default="0" hint="pass 1 to get deleted post"> 
		<cfargument name="keyword" required="false" type="string" default="0" hint="pass any keyword if you want to search for a post">
		<cfargument name="topicdeleted" required="false" type="string" default="0" hint="1 if the topic is deleted">
		<cfargument name="resultsperpage" required="false" type="string" default="10" hint="results per page"> 
		<cfset var get=0>
		<cfset upperlimit=arguments.lowerlimit + arguments.resultsperpage>
		<cfif arguments.approved NEQ -1>
			<cfif arguments.approved NEQ 0>
				<cfset arguments.approved=1>
			</cfif>
		</cfif>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT * FROM (
				SELECT
					POSTS.POSTID,
					POSTS.TOPICID,
					POSTS.FORUMID,
					POSTS.POSTERID,
					NAME.USERNAME AS POSTERNAME,
					POSTS.POSTERIP,
					POSTS.POSTTIME,
					POSTS.POSTAPPROVED,
					POSTS.POSTREPORTED,
					POSTS.POSTSUBJECT,
					POSTS.POSTTEXT,
					ROW_NUMBER() OVER (ORDER BY #orderby# #ascdesc#) AS ROW
				FROM POSTS, NAME
				WHERE POSTS.POSTERID=NAME.NAMEID
				<cfif arguments.approved NEQ "-1">
				AND POSTS.POSTAPPROVED=<cfqueryparam value="#arguments.approved#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.deleted NEQ "-1">
				AND POSTS.POSTDELETED=<cfqueryparam value="#arguments.deleted#" cfsqltype="cf_sql_varchar">
				</cfif> 
				<cfif arguments.topicid NEQ "0">
				AND POSTS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.topicdeleted NEQ "1">
				AND POSTS.TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)
				</cfif>
				<cfif arguments.postid NEQ "0">
				AND POSTS.POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.keyword NEQ "0">
				AND POSTS.POSTSUBJECT LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">
				AND POSTS.POSTTEXT LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">
				</cfif>
				) ALLPOSTS WHERE ROW > <cfqueryparam value="#arguments.lowerlimit#"> AND ROW <= <cfqueryparam value="#upperlimit#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getLatestPosts" access="public" returntype="query" output="false" hint="I return lastest post">
		<cfargument name="ds" required="true" type="String" hint="I am the datasource for the forum">
		<cfargument name="noofposts" required="false" type="string" default="5" hint="No of latest posts to return">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				TOP #arguments.noofposts#
					POSTS.POSTID,
					POSTS.TOPICID,
					POSTS.FORUMID,
					POSTS.POSTERID,
					POSTS.POSTERIP,
					POSTS.POSTTIME,
					POSTS.POSTSUBJECT,
					POSTS.POSTTEXT
				FROM POSTS
				WHERE POSTAPPROVED=1
				AND POSTDELETED<>1
				ORDER BY POSTID DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="approveposts" access="public" returntype="string" output="false" hint="I approve forum post">
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postList" type="string" required="true" hint="I am the post corresponding to the topic">
		<cfset var approve=0>
		<cfset var get=0>
		<cfset var getcount=0>
		<cfset var getinfo=0>
		<cfset var args=StructNew()>
		<cfset args.ds=arguments.ds>
		<cfloop list="#postList#" index="postid">
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT TOPICID, FORUMID FROM POSTS WHERE POSTID=<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="approve" datasource="#arguments.ds#">
				UPDATE POSTS SET POSTAPPROVED=1 WHERE POSTID =<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="getcount" datasource="#arguments.ds#">
				SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE TOPICID=<cfqueryparam value="#get.topicid#">
			</cfquery>
			<cfif getcount.NOOFPOSTS EQ 1>
				<cfquery name="approve" datasource="#arguments.ds#">
					UPDATE TOPICS SET TOPICAPPROVED=1 WHERE TOPICID=<cfqueryparam value="#get.TOPICID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
			
			<!--- change no of posts, no of topics in new forum --->
			<cfinvoke method="getLastPost" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar"> AND TOPICDELETED=0),
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- find out if the new forum has a parent and update the parent forum if yes --->
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
			<cfquery name="getinfo" datasource="#arguments.ds#">
				SELECT USERNAME FROM NAME 
				WHERE NAMEID=(SELECT POSTERID FROM POSTS WHERE POSTID=<cfqueryparam value="#arguments.postid#">)
			</cfquery>
			<cfset args.topicid=get.topicid>
			<cfset args.username=getinfo.username>
			<cfset args.postid=postid>
			<cfinvoke method="notifySubscribers" argumentcollection="#args#">
		</cfloop>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="deleteposts" access="public" returntype="string" output="false" hint="I delete forum topic.">
		<!--- 
			logic:
				Delete the posts.
				Find its topicid and forumid
				If it is not the first post on the topic decrease the noofreplies by 1.
				If the topic do not have posts anymore, delete the topic, decrease the no of forum topics by 1.
				Decrease the no of forum posts by 1 
		--->
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postList" type="string" required="true" hint="I am the post corresponding to the topic">
		<cfset var delete=0>
		<cfset var get=0>
		<cfset var update=0>
		<cfset var check=0>
		<cfset var countposts=0>
		<cfloop list="#postList#" index="postid">
			<!--- delete the post --->
			<cfquery name="delete" datasource="#arguments.ds#">
				UPDATE POSTS SET POSTDELETED=1 WHERE POSTID =<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<!--- get topic and forumid --->
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT TOPICID, FORUMID FROM POSTS WHERE POSTID=<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- decrease the noofreplies --->
			<cfquery name="countpost" datasource="#arguments.ds#">
				SELECT COUNT(POSTID) AS NOOFPOSTS 
				FROM POSTS 
				WHERE TOPICID=<cfqueryparam value="#get.topicid#" cfsqltype="cf_sql_varchar"> 
				AND POSTDELETED<>1
			</cfquery>
			
			<cfif countpost.NOOFPOSTS GT 0>
				<cfset noofreplies=countpost.NOOFPOSTS-1>
			<cfelse>
				<cfset noofreplies=0>
			</cfif>
			
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.topicid#" returnvariable="lastpostinfo">
			
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					NOOFREPLIES=<cfqueryparam value="#noofreplies#" cfsqltype="cf_sql_varchar">,
					<cfif lastpostinfo.recordcount GT 0>
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					<cfelse>
					LASTPOSTID=NULL,
					LASTPOSTERID=NULL,
					LASTPOSTERNAME=NULL,
					LASTPOSTDATE=NULL
					</cfif>
				WHERE TOPICID=<cfqueryparam value="#get.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- decrease the no of posts and no of topics from forum if necessary and update other records --->
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.forumid#" returnvariable="lastpostinfo">
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND POSTDELETED=0 AND TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)),
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND TOPICDELETED=0)
					<cfif lastpostinfo.recordcount GT 0>
					,LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					<cfelse>
					,LASTPOSTID=NULL,
					LASTPOSTERID=NULL,
					LASTPOSTERNAME=NULL,
					LASTPOSTDATE=NULL
					</cfif>
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="Undeleteposts" access="public" returntype="string" output="false" hint="I delete forum topic.">
		<!--- 
			logic:
				Undelete the posts.
				Find its topicid and forumid
				If it is not the first post on the topic increase the noofreplies by 1.
				Else Restore the topic
				Increase the noofposts in forum by 1
		--->
		<cfargument name="ds" type="string" required="true" hint="I am the data source for the forum">
		<cfargument name="postList" type="string" required="true" hint="I am the post corresponding to the topic">
		<cfset var undelete=0>
		<cfset var get=0>
		<cfset var update=0>
		<cfset var check=0>
		<cfset var countpost=0>
		<cfloop list="#postList#" index="postid">
			<!--- undelete the post --->
			<cfquery name="undelete" datasource="#arguments.ds#">
				UPDATE POSTS SET POSTDELETED=0 WHERE POSTID =<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<!--- get topic and forumid --->
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT TOPICID, FORUMID FROM POSTS WHERE POSTID=<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="countpost" datasource="#arguments.ds#">
				SELECT COUNT(POSTID) AS NOOFPOSTS 
				FROM POSTS 
				WHERE TOPICID=<cfqueryparam value="#get.topicid#" cfsqltype="cf_sql_varchar"> 
				AND POSTDELETED<>1
				AND TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)
			</cfquery>
			
			<cfif countpost.NOOFPOSTS LT 1>
				<cfset noofreplies=0>
			<cfelse>
				<cfset noofreplies=countpost.NOOFPOSTS-1>
			</cfif>
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.TOPICID#" returnvariable="lastpostinfo">
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					NOOFREPLIES=<cfqueryparam value="#noofreplies#" cfsqltype="cf_sql_varchar">,
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE TOPICID=<cfqueryparam value="#get.topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
	
			<!--- decrease the no of posts and no of topics from forum if necessary  --->
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.forumid#" returnvariable="lastpostinfo">
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND POSTDELETED=0 AND TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)),
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND TOPICDELETED=0),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="deletetopics" access="public" returntype="string" output="false" hint="I delete a topic">
		<cfargument name="ds" required="true" type="string" hint="I am the data source">
		<cfargument name="topicList" required="true" type="string" hint="I am the topicid">
		<cfset var delete=0>
		<cfset var get=0>
		<cfset var update=0>
		<cfloop list="#arguments.topicList#" index="topicid">
			<cfquery name="delete" datasource="#arguments.ds#">
				UPDATE TOPICS SET TOPICDELETED=1 WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
			</cfquery> 
					
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID FROM TOPICS WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.forumid#" returnvariable="lastpostinfo">
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND TOPICDELETED=0),
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND POSTDELETED=0 AND TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)),
					<cfif lastpostinfo.recordcount GT 0>
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					<cfelse>
					LASTPOSTID=NULL,
					LASTPOSTERID=NULL,
					LASTPOSTERNAME=NULL,
					LASTPOSTDATE=NULL
					</cfif>
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="undeletetopics" access="public" returntype="string" output="false" hint="I delete a topic">
		<cfargument name="ds" required="true" type="string" hint="I am the data source">
		<cfargument name="topiclist" required="true" type="string" hint="I am the topicid">
		<cfset var undelete=0>
		<cfset var get=0>
		<cfloop list="#arguments.topiclist#" index="topicid">
			<cfquery name="undelete" datasource="#arguments.ds#">
				UPDATE TOPICS SET TOPICDELETED=0 WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
			</cfquery> 
					
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID FROM TOPICS WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="countposts" datasource="#arguments.ds#">
				SELECT COUNT(POSTID) AS NOOFPOSTS FROM POSTS WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfinvoke method="getlastpost" ds="#arguments.ds#" topicid="#get.forumid#" returnvariable="lastpostinfo">
			<cfquery name="update" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND TOPICDELETED=0),
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID = <cfqueryparam value="#get.forumid#"> AND POSTDELETED=0 AND TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)),
					<cfif lastpostinfo.recordcount GT 0>
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					</cfif>
				WHERE FORUMID=<cfqueryparam value="#get.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#get.forumid#" returnvariable="parentid">
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="recordmessage" access="public" returntype="string" output="false" hint="I record message">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="msgsauthor" required="true" type="string" hint="I am the author of the message">
		<cfargument name="msgssubject" required="true" type="string" hint="I am the subject of the message">
		<cfargument name="msgstext" required="true" type="string" hint="I am the message">
		<cfset var record=0>
		<cfquery name="record" datasource="#arguments.ds#">
			INSERT INTO PRIVMSGS
			(
				MSGSTIME,
				MSGSAUTHOR,
				MSGSSUBJECT,
				MSGSTEXT
			)
			VALUES
			(
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgsauthor#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgssubject#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgstext#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS MSGSID
		</cfquery>
		<cfreturn record.MSGSID>
	</cffunction>

	<cffunction name="sendprivatemsgs" access="public" returntype="string" output="false" hint="I send private message">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgsid" required="true" type="string" hint="I am the messageid that is being sent">
		<cfargument name="msgsto" required="true" type="string" hint="I am the nameid of the person to whom privmsg is being sent">
		<cfargument name="msgsfrom" required="true" type="string" hint="I am the nameid fo the person to whom private message is being sent">
		<cfset var send=0>
		<cfquery name="send" datasource="#arguments.ds#">
			INSERT INTO MSGSTO
			(
				MSGSID,
				MSGSFROM,
				MSGSTO,
				MSGSFOLDER
			)
			VALUES
			(
				<cfqueryparam value="#arguments.msgsid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgsfrom#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgsto#" cfsqltype="cf_sql_varchar">,
				-3
			)
		</cfquery>
		<cfquery name="send" datasource="#arguments.ds#">
			INSERT INTO MSGSTO
			(
				MSGSID,
				MSGSFROM,
				MSGSTO,
				MSGSNEW,
				MSGSFOLDER
			)
			VALUES
			(
				<cfqueryparam value="#arguments.msgsid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgsfrom#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.msgsfrom#" cfsqltype="cf_sql_varchar">,
				0,
				-2
			)
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="getprivatemsgs" access="public" returntype="query" output="false" hint="I get a private messages if messageid is passed">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgstoid" required="true" type="string" hint="I am the id of the message">
		<cfargument name="noofmessages" required="false" type="string" default="0" hint="I am the noofmessages that should be showed at a time.">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				MSGSTO.MSGSTOID,
				MSGSTO.MSGSTO,
				MSGSTO.MSGSFROM,
				MSGSTO.MSGSNEW,
				MSGSTO.MSGSFORWARDED,
				PRIVMSGS.MSGSID,
				PRIVMSGS.MSGSSUBJECT,
				PRIVMSGS.MSGSTEXT,
				NAME.USERNAME
			FROM PRIVMSGS,MSGSTO,NAME
			WHERE PRIVMSGS.MSGSID=MSGSTO.MSGSID
			AND MSGSTO.MSGSTOID=<cfqueryparam value="#arguments.msgstoid#" cfsqltype="cf_sql_varchar">
			AND MSGSTO.MSGSFROM=NAME.NAMEID
		</cfquery>
		<cfreturn get>	
	</cffunction>
	
	<cffunction name="recordviewed" access="public" returntype="void" output="false" hint="I update message as viewed">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgstoid" required="true" type="string" hint="I am the id of the message">
		<cfset var record=0>
		<cfquery name="record" datasource="#arguments.ds#">
			UPDATE MSGSTO
			SET MSGSNEW=0
			WHERE MSGSTOID=<cfqueryparam value="#arguments.msgstoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="deletemsgs" access="public" returntype="void" output="false" hint="I delete message">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgstoid" required="true" type="string" hint="I am the id of the message">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.ds#">
			DELETE FROM MSGSTO
			WHERE MSGSTOID=<cfqueryparam value="#arguments.msgstoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getmessagelist" access="public" returntype="query" output="false" hint="I get message inbox">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgsto" required="true" type="string" hint="I am the nameid of the person whom messages are sent">
		<cfargument name="noofmessages" required="false" type="string" default="0" hint="I am the noofmessages that should be showed at a time.">
		<cfargument name="orderby" required="false" type="string" default="MSGSTO.MSGSTOID DESC" hint="Sort order">
		<cfargument name="msgsfolder" required="false" type="string" default="-3" hint="-3 or message received, -2 for message sent">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				MSGSTO.MSGSTOID,
				MSGSTO.MSGSTO,
				MSGSTO.MSGSFROM,
				MSGSTO.MSGSNEW,
				MSGSTO.MSGSFORWARDED,
				PRIVMSGS.MSGSID,
				PRIVMSGS.MSGSSUBJECT,
				NAME.USERNAME
			FROM PRIVMSGS,MSGSTO,NAME
			WHERE PRIVMSGS.MSGSID=MSGSTO.MSGSID
			AND MSGSTO.MSGSTO=<cfqueryparam value="#arguments.msgsto#" cfsqltype="cf_sql_varchar">
			AND MSGSTO.MSGSFROM=NAME.NAMEID
			AND MSGSFOLDER=<cfqueryparam value="#arguments.msgsfolder#" cfsqltype="cf_sql_varchar">
			ORDER BY #arguments.orderby#
		</cfquery>
		<cfreturn get>	
	</cffunction>
	
	<cffunction name="getnoofmessages" access="public" returntype="string" output="false" hint="I get the total number of messages">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="msgsto" required="true" type="string" hint="I am the nameid of the person whom messages are sent">
		<cfargument name="new" required="false" type="string" default="0" hint="1 if you want to get count of new messages">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(MSGSTO) AS TOTALMESSAGES 
			FROM MSGSTO 
			WHERE MSGSTO.MSGSTO=<cfqueryparam value="#arguments.msgsto#" cfsqltype="cf_sql_varchar">
			<cfif arguments.new EQ 1>
			AND MSGSNEW = 1
			</cfif>
		</cfquery>
		<cfreturn get.totalmessages>
	</cffunction>

	<cffunction name="getnoofposts" access="public" returntype="string" output="false" hint="I get the number of posts for a user">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource of the forum">
		<cfargument name="posterid" required="true" type="string" hint="I am the id of the poster">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(POSTID) AS NOOFPOSTS 
			FROM POSTS WHERE POSTERID=<cfqueryparam value="#arguments.posterid#" cfsqltype="cf_sql_varchar">
			AND POSTDELETED <>1
		</cfquery>
		<cfreturn get.noofposts>
	</cffunction>

	<!--- new additions 20090918--->
	<cffunction name="getchildren" access="public" returntype="query" hint="I get all subforums of the forum;FORUMID, NAME, DESCRIPTION">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="forumid" type="string" required="true" hint="I am the forum id whose children you are trying to get">
		<cfargument name="status" type="string" required="false" default="-1" hint="I am the status of the forum">
		<cfset var get=0>
		<cfset var getchildren=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT FORUMID FROM FORUMS_RELATIONS
			WHERE PARENTID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfset forumlist="0">
		<cfelse>
			<cfset forumlist=valueList(get.forumid)>
		</cfif>
		<cfquery name="getchildren" datasource="#arguments.ds#">
			SELECT 
				FORUMID,
				NAME,
				DESCRIPTION,
				CREATEDON,
				STATUS,
				LASTUPDATED,
				NOOFTOPICS,
				NOOFPOSTS,
				LASTPOSTID,
				LASTPOSTERID,
				LASTPOSTERNAME,
				LASTPOSTDATE
			FROM FORUMS
			WHERE FORUMID IN (#forumlist#)
			<cfif arguments.status NEQ -1>
			AND STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn getchildren>
	</cffunction>
	
	<cffunction name="getparent" access="public" returntype="string" hint="I get the Id of the parent forum, i return 0 if there is no parent">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="forumid" type="string" required="true" hint="I am the id of the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT PARENTID 
			FROM FORUMS_RELATIONS
			WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0><cfreturn 0></cfif>
		<cfreturn get.PARENTID>
	</cffunction>
	
	<cffunction name="moveposts" access="public" returntype="string" hint="I move posts from one topic to another">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="postList" required="true" type="string" hint="list of posts id you want to move">
		<cfargument name="newtopicid" required="true" type="string" hint="id of the topic where the posts should be moved to">
		<cfset var get=0>
		<cfset var set=0>
		
		<!--- Make sure the postList is not empty --->
		<cfif ListLen(postList) EQ 0>
			<cfreturn 0>
		</cfif>
		
		<cfloop list="#postList#" index="postid">
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID, TOPICID 
				FROM POSTS 
				WHERE POSTID=<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset oldtopicid=get.TOPICID>
			<cfset oldforumid=get.FORUMID>
			
			<!--- Get forumid of the new topic --->
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMID
				FROM TOPICS
				WHERE TOPICID=<cfqueryparam value="#newtopicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset newforumid=get.FORUMID>
			
			<!--- change the forumid and topicid of the posts --->
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE POSTS SET 
					FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar">,
					TOPICID=<cfqueryparam value="#newtopicid#" cfsqltype="cf_sql_varchar">
				WHERE POSTID =<cfqueryparam value="#postid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- change new topic info --->
			<cfinvoke method="getLastPost" ds="#arguments.ds#" topicid="#newtopicid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					NOOFREPLIES=((SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE TOPICID=<cfqueryparam value="#newtopicid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0)-1),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE TOPICID=<cfqueryparam value="#newtopicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- change topic info --->
			<cfinvoke method="getLastPost" ds="#arguments.ds#" topicid="#oldtopicid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE TOPICS SET 
					NOOFREPLIES=((SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE TOPICID=<cfqueryparam value="#oldtopicid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0)-1),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE TOPICID=<cfqueryparam value="#oldtopicid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			
			<!--- change no of posts, no of topics in old forum --->
			<cfinvoke method="getLastPost" ds="#arguments.ds#" forumid="#oldforumid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar"> AND TOPICDELETED=0),
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- change no of posts, no of topics in new forum --->
			<cfinvoke method="getLastPost" ds="#arguments.ds#" forumid="#newforumid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT COUNT(*) AS NOOFTOPICS FROM TOPICS WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar"> AND TOPICDELETED=0),
					NOOFPOSTS=(SELECT COUNT(*) AS NOOFPOSTS FROM POSTS WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<!--- find out if the new forum has a parent and update the parent forum if yes --->
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#newforumid#" returnvariable="parentid">
			
			<cfif parentid NEQ 0>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>
			
			<!--- if new forum and old forum are not same OR new forum and old forum are not siblings and old forum has a perent, update the parent --->
			<cfif (NOT isDefined('allchildren')) OR (listfindnocase(allchildren,oldforumid) EQ 0)>
				<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#oldforumid#" returnvariable="oldparentid">
				<cfif (oldparentid NEQ 0) AND (oldforumid NEQ newforumid)>
					<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#oldparentid#" returnvariable="children">
					<cfif children.recordcount GT 0>
						<cfset allchildren=ValueList(children.FORUMID)>
						<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#oldparentid#" returnvariable="lastpostinfo">
						<cfquery name="set" datasource="#arguments.ds#">
							UPDATE FORUMS SET 
								NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
								NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
								LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
								LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
								LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
								LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
							WHERE FORUMID=<cfqueryparam value="#oldparentid#" cfsqltype="cf_sql_varchar">
						</cfquery>	
					</cfif>
				</cfif>		
			</cfif>
		</cfloop>
		<cfreturn 1>
	</cffunction>

	<cffunction name="moveTopics" access="public" returntype="string" hint="I move topics from one forum to another">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="topicList" type="string" required="true" hint="I am the list of topics">
		<cfargument name="forumid" type="string" required="true" hint="I am the forumid where the topics should be moved">
		<cfset var get=0>
		<cfset var set=0>
		
		<cfset newforumid=arguments.forumid>
		
		<cfif listLen(topicList) EQ 0>
			<cfreturn 0>
		<cfelse>
			<cfset topicid=listfirst(topicList)>
		</cfif>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT FORUMID FROM TOPICS 
			WHERE TOPICID=<cfqueryparam value="#topicid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset oldforumid=get.FORUMID>
		
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE TOPICS SET 
				FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar">
			WHERE TOPICID IN (#topicList#)
		</cfquery>
		
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE POSTS SET 
				FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar">
			WHERE TOPICID IN (#topicList#)	
		</cfquery>
		
		<cfinvoke method="getLastPost" ds="#arguments.ds#" forumid="#newforumid#" returnvariable="lastpostinfo">
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE FORUMS SET 
				NOOFTOPICS=(SELECT COUNT(*) FROM TOPICS WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar"> AND TOPICDELETED=0),
				NOOFPOSTS=(SELECT COUNT(*) FROM POSTS WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0),
				LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
				LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
				LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
				LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
			WHERE FORUMID=<cfqueryparam value="#newforumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfinvoke method="getLastPost" ds="#arguments.ds#" forumid="#oldforumid#" returnvariable="lastpostinfo">
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE FORUMS SET 
				NOOFTOPICS=(SELECT COUNT(*) FROM TOPICS WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar"> AND TOPICDELETED=0),
				NOOFPOSTS=(SELECT COUNT(*) FROM POSTS WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar"> AND POSTDELETED=0),
				LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" Cfsqltype="cf_sql_varchar">,
				LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" Cfsqltype="cf_sql_varchar">,
				LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
				LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
			WHERE FORUMID=<cfqueryparam value="#oldforumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#newforumid#" returnvariable="parentid">
		
		<cfif parentid NEQ 0>
			<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
			<cfif children.recordcount GT 0>
				<cfset allchildren=ValueList(children.FORUMID)>
				<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
				<cfquery name="set" datasource="#arguments.ds#">
					UPDATE FORUMS SET 
						NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
						NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
						LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
						LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
						LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
						LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- If new forum and old forum are not same OR new forum and old forum are not siblings and old forum has a perent, update the parent --->
		<cfif (NOT isDefined('allchildren')) OR (listfindnocase(allchildren,oldforumid) EQ 0)>
			<cfinvoke method="getparent" ds="#arguments.ds#" forumid="#oldforumid#" returnvariable="oldparentid">
			<cfif (oldparentid NEQ 0) AND (oldforumid NEQ newforumid)>
				<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#oldparentid#" status=1 returnvariable="children">
				<cfif children.recordcount GT 0>
					<cfset allchildren=ValueList(children.FORUMID)>
					<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#oldparentid#" returnvariable="lastpostinfo">
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
							LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
							LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
							LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
						WHERE FORUMID=<cfqueryparam value="#oldparentid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				<cfelse>
					<cfquery name="set" datasource="#arguments.ds#">
						UPDATE FORUMS SET 
							NOOFTOPICS=0,
							NOOFPOSTS=0,
							LASTPOSTID=NULL,
							LASTPOSTERID=NULL,
							LASTPOSTERNAME=NULL,
							LASTPOSTDATE=NULL
						WHERE FORUMID=<cfqueryparam value="#oldparentid#" cfsqltype="cf_sql_varchar">
					</cfquery>	
				</cfif>
			</cfif>		
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<!--- 
	Moving a forum
		1. Check if it has children and return if it does.
		2. Check if it has parent, get parentid if it does and remove it as a child of that forum.
		3. Add a record in FORUMS_RELATIONS table to make it a child of new forum.forum
		4. Update the records of old parent forum.
		5. Update the records of new parent forum. 
	 --->	 
	<cffunction name="moveForums" access="public" returntype="string" hint="I move forum">
		<cfargument name="ds" required="true" type="string" hint="Data source">
		<cfargument name="forumList" required="true" type="string" hint="Id of the forum">
		<cfargument name="newparentid" required="true" type="string" hint="Id of the parent forum where the forum should be moved">
		<cfset var get=0>
		<cfset var set=0>
		<cfif listlen(arguments.forumList) EQ 0>
			<cfreturn 0>
		</cfif>
		
		<cfinvoke method="getChildren" ds="#arguments.ds#" forumid="#listfirst(forumList)#" returnvariable="children">
		<cfif children.recordcount NEQ 0>
			<cfreturn 0>
		</cfif>
		
		<cfinvoke method="getParent" ds="#arguments.ds#" forumid="#listfirst(forumList)#" returnvariable="parentid">
		
		<cfif parentid NEQ 0>
			<cfquery name="set" datasource="#arguments.ds#">
				DELETE FROM FORUMS_RELATIONS
				WHERE FORUMID IN (#arguments.forumList#)
			</cfquery>
			<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#parentid#" status=1 returnvariable="children">
			
			<cfif children.recordcount GT 0>
				<cfset allchildren=ValueList(children.FORUMID)>
				<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#parentid#" returnvariable="lastpostinfo">
				<cfquery name="set" datasource="#arguments.ds#">
					UPDATE FORUMS SET 
						NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
						NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
						LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
						LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
						LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
						LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
					WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
				</cfquery>
			<cfelse>
				<cfquery name="set" datasource="#arguments.ds#">
					UPDATE FORUMS SET 
						NOOFTOPICS=0,
						NOOFPOSTS=0,
						LASTPOSTID=NULL,
						LASTPOSTERID=NULL,
						LASTPOSTERNAME=NULL,
						LASTPOSTDATE=NULL
					WHERE FORUMID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">
				</cfquery>				
			</cfif>
		</cfif>
		
		<cfloop list="#arguments.forumlist#" index="forumid">
			<cfinvoke method="addchild" ds="#arguments.ds#" forumid="#forumid#" parentid="#arguments.newparentid#">
		</cfloop>
		
		<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#arguments.newparentid#" status=1 returnvariable="children">
		<cfif children.recordcount GT 0>
			<cfset allchildren=ValueList(children.FORUMID)>
			<cfinvoke method="getlastpost" ds="#arguments.ds#" forumid="#arguments.newparentid#" returnvariable="lastpostinfo">
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=(SELECT SUM(NOOFTOPICS) AS SUMTOPICS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
					NOOFPOSTS=(SELECT SUM(NOOFPOSTS) AS SUMPOSTS FROM FORUMS WHERE FORUMID IN (#allchildren#)),
					LASTPOSTID=<cfqueryparam value="#lastpostinfo.POSTID#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERID=<cfqueryparam value="#lastpostinfo.POSTERID#" cfsqltype="cf_sql_varchar">,
					LASTPOSTERNAME=<cfqueryparam value="#lastpostinfo.USERNAME#" cfsqltype="cf_sql_varchar">,
					LASTPOSTDATE=<cfqueryparam value="#lastpostinfo.POSTTIME#" cfsqltype="cf_sql_varchar">
				WHERE FORUMID=<cfqueryparam value="#arguments.newparentid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse>
			<cfquery name="set" datasource="#arguments.ds#">
				UPDATE FORUMS SET 
					NOOFTOPICS=0,
					NOOFPOSTS=0,
					LASTPOSTID=NULL,
					LASTPOSTERID=NULL,
					LASTPOSTERNAME=NULL,
					LASTPOSTDATE=NULL
				WHERE FORUMID=<cfqueryparam value="#arguments.newparentid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="addchild" access="public" returntype="void" hint="I add child or subforum to a forum">
		<cfargument name="ds" required="true" type="string" hint="I am the data source">
		<cfargument name="forumid" required="true" type="string" hint="I am the child forum id">
		<cfargument name="parentid" required="true" type="string" hint="I am the parentid forum id">
		<cfset var add =0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO FORUMS_RELATIONS
			(
				FORUMID,
				PARENTID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getLastPost" access="public" returntype="query" hint="I return last post;POSTID,POSTERID,USERNAME">
		<cfargument name="ds" required="true" type="string" hint="I am the data source">
		<cfargument name="forumid" required="false" type="string" default="0" hint="Id of the forum">
		<cfargument name="topicid" required="false" type="string" default="0" hint="Id of the Topic">
		<cfset var get=0>
		<cfif arguments.forumid NEQ 0>
			<cfinvoke method="getchildren" ds="#arguments.ds#" forumid="#arguments.forumid#" status=1 returnvariable="children">
			<cfif children.recordcount NEQ 0>
				<cfset forumlist=ValueList(children.forumid)>
			<cfelse>
				<cfset forumlist=arguments.forumid>
			</cfif>
		<cfelse>
			<cfset forumlist=arguments.forumid>
		</cfif>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT TOP 1 
				POSTS.POSTID,
				POSTS.POSTERID,
				POSTS.POSTTIME,
				NAME.USERNAME
			FROM POSTS, NAME
			WHERE POSTS.POSTERID=NAME.NAMEID
			AND POSTS.POSTDELETED=0
			AND POSTS.TOPICID NOT IN (SELECT TOPICID FROM TOPICS WHERE TOPICDELETED=1)
			<cfif arguments.forumid NEQ 0>
			AND POSTS.FORUMID IN (#forumlist#)
			</cfif>
			<cfif arguments.topicid NEQ 0>
			AND POSTS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY POSTS.POSTID DESC
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="geteligibleParents" access="public" returntype="query" hint="I return forums with no parent;FORUMID, NAME">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfargument name="excludeList" type="string" required="false" default="0" hint="I am the list that should be excluded">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				FORUMID,
				NAME,
				DESCRIPTION
			FROM FORUMS
			WHERE FORUMID NOT IN (SELECT DISTINCT FORUMID FROM FORUMS_RELATIONS)
			AND STATUS=1
			<cfif Trim(arguments.excludeList) NEQ "" And arguments.excludelist NEQ 0>
			AND FORUMID NOT IN (#arguments.excludeList#) 
			</cfif>
			AND FORUMID NOT IN (SELECT DISTINCT FORUMID FROM POSTS)
			AND FORUMID NOT IN (SELECT DISTINCT FORUMID FROM TOPICS)
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="editTopic" access="public" returntype="void" hint="I edit topic">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="topicid" type="string" required="true" hint="I am the id of the topic">
		<cfargument name="topictitle" type="string" required="true" hint="i am the title of the topic">
		<cfset var set=0>
		<cfquery name="set" datasource="#arguments.ds#">
			UPDATE TOPICS SET TOPICTITLE=<cfqueryparam value="#arguments.topictitle#" cfsqltype="cf_sql_varchar">
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="isDeleted" access="public" returntype="string" hint="Not Deleted:0, Forum deleted:1, Topic deleted:2, Post deleted:3, Parent forum deleted:4, does not exist:-1 ">
		<cfargument name="ds" required="true" type="string" hint="datasource">
		<cfargument name="forumid" required="false" default="0" type="string" hint="id of the forum">
		<cfargument name="topicid" required="false" default="0" type="string" hint="id of the topic">
		<cfargument name="postid" required="false" default="0" type="string" hint="id of the post">
		<cfset var get=0>
		<cfif (arguments.forumid EQ 0) AND (arguments.topicid EQ 0) AND (arguments.postid EQ 0)>
			<cfreturn -1>
		</cfif>
		<cfif arguments.postid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT 
					FORUMS.FORUMID,
					FORUMS.STATUS,
					TOPICS.TOPICDELETED,
					POSTS.POSTDELETED
				FROM FORUMS,TOPICS,POSTS 
				WHERE POSTS.POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar"> 
				AND POSTS.FORUMID=FORUMS.FORUMID
				AND POSTS.TOPICID=TOPICS.TOPICID
			</cfquery>
			<cfif get.recordcount EQ 0>
				<cfreturn -1>
			<cfelse>
				<cfif get.STATUS EQ 0>
					<cfreturn 1>
				<cfelseif get.TOPICDELETED EQ 1>
					<cfreturn 2>
				<cfelseif get.POSTDELETED EQ 1>
					<cfreturn 3>
				<cfelse>
					<cfset arguments.forumid=get.forumid>
				</cfif>
			</cfif>
		<cfelseif arguments.topicid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT
					FORUMS.FORUMID,
					FORUMS.STATUS,
					TOPICS.TOPICDELETED
				FROM FORUMS,TOPICS
				WHERE TOPICS.TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
				AND TOPICS.FORUMID=FORUMS.FORUMID
			</cfquery>
			<cfif get.recordcount EQ 0>
				<cfreturn -1>
			<cfelse>
				<cfif get.STATUS EQ 0>
					<cfreturn 1>
				<cfelseif get.TOPICDELETED EQ 1>
					<cfreturn 2>
				<cfelse>
					<cfset arguments.forumid=get.forumid>
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT FORUMS.STATUS FROM FORUMS
				WHERE FORUMS.FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif get.recordcount EQ 0>
				<cfreturn -1>
			<cfelse>
				<cfif get.STATUS EQ 0>
					<cfreturn 1>
				</cfif>
			</cfif>
		</cfif>
		
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT FORUMS_RELATIONS.PARENTID,FORUMS.STATUS
			FROM FORUMS_RELATIONS,FORUMS
			WHERE FORUMS_RELATIONS.FORUMID=<cfqueryparam value="#arguments.FORUMID#" cfsqltype="cf_sql_varchar">
			AND FORUMS.FORUMID=FORUMS_RELATIONS.PARENTID
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn -1>	
		<cfelse>
			<cfif get.STATUS EQ 0>
				<cfreturn 4>
			<cfelse>
				<cfreturn 0>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getForumStatus" access="public" returntype="string" hint="I check if the forum id is Valid. 1: Valid, -1: Deleted, 0: Does not exist">
		<cfargument name="ds" required="true" type="string" hint="Data source">
		<cfargument name="forumid" required="true" type="string" hint="forumid">
		<cfset var get = 0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				FORUMID, 
				STATUS
			FROM FORUM 
			WHERE FORUMID=<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn "0">
		<cfelseif get.status EQ 0>
			<cfreturn "-1">
		<cfelse>
			<cfreturn "1">
		</cfif>
	</cffunction>
	
	<cffunction name="getTopicStatus" access="public" returntype="string" hint="I check if the topicid id is Valid. 1: Valid, -1: Deleted, 0: Does not exist">
		<cfargument name="ds" required="true" type="string" hint="Data source">
		<cfargument name="topicid" required="true" type="string" hint="forumid">
		<cfset var get = 0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				TOPICID,
				TOPICDELETED 
			FROM TOPICS 
			WHERE TOPICID=<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn "0">
		<cfelseif get.TOPICDELETED EQ 0>
			<cfreturn "-1">
		<cfelse>
			<cfreturn "1">
		</cfif>
	</cffunction>
	
	<cffunction name="getPostStatus" access="public" returntype="string" hint="I check if the post id is Valid. 1: Valid, -1: Deleted, 0: Does not exist">
		<cfargument name="ds" required="true" type="string" hint="Data source">
		<cfargument name="postid" required="true" type="string" hint="forumid">
		<cfset var get = 0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				POSTID,
				POSTDELETED 
			FROM POSTS 
			WHERE POSTID=<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn "0">
		<cfelseif get.POSTDELETED EQ 0>
			<cfreturn "-1">
		<cfelse>
			<cfreturn "1">
		</cfif>
	</cffunction>

	<cffunction name="reportAbuse" access="public" returntype="string" hint="I record reports">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="forumid" required="true" type="string" hint="id of the forum">
		<cfargument name="topicid" required="true" type="string" hint="Id of the topic">
		<cfargument name="postid" required="true" type="string" hint="id of the post">
		<cfargument name="userid" required="true" type="string" hint="id of the user">
		<cfargument name="usernotify" required="false" type="string" default="0" hint="wheather to notify user or not">
		<cfset var report=0>
		<cfset var recordreport=0>
		<cfquery name="report" datasource="#arguments.ds#">
			UPDATE POSTS SET POSTREPORTED=1 WHERE POSTID=<cfqueryparam value="#arguments.postid#">
		</cfquery>
		<cfquery name="recordreport" datasource="#arguments.ds#">
			INSERT INTO POSTREPORT
			(
				USERID,
				USERNOTIFY,
				REPORTTIME,
				POSTID,
				TOPICID,
				FORUMID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.usernotify#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.topicid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.forumid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS REPORTID
		</cfquery>
		<cfreturn recordreport.REPORTID>
	</cffunction>
	
	<cffunction name="getReportedPosts" access="public" returntype="query" hint="I get all the reported posts">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
				POSTID,
				POSTERID,
				POSTSUBJECT,
				NAME.USERNAME AS POSTERNAME,
				(SELECT USERNAME FROM NAME WHERE NAMEID=(SELECT USERID FROM POSTREPORT WHERE POSTID=P.POSTID)) AS REPORTEDBY,
				POSTTIME
			FROM POSTS P,NAME
			WHERE P.POSTREPORTED=1
			AND P.POSTERID=NAME.NAMEID
			AND P.POSTDELETED=0
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="ignoreReport" access="public" returntype="string" hint="I ignore report">
		<cfargument name="ds" required="true" type="string" hint="I am the the datasource for the forum">
		<cfargument name="postList" required="true" default="0" type="string" hint="List of reported posts to ignore">
		<cfset var ignore=0>
		<cfif listlen(postList) GT 0>
			<cfquery name="ignore" datasource="#arguments.ds#">
				UPDATE POSTS SET POSTREPORTED=0 WHERE POSTID IN (#arguments.postList#)
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>