<cfcomponent hint="I manage the comments">
	<cfparam name="variables.ds" default="spiderwebmaster.net">
	<cfobject component="timeDateConversion" name="mytime">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="init" access="public" returntype="void" hint="I run buildTables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke component="comments" method="buildTables" argumentcollection="#arguments#">
	</cffunction>
	
	<cffunction name="buildTables" access="public" output="false" returntype="void" hint="I create the table for comments">
		<cfargument name="ds" required="true" type="string" hint="I am datasource">
		<cfset var createcommentTable = 0>
		<cfif not tblCheck.tableExists('#arguments.ds#', 'COMMENT')>
			<cfquery name="createcommentTable" datasource="#arguments.ds#">
			CREATE TABLE [COMMENT](
			       [COMMENTID] [varchar](16) NOT NULL PRIMARY KEY,
			       [CREATEDBYID] [bigint] NULL,
			       [PROJECTID] [varchar](16) NULL,
			       [EVENTID] [varchar](16) NULL,
			       [NAMEID] [bigint] NULL,
			       [CARTID] [varchar](16) NULL,
			       [SITEID] [varchar](16) NULL,
			       [PRODUCTID] [varchar](16) NULL,
			       [IMAGEID] [varchar](16) NULL,
			       [COMMENT] [ntext] NULL,
			       [COMMENTNAME] [varchar](1024) NULL,
			       [STATUS] [varchar](64) NULL,
			       [TASKID] [bigint] NULL,
			       [INCIDENTID] [bigint] NULL,
			       [SENDTO] [varchar](1024) NULL,
			       [SENDFROM] [varchar](1024) NULL,
			       [CREATEDON] [varchar](16) NULL,
			       [BLOGENTRYID] [BIGINT] NULL,
			       [BLOGENTRYCOMMENTEMAIL] [VARCHAR] (256) NULL,
			       [BLOGENTRYCOMMENTYOURNAME] [VARCHAR] (256) NULL)
			</cfquery>
			
			<!--- took this FK constraint building out as I did not think we really needed it, it was causing issues on the spiderwebmaster.net dsn
			20090319 - Drew --->
			<!--- ALTER TABLE [COMMENT]  WITH CHECK ADD  CONSTRAINT [FK_COMMENT_EVENT] FOREIGN KEY([EVENTID])
			REFERENCES [EVENT] ([EVENTID])
			;
			ALTER TABLE [COMMENT] CHECK CONSTRAINT [FK_COMMENT_EVENT]
			;
			ALTER TABLE [COMMENT]  WITH NOCHECK ADD  CONSTRAINT [FK_COMMENT_NAME] FOREIGN KEY([NAMEID])
			REFERENCES [NAME] ([NAMEID])
			;
			ALTER TABLE [COMMENT] CHECK CONSTRAINT [FK_COMMENT_NAME]
			;
			ALTER TABLE [COMMENT]  WITH CHECK ADD  CONSTRAINT [FK_COMMENT_PROJECT] FOREIGN KEY([PROJECTID])
			REFERENCES [PROJECT] ([PROJECTID])
			;
			ALTER TABLE [COMMENT] CHECK CONSTRAINT [FK_COMMENT_PROJECT]
			; --->
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYID')>
			<cfquery name="createBlogEntryid" datasource="#arguments.ds#">
			ALTER TABLE COMMENT ADD BLOGENTRYID BIGINT
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYCOMMENTEMAIL')>
			<cfquery name="createBlogEntryid" datasource="#arguments.ds#">
			ALTER TABLE COMMENT ADD BLOGENTRYCOMMENTEMAIL VARCHAR (256)
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYCOMMENTYOURNAME')>
			<cfquery name="createBlogEntryid" datasource="#arguments.ds#">
			ALTER TABLE COMMENT ADD BLOGENTRYCOMMENTYOURNAME VARCHAR (256)
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'LASTUPDATED')>
			<cfquery name="createLastUpdated" datasource="#arguments.ds#">
			ALTER TABLE COMMENT ADD LASTUPDATED VARCHAR (16)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getComments" output="false" returntype="query" access="public" hint="I get the comments for the id or ids you pass to me, I return a query:COMMENTID, COMMENTNAME, CREATEDBYID, PROJECTID, EVENTID, AGENCYID, PEOPLEID, CARTID, SITEID, PRODUCTID, IMAGEID,	COMMENT, status">
		<cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
		<cfargument name="nameid" type="string" required="false" default="0">
		<cfargument name="PROJECTID" type="string" required="false" default="0">
		<cfargument name="EVENTID" type="string" required="false" default="0">
		<cfargument name="AGENCYID" type="string" required="false" default="0">
		<cfargument name="PEOPLEID" type="string" required="false" default="0">
		<cfargument name="CREATEDON" type="string" required="false" default="0">
		<cfargument name="CARTID" type="string" required="false" default="0">
		<cfargument name="SITEID" type="string" required="false" default="0">
		<cfargument name="PRODUCTID" type="string" required="false" default="0">
		<cfargument name="IMAGEID" type="string" required="false" default="0">
		<cfargument name="commentid" type="string" required="false" default="0">	
		<cfargument name="status" type="string" required="false" default="0">	
		<cfargument name="BLOGENTRYID" type="string" required="false" default="0">
		<cfargument name="blogcomment" type="string" required="false" default="0">	
		<cfargument name="BLOGENTRYCOMMENTYOURNAME" type="string" required="false" default="0" hint="The name of the person leaving a comment">
		<cfargument name="BLOGENTRYCOMMENTEMAIL" type="string" required="false" default="0" hint="The e-mail of the person leaving a comment.">
		<cfquery name="getNotes" datasource="#ds#">
		SELECT
			C.COMMENTID, 
			C.COMMENTNAME,
			C.CREATEDBYID, 
			C.PROJECTID,
			C.CREATEDON, 
			C.EVENTID, 
			C.NAMEID,
			C.CARTID, 
			C.SITEID, 
			C.PRODUCTID, 
			C.IMAGEID,
			C.COMMENT,
			C.STATUS,
			C.BLOGENTRYID,
			C.BLOGENTRYCOMMENTYOURNAME,
			C.BLOGENTRYCOMMENTEMAIL,
			(SELECT COUNT(COMMENTID)
					FROM COMMENT
					WHERE C.COMMENTID = COMMENTID) AS ENTRYCOUNT
		FROM COMMENT C
		WHERE 1=1
		<cfif arguments.status neq 0>
		AND STATUS = <cfqueryparam value="#arguments.STATUS#">
		</cfif>
		<cfif arguments.blogcomment neq 0>
		AND C.BLOGENTRYID IS NOT NULL
		</cfif>
		<cfif arguments.commentid neq 0>
		AND C.COMMENTID = <cfqueryparam value="#arguments.COMMENTID#">
		</cfif>
		<cfif arguments.PROJECTID neq 0>
		AND C.PROJECTID = <cfqueryparam value="#arguments.PROJECTID#">
		</cfif>
		<cfif arguments.EVENTID neq 0>
		AND C.EVENTID = <cfqueryparam value="#arguments.EVENTID#">
		</cfif>
		<cfif arguments.CREATEDON neq 0>
		AND C.CREATEDON = <cfqueryparam value="#arguments.CREATEDON#">
		</cfif>
		<cfif arguments.AGENCYID neq 0>
		AND C.AGENCYID = <cfqueryparam value="#arguments.AGENCYID#">
		</cfif>
		<cfif arguments.nameid neq 0>
		AND C.nameid = <cfqueryparam value="#arguments.nameid#">
		</cfif>
		<cfif arguments.CARTID neq 0>
		AND C.CARTID = <cfqueryparam value="#arguments.CARTID#">
		</cfif>
		<cfif arguments.IMAGEID neq 0>
		AND C.IMAGEID = <cfqueryparam value="#arguments.IMAGEID#">
		</cfif>
		<cfif arguments.PRODUCTID neq 0>
		AND C.PRODUCTID = <cfqueryparam value="#arguments.PRODUCTID#">
		</cfif>
		<cfif arguments.BLOGENTRYID neq 0>
		AND C.BLOGENTRYID = <cfqueryparam value="#arguments.BLOGENTRYID#">
		</cfif>
		<cfif arguments.BLOGENTRYCOMMENTYOURNAME neq 0>
		AND C.BLOGENTRYCOMMENTYOURNAME = <cfqueryparam value="#arguments.BLOGENTRYCOMMENTYOURNAME#">
		</cfif>
		<cfif arguments.BLOGENTRYCOMMENTEMAIL neq 0>
		AND C.BLOGENTRYCOMMENTEMAIL = <cfqueryparam value="#arguments.BLOGENTRYCOMMENTEMAIL#">
		</cfif>
		ORDER BY COMMENTID DESC
		</cfquery>
		<cfreturn getNotes>
	</cffunction>
	
	<cffunction name="outputComment" access="public" output="false" returntype="string" hint="I save the comment passed to me as a var ready to email">
		<cfargument name="ds" required="false" type="string" hint="datasource" default="#variables.ds#">
		<cfargument name="commentid" required="true" type="string" hint="id for the comment" >
		<cfargument name="contactdsn" default="deltasystem" required="false" type="string" hint="alternate dsn to look up personal info for the one who posted the comment" >
		<cfset myComment=0>
		<cfinvoke component="comments" 
					method="getComments" 
					returnvariable="thisComment" 
					commentid="#arguments.commentid#" 
					ds="#arguments.ds#">
		<cfinvoke component="addressbook" 
					method="getPersonalInfo" 
					contactdsn="#arguments.contactdsn#" 
					nameid="#thisComment.CREATEDBYID#" 
					returnvariable="commentAuthor">
		
		<cfoutput>
		<cfsavecontent variable="myComment">
		<html>
		<head>
		<title>Notifacation of comment: #thisComment.commentname#</title>
		</head>
		<body>
		<p><strong>Greetings,</strong></p>
		<p>A comment was made by #commentAuthor.firstname# #commentAuthor.lastname# on #Mid(thisComment.commentid,5,2)#/#Mid(thisComment.commentid,7,2)#/#Left(thisComment.commentid,4)# at #Mid(thisComment.commentid,9,2)#:#Mid(thisComment.commentid,11,2)#:#Mid(thisComment.commentid,13,2)# CT.</p>
		<p>Regarding:
		<cfif thisComment.PROJECTID neq "">
		projectid value=#thisComment.PROJECTID#
		</cfif>
		<cfif thisComment.EVENTID neq "">
		EVENTID value=#thisComment.EVENTID#
		</cfif>
		<cfif thisComment.nameid neq "">
			<cfinvoke component="addressbook" 
					method="getPersonalInfo" 
					contactdsn="#arguments.ds#" 
					nameid="#thisComment.nameid#" 
					returnvariable="cname">
		NAMEID value=#thisComment.nameid#<br />#cname.firstname# #cname.lastname# at #cname.company#
		</cfif>
		<cfif thisComment.CARTID neq "">
		CARTID value=#thisComment.CARTID#
		</cfif>
		<cfif thisComment.IMAGEID neq "">
		IMAGEID value=#thisComment.IMAGEID#
		</cfif>
		<cfif thisComment.PRODUCTID neq "">
		PRODUCTID value=#thisComment.PRODUCTID#
		</cfif>
		</p>
		<p>Subject/Comment Name = #thisComment.commentname#</p>
		<p>Current status = #thisComment.status#</p> 
		<p>Comment:
		<br />#thisComment.comment#</p>
		</body>
		</html>
		</cfsavecontent>
		</cfoutput>
	<cfreturn myComment>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="deleteComment" returntype="struct" access="public" hint="I delete the comment you pass to me, I return a stucture struct.delete will be 1 if deleted and 0 if not and struct.deletemsg will have a message about whether or not I deleted your comment">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="commentid" type="string" required="true" hint="The ID of the Comment">
		<cfset var deleteMyComment=0>
		<cfset var deleteThisComment = StructNew()>
		<cfif variables.tblCheck.tableExists('#arguments.ds#', 'COMMENTSORT')>
			<cfquery name="deleteMyComment" datasource="#arguments.ds#">
				DELETE FROM COMMENTSORT
				WHERE COMMENTID = <cfqueryparam value="#arguments.commentid#">
			</cfquery>
		</cfif>
		
		<cfquery name="deleteMyComment" datasource="#arguments.ds#">
			DELETE FROM COMMENT
			WHERE COMMENTID = <cfqueryparam value="#arguments.commentid#">
			</cfquery>
			<cfset deleteThisComment.delete=1>
		<cfreturn deleteThisComment>
	</cffunction>
	
	<cffunction name="commentsort" access="public" returntype="void" hint="I sort comments">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="commentid" type="string" required="true" hint="I am the id of the comment">
		<cfargument name="parentid" type="string" required="false" default="0" hint="I am the parentid of the comment">
		<cfset var get=0>
		<cfset var update=0>
		
		<cfif arguments.parentid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT SORTORDER, NOOFREPLIES 
				FROM COMMENTSORT 
				WHERE COMMENTID=<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif get.recordcount GT 0>
				<cfset noofreplies=get.NOOFREPLIES+1>
				<cfset sortcodepart1=get.SORTORDER>
				<cfif listlen(sortcodepart1,'.') EQ 1>
					<cfset sortcodepart1="#sortcodepart1#.">
				</cfif>
				<cfset sortcodepart2=noofreplies/10000>
				<cfset sortcodepart2=listlast(sortcodepart2,'.')>
				<cfset sortcode="#sortcodepart1##sortcodepart2#">
				<cfquery name="update" datasource="#arguments.ds#">
					UPDATE COMMENTSORT SET 
					NOOFREPLIES=<cfqueryparam value="#noofreplies#" cfsqltype="cf_sql_varchar">
					WHERE COMMENTID=<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar"> 
				</cfquery>
			</cfif>
		<cfelse>
			<cfset sortcode=arguments.commentid>
		</cfif>
			
		<cfquery name="update" datasource="#arguments.ds#">
			INSERT INTO COMMENTSORT
			(
				COMMENTID,
				<cfif arguments.parentid NEQ 0>
				PARENTID,
				</cfif>
				SORTORDER
			)
			VALUES
			(
				<cfqueryparam value="#arguments.commentid#" cfsqltype="cf_sql_varchar">,
				<cfif arguments.parentid NEQ 0>
				<cfqueryparam value="#arguments.parentid#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#sortcode#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addComment" access="public" output="false" returntype="string" hint="I add the comment you pass to me and return the commentid">
	<cfargument name="ds" type="string" required="true" hint="The datasource of the comment you are adding.">
	<cfargument name="projectid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="eventid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="nameid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="cartid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="imageid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="productid" type="string" required="false" default="0" hint="The project ID relating to the comment being added.">
	<cfargument name="subject" type="string" required="false" default="0" hint="The Subject of the Comment">
	<cfargument name="userid" type="string" required="false" default="0" hint="The User ID of the person who added the Comment">
	<cfargument name="comment" type="string" required="true" hint="The Comment body of the Comment">
	<cfargument name="status" type="string" default="Private" required="false" hint="The status of the comment you are adding">
	<cfargument name="blogentryid" type="string" default="0" required="false" hint="The id of the blogentry you are commenting on">
	<cfargument name="blogentrycommentyourname" type="string" required="false" default="0" hint="The name of the person leaving a comment">
	<cfargument name="blogentrycommentemail" type="string" required="false" default="0" hint="The e-mail of the person leaving a comment.">
		<cfset timedate=mytime.createTimedate()>
		<cfquery name="qryaddcomment" datasource="#arguments.ds#">
			INSERT INTO COMMENT
			(<!--- SITEID, --->
			COMMENTID,
			COMMENTNAME,
			CREATEDBYID,
			CREATEDON, 
			COMMENT,
			STATUS
			<cfif arguments.projectID NEQ 0>
			, PROJECTID
			</cfif>
			<cfif arguments.eventID NEQ 0>
			, EVENTID
			</cfif>
			<cfif arguments.nameID NEQ 0>
			, nameid
			</cfif>
			<cfif arguments.cartID NEQ 0>
			, CARTID
			</cfif>
			<cfif arguments.imageID NEQ 0>
			, IMAGEID
			</cfif>
			<cfif arguments.productID NEQ 0>
			, PRODUCTID
			</cfif>
			<cfif arguments.blogentryid NEQ 0>
			, BLOGENTRYID
			</cfif>
			<cfif arguments.blogentrycommentyourname NEQ 0>
			, blogentrycommentyourname
			</cfif>
			<cfif arguments.blogentrycommentemail NEQ 0>
			, blogentrycommentemail
			</cfif>)
			VALUES (<!--- '#SESSION.SITEID#', --->
			<cfqueryparam value="#timedate#">,
			<cfqueryparam value="#arguments.subject#">,
			<cfqueryparam value="#arguments.userid#">,
			<cfqueryparam value="#myTime.createTimeDate()#">, 
			<cfqueryparam value="#arguments.comment#">,
			<cfqueryparam value="#arguments.status#">
			<cfif arguments.projectID NEQ 0>
			, <cfqueryparam value="#arguments.PROJECTID#">
			</cfif>
			<cfif arguments.eventID NEQ 0>
			, <cfqueryparam value="#arguments.eventID#">
			</cfif>
			<cfif arguments.nameID NEQ 0>
			, <cfqueryparam value="#arguments.nameID#">
			</cfif>
			<cfif arguments.cartID NEQ 0>
			, <cfqueryparam value="#arguments.cartID#">
			</cfif>
			<cfif arguments.imageID NEQ 0>
			, <cfqueryparam value="#arguments.imageID#">
			</cfif>
			<cfif arguments.productID NEQ 0>
			, <cfqueryparam value="#arguments.productID#">
			</cfif>
			<cfif arguments.blogentryid NEQ 0>
			, <cfqueryparam value="#arguments.blogentryid#">
			</cfif>
			<cfif arguments.blogentrycommentyourname NEQ 0>
			, <cfqueryparam value="#arguments.blogentrycommentyourname#">
			</cfif>
			<cfif arguments.blogentrycommentemail NEQ 0>
			, <cfqueryparam value="#arguments.blogentrycommentemail#">
			</cfif>
			)
		</cfquery>
		<cfreturn timedate>
	</cffunction>

	<!--- done, not tested --->
	<cffunction name="updateComment" access="public" output="false" hint="I update the contact for the mynameid passed to me">
		<cfargument name="ds" type="string" required="true" hint="The datasource of the comment you are updating.">
		<cfargument name="projectid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="eventid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="nameid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="cartid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="imageid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="productid" type="string" required="false" default="0" hint="The project ID relating to the comment being updated.">
		<cfargument name="subject" type="string" required="false" hint="The Subject of the Comment">
		<cfargument name="commentid" type="string" required="true" hint="The ID of the Comment">
		<cfargument name="userid" type="string" required="false" hint="The User ID of the person who added the Comment">
		<cfargument name="comment" type="string" required="false" hint="The Comment body of the Comment">
		<cfargument name="status" type="string" default="0" required="false" hint="The status of the comment you are adding">
		<cfargument name="blogentryid" type="string" default="0" required="false" hint="The id of the blogentry you are commenting on">
		<cfargument name="blogentrycommentyourname" type="string" required="false" default="0" hint="The name of the person leaving a comment">
		<cfargument name="blogentrycommentemail" type="string" required="false" default="0" hint="The e-mail of the person leaving a comment."> 
		<cfset var qryupdatecomment=0>
		<cfinvoke component="comments" method="buildTables" ds="#arguments.ds#">
		<cfquery name="qryupdatecomment" datasource="#arguments.ds#">
			UPDATE COMMENT
			SET LASTUPDATED =<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				<cfif arguments.blogentrycommentyourname NEQ 0>
				, BLOGENTRYCOMMENTYOURNAME = <cfqueryparam value="#arguments.blogentrycommentyourname#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif arguments.blogentrycommentemail NEQ 0>
				, BLOGENTRYCOMMENTEMAIL=<cfqueryparam value="#arguments.blogentrycommentemail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif arguments.status NEQ 0>
				, STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif arguments.blogentrycommentemail NEQ 0>
				, COMMENT=<cfqueryparam value="#arguments.comment#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
			WHERE COMMENTID = <cfqueryparam value="#arguments.commentid#">
		</cfquery>	
	</cffunction>
</cfcomponent>