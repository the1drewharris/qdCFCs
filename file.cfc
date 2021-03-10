<cfcomponent hint="function related to file">
<cfobject component="timeDateConversion" name="mytime">
	<cffunction name="createtables">
		<cfquery name="tables" datasource="#filedsn#">
			DROP TABLE FILETOIDPOOL;
			DROP TABLE FILESFORMEDIA;
			DROP TABLE FILES;
			CREATE TABLE FILESFORMEDIA
			(
				FILEID BIGINT IDENTITY(1,1) NOT NULL,
				TITLE NTEXT NOT NULL,
				DESCRIPTION NTEXT,
				PATH NTEXT NOT NULL,
				FILENAME NTEXT NOT NULL,
				NAMEID BIGINT NOT NULL,
				TIMEDATE VARCHAR(16)
			)
			ALTER TABLE FILESFORMEDIA ADD CONSTRAINT PK_FILESFORMEDIA PRIMARY KEY(FILEID);
			
			CREATE TABLE FILETOIDPOOL 
			(
				FILEID BIGINT NOT NULL,
				ID BIGINT NOT NULL
			)
			ALTER TABLE FILETOIDPOOL ADD CONSTRAINT PK_FILETOIDPOOL PRIMARY KEY(FILEID,ID);
			ALTER TABLE FILETOIDPOOL ADD FOREIGN KEY(FILEID) REFERENCES FILESFORMEDIA(FILEID);
			ALTER TABLE FILETOIDPOOL ADD FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			
			CREATE TABLE FILES
			(
				FILECATEGORYID VARCHAR(16),
				FILECATEGORY VARCHAR(256),
				SERVERFILENAME VARCHAR(256) NOT NULL,
				DISPLAYNAME VARCHAR(256),
				PROJECTID VARCHAR(16),
				FILEID BIGINT IDENTITY(1,1),
				SORTORDER BIGINT,
				LASTUPDATED VARCHAR(16) NOT NULL
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addfile" access="public" returntype="String" hint="I add file and return FILEID">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="title" required="true" type="String" hint="title of the file">
		<cfargument name="description" required="true" type="String" hint="description of the file">
		<cfargument name="path" required="true" type="String" hint="name and path where the file will be stored">
		<cfargument name="nameid" required="true" type="String" hint="Nameid of the person who uploaded the file"> 
		<cfset var add=0>
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		<cfquery name="add" datasource="#filedsn#">
			INSERT INTO FILESFORMEDIA
			(
				TITLE,
				DESCRIPTION,
				PATH,
				FILENAME,
				NAMEID,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.path#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.filename#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS FILEID
		</cfquery>
		<cfreturn add.fileid>
	</cffunction>
	
	<cffunction name="tiefiletoproduct" access="public" returntype="void" hint="I tie file to a product">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="fileid" required="true" type="String" hint="id of the file">
		<cfargument name="id" required="true" type="String" hint="id of the product it is tied to">
		<cfset var addfile2idpool=0 >
		<cfquery name="addfile2idpool" datasource="#filedsn#">
			INSERT INTO FILETOIDPOOL
			(
				FILEID,
				ID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getfiles" access="public" returntype="query" hint="I get files and return a recordset: FILEID, TITLE, DESCRIPTION, PATH, FILENAME, TIMEDATE">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="id" required="false" type="string" hint="id of the video/podcast to which the file is associated">
		<cfset var files=0>
		<cfquery name="files" datasource="#filedsn#">
			SELECT 
				FILESFORMEDIA.FILEID,
				FILESFORMEDIA.TITLE,
				FILESFORMEDIA.DESCRIPTION,
				FILESFORMEDIA.PATH,
				FILESFORMEDIA.FILENAME,
				FILESFORMEDIA.TIMEDATE
			FROM FILESFORMEDIA, FILETOIDPOOL
			WHERE FILESFORMEDIA.FILEID=FILETOIDPOOL.FILEID
			<cfif isdefined('id')>
			AND FILETOIDPOOL.ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn files>
	</cffunction>

	<cffunction name="deletefile" access="public" returntype="void" hint="I delete files">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="fileid" required="true" type="String" hint="fileid of the file to be delete">
		<cfset var delete=0>
		<cfset var getfile=0>
		
		<cfquery name="getfile" datasource="#filedsn#">
			SELECT PATH, FILENAME FROM FILESFORMEDIA WHERE FILEID=<cfqueryparam value="#fileid#">
		</cfquery>
		<cfset filename=getfile.filename>
		<cfset path=getfile.path>
		<cfquery name="delete" datasource="#filedsn#">
			DELETE FROM 
			FILETOIDPOOL 
			WHERE FILEID=<cfqueryparam value="#fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="delete" datasource="#filedsn#">
			DELETE FROM 
			FILESFORMEDIA 
			WHERE FILEID=<cfqueryparam value="#fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cffile action = "delete" file = "#path##filename#">
	</cffunction>
	
	<cffunction name="updatefile" access="public" returntype="void" hint="I update file title and description">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="fileid" required="true" type="String" hint="id of the file">
		<cfargument name="title" required="true" type="String" hint="title of the file">
		<cfargument name="description" required="true" type="String" hint="description of the file">
		<cfquery name="update" datasource="#filedsn#">
			UPDATE FILESFORMEDIA
			SET 
			TITLE=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
			DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="getfilefromfileid" access="public" returntype="query" hint="I get file from fileid">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="fileid" required="true" type="string" hint="fileid of the file">
		<cfset var files=0>
		<cfquery name="files" datasource="#arguments.filedsn#">
			SELECT
				FILEID,
				TITLE,
				DESCRIPTION,
				PATH,
				FILENAME,
				TIMEDATE
			FROM FILESFORMEDIA
			WHERE FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn files>
	</cffunction>
	
	<cffunction name="getmyfiles" access="public" returntype="query" hint="I get files for a user">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the person">
		<cfargument name="fileid" required="false" default="0" type="String" hint="fileid of the file">
		<cfset var myfiles=0>
		<cfinvoke component="subscription" method="getmyvideos" subscriptiondsn="#arguments.filedsn#" nameid="#arguments.nameid#" returnvariable="myvideos">
		<cfset mylist=ValueList(myvideos.vid)>
		<cfquery name="files" datasource="#filedsn#">
			SELECT 
				FILESFORMEDIA.FILEID,
				FILESFORMEDIA.TITLE,
				FILESFORMEDIA.DESCRIPTION,
				FILESFORMEDIA.PATH,
				FILESFORMEDIA.FILENAME,
				FILESFORMEDIA.TIMEDATE
			FROM FILESFORMEDIA, FILETOIDPOOL
			WHERE FILESFORMEDIA.FILEID=FILETOIDPOOL.FILEID
			AND FILETOIDPOOL.ID IN (<cfqueryparam value="#mylist#" list="yes">)
			<cfif arguments.fileid NEQ 0>
			AND FILESFORMEDIA.FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn files>
	</cffunction>
	
	<cffunction name="addnonmediafile" access="public" returntype="String" hint="I add a non media file">
		<cfargument name="filedsn" required="true" type="String" hint="Data Source">
		<cfargument name="serverfilename" required="true" type="String" hint="Data Source">
		<cfargument name="displayname" required="true" type="String" hint="Data Source">
		<cfargument name="filecategoryid" required="false" type="String" default="0" hint="categoryid of the file">
		<cfargument name="filecategory" required="false" type="String" default="0" hint="Category of a file">
		<cfargument name="projectid" required="false" type="String" default="0" hint="Project id">
		<cfargument name="sortorder" required="false" type="String" default="0" hint="Sort order of the file">
		<cfset var add=0>
		
		<cfquery name="add" datasource="#arguments.filedsn#">
			INSERT INTO FILES
			(
				DISPLAYNAME,
				SERVERFILENAME,
				SORTORDER,
				LASTUPDATED
				<cfif filecategoryid NEQ 0>
				,FILECATEGORYID
				</cfif>
				<cfif filecategory NEQ 0>
				,FILECATEGORY
				</cfif>
				<cfif projectid NEQ 0>
				,PROJECTID
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.displayname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.serverfilename#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
				<cfif filecategoryid NEQ 0>
				,<cfqueryparam value="#arguments.filecategoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif filecategory NEQ 0>
				,<cfqueryparam value="#arguments.filecategory#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif projectid NEQ 0>
				,<cfqueryparam value="#arguments.projectid#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS FILEID
		</cfquery>
		<cfreturn add.fileid>
	</cffunction>
	
	<cffunction name="getnonmediafiles" access="public" returntype="query" hint="I get files based on inputs">
		<cfargument name="filedsn" required="true" type="String" default="0" hint="Data Source">
		<cfargument name="fileid" required="false" type="String" default="0" hint="id of the file">
		<cfargument name="serverfilename" required="false" type="String" default="0" hint="name of the actual">
		<cfargument name="displayname" required="false" type="String" default="0" hint="Display name of the file">
		<cfargument name="filecategoryid" required="false" type="String" default="0" hint="categoryid of the file">
		<cfargument name="filecategory" required="false" type="String" default="0" hint="Category of a file">
		<cfargument name="projectid" required="false" type="String" default="0" hint="Project id">
		<cfargument name="sortorder" required="false" type="String" default="0" hint="Sort order of the file">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.filedsn#">
			SELECT
				FILEID,
				DISPLAYNAME,
				SERVERFILENAME,
				SORTORDER,
				FILECATEGORYID,
				FILECATEGORY,
				PROJECTID,
				LASTUPDATED
			FROM FILES
			WHERE 1=1
			<cfif arguments.fileid NEQ 0>
				AND FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.displayname NEQ 0>
				AND DISPLAYNAME LIKE <cfqueryparam value="%#arguments.displayname#%" cfsqltype="cf_sql_varchar">	
			</cfif>
			<cfif arguments.serverfilename NEQ 0>
				AND SERVERFILENAME LIKE <cfqueryparam value="%#arguments.serverfilename#%" cfsqltype="cf_sql_varchar">	
			</cfif>
			<cfif arguments.sortorder NEQ 0>
				AND SORTORDER=<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.filecategoryid NEQ 0>
				AND FILECATEGORYID=<cfqueryparam value="#arguments.filecategoryid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.filecategory NEQ 0>
				AND FILECATEGORY=<cfqueryparam value="#arguments.filecategory#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.projectid NEQ 0>
				AND PROJECTID=<cfqueryparam value="#arguments.projectid#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY SORTORDER DESC
		</cfquery>
		<cfreturn get>	
	</cffunction>
	
	<cffunction name="editnonmediafile" access="public" returntype="void" hint="I edit non media files">
		<cfargument name="filedsn" required="true" type="String" default="0" hint="Data Source">
		<cfargument name="fileid" required="false" type="String" default="0" hint="id of the file">
		<cfargument name="displayname" required="false" type="String" default="0" hint="Display name of the file">
		<cfargument name="serverfilename" required="false" type="String" default="0" hint="Uploaded file name">
		<cfargument name="filecategoryid" required="false" type="String" default="0" hint="categoryid of the file">
		<cfargument name="filecategory" required="false" type="String" default="0" hint="Category of a file">
		<cfargument name="projectid" required="false" type="String" default="0" hint="Project id">
		<cfargument name="sortorder" required="false" type="String" default="0" hint="Sort order of the file">
		<cfset var edit=0>
		<cfquery name="edit" datasource="#arguments.filedsn#">
			UPDATE FILES
			SET LASTUPDATED=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			<cfif arguments.displayname NEQ 0>
				,DISPLAYNAME=<cfqueryparam value="#arguments.displayname#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.serverfilename NEQ 0>
				,SERVERFILENAME=<cfqueryparam value="#arguments.serverfilename#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.filecategoryid NEQ 0>
				,FILECATEGORYID=<cfqueryparam value="#arguments.filecategoryid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.filecategory NEQ 0>
				,FILECATEGORY=<cfqueryparam value="#arguments.filecategory#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.projectid NEQ 0>
				,PROJECTID=<cfqueryparam value="#arguments.projectid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.sortorder NEQ 0>
				,SORTORDER=<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="deletenonmediafile" access="public" returntype="void" hint="I delete non media files.">
		<cfargument name="filedsn" required="true" type="String" default="0" hint="Data Source">
		<cfargument name="fileid" required="false" type="String" default="0" hint="id of the file">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.filedsn#">
			DELETE FROM FILES WHERE FILEID=<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
</cfcomponent>