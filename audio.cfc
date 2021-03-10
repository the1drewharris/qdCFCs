<cfcomponent hint="I have all the functions for podcasts">
<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">

<cffunction name="createpodcasttable">
	<cfquery name="createtables" datasource="none">
		CREATE TABLE AUDIOLIB
		(
			VID BIGINT NOT NULL,
			TITLE VARCHAR(1024) NOT NULL,
			STATUS VARCHAR(32) NOT NULL,
			CAPTION VARCHAR(128) NOT NULL,
			LINK VARCHAR(128) NOT NULL,
			LINKTEXT VARCHAR(256) NOT NULL,
			KEYWORDS NTEXT NOT NULL,
			VIDEOPATH NTEXT NOT NULL,
			IMAGEPATH NTEXT NOT NULL,
			SORTORDER INT NOT NULL DEFAULT 0,
			CREATEDON VARCHAR(16) NOT NULL,
			UPDATEDON VARCHAR(16) NOT NULL,
			SUBTITLE VARCHAR(1024),
			MEDIATYPEID INT DEFAULT 1,
			SUMMARY NTEXT,
			DESCRIPTION NTEXT
			
		);
		ALTER TABLE AUDIOLIB ADD CONSTRAINT PK_VIDEOLIB PRIMARY KEY(VID);
		ALTER TABLE AUDIOLIB ADD CONSTRAINT VIDEOLIB_VIDEOSTATUS FOREIGN KEY(STATUS) REFERENCES VIDEOSTATUS(STATUS);
		ALTER TABLE AUDIOLIB ADD CONSTRAINT VIDEOLIB_MEDIA FOREIGN KEY(MEDIATYPEID) REFERENCES MEDIATYPE(MEDIATYPEID);
	</cfquery>
</cffunction>

<cffunction name="addpodcast" access="public" returntype="void" hint="I add podcast to the podcast library">
	<cfargument name="podcastdsn" required="true" type="string" hint="Datasource">
	<cfargument name="vid" required="true" type="string" hint="id of the podcast">
	<cfargument name="title" required="true" type="string" hint="Title of the podcast">
	<cfargument name="status" required="true" type="string" hint="Status of the podcast">
	<cfargument name="caption" required="true" type="string" hint="Caption of the podcast">
	<cfargument name="path" required="true" type="string" hint="path of the podcast">
	<cfargument name="keywords" required="true" type="string" hint="Keywords for the podcast">
	<cfargument name="sortorder" required="true" type="string" hint="used to sort podcasts">
	<cfargument name="link" required="true" type="String" hint="url for the podcast">
	<cfargument name="linktext" required="true" type="String" hint="text to display for url">

	<cfquery name="addpodcast" datasource="#podcastdsn#">
		INSERT INTO PODCAST
		(
			VID,
			TITLE,
			STATUS,
			CAPTION,
			PATH,
			KEYWORDS,
			LINK,
			LINKTEXT,
			SORTORDER,
			CREATEDON,
			UPDATEDON
		)
		VALUES
		(
			<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#caption#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#path#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#keywords#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#link#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#linktext#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#sortorder#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
</cffunction>

<cffunction name="addsample" access="public" output="false" returntype="void" hint="I add sample podcast">
	<cfargument name="podcastdsn" required="true" type="string" hint="Data source">
	<cfargument name="vid" type="string" required="true" hint="vid of a podcast">
	<cfargument name="samplepath" type="string" required="true" hint="name of the sample podcast">
	<cfargument name="sampleid" type="string" required="true" hint="sample id of the podcast">
	<cfset var addsample=0>
	<cfquery name="addsample" datasource="#podcastdsn#">
		INSERT INTO SAMPLEMEDIA
		(
			SAMPLEID,
			VID,
			SAMPLEPATH
		)
		VALUES
		(
			<cfqueryparam value="#sampleid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#samplepath#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
</cffunction>

<cffunction name="podcastToCategory" access="public" returntype="void" hint="I assign video to certain category">
	<cfargument name="podcastdsn" required="true" type="string" hint="Datasource">
	<cfargument name="vid" required="true" type="string" hint="vid of the video">
	<cfargument name="category" required="true" type="String" hint="category of the video">
	<cfset var setcategory=0>
	<cfquery name="setcategory" datasource="#videodsn#">
		INSERT INTO VIDEO_TO_CATEGORY
		(
			VID,
			CATEGORY,
			TIMEDATE
		)
		VALUES
		(
			<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
</cffunction>

<cffunction name="getpodcast" access="public" output="false" returntype="Query" hint="I show podcast information">
	<cfargument name="podcastdsn" required="true" type="string" hint="Data source">
	<cfargument name="keyword" required="false" type="string" hint="search keyword field or all fields">
	<cfargument name="vid" required="false" type="string" hint="vid of the podcast" default="0">
	<cfargument name="criteria" required="false" type="string" hint="search word">
	<cfargument name="status" required="false" type="string" default="public" hint="status of the podcast to be looked for">
	<cfargument name="category" required="false" type="string" default="All" hint="category of podcasts">
	<cfargument name="noofpodcast" required="false" type="String" default="all" hint="no of podcast to return">
	<cfset var podcast=0>
	<cfif status EQ "All">
		<cfset status="%">
	</cfif>
	<cfquery name="podcast" datasource="#podcastdsn#">
		SELECT
			<cfif noofpodcast NEQ "all">
			TOP #noofpodcast#
			</cfif>
			VID,
			TITLE,
			STATUS,
			CAPTION,
			LINK,
			LINKTEXT,
			KEYWORDS,
			PATH,
			CREATEDON,
			UPDATEDON,
			SORTORDER,
			(SELECT TOP 1 TIMEDATE FROM VIEWRECORD WHERE PODCAST.VID=VIEWRECORD.VID ORDER BY TIMEDATE DESC)
			AS LASTVIEWED
			FROM PODCAST
			WHERE STATUS LIKE <cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
			<cfif category NEQ "All">
			AND VID IN (SELECT VID FROM VIDEO_TO_CATEGORY WHERE CATEGORY LIKE <cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">)
			</cfif>
			<cfif NOT isDefined('criteria')>
				<cfif vid neq 0>
				AND VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
				</cfif>
			<cfelse>
				 AND (KEYWORDS LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">
				<cfif not isDefined('keyword')>
					OR TITLE LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">
					OR CAPTION LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">
					OR LINK LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">
					OR LINKTEXT LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">
					OR PATH LIKE <CFQUERYPARAM VALUE="%#criteria#%" cfsqltype="cf_sql_varchar">)
				<cfelse>
					)
				</cfif>
			</cfif>
			ORDER BY SORTORDER DESC
	</cfquery>
	<cfreturn podcast>
</cffunction>

<cffunction name="gettoppodcasts" access="public" returntype="Query" hint="I get top podcasts">
	<cfargument name="podcastdsn" type="string" required="true" hint="The datasource for the podcasts">
	<cfargument name="noofpodcasts" type="string" required="false" default="3" hint="The datasource for the podcasts">
	<cfset var toppodcast=0>
	<cfquery name="toppodcasts" datasource="#podcastdsn#">
		SELECT
		TOP #noofpodcasts#
		VID,
		TITLE,
		STATUS,
		CAPTION,
		LINK,
		LINKTEXT,
		KEYWORDS,
		PATH,
		IMAGEPATH,
		CREATEDON,
		UPDATEDON,
		(SELECT COUNT(VID) FROM VIEWRECORD WHERE VID=PODCAST.VID) AS VIEWCOUNT,
		(SELECT TOP 1 SAMPLEID FROM SAMPLEMEDIA WHERE VID=PODCAST.VID ORDER BY SAMPLEID) AS SAMPLEID,
		(SELECT TOP 1 SAMPLEPATH FROM SAMPLEMEDIA WHERE VID=PODCAST.VID ORDER BY SAMPLEID) AS SAMPLEPATH
		FROM PODCAST
		ORDER BY VIEWCOUNT DESC
	</cfquery>
	<cfreturn toppodcasts>
</cffunction>

<cffunction name="getfreepodcast" access="public" returntype="Query" hint="I get top videos">
	<cfargument name="podcastdsn" type="string" required="true" hint="The datasource for the videos">
	<cfargument name="noofpodcasts" type="string" required="false" default="2" hint="The datasource for the videos">
	<cfset var freepodcast=0>
	<cfquery name="freepodcast" datasource="#podcastdsn#">
		SELECT
		TOP #noofpodcasts#
		VID,
		TITLE,
		STATUS,
		CAPTION,
		LINK,
		LINKTEXT,
		KEYWORDS,
		PATH,
		CREATEDON,
		UPDATEDON,
		(SELECT COUNT(VID) FROM VIEWRECORD WHERE VID=PODCAST.VID) AS VIEWCOUNT,
		(SELECT TOP 1 SAMPLEID FROM SAMPLEMEDIA WHERE VID=PODCAST.VID ORDER BY SAMPLEID) AS SAMPLEID,
		(SELECT TOP 1 SAMPLEPATH FROM SAMPLEMEDIA WHERE VID=PODCAST.VID ORDER BY SAMPLEID) AS SAMPLEPATH
		FROM PODCAST
		WHERE VID NOT IN (SELECT SUBSCRIABLEID AS VID FROM SUBSCRIPTIONPLANS)
		ORDER BY VIEWCOUNT DESC
	</cfquery>
	<cfreturn freepodcast>
</cffunction>

<cffunction name="updatePodcast" access="public" output="false" returntype="void" hint="I edit podcast information">
	<cfargument name="podcastdsn" required="true" type="string" hint="Data source">
	<cfargument name="vid" required="true" type="string" hint="vid of the podcast">
	<cfargument name="title" required="false" type="string" hint="Title of the podcast">
	<cfargument name="status" required="false" type="string" hint="Status of the podcast">
	<cfargument name="caption" required="false" type="string" hint="Caption of the podcast">
	<cfargument name="path" required="false" type="string" hint="path of the podcast">
	<cfargument name="sortorder" required="false" type="string" hint="used to sort podcasts">
	<cfargument name="keywords" required="false" type="string" hint="Keywords for the podcast">
	<cfargument name="link" required="false" type="String" hint="url for the podcast">
	<cfargument name="linktext" required="false" type="String" hint="text to display for url">
	
	<cfquery name="updatepodcast" datasource="#podcastdsn#">
		UPDATE PODCAST
		SET UPDATEDON=<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
		<cfif isDefined('title')>
			,TITLE=<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('status')>
			,STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('caption')>
			,CAPTION=<cfqueryparam value="#caption#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('path')>
			,PATH=<cfqueryparam value="#path#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('keywords')>
			,KEYWORDS=<cfqueryparam value="#keywords#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('sortorder')>
			,SORTORDER=<cfqueryparam value="#sortorder#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('link')>
			,LINK=<cfqueryparam value="#link#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isDefined('linktext')>
			,LINKTEXT=<cfqueryparam value="#linktext#" cfsqltype="cf_sql_varchar">
		</cfif>
		WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="XmlBuild" output="false" returntype="void" access="public" hint="I build the xml for the podcastdsn passed to me.">
		<cfargument name="podcastdsn" type="string" required="true" hint="The datasource for the podcasts">
		<cfset podcasts=getPodcast(arguments.podcastdsn)>
		<cfset mysitepath = "/home/drew/domains/#podcastdsn#/public_html/podcast/">
		<cfsavecontent variable="xml_map"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>
			<Podcasts>
				<cfoutput query="podcasts">
					<Podcast> 
					<path>=#path#</path> 
					<vid>#vid#</vid> 
					<title>#XMLFormat(title)#</title> 
					<status>#status#</status>
					<caption>#XMLFormat(CAPTION)#</caption> 
					<link>#link#</link> 
					<linktext>#linktext#</linktext> 
					<keywords>#keywords#</keywords>
					<createdon>#createdon#</createdon>
					<updatedon>#updatedon#</updatedon> 
					<sortorder>#sortorder#</sortorder>
					<cfinvoke component="videolib" method="getVideoCategory" returnvariable="categories" videodsn="#podcastdsn#" vid="#vid#">
					<cfloop query="categories">
					<category>#category#</category>
					</cfloop>
					</Podcast>
				</cfoutput>
			</Podcasts>
		</cfsavecontent>
		<cfoutput>
			<cffile action="write" mode="775" addnewline="no" file="#mysitepath#xml_map.xml" output="#xml_map#">
		</cfoutput>
	</cffunction>
</cfcomponent>