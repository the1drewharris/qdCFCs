<cfcomponent hint="image gallery functions">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions" name="txtConvert">
	<cfobject component="qdDataMgr" name="tblCheck">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cfset thumbdirlist="tiny,small,large,detail,qdcms">
	<cfset mybasepath="/home/drew/domains">
	<cfinclude template="StripAllBut.cfm">
	<cffunction name="init" access="public" returntype="void" hint="I run create table scripts">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke method="createtables" argumentcollection="#arguments#">
	</cffunction>
	
	<cffunction name="createtables" access="private" returntype="void" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		
		<cfset var image=0>
		<cfset var imagecategory=0>
		<cfset var image2imagecategory=0>
		<cfset var addlogoid=0>
		<cfif not tblCheck.tableExists('#arguments.ds#', 'image')>
			<cfquery name="imagetable" datasource="#arguments.ds#">
				CREATE TABLE IMAGE
				(
					IMAGEID BIGINT NOT NULL IDENTITY,
					IMAGEPATH VARCHAR(128),
					ALT VARCHAR(256),
					ALIGN VARCHAR(32),
					HSPACE DECIMAL(18),
					VSPACE DECIMAL(18),
					HEIGHT DECIMAL(18),
					WIDTH DECIMAL(18),
					TITLE VARCHAR(256),
					IMAGENAME VARCHAR(256),
					IMAGECLASS VARCHAR(64),
					VERSIONID VARCHAR(16),			
					CREATEDBYID VARCHAR(16),
					VERSIONDESCRIPTION VARCHAR (128),
					CAPTION NTEXT,
					STATUS VARCHAR(16),
					SITEID VARCHAR(50),
					SORTORDER BIGINT,
					FLASHGALLERY VARCHAR(1),
					LINK VARCHAR(256)
				)
				ALTER TABLE IMAGE ADD CONSTRAINT PK_IMAGE PRIMARY KEY(IMAGEID);
				<!--- ALTER TABLE IMAGE ADD CONSTRAINT FK_IMAGE_NAME FOREIGN KEY(CREATEDBYID) REFERENCES NAME(NAMEID); --->
			</cfquery>
		</cfif>
		<cfif not tblCheck.tableExists('#arguments.ds#', 'imagecategory')>
			<cfquery name="imagecategory" datasource="#arguments.ds#">
				CREATE TABLE IMAGECATEGORY
				(
					IMAGECATEGORYID BIGINT NOT NULL IDENTITY,
					IMAGECATEGORY VARCHAR(128) NOT NULL,
					DESCRIPTION NTEXT,
					STATUS VARCHAR(32),
					VERSIONID VARCHAR(16) NOT NULL,
					CREATEDBYID VARCHAR(16) NOT NULL,
					VERSIONDESCRIPTION VARCHAR(128),
					SORTORDER INT,
					SITEID VARCHAR(16),
					FLASHGALLERY VARCHAR(1),
					PARENTIMAGECATEGORYID BIGINT NOT NULL
				)
				ALTER TABLE IMAGECATEGORY ADD CONSTRAINT PK_IMAGECATEGORY PRIMARY KEY (IMAGECATEGORYID);
				<!--- ALTER TABLE IMAGECATEGORY ADD CONSTRAINT FK_IMAGECATEGORY_NAME FOREIGN KEY (CREATEDBYID) REFERENCES NAME (NAMEID); --->
			</cfquery>
		</cfif>
		<cfif not tblCheck.tableExists('#arguments.ds#', 'image2imagecategory')>
			<cfquery name="image2imagecategory" datasource="#arguments.ds#">
				CREATE TABLE IMAGE2IMAGECATEGORY
				(
					IMAGEID BIGINT NOT NULL,
					IMAGECATEGORYID BIGINT NOT NULL,
					SORTORDER BIGINT
				)
				ALTER TABLE IMAGE2IMAGECATEGORY ADD CONSTRAINT FK_IMAGE2IMAGECATEGORY_IMAGE FOREIGN KEY(IMAGEID) REFERENCES IMAGE(IMAGEID);
				ALTER TABLE IMAGE2IMAGECATEGORY ADD CONSTRAINT FK_IMAGE2IMAGECATEGORY_IMAGECATEGORY FOREIGN KEY(IMAGECATEGORYID) REFERENCES IMAGECATEGORY(IMAGECATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.ds#', 'NAME', 'LOGOID')>
			<cfquery name="addlogoid" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LOGOID BIGINT
				ALTER TABLE NAME ADD CONSTRAINT FK_NAME_IMAGE FOREIGN KEY(LOGOID) REFERENCES IMAGE(IMAGEID);
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getImagePath" access="public" returntype="string" hint="I create imagepath">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the image">
		<cfargument name="imageid" type="numeric" required="true" hint="Id of the iamge">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.imagedsn#">
			SELECT IMAGEPATH FROM IMAGE
			WHERE IMAGEID=<cfqueryparam value="#arguments.imageid#">
		</cfquery>
		<cfreturn get.IMAGEPATH>
	</cffunction>
	
	<cffunction name="renamefile" access="public" output="false" returntype="string" hint="I rename a file as per qdcms standard">
		<cfargument name="destFolder" required="true" type="string" hint="Absolute path of destination folder">
		<cfargument name="filename" required="true" type="string" hint="name of the file">
		<cfargument name="fileExtension" required="true" type="string" hint="file extension">
		<cfset var newfilename=0>
		<cfset var timenow="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfset var a=0>
		<cfset var i=0>
		<cfset var fileNameIsUnique=FALSE>
		<cfloop condition="fileNameIsUnique EQ FALSE">
			<cfset newfilename="">
			<cfloop index="i" from="1" to="16">
			    <cfset a = randrange(48,122)>
			    <cfif (a GT 57 AND a LT 65) or (a GT 90 AND a LT 97)>
			        <cfset newfilename=newfilename & "i">
			    <cfelse>
			        <cfset newfilename=newfilename & chr(a)>
			    </cfif>
			</cfloop>
			<cfset newfilename=newfilename & timenow & ".#arguments.fileExtension#">
			<cfif NOT fileExists('#arguments.destFolder#/#newfilename#')>
				<cffile action="rename" source="#arguments.destFolder#/#arguments.filename#" destination="#arguments.destFolder#/#newfilename#">
				<cfset fileNameIsUnique=TRUE>
			</cfif>
		</cfloop>
		<cfreturn newfilename>
	</cffunction>
	
	<cffunction name="createRandomName" access="public" returntype="String" Hint="I generate a random username">
		<cfset var name=''>
		<cfset var a=0>
		<cfset var i=0>
		<cfset var timenow="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfloop index="i" from="1" to="16">
		    <cfset a = randrange(48,122)>
		    <cfif (a GT 57 AND a LT 65) or (a GT 90 AND a LT 97)>
		        <cfset name=name & "i">
		    <cfelse>
		        <cfset name=name & chr(a)>
		    </cfif>
		</cfloop>
		<cfset name=name & timenow>
		<cfreturn name>
	</cffunction>
	
	<cffunction name="approveimages" access="public" returntype="void" hint="Approve images">
		<cfargument name="imagedsn" required="true" type="string" hint="database name">
		<cfargument name="imagelist" required="true" type="string" hint="list of images">
		<cfset var approve=0>
		<cfquery name="approve" datasource="#arguments.imagedsn#">
			UPDATE IMAGE
			SET STATUS=<cfqueryparam value="Active">
			WHERE IMAGEID IN (#arguments.imagelist#);
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="deletePendingImages" access="public" returntype="void" hint="delete 1 or more images">
		<cfargument name="imagedsn" required="true" type="string" hint="database name">
		<cfargument name="imagelist" required="true" type="string" hint="list of images">
		<cfargument name="sitepath" required="true" type="string" hint="path of the site so that images can be deleted physically">
		<cfargument name="thumbdirlist" required="true" type="string" hint="list of thumb directories">
		<cfset var get=0>
		<cfset var delete=0>
		<cfset var deletecat=0>
		<cfquery name="get" datasource="#arguments.imagedsn#">
			SELECT IMAGEPATH FROM IMAGE WHERE IMAGEID IN (#arguments.imagelist#)
		</cfquery>
		<cfquery name="deletecat" datasource="#arguments.imagedsn#">
			DELETE FROM IMAGE2IMAGECATEGORY WHERE IMAGEID IN (#arguments.imagelist#)
		</cfquery>	
		<cfquery name="delete" datasource="#arguments.imagedsn#">
			DELETE FROM IMAGE WHERE IMAGEID IN (#arguments.imagelist#)
		</cfquery>
		<cfloop query="get">
			<cfif fileExists('#arguments.sitepath#/images/#imagepath#')>
				<cffile action="delete" file="#arguments.sitepath#/images/#imagepath#">
				<cfloop list="#arguments.thumbdirlist#" index="thumbdir">
					<cfif fileExists('#arguments.sitepath#/images/#thumbdir#/#imagepath#')>
						<cffile action="delete" file="#arguments.sitepath#/images/#thumbdir#/#imagepath#">
					</cfif> 
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getPendingImages" output="false" returntype="query" access="public" hint="I get all the information for an imageid passed to me, I return a recordset (IMAGEID, CAPTION,IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT,WIDTH, TITLE,STATUS,IMAGENAME,IMAGECLASS,SORTORDER,FLASHGALLERY,LINK,CREATEDBYID,VERSIONID, VERSIONDESCRIPTION)">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the image">
		<cfset var pendingimages=0>
		<cfquery name="pendingimages" datasource="#imagedsn#">
			SELECT     
				IMAGEID, 
				CAPTION,
				IMAGEPATH, 
				TITLE, 
				STATUS,
				CREATEDBYID
			FROM         
				IMAGE 
			WHERE STATUS=<cfqueryparam value="Pending">
			OR STATUS=<cfqueryparam value="Non-Active">
		</cfquery>
		<cfreturn pendingimages>		
	</cffunction>
	
	<cffunction name="getImageStatus" access="public" returntype="string" hint="I get status of an image">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imageid" type="string" required="true" hint="id for the person making this update">
		<cfset var get=0>
		<cfquery name="get" datasource="#client.siteurl#">
			SELECT STATUS FROM IMAGE
			WHERE IMAGEID=<cfqueryparam value="#arguments.imageid#">
		</cfquery>
		<cfreturn get.STATUS>
	</cffunction>
	
	<cffunction name="getQuickGalleriesInfo" access="public" output="false" returntype="query" hint="I return GALLERYID,GALLERYNAME">
		<cfargument name="imagedsn" required="true" type="string" hint="database name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.imagedsn#">
			SELECT
				IMAGECATEGORYID,
				IMAGECATEGORY
			FROM IMAGECATEGORY
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="dirCheckCreate" output="false" returntype="boolean" access="public" hint="I check to see if a directory exists if it does not, I create it, I return 'yes' if it exsited, I return 'created' if I created it.">
		<cfargument name="myDir" type="string" required="true" hint="the dir you want to check and create (full path)">
		<!--- Checks to make sure the images path actually exists for website --->
		<cfif not DirectoryExists(#arguments.myDir#)>
			<!--- If not then create the directory --->
			<cfdirectory action = "create" directory = "#arguments.myDir#" mode="775">
			<cfset theDirThere = 1>
		<cfelse>
			<cfset theDirThere = 0>
		</cfif>
		<cfreturn theDirThere>
	</cffunction>
	
	<cffunction name="uploadImage" output="false" returntype="struct" access="public" hint="I upload the image sent to me.  I return a structure called myImage.">
		<cfargument name="path" type="string" required="true" hint="The full path to where the image should be uploaded">
		<cfargument name="fileField" optional="False" hint="The filefield used for cffile upload to work properly"/>	
		<cfargument name="allowedExtenstions" required="false" default="jpg,png,gif,jpeg">
		<cfset var newimagename=0>
		<cfset var fileNameIsUnique=FALSE>
		<cfset var myimage=structNew()>
		<cfset myImage.error=0>
		<cfset myImage.name=''>
		<cfset dirCheckCreate(arguments.path)>
		<cffile action="upload" filefield="#arguments.fileField#" destination="#arguments.path#" mode="775" result="myNewImage" nameconflict="rename">
		<cfif myNewImage.fileWasSaved EQ "No">
			<cfset myImage.error=1>		
		<cfelse>
			<cfset ext=lcase(listlast(myNewImage.serverfile,"."))>
			<cfloop condition="fileNameIsUnique EQ FALSE">
				<cfset newimagename=createRandomName() & "." & ext>
				<cfif NOT FileExists("#arguments.path#/#newimagename#")>
					<cfset fileNameIsUnique=TRUE>
				</cfif>
			</cfloop>
			<cffile action="rename" source="#arguments.path#/#myNewImage.serverfile#" destination="#arguments.path#/#newimagename#">
		</cfif>
		<cfset myimage.name=newimagename>
		<cfreturn myimage>
	</cffunction>
	
	<cffunction name="createImageThumb" output="no" returntype="string" hint="Creates a thumbnail of a master image and return the full path and name of that image">
       	<cfargument name="masterimage" type="string" required="true" hint="The name of the master image">
       	<cfargument name="masterpath" type="string" required="true" hint="The path to the master image that needs to be copied">
       	<cfargument name="thumbdir" type="string" required="true" hint="the path the thumbnail should be created in">
       	<cfargument name="imagesize" type="string" required="false" hint="The maximum size (width or height) of the thumbnail." default="200">
      	<cfargument name="imagewidth" type="string" required="false" hint="The maximum width of the thumbnail." default="0">
       	<cfargument name="imageheight" type="string" required="false" hint="The maximum height of the thumbnail." default="0">
    	<cfset var sourceImg=0>
		<cfset var newThumb=0> 
		<cfset sourceImg = "#arguments.masterpath##arguments.masterimage#">
		<cfset dirCheckCreate(arguments.masterpath)>
		<cfset dirCheckCreate(arguments.thumbdir)>
      	<cfimage action="read" source="#sourceImg#" name="img">
      	<cfif arguments.imageheight EQ 0><cfset arguments.imageheight = arguments.imagesize></cfif>
      	<cfif arguments.imagewidth EQ 0><cfset arguments.imagewidth = arguments.imagesize></cfif>

       	<cfif ImageGetWidth(img) GTE arguments.imagewidth AND ImageGetHeight(img) GTE arguments.imageheight>
			<cfset ImageScaleToFit(img,arguments.imagewidth,arguments.imageheight,'mediumquality')>
		<cfelseif ImageGetWidth(img) GTE (arguments.imagewidth * 2)>
			<cfset ImageResize(img,arguments.imagewidth,'')>
		<cfelseif ImageGetHeight(img) GTE (arguments.imageheight * 2)>
			<cfset ImageResize(img,'',arguments.imageheight)>
		</cfif>
        <cfimage action="write" destination="#arguments.thumbdir##arguments.masterimage#" source="#img#" overwrite="yes" quality="1.0">
		<cfset newThumb="#arguments.thumbdir##arguments.masterimage#">
		<cfreturn newThumb>
   </cffunction>
	
	<cffunction name="rotateThisImage" output="false" returntype="string" access="public" hint="I rotate all of the images for the imageid passed to me">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the image">
		<cfargument name="imageid" type="numeric" required="true" hint="Id of the iamge you want to rotate">
		<cfargument name="angle" type="numeric" default="90" hint="the angle of the rotation you want">
		<cfargument name="sitepath" type="string" required="true" hint="the sitepath you want to use to rotate the image">
		<cfset mybaseimagepath="#arguments.sitepath#/images">
		<cfquery name="myImage" datasource="#imagedsn#">
			SELECT IMAGEPATH FROM IMAGE
			WHERE IMAGEID=<cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">
		</cfquery>
		<cfif myImage.recordcount eq 1>
			<cfif NOT fileExists('#mybaseimagepath#/#myImage.IMAGEPATH#')>
				<cfif fileExists('#mybaseimagepath#/detail/#myImage.IMAGEPATH#')>
					<cffile action="copy" source="#mybaseimagepath#/detail/#myImage.IMAGEPATH#" destination="#mybaseimagepath#">
				</cfif>
			</cfif>
			<cfimage action="rotate" 
					 angle="#angle#" 
					 source="#mybaseimagepath#/#myImage.IMAGEPATH#" 
					 Destination="#mybaseimagepath#/#myImage.IMAGEPATH#"
					 overwrite="yes">
			<cfloop list="#thumbdirlist#" index="currentpath">
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/#currentpath#/#myImage.IMAGEPATH#" 
						 Destination="#mybaseimagepath#/#currentpath#/#myImage.IMAGEPATH#"
						 overwrite="yes">
			</cfloop>
			<!--- binod@quantumdelta.com 20090810 --->
			<cfif fileExists("#mybaseimagepath#/temp/reflection/#myImage.imagepath#")>
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/temp/reflection/#myImage.imagepath#" 
						 destination="#mybaseimagepath#/temp/reflection/#myImage.imagepath#" 
						 overwrite="yes"> 
			</cfif>
			<cfif fileExists("#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#")>
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#" 
						 destination="#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#" 
						 overwrite="yes"> 
			</cfif>
			<cfset myPath=myImage.imagepath>
		<cfelse>
			<cfset myPath=0>
		</cfif>
		<cfreturn myPath>
	</cffunction>
	
	<cffunction name="rotateImage" output="false" returntype="string" access="public" hint="I rotate all of the images for the imageid passed to me">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the image">
		<cfargument name="imageid" type="numeric" required="true" hint="Id of the iamge you want to rotate">
		<cfargument name="angle" type="numeric" default="90" hint="the angle of the rotation you want">
		<cfargument name="sitepath" type="string" required="false" default="0" hint="the sitepath you want to use to rotate the image">
		<cfif arguments.sitepath eq 0>
			<cfset mybaseimagepath="#mybasepath#/#imagedsn#/public_html/images">
		<cfelse>
			<cfset mybaseimagepath="#mybasepath#/#arguments.sitepath#/images">
		</cfif>
		<cfquery name="myImage" datasource="#imagedsn#">
		SELECT
			IMAGEPATH
		FROM 
			IMAGE
		WHERE
			IMAGEID=<cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">
		</cfquery>
		<cfif myImage.recordcount eq 1>
			<cfimage action="rotate" 
					 angle="#angle#" 
					 source="#mybaseimagepath#/#myImage.IMAGEPATH#" 
					 Destination="#mybaseimagepath#/#myImage.IMAGEPATH#"
					 overwrite="yes">
			<cfloop list="#thumbdirlist#" index="currentpath">
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/#currentpath#/#myImage.IMAGEPATH#" 
						 Destination="#mybaseimagepath#/#currentpath#/#myImage.IMAGEPATH#"
						 overwrite="yes">
			</cfloop>
			<!--- binod@quantumdelta.com 20090810 --->
			<cfif fileExists("#mybaseimagepath#/temp/reflection/#myImage.imagepath#")>
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/temp/reflection/#myImage.imagepath#" 
						 destination="#mybaseimagepath#/temp/reflection/#myImage.imagepath#" 
						 overwrite="yes"> 
			</cfif>
			<cfif fileExists("#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#")>
				<cfimage action="rotate" 
						 angle="#angle#" 
						 source="#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#" 
						 destination="#mybaseimagepath#/temp/rounded_corners/#myImage.imagepath#" 
						 overwrite="yes"> 
			</cfif>
			<cfset myPath=myImage.imagepath>
		<cfelse>
			<cfset myPath=0>
		</cfif>
		<cfreturn myPath >
	</cffunction>
	
	<cffunction name="getImage" output="false" returntype="query" access="public" hint="I get all the information for an imageid passed to me, I return a recordset (IMAGEID, CAPTION,IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT,WIDTH, TITLE,STATUS,IMAGENAME,IMAGECLASS,SORTORDER,FLASHGALLERY,LINK,CREATEDBYID,VERSIONID, VERSIONDESCRIPTION)">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the image">
		<cfargument name="imageid" type="numeric" required="false" default="0" hint="Id of the image you are looking for information on">
		<cfargument name="imagepath" type="string" required="false" default="0" hint="imagepath of the image you want to get">
		<cfquery name="myImage" datasource="#imagedsn#">
		SELECT     
			IMAGEID, 
			CAPTION,
			IMAGEPATH, 
			ALT, 
			ALIGN, 
			HSPACE, 
			VSPACE, 
			HEIGHT, 
			WIDTH, 
			TITLE, 
			STATUS,
			IMAGENAME, 
			IMAGECLASS,
			SORTORDER,
			FLASHGALLERY,
			LINK,
			CREATEDBYID,
			VERSIONID, 
			VERSIONDESCRIPTION
		FROM         
			IMAGE 
		WHERE 1=1
		<cfif imageid NEQ 0>AND IMAGEID = '#IMAGEID#'</cfif>
		<cfif imagepath NEQ 0>AND IMAGEPATH = '#IMAGEPATH#'</cfif>
		</cfquery>
		<cfreturn myImage>		
	</cffunction>
	
	<cffunction name="searchImages" output="false" returntype="query" access="public" hint="I get the images for the gallery passed to me, I return a recordset, (IMAGEID, CAPTION, IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT, WIDTH, TITLE, IMAGENAME, IMAGECLASS, SORTORDER, FLASHGALLERY, LINK, CREATEDBYID, VERSIONID, VERSIONDESCRIPTION, IMAGECATEGORY, IMAGECATEGORYID, PARENTIMAGECATEGORYID, DESCRIPTION, STATUS)">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="Numeric" Default="0" required="false" hint="ID of the gallery you want images from">
		<cfargument name="criteria" type="string" required="false" default="0" hint="I am the criteria you are searching for, I search on imagepath, name, title, caption.  If you do not pass me in I default to zero and return all images">
		<cfargument name="showinflashgallery" type="string" required="false" hint="Images to display in flash gallery (y or n)">	
		<cfargument name="status" type="string" required="false" default="0">
		<cfargument name="sortimages" type="string" required="false" hint="I let the person calling me provide me with a list of how they want thier images sorted">
		<cfquery name="myGalleryImages" datasource="#imagedsn#">
		SELECT     
			IMAGE.IMAGEID, 
			IMAGE.IMAGEPATH, 
			IMAGE.TITLE, 
			IMAGE.IMAGENAME, 
			IMAGE.CREATEDBYID,
			IMAGECATEGORY.IMAGECATEGORYID,
			IMAGE.STATUS,
			IMAGE.ALT
		FROM
			IMAGE,
			IMAGECATEGORY,
			IMAGE2IMAGECATEGORY
		WHERE
			IMAGE.IMAGEID = IMAGE2IMAGECATEGORY.IMAGEID
		AND (IMAGE.IMAGEPATH LIKE '%.jpg'
		OR IMAGE.IMAGEPATH LIKE '%.jpeg'
		OR IMAGE.IMAGEPATH LIKE '%.PNG'
		OR IMAGE.IMAGEPATH LIKE '%.GIF')
		AND IMAGECATEGORY.IMAGECATEGORYID = IMAGE2IMAGECATEGORY.IMAGECATEGORYID	
		<cfif galleryid neq 0>AND IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#galleryid#"></cfif>
		<cfif status NEQ "0">AND IMAGE.STATUS = <cfqueryparam value="#status#"></cfif>
		<cfif isdefined('showinflashgallery')>AND IMAGE.FLASHGALLERY = <cfqueryparam value="#showinflashgallery#"></cfif>
		<cfif criteria neq 0>AND (IMAGE.IMAGEPATH LIKE '%#CRITERIA#%'
		OR IMAGE.IMAGENAME LIKE '%#CRITERIA#%'
		OR IMAGE.CAPTION LIKE '%#CRITERIA#%'
		OR IMAGE.TITLE LIKE '%#CRITERIA#%'
		OR IMAGE.ALT LIKE '%#CRITERIA#%')
		</cfif>
		<cfif galleryid EQ 0>
			GROUP BY IMAGE.IMAGEID, IMAGE2IMAGECATEGORY.SORTORDER, IMAGE.IMAGEPATH, IMAGE.TITLE, IMAGE.IMAGENAME, IMAGE.CREATEDBYID, IMAGECATEGORY.IMAGECATEGORYID, IMAGE.STATUS, IMAGE.ALT
		</cfif>
		<cfif isdefined('sortimages')>
		order by #sortimages#
		<cfelse>
		order by imagecategory.imagecategoryid, IMAGE2IMAGECATEGORY.sortorder
		</cfif>

		</cfquery>
		<cfreturn myGalleryImages>
	</cffunction>
	
	<cffunction name="getGalleryImages" output="false" returntype="query" access="public" hint="I get the images that match the criteria passed to me, I return a recordset, (IMAGEID, CAPTION, IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT, WIDTH, TITLE, IMAGENAME, IMAGECLASS, SORTORDER, FLASHGALLERY, LINK, CREATEDBYID, VERSIONID, VERSIONDESCRIPTION, IMAGECATEGORY, IMAGECATEGORYID, PARENTIMAGECATEGORYID, DESCRIPTION, STATUS)">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="Numeric" required="false" hint="ID of the gallery you want images from">
		<cfargument name="albumName" type="string" required="false" hint="the name of the album you want">
		<cfargument name="showinflashgallery" type="string" required="false" hint="Images to display in flash gallery (y or n)">	
		<cfargument name="status" type="string" required="false">
		<cfargument name="excludeList" type="string" required="false" hint="an optional list of image ids you want to exclude">
		<cfargument name="sortimages" type="string" required="false" hint="I let the person calling me provide me with a list of how they want thier images sorted">
		<cfargument name="noofimages" type="string" required="false" default="0" hint="Max number of images to return">
		<cfquery name="myGalleryImages" datasource="#imagedsn#">
		SELECT     
			<cfif arguments.noofimages NEQ "0">
			TOP #arguments.noofimages#
			</cfif>
			IMAGE.IMAGEID, 
			IMAGE.CAPTION,
			IMAGE.IMAGEPATH, 
			IMAGE.ALT, 
			IMAGE.ALIGN, 
			IMAGE.HSPACE, 
			IMAGE.VSPACE, 
			IMAGE.HEIGHT, 
			IMAGE.WIDTH, 
			IMAGE.TITLE, 
			IMAGE.IMAGENAME, 
			IMAGE.IMAGECLASS,
			IMAGE.SORTORDER,
			IMAGE.FLASHGALLERY,
			IMAGE.LINK,
			IMAGE.CREATEDBYID,
			IMAGE.VERSIONID, 
			IMAGE.VERSIONDESCRIPTION,
			IMAGECATEGORY.IMAGECATEGORY,
			IMAGECATEGORY.IMAGECATEGORYID,
			IMAGECATEGORY.PARENTIMAGECATEGORYID,
			IMAGECATEGORY.DESCRIPTION,
			IMAGE.STATUS,
			IMAGECATEGORY.STATUS AS IMAGECATEGORYSTATUS,
			IMAGE2IMAGECATEGORY.SORTORDER,
			<cfif isDefined('arguments.sortimages')>
				ROW_NUMBER() OVER (ORDER BY #arguments.sortimages#) AS ROW
			<cfelse>
				ROW_NUMBER() OVER (ORDER BY IMAGECATEGORY.IMAGECATEGORYID, IMAGE2IMAGECATEGORY.SORTORDER) AS ROW
			</cfif>
		FROM
			IMAGE,
			IMAGECATEGORY,
			IMAGE2IMAGECATEGORY
		WHERE
			IMAGE.IMAGEID = IMAGE2IMAGECATEGORY.IMAGEID
		AND (IMAGE.IMAGEPATH LIKE '%.jpg'
		OR IMAGE.IMAGEPATH LIKE '%.jpeg'
		OR IMAGE.IMAGEPATH LIKE '%.PNG'
		OR IMAGE.IMAGEPATH LIKE '%.GIF')
		AND IMAGECATEGORY.IMAGECATEGORYID = IMAGE2IMAGECATEGORY.IMAGECATEGORYID	
		<cfif isdefined('arguments.excludeList')>AND IMAGEID NOT IN (#arguments.excludeList#)</cfif>
		<cfif isDefined('arguments.galleryid')>AND IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#arguments.galleryid#"></cfif>
		<cfif isDefined('arguments.albumName')>AND IMAGECATEGORY.IMAGECATEGORY = <cfqueryparam value="#arguments.albumName#"></cfif>
		<cfif isdefined('arguments.status')>AND IMAGE.STATUS = <cfqueryparam value="#arguments.status#"></cfif>
		<cfif isdefined('arguments.showinflashgallery')>AND IMAGE.FLASHGALLERY = <cfqueryparam value="#arguments.showinflashgallery#"></cfif>
		<cfif isdefined('arguments.sortimages')>
		order by #arguments.sortimages#
		<cfelse>
		order by imagecategory.imagecategoryid, IMAGE2IMAGECATEGORY.sortorder
		</cfif>
		</cfquery>
		<cfreturn myGalleryImages>
	</cffunction>
	
	<cffunction name="getHeaderImage" output="false" returntype="string" access="public" hint="I get the header image">
		<cfargument name="ds"  required="true" type="string" hint="name of the database">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT IMAGEPATH 
			FROM IMAGE
			WHERE IMAGEID IN (SELECT TOP 1 IMAGEID FROM IMAGE2IMAGECATEGORY WHERE IMAGECATEGORYID=(SELECT TOP 1 IMAGECATEGORYID FROM IMAGECATEGORY WHERE IMAGECATEGORY='header_images'))
		</cfquery>
		<cfreturn get.IMAGEPATH>
	</cffunction>
	
	<cffunction name="getGalleryInfo" output="false" returntype="query" access="public" hint="I get the information for the galleryid passed to me, I return a query (IMAGECATEGORYID, SORTORDER, IMAGECATEGORY, DESCRIPTION, PARENTIMAGECATEGORYID, STATUS, VERSIONID)">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="Numeric" required="false" default="0" hint="ID of the gallery you want images from">
		<cfargument name="albumname" type="string" required="false" default="0" hint="I am the name of the album">
		<cfquery name="myGalleryInfo" datasource="#imagedsn#">
		SELECT   
			IMAGECATEGORYID,  
			SORTORDER,
			IMAGECATEGORY, 
			DESCRIPTION, 
			PARENTIMAGECATEGORYID, 
			STATUS, 
			VERSIONID
		FROM         
			IMAGECATEGORY
		WHERE 1=1
		<cfif arguments.galleryid neq 0>AND IMAGECATEGORYID = <cfqueryparam value="#arguments.galleryid#"></cfif>
		<cfif arguments.albumname neq 0>AND IMAGECATEGORY LIKE <cfqueryparam value="#arguments.albumname#"></cfif>
		</cfquery>
		<cfreturn myGalleryInfo>
	</cffunction>
	
	<cffunction name="findGallery" output="false" returntype="query" access="public" hint="I get the information for the galleryname passed to me, I Return a query recordset (galleryid, sortorder, galleryname, description, parentgalleryid, status, versionid)">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryname" type="string" required="true" hint="the name of the gallery I am searching for">
		<cfargument name="findCriteria" type="string" required="false" default="exact" hint="I am the criteria in which a gallery is searched for, I need 'like' or 'exact', if you don't pass a value to me a default to 'exact'">
		<cfquery name="myGalleryInfo" datasource="#imagedsn#">
		SELECT   
			IMAGECATEGORYID as GALLERYID,  
			SORTORDER,
			IMAGECATEGORY as GALLERYNAME, 
			DESCRIPTION, 
			PARENTIMAGECATEGORYID as PARENTGALLERYID, 
			STATUS, 
			VERSIONID
		FROM         
			IMAGECATEGORY
		WHERE IMAGECATEGORY <cfif findCriteria eq "like">like<cfelse>=</cfif> '#galleryname#'
		</cfquery>
		<cfreturn myGalleryInfo>
	</cffunction>
	
	<cffunction name="addImage" output="false" returntype="string" access="public" hint="I add the image passed to me to the database and I return the id for the image I just added.">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imagename" type="string" required="true" >
		<cfargument name="imagetitle" type="string" required="false" default="">		 
		<cfargument name="imagealt" type="string" required="false" default="">
		<cfargument name="imagealign" type="string" required="false" default="top" >
		<cfargument name="imagevspace" type="string" required="false" default="5" >
		<cfargument name="imagehspace" type="string" required="false" default="5" >
		<cfargument name="sortorder" type="numeric" required="false" default="0" >
		<cfargument name="addtoflash" type="string" required="false" default="y" >
		<cfargument name="caption" type="string" required="false" default="">
		<cfargument name="link" type="string" required="false" default="">
		<cfargument name="status" type="string" required="false" default="Active">
		<cfargument name="userid" type="numeric" required="false" default="0">
		<cfif imagealt neq "">
			<cfset myimagealt=imagealt>
		<cfelse>
			<cfset myimagealt=imagename>
		</cfif>
		<cfif isdefined('caption')>
			<cfset myimagecaption=caption>
		<cfelse>
			<cfset myimagecaption=imagename>
		</cfif>
		<cfquery name="addimage" datasource="#imagedsn#">
		INSERT	INTO IMAGE
		(STATUS,
		 IMAGEPATH,
		 VERSIONID,
		 CREATEDBYID,
		 ALT,
		 ALIGN,
		 <cfif imagehspace neq "">
		 HSPACE,
		 </cfif>
		 <cfif imagevspace neq "">
		 VSPACE,
		 </cfif>
		 TITLE,
		 IMAGENAME,
		 CAPTION,
		 SORTORDER,
		 FLASHGALLERY,
		 LINK)
		VALUES
		(<cfqueryparam value="#status#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#timedate#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#userid#" cfsqltype="CF_SQL_BIGINT">,
		 <cfif imagealt neq "">
		 <cfqueryparam value="#myimagealt#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfelse>
		 <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_VARCHAR">,
		 </cfif>
		 <cfqueryparam value="#imagealign#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfif imagehspace neq ""><cfqueryparam value="#imagehspace#" cfsqltype="CF_SQL_VARCHAR">,</cfif>
		 <cfif imagevspace neq ""><cfqueryparam value="#imagevspace#" cfsqltype="CF_SQL_VARCHAR">,</cfif>
		 <cfqueryparam value="#imagetitle#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#myimagealt#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#myimagecaption#" cfsqltype="CF_SQL_NTEXT">,
		 <cfqueryparam value="#sortorder#" cfsqltype="CF_SQL_BIGINT">,
		 <cfqueryparam value="#addtoflash#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#link#" cfsqltype="CF_SQL_VARCHAR">)
		SELECT @@IDENTITY AS IMAGEID
		</cfquery> 
		<cfset myimageid=addimage.imageid>
		<cfreturn myimageid>
	</cffunction>
	
	<cffunction name="addImageToGallery" output="false" returntype="void" access="public" hint="I add the image to the gallery passed to me">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imageid" type="Numeric" required="true" hint="ID of the image you want to add to the gallery">
		<cfargument name="galleryid" type="Numeric" required="true" hint="ID of the gallery you want to add the image to">
		<cfargument name="userid" type="numeric" required="false" default="0">
		<cfoutput>
		<cfquery name="deletefromgallery" datasource="#imagedsn#">
		DELETE
		FROM IMAGE2IMAGECATEGORY
		WHERE IMAGEID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">
			AND IMAGECATEGORYID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">
		</cfquery>
		<cfquery name="getmaxsortorder" datasource="#imagedsn#">
		SELECT
			MAX(SORTORDER) AS SORTMAX
		FROM IMAGE2IMAGECATEGORY
		WHERE IMAGECATEGORYID=<cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">
		</cfquery>
		<cfif getmaxsortorder.sortmax neq "">
			<cfset sortmax=getmaxsortorder.sortmax + 10>
		<cfelse>
			<cfset sortmax=10>
		</cfif>
		<cfquery name="qryimage2imagecat" datasource="#imagedsn#">
		INSERT	INTO IMAGE2IMAGECATEGORY
		(IMAGEID,
		 IMAGECATEGORYID,
		 SORTORDER)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">,
		 <cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">,
		 <cfqueryparam cfsqltype="cf_sql_bigint" value="#SORTMAX#">)
		</cfquery> 
		</cfoutput>
	</cffunction>
	
	<cffunction name="removeImageFromGallery" output="false" returntype="void" access="public" hint="I remove the image from the gallery passed to me">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imageid" type="Numeric" required="true" hint="ID of the image you want to remove">
		<cfargument name="galleryid" type="Numeric" required="true" hint="ID of the gallery you want to remove to remove the image from">
		<cfset var removeMyImageFromGallery=0>
		<cfquery name="removeMyImageFromGallery" datasource="#imagedsn#">
		DELETE FROM IMAGE2IMAGECATEGORY
		WHERE IMAGEID = <cfqueryparam value="#imageid#">
		AND IMAGECATEGORYID = <cfqueryparam value="#galleryid#">
		</cfquery> 
	</cffunction>
	
	<cffunction name="removeImagesFromGallery" access="public" output="false" returntype="void" hint="Remove list of images from a gallery">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imagelist" type="string" required="true" hint="ID of the image you want to remove">
		<cfargument name="galleryid" type="string" required="true" hint="ID of the gallery you want to remove to remove the image from">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#arguments.imagedsn#">
			DELETE FROM IMAGE2IMAGECATEGORY
			WHERE IMAGECATEGORYID = <cfqueryparam value="#arguments.galleryid#">
			AND IMAGEID IN (#arguments.imagelist#)
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="deleteGallery" output="false" returntype="void" access="public" hint="I remove the image gallery passed to me">
		<cfargument  name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="Numeric" required="true" hint="ID of the gallery you want to remove to remove the image from">
		<cfquery name="removeMyImageFromGallery" datasource="#imagedsn#">
		DELETE FROM IMAGE2IMAGECATEGORY
		WHERE IMAGECATEGORYID = '#galleryid#'
		</cfquery>
		<cfquery name="removeGallery" datasource="#imagedsn#">
		DELETE FROM IMAGECATEGORY
		WHERE IMAGECATEGORYID= '#galleryid#'
		</cfquery>
	</cffunction>
	
	<cffunction name="getAllImages" output="false" returntype="query" access="public" hints="I get all of the images for the imagedsn passed to me  I return a recordset, (IMAGEID, CAPTION, IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT, WIDTH, TITLE, IMAGENAME, IMAGECLASS, SORTORDER, FLASHGALLERY, LINK, CREATEDBYID, VERSIONID, VERSIONDESCRIPTION, IMAGECATEGORY, IMAGECATEGORYID, PARENTIMAGECATEGORYID, DESCRIPTION, STATUS)">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="excludegallerylist" type="string" required="false" hint="list of galleryids you want to exclude">
		<cfargument name="excludeimagelist" type="string" required="false" hint="list of imageids to exclude">
		<cfargument name="gallerystatus" required="false" hint="status of the gallery">
		<cfargument name="imagestatus" required="false" hint="list of status of the image you want">
		<cfargument name="sortimages" type="string" required="false" hint="I let the person calling me provide me with a list of how they want thier images sorted">
		<cfquery name="allMyImages" datasource="#imagedsn#">
		SELECT     
			IMAGE.IMAGEID, 
			IMAGE.CAPTION,
			IMAGE.IMAGEPATH, 
			IMAGE.ALT, 
			IMAGE.ALIGN, 
			IMAGE.HSPACE, 
			IMAGE.VSPACE, 
			IMAGE.HEIGHT, 
			IMAGE.WIDTH, 
			IMAGE.TITLE, 
			IMAGE.IMAGENAME, 
			IMAGE.IMAGECLASS,
			IMAGE.SORTORDER,
			IMAGE.FLASHGALLERY,
			IMAGE.LINK,
			IMAGE.CREATEDBYID,
			IMAGE.VERSIONID, 
			IMAGE.STATUS AS IMAGESTATUS,
			IMAGE.VERSIONDESCRIPTION,
			IMAGECATEGORY.IMAGECATEGORY,
			IMAGECATEGORY.IMAGECATEGORYID,
			IMAGECATEGORY.PARENTIMAGECATEGORYID,
			IMAGECATEGORY.DESCRIPTION,
			IMAGECATEGORY.STATUS
		FROM
			IMAGE 
			LEFT OUTER JOIN IMAGE2IMAGECATEGORY 
			ON IMAGE.IMAGEID = IMAGE2IMAGECATEGORY.IMAGEID
			LEFT OUTER JOIN IMAGECATEGORY 
			ON IMAGECATEGORY.IMAGECATEGORYID = IMAGE2IMAGECATEGORY.IMAGECATEGORYID
		WHERE (IMAGE.IMAGEPATH LIKE '%.jpg'
			OR IMAGE.IMAGEPATH LIKE '%.jpeg'
			OR IMAGE.IMAGEPATH LIKE '%.PNG'
			OR IMAGE.IMAGEPATH LIKE '%.GIF')
		<cfif isdefined('arguments.excludegallerylist')>
		AND IMAGECATEGORY.IMAGECATEGORYID NOT IN (#arguments.excludegallerylist#)
		</cfif>
		<cfif isdefined('arguments.excludeimagelist')>
		AND IMAGE.IMAGEID NOT IN (#arguments.excludeimagelist#)
		</cfif>
		<cfif isdefined('arguments.gallerystatus')>
		AND IMAGECATEGORY.STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gallerystatus#">
		</cfif>
		<cfif isdefined('arguments.imagestatus')>
		AND
		(
			<cfloop list="#arguments.imagestatus#" index="imgstatus">
				<cfif listfindnocase(arguments.imagestatus,imgstatus) GT 1>OR</cfif>
				IMAGE.STATUS=<cfqueryparam value="#imgstatus#" cfsqltype="cf_sql_varchar">
			</cfloop>
		)
		</cfif>
		<cfif isdefined('arguments.sortimages')>
		order by #arguments.sortimages#
		<cfelse>
		order by imagecategory.imagecategoryid, image.sortorder
		</cfif>
		</cfquery>

		<cfreturn allMyImages>
	</cffunction>
		
	<cffunction name="updateImageStatus" output="false" returntype="void" access="public" hint="I update the image status passed to me in the database">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imageid" type="numeric" required="true" hint="id for the image you are updating">
		<cfargument name="status" type="string" required="true" hint="status you want to update this image to">
		<cfquery name="addimage" datasource="#imagedsn#">
			UPDATE IMAGE
			SET STATUS = <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_VARCHAR">
			WHERE IMAGEID=<cfqueryparam value="#arguments.imageid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="updateImagePath" output="false" returntype="boolean" access="public" hint="I update the image path in the database">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="oldimagepath" type="string" required="true" hint="The old image path of the image to be updated">
		<cfargument name="newimagepath" type="string" required="true" hint="The new image path of the image to be updated">
		<cfset var update=0>
		<cfset image=getImage(arguments.imagedsn,0,arguments.oldimagepath)>
		<cfif image.recordCount EQ 1>
			<cfquery name="update" datasource="#imagedsn#">
				UPDATE IMAGE
				SET IMAGEPATH = <cfqueryparam value="#arguments.newimagepath#" cfsqltype="CF_SQL_VARCHAR">
				WHERE IMAGEID = <cfqueryparam value="#image.imageid#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
			<cfset isImagePathUpdated = 1>
		<cfelse>
			<cfset isImagePathUpdated = 0>
		</cfif>
		<cfreturn isImagePathUpdated>
	</cffunction>
	
	<cffunction name="updateImage" output="false" returntype="void" access="public" hint="I update the image passed to me in the database">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="userid" type="string" required="true" hint="id for the image you are updating">
		<cfargument name="imageid" type="string" required="true" hint="id for the person making this update">
		<cfargument name="imagename" type="string" required="true" hint="the full path to the master image"/>		 
		<cfargument name="imagealt" type="string" required="false" default="" hint="If I do not recieve imagealt, I will update imagealt with the imagename"/>
		<cfargument name="imagealign" type="string" required="false" />
		<cfargument name="imagevspace" type="string" required="false" />
		<cfargument name="imagehspace" type="string" required="false" />
		<cfargument name="sortorder" type="string" required="false" />
		<cfargument name="addtoflash" type="string" required="false" />
		<cfargument name="link" type="string" required="false" />
		<cfargument name="imagetitle" type="string" required="false" />
		<cfargument name="caption" type="string" required="false" hint="caption for the image" />
		<cfargument name="createstandardthumbs" type="string" required="false" default="yes" />
		<cfargument name="status" type="string" required="false" default="Active">
		<cfif imagealt neq "">
			<cfset myimagealt=imagealt>
		<cfelse>
			<cfset myimagealt=imagename>
		</cfif>
		<cfquery name="addimage" datasource="#imagedsn#">
		UPDATE IMAGE
		SET STATUS = <cfqueryparam value="#status#" cfsqltype="CF_SQL_VARCHAR">,
		 IMAGEPATH = <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_VARCHAR">,
		 VERSIONID = <cfqueryparam value="#timedate#" cfsqltype="CF_SQL_VARCHAR">,
		 CREATEDBYID = <cfqueryparam value="#userid#" cfsqltype="CF_SQL_BIGINT">,
		 ALT = <cfif imagealt neq "">
		 <cfqueryparam value="#myimagealt#" cfsqltype="CF_SQL_VARCHAR">
		 <cfelse>
		 <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_VARCHAR">
		 </cfif>
		 <cfif isdefined('imagealign')>, ALIGN = <cfqueryparam value="#imagealign#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 <cfif isdefined('imagehspace')>, HSPACE <cfqueryparam value="#imagehspace#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 <cfif isdefined('imagevspace')>, VSPACE = <cfqueryparam value="#imagevspace#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 <cfif isdefined('imagetitle')>, TITLE = <cfqueryparam value="#imagetitle#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 <cfif isdefined('imagealign')>, IMAGENAME = <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_NTEXT"></cfif>
		 <cfif isdefined('caption')>, CAPTION = <cfqueryparam value="#caption#" cfsqltype="CF_SQL_NTEXT"></cfif>
		 <cfif isdefined('sortorder')>, SORTORDER = <cfqueryparam value="#sortorder#" cfsqltype="CF_SQL_BIGINT"></cfif>
		 <cfif isdefined('addtoflash')>, FLASHGALLERY =  <cfqueryparam value="#addtoflash#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 <cfif isdefined('link')>, LINK =  <cfqueryparam value="#link#" cfsqltype="CF_SQL_VARCHAR"></cfif>
		 WHERE IMAGEID='#IMAGEID#'
		 </cfquery>
	</cffunction>
	
	<cffunction name="renameImage" output="false" returntype="string" access="public" hint="I rename the actual image file on the server, I return the new image name, if I do not find the image in the root image folder, I return 'NoImage' as the new image name">
		<cfargument name="oldImageName" type="string" required="true" hint="I am the old image name">
		<cfargument name="siteurl" type="string" required="true" hint="I am the url for the site in which I am renaming the image">
		<cfargument name="newname" type="string" required="false" default="0" hint="optional new name of the image, if you don't pass me in I will randomly create a new name">
		<cfargument name="filepath" type="string" required="false" default="images" hint="in case you want to rename or copy images that are not in the standard images path, pass in a different path as your source mybasepath:'/home/drew/domains' is already defined and your path would be mybasepath:siteurl:filepath">
		<cfargument name="destinationpath" type="string" required="false" default="images" hint="The destination folder for the new image (defaults to 'images').">
		<cfargument name="copy" type="string" required="false" default="0" hint="If you pass in a '1' I will just make a copy of the image and give it a new name, leaving the old one in case it is on a site somewhere already.">
		<cfset var myNewImage=0>
		<cfset var file_ext=0>
		<cfset var tempDir = 0>
		<cfset var currTemp=0>
		<cfset var baseImagePath=0>	
		<!--- set the base path --->
		<cfif arguments.filepath EQ "images">
			<cfset baseImagePath = "#mybasepath#/#arguments.siteurl#/public_html/#arguments.filepath#">
		<cfelse>
			<cfset baseImagePath = arguments.filepath>
		</cfif>
		<cfif arguments.DestinationPath EQ "images">
			<cfset baseDestinationPath="#mybasepath#/#arguments.siteurl#/public_html/#arguments.destinationpath#">
		<cfelse>
			<cfset baseDestinationPath = arguments.filepath>
		</cfif>
		
		<cfset tempDir = ListAppend('#baseImagePath#', 'temp', '/')>
			<!--- first check to make sure the file we are about to rename really exists --->
			<cfif FileExists("#baseImagePath#/#arguments.oldImageName#")>
				<!--- set the file extension of the file we are renameing --->
				<cfset file_ext=ListLast('#arguments.oldImageName#', '.')>
				<!--- if I do not get a newname to use, I will create a random one --->
				<cfif arguments.newname EQ 0>
					<cfinvoke component="Security" method="getRandomUsername" returnvariable="randomName">
					<cfset myNewImage="i#randomName##timedate#.#file_ext#">
				<cfelse>
					<cfset myNewImage = arguments.newname>
				</cfif>
				<!--- If copy is not passed in to me I will just rename the image as is --->
				<cfif arguments.copy eq 0>
					<cffile action="rename" source="#baseImagePath#/#oldImageName#" destination="#baseImagePath#/#myNewImage#">
					<cfloop list="#thumbdirlist#" index="currFolder">
						<cfif FileExists("#baseImagePath#/#currFolder#/#oldImageName#")>
							<cffile action="rename" source="#baseImagePath#/#currFolder#/#oldImageName#" destination="#baseDestinationPath#/#currFolder#/#myNewImage#" >
						</cfif>
					</cfloop>
				<!--- this means that I was called to create a newly named copy of the image passed to me --->
				<cfelse>
					<!--- check/create the temp dir for this path to use for the copy--->
					<cfinvoke component="imagegallery" method="dirCheckCreate" myDir="#tempDir#" returnvariable="gDir">
					<!--- copy the first root image --->
					<cffile action="copy" source="#baseImagePath#/#oldImageName#" destination="#tempDir#">
					<!--- rename the first root image--->
					<cffile action="rename" source="#tempDir#/#oldImageName#" destination="#baseDestinationPath#/#myNewImage#">
					<!--- now do the same for each thumb --->
					<cfloop list="#thumbdirlist#" index="currFolder">
						<!--- only do this if each thumb already exists --->
						<cfif FileExists("#baseImagePath#/#currFolder#/#oldImageName#")>
							<cfset currTemp="#baseImagePath#/#currFolder#/temp">
							<cfinvoke component="imagegallery" method="dirCheckCreate" myDir="#currtemp#" returnvariable="gDir">
							<cffile action="copy" source="#baseImagePath#/#currFolder#/#filename#" destination="#tempDir#">
							<cffile action="rename"source="#currTemp#/#oldImageName#" destination="#baseDestinationPath#/#currFolder#/#myNewImage#">
						</cfif>
					</cfloop>
				</cfif>
			<!--- if the file does not exist, set the return var to NoImage --->
			<cfelse>
				<cfset myNewImage="NoImage">
			</cfif>
		<cfreturn myNewImage>
	</cffunction>	
	
	<cffunction name="addGallery" output="false" returntype="string" access="public" hint="I add a new gallery, and return the id for the gallery I added">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryname" type="string" required="true" hint="I am the name of the new gallery">
		<cfargument name="gallerydescription" type="string" required="false" hint="I am the description of the gallery" default="">
		<cfargument name="parentgalleryid" type="numeric" required="false" hint="I am the parent id of the gallery, I default to 0" default="0">
		<cfargument name="sortorder" type="numeric" required="false" hint="I provide the sort value of the galleries, I default to 0" default="0">
		<cfargument name="status" type="string" required="false" hint="I am the status of the new gallery, I default to Private" default="Private">
		<cfargument name="userid" type="numeric" required="false" default="0" hint="I am userid for the person adding the image category">
		<cfquery name="insertnewcat" datasource="#imagedsn#">  <!--- was request.dsn --binod 2008/12/10 --->
			INSERT INTO IMAGECATEGORY
			(
				IMAGECATEGORY,
				VERSIONID,
				DESCRIPTION,
				PARENTIMAGECATEGORYID,
				STATUS,
				VERSIONDESCRIPTION,
				SORTORDER,
				CREATEDBYID
			)
			VALUES
			(
				<cfqueryparam value="#galleryname#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#timedate#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#gallerydescription#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#parentgalleryid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#status#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="I was created using the imagegallery.cfc" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#sortorder#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#userid#" cfsqltype="CF_SQL_BIGINT">
			) 
			SELECT @@IDENTITY AS GALLERYID
	 </cfquery>
	 <cfreturn insertnewcat.galleryid>
	</cffunction>
	
	<cffunction name="addGalleryWithID" output="false" returntype="void" access="public" hint="I add a new gallery, and return the id for the gallery I added">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryname" type="string" required="true" hint="I am the name of the new gallery">
		<cfargument name="galleryid" type="string" required="true" hint="I am the gallery id the gallery is forced to have">
		<cfargument name="gallerydescription" type="string" required="false" hint="I am the description of the gallery" default="">
		<cfargument name="parentgalleryid" type="numeric" required="false" hint="I am the parent id of the gallery, I default to 0" default="0">
		<cfargument name="sortorder" type="numeric" required="false" hint="I provide the sort value of the galleries, I default to 0" default="0">
		<cfargument name="status" type="string" required="false" hint="I am the status of the new gallery, I default to Private" default="Private">
		<cfargument name="userid" type="numeric" required="false" default="0" hint="I am userid for the person adding the image category">
		<cfquery name="insertnewcat" datasource="#imagedsn#">  <!--- was request.dsn --binod 2008/12/10 --->
			SET IDENTITY_INSERT IMAGECATEGORY ON
			INSERT INTO IMAGECATEGORY
			(
				IMAGECATEGORYID,
				IMAGECATEGORY,
				VERSIONID,
				DESCRIPTION,
				PARENTIMAGECATEGORYID,
				STATUS,
				VERSIONDESCRIPTION,
				SORTORDER,
				CREATEDBYID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.galleryid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#galleryname#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#timedate#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#gallerydescription#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#parentgalleryid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#status#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="I was created using the imagegallery.cfc" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#sortorder#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#userid#" cfsqltype="CF_SQL_BIGINT">
			) 
			SET IDENTITY_INSERT IMAGECATEGORY OFF;
	 </cfquery>
	 <cfreturn>
	</cffunction>
	
	<cffunction name="updateGallery" output="false" returntype="void" access="public" hint="I add a new gallery, and return the id for the gallery I added">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="numeric" required="true" hint="I am the galleryid for the gallery you want to update">
		<cfargument name="galleryname" type="string" required="true" hint="I am the name of the new gallery">
		<cfargument name="userid" type="numeric" required="true" hint="I am userid for the person updating the image category">
		<cfargument name="gallerydescription" type="string" required="false" hint="I am the description of the gallery" default="">
		<cfargument name="parentgalleryid" type="numeric" required="false" hint="I am the parent id of the gallery" default="0">
		<cfargument name="sortorder" type="numeric" required="false" hint="I provide the sort value of the galleries" default="0">
		<cfargument name="status" type="string" required="false" hint="I am the status of the new gallery" default="Private">
		<cfquery name="insertnewcat" datasource="#arguments.imagedsn#"> 
			UPDATE IMAGECATEGORY
			SET IMAGECATEGORY=<cfqueryparam value="#galleryname#" cfsqltype="CF_SQL_VARCHAR">,
				VERSIONID=<cfqueryparam value="#timedate#" cfsqltype="CF_SQL_VARCHAR">,
				DESCRIPTION=<cfqueryparam value="#gallerydescription#" cfsqltype="CF_SQL_VARCHAR">,
				PARENTIMAGECATEGORYID=<cfqueryparam value="#parentgalleryid#" cfsqltype="CF_SQL_VARCHAR">,
				STATUS=<cfqueryparam value="#status#" cfsqltype="CF_SQL_VARCHAR">,
				VERSIONDESCRIPTION=<cfqueryparam value="I was created using the imagegallery.cfc" cfsqltype="CF_SQL_VARCHAR">,
				<cfif arguments.sortorder NEQ 0>
					SORTORDER=<cfqueryparam value="#sortorder#" cfsqltype="CF_SQL_INTEGER">,
				</cfif>
				CREATEDBYID=<cfqueryparam value="#userid#" cfsqltype="CF_SQL_BIGINT">
			WHERE IMAGECATEGORYID=<cfqueryparam value="#galleryid#" cfsqltype="CF_SQL_BIGINT">
		 </cfquery>
	</cffunction>
	
	<cffunction name="getRecentImages" output="false" returntype="query" access="public" hint="I get the recently added images, I return a recordset, (IMAGEID, CAPTION, IMAGEPATH, ALT, ALIGN, HSPACE, VSPACE, HEIGHT, WIDTH, TITLE, IMAGENAME, IMAGECLASS, SORTORDER, FLASHGALLERY, LINK, CREATEDBYID, VERSIONID, VERSIONDESCRIPTION, IMAGECATEGORY, IMAGECATEGORYID, PARENTIMAGECATEGORYID, DESCRIPTION, STATUS)">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="requestednumber" type="string" required="false" hint="The number of requested recent images" default="9">
		<cfquery name="getImages" datasource="#imagedsn#" maxrows="#requestednumber#">
		SELECT     
			IMAGE.IMAGEID, 
			IMAGE.CAPTION,
			IMAGE.IMAGEPATH, 
			IMAGE.ALT, 
			IMAGE.ALIGN, 
			IMAGE.HSPACE, 
			IMAGE.VSPACE, 
			IMAGE.HEIGHT, 
			IMAGE.WIDTH, 
			IMAGE.TITLE, 
			IMAGE.IMAGENAME, 
			IMAGE.IMAGECLASS,
			IMAGE.SORTORDER,
			IMAGE.FLASHGALLERY,
			IMAGE.CREATEDBYID,
			IMAGE.VERSIONID, 
			IMAGE.LINK,
			IMAGE.VERSIONDESCRIPTION
		FROM
			IMAGE
		WHERE (IMAGE.IMAGEPATH LIKE '%.jpg'
		OR IMAGE.IMAGEPATH LIKE '%jpeg'
		OR IMAGE.IMAGEPATH LIKE '%PNG'
		OR IMAGE.IMAGEPATH LIKE '%GIF')
		ORDER BY IMAGE.VERSIONID DESC
		</cfquery>
		<cfreturn getImages>
	</cffunction>
	
	<cffunction name="updateSortOrder" output="false" returntype="void" access="public" hint="I resort the images and the gallery passed to me">
		<cfargument name="imagedsn" required="true" type="string" hint="The datasource for the images">
		<cfargument name="galleryid" required="true" type="numeric" hint="I am the id of the gallery you want to resort images on">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of image ids in the order you want them sorted">
		<cfset var myNewList=0>
		<cfset var mycount=0>
		<cfset myNewList = "#txtConvert.ListDeleteDuplicatesNoCase(sortlist)#">
		<cfset mycount=10>
		<cfloop list="#myNewList#" index="imageid">
			<cfquery name="deletefromgallery" datasource="#imagedsn#">
			DELETE
			FROM IMAGE2IMAGECATEGORY
			WHERE IMAGEID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">
			AND IMAGECATEGORYID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">
			</cfquery>
			<cfquery name="qryimage2imagecat" datasource="#imagedsn#">
			INSERT	INTO IMAGE2IMAGECATEGORY
			(IMAGEID,
			 IMAGECATEGORYID,
			 SORTORDER)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_bigint" value="#imageid#">,
			 <cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">,
			 <cfqueryparam cfsqltype="cf_sql_bigint" value="#mycount#">)
			</cfquery> 
			<cfset mycount=mycount + 10>
		</cfloop>
	</cffunction>
	
	<cffunction name="sortImagesInGallery" access="public" output="false" returntype="void" hint="I sort images in a gallery">
		<cfargument name="imagedsn" required="true" type="string" hint="database name">
		<cfargument name="galleryid" required="true" type="string" hint="id of the gallery">
		<cfargument name="imageidlist" required="true" type="string" hint="list of image id">
		<cfset var sort=0>
		<cfset var l=listlen(arguments.imageidlist)>
		<cfquery name="sort" datasource="#arguments.imagedsn#">
			UPDATE IMAGE2IMAGECATEGORY
			SET SORTORDER = CASE IMAGEID
				<cfloop from="1" to="#l#" index="i">
					WHEN <cfqueryparam value="#listGetAt(arguments.imageidlist,i)#"> THEN <cfqueryparam value="#i#">
				</cfloop>
			END
			WHERE IMAGECATEGORYID=<cfqueryparam value="#arguments.galleryid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="updateGallerySortOrder" output="false" returntype="void" access="public" hint="I resort the images and the gallery passed to me">
		<cfargument name="imagedsn" required="true" type="string" hint="The datasource for the images">
		<cfargument name="sortlist" required="true" type="string" hint="I am the list of image ids in the order you want them sorted">
		<!--- <cfquery name="dropGallerSort" datasource="#imagedsn#">
		DELETE FROM IMAGE2IMAGECATEGORY
		WHERE IMAGECATEGORYID=<cfqueryparam cfsqltype="cf_sql_bigint" value="#galleryid#">
		</cfquery> --->
		<cfset mycount=10>
		<cfloop list="#sortlist#" index="i">
		<cfquery name="updateSortOrder" datasource="#imagedsn#">
		UPDATE IMAGECATEGORY
		SET  SORTORDER=<cfqueryparam cfsqltype="cf_sql_bigint" value="#mycount#">
		WHERE IMAGECATEGORYID=<cfqueryparam cfsqltype="cf_sql_bigint" value="#i#">
		</cfquery>
		<cfset mycount=mycount + 10>
		</cfloop>
	</cffunction>
	
	<cffunction name="sortAlbums" access="public" output="false" returntype="void" hint="I sort image galleries">
		<cfargument name="imagedsn" required="true" type="string" hint="database name">
		<cfargument name="sortlist" required="true" type="string" hint="database name">
		<cfset var sort=0>
		<cfset var l=listlen(arguments.sortlist)>
		<cfquery name="sort" datasource="#arguments.imagedsn#">
			UPDATE IMAGECATEGORY
			SET SORTORDER = CASE IMAGECATEGORYID
				<cfloop from="1" to="#l#" index="i">
					WHEN <cfqueryparam value="#listGetAt(arguments.sortlist,i)#"> THEN <cfqueryparam value="#i#">
				</cfloop>
			END
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getRandomImages" access="public" returnType="query" hint="I get random images, a specific image gallery can be specified. (IMAGEID, IMAGEPATH, ALT, IMAGENAME, SORTORDER)" output="false">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="galleryid" type="string" required="false" hint="Gallery ID for random images" default="0">
		<cfargument name="numberOfImages" type="string" required="false" hint="Number of Images to Return" default="1">
		<cfargument name="status" type="string" required="false" hint="Will only return random images from a specific status" default="0">
		<cfquery name="randomImages" datasource="#imagedsn#">
			SELECT TOP <cfoutput>#numberOfImages#</cfoutput> 
				IMAGE.IMAGEID,
				IMAGE.IMAGEPATH,
				IMAGE.ALT,
				IMAGE.IMAGENAME,
				IMAGE.LINK,
				IMAGE.STATUS,
				IMAGE.TITLE,
				IMAGE.CAPTION,
				IMAGE2IMAGECATEGORY.SORTORDER
			FROM IMAGE, IMAGE2IMAGECATEGORY			
			WHERE 
			IMAGE2IMAGECATEGORY.IMAGEID = IMAGE.IMAGEID
			<cfif arguments.status NEQ 0>AND IMAGE.STATUS = <cfqueryparam value="#arguments.status#"></cfif>
			<cfif arguments.galleryid NEQ 0>AND IMAGE2IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#galleryid#"></cfif>
			ORDER BY NEWID()
		</cfquery>
		<cfreturn randomImages>
	</cffunction>
	
	<cffunction name="getLegacyGalleries" access="public" returntype="query" hint="I get the legacy image galleries for the siteid passed to me">
		<cfargument name="siteid" type="string" required="true" hint="I am the siteid for the site you need to get legacy image galleries from, this is required since it is the legacy system">
		<cfargument name="imagedsn" type="string" required="false" default="qdelta" hint="the datasource to look for legacy image galleries">
		<cfargument name="galleryid" type="string" required="false" default="0" hint="the id for the gallery you want">
		<cfset var legacyGalleries=0>
		<cfquery name="legacyGalleries" datasource="#arguments.imagedsn#">
			SELECT     
				IMAGECATEGORY.IMAGECATEGORYID, 
				IMAGECATEGORY.SORTORDER,
				IMAGECATEGORYVERSION.IMAGECATEGORY, 
				SITE.SITEID, 
				SITE.SITENAME, 
				IMAGECATEGORYVERSION.DESCRIPTION, 
				IMAGECATEGORYVERSION.PARENTIMAGECATEGORYID, 
				IMAGECATEGORYVERSION.STATUS, 
				IMAGECATEGORYVERSION.VERSIONID
			FROM SITE 
			RIGHT OUTER JOIN
			IMAGECATEGORY2SITE 
			ON SITE.SITEID = IMAGECATEGORY2SITE.SITEID 
			RIGHT OUTER JOIN
			IMAGECATEGORY 
			ON IMAGECATEGORY2SITE.IMAGECATEGORYID = IMAGECATEGORY.IMAGECATEGORYID 
			LEFT OUTER JOIN
			IMAGECATEGORYVERSION 
			ON IMAGECATEGORY.IMAGECATEGORYID = IMAGECATEGORYVERSION.IMAGECATEGORYID
			WHERE     (IMAGECATEGORYVERSION.VERSIONID =                          
				(SELECT     MAX(VERSIONID)                            
				FROM          IMAGECATEGORYVERSION                            
				WHERE      IMAGECATEGORYID = IMAGECATEGORY.IMAGECATEGORYID)) 							
				AND (IMAGECATEGORYVERSION.STATUS <> 'Deleted')
			AND SITE.SITEID = <cfqueryparam value="#arguments.siteid#">
			<cfif arguments.galleryid neq 0>
			AND IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#arguments.galleryid#">
			</cfif>
			ORDER BY IMAGECATEGORY.SORTORDER
		</cfquery>
		<cfreturn legacyGalleries>
	</cffunction>
	
	<cffunction name="getLegacyImages" access="public" returntype="query" hint="I get the legacy images for the categoryid passed to me">
	<cfargument name="categoryid" type="string" required="true" hint="The id of the imagecategoryid you want to get the legacy images for">
	<cfargument name="imagedsn" type="string" required="false" default="qdelta" hint="the datasource to look for legacy image galleries">
	<cfset var legacyImages=0>
	<cfquery name="legacyImages" datasource="#arguments.imagedsn#">
		SELECT     
			IMAGE.IMAGEID,
			IMAGEVERSION.CAPTION,
			IMAGEVERSION.IMAGEPATH, 
			IMAGEVERSION.ALT, 
			IMAGEVERSION.ALIGN, 
			IMAGEVERSION.HSPACE, 
			IMAGEVERSION.VSPACE, 
			IMAGEVERSION.HEIGHT, 
			IMAGEVERSION.WIDTH, 
			IMAGEVERSION.TITLE, 
			IMAGEVERSION.IMAGENAME, 
			IMAGEVERSION.STATUS,
			IMAGEVERSION.IMAGECLASS, 
			IMAGEVERSION.VERSIONID, 
			IMAGEVERSION.VERSIONDESCRIPTION, 
			IMAGECATEGORY.IMAGECATEGORYID, 
			IMAGECATEGORY.IMAGECATEGORY
		FROM IMAGE 
		INNER JOIN
		IMAGEVERSION 
		ON IMAGE.IMAGEID = IMAGEVERSION.IMAGEID 
		RIGHT OUTER JOIN
		IMAGE2IMAGECATEGORY 
		ON IMAGE.IMAGEID = IMAGE2IMAGECATEGORY.IMAGEID 
		RIGHT OUTER JOIN
		IMAGECATEGORY 
		ON IMAGE2IMAGECATEGORY.IMAGECATEGORYID = IMAGECATEGORY.IMAGECATEGORYID
		WHERE     (IMAGEVERSION.VERSIONID =                          
		(SELECT     MAX(VERSIONID)                            
		FROM          IMAGEVERSION                            
		WHERE      IMAGEID = IMAGE.IMAGEID)) 
		AND IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#arguments.categoryid#">
		AND IMAGEVERSION.STATUS <> 'Deleted'
		ORDER BY IMAGEVERSION.ALT
	</cfquery>
	<cfreturn legacyImages>
	</cffunction>
	
	<cffunction name="getGalleries" access="public" returntype="query" hint="I get the image galleries that have not been deleted and I ignore 'address book'(SORTORDER, IMAGECATEGORY, IMAGECATEGORYID, PARENTIMAGECATEGORYID, DESCRIPTION, STATUS, VERSIONID, VERSIONID, IMAGECOUNT, IMAGEPATH, LASTUPDATE, CREATED)" output="false">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="gallerystatus" type="string" required="false" hint="the status of the galleries you want" default="0">
		<cfargument name="status" type="string" required="false" hint="the status of the sample images you want" default="0">
		<cfargument name="criteria" type="string" required="false" hint="what you want to search on" default="0">
		<cfargument name="categoryid" type="string" required="false" hint="ID of Category to return" default="0">
		<cfargument name="excludelist" type="string" required="false" hint="the list of the gallery ids you want to exclude" default="0">
		<cfargument name="addressbookinclude" type="string" required="false" default="0" hint="If you do not want to exlude the address book gallery, pass in 1">
		<cfset var imagecategories=0>
		<cfset var sub1=0>
		<cfset var sub2=0>
		
		<!--- <cfquery name="sub2" datasource="#arguments.imagedsn#">
			SELECT IC1.IMAGEID, IC1.IMAGECATEGORYID, IC1.SORTORDER, IMAGE.IMAGEPATH
			FROM IMAGE2IMAGECATEGORY IC1
			JOIN IMAGE ON IC1.IMAGEID=IMAGE.IMAGEID
			JOIN
			(
			SELECT IMAGECATEGORYID, MIN(SORTORDER) AS SORTORDER
			FROM IMAGE2IMAGECATEGORY
			GROUP BY IMAGECATEGORYID
		
			) IC2
			ON
			IC1.IMAGECATEGORYID = IC2.IMAGECATEGORYID
			AND IC1.SORTORDER=IC2.SORTORDER
		</cfquery> --->
		
		<!--- <cfquery name="sub2" datasource="#arguments.imagedsn#">
			SELECT IC1.IMAGEID, IC1.IMAGECATEGORYID, IC1.SORTORDER, IMAGE.IMAGEPATH
			FROM IMAGE2IMAGECATEGORY IC1
			JOIN IMAGE ON IC1.IMAGEID=IMAGE.IMAGEID
			JOIN
			(
				SELECT X.IMAGECATEGORYID, X.IMAGECATEGORY, (select min(sortorder) from image2imagecategory where imagecategoryid=x.imagecategoryid) as sortorder FROM IMAGECATEGORY X
				left OUTER JOIN
				(
				SELECT IMAGECATEGORYID, MIN(SORTORDER) AS SORTORDER
				FROM IMAGE2IMAGECATEGORY
				GROUP BY IMAGECATEGORYID
				) C
				ON X.IMAGECATEGORYID=C.IMAGECATEGORYID
			) IC2
			ON
			IC1.IMAGECATEGORYID = IC2.IMAGECATEGORYID
			AND IC1.SORTORDER=IC2.SORTORDER
		</cfquery> --->
		
		<cfquery name="sub1" datasource="#arguments.imagedsn#">
		SELECT     
			IMAGECATEGORY.IMAGECATEGORYID, 
			IMAGECATEGORY.SORTORDER,
			IMAGECATEGORY.IMAGECATEGORY,  
			convert(VARCHAR(1000),DESCRIPTION) AS DESCRIPTION, 
			IMAGECATEGORY.PARENTIMAGECATEGORYID, 
			IMAGECATEGORY.STATUS, 
			IMAGECATEGORY.VERSIONID,
			COUNT(IMAGE2IMAGECATEGORY.IMAGEID) AS IMAGECOUNT,
			(SELECT TOP 1 IMAGE.IMAGEPATH
			FROM
				IMAGE,
				IMAGE2IMAGECATEGORY
			WHERE
				IMAGE.IMAGEID=IMAGE2IMAGECATEGORY.IMAGEID
			AND IMAGE2IMAGECATEGORY.IMAGECATEGORYID = IMAGECATEGORY.IMAGECATEGORYID
			ORDER BY IMAGE2IMAGECATEGORY.SORTORDER) AS IMAGEPATH, 
			MAX(IMAGE.VERSIONID) AS LASTUPDATE,
			MIN(IMAGE.VERSIONID) AS CREATED
		FROM
			IMAGECATEGORY LEFT OUTER JOIN IMAGE2IMAGECATEGORY
			ON IMAGECATEGORY.IMAGECATEGORYID = IMAGE2IMAGECATEGORY.IMAGECATEGORYID
			LEFT OUTER JOIN IMAGE
			ON IMAGE2IMAGECATEGORY.IMAGEID = IMAGE.IMAGEID
		WHERE      (IMAGECATEGORY.STATUS <> 'Deleted')
		<cfif criteria neq 0 and criteria neq "" and len(criteria) and categoryid eq 0>
		AND (IMAGECATEGORY.IMAGECATEGORY LIKE '%#arguments.criteria#%'
		OR IMAGECATEGORY.DESCRIPTION LIKE '%#arguments.criteria#%')
		<cfelseif categoryid NEQ 0>
			AND (IMAGECATEGORY.IMAGECATEGORYID = <cfqueryparam value="#arguments.categoryid#">)
		</cfif>
		<cfif arguments.gallerystatus neq 0>
		AND IMAGECATEGORY.STATUS = <cfqueryparam value="#arguments.gallerystatus#">
		</cfif>
		<cfif arguments.status neq 0>
		AND IMAGE.STATUS = <cfqueryparam value="#arguments.status#">
		</cfif>
		<cfif arguments.excludelist neq 0>
		AND IMAGECATEGORY.IMAGECATEGORYID NOT IN (<cfqueryparam value="#arguments.excludelist#">)
		</cfif>
		<cfif addressbookinclude neq 0>
		AND IMAGECATEGORY.IMAGECATEGORY NOT LIKE '%Address Book%'
		</cfif>
		GROUP BY 
			IMAGECATEGORY.SORTORDER,
			IMAGECATEGORY.IMAGECATEGORY, 
			IMAGECATEGORY.IMAGECATEGORYID, 
			IMAGECATEGORY.PARENTIMAGECATEGORYID, 
			convert(VARCHAR(1000),DESCRIPTION), 
			IMAGECATEGORY.STATUS, 
			IMAGECATEGORY.VERSIONID
		ORDER BY IMAGECATEGORY.SORTORDER
		</cfquery>
		
		<!--- <cfquery name="imagecategories" dbtype="query">
			SELECT 
				SUB1.IMAGECATEGORYID,
				SUB1.SORTORDER,
				SUB1.IMAGECATEGORY,
				SUB1.DESCRIPTION,
				SUB1.PARENTIMAGECATEGORYID,
				SUB1.STATUS,
				SUB1.VERSIONID,
				SUB1.IMAGECOUNT,
				SUB1.LASTUPDATE,
				SUB1.CREATED,
				SUB2.IMAGEPATH
			FROM SUB1,SUB2
			WHERE SUB1.IMAGECATEGORYID=SUB2.IMAGECATEGORYID
		</cfquery> --->
		
		<cfreturn sub1>
	</cffunction>

	<cffunction name="getLastUpdatedGallery" access="public" returntype="query" hint="I get the lastest updated gallery">
		<cfargument name="imagedsn" type="string" required="true" hint="I get the last updated gallery">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.imagedsn#">
			SELECT TOP 1
				IMAGECATEGORYID,
				IMAGECATEGORY,
				DESCRIPTION,
				STATUS,
				VERSIONID,
				CREATEDBYID,
				VERSIONDESCRIPTION
			FROM IMAGECATEGORY
			WHERE STATUS='Public'
			ORDER BY VERSIONID DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
		
	<cffunction name="deleteImage" output="false" returntype="void" access="public" hint="I remove the image from the database">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfargument name="imageid" type="Numeric" required="true" hint="ID of the image you want to remove">
		<cfset mybaseimagepath="#mybasepath#/#imagedsn#/public_html/images">
		<cfinvoke component="imagegallery" 
					method="getImage" 
					imageid="#imageid#" 
					imagedsn="#imagedsn#" 
					returnvariable="myimage">
		<cfif myimage.recordcount eq 1>
			<cfinvoke component="imagegallery" imagedsn="#imagedsn#" method="getImage" imagepath="#myimage.imagepath#" returnVariable="multipleImages">

				<cfquery name="removeMyImageFromGallery" datasource="#imagedsn#">
				DELETE FROM IMAGE2IMAGECATEGORY
				WHERE IMAGEID = '#imageid#'
				</cfquery> 
				<cfquery name="qryDELETEimagever" datasource="#imagedsn#">
				DELETE FROM	IMAGE
				WHERE IMAGEID = '#IMAGEID#'
				</cfquery>

			<!--- <cfif multipleImages.recordCount EQ 0> --->
				<cfif fileexists("#mybaseimagepath#/#myimage.imagepath#")>
					<cffile action="delete" FILE="#mybaseimagepath#/#myimage.imagepath#"> 
					<cfloop list="#thumbdirlist#" index="currentpath">
						<cfif fileexists("#mybaseimagepath#/#currentpath#/#myimage.imagepath#")>
							<cffile action="delete" FILE="#mybaseimagepath#/#currentpath#/#myimage.imagepath#">
						</cfif>
					</cfloop>
				</cfif>
			<!--- </cfif> --->
		</cfif>
	</cffunction>
	
	<cffunction name="deleteImages" access="public" output="false" returntype="void" hint="I delete images">
		<cfargument name="imagedsn" type="string" required="true" hint="database name">
		<cfargument name="imagelist" type="string" required="true" hint="list of image ids">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#arguments.imagedsn#">
			DELETE FROM IMAGE2IMAGECATEGORY
			WHERE IMAGEID IN (#arguments.imagelist#)
		</cfquery> 
		<cfquery name="remove" datasource="#arguments.imagedsn#">
			DELETE FROM	IMAGE
			WHERE IMAGEID IN (#arguments.imagelist#)
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="sspXmlBuild" output="false" returntype="void" access="public" hint="I build the ssp xml for the imagedsn passed to me.">
		<cfargument name="imagedsn" type="string" required="true" hint="The datasource for the images">
		<cfinvoke component="imagegallery" method="getAllImages" gallerystatus="Public" imagestatus="Active" imagedsn="#imagedsn#" returnvariable="qrysspimages">
		<cfset largepicpath = "http://#imagedsn#/images/detail/">
		<cfset smallpicpath = "http://#imagedsn#/images/tiny/">
		<cfset mysitepath = "/home/drew/domains/#imagedsn#/public_html/">
		<cfsavecontent variable="xml_ssp_map"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>
		<gallery>
		<cfoutput query="qrysspimages" group="imagecategoryid">
			<album id="#IMAGECATEGORYID#" parentid="#parentimagecategoryid#" title="#XMLFormat(IMAGECATEGORY)#" description="#XMLFormat(description)#" lgPath="#largepicpath#" tnPath="#smallpicpath#" tn="#smallpicpath#">
			<cfoutput group="IMAGEID">
				<img src="#IMAGEPATH#" id="#imageid#" title="#XMLFormat(title)#" caption="#XMLFormat(CAPTION)#" link="" target="" sortorder="#sortorder#"/>
			</cfoutput>
			</album >
		</cfoutput>
		</gallery>
		</cfsavecontent>
		
		<cfoutput query="qrysspimages" group="imagecategoryid">
		<cfsavecontent variable="xml_ssp_#imagecategoryid#"><?xml version="1.0" encoding="UTF-8" standalone="yes"?>
		<gallery>
			<album id="#imagecategoryid#" parentid="#parentimagecategoryid#" title="#XMLFormat(IMAGECATEGORY)#" description="#XMLFormat(description)#" lgPath="#largepicpath#" tnPath="#smallpicpath#" tn="#smallpicpath#">
			<cfoutput group="IMAGEID">
				<img src="#IMAGEPATH#" id="#imageid#" title="#XMLFormat(title)#" caption="#XMLFormat(CAPTION)#" link="" target="" sortorder="#sortorder#"/>
			</cfoutput>
			</album >
		</gallery>
		</cfsavecontent>
		</cfoutput>
		
		<cfoutput>
			<cffile action="write" mode="775" addnewline="no" file="#mysitepath#xml/ssp_all.xml" output="#xml_ssp_map#">
		</cfoutput>
		
		<cfoutput query="qrysspimages" group="imagecategoryid">
			<cffile action="write" mode="775" addnewline="no" file="#mysitepath#xml/ssp_#imagecategoryid#.xml" output="#Evaluate("xml_ssp_#imagecategoryid#")#">
		</cfoutput>
	</cffunction>

</cfcomponent>