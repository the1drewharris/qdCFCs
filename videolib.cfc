<!--- Though this file is named videolib.cfc, it is actually for media. --->

<cfcomponent hint="video library functions">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions" name="txtConvert">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		
	<cffunction name="createvideolib" access="private" returntype="void" hint="I create video library tables.">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfquery name="createvideolib" datasource="#videodsn#">
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIDEOLENGTH') 
			DROP TABLE VIDEOLENGTH
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'USERVIEW') 
			DROP TABLE USERVIEW
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIDEO_TO_CATEGORY') 
			DROP TABLE VIDEO_TO_CATEGORY;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIEWRECORD') 
			DROP TABLE VIEWRECORD;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SAMPLEMEDIA') 
			DROP TABLE SAMPLEMEDIA;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIDEOLIB') 
			DROP TABLE VIDEOLIB;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIDEOCATEGORY')
			DROP TABLE VIDEOCATEGORY;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VIDEOSTATUS')
			DROP TABLE VIDEOSTATUS;
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MEDIATYPE')
			DROP TABLE MEDIATYPE;
			
			CREATE TABLE MEDIATYPE
			(
				MEDIATYPEID INT NOT NULL,
				MEDIATYPE VARCHAR(32) NOT NULL
			);
			ALTER TABLE MEDIATYPE ADD CONSTRAINT PK_MEDIATYPE PRIMARY KEY(MEDIATYPEID); 
			INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(1, 'Video');
			INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(2, 'Audio');
			INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(3, 'File');
			
			CREATE TABLE VIDEOSTATUS
			(
				STATUS VARCHAR(32) NOT NULL
			);
			ALTER TABLE VIDEOSTATUS ADD CONSTRAINT PK_VIDEOSTATUS PRIMARY KEY(STATUS);
			
			CREATE TABLE VIDEOCATEGORY
			(
				VIDEOCATEGORYID INT NOT NULL IDENTITY(1,1),
				CATEGORY VARCHAR(32) NOT NULL,
				SORTORDER BIGINT NOT NULL DEFAULT 0
			)
			ALTER TABLE VIDEOCATEGORY ADD CONSTRAINT PK_VIDEOCATEGORY PRIMARY KEY(VIDEOCATEGORYID);
			
			CREATE TABLE VIDEOLIB
			(
				VID BIGINT NOT NULL,
				TITLE VARCHAR(1024) NOT NULL,
				STATUS VARCHAR(32) NOT NULL,
				CAPTION NTEXT NOT NULL,
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
			ALTER TABLE VIDEOLIB ADD CONSTRAINT PK_VIDEOLIB PRIMARY KEY(VID);
			ALTER TABLE VIDEOLIB ADD CONSTRAINT VIDEOLIB_VIDEOSTATUS FOREIGN KEY(STATUS) REFERENCES VIDEOSTATUS(STATUS);
			ALTER TABLE VIDEOLIB ADD CONSTRAINT VIDEOLIB_MEDIA FOREIGN KEY(MEDIATYPEID) REFERENCES MEDIATYPE(MEDIATYPEID); 
			
			CREATE TABLE SAMPLEMEDIA
			(
				SAMPLEID BIGINT NOT NULL,
				SAMPLEPATH VARCHAR(1024) NOT NULL,
				VID BIGINT NOT NULL
			)
			ALTER TABLE SAMPLEMEDIA ADD CONSTRAINT PK_SAMPLEMEDIA PRIMARY KEY(SAMPLEID);
			ALTER TABLE SAMPLEMEDIA ADD CONSTRAINT SAMPLEMEDIA_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			
			CREATE TABLE VIEWRECORD
			(
				VIEWID BIGINT NOT NULL IDENTITY(1,1),
				VID BIGINT NOT NULL,
				CFID VARCHAR(32) NOT NULL,
				IPADDRESS VARCHAR(32) NOT NULL,
				COMPLETED BIT NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL
			);
			ALTER TABLE VIEWRECORD ADD CONSTRAINT PK_VIEWID PRIMARY KEY(VIEWID);
			ALTER TABLE VIEWRECORD ADD CONSTRAINT VIEWRECORD_IDPOOL FOREIGN KEY(VID) REFERENCES IDPOOL(ID);
			
			INSERT INTO VIDEOSTATUS VALUES ('Public');
			INSERT INTO VIDEOSTATUS VALUES ('Private');
			INSERT INTO VIDEOSTATUS VALUES ('Inactive');
			
			CREATE TABLE VIDEO_TO_CATEGORY
			(
				VID BIGINT NOT NULL,
				VIDEOCATEGORYID INT NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL,
				SORTORDER BIGINT NOT NULL DEFAULT 0
			)
			ALTER TABLE VIDEO_TO_CATEGORY ADD CONSTRAINT VIDEO_TO_CATEGORY_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			ALTER TABLE VIDEO_TO_CATEGORY ADD CONSTRAINT VIDEO_TO_CATEGORY_VIDEOCATEGORY FOREIGN KEY(VIDEOCATEGORYID) REFERENCES VIDEOCATEGORY(VIDEOCATEGORYID);
			
			CREATE TABLE USERVIEW
			(
				VIEWID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL
			)
			ALTER TABLE USERVIEW ADD CONSTRAINT PK_UESRVIEW PRIMARY KEY(VIEWID);
			ALTER TABLE USERVIEW ADD CONSTRAINT USERVIEW_VIEWRECORD FOREIGN KEY(VIEWID) REFERENCES VIEWRECORD(VIEWID);
			ALTER TABLE USERVIEW ADD CONSTRAINT USERVIEW_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE VIDEOLENGTH
			(
				VID BIGINT NOT NULL,
				LENGTH BIGINT NOT NULL
			)
			ALTER TABLE VIDEOLENGTH ADD CONSTRAINT PK_VIDEOLENGTH PRIMARY KEY(VID);
			ALTER TABLE VIDEOLENGTH ADD CONSTRAINT FK_VIDEOLENGTH_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
		</cfquery>
	</cffunction>
	
	<cffunction name="addRunTime" access="public" returntype="void" hint="I record run time of a video">
		<cfargument name="videodsn" required="true" type="string" hint="database name">
		<cfargument name="vid" required="true" type="string" hint="id of the video">
		<cfargument name="runtime" required="true" type="string" hint="run time">
		<cfset var set=0>
		<cfquery name="set" datasource="#arguments.videodsn#">
			INSERT INTO VIDEOLENGTH
			(
				VID,
				LENGTH
			)
			VALUES
			(
				<cfqueryparam value="#arguments..vid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.runtime#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn> 
	</cffunction>
	
	<cffunction name="getCompletedViewCount" access="public" returntype="string" hint="I get view records of the video which are completed viewed">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var get=0>
		<cfquery name="get"  datasource="#arguments.videodsn#">
			SELECT
				COUNT(*) AS TOTALCOMPLETEDVIEWS
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE > <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE < <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			AND COMPLETED=1
		</cfquery>
		<cfreturn get.TOTALCOMPLETEDVIEWS>
	</cffunction>
	
	<cffunction name="getUniqueViewCount" access="public" returntype="string" hint="I get view record of a video">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT
				COUNT(DISTINCT CFID) AS TOTALVIEWS
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE >= <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE <= <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get.TOTALVIEWS>
	</cffunction>
	
	<cffunction name="getViewCount" access="public" returntype="string" hint="I get view record of a video">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var get=0>
		<cfquery name="get"  datasource="#arguments.videodsn#">
			SELECT
				COUNT(*) AS VIEWCOUNT
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE >= <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE <= <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get.VIEWCOUNT>
	</cffunction>
	
	<cffunction name="checkAlbum" access="public" output="false" returntype="boolean" hint="I check if the album exists">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="videocategoryid" required="true" type="String" hint="category of the video">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT VIDEOCATEGORYID FROM VIDEOCATEGORY 
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
	
	<cffunction name="getVideoTitle" access="public" returntype="string" hint="I get status of the video">
		<cfargument name="videodsn" required="true" type="string" hint="I am the database name">
		<cfargument name="vid" required="true" type="string" hint="id of the video">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT TITLE 
			FROM VIDEOLIB
			WHERE VID=<cfqueryparam value="#arguments.vid#">		
		</cfquery>
		<cfreturn get.TITLE>
	</cffunction> 
	
	<cffunction name="getVideoStatus" access="public" returntype="string" hint="I get status of the video">
		<cfargument name="videodsn" required="true" type="string" hint="I am the database name">
		<cfargument name="vid" required="true" type="string" hint="id of the video">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT STATUS 
			FROM VIDEOLIB
			WHERE VID=<cfqueryparam value="#arguments.vid#">		
		</cfquery>
		<cfreturn get.STATUS>
	</cffunction> 
	
	<cffunction name="updateVideoStatus" access="public" returntype="void" hint="I update video status">
		<cfargument name="videodsn" required="true" type="string" hint="I am the name of the database">
		<cfargument name="vid" required="true" type="string" hint="id of the video">
		<cfargument name="status" required="true" type="string" hint="new status of the video">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.videodsn#">
			UPDATE VIDEOLIB
			SET STATUS=<cfqueryparam value="#arguments.status#">
			WHERE VID=<cfqueryparam value="#arguments.vid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getAllGalleries" access="public" returntype="query" output="false" hint="I get all video galleries">
		<cfargument name="videodsn" required="true" type="string" hint="database name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT
				VIDEOCATEGORYID,
				CATEGORY
			FROM VIDEOCATEGORY
			ORDER BY SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="sortVideosInGallery" access="public" returntype="void" hint="I sort video galleries">
		<cfargument name="videodsn" required="true" type="string" hint="I am the data source">
		<cfargument name="videocategoryid" required="true" type="string" hint="I am the video category id">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of galleries in sort order">
		<cfset var sort=0>
		<cfset var l=listlen(arguments.sortlist)>
		<cfquery name="sort" datasource="#arguments.videodsn#">
			UPDATE VIDEO_TO_CATEGORY
			SET SORTORDER = CASE VID
				<cfloop from="1" to="#l#" index="i">
					WHEN <cfqueryparam value="#listGetAt(arguments.sortlist,i)#"> THEN <cfqueryparam value="#i#">
				</cfloop>
				ELSE SORTORDER
			END
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="deletevideogalleries" access="public" returntype="void" output="false" hint="Delete video galleries">
		<cfargument name="videodsn" required="true" type="string" hint="database name">
		<cfargument name="gallerylist" required="true" type="string" hint="list of galleries">
		<cfset var deleteitems=0>
		<cfset var delete=0>
		<cfquery name="deleteitems" datasource="#arguments.videodsn#">
			DELETE FROM VIDEO_TO_CATEGORY
			WHERE VIDEOCATEGORYID IN (#arguments.gallerylist#)
		</cfquery>
		<cfquery name="delete" datasource="#arguments.videodsn#">
			DELETE FROM VIDEOCATEGORY
			WHERE VIDEOCATEGORYID IN (#arguments.gallerylist#)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="sortvideoalbums" access="public" returntype="void" hint="I sort video galleries">
		<cfargument name="videodsn" required="true" type="string" hint="I am the data source">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of galleries in sort order">
		<cfset var sort=0>
		<cfset var l=listlen(arguments.sortlist)>
		<cfquery name="sort" datasource="#arguments.videodsn#">
			UPDATE VIDEOCATEGORY
			SET SORTORDER = CASE VIDEOCATEGORYID
				<cfloop from="1" to="#l#" index="i">
					WHEN <cfqueryparam value="#listGetAt(arguments.sortlist,i)#"> THEN <cfqueryparam value="#i#">
				</cfloop>
			END
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getRandomImage" access="public" returntype="string" hint="I get a random image for a category">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="category" required="false" type="String" hint="category of the video">
		<cfargument name="videocategoryid" required="false" type="String" hint="category of the video">
		<cfset var image=0>
		<cfif isDefined('arguments.category')>
			<cfquery name="getcategoryid" datasource="#arguments.videodsn#">
				SELECT VIDEOCATEGORYID FROM VIDEOCATEGORY WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			</cfquery>	
			<cfset videocategoryid=getcategoryid.videocategoryid>	
		</cfif>
		<cfquery name="image" datasource="#arguments.videodsn#">
			SELECT TOP 1 IMAGEPATH
			FROM VIDEOLIB, VIDEO_TO_CATEGORY
			
			WHERE VIDEO_TO_CATEGORY.VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">
			AND VIDEO_TO_CATEGORY.VID=VIDEOLIB.VID
			AND VIDEOLIB.STATUS = 'Public'
			ORDER BY NEWID()
		</cfquery>
		<cfreturn image.imagepath >
	</cffunction>
	
	<cffunction name="getCategoriesInUse" access="public" returntype="query" hint="I get category and an image for that category. output: category, total">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfset var videocategory=0>
		<cfquery name="getvideocategory" datasource="#arguments.videodsn#">
			SELECT 
				VIDEOCATEGORY.CATEGORY, 
				COUNT(VID) AS TOTAL 
			FROM VIDEOCATEGORY, VIDEO_TO_CATEGORY 
			WHERE VID NOT IN(SELECT VID FROM VIDEOLIB WHERE STATUS='INACTIVE' OR STATUS='PRIVATE')
			AND VIDEOCATEGORY.VIDEOCATEGORYID=VIDEO_TO_CATEGORY.VIDEOCATEGORYID
			GROUP BY VIDEOCATEGORY.CATEGORY
		</cfquery>
		<cfreturn getvideocategory>
	</cffunction>
	
	<cffunction name="getStatus" access="public" returntype="Query" hint="I get the status of the videos. output: status">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfset var getstatus=0>
		<cfquery name="getstatus" datasource="#arguments.videodsn#">
			SELECT STATUS FROM VIDEOSTATUS ORDER BY STATUS DESC
		</cfquery>
		<cfreturn getstatus>
	</cffunction>
	
	<cffunction name="addstatus" access="public" returntype="void" hint="I add status">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="status" required="true" type="String" hint="Status of the video">
		<cfset var addstatus=0>
		<cfquery name="addstatus" datasource="#arguments.videodsn#">
			INSERT INTO VIDEOSTATUS
			(
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="addcategory" access="public" returntype="String" hint="I add video category">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="category" required="true" type="String" hint="category of the video">
		<cfset var addcategory=0>
		<cfquery name="addcategory" datasource="#videodsn#">
			INSERT INTO VIDEOCATEGORY
			(
				CATEGORY
			)
			VALUES
			(
				<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS VIDEOCATEGORYID
		</cfquery>
		<cfreturn addcategory.VIDEOCATEGORYID>
	</cffunction>
	
	<cffunction name="deleteCategory" access="public" returntype="void" hint="I delete video category">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<!--- <cfargument name="category" required="false" type="String" hint="category of the video"> --->
		<cfargument name="videocategoryid" required="false" type="String" hint="videocategoryid of the video">
		<cfset var deletecategory=0>
		
		<cfquery name="deletecategory" datasource="#videodsn#">
			DELETE FROM VIDEO_TO_CATEGORY 
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#">
			<!--- <cfif isDefined('arguments.videocategoryid')> --->
			DELETE FROM VIDEOCATEGORY
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">	
		<!--- 	<cfelseif isDefined('category')>
			DELETE FROM VIDEOCATEGORY
			WHERE CATEGORY=<cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_varchar">
			</cfif> --->
		</cfquery>
	</cffunction>
	
	<cffunction name="editCategory" access="public" returntype="void" hint="I add video category">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="newcategory" required="true" type="String" hint="new category of the video">
		<cfargument name="videocategoryid" required="false" type="String" hint="video category id">
		<cfargument name="category" required="false" type="String" hint="old category of the video">
		<cfset var editcategory=0>
		<cfquery name="editcategory" datasource="#videodsn#">
			UPDATE VIDEOCATEGORY
			SET CATEGORY=<cfqueryparam value="#newcategory#" cfsqltype="cf_sql_varchar">
			<cfif isDefined('videocategoryid')>
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#videocategoryid#" cfsqltype="cf_sql_varchar">
			<cfelse>
			WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
	</cffunction>
	
	<cffunction name="videoToCategory" access="public" returntype="void" hint="I assign video to certain category">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="videocategoryid" required="true" type="String" hint="category of the video">
		<cfset var addtocat=0>
		<cfset var sortmax=0>
		<cfset var getmaxsortorder=0>
		<cfquery name="deletefromgallery" datasource="#arguments.videodsn#">
		DELETE
		FROM VIDEO_TO_CATEGORY
		WHERE VID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.vid#">
			AND VIDEOCATEGORYID = <cfqueryparam value="#arguments.videocategoryid#">
		</cfquery>
		<cfquery name="getmaxsortorder" datasource="#arguments.videodsn#">
		SELECT
			MAX(SORTORDER) AS SORTMAX
		FROM VIDEO_TO_CATEGORY
		WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#">
		</cfquery>
		<cfif getmaxsortorder.sortmax neq "">
			<cfset sortmax=getmaxsortorder.sortmax + 10>
		<cfelse>
			<cfset sortmax=10>
		</cfif>
		<cfquery name="addtocat" datasource="#arguments.videodsn#">
			INSERT INTO VIDEO_TO_CATEGORY
			(
				VID,
				VIDEOCATEGORYID,
				TIMEDATE,
				SORTORDER
			)
			VALUES
			(
				<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#sortmax#">
			)
		</cfquery>
	</cffunction>

	<cffunction name="removeVideoFromCategory" access="public" returntype="void" hint="I remove video from category. I delete database record and files">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="videocategoryid" required="true" type="String" hint="category of the video">
		<cfset var removeVideoFromCategory=0>
		<cfquery name="removeVideoFromCategory" datasource="#arguments.videodsn#">
			DELETE FROM VIDEO_TO_CATEGORY 
			WHERE VID=<cfqueryparam value="#arguments.vid#">
			AND VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#">			
		</cfquery>
	</cffunction>

	<cffunction name="removeVideoFromAllCategory" access="public" returntype="void" hint="I remove a video from all categories">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#videodsn#">
			DELETE FROM VIDEO_TO_CATEOGRY
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="removeVideo" access="public" returntype="void" hint="I delete video from the database">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="videopath" required="true" type="string" hint="name of the video file">
		<cfargument name="imagepath" required="true" type="string" hint="name of the preview image file">
		<cfset var deleteviewrecord=0>
		<cftransaction>
		<cfquery name="deleteviewrecord" datasource="#arguments.videodsn#">
			DELETE FROM VIEWRECORD WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="deletevideotocategory" datasource="#arguments.videodsn#">
			DELETE FROM VIDEO_TO_CATEGORY WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="deletefromvideolib" datasource="#arguments.videodsn#">
			DELETE FROM VIDEOLIB WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="deletefromidpool" datasource="#arguments.videodsn#">
			DELETE FROM IDPOOL WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		</cftransaction>
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/videos/#videopath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/#imagepath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/tiny/#imagepath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/small/#imagepath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/large/#imagepath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/detail/#imagepath#">
		<cffile action = "delete" file = "/home/drew/domains/#videodsn#/public_html/images/qdcms/#imagepath#">
		
	</cffunction>
	
	<cffunction name="addVideo" access="public" returntype="string" hint="I add video to the video library">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="id of the video">
		<cfargument name="title" required="true" type="string" hint="Title of the video">
		<cfargument name="videopath" required="true" type="string" hint="path of the video">
		<cfargument name="keywords" required="true" type="string" hint="Keywords for the video" default="">
		<cfargument name="sortorder" required="true" type="string" hint="used to sort videos">
		<cfargument name="link" required="true" type="String" hint="url for the video">
		<cfargument name="linktext" required="true" type="String" hint="text to display for url">
		<cfargument name="status" required="false" type="string" hint="Status of the video" default="public">
		<cfargument name="imagepath" required="false" default="" type="string" hint="path of the image used as thumb nail for video">
		<cfargument name="subtitle" required="false" type="String" default="" hint="Subtitle for this media">
		<cfargument name="summary" required="false" type="String" default="" hint="Short description to display">
		<cfargument name="description" required="false" type="String" default="" hint="Description">
		<cfargument name="caption" required="false" type="string"  default="" hint="Caption of the video">
		<cfargument name="mediatypeid" required="false" type="string"  default="1" hint="1:Video, 2:Audio">
		<cfset var addVideo=0>
		<cfquery name="addvideo" datasource="#arguments.videodsn#">
			INSERT INTO VIDEOLIB
			(
				VID,
				TITLE,
				STATUS,
				CAPTION,
				VIDEOPATH,
				IMAGEPATH,
				KEYWORDS,
				LINK,
				LINKTEXT,
				SORTORDER,
				CREATEDON,
				UPDATEDON,
				SUBTITLE,
				MEDIATYPEID,
				SUMMARY,
				DESCRIPTION
			)
			VALUES
			(
				<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.videopath#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.imagepath#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.keywords#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.link#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.linktext#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.subtitle#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.mediatypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.summary#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS VID
		</cfquery>
		<cfreturn vid>
	</cffunction>

	<cffunction name="updateVideo" acces="public" returntype="void" hint="I update video and video data">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="title" required="false" default="0" type="string" hint="Title of the video">
		<cfargument name="status" required="false" default="0" type="string" hint="Status of the video">
		<cfargument name="caption" required="false" default="0" type="string" hint="Caption of the video">
		<cfargument name="videopath" required="false" default="0" type="string" hint="path of the video">
		<cfargument name="imagepath" required="false" default="0" type="string" hint="path of the image used as thumb nail for video">
		<cfargument name="sortorder" required="false" default="novalue" type="string" hint="used to sort videos">
		<cfargument name="keywords" required="false" default="0" type="string" hint="Keywords for the video">
		<cfargument name="link" required="false" default="0" type="String" hint="url for the video">
		<cfargument name="linktext" required="false" default="0" type="String" hint="text to display for url">
		<cfargument name="subtitle" required="false" default="0" type="String" hint="subtitle of the media">
		<cfargument name="mediatypeid" required="false" default="0" type="String" hint="mediatype id, references mediatypeid from mediatype table">
		<cfargument name="summary" required="false" default="0" type="String" hint="summary, shorter version of description">
		<cfargument name="description" required="false" default="0" type="String" hint="description">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.videodsn#">
			UPDATE VIDEOLIB
			SET UPDATEDON=<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			<cfif arguments.title NEQ "0">
				,TITLE=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.status NEQ "0">
				,STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.caption NEQ "0">
				,CAPTION=<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.videopath NEQ "0">
				,VIDEOPATH=<cfqueryparam value="#arguments.videopath#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.imagepath NEQ "0">
				,IMAGEPATH=<cfqueryparam value="#arguments.imagepath#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.keywords NEQ "0">
				,KEYWORDS=<cfqueryparam value="#arguments.keywords#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.sortorder NEQ "novalue">
				,SORTORDER=<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.link NEQ "0">
				,LINK=<cfqueryparam value="#arguments.link#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.linktext NEQ "0">
				,LINKTEXT=<cfqueryparam value="#arguments.linktext#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.subtitle NEQ "0">
				,SUBTITLE=<cfqueryparam value="#arguments.subtitle#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.mediatypeid NEQ "0">
				,MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.summary NEQ "0">
				,SUMMARY=<cfqueryparam value="#arguments.summary#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.description NEQ "0">
				,DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="addViewRecord" access="public" returntype="numeric" hint="I add view record to the database">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="cfid" required="true" type="string" hint="coldfusion session id">
		<cfargument name="ipaddress" required="true" type="string" hint="IP address of the computer viewing the video">
		<cfargument name="completed" required="false" default="0" type="string" hint="1 if the video is watched completely">
		<cfargument name="nameid" required="false" default="0" type="string" hint="nameid of the person who watched the video">
		<cfset var addviewrecord = 0>
		<cfset var adduserview = 0>
		
		<cfquery name="addviewrecord" datasource="#videodsn#">
			INSERT INTO VIEWRECORD
			(
				VID,
				CFID,
				IPADDRESS,
				COMPLETED,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#cfid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#ipaddress#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#completed#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS VIEWID
		</cfquery>
		
		<cfif nameid NEQ 0>
			<cfquery name="#adduserview#" datasource="#videodsn#">
				INSERT INTO USERVIEW
				(
					VIEWID,
					NAMEID
				)
				VALUES
				(
					<cfqueryparam value="#addviewrecord.viewid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>	
		</cfif>
		<cfreturn addviewrecord.VIEWID>
	</cffunction>
	
	<cffunction name="completedView" acces="public" returntype="void" hint="I mark the viewrecord as completely watched">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="viewid" required="true" type="string" hint="Id generated when video is being watched">
		<cfset var completed=0>
		<cfquery name="completed" datasource="#videodsn#">
			UPDATE VIEWRECORD
			SET COMPLETED=1
			WHERE VIEWID=<cfqueryparam value="#viewid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="getVideos" access="public" returntype="query" hint="I get the videos from the database. Output fields: VID,TITLE, STATUS,CAPTION,LINK,LINKTEXT,KEYWORDS,VIDEOPATH,IMAGEPATH,SUBTITLE,MEDIATYPEID,SUMMARY,DESCRIPTION,SAMPLEID,SAMPLEPATH,CREATEDON,UPDATEDON,SORTORDER,LASTVIEWED">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="keyword" required="false" default="0" type="string" hint="search keyword field or all fields">
		<cfargument name="vid" required="false" type="string" hint="vid of the video" default="0">
		<cfargument name="criteria" required="false" type="string" hint="search word">
		<cfargument name="status" required="false" type="string" default="public" hint="status of the video to be looked for">
		<cfargument name="category" required="false" type="string" default="All" hint="category of videos">
		<cfargument name="videocategoryid" required="false" type="string" default="0" hint="videocategoryid of the videos">
		<cfargument name="noofvideos" required="false" type="string" default="all" hint="no of videos required">
		<cfargument name="mediatypeid" required="false" type="string" default="1" hint="Type of media, 1:Video, 2:Audio">
		<cfset var videos=0>
		<cfif status EQ "all">
			<cfset status="%">
		</cfif>
		<cfif videocategoryid EQ 0>
			<cfif category NEQ "All">
				<cfinvoke method="getcategoryid" videodsn="#videodsn#" category="#category#" returnvariable="videocategoryid">
			</cfif>
		<cfelse>
			<cfset category ="notAll">
		</cfif>
		
		<cfquery name="videos" datasource="#arguments.videodsn#">
			SELECT
				<cfif arguments.noofvideos NEQ "all">
				TOP #arguments.noofvideos#
				</cfif>
				VID,
				TITLE,
				STATUS,
				CAPTION,
				LINK,
				LINKTEXT,
				KEYWORDS,
				VIDEOPATH,
				IMAGEPATH,
				SUBTITLE,
				MEDIATYPEID,
				SUMMARY,
				DESCRIPTION,
				(SELECT TOP 1 SAMPLEID FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID DESC) AS SAMPLEID,
				(SELECT TOP 1 SAMPLEPATH FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID DESC) AS SAMPLEPATH,
				(SELECT LENGTH FROM VIDEOLENGTH WHERE VID=VIDEOLIB.VID) AS LENGTH,
				CREATEDON,
				UPDATEDON,
				<cfif videocategoryid NEQ 0>
				(SELECT SORTORDER FROM VIDEO_TO_CATEGORY WHERE VID=VIDEOLIB.VID AND VIDEOCATEGORYID=<cfqueryparam value="#videocategoryid#" cfsqltype="cf_sql_varchar">) AS SORTORDER,
				<cfelse>
				SORTORDER,
				</cfif>
				ROW_NUMBER() OVER (ORDER BY SORTORDER) AS ROW,
				(SELECT TOP 1 TIMEDATE FROM VIEWRECORD WHERE VIDEOLIB.VID=VIEWRECORD.VID ORDER BY TIMEDATE DESC)
				AS LASTVIEWED
				FROM VIDEOLIB
				WHERE STATUS LIKE <cfqueryparam value="%#arguments.status#%">
				<cfif mediatypeid EQ "12" OR mediatypeid EQ "21">
					AND MEDIATYPEID IN (1,2)
				<cfelseif mediatypeid EQ "13" OR mediatypeid EQ "31">
					AND MEDIATYPEID IN (1,3)
				<cfelseif mediatypeid EQ "23" OR mediatypeid EQ "32">
					AND MEDIATYPEID IN (2,3)
				<cfelseif mediatypeid EQ "all">
					AND MEDIATYPEID LIKE '%'
				<cfelse>
					AND MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#">
				</cfif>
				
				<cfif category NEQ "All">
				AND VID IN (SELECT VID FROM VIDEO_TO_CATEGORY WHERE VIDEOCATEGORYID = <cfqueryparam value="#videocategoryid#">)
				</cfif>
				<cfif NOT isDefined('arguments.criteria')>
					<cfif vid neq 0>
					AND VID=<cfqueryparam value="#arguments.vid#">
					</cfif>
				<cfelse>
					 AND (KEYWORDS LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
					<cfif arguments.keyword EQ "0">
						OR TITLE LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
						OR CAPTION LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
						OR LINK LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
						OR LINKTEXT LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
						OR VIDEOPATH LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">
						OR IMAGEPATH LIKE <CFQUERYPARAM VALUE="%#arguments.criteria#%">)
					<cfelse>
						)
					</cfif>
				</cfif>
				 ORDER BY SORTORDER
		</cfquery>
		<cfreturn videos>
	</cffunction> 
	
	<cffunction name="getVideoCategory" access="public" returntype="query" hint="I get categories of a video. Output fields: CATEGORY">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="mediatypeid" required="false" default="1" type="string" hint="1:Video 2: Audio 3: files">
		<cfset var getcategory=0>
		<cfquery name="getcategory" datasource="#arguments.videodsn#">
			SELECT
				VIDEO_TO_CATEGORY.VIDEOCATEGORYID, 
				VIDEOCATEGORY.CATEGORY,
				VIDEO_TO_CATEGORY.SORTORDER
			FROM VIDEO_TO_CATEGORY, VIDEOCATEGORY
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			AND VIDEO_TO_CATEGORY.VIDEOCATEGORYID=VIDEOCATEGORY.VIDEOCATEGORYID
			ORDER BY VIDEO_TO_CATEGORY.SORTORDER
			
		</cfquery>
		<cfreturn getcategory>
	</cffunction>
	
	<cffunction name="getViewRecord" access="public" returntype="query" hint="I get view record of a video">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var viewrecord=0>
		<cfquery name="viewrecord"  datasource="#videodsn#">
			SELECT
				VIEWID,
				VID,
				CFID,
				IPADDRESS,
				COMPLETED,
				TIMEDATE
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE >= <cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE <= <cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY TIMEDATE DESC
		</cfquery>
		<cfreturn viewrecord>
	</cffunction>
	
	<cffunction name="getUniqueViews" access="public" returntype="query" hint="I get view record of a video">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var uniqueviews=0>
		<cfquery name="uniqueviews"  datasource="#videodsn#">
			SELECT
				COUNT(VID) AS TOTALVIEWS,
				CFID,
				MIN(TIMEDATE),
				MAX(TIMEDATE)
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE >= <cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE <= <cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			GROUP BY CFID
		</cfquery>
		<cfreturn uniqueviews>
	</cffunction>
	
	<cffunction name="getCompletedViews" access="public" returntype="query" hint="I get view records of the video which are completed viewed">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var viewrecord=0>
		<cfquery name="viewrecord"  datasource="#videodsn#">
			SELECT
				VIEWID,
				VID,
				CFID,
				IPADDRESS,
				COMPLETED,
				TIMEDATE
			FROM VIEWRECORD 
			WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE > <cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE < <cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			AND COMPLETED=1
			ORDER BY TIMEDATE DESC
		</cfquery>
		<cfreturn viewrecord>
	</cffunction>

	<cffunction name="getViewPerDay" access="public" returntype="query" hint="I get viewrecords per day for a particular vid">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfargument name="startdate" required="false" default="0" type="string" hint="start of view date">
		<cfargument name="enddate" required="false" default="0" type="string" hint="end of view date">
		<cfset var getDays=0>
		<cfset var viewperday=0>
		<cfquery name="getDays" datasource="#videodsn#">
			SELECT LEFT(TIMEDATE,8) AS RECORDEDDATE
			FROM VIEWRECORD
			WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
			<cfif startdate NEQ "0">
			AND TIMEDATE >= <cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif enddate NEQ "0">
			AND TIMEDATE <= <cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfquery name="viewperday" dbtype="query">
			SELECT RECORDEDDATE, COUNT(RECORDEDDATE) AS TOTALVIEWS
			FROM GETDAYS
			GROUP BY RECORDEDDATE
		</cfquery>
		<cfreturn viewperday>
	</cffunction>
	
	<cffunction name="getCategory" access="public" returntype="query" hint="I get number of videos that belong to the category. Output: category, videocount, imagepath">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="criteria" required="false" type="string" default="0" hint="what you want to search the video categories for">
		<cfargument name="mediatypeid" type="String" required="false" default="1" hint="1: Video, 2: Audio, 3:Files">
		<cfargument name="excludelist" type="string" required="false" default="0" hint="list of categoryid to exclude">
		<cfset var categoryinfo=0>
		<cfquery name="categoryinfo" datasource="#videodsn#">
			SELECT 
				VC.CATEGORY,
				VC.VIDEOCATEGORYID,
				ROW_NUMBER() OVER (ORDER BY VC.SORTORDER) AS ROW,
				(
					SELECT COUNT(VTC1.VID) FROM VIDEO_TO_CATEGORY VTC1, VIDEOLIB VL1
					WHERE VTC1.VIDEOCATEGORYID=VC.VIDEOCATEGORYID
					AND VTC1.VID=VL1.VID
					AND VL1.MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#">
					AND (VL1.STATUS='Public' OR VL1.STATUS='Private')
				) AS VIDEOCOUNT,
				(
					SELECT TOP 1 IMAGEPATH FROM VIDEOLIB VL2, VIDEO_TO_CATEGORY VTC2
					WHERE VL2.MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#">
					AND VL2.VID=VTC2.VID
					AND VTC2.VIDEOCATEGORYID=VC.VIDEOCATEGORYID
					ORDER BY VTC2.SORTORDER
				) AS IMAGEPATH
			FROM VIDEOCATEGORY VC
			WHERE 1=1
			<cfif arguments.criteria neq 0>
				AND VC.CATEGORY LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.excludelist NEQ 0>
				AND VC.VIDEOCATEGORYID NOT IN(#arguments.excludelist#)
			</cfif>
			ORDER BY VC.SORTORDER
		</cfquery>
		<cfreturn categoryinfo>
	</cffunction> 

	<cffunction name="getPulbicCategory" access="public" returntype="query" hint="I get number of videos that belong to the category. Output: category, videocount, imagepath">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="criteria" required="false" type="string" default="0" hint="what you want to search the video categories for">
		<cfargument name="mediatypeid" type="String" required="false" default="1" hint="1: Video, 2: Audio, 3:Files">
		<cfargument name="excludelist" type="string" required="false" default="0" hint="list of categoryid to exclude">
		<cfset var categoryinfo=0>
		<cfquery name="categoryinfo" datasource="#videodsn#">
			SELECT 
				VC.CATEGORY,
				VC.VIDEOCATEGORYID,
				ROW_NUMBER() OVER (ORDER BY VC.SORTORDER) AS ROW,
				(
					SELECT COUNT(VTC1.VID) FROM VIDEO_TO_CATEGORY VTC1, VIDEOLIB VL1
					WHERE VTC1.VIDEOCATEGORYID=VC.VIDEOCATEGORYID
					AND VTC1.VID=VL1.VID
					AND VL1.MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#">
					AND (VL1.STATUS='Public')
				) AS VIDEOCOUNT,
				(
					SELECT TOP 1 IMAGEPATH FROM VIDEOLIB VL2, VIDEO_TO_CATEGORY VTC2
					WHERE VL2.MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#">
					AND VL2.VID=VTC2.VID
					AND VTC2.VIDEOCATEGORYID=VC.VIDEOCATEGORYID
					ORDER BY VTC2.SORTORDER
				) AS IMAGEPATH
			FROM VIDEOCATEGORY VC
			WHERE 1=1
			<cfif arguments.criteria neq 0>
				AND VC.CATEGORY LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.excludelist NEQ 0>
				AND VC.VIDEOCATEGORYID NOT IN(#arguments.excludelist#)
			</cfif>
			ORDER BY VC.SORTORDER
		</cfquery>
		<cfreturn categoryinfo>
	</cffunction> 

	<cffunction name="getAudioCategory" access="public" output="false" returntype="query" hint="I return audio categories">
		<cfargument name="videodsn" required="true" type="string" hint="I am the database name">
	 	<cfargument name="criteria" required="false" type="string" default="0" hint="what you want to search the video categories for">
	 	<cfargument name="meidaStatusList" required="false" type="string" default="Public,Private" hint="list of statuses">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT
				VIDEOCATEGORYID,
				CATEGORY,
				(
					SELECT COUNT(VID) FROM VIDEO_TO_CATEGORY VTC
					WHERE VTC.VIDEOCATEGORYID=VC.VIDEOCATEGORYID
					AND VID IN 
					(
						SELECT VID FROM VIDEOLIB 
						WHERE MEDIATYPEID=<cfqueryparam value="2"> 
						AND (
							STATUS=<cfqueryparam value="Public">
							OR STATUS=<cfqueryparam value="Private">
						)
						
					)
				) AS AUDIOCOUNT
			FROM VIDEOCATEGORY VC
			<cfif arguments.criteria neq 0>
				WHERE CATEGORY LIKE <cfqueryparam value="%#arguments.criteria#%">
			</cfif>
			ORDER BY SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="addVideoToName" access="public" returntype="void" hint="I assign video to Name">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="vid" type="string" required="true" hint="vid of a video">
		<cfargument name="nameid" type="string" required="true" hint="nameid of a person">
		<cfset var addVideoToName=0>
		<cfquery name="addVideoToName" datasource="#videodsn#">
			INSERT INTO VIDEOTOPRODUCT
			(
				NAMEID,
				VID
			)
			VALUES
			(
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">		
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addsample" access="public" returntype="void" hint="I add sample video">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="vid" type="string" required="true" hint="vid of a video">
		<cfargument name="samplepath" type="string" required="true" hint="name of the samplevideo">
		<cfargument name="sampleid" type="string" required="true" hint="sample id of the video">
		<cfset var addsample=0>
		<cfquery name="addsample" datasource="#videodsn#">
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

	<cffunction name="gettopmedia" access="public" returntype="Query" hint="I get top videos">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="noofvideos" type="string" required="false" default="3" hint="The datasource for the videos">
		<cfargument name="mediatypeid" required="false" type="string" default="1" hint="Type of media, 1:Video, 2:Audio">
		<cfset var topmedia=0>
		<cfquery name="topmedia" datasource="#videodsn#">
			SELECT
			TOP #noofvideos#
			VID,
			TITLE,
			STATUS,
			CAPTION,
			LINK,
			LINKTEXT,
			KEYWORDS,
			VIDEOPATH,
			IMAGEPATH,
			CREATEDON,
			UPDATEDON,
			SUBTITLE,
			MEDIATYPEID,
			SUMMARY,
			DESCRIPTION,
			(SELECT LENGTH FROM VIDEOLENGTH WHERE VID=VIDEOLIB.VID) AS LENGTH,
			(SELECT COUNT(VID) FROM VIEWRECORD WHERE VID=VIDEOLIB.VID) AS VIEWCOUNT,
			(SELECT TOP 1 SAMPLEID FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID) AS SAMPLEID,
			(SELECT TOP 1 SAMPLEPATH FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID) AS SAMPLEPATH
			FROM VIDEOLIB
			WHERE VID IN (SELECT SUBSCRIABLEID AS VID FROM SUBSCRIPTIONPLANS)
			AND STATUS<>'Inactive'
			<cfif mediatypeid NEQ "all">
			AND MEDIATYPEID=<cfqueryparam value="#mediatypeid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY VIEWCOUNT DESC
		</cfquery>
		<cfreturn topmedia>
	</cffunction>
	
	<cffunction name="getfreemedia" access="public" returntype="Query" hint="I get top videos">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="noofvideos" type="string" required="false" default="2" hint="The datasource for the videos">
		<cfargument name="mediatypeid" required="false" type="string" default="1" hint="Type of media, 1:Video, 2:Audio">
		<cfset var freevideos=0>
		<cfquery name="freevideos" datasource="#videodsn#">
			SELECT
			TOP #noofvideos#
			VID,
			TITLE,
			STATUS,
			CAPTION,
			LINK,
			LINKTEXT,
			KEYWORDS,
			VIDEOPATH,
			IMAGEPATH,
			CREATEDON,
			UPDATEDON,
			SUBTITLE,
			MEDIATYPEID,
			SUMMARY,
			DESCRIPTION,
			(SELECT LENGTH FROM VIDEOLENGTH WHERE VID=VIDEOLIB.VID) AS LENGTH,
			(SELECT COUNT(VID) FROM VIEWRECORD WHERE VID=VIDEOLIB.VID) AS VIEWCOUNT,
			(SELECT TOP 1 SAMPLEID FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID) AS SAMPLEID,
			(SELECT TOP 1 SAMPLEPATH FROM SAMPLEMEDIA WHERE VID=VIDEOLIB.VID ORDER BY SAMPLEID) AS SAMPLEPATH
			FROM VIDEOLIB
			WHERE VID NOT IN (SELECT SUBSCRIABLEID AS VID FROM SUBSCRIPTIONPLANS)
			AND STATUS='Public'
			AND MEDIATYPEID=<cfqueryparam value="#mediatypeid#" cfsqltype="cf_sql_varchar">
			ORDER BY NEWID()
		</cfquery>
		<cfreturn freevideos>
	</cffunction>
	
	<cffunction name="getsamples" access="public" returntype="Query" hint="I get the samples of the media">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="vid" type="string" required="true" hint="vid of a video">
		<cfset var samples=0>
		<cfquery name="samples" datasource="#arguments.videodsn#">
			SELECT 
				SAMPLEID, 
				(SELECT ITEMNAME FROM IDPOOL WHERE ID=SAMPLEMEDIA.SAMPLEID) AS SAMPLENAME, 
				SAMPLEPATH 
			FROM SAMPLEMEDIA
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			ORDER BY SAMPLEID DESC
		</cfquery>
		<cfreturn samples>	
	</cffunction>
	
	<cffunction name="updateSortOrder" output="false" returntype="void" access="public" hint="I resort the videos and the category passed to me">
		<cfargument name="videodsn" required="true" type="string" hint="The datasource for the videos">
		<cfargument name="galleryid" required="true" type="numeric" hint="I am the id of the gallery you want to resort images on">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of image ids in the order you want them sorted">
		<cfset var myNewList=0>
		<cfset var mycount=0>
		<cfset myNewList = "#txtConvert.ListDeleteDuplicatesNoCase(arguments.sortlist)#">
		<cfset mycount=10>
		<cfloop list="#myNewList#" index="VID">
			<cfquery name="deletefromgallery" datasource="#arguments.videodsn#">
			DELETE
			FROM VIDEO_TO_CATEGORY
			WHERE VID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#VID#">
			AND VIDEOCATEGORYID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.galleryid#">
			</cfquery>
			<cfquery name="qryimage2imagecat" datasource="#arguments.videodsn#">
			INSERT	INTO VIDEO_TO_CATEGORY
			(VID,
			 VIDEOCATEGORYID,
			 TIMEDATE,
			 SORTORDER)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_bigint" value="#VID#">,
			 <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.galleryid#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#timedate#">,
			 <cfqueryparam cfsqltype="cf_sql_bigint" value="#mycount#">)
			</cfquery> 
			<cfset mycount=mycount + 10>
		</cfloop>
	</cffunction>
	
	<cffunction name="updateCategorySortOrder" output="false" returntype="void" access="public" hint="I resort the video categories passed to me">
		<cfargument name="videodsn" required="true" type="string" hint="The datasource for the videos">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of image ids in the order you want them sorted">
		<cfset var myNewList=0>
		<cfset var mycount=0>
		<cfset myNewList = "#txtConvert.ListDeleteDuplicatesNoCase(arguments.sortlist)#">
		<cfset mycount=10>
		<cfloop list="#myNewList#" index="CATID">
			<cfquery name="updateCategorySort" datasource="#arguments.videodsn#">
			UPDATE VIDEOCATEGORY
			SET SORTORDER = <cfqueryparam cfsqltype="cf_sql_bigint" value="#mycount#">
			WHERE VIDEOCATEGORYID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#CATID#">
			</cfquery>
			<cfset mycount=mycount + 10>
		</cfloop>
	</cffunction>
	
	<cffunction name="getcategoryid" output="false" returntype="string" access="public" hint="I get categoryid from category">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="category" type="string" required="true" hint="category name of the video">
		<cfset var myqry=0>
		<cfquery name="myqry" datasource="#videodsn#">
			SELECT VIDEOCATEGORYID FROM VIDEOCATEGORY
			WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn myqry.VIDEOCATEGORYID>
	</cffunction>
	
	<cffunction name="getcategoryname" output="false" access="public" returntype="query" hint="I get category from videocategoryid. outputs: videocategoryid, category, noofvideos, sortorder and imagepath">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="videocategoryid" type="string" required="true" default="0" hint="videocategoryidof the video">
		<cfargument name="mediatypeid" type="String" required="false" default="1" hint="1: Video, 2: Audio, 3:Files">
		<cfargument name="status" type="string" required="false" default="Public" hint="the status of the videos in the category">
		<cfset var getcategoryname=0>
		<cfquery name="getcategoryname" datasource="#arguments.videodsn#">
			SELECT 
				VIDEOCATEGORYID,
				CATEGORY, 
				SORTORDER,
				(SELECT COUNT(VID) FROM VIDEO_TO_CATEGORY 
				WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">
				AND VID IN(SELECT VID FROM VIDEOLIB WHERE MEDIATYPEID=<cfqueryparam value="#arguments.mediatypeid#" cfsqltype="cf_sql_varchar"> AND STATUS = <cfqueryparam value="#arguments.status#">)) AS NOOFVIDEOS,
				(SELECT IMAGEPATH FROM VIDEOLIB WHERE VID IN (SELECT TOP 1 VID FROM VIDEO_TO_CATEGORY WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar"> ORDER BY NEWID())) AS IMAGEPATH
			FROM VIDEOCATEGORY 
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getcategoryname>
	</cffunction>
	
	<cffunction name="isSubscriableProduct" output="false" access="public" returntype="Numeric" hint="I find if a video is a subscriable product">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="vid" type="string" required="true" hint="vid of the video">
		<cfset var check=0>
		<cfquery name="check" datasource="#videodsn#">
			SELECT ID FROM SUBSCRIPTIONPLANS 
			WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
		</cfquery>	
		<cfif check.recordcount GT 0>
			<cfreturn "1">
		<cfelse> 
			<cfreturn "0">
		</cfif>
	</cffunction>

	<cffunction name="getVideosinCat" output="false" access="public" returntype="query">
		<cfargument name="ds" type="string" required="true">
		<cfargument name="catid" type="string" required="true">
		<cfset var myVideosinCat=0>
		<cfquery name="myVideosinCat" datasource="#arguments.ds#">
		SELECT     
		VIDEO_TO_CATEGORY.SORTORDER, 
		VIDEOCATEGORY.CATEGORY, 
		VIDEOLIB.TITLE, 
		VIDEOLIB.VID, 
		VIDEOLIB.VIDEOPATH, 
		VIDEOLIB.IMAGEPATH
		FROM         
		VIDEO_TO_CATEGORY 
		INNER JOIN
		VIDEOCATEGORY 
		ON VIDEO_TO_CATEGORY.VIDEOCATEGORYID = VIDEOCATEGORY.VIDEOCATEGORYID 
		INNER JOIN VIDEOLIB 
		ON VIDEO_TO_CATEGORY.VID = VIDEOLIB.VID
		WHERE VIDEOCATEGORY.VIDEOCATEGORYID = <cfqueryparam value="#arguments.catid#">
		ORDER BY VIDEO_TO_CATEGORY.SORTORDER
		</cfquery>
	</cffunction>

	<cffunction name="getruntime" access="public" Returntype="String" Hint="I get run time of the video">
		<cfargument name="videodsn" required="true" type="string" hint="Datasource">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfset var get=0>
		<cfquery name="get" datasource="#videodsn#">
			SELECT LENGTH FROM VIDEOLENGTH WHERE VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.LENGTH>
		<cfelse> 
			<cfreturn "0">
		</cfif>
	</cffunction>
	 
	<cffunction name="getvideocategoryid" access="public" returntype="Query" hint="I videocategorids a video belongs to. output: VID">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="vid" required="true" type="string" hint="vid of the video">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT VIDEOCATEGORYID FROM VIDEO_TO_CATEGORY
			WHERE VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			ORDER BY NEWID();
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="lastupdatedCategory" access="public" returntype="Query" hint="I get last updated video category">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfset var getVideo=0>
		<cfset var get=0>
		<cfquery name="getVideo" datasource="#arguments.videodsn#">
			SELECT TOP 1 VID FROM VIDEOLIB ORDER BY VID DESC
		</cfquery>
		<cfquery name="get" datasource="#arguments.videodsn#">
			SELECT TOP 1
				VIDEO_TO_CATEGORY.VIDEOCATEGORYID,
				VIDEO_TO_CATEGORY.TIMEDATE,
				VIDEOCATEGORY.CATEGORY
			FROM VIDEO_TO_CATEGORY, VIDEOCATEGORY
			WHERE VIDEO_TO_CATEGORY.VIDEOCATEGORYID=VIDEOCATEGORY.VIDEOCATEGORYID
			ORDER BY VIDEO_TO_CATEGORY.TIMEDATE DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="SSPXmlBuild" output="false" returntype="xml" access="public" hint="I build the xml for the videodsn passed to me.">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfargument name="galleryid" type="string" required="true" hint="the id of the gallery you want">
		<cfset var ssp_xml=0>
		<cfset qryvideos=getVideos(arguments.videodsn,arguments.galleryid)>
		<cfoutput>
			<cfsavecontent variable="ssp_xml"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>			
				<gallery>
					<album id="#arguments.galleryid#" lgPath="http://#arguments.videodsn#/videos/" tnPath="http://#arguments.videodsn#/images/small/" videocount="#qryvideos.recordcount#" >
					<cfloop query="qryvideos">
						<img src="#VIDEOPATH#" tn="#imagepath#" vidpreview="http://#arguments.videodsn#/images/large/#imagepath#" id="#vid#" title="#title#" />
					</cfloop>
					</album>
				</gallery>
			</cfsavecontent>
		</cfoutput>
		<cfreturn ssp_xml>
	</cffunction>

	<cffunction name="XmlBuild" output="false" returntype="void" access="public" hint="I build the xml for the videodsn passed to me.">
		<cfargument name="videodsn" type="string" required="true" hint="The datasource for the videos">
		<cfset qryvideos=getVideos(arguments.videodsn)>
		<cfset mysitepath = "/home/drew/domains/#videodsn#/public_html/videos/">
		<cfsavecontent variable="xml_map"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>
			<VideoLibrary>
				<cfoutput query="qryvideos">
					<Video> 
					<videopath>=#videopath#</videopath> 
					<vid>#vid#</vid> 
					<title>#XMLFormat(title)#</title> 
					<status>#status#</status>
					<caption>#XMLFormat(CAPTION)#</caption> 
					<link>#link#</link> 
					<linktext>#linktext#</linktext> 
					<keywords>#keywords#</keywords>
					<imagepath>#imagepath#</imagepath>
					<subtitle>#subtitle#</subtitle>
					<mediatypeid>#mediatypeid#</subtitle>
					<summary>#summary#</summary>
					<description>description</description>
					<createdon>#createdon#</createdon>
					<updatedon>#updatedon#</updatedon> 
					<sortorder>#sortorder#</sortorder>
					<cfset categories=getVideoCategory(arguments.videodsn,vid)>
					<cfloop query="categories">
					<videocategoryid>#videocategoryid#</videocategoryid>
					<category>#category#</category>
					</cfloop>
					</Video>
				</cfoutput>
			</VideoLibrary>
		</cfsavecontent>
		<cfoutput>
			<cffile action="write" mode="775" addnewline="no" file="#mysitepath#xml_map.xml" output="#xml_map#">
		</cfoutput>
	</cffunction>
</cfcomponent>