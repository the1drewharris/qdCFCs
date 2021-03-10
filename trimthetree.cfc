<cfcomponent hint="I have funcions for trimthetree.com">
	<cfobject component="timeDateConversion" name="variables.mytime">
	<cfobject component="qdDataMgr" name="variables.tblCheck">
	
	<cffunction name="createTrimTheTreeTables" returntype="void" output="true" access="public" hint="I create comment table">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
		<cfset var populate=0>

		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TREETYPE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TREETYPE
				(
					TREETYPEID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					IMAGE VARCHAR(512) NOT NULL
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TREEENV')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TREEENV
				(
					TREEENVID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					IMAGE VARCHAR(512) NOT NULL
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TREEMUSIC')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TREEMUSIC
				(
					TREEMUSICID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					MP3 VARCHAR(512) NOT NULL
				)
			</cfquery>
		</cfif>
		
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TREEORNAMENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TREEORNAMENT
				(
					ORNAMENTID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					NAME VARCHAR(512) NOT NULL,
					IMAGE VARCHAR(512) NOT NULL
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'XMASGREETING')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE XMASGREETING
				(
					XMASGREETINGID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					MYXMASGREETING VARCHAR(1024) NOT NULL
				)
			</cfquery>
		</cfif>
			
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'MYTREE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE MYTREE
				(
					MYTREEID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					NAMEID BIGINT NOT NULL,
					TREETYPEID INTEGER NOT NULL,
					TREEENVID INTEGER NOT NULL,
					TREEMUSICID INTEGER NOT NULL,
					XMASGREETINGID INTEGER NOT NULL
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'MYTREE_TREEOWNER_FK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE MYTREE 
				ADD CONSTRAINT MYTREE_NAME_FK 
				FOREIGN KEY(NAMEID) 
				REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'MYTREE_TREETYPE_FK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE MYTREE 
				ADD CONSTRAINT MYTREE_TREETYPE_FK 
				FOREIGN KEY(TREETYPEID) 
				REFERENCES TREETYPE(TREETYPEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'MYTREE_TREEENV_FK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE MYTREE 
				ADD CONSTRAINT MYTREE_TREEENV_FK 
				FOREIGN KEY(TREEENVID) 
				REFERENCES TREEENV(TREEENVID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'MYTREE_TREEMUSIC_FK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE MYTREE 
				ADD CONSTRAINT MYTREE_TREEMUSIC_FK 
				FOREIGN KEY(TREEMUSICID) 
				REFERENCES TREEMUSIC(TREEMUSICID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'MYTREE_XMASGREETING_FK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE MYTREE 
				ADD CONSTRAINT MYTREE_XMASGREETING_FK 
				FOREIGN KEY(XMASGREETINGID) 
				REFERENCES XMASGREETING(XMASGREETINGID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'MYTREEORNAMENTS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE MYTREEORNAMENTS
				(
					THISORNAMENTID INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
					MYTREEID INTEGER NOT NULL,
					ORNAMENTID INTEGER NOT NULL,
					XPOS DECIMAL(4,3) NOT NULL,
					YPOS DECIMAL(4,3) NOT NULL,
					ROTATION DECIMAL(4,3) NOT NULL,
					COLOR VARCHAR(8) NOT NULL,
					XSCALE DECIMAL(4,3) NOT NULL,
					YSCALE DECIMAL(4,3) NOT NULL
				)
			</cfquery>
		</cfif>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TREETOGROUP')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TREETOGROUP
				(
					TREETOGROUPID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
					MYTREEID INTEGER NOT NULL,
					GROUPID BIGINT NOT NULL
				)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="addXmasGreeting" access="public" output="false" returntype="string" hint="I add greeting to the db">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="xmasgreeting" type="string" required="true" hint="I am the greeting">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO XMASGREETING
			(
				MYXMASGREETING
			)
			VALUES
			(
				<cfqueryparam value="#arguments.greeting#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS GREETINGID
		</cfquery>
		<cfreturn add.GREETINGID>
	</cffunction>
	
	<cffunction name="getTree" returntype="query" output="false" access="public" hint="I get the tree data for the element(s) passed to me and return a recordset: mytreeid, nameid, treetypeid, treevid, treemusicid, xmasgreetingid">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="mytreeid" type="string" required="false" default="0" hint="I am the mytreeid you are looking for, I default to 0">
		<cfargument name="mynameid" type="string" required="false" default="0" hint="I am the nameid you are looking for, I default to 0">
		<cfset var getMyTree=0>
		<cfquery name="getMyTree" datasource="#arguments.ds#">
		SELECT 
			MYTREEID,
			NAMEID,
			TREETYPEID,
			TREEENVID,
			TREEMUSICID,
			XMASGREETINGID
		FROM MYTREE
		WHERE 1=1
		<cfif arguments.treeid neq 0>
		AND MYTREEID=<cfqueryparam value="#arguments.mytreeid#">
		</cfif>
		<cfif arguments.nameid neq 0>
		AND NAMEID=<cfqueryparam value="#arguments.mynameid#">
		</cfif>
		</cfquery>
	<cfreturn getMyTree>
	</cffunction>
	
	<cffunction name="addTree" returntype="string" output="false" access="public" hint="I add a new tree to the database">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="nameid" type="string" required="true" hint="I am the nameid of the person who is creating the tree">
		<cfargument name="treetypeid" type="string" required="true" hint="I am the type of the tree">
		<cfargument name="treeenvid" type="string" required="true" hint="I am the enviroment of the tree">
		<cfargument name="treemusicid" type="string" required="true" hint="I am the id of the music">
		<cfargument name="xmasgreetingid" type="string" required="true" hint="I am the id of the greeting">
		<cfset var create=0>
		<cfquery name="create" datasource="#arguments.ds#">
			INSERT INTO MYTREE
			(
				NAMEID,
				TREETYPEID,
				TREEENVID,
				TREEMUSICID,
				XMASGREETINGID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.treetypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.treeenvid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.treemusicid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.xmasgreetingid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS MYTREEID
		</cfquery>
		<cfreturn create.MYTREEID>
	</cffunction>
	
	<cffunction name="addOrnamentToTree" access="public" returntype="string" hint="I add ornament to tree">
		<cfargument name="ds" type="string" required="true" hint="data source">
		<cfargument name="mytreeid" type="string" required="true" hint="id of the tree">
		<cfargument name="ornamentid" type="string" required="true" hint="id of the ornament">
		<cfargument name="xpos" type="string" required="true" hint="x position of the ornament">
		<cfargument name="ypos" type="string" required="true" hint="y position of the ornament">
		<cfargument name="color" type="string" required="true" hint="color of the ornament">
		<cfargument name="xscale" type="string" required="true" hint="x scale">
		<cfargument name="yscale" type="string" required="true" hint="y scale">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO MYTREEORNAMENTS
			(
				MYTREEID,
				ORNAMENTID,
				XPOS,
				YPOS,
				ROTATION,
				COLOR,
				XSCALE,
				YSCALE
			)
			VALUES
			(
				<cfqueryparam value="#arguments.mytreeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.ornamentid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.xpos#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.ypos#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.rotation#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.color#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.xscale#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.yscale#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS THISORNAMENTID
		</cfquery>
		<cfreturn add.THISORNAMENTID>
	</cffunction>
	
	<cffunction name="treeToGroup" access="public" output="false" returntype="string" hint="I associate tree to a group">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="mytreeid" type="string" required="true"  hint="I am the id of the tree">
		<cfargument name="groupid" type="string" required="true" hint="I am the id of the group">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO TREETOGROUP
			(
				MYTREEID,
				GROUPID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.mytreeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS TREETOGROUPID
		</cfquery>
		<cfreturn ADD.TREETOGROUPID>
	</cffunction>
	
	<cffunction name="buildTree" returntype="void" output="false" access="public" hint="I build the xml tree for the treeid passed to me">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="mytreeid" type="string" required="true" hint="I am the id of the tree">
		<cfset var getTheTree=0>
		<cfset var getTheOrnaments=0>
		
		<cfquery name="getTheTree" datasource="#arguments.ds#">
			SELECT
				MYTREE.MYTREEID,
				MYTREE.NAMEID,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.WEMAIL,
				MYTREE.TREETYPEID,
			    TREETYPE.IMAGE AS TREEIMAGE,
				MYTREE.TREEENVID,
				TREEENV.IMAGE AS ENVIMAGE,
				MYTREE.TREEMUSICID,
				TREEMUSIC.MP3,
				MYTREE.XMASGREETINGID,
				XMASGREETING.MYXMASGREETING
			FROM MYTREE,NAME, TREETYPE, TREEENV, TREEMUSIC, XMASGREETING
			WHERE MYTREE.MYTREEID=<cfqueryparam value="#arguments.mytreeid#" cfsqltype="cf_sql_varchar"> 
			AND MYTREE.NAMEID=NAME.NAMEID
			AND MYTREE.TREETYPEID=TREETYPE.TREETYPEID
			AND MYTREE.TREEENVID=TREEENV.TREEENVID
			AND MYTREE.TREEMUSICID=TREEMUSIC.TREEMUSICID
			AND MYTREE.XMASGREETINGID=XMASGREETING.XMASGREETINGID
		</cfquery>
		
		<cfquery name="getTheOrnaments" datasource="#arguments.ds#">
			SELECT
				MYTREEORNAMENTS.THISORNAMENTID,
				MYTREEORNAMENTS.MYTREEID,
				MYTREEORNAMENTS.ORNAMENTID,
				MYTREEORNAMENTS.XPOS,
				MYTREEORNAMENTS.YPOS,
				MYTREEORNAMENTS.ROTATION,
				MYTREEORNAMENTS.COLOR,
				MYTREEORNAMENTS.XSCALE,
				MYTREEORNAMENTS.YSCALE,
				TREEORNAMENT.IMAGE
			FROM MYTREEORNAMENTS, TREEORNAMENT
			WHERE MYTREEID=<cfqueryparam value="#arguments.mytreeid#" cfsqltype="cf_sql_varchar">
			AND MYTREEORNAMENTS.ORNAMENTID=TREEORNAMENT.ORNAMENTID
		</cfquery>
		
		<cfif getTheTree.recordcount GT 0>
			<cfsavecontent variable="tree"><?xml version="1.0" encoding="ISO-8859-1"?>
				<cfoutput>
				<treeData treeID="#getTheTree.mytreeid#" Treetype="#getTheTree.treetypeid#" Treeimage="#getTheTree.treeimage#" sceneID="#getTheTree.treeenvid#" sceneimage="#getTheTree.envimage#" audioID="#getTheTree.treemusicid#" audiopath="#getTheTree.mp3#" firstname="#getTheTree.firstname#" lastname="#getTheTree.lastname#">
					<greeting>#getTheTree.MYXMASGREETING#</greeting>
					<ornaments>
					<cfloop query="getTheOrnaments">
						<ornament ornID="#THISORNAMENTID#" xPos="#XPOS#" yPos="#YPOS#" rot="#ROTATION#" color="#COLOR#" xScale="#XSCALE#" yScale="#YSCALE#" IMAGE="#IMAGE#"/>
					</cfloop>
					</ornaments>
				</treeData>
				</cfoutput>
			</cfsavecontent>
			<cfset filename="#mytreeid#.xml">
			<cffile action="write" mode="775" addnewline="no" file="/home/drew/domains/trimthetree.com/public_html/xml/#filename#" output="#tree#">
		</cfif>
	</cffunction>
</cfcomponent>