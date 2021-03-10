<cfcomponent hint="Blog Functions">
	<cfobject component="timeDateConversion" name="mytime">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	
	<cffunction name="getCategories" access="public" returntype="query" hint="I get the blog categories for the site passed to me">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="timedate" type="string" required="no" default="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfset var qry_categories=0>
		<cfquery name="qry_categories" datasource="#datasource#">
			SELECT
			BLOGCATEGORY.BLOGCATEGORYID AS id, 
			BLOGCATEGORY.BLOGCATEGORY AS name,
			COUNT(BLOG2BLOGCATEGORY.EVENTID) AS count
			FROM         
				EVENT,
				EVENTVERSION, 	
				BLOG2BLOGCATEGORY,
				BLOGCATEGORY,
				EVENTCATEGORY
			WHERE
				EVENTVERSION.EVENTID = BLOG2BLOGCATEGORY.EVENTID
				AND BLOG2BLOGCATEGORY.BLOGCATEGORYID = BLOGCATEGORY.BLOGCATEGORYID
				AND EVENTCATEGORY.EVENTCATEGORYID = BLOGCATEGORY.PARENTBLOGCATEGORYID
				AND EVENTCATEGORY.EVENTCATEGORY = 'Blog'
				AND EVENTVERSION.STATUS = 'Publish'
				AND EVENTVERSION.STARTTIME < '#TIMEDATE#'
			AND (EVENTVERSION.VERSIONID =
				  (SELECT     MAX(VERSIONID)
					FROM          EVENTVERSION
					WHERE      EVENTID = EVENT.EVENTID
					AND    EVENTVERSION.STATUS = 'Publish')) 
				AND BLOGCATEGORY.VERSIONID = (SELECT MAX(BCS.VERSIONID)
				   FROM BLOGCATEGORY BCS
				   WHERE BCS.BLOGCATEGORYID = BLOGCATEGORY.BLOGCATEGORYID)
			GROUP BY 
			BLOGCATEGORY.BLOGCATEGORY, 
			BLOGCATEGORY.BLOGCATEGORYID
			ORDER BY NAME
			</cfquery>
			<cfreturn qry_categories>
		</cffunction>
		
		<cffunction name="getMonthCounts" access="public" returntype="query" hint="I get the blog entry counts for each month for the date range passed to me.">
			<cfargument name="datasource" type="string" required="yes">
			<cfargument name="startrange" type="string" required="yes" hint="the start range needs to be in yyyymmdd format">
			<cfargument name="endrange" type="string" required="yes" hint="the end range needs to be in yyyymmdd format">
			<cfargument 
				name="timedate" 
				type="string" 
				required="no" 
				default="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
			<cfset var monthcount=0>
			<cfquery name="monthcount" datasource="#datasource#">
			SELECT
				SUBSTRING(EVENTVERSION.STARTTIME, 1,6) POSTMONTH,	
				MAX(EVENTVERSION.STARTTIME) AS POSTDATE,
				COUNT(*) AS monthcount
			FROM         
				EVENT,
				EVENTVERSION,
				EVENTCATEGORY
			WHERE EVENT.EVENTID = EVENTVERSION.EVENTID
			AND EVENTCATEGORY.EVENTCATEGORY = 'Blog'
			AND EVENTVERSION.STARTTIME BETWEEN '#startrange#%' AND '#endrange#%'
			AND EVENTVERSION.STATUS = 'Publish'
			AND EVENTVERSION.STARTTIME < '#TIMEDATE#'
			AND EVENTVERSION.VERSIONID =
			(SELECT     MAX(VERSIONID)
			FROM          EVENTVERSION
			WHERE EVENTID = EVENT.EVENTID
			AND    EVENTVERSION.STATUS = 'Publish')
			GROUP BY 
			SUBSTRING(EVENTVERSION.STARTTIME, 1,6)
			ORDER BY SUBSTRING(EVENTVERSION.STARTTIME, 1,6) DESC
			</cfquery>
			<cfreturn monthcount>
		</cffunction>
		
		<cffunction name="getComments" access="public" returnType="query" hint="I get comments for a particular blog entry: I return a recordset: COMMENTID, COMMENTNAME, CREATEDBYID, PROJECTID, EVENTID, PEOPLEID, CARTID, SITEID, PRODUCTID, IMAGEID, FIRSTNAME, LASTNAME, COMMENT, STATUS">
			<cfargument name="datasource" type="string" required="yes" hint="Datasource">
			<cfargument name="entryID" type="string" required="yes" hint="Blog Entry ID">
			<cfset var getCommentsQuery=0>
			<cfquery name="getCommentsQuery" dataSource="#datasource#">
			SELECT
				COMMENTID, 
				COMMENTNAME,
				COMMENT.CREATEDBYID, 
				PROJECTID, 
				EVENTID, 
				COMMENT.NAMEID AS PEOPLEID,
				CARTID, 
				SITEID, 
				PRODUCTID, 
				IMAGEID,
				FIRSTNAME,
				LASTNAME,
				COMMENT,
				COMMENT.STATUS
			FROM COMMENT, NAME
			WHERE COMMENT.STATUS <> 'DELETED'
				AND NAME.NAMEID = COMMENT.NAMEID
				AND EVENTID = '#arguments.entryID#'
			ORDER BY COMMENTID DESC
			</cfquery>
			<cfreturn getCommentsQuery>
		</cffunction>
		
		<cffunction name="addComment" access="public" returnType="void" hint="I add a comment about a specific blog entry.">
			<cfargument name="datasource" type="string" required="yes" hint="Datasource">
			<cfargument name="entryID" type="string" required="yes" hint="Blog Entry ID">
			<cfargument name="title" type="string" required="yes" hint="Title of the Comment to be Added.">
			<cfargument name="comment" type="string" required="yes" hint="Comment to be Added.">
			<cfargument name="authorid" type="string" required="yes" hint="Author of the Comment.">
			<cfargument name="status" type="string" required="no" hint="Comment Status." default="Pending">
			<cfset var addCommentQuery=0>
			<cfquery name="addCommentQuery" datasource="#datasource#">
			INSERT INTO COMMENT (
				EVENTID,
				COMMENTID,
				COMMENTNAME,
				COMMENT,
				NAMEID,
				STATUS
				) 
			VALUES (
				<cfqueryparam value="#entryID#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#comment#">,
				<cfqueryparam value="#authorid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cffunction>
		
		<cffunction name="getEntries" access="public" returntype="any" hint="I get the blog entries for the site and data passed to me">
			<cfargument name="datasource" type="string" required="yes">
			<cfargument name="categoryid" type="string" required="no" hint="I filter the entries by Category ID">
			<cfargument name="numberofentries" type="numeric" required="no" default="500" hint="I set the number of entries to display">
			<cfargument name="timeframe" type="string" required="no" hint="I set the time frame to display entries from (i.e. for 2007 just put in 2007 for Oct. 2007 type in 200710">
			<cfargument name="returnType" type="string" required="no" hint="Type to return: XML or query" default="query">
			<cfargument name="entryID" type="string" required="no" hint="If set I will just pull the entry with that particular matching ID">
			<cfargument name="search" type="string" required="no" hint="Search Criteria to search the blog">
			<cfargument 
				name="timedate" 
				type="string" 
				required="no" 
				default="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
			<cfset var entries=0>
			<cfset var theblogentries=0>
			<cfset var author=0>
			<cfset var comments=0>
			<cfquery name="entries" datasource="#datasource#" maxrows="#numberofentries#">
			SELECT
				EVENTVERSION.EVENTID as entryid, 
				EVENTVERSION.EVENTNAME as entryname, 
				EVENTVERSION.STARTTIME as posttime,
				EVENTVERSION.SEDESCRIPTION as excerpt, 
				EVENTVERSION.KEYWORDS, 
				EVENTVERSION.TITLE, 
				EVENTVERSION.DESCRIPTION as entry, 
				EVENTVERSION.PAGENAME,
				EVENTVERSION.CREATEDBYID, 
				BLOGCATEGORY.BLOGCATEGORYID as categoryid, 
				BLOGCATEGORY.BLOGCATEGORY as category, 
				BLOG2BLOGCATEGORY.EVENTID AS BEVENTID,
				(SELECT COUNT(COMMENTID)
					FROM COMMENT
					WHERE 1=1 
					<cfif isDefined("arguments.entryID")>
					AND EVENTID = '#arguments.entryID#'
					</cfif>
					AND STATUS <> 'DELETED') AS commentCount
			FROM         
				EVENT,
				EVENTVERSION, 	
				BLOG2BLOGCATEGORY,
				BLOGCATEGORY,
				EVENTCATEGORY
			WHERE
				EVENTVERSION.EVENTID = BLOG2BLOGCATEGORY.EVENTID
				AND BLOG2BLOGCATEGORY.BLOGCATEGORYID = BLOGCATEGORY.BLOGCATEGORYID
				AND EVENTCATEGORY.EVENTCATEGORYID = BLOGCATEGORY.PARENTBLOGCATEGORYID
				AND EVENTCATEGORY.EVENTCATEGORY = 'Blog'
				AND EVENTVERSION.PARENTEVENTID = '0' 
				AND EVENTVERSION.STATUS = 'Publish'
				AND EVENTVERSION.STARTTIME < '#TIMEDATE#'
				<cfif isDefined("categoryid")>
				AND BLOGCATEGORY.BLOGCATEGORYID = <cfqueryparam value="#categoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined("arguments.entryID")>
				AND EVENT.EVENTID = '#arguments.entryID#'
				</cfif>
				<cfif isDefined("timeframe")>
				AND EVENTVERSION.STARTTIME like '#timeframe#%'
				</cfif>
				<cfif isDefined("search")>
				AND EVENTVERSION.DESCRIPTION LIKE '%#SEARCH#%'
				</cfif>
				AND (EVENTVERSION.VERSIONID =
				  (SELECT     MAX(VERSIONID)
					FROM          EVENTVERSION
					WHERE      EVENTID = EVENT.EVENTID
					AND    EVENTVERSION.STATUS = 'Publish')) 
				AND BLOGCATEGORY.VERSIONID = (SELECT MAX(BCS.VERSIONID)
				   FROM BLOGCATEGORY BCS
				   WHERE BCS.BLOGCATEGORYID = BLOGCATEGORY.BLOGCATEGORYID)
			ORDER BY EVENTVERSION.STARTTIME DESC
			</cfquery>
			<cfif returnType EQ "XML">
			<cfsavecontent variable="theblogentries">
			<entries count="<cfoutput>#entries.recordcount#</cfoutput>">
			<cfoutput query="entries">
			<cfset postdate = "#Left(posttime,4)#-#Mid(posttime,5,2)#-#Mid(posttime,7,2)#">
			<!--- GET FIRST/LAST NAME BY PASSING THE NAMEID --->
			<cfquery name="author" datasource="deltasystem">
				SELECT
					FIRSTNAME,
					LASTNAME
				FROM 
					NAME
				WHERE
					NAMEID = <cfqueryparam value="#createdbyid#" cfsqltype="CF_SQL_VARCHAR" maxlength="16">
			</cfquery>
				<cfquery name="comments" datasource="#datasource#">
				SELECT
				COMMENTID, 
				COMMENTNAME,
				CREATEDBYID as commenter, 
				EVENTID
				COMMENT,
				STATUS
				FROM COMMENT
				WHERE STATUS <> 'DELETED'
				AND EVENTID = '#entryid#'
				ORDER BY COMMENTID DESC
				</cfquery>
					<entry id="#entryid#">
						<author firstname="#author.firstname#" lastname="#author.lastname#" />
						<title>#title#</title>
						<link>http://#datasource#/blog/#entryid#/#pagename#.html</link>
						<description>#xmlformat(excerpt)#</description>
						<posttime>#posttime#</posttime>
						<postdate>#postdate#</postdate>
						<fullentry>#xmlformat(entry)#</fullentry>
						<category>#category#</category>
						<categoryid>#categoryid#</categoryid>
						<comments count="#comments.recordcount#">
							<cfloop query="comments">
							<comment id="#commentid#" name="#commentname#" status="#status#" postedby="#commenter#">#comment#</comment>
							</cfloop>
						</comments>
					</entry>
				</cfoutput>
				</entries>
				</cfsavecontent>
				<cfset entries=XMLParse(#theblogentries#)>
			</cfif>
		<cfreturn entries>
		</cffunction>
		<!--- <cffunction name="addBlogEntry" access="public" returntype="void" hint="I add the blog entry">
			<cfargument name="dsn" required="true" type="string" hint="datasource for the entry you are updating">
			<cfargument name="createdbyid" required="true" type="string" hint="the id for the person adding the post (system userid)">
			<cfargument name="entryid" required="false" type="string" default="0" hint="id for the entry you are wanting to update">
			<cfargument name="entryname" required="false" type="string" default="0" hint="the name of the blog entry you are updating">
			<cfargument name="posttime" required ="false" type="string" default="0" hint="the datetime of the post">
			<cfargument name="excerpt" required="false" type="string" default="0" hint="the excerpt for the post">
			<cfargument name="keywords" required="false" type="string" default="0" hint="the keywords for the post">
			<cfargument name="title" required="false" type="string" default="0" hint="the title of the post">
			<cfargument name="entry" required="false" type="string" default="0" hint="The post itself">
			<cfargument name="pagename" required="false" type="string" default="0" hint="the pagename of the post">
			<cfargument name="categoryid" required="false" type="string" default="0" hint="the blog categoryid">
			<cfargument name="category" required="false" type="string" default="0" hint="the name of the blog category">
			<cftransaction >
			<!--- check to see if the blog entry already exists --->
			
			<!---if entry does not exist add event and event version --->
			
			<cfquery name="addBlogEntry" datasource="#dsn#">
			INSERT INTO EVENTVERSION
			(EVENTVERSION.EVENTID,
			EVENTVERSION.EVENTNAME,
			EVENTVERSION.STARTTIME,
			EVENTVERSION.SEDESCRIPTION,
			EVENTVERSION.KEYWORDS,
			EVENTVERSION.TITLE,
			EVENTVERSION.DESCRIPTION,
			EVENTVERSION.PAGENAME,
			EVENTVERSION.CREATEDBYID)
			VALUES
			(<cfqueryparam value="#entryid#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#entryname#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#posttime#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#excerpt#">, 
				<cfqueryparam value="#KEYWORDS#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#TITLE#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#entry#">, 
				<cfqueryparam value="#PAGENAME#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CREATEDBYID#" cfsqltype="cf_sql_varchar">) 
			</cfquery>
			</cftransaction>
			
			<!--- invoke updateBlogEntryCategory to add to or update event category --->
			
		</cffunction> --->
		<!--- working and used now in beta.spiderwebmaster.net --->
		<cffunction name="updateBlogEntryCategory" access="public" returntype="void" hint="I update the blog entry categories">
			<cfargument name="dsn" required="true" type="string" hint="datasource for the entry you are updating">
			<cfargument name="entryid" required="true" type="string" default="0" hint="id for the entry you are wanting to update">
			<cfargument name="categoryid" required="true" type="string" default="0" hint="a list of the blog category ids">
			<cfset var removeblog2cat=0>
			<cfset var relateevent2blogcat=0>
			<cftransaction >
				<cfquery name="removeblog2cat" datasource="#dsn#">
				DELETE FROM BLOG2BLOGCATEGORY
				WHERE EVENTID = <cfqueryparam value="#entryid#">
				</cfquery>
				<cfloop index="curr" list="#categoryid#" delimiters=",">
					<cfquery name="relateevent2blogcat" datasource="#dsn#">
					INSERT INTO BLOG2BLOGCATEGORY
						(BLOGCATEGORYID,
						EVENTID)
					VALUES
						(<cfqueryparam value="#curr#" cfsqltype="CF_SQL_VARCHAR" maxlength="16">,
						<cfqueryparam value="#entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="16">)
					</cfquery>
				</cfloop>
			</cftransaction>
		</cffunction>
		<!--- not tested --->
		<cffunction name="updateBlogCategory" access="public" returntype="void" hint="I update the blog category">
			<cfargument name="dsn" required="true" type="string" hint="datasource for the entry you are updating">
			<cfargument name="blogcategory" required="true" type="string" default="0" hint="the new name of the blog category">
			<cfargument name="blogcategoryid" required="true" type="string" default="0" hint="the id of the blogcategory you are updating">
			<cfargument name="versiondesc" required="false" type="string" default="I was updated on using the blog cfc" hint="I am the description of this version">
			<cfargument name="color" required="false" type="string" default="0" hint="I am the color of this blog category">
			<cfargument name="status" required="false" type="string" default="0" hint="I am the status of the category you are updating">
			<cfargument name="description" required="false" type="string" default="0" hint="I am the new description of the category you are updating">
			<cfargument name="archivexmo" required="false" type="string" default="0" hint="I am the number of monthes you want to archive these type of blog entries on the site">
			<cfset var updateblogcat=0>
			<cfquery name="updateblogcat" datasource="#request.dsn#">
			UPDATE BLOGCATEGORY
			SET BLOGCATEGORY = <cfqueryparam value="#blogcategory#">,
				VERSIONID = <cfqueryparam value="#TIMEDATE#">,
				VERSIONDESCRIPTION = <cfqueryparam value="#versiondesc#">
				<cfif description neq 0>, DESCRIPTION = <cfqueryparam value="#description#"></cfif>
				<cfif status neq 0>, STATUS = <cfqueryparam value="#status#"></cfif>
				<cfif color neq 0>, COLOR = <cfqueryparam value="#color#"></cfif>
				<cfif archivexmo neq 0>, ARCHIVEXMO = <cfqueryparam value="#archivexmo#"></cfif>
			WHERE BLOGCATEGORYID = <cfqueryparam value="#blogcategoryid#">
			</cfquery>
		</cffunction>
	</cfcomponent>