<cfcomponent hint="I build tables for systems">
	<cfobject component="timeDateConversion" name="variables.mytime">
	<cfobject component="qdDataMgr" name="variables.tblCheck">
	<cfset variables.statuslist="Published,Draft,Deactive,Shared">
	<cfset variables.productexcludelist="salesinamerica.com,aircoservice.com">
	<cfset variables.blogstatusList="Published,Draft,Deactive">
		
	<cffunction name="buildAllTables" returntype="void" output="false" access="public" hint="I check and add or update all the tables needed for qdcms">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfinvoke method="createaddressbooktables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createProductTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createCommentTables" ds="#arguments.ds#">
		<cfinvoke method="createSiteSecurityTables" ds="#arguments.ds#">
		<cfinvoke method="createModuleTables" ds="#arguments.ds#">
		<cfinvoke method="createLayoutTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createAdTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createBlogTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createCartTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createErrorTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createEventTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createFilesForMediaTables" ds="#arguments.ds#">
		<cfinvoke method="createApplicationTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createHauTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createImageTables" ds="#arguments.ds#">
		<cfinvoke method="createLinkTables" ds="#arguments.ds#">
		<cfinvoke method="createNavigationTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createNewsletterTables" ds="#arguments.ds#"> --->
		<!--- <cfinvoke method="createSubscriptionTables" ds="#arguments.ds#">
		<cfinvoke method="createSurveyTables" ds="#arguments.ds#">
		<cfinvoke method="createLastVisitsTables" ds="#arguments.ds#">
		<cfinvoke method="createVideoLibraryTables" ds="#arguments.ds#"> 
		<cfinvoke method="createContestTables" ds="#arguments.ds#">--->
		<cfinvoke method="createWebPageTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createCoupounTables" ds="#arguments.ds#">
		<cfinvoke method="createReviewTables" ds="#arguments.ds#">
		<cfinvoke method="createAudioLibTables" ds="#arguments.ds#">
		<cfinvoke method="createForumTables" ds="#arguments.ds#"> --->
		<cfinvoke method="createEmailServersTables" ds="#arguments.ds#">
		<cfinvoke method="createDashboardTables" ds="#arguments.ds#">
		<!--- <cfinvoke method="createShiftTables" ds="#arguments.ds#"> --->
	</cffunction>
	
	<cffunction name="createImageTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'image')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IMAGE
				(
					IMAGEID BIGINT NOT NULL IDENTITY(1,1),
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
		
		<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'image')>
			<cfquery name="addImagePK" datasource="#arguments.ds#">
			ALTER TABLE IMAGE ADD CONSTRAINT PK_IMAGE PRIMARY KEY(IMAGEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'IMAGE', 'LINK')>
			<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE IMAGE ADD LINK VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'IMAGE', 'FLASHGALLERY')>
			<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE IMAGE ADD FLASHGALLERY VARCHAR(1)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'IMAGE', 'SORTORDER')>
			<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE IMAGE ADD SORTORDER BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'imagecategory')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IMAGECATEGORY
				(
					IMAGECATEGORYID BIGINT NOT NULL IDENTITY(1,1),
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
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'image2imagecategory')>
			<cfquery name="create" datasource="#arguments.ds#">
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
		

		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'IMAGE2IMAGECATEGORY', 'SORTORDER')>
			<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE IMAGE2IMAGECATEGORY ADD SORTORDER BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'IMAGECATEGORY', 'SORTORDER')>
			<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE IMAGECATEGORY ADD SORTORDER BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'LOGOID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LOGOID BIGINT
				ALTER TABLE NAME ADD CONSTRAINT FK_NAME_IMAGE FOREIGN KEY(LOGOID) REFERENCES IMAGE(IMAGEID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createaddressbooktables" returntype="void" output="false" access="public" hint="create tables for addressbook">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NAME
				([NAMEID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[HEADNAMEID] [bigint] NULL,
				[COMPANY] [varchar](256) NULL,
				[FIRSTNAME] [varchar](256) NULL,
				[MAIDENNAME] [varchar] (256) NULL,
				[LASTNAME] [varchar](256) NULL,
				[LASTUPDATED] [varchar](16) NOT NULL,
				[DESCRIPTION] [ntext] NULL,
				[URL] [varchar](256) NULL,
				[MEMAIL] [varchar](256) NULL,
				[HEMAIL] [varchar](256) NULL,
				[WEMAIL] [varchar](256) NULL,
				[OEMAIL] [varchar](256) NULL,
				[MPHONE] [varchar](64) NULL,
				[WPHONE] [varchar](64) NULL,
				[HPHONE] [varchar](64) NULL,
				[OPHONE] [varchar](64) NULL,
				[FPHONE] [varchar](64) NULL,
				[PPHONE] [varchar](64) NULL,
				[ICQ] [varchar](256) NULL,
				[YAHOO] [varchar](256) NULL,
				[AOL] [varchar](256) NULL,
				[JABBER] [varchar](256) NULL,
				[MAC] [varchar](256) NULL,
				[MSN] [varchar](256) NULL,
				[LOGOID] [bigint] NULL,
				[GMAIL] [varchar](256) NULL,
				[DOB] [varchar](16) NULL,
				[GENDER] [bigint] NULL,
				[USERNAME] [varchar](256) NULL,
				[PASSWORD] [varchar](256) NULL,
				[MIDDLENAME] [varchar](256) NULL,
				[STATUS] [bit] NULL,
				[REFERREDBY] [varchar](256) NULL,
				[MARITALSTATUS] [bit] NULL,
				[SPOUSENAME] [varchar](256) NULL,
				[CLIENTUSERID] [varchar](16) NULL,
				[OLDID] [varchar](16) NULL,
				[AGENCYCATEGORYID] [varchar](16) NULL,
				[YEARSINBIZ] [bigint] NULL,
				[BIZEST] [varchar](8) NULL,
				[CCACCEPTED] [varchar](1024) NULL,
				[SLOGAN] [ntext] NULL,
				[TITLE] [varchar](256) NULL,
				[CREATEDBYID] [bigint] NULL,
				[TIMECREATED] [varchar](16) NULL,
				[LASTUPDATEDBYID] [bigint] NULL,
				[LASTLOGIN] [varchar](16) NULL,
				[ROLEID] [bigint] NULL,
				[TWITTER] [varchar](256) NULL,
				[LINKEDIN] [varchar](256) NULL,
				[YOUTUBE] [varchar](256) NULL,
				[PLAXO] [varchar](256) NULL,
				[MYSPACE] [varchar](256) NULL,
				[FRIENDFEED] [varchar](256) NULL,
				[HASREVIEWS] [BIT] DEFAULT 0
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','HASREVIEWS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD HASREVIEWS BIT DEFAULT 0
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','TWITTER')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD TWITTER VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','LINKEDIN')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LINKEDIN VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','YOUTUBE')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD YOUTUBE VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','PLAXO')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD PLAXO VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','FACEBOOK')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD FACEBOOK VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','MYSPACE')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD MYSPACE VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NAME','FRIENDFEED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD FRIENDFEED VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ADDRESS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE ADDRESS
				([ADDRESSID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[NAMEID] [bigint] NOT NULL,
				[ADDRESSTYPEID] [bigint] NOT NULL,
				[ADDRESS1] [varchar](256) NULL,
				[ADDRESS2] [varchar](256) NULL,
				[CITY] [varchar](256) NULL,
				[STATE] [varchar](50) NULL,
				[ZIP] [varchar](16) NULL,
				[LASTUPDATEDBYID] [bigint] NULL,
				[LASTUPDATED] [varchar](16) NULL,
				[OLDADDRESSID] [varchar](16) NULL,
				[LAT] [float] NULL,
				[LON] [float] NULL,
				[COUNTRY] [varchar](50) NULL,
				[INTERSECTION] [varchar](1024) NULL);
				
				ALTER TABLE ADDRESS 
				ADD CONSTRAINT ADDRESS_NAME 
				FOREIGN KEY(NAMEID) 
				REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>

		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'ADDRESS', 'COUNTRY')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE ADDRESS ADD COUNTRY VARCHAR(50)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'ADDRESS', 'INTERSECTION')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE ADDRESS ADD INTERSECTION VARCHAR(1024)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'YEARSINBIZ')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD YEARSINBIZ BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'STATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD STATUS BIT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'MAIDENNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD MAIDENNAME VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'BIZEST')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD BIZEST VARCHAR(8)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'CCACCEPTED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD CCACCEPTED VARCHAR(1024)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'SLOGAN')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD SLOGAN NTEXT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'TITLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD TITLE VARCHAR(256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'LOGOID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LOGOID BIGINT;
				
				ALTER TABLE NAME 
				ADD CONSTRAINT FK_NAME_LOGOID 
				FOREIGN KEY(LOGOID) 
				REFERENCES IMAGE(IMAGEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'TIMECREATED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD TIMECREATED BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'LASTLOGIN')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LASTLOGIN BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NAME', 'LASTUPDATED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NAME ADD LASTUPDATED BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.viewExists('#arguments.ds#', 'vwNameAddress')>
			<cfquery name="create" datasource="#arguments.ds#">
				create view vwNameAddress as
				        select
				            n.nameid,
				            n.firstname,
				            n.lastname,
							n.company,
							n.lastupdated,
							n.url as contacturl,
							n.memail,
							n.hemail,
							n.wemail,
							n.oemail,
							n.mphone,
							n.wphone,
							n.hphone,
							n.fphone,
							n.icq,
							n.yahoo,
							n.aol,
							n.mac,
							n.msn,
							n.gmail,
							n.dob,
							n.gender,
							n.username,
							n.password,
							n.status as contactstatus,
							n.maritalstatus,
							n.spousename,
							n.clientuserid,
							n.yearsinbiz,
							n.bizest,
							n.ccaccepted,
							n.slogan,
							a.addressid,
				            a.address1,
							a.address2,
				            a.city,
				            a.state,
							a.zip,
							a.lat,
							a.lon,
							a.country,
							a.intersection
				        from
				            name n
				        inner join
				            address a
				                on n.nameid = a.nameid
			</cfquery>
		</cfif>

		<cfif not variables.tblcheck.tableExists('#arguments.ds#','USERACTIVATION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE USERACTIVATION
				(
					ACTIVATIONCODE VARCHAR(64) NOT NULL,
					NAMEID BIGINT NOT NULL,
					EXPIRYDATE VARCHAR(16) NOT NULL,
					ACTIVATEDON VARCHAR(16) NOT NULL DEFAULT 'NOT ACTIVATED'
				);
				ALTER TABLE USERACTIVATION ADD CONSTRAINT PK_USERACTIVATION PRIMARY KEY (ACTIVATIONCODE);
				ALTER TABLE USERACTIVATION ADD CONSTRAINT FK_USERACTIVATION_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERACTIVATION', 'ACTIVATEDON')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERACTIVATION ADD ACTIVATEDON VARCHAR(16) NOT NULL DEFAULT 'NOT ACTIVATED'
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'USERGROUPS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE USERGROUPS
				(
					[USERGROUPID] [varchar](16) NOT NULL,
					[USERGROUPNAME] [varchar](128) NOT NULL,
					[USERGROUPDESCRIPTION] [ntext] NULL,
					[PARENTUSERGROUPID] [varchar](16) DEFAULT('0') NULL,
					[KEYWORDS] [ntext] NULL,
					[NAMEID] [bigint] NULL,
					[STATUS] [varchar](128) NULL,
					[CREATEDBYID] [varchar](16) NULL
				);
				
				ALTER TABLE USERGROUPS 
				WITH CHECK 
				ADD  CONSTRAINT FK_NAME_USERGROUP
				FOREIGN KEY(NAMEID)
				REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERGROUPS', 'USERGROUPDESCRIPTION')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERGROUPS ADD USERGROUPDESCRIPTION NTEXT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERGROUPS', 'PARENTUSERGROUPID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERGROUPS ADD PARENTUSERGROUPID VARCHAR(16) DEFAULT('0')
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERGROUPS', 'KEYWORDS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERGROUPS ADD KEYWORDS NTEXT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERGROUPS', 'STATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERGROUPS ADD STATUS VARCHAR(16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'USERGROUPS', 'NAMEID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE USERGROUPS ADD NAMEID BIGINT;
				
				ALTER TABLE USERGROUPS 
				WITH CHECK 
				ADD  CONSTRAINT FK_NAME_USERGROUP
				FOREIGN KEY(NAMEID)
				REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="createProductTables" returntype="void" output="false" access="public" hint="I create product Tables">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create = 0>
		<cfset var drop = 0>
		
		<cfif not listcontainsnocase('#variables.productexcludelist#', '#arguments.ds#')>
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'IDPOOL')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE IDPOOL
					(
						ID BIGINT IDENTITY(0,1) NOT NULL PRIMARY KEY,
						IDFOR VARCHAR(64) NOT NULL,
						ITEMNAME VARCHAR(256) NOT NULL,
						SUBSCRIABLE BIT NOT NULL DEFAULT 0,
						STOPSELLING BIT NOT NULL DEFAULT 0
					);
					INSERT INTO IDPOOL(IDFOR, ITEMNAME,SUBSCRIABLE, STOPSELLING) VALUES ('All videos', 'All videos', 1, <cfqueryparam value="#variables.mytime.createTimeDate()#">);
					INSERT INTO IDPOOL(IDFOR, ITEMNAME,SUBSCRIABLE, STOPSELLING) VALUES ('All Podcast', 'All Podcasts', 1, <cfqueryparam value="#variables.mytime.createTimeDate()#">);
				</cfquery>
			</cfif>
			
			<cfif variables.tblCheck.columnExists('#arguments.ds#', 'PRODUCTCATEGORY', 'PRODUCTCATEGORYID')>
				<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE PRODUCTCATEGORY
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRODUCTCATEGORY')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRODUCTCATEGORY
					(
						CATEGORYID INT IDENTITY(1,1) PRIMARY KEY,
						CATEGORY VARCHAR(128) NOT NULL UNIQUE,
						PARENTID INT,
						NESTLEVEL INT NOT NULL,
						SORTORDER VARCHAR(2048) NOT NULL
					);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCTCATEGORY','PARENTID')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCTCATEGORY ADD PARENTID INT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCTCATEGORY','NESTLEVEL')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCTCATEGORY ADD NESTLEVEL INT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCTCATEGORY','SORTORDER')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCTCATEGORY ADD SORTORDER VARCHAR(2048)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRICENAMES')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRICENAMES
					(
						PRICENAMEID INT IDENTITY(1,1) PRIMARY KEY,
						PRICENAME VARCHAR(32) UNIQUE NOT NULL
					);
					INSERT INTO PRICENAMES (PRICENAME) VALUES('Retail');
					INSERT INTO PRICENAMES (PRICENAME) VALUES('Reseller');
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRODUCT')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRODUCT
					(
						ID BIGINT NOT NULL PRIMARY KEY, 
						CATEGORYID INT NOT NULL,
						QUANTITY INT NOT NULL,
						DESCRIPTION NTEXT,
						ATTRIBUTES NTEXT
					)
					ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
					ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_PRODUCTCAT FOREIGN KEY(CATEGORYID) REFERENCES PRODUCTCATEGORY(CATEGORYID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCT','TEASER')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCT ADD TEASER NTEXT;
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCT','CLIENTPRODUCTID')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCT ADD CLIENTPRODUCTID VARCHAR(64);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','PRODUCT','WEIGHT')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE PRODUCT ADD WEIGHT FLOAT;
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ITEMIMAGES')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE ITEMIMAGES
					(
						ID BIGINT NOT NULL,
						IMAGEID BIGINT NOT NULL
					)
					ALTER TABLE ITEMIMAGES ADD PRIMARY KEY(ID, IMAGEID);
					ALTER TABLE ITEMIMAGES ADD CONSTRAINT ITEMIMAGES_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#','ITEMIMAGES','SORTORDER')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE ITEMIMAGES ADD SORTORDER INT DEFAULT 1
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRODUCTLOG')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRODUCTLOG
					(
						ID BIGINT NOT NULL,
						QUANTITY INTEGER NOT NULL,
						NAMEID BIGINT NOT NULL,
						TIMEDATE VARCHAR(16) NOT NULL
					);
					ALTER TABLE PRODUCTLOG ADD CONSTRAINT PRODUCTLOG_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRODUCTGROUP')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRODUCTGROUP
					(
						ID BIGINT NOT NULL,
						PRODUCTID BIGINT NOT NULL
					);
					ALTER TABLE PRODUCTGROUP ADD PRIMARY KEY(ID, PRODUCTID);
					ALTER TABLE PRODUCTGROUP ADD CONSTRAINT PRODUCTGROUP_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
					ALTER TABLE PRODUCTGROUP ADD CONSTRAINT PRODUCTGROUP_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT(ID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRICE')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE PRICE
					(
						ID BIGINT NOT NULL,
						PRICENAMEID INT NOT NULL,
						PRICE FLOAT NOT NULL,
						TIMEDATE VARCHAR(16) NOT NULL,
						ACTIVE BIT DEFAULT 1
					);
					ALTER TABLE PRICE ADD CONSTRAINT PRICE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
					ALTER TABLE PRICE ADD CONSTRAINT PRICE_PRCENAMES FOREIGN KEY(PRICENAMEID) REFERENCES PRICENAMES(PRICENAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TRANSACTIONS')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE TRANSACTIONS
					(
						TRANSACTIONID BIGINT PRIMARY KEY,
						BUYERID BIGINT NOT NULL,
						NAMEID BIGINT NOT NULL,
						TRANSACTIONTOTAL FLOAT NOT NULL,
						DATETIME VARCHAR(16) NOT NULL
					);
					ALTER TABLE TRANSACTIONS ADD CONSTRAINT TRANSACTIONS_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
					ALTER TABLE TRANSACTIONS ADD CONSTRAINT TRANSACTIONS_BUYERNAME FOREIGN KEY(BUYERID) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.constraintExists('#arguments.ds#', 'TRANSACTIONS')>
				<cfquery name="addTRANSACTIONSPK" datasource="#arguments.ds#">
				ALTER TABLE TRANSACTIONS ADD CONSTRAINT PK_TRANSACTIONS PRIMARY KEY(TRANSACTIONID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SALESRECORD')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE SALESRECORD
					(
						ID BIGINT NOT NULL,
						TRANSACTIONID BIGINT NOT NULL,
						UNITPRICE FLOAT NOT NULL,
						QUANTITY INT NOT NULL,
						DISCOUNTPERCENT FLOAT DEFAULT 0,
						DISCOUNT FLOAT DEFAULT 0,
						OTHERCHARGES FLOAT DEFAULT 0,
						TOTAL FLOAT NOT NULL,
						REMARKS VARCHAR(256) NOT NULL DEFAULT 'Sold'
					);
					ALTER TABLE SALESRECORD ADD CONSTRAINT PK_SALESRECORD PRIMARY KEY(ID, TRANSACTIONID);
					ALTER TABLE SALESRECORD ADD CONSTRAINT SALESRECORD_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
					ALTER TABLE SALESRECORD ADD CONSTRAINT SALESRECORD_TRANSACTIONS FOREIGN KEY(TRANSACTIONID) REFERENCES TRANSACTIONS(TRANSACTIONID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'RETURNEDPRODUCT')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE RETURNEDPRODUCT
					(
						TRANSACTIONID BIGINT NOT NULL,
						ID BIGINT NOT NULL,
						REFUNDPERCENT FLOAT NOT NULL,
						REFUNDAMOUNT  FLOAT NOT NULL,
						REASONOFRETURN NTEXT NOT NULL,
						NAMEID BIGINT NOT NULL,
						DATETIME FLOAT NOT NULL
					);
					ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_TRANSACTION FOREIGN KEY(TRANSACTIONID) REFERENCES TRANSACTIONS(TRANSACTIONID);
					ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
					ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'DAMAGED')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE DAMAGED
					(
						ID BIGINT NOT NULL,
						DESCRIPTION NTEXT NOT NULL,
						NAMEID BIGINT NOT NULL,
						DATETIME VARCHAR(16) NOT NULL
					);
					ALTER TABLE DAMAGED ADD CONSTRAINT DAMAGED_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
					ALTER TABLE DAMAGED ADD CONSTRAINT DAMAGED_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>	
			
			<cfif  variables.tblCheck.columnExists('#arguments.ds#', 'PRODUCT2PRODUCTCATEGORY', 'PRODUCTID')>
				<cfquery name="dropproduct2productcategory" datasource="#arguments.ds#">
					DROP TABLE PRODUCT2PRODUCTCATEGORY;
				</cfquery>
			</cfif>	
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PRODUCT2PRODUCTCATEGORY')>
				<cfquery name="dropproduct2productcategory" datasource="#arguments.ds#">
					CREATE TABLE PRODUCT2PRODUCTCATEGORY
					(
						ID BIGINT NOT NULL,
						CATEGORYID INT NOT NULL
					);
					ALTER TABLE PRODUCT2PRODUCTCATEGORY ADD CONSTRAINT PK_PRODUCT2PRODUCTCATEGORY PRIMARY KEY(ID, CATEGORYID);
					ALTER TABLE PRODUCT2PRODUCTCATEGORY ADD CONSTRAINT FK_ID_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
					ALTER TABLE PRODUCT2PRODUCTCATEGORY ADD CONSTRAINT FK_CATEGORYID_PRODUCTCATEGORY FOREIGN KEY(CATEGORYID) REFERENCES PRODUCTCATEGORY(CATEGORYID);
				</cfquery>
			</cfif>	
			
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createCommentTables" returntype="void" output="false" access="public" hint="I create comment table">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
		<cfset var populate=0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'COMMENT')>
			<cfquery name="create" datasource="#arguments.ds#">
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
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD BLOGENTRYID BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYCOMMENTEMAIL')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD BLOGENTRYCOMMENTEMAIL VARCHAR (256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'CREATEDON')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD CREATEDON VARCHAR (16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYCOMMENTYOURNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD BLOGENTRYCOMMENTYOURNAME VARCHAR (256)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'LASTUPDATED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD LASTUPDATED VARCHAR (16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'QUOTEID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD QUOTEID BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'COMMENTSORT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE COMMENTSORT
				(
					COMMENTID VARCHAR(16) NOT NULL,
					PARENTID VARCHAR(16),
					NOOFREPLIES INTEGER NOT NULL DEFAULT 0,
					SORTORDER VARCHAR(256) NOT NULL
				)
				ALTER TABLE COMMENTSORT ADD CONSTRAINT PK_COMMENTSORT PRIMARY KEY(COMMENTID);
				ALTER TABLE COMMENTSORT ADD CONSTRAINT FK_COMMENTSORT_COMMENT1 FOREIGN KEY(COMMENTID) REFERENCES COMMENT(COMMENTID);
				ALTER TABLE COMMENTSORT ADD CONSTRAINT FK_COMMENTSORT_COMMENT2 FOREIGN KEY(PARENTID) REFERENCES COMMENT(COMMENTID);
			</cfquery>
			<cfquery name="populate" datasource="#arguments.ds#">
				INSERT INTO COMMENTSORT
				(
					COMMENTID,
					SORTORDER
				)
				SELECT COMMENTID, COMMENTID FROM COMMENT
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createModuleTables" returntype="void" output="false" access="public" hint="I create Module table">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'MODULES')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE MODULES
				(
					MODULEID INT NOT NULL IDENTITY(1,1),
					NAME VARCHAR(32) NOT NULL,
					DESCRIPTION NTEXT,
					CFC VARCHAR(256),
					CUSTOMTAGS VARCHAR(256)
				);
				ALTER TABLE MODULES ADD CONSTRAINT PK_MODULES PRIMARY KEY(MODULEID);
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="createSiteSecurityTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SITESECURITY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SITESECURITY
				(
					SECURITYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					MASTERNAMEID BIGINT NOT NULL,
					EMAIL VARCHAR(256) NOT NULL,
					FIRSTNAME VARCHAR(256) NOT NULL,
					LASTNAME VARCHAR(256) NOT NULL,
					USERNAME VARCHAR(256) NOT NULL UNIQUE,
					PASS VARCHAR(256) NOT NULL,
					STATUS TINYINT NOT NULL DEFAULT 1
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SECURITYROLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SECURITYROLE
				(
					ROLEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SECURITYROLE VARCHAR(128) NOT NULL
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'USER2ROLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE USER2ROLE
				(
					ROLEID BIGINT NOT NULL,
					SECURITYID BIGINT NOT NULL
				);
				
				ALTER TABLE USER2ROLE ADD PRIMARY KEY(ROLEID, SECURITYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SEC2ROLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SEC2ROLE
				(
					SEC VARCHAR(128) NOT NULL,
					ROLEID BIGINT NOT NULL,
					SITEID VARCHAR(16) NOT NULL
				);
				
				ALTER TABLE SEC2ROLE ADD PRIMARY KEY(SEC, ROLEID, SITEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'MOD2ROLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE MOD2ROLE
				(
					MOD VARCHAR(128) NOT NULL,
					ROLEID BIGINT NOT NULL,
					SITEID VARCHAR(16) NOT NULL
				);
				
				ALTER TABLE MOD2ROLE ADD PRIMARY KEY(MOD, ROLEID, SITEID);
			
				ALTER TABLE USER2ROLE ADD CONSTRAINT FK_USERROLE_SECURITYID FOREIGN KEY(SECURITYID) REFERENCES SITESECURITY(SECURITYID);
				ALTER TABLE USER2ROLE ADD CONSTRAINT FK_USERROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES SECURITYROLE(ROLEID);
				ALTER TABLE SEC2ROLE ADD CONSTRAINT FK_SECROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES SECURITYROLE(ROLEID);
				ALTER TABLE MOD2ROLE ADD CONSTRAINT FK_MODROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES SECURITYROLE(ROLEID);	
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createNewSecurityTables" returntype="void" output="false" access="public" hint="I create Module security table">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create=0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_PRODUCTS')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_PRODUCTS
				(
					PRODUCTID BIGINT NOT NULL IDENTITY(1,1),
					PRODUCT_NAME VARCHAR(64) NOT NULL UNIQUE,
					DESCRIPTION NTEXT
				)
				ALTER TABLE QD_PRODUCTS ADD CONSTRAINT PK_QD_PRODUCTS PRIMARY KEY(PRODUCTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_SECTIONS')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_SECTIONS
				(
					SECTIONID BIGINT NOT NULL IDENTITY(1,1),
					SECTION_NAME VARCHAR(32) NOT NULL UNIQUE,
					CAPTION VARCHAR(64),
					DESCRIPTION NTEXT
				);
				ALTER TABLE QD_SECTIONS ADD CONSTRAINT PK_QD_SECTIONS PRIMARY KEY(SECTIONID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_SECTIONS_TO_QD_PRODUCTS')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_SECTIONS_TO_QD_PRODUCTS
				(
					PRODUCTID BIGINT NOT NULL,
					SECTIONID BIGINT NOT NULL,
					SORTORDER INT NOT NULL DEFAULT 10000
				);
				ALTER TABLE QD_SECTIONS_TO_QD_PRODUCTS ADD CONSTRAINT PK_QD_SECTIONS_TO_QD_PRODUCTS PRIMARY KEY(PRODUCTID,SECTIONID);
				ALTER TABLE QD_SECTIONS_TO_QD_PRODUCTS ADD CONSTRAINT FK_QD_SECTIONS_TO_QD_PRODUCTS_QD_PRODUCTS FOREIGN KEY(PRODUCTID) REFERENCES QD_PRODUCTS(PRODUCTID);
				ALTER TABLE QD_SECTIONS_TO_QD_PRODUCTS ADD CONSTRAINT FK_QD_SECTIONS_TO_QD_PRODUCTS_QD_SECTIONS FOREIGN KEY(SECTIONID) REFERENCES QD_SECTIONS(SECTIONID);
			 </cfquery>
		 </cfif>
		 
		 <cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_MODULES_TO_QD_SECTIONS')>
			 <cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_MODULES
				(
					MODULEID BIGINT NOT NULL IDENTITY(1,1),
					MODULE_NAME VARCHAR(32) NOT NULL UNIQUE,
					CAPTION VARCHAR(64),
					DESCRIPTION NTEXT,
					STATUS BIT NOT NULL,
					DB_UPDATE_REQUIRED BIT NOT NULL
				);
				ALTER TABLE QD_MODULES ADD CONSTRAINT PK_QD_MODULES PRIMARY KEY(MODULEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_MODULES_TO_QD_SECTIONS')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_MODULES_TO_QD_SECTIONS
				(
					ID BIGINT NOT NULL IDENTITY(1,1),
					SECTIONID BIGINT NOT NULL,
					MODULEID BIGINT NOT NULL,
					SORTORDER INT NOT NULL DEFAULT 10000
				);
				ALTER TABLE QD_MODULES_TO_QD_SECTIONS ADD CONSTRAINT PK_QD_MODULES_TO_QD_SECTIONS PRIMARY KEY(ID);
				ALTER TABLE QD_MODULES_TO_QD_SECTIONS ADD CONSTRAINT FK_QD_MODULES_TO_QD_SECTIONS_QD_SECTIONS FOREIGN KEY(SECTIONID) REFERENCES SECTIONS(SECTIONID);
				ALTER TABLE QD_MODULES_TO_QD_SECTIONS ADD CONSTRAINT FK_QD_MODULES_TO_QD_SECTIONS_QD_MODULES FOREIGN KEY(MODULEID) REFERENCES QD_MODULES(MODULEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_MODULES_TO_SITE')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_MODULES_TO_SITE
				(
					ID BIGINT NOT NULL IDENTITY(1,1),
					SITEID VARCHAR(16) NOT NULL,
					MODULEID BIGINT NOT NULL
				);
				ALTER TABLE QD_MODULES_TO_SITE ADD CONSTRAINT PK_QD_MODULES_TO_SITE PRIMARY KEY(ID);
				ALTER TABLE QD_MODULES_TO_SITE ADD CONSTRAINT FK_QD_MODULES_TO_SITE_SITE FOREIGN KEY(SITEID) REFERENCES SITE(SITEID);
				ALTER TABLE QD_MODULES_TO_SITE ADD CONSTRAINT FK_QD_MODULES_TO_SITE_QD_MODULES FOREIGN KEY(MODULEID) REFERENCES QD_MODULES(MODULEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_MODULES_TO_USER')>
			<cfquery name="create" datasource="deltasystem">
				CREATE TABLE QD_MODULES_TO_USER
				(
					ID BIGINT NOT NULL IDENTITY(1,1),
					NAMEID BIGINT NOT NULL,
					SITEID VARCHAR(16) NOT NULL,
					MODULEID BIGINT NOT NULL,
					PERMISSION INT DEFAULT 3
				);
				ALTER TABLE QD_MODULES_TO_USER ADD CONSTRAINT PK_QD_MODULES_TO_USER PRIMARY KEY(MODULE_TO_USERID);
				ALTER TABLE QD_MODULES_TO_USER ADD CONSTRAINT FK_QD_MODULES_TO_USER_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
				ALTER TABLE QD_MODULES_TO_USER ADD CONSTRAINT FK_QD_MODULES_TO_USER_SITE FOREIGN KEY(SITEID) REFERENCES SITE(SITEID);
				ALTER TABLE QD_MODULES_TO_USER ADD CONSTRAINT FK_QD_MODULES_TO_USER_QD_MODULES FOREIGN KEY(MODULEID) REFERENCES QD_MODULES(MODULEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SECURITYROLE')>
			<cfquery name="create" datasource="deltasystem">		
				CREATE TABLE SECURITYROLE
				(
					ROLEID BIGINT NOT NULL IDENTITY(1,1),
					SECURITYROLE VARCHAR(128) NOT NULL UNIQUE
				);
				ALTER TABLE SECURITYROLE ADD CONSTRAINT PK_SECURITYROLE PRIMARY KEY(ROLEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QD_MODULES_TO_ROLE')>
			<cfquery name="create" datasource="deltasystem">			
				CREATE TABLE QD_MODULES_TO_ROLE
				(
					ROLEID BIGINT NOT NULL,
					MODULEID BIGINT NOT NULL,
					PERMISSION INT DEFAULT 3
				);
				ALTER TABLE QD_MODULES_TO_ROLE ADD CONSTRAINT PK_QD_MODULES_TO_ROLE(ROLEID,MODULEID,PERMISSION);
				ALTER TABLE QD_MODULES_TO_ROLE ADD CONSTRAINT FK_QD_MODULES_TO_ROLE_QD_MODULES(MODULEID) REFERENCES QD_MODULES(MODULEID);
				ALTER TABLE QD_MODULES_TO_ROLE ADD CONSTRAINT FK_QD_MODULES_TO_ROLE_SECURITYROLE(ROLEID) REFERENCES SECURITYROLE(ROLEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'USER_TO_ROLE')>
			<cfquery name="create" datasource="deltasystem">	
				CREATE TABLE USER_TO_ROLE
				(
					SITEID VARCHAR(16) NOT NULL,
					NAMEID BIGINT NOT NULL,
					ROLEID BIGINT NOT NULL
				)
				ALTER TABLE USER_TO_ROLE ADD CONSTRAINT PK_USER_TO_ROLE(SITEID,NAMEID);
				ALTER TABLE USER_TO_ROLE ADD CONSTRAINT FK_USER_TO_ROLE_SITE(SITEID) REFERENCES SITE(SITEID);
				ALTER TABLE USER_TO_ROLE ADD CONSTRAINT FK_USER_TO_ROLE_NAME(NAMEID) REFERENCES NAME(NAMEID);
				ALTER TABLE USER_TO_ROLE ADD CONSTRAINT FK_USER_TO_ROLE_ROLE(ROLEID) REFERENCES NAME(ROLEID);
			</cfquery> 
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createLayoutTables" returntype="void" output="false" access="public" hint="I create layout tables">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'LAYOUT')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE LAYOUT
					(
						LAYOUTID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
						TITLE NTEXT NOT NULL,
						DESCRIPTION NTEXT NOT NULL,
						FILENAME NTEXT NOT NULL,
						SCREENSHOTPATH NTEXT NOT NULL
					)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ZONECONTAINER')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE ZONECONTAINER
					(
						ZONECONTAINERID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
						HEIGHT INT NOT NULL,
						WIDTH INT NOT NULL,
						COLOR INT,
						BGCOLOR INT,
						DESCRIPTION NTEXT,
						CSSID VARCHAR(256) NOT NULL,
						MAXZONES INT NOT NULL DEFAULT 1
					)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'LAYOUTTOZONECONTAINER')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE LAYOUTTOZONECONTAINER
		            (
		                LAYOUTID INT NOT NULL,
		                ZONECONTAINERID INT NOT NULL    
		            )
		            ALTER TABLE LAYOUTTOZONECONTAINER ADD PRIMARY KEY(LAYOUTID, ZONECONTAINERID);
		            ALTER TABLE LAYOUTTOZONECONTAINER ADD FOREIGN KEY(LAYOUTID) REFERENCES LAYOUT(LAYOUTID);
		            ALTER TABLE LAYOUTTOZONECONTAINER ADD FOREIGN KEY(ZONECONTAINERID) REFERENCES ZONECONTAINER(ZONECONTAINERID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ZONES')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE ZONES
					(
						ZONEID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
						ZONECONTAINERID INT NOT NULL,
						DESCRIPTION NTEXT,
						MODULEID INT NOT NULL
					);
					
					ALTER TABLE ZONES ADD FOREIGN KEY(ZONECONTAINERID) REFERENCES ZONECONTAINER(ZONECONTAINERID);
					ALTER TABLE ZONES ADD FOREIGN KEY(MODULEID) REFERENCES MODULES(MODULEID);
				</cfquery>
			</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createAdTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'BANNERAD')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE BANNERAD
				(
					ADID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					ADNAME VARCHAR(256) NOT NULL,
					ADVERTISER_NAMEID BIGINT NOT NULL,
					ZONEID INT NOT NULL,
					TARGET_URL NTEXT NOT NULL,
					IMAGE_PATH VARCHAR(256),
					DISPLAYTEXT NTEXT
				);
				ALTER TABLE BANNERAD ADD FOREIGN KEY(ZONEID) REFERENCES ZONES(ZONEID);
				ALTER TABLE BANNERAD ADD FOREIGN KEY(ADVERTISER_NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'RENEWAD')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE RENEWAD
				(
					RENEWID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					ADID BIGINT NOT NULL,
					RECORDEDON VARCHAR(16) NOT NULL,
					ACTIVATEDON VARCHAR(16) DEFAULT 'Not Activated',
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16),
					MAXCLICK BIGINT DEFAULT 0,
					MAXIMPRESSION BIGINT DEFAULT 0,
					CHECK_DATE BIT DEFAULT 0,
					ACTIVE BIT DEFAULT 0
				);
				ALTER TABLE RENEWAD ADD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'DELETEDADS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE DELETEDADS
				(
					ADID BIGINT NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL,
					DELETED BIT NOT NULL
				)
				ALTER TABLE DELETEDADS ADD FOREIGN KEY (ADID) REFERENCES BANNERAD(ADID);
				<!--- EXEC sp_rename 'DELETEDADS.DATETIME', TIMEDATE, 'COLUMN' --->
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'IMPRESSION_RECORD')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IMPRESSION_RECORD
				(
					ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					ADID BIGINT NOT NULL,
					CLICK BIT DEFAULT 0,
					CFID VARCHAR(16) NOT NULL,
					IPADDRESS VARCHAR(24) NOT NULL,
					RECORDEDON  VARCHAR(16) NOT NULL,
					ZONEID INT
				)
				ALTER TABLE IMPRESSION_RECORD ADD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'IMPRESSION_TEMP')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IMPRESSION_TEMP
				(
					ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					ADID BIGINT NOT NULL,
					CLICK BIT DEFAULT 0,
					CFID VARCHAR(16) NOT NULL,
					IPADDRESS VARCHAR(24) NOT NULL,
					RECORDEDON  VARCHAR(16) NOT NULL,
					ZONEID INT
				)
				ALTER TABLE IMPRESSION_TEMP ADD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'IMPRESSION_COUNTS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IMPRESSION_COUNTS
				(
					ADID BIGINT NOT NULL,
					NOOFCLICKS BIGINT NOT NULL DEFAULT 0,
					NOOFIMPRESSIONS BIGINT NOT NULL DEFAULT 0,
					NOOFUNIQUEIMPRESSIONS BIGINT NOT NULL DEFAULT 0
				)
				ALTER TABLE IMPRESSION_COUNTS ADD CONSTRAINT PK_IMPRESSION_COUNTS PRIMARY KEY(ADID);
				ALTER TABLE IMPRESSION_COUNTS ADD CONSTRAINT FK_IMPRESSION_COUNTS_BANNERAD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'DAILY_IMPRESSIONS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE DAILY_IMPRESSIONS
				(
					ADID BIGINT NOT NULL, 
					IMPRESSIONDATE BIGINT NOT NULL, 
					NOOFIMPRESSIONS BIGINT NOT NULL, 
					NOOFUNIQUEIMPRESSIONS BIGINT NOT NULL, 
					NOOFCLICKS BIGINT NOT NULL
				);
				ALTER TABLE DAILY_IMPRESSIONS ADD CONSTRAINT PK_DAILY_IMPRESSIONS PRIMARY KEY(ADID,IMPRESSIONDATE);
				ALTER TABLE DAILY_IMPRESSIONS ADD CONSTRAINT FK_DAILY_IMPRESSIONS_BANNERAD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblcheck.columnExists('#arguments.ds#','IMPRESSION_RECORD','ZONEID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE IMPRESSION_RECORD ADD ZONEID INT
				ALTER TABLE IMPRESSION_RECORD ADD CONSTRAINT FK_IMPRESSION_RECORD_ZONES FOREIGN KEY(ZONEID) REFERENCES ZONES (ZONEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'AD_TO_ZONE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE AD_TO_ZONE
				(
					ADID BIGINT NOT NULL,
					ZONEID INT NOT NULL
				)
				ALTER TABLE AD_TO_ZONE ADD CONSTRAINT PK_AD_TO_ZONE PRIMARY KEY(ADID, ZONEID);
				ALTER TABLE AD_TO_ZONE ADD CONSTRAINT FK_AD_TO_ZONE_BANNERAD FOREIGN KEY(ADID) REFERENCES BANNERAD(ADID);
				ALTER TABLE AD_TO_ZONE ADD CONSTRAINT FK_AD_TO_ZONE_ZONES FOREIGN KEY (ZONEID) REFERENCES ZONES(ZONEID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
		
	<cffunction name="createBlogTables" returntype="void" output="false" access="public" hint="I create blog Tables">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfset var create=0>
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'COMMENT', 'BLOGENTRYID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE COMMENT ADD BLOGENTRYID BIGINT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOG')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOG
				(
					BLOGID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAME VARCHAR(128) NOT NULL,
					TITLE VARCHAR(1024),
					KEYWORDS VARCHAR(1024),
					DESCRIPTION VARCHAR(1024),
					CREATEDON VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL,
					STATUS VARCHAR(128) NOT NULL DEFAULT 'Active',
					URLNAME VARCHAR(64) NOT NULL
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'qdcmsBLOG', 'STATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE qdcmsBLOG ADD STATUS VARCHAR(128) NOT NULL DEFAULT 'Active'
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'qdcmsBLOG', 'URLNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE qdcmsBLOG ADD URLNAME VARCHAR(64)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOGSTATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOGSTATUS
				(
					BLOGSTATUS VARCHAR(128) NOT NULL PRIMARY KEY DEFAULT 'Draft'
				);
				INSERT INTO qdcmsBlogSTATUS VALUES ('Draft');
				INSERT INTO qdcmsBlogSTATUS VALUES ('Published');
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOGENTRY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOGENTRY
				(
					BLOGENTRYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAME VARCHAR(128) NOT NULL,
					ENTRY NTEXT NOT NULL,
					TITLE VARCHAR(1024),
					KEYWORDS VARCHAR(1024),
					DESCRIPTION NTEXT,
					ENTRYSTATUS VARCHAR(128) NOT NULL DEFAULT 'Draft',
					POSTDATE VARCHAR(16) NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL,
					LASTUPDATEDBY VARCHAR(128),
					URLNAME VARCHAR(64) NOT NULL
				);
				
				ALTER TABLE qdcmsBLOGENTRY 
				ADD CONSTRAINT qdcmsBLOGENTRY_qdcmsBLOGSTATUS 
				FOREIGN KEY(ENTRYSTATUS) 
				REFERENCES qdcmsBLOGSTATUS(BLOGSTATUS);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'qdcmsBLOGENTRY', 'URLNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE qdcmsBLOGENTRY ADD URLNAME VARCHAR(64)
			</cfquery>
		</cfif>
		
		<cfquery name="create" datasource="#arguments.ds#">
			ALTER TABLE QDCMSBLOGENTRY ALTER COLUMN DESCRIPTION NTEXT
		</cfquery>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','qdcmsBLOGENTRY','LASTUPDATEDBY')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE qdcmsBLOGENTRY ADD LASTUPDATEDBY VARCHAR(128)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOGCATEGORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOGCATEGORY
				(
					BLOGCATEGORYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAME VARCHAR(128) NOT NULL,
					TITLE VARCHAR(1024),
					KEYWORDS VARCHAR(1024),
					DESCRIPTION VARCHAR(1024),
					CREATEDON VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL,
					BLOGCATEGORYSTATUS VARCHAR(128) NOT NULL DEFAULT 'Draft'
				);
				
				ALTER TABLE qdcmsBLOGCATEGORY ADD CONSTRAINT qdcmsBLOGCATEGORY_qdcmsBLOGSTATUS FOREIGN KEY(BLOGCATEGORYSTATUS) REFERENCES qdcmsBLOGSTATUS(BLOGSTATUS);
			</cfquery>
		</cfif>
		
		<cfloop list="#variables.blogstatusList#" index="status">
			<cfinvoke component="bloggin" method="getBlogStatus" ds="#arguments.ds#" criteria="#status#" returnvariable="myStatus">
			<cfif myStatus.recordcount eq 0>
				<cfquery name="create" datasource="#arguments.ds#">
				INSERT INTO qdcmsBLOGSTATUS
				(BLOGSTATUS)
				VALUES
				(<cfqueryparam value="#status#">)
				</cfquery>
			</cfif>
		</cfloop>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOGENTRYTOBLOG')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOGENTRYTOBLOG
				(
					BLOGENTRYID BIGINT NOT NULL,
					BLOGID BIGINT NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL
				);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOG 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOG_PK 
				PRIMARY KEY(BLOGENTRYID,BLOGID);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOG 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOG_BLOGENTRY_FK 
				FOREIGN KEY(BLOGENTRYID) 
				REFERENCES qdcmsBLOGENTRY(BLOGENTRYID);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOG 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOG_BLOG_FK 
				FOREIGN KEY(BLOGID) 
				REFERENCES qdcmsBLOG(BLOGID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsBLOGENTRYTOBLOGCAT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsBLOGENTRYTOBLOGCAT
				(
					BLOGENTRYID BIGINT NOT NULL,
					BLOGCATEGORYID BIGINT NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL
				);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOGCAT 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOGCAT_PK 
				PRIMARY KEY(BLOGENTRYID,BLOGCATEGORYID);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOGCAT 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOGCAT_BLOGENTRY_FK 
				FOREIGN KEY(BLOGENTRYID) 
				REFERENCES qdcmsBLOGENTRY(BLOGENTRYID);
				
				ALTER TABLE qdcmsBLOGENTRYTOBLOGCAT 
				ADD CONSTRAINT qdcmsBLOGENTRYTOBLOGCAT_BLOGCAT_FK 
				FOREIGN KEY(BLOGCATEGORYID) 
				REFERENCES qdcmsBLOGCATEGORY(BLOGCATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'qdcmsSUBSCRIBETOBLOGENTRYCOMMENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE qdcmsSUBSCRIBETOBLOGENTRYCOMMENT
				(
					ID BIGINT IDENTITY(1,1) NOT NULL,
					BLOGENTRYID BIGINT NOT NULL,
					BLOGENTRYCOMMENTEMAIL VARCHAR(256) NOT NULL
				);
				ALTER TABLE qdcmsSUBSCRIBETOBLOGENTRYCOMMENT ADD CONSTRAINT PK_qdcmsSUBSCRIBETOBLOGENTRYCOMMENT PRIMARY KEY(BLOGENTRYID,BLOGENTRYCOMMENTEMAIL);
				ALTER TABLE qdcmsSUBSCRIBETOBLOGENTRYCOMMENT ADD CONSTRAINT FK_SUBSCOMMENT_BLOGENTRY FOREIGN KEY(BLOGENTRYID) REFERENCES qdcmsBLOGENTRY(BLOGENTRYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.viewExists('#arguments.ds#', 'qdcmsUNIQUEBLOGENTRYID')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE VIEW qdcmsUNIQUEBLOGENTRYID AS
					SELECT BLOGENTRYID, 
					MAX(CREATEDON) AS CREATEDON
					FROM qdcmsBLOGENTRY
					GROUP BY BLOGENTRYID;
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createCartTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfset var drop = 0>
		<cfif not listcontainsnocase('#variables.productexcludelist#', '#arguments.ds#')>
			<cfif variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SITEID')>
				<cfif variables.tblCheck.tableExists('#arguments.ds#', 'CART')>
					<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE CART
					</cfquery>
				</cfif>
				<cfif variables.tblCheck.tableExists('#arguments.ds#', 'CART2ITEM')>
					<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE CART2ITEM
					</cfquery>
				</cfif>
			</cfif>
		
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'CART')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE CART
					(
						CARTID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						REPID BIGINT,
						CREATEDON VARCHAR(16) NOT NULL,
						ACTIVE BIT NOT NULL DEFAULT 1
					)
					ALTER TABLE CART ADD FOREIGN KEY (REPID) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'CARTOWNER')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE CARTOWNER
					(
						CARTID BIGINT NOT NULL PRIMARY KEY,
						NAMEID BIGINT NOT NULL
					)
					ALTER TABLE CARTOWNER ADD FOREIGN KEY (CARTID) REFERENCES CART(CARTID);
					ALTER TABLE CARTOWNER ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'CART2ITEM')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE CART2ITEM
					(
						CARTID BIGINT NOT NULL,
						ID BIGINT NOT NULL,
						QUANTITY BIGINT NOT NULL
					)
					ALTER TABLE CART2ITEM ADD PRIMARY KEY (CARTID, ID);
					ALTER TABLE CART2ITEM ADD FOREIGN KEY (CARTID) REFERENCES CART(CARTID);
					ALTER TABLE CART2ITEM ADD FOREIGN KEY (ID) REFERENCES IDPOOL(ID);
				</cfquery>
			</cfif>
			
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SOLDCART')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE SOLDCART
					(
						CARTID BIGINT NOT NULL PRIMARY KEY,
						CARTSOLD NTEXT NOT NULL
					)
					ALTER TABLE CART ADD FOREIGN KEY (CARTID) REFERENCES CART(CARTID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'COMMENT')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD COMMENT NTEXT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPADDRESS1')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPADDRESS1 VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPADDRESS2')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPADDRESS2 VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPCITY')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPCITY VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPSTATE')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPSTATE VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPCOUNTRY')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPCOUNTRY VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPNAME')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPNAME VARCHAR(128)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPSERVICE')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPSERVICE VARCHAR(256)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPFEE')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPFEE FLOAT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'SHIPMARKUP')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD SHIPMARKUP FLOAT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'DELIVERYPICKUP')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD DELIVERYPICKUP FLOAT
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CART', 'TAXFEE')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CART ADD TAXFEE FLOAT
				</cfquery>
			</cfif>
			
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createContestTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'CONTEST')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE CONTEST
				(
					CONTESTID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAMEID BIGINT NOT NULL,
					DESCRIPTION NTEXT NOT NULL,
					LONGDESCRIPTION NTEXT,
					QUESTION NTEXT,
					RECORDEDON VARCHAR(16),
					STARTDATE VARCHAR(16),
					ENDDATE VARCHAR(16),
					ANSWERREQUIRED BIT DEFAULT 0,
					IMAGEREQUIRED BIT DEFAULT 0,
					VIDEOREQUIRED BIT DEFAULT 0
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTEST', 'IMAGEREQUIRED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE CONTEST ADD IMAGEREQUIRED BIT DEFAULT 0
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTEST', 'VIDEOREQUIRED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE CONTEST ADD VIDEOREQUIRED BIT DEFAULT 0
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTEST', 'LONGDESCRIPTION')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE CONTEST ADD LONGDESCRIPTION NTEXT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTEST', 'QUESTION')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE CONTEST ADD QUESTION NTEXT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'CONTESTENTRY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE CONTESTENTRY
				(
					CONTESTID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					ENTRYTEXT NTEXT,
					IMAGEID BIGINT,
					VID BIGINT
				);
				ALTER TABLE CONTESTENTRY ADD PRIMARY KEY(CONTESTID, NAMEID);
				ALTER TABLE CONTESTENTRY ADD FOREIGN KEY (CONTESTID) REFERENCES CONTEST(CONTESTID);
				ALTER TABLE CONTESTENTRY ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
				ALTER TABLE CONTESTENTRY ADD FOREIGN KEY(IMAGEID) REFERENCES IMAGE(IMAGEID);
				ALTER TABLE CONTESTENTRY ADD FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTESTENTRY', 'IMAGEID')>
				<cfquery name="create" datasource="#arguments.ds#">
					ALTER TABLE CONTESTENTRY ADD IMAGEID BIGINT DEFAULT 0;
					ALTER TABLE CONTESTENTRY ADD FOREIGN KEY(IMAGEID) REFERENCES IMAGE(IMAGEID);
				</cfquery>
			</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'CONTESTENTRY', 'VID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE CONTESTENTRY ADD VID BIGINT DEFAULT 0;
				ALTER TABLE CONTESTENTRY ADD FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'WINNER')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE WINNER
				(
					CONTESTID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					SELECTEDON VARCHAR(16) NOT NULL
				)
				ALTER TABLE WINNER ADD PRIMARY KEY(CONTESTID, NAMEID);
				ALTER TABLE WINNER ADD FOREIGN KEY (CONTESTID) REFERENCES CONTEST(CONTESTID);
				ALTER TABLE WINNER ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createErrorTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ERRORS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE ERRORS
				(
					ERRORID VARCHAR(16) NOT NULL,
					SITEID VARCHAR(16) NOT NULL,
					ERROR NTEXT NOT NULL,
					CLIENTVARIABLES NTEXT NOT NULL,
					CGIVARIABLES NTEXT NOT NULL,
					FORMVARIABLES NTEXT,
					URLVARIABLES NTEXT,
					REQUESTVARIABLES NTEXT,
					SESSIONVARIABLES NTEXT,
					VIEWED BIT NOT NULL DEFAULT 0
					
				)
				ALTER TABLE ERRORS ADD CONSTRAINT PK_ERRORS PRIMARY KEY(ERRORID);
			</cfquery>
		</cfif>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'RESOLVEDERRORS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE RESOLVEDERRORS
				(
					ERRORID VARCHAR(16) NOT NULL,
					RESLOVEDON VARCHAR(16) NOT NULL
				)
				ALTER TABLE RESOLVEDERRORS ADD CONSTRAINT PK_RESOLVEDERRORS PRIMARY KEY(ERRORID);
				ALTER TABLE RESOLVEDERRORS ADD CONSTRAINT FK_RESOLVEDERRORS_ERRORS FOREIGN KEY(ERRORID) REFERENCES ERRORS(ERRORID);
			</cfquery>
		</cfif>	
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'COMMENTS_ON_ERRORS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE COMMENTS_ON_ERRORS
				(
					COMMENTID VARCHAR(16) NOT NULL,
					ERRORID VARCHAR(16) NOT NULL
				)
				ALTER TABLE COMMENTS_ON_ERRORS ADD CONSTRAINT FK_COMMNETS_ON_ERRORS_ERRORS FOREIGN KEY(ERRORID) REFERENCES ERRORS(ERRORID);
				ALTER TABLE COMMENTS_ON_ERRORS ADD CONSTRAINT FK_COMMENTS_ON_ERRORS_COMMENT FOREIGN KEY(COMMENTID) REFERENCES COMMENT(COMMENTID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createEventTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'EVENTCATEGORY')>
			<cfquery name="eventcategorytbl" datasource="#arguments.ds#">
				CREATE TABLE EVENTCATEGORY(
				EVENTCATEGORYID varchar(16) NOT NULL,
				EVENTCATEGORY varchar(128) NOT NULL,
				DESCRIPTION ntext NULL,
				PARENTEVENTCATEGORYID varchar(16) NULL,
				STATUS varchar(32) NULL,
				VERSIONID varchar(16) NOT NULL,
				VERSIONDESCRIPTION varchar(128) NULL,
				COLOR varchar(32) NULL,
				ARCHIVEXMO varchar(3) NULL,
				AGENCYCATEGORYID varchar(16) NULL
				);
				ALTER TABLE EVENTCATEGORY ADD CONSTRAINT PK_EVENTCATEGORY PRIMARY KEY(EVENTCATEGORYID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'EVENT')>
			<cfquery name="eventtbl" datasource="#arguments.ds#">
				CREATE TABLE EVENT(
				EVENTID varchar(16) NOT NULL,
				EVENTNAME varchar(256) NOT NULL,
				EVENTCATEGORYID varchar(16) NULL,
				SITEID varchar(16) NULL,
				CONTACTID bigint NULL,
				URL varchar(1024) NULL
				);
				ALTER TABLE EVENT ADD CONSTRAINT PK_EVENT PRIMARY KEY(EVENTID);
				ALTER TABLE EVENT ADD CONSTRAINT FK_EVENT_EVENTCATEGORYID FOREIGN KEY(EVENTCATEGORYID) REFERENCES EVENTCATEGORY(EVENTCATEGORYID);
			
				INSERT INTO EVENTCATEGORY 
				(
					EVENTCATEGORYID, 
					EVENTCATEGORY, 
					VERSIONID
				) 
				VALUES
				(
					<cfqueryparam value="#mytime.createTimeDate()#">,
					'Online Sign-up Event',
					<cfqueryparam value="#mytime.createTimeDate()#">
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','EVENT','CONTACTID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE EVENT ADD CONTACTID BIGINT;
				ALTER TABLE EVENT ADD CONSTRAINT FK_EVENT_NAME FOREIGN KEY (CONTACTID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','EVENT','URL')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE EVENT ADD URL VARCHAR(1024);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'EVENTVERSION')>
			<cfquery name="eventversiontbl" datasource="#arguments.ds#">
				CREATE TABLE EVENTVERSION(
				EVENTID varchar(16) NOT NULL,
				EVENTNAME varchar(256) NULL,
				DESCRIPTION ntext NULL,
				PREDESSOREVENTID varchar(16) NULL,
				RECURPATTERN varchar(50) NULL,
				EVERYXWEEKS decimal(18, 0) NULL,
				PARENTEVENTID varchar(16) NULL,
				STATUS varchar(32) NULL,
				VERSIONID varchar(16) NOT NULL,
				OLDCREATEDBYID varchar(16) NULL,
				VERSIONDESCRIPTION varchar(128) NULL,
				FUSEACTIONID varchar(16) NULL,
				KEYWORDS varchar(2048) NULL,
				TITLE varchar(128) NULL,
				PEERORDERNUMBER int NULL,
				TEMPLATEID varchar(16) NULL,
				STARTTIME varchar(16) NULL,
				ENDTIME varchar(256) NULL,
				SEDESCRIPTION varchar(2000) NULL,
				IMAGEID varchar(16) NULL,
				PERCENTCOMPLETE int NULL,
				CUSTOMCSS varchar(256) NULL,
				PRINTCSS varchar(256) NULL,
				SCREENCSS varchar(256) NULL,
				ACTUALSTARTTIME varchar(16) NULL,
				ACTUALENDTIME varchar(16) NULL,
				MENUIMAGECAPTION varchar(1024) NULL,
				MENUIMAGELINK varchar(1024) NULL,
				ALTLAYOUT varchar(256) NULL,
				PROJECTID varchar(16) NULL,
				PROJECTSTANDARDEVENTID varchar(16) NULL,
				EVENTCATEGORYID varchar(16) NULL,
				SITEID varchar(16) NULL,
				CREATEDBYID bigint NULL,
				NAVNUM bigint NULL,
				PLACEHOLDER varchar(32) NULL,
				PAGENAME varchar(32) NULL,
				FREQUENCY varchar(128) NULL,
				INTERVAL int NULL,
				COUNT int NULL,
				BYDAY varchar(1024) NULL,
				UNTIL varchar(16) NULL,
				REPEATEND varchar(128) NULL,
				FROMEMAIL varchar(128) NULL,
				CC varchar(128) NULL,
				SUBJECT varchar(1024) NULL,
				MESSAGE ntext NULL,
				DEFAULTPRICE money NULL,
				DISCOUNTTYPE varchar(32) NULL,
				PERCENTOFF int NULL,
				DISCOUNTPRICE money NULL,
				GUESTPRICE money NULL,
				LOCATIONID bigint NULL
				);
				ALTER TABLE EVENTVERSION ADD CONSTRAINT FK_EVENTVERSION_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID); 
				ALTER TABLE EVENTVERSION ADD CONSTRAINT FK_EVENTVERSION_NAME FOREIGN KEY(LOCATIONID) REFERENCES NAME (NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'COUNT')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD COUNT INT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'ACTUALSTARTTIME')>
			<cfquery name="ADDACTUALSTARTTIME" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD ACTUALSTARTTIME VARCHAR(16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'ACTUALENDTIME')>
		<cfquery name="addACTUALENDTIME" datasource="#arguments.ds#">
		ALTER TABLE EVENTVERSION ADD ACTUALENDTIME VARCHAR(16)
		</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'RECURPATTERN')>
			<cfquery name="addRECURPATTERN" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD RECURPATTERN varchar(50)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'EVERYXWEEKS')>
			<cfquery name="addEVERYXWEEKS" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD EVERYXWEEKS decimal(18, 0)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'FREQUENCY')>
			<cfquery name="addFREQUENCY" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD FREQUENCY varchar(128)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'INTERVAL')>
			<cfquery name="addINTERVAL" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD [INTERVAL] int
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'BYDAY')>
			<cfquery name="addBYDAY" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD BYDAY varchar(1024)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'UNTIL')>
			<cfquery name="addUNTIL" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD UNTIL varchar(16)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'REPEATEND')>
			<cfquery name="addREPEATEND" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD REPEATEND varchar(128)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'FROMEMAIL')>
			<cfquery name="addFROMEMAIL" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD FROMEMAIL varchar(128)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'CC')>
			<cfquery name="addCC" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD CC varchar(128)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'SUBJECT')>
			<cfquery name="addSUBJECT" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD SUBJECT varchar(1024)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'MESSAGE')>
			<cfquery name="addMESSAGE" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD MESSAGE ntext
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'DEFAULTPRICE')>
			<cfquery name="addDEFAULTPRICE" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD DEFAULTPRICE money
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'DISCOUNTTYPE')>
			<cfquery name="addDISCOUNTTYPE" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD DISCOUNTTYPE varchar(32)
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'PERCENTOFF')>
			<cfquery name="addPERCENTOFF" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD PERCENTOFF INT
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'DISCOUNTPRICE')>
			<cfquery name="addDISCOUNTPRICE" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD DISCOUNTPRICE money
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'GUESTPRICE')>
			<cfquery name="addGUESTPRICE" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD GUESTPRICE money
			</cfquery>
		</cfif>
				
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EVENTVERSION', 'LOCATIONID')>
			<cfquery name="addLOCATIONID" datasource="#arguments.ds#">
				ALTER TABLE EVENTVERSION ADD LOCATIONID bigint
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'EVENT2ADDRESS')>
			<cfquery name="event2addresstbl" datasource="#arguments.ds#">
				CREATE TABLE EVENT2ADDRESS(
				ADDRESSID bigint NULL,
				EVENTID varchar(16) NULL
				);
				ALTER TABLE EVENT2ADDRESS ADD CONSTRAINT FK_EVENT2ADDRESS_ADDRESS FOREIGN KEY(ADDRESSID) REFERENCES ADDRESS(ADDRESSID);
				ALTER TABLE EVENT2ADDRESS ADD CONSTRAINT FK_EVENT2ADDRESS_EVENT FOREIGN KEY (EVENTID) REFERENCES EVENT(EVENTID);		
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#','EVENT2USERGROUP')>
			<cfquery name="event2usergrouptbl" datasource="#arguments.ds#">
				CREATE TABLE EVENT2USERGROUP(
				EVENTID varchar(16) NOT NULL,
				USERGROUPID varchar(16) NOT NULL
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#','PEOPLE2EVENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE PEOPLE2EVENT(
					EVENTID VARCHAR(16) NOT NULL,
					USERGROUPID VARCHAR(16),
					NAMEID BIGINT NOT NULL,
					RELATIONSHIPID BIGINT,
					PRICE MONEY
				)
				ALTER TABLE PEOPLE2EVENT ADD CONSTRAINT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
				ALTER TABLE PEOPLE2EVENT ADD CONSTRAINT FOREIGN KEY(USERGROUPID) REFERENCES USERGROUPS(USERGROUPID);
				ALTER TABLE PEOPLE2EVENT ADD CONSTRAINT FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists(arguments.ds, 'PEOPLE2EVENT', 'USERGROUPID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE PEOPLE2EVENT ADD USERGROUPID VARCHAR(16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'REPEATINGEVENTS')>
			<cfquery name="repeatingeventstbl" datasource="#arguments.ds#">
				CREATE TABLE REPEATINGEVENTS
				(
					EVENTINSTANCEID BIGINT IDENTITY(1,1) NOT NULL,
					EVENTID VARCHAR(16) NOT NULL,
					STARTTIME VARCHAR(16) NOT NULL,
					ENDTIME VARCHAR(16) NOT NULL,
					ACTUALSTARTTIME VARCHAR(16) NOT NULL,
					ACTUALENDTIME VARCHAR(16) NOT NULL,
					STATUS VARCHAR(32) NOT NULL
				);
				ALTER TABLE REPEATINGEVENTS ADD CONSTRAINT PK_REPEATINGEVENTS PRIMARY KEY (EVENTID, STARTTIME);
				ALTER TABLE REPEATINGEVENTS ADD CONSTRAINT FK_REPEATINGEVENTS_EVENTS FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'REPEATINGEVENTS', 'ACTUALSTARTTIME')>
			<cfquery name="modifyrepeatingevents" datasource="#arguments.ds#">
				ALTER TABLE REPEATINGEVENTS ADD ACTUALSTARTTIME VARCHAR(16)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'REPEATINGEVENTS', 'ACTUALENDTIME')>
			<cfquery name="modifyrepeatingevents" datasource="#arguments.ds#">
				ALTER TABLE REPEATINGEVENTS ADD ACTUALENDTIME VARCHAR(16)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createFilesForMediaTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'FILESFORMEDIA')>
			<cfquery name="create" datasource="#arguments.ds#">
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
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'FILECATEGORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE FILECATEGORY
				(
					FILECATEGORYID VARCHAR(16) NOT NULL,
					FILECATEGORY VARCHAR(256) NOT NULL,
					STATUS VARCHAR(128),
					SORTORDER INT,
					EVENTCATEGORYID VARCHAR(16)
				)
				ALTER TABLE FILECATEGORY ADD CONSTRAINT PK_FILECATEGORY PRIMARY KEY(FILECATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#','FILES')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE FILES
				(
					FILECATEGORYID VARCHAR(16),
					FILECATEGORY VARCHAR(256),
					SERVERFILENAME VARCHAR(256) NOT NULL,
					DISPLAYNAME VARCHAR(256),
					PROJECTID VARCHAR(16),
					FILEID BIGINT IDENTITY(1,1),
					SORTORDER BIGINT DEFAULT 0,
					LASTUPDATED VARCHAR(16) NOT NULL
				)
				
				ALTER TABLE FILES ADD CONSTRAINT FK_FILES_FILECATEGORY FOREIGN KEY(FILECATEGORYID) REFERENCES FILECATEGORY(FILECATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.ColumnExists('#arguments.ds#','FILES','DISPLAYNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE FILES ADD DISPLAYNAME VARCHAR(256) 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.ColumnExists('#arguments.ds#','FILES','LASTUPDATED')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE FILES ADD LASTUPDATED VARCHAR(16) NOT NULL
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.ColumnExists('#arguments.ds#','FILES','SERVERFILENAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE FILES ADD SERVERFILENAME VARCHAR(256) 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'FILETOIDPOOL')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE FILETOIDPOOL 
				(
					FILEID BIGINT NOT NULL,
					ID BIGINT NOT NULL
				)
				ALTER TABLE FILETOIDPOOL ADD CONSTRAINT PK_FILETOIDPOOL PRIMARY KEY(FILEID,ID);
				ALTER TABLE FILETOIDPOOL ADD FOREIGN KEY(FILEID) REFERENCES FILESFORMEDIA(FILEID);
				ALTER TABLE FILETOIDPOOL ADD FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createApplicationTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PERSONALINFO')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE PERSONALINFO
				(
					PERSONALINFOID BIGINT NOT NULL IDENTITY(1,1),
					WEMAIL VARCHAR(64) NOT NULL,
					FIRSTNAME VARCHAR(64) NOT NULL,
					LASTNAME VARCHAR(64) NOT NULL,
					MIDDLENAME VARCHAR(64),
					MAIDENNAME VARCHAR(64) NOT NULL,
					HPHONE VARCHAR(64) NOT NULL,
					MPHONE VARCHAR(64),
					GENDER VARCHAR(1) DEFAULT 1,
					DOB VARCHAR(16) NOT NULL,
					MARITALSTATUS VARCHAR(1) DEFAULT 2,
					SPOUSENAME VARCHAR(128) NOT NULL
				);
				ALTER TABLE PERSONALINFO ADD CONSTRAINT PK_PERSONALINFO PRIMARY KEY(PERSONALINFOID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'PERSONALINFO', 'MPHONE')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE PERSONALINFO ADD MPHONE VARCHAR(64)
			</cfquery>	
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'RESIDENCEINFO')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE RESIDENCEINFO
				(
					RESIDENCEINFOID BIGINT NOT NULL IDENTITY(1,1),
					PERSONALINFOID BIGINT NOT NULL,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16) NOT NULL,
					ADDRESS1 VARCHAR(256) NOT NULL,
					ADDRESS2 VARCHAR(256) NOT NULL,
					CITY VARCHAR(256) NOT NULL,
					STATE VARCHAR(32),
					ZIP VARCHAR(10),
					COUNTY VARCHAR(64),
					COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
				);
				ALTER TABLE RESIDENCEINFO ADD CONSTRAINT PK_RESIDENCEINFO PRIMARY KEY(RESIDENCEINFOID);
				ALTER TABLE RESIDENCEINFO ADD CONSTRAINT FK_RESIDENCEINFO_PERSONALINFO FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);
			</cfquery>
		</cfif>
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'RESIDENCEINFO', 'ZIP')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE RESIDENCEINFO ADD ZIP VARCHAR(10)
			</cfquery>	
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'RESIDENCEINFO', 'COUNTY')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE RESIDENCEINFO ADD COUNTY VARCHAR(64)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'EMPLOYMENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE EMPLOYMENT
				(
					EMPLOYMENTID BIGINT NOT NULL IDENTITY(1,1),
					PERSONALINFOID BIGINT NOT NULL,
					TITLE VARCHAR(128) NOT NULL,
					COMPANY VARCHAR(128) NOT NULL,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16) NOT NULL,
					RESPONSIBILITIES NTEXT NOT NULL,
					SUPERVISOR_NAME VARCHAR(64),
					SUPERVISOR_PH_NUMBER VARCHAR(32),
					ADDRESS1 VARCHAR(256) NOT NULL,
					ADDRESS2 VARCHAR(256),
					CITY VARCHAR(256) NOT NULL,
					STATE VARCHAR(32),
					ZIP VARCHAR(16),
					COUNTY VARCHAR(64),
					COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
				);
				ALTER TABLE EMPLOYMENT ADD CONSTRAINT PK_EMPLOYMENT PRIMARY KEY(EMPLOYMENTID);
				ALTER TABLE EMPLOYMENT ADD CONSTRAINT FK_EMPLOYMENT_NAME FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EMPLOYMENT', 'COUNTY')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE EMPLOYMENT ADD COUNTY VARCHAR(64)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'EMPLOYMENT', 'SUPERVISOR_NAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE EMPLOYMENT ADD SUPERVISOR_NAME VARCHAR(64)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'BUSINESS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE BUSINESS
				(
					BUSINESSID BIGINT NOT NULL IDENTITY(1,1),
					PERSONALINFOID BIGINT NOT NULL,
					TITLE VARCHAR(128) NOT NULL,
					PRODUCTS_SERVICES NTEXT NOT NULL,
					PARTNERSANDNUMBERS NTEXT NOT NULL,
					FID VARCHAR(64) NOT NULL,
					COMPANY VARCHAR(128) NOT NULL,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16),
					CURRENTINVOLVEMENT VARCHAR(3) NOT NULL,
					CE_EXPLANATION NTEXT NOT NULL,
					PCTOFTIMEUSED INT DEFAULT 0,
					ADDRESS1 VARCHAR(256) NOT NULL,
					ADDRESS2 VARCHAR(256),
					CITY VARCHAR(256) NOT NULL,
					STATE VARCHAR(2),
					ZIP VARCHAR(16),
					COUNTRY VARCHAR(64) NOT NULL DEFAULT 'US'
				);
				ALTER TABLE BUSINESS ADD CONSTRAINT PK_BUSINESS PRIMARY KEY(BUSINESSID);
				ALTER TABLE BUSINESS ADD CONSTRAINT FK_BUSINESS_NAME FOREIGN KEY(PERSONALINFOID) REFERENCES PERSONALINFO(PERSONALINFOID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SAVEDAPPLICATION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SAVEDAPPLICATION
				(
					EMAIL VARCHAR(64) NOT NULL,
					PASSWORD VARCHAR(32) NOT NULL,
					SAVEDDATA NTEXT NOT NULL,
					LOCKED BIT NOT NULL DEFAULT 0	
				);
				ALTER TABLE SAVEDAPPLICATION ADD CONSTRAINT PK_SAVEDAPPLICATION PRIMARY KEY(EMAIL);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TRACKAPPLICATION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TRACKAPPLICATION
				(
					ID BIGINT IDENTITY(1,1) NOT NULL,
					EMAIL VARCHAR(64) NOT NULL,
					TIMEDATE VARCHAR(16),
					REMARKS VARCHAR(256)
				);
				ALTER TABLE TRACKAPPLICATION ADD CONSTRAINT PK_TRACKAPPLICATION PRIMARY KEY(ID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createHauTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'HEARDABOUTUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE HEARDABOUTUS
				(
					ABOUTUSID BIGINT NOT NULL IDENTITY(1,1),
					ABOUTUS VARCHAR(512) NOT NULL UNIQUE,
					ABOUTUSPARENTID BIGINT NOT NULL,
					NESTLEVEL INT DEFAULT 0,
					SORTORDER VARCHAR(2048),
					STATUS VARCHAR(32)
				)
				ALTER TABLE HEARDABOUTUS ADD CONSTRAINT PK_HEARDABOUTUS PRIMARY KEY(ABOUTUSID)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists(arguments.ds,'HEARDABOUTUS','NESTLEVEL')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE HEARDABOUTUS ADD NESTLEVEL INT DEFAULT 0
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists(arguments.ds, 'HEARDABOUTUS','SORTORDER')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE HEARDABOUTUS ADD SORTORDER VARCHAR(2048)
			</cfquery>	
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'HAU2EVENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE HAU2EVENT
				(
					ABOUTUSID BIGINT NOT NULL,
					EVENTID VARCHAR(16) NOT NULL
				);
				ALTER TABLE HAU2EVENT ADD CONSTRAINT PK_HAU2EVENT PRIMARY KEY(ABOUTUSID,EVENTID);
				ALTER TABLE HAU2EVENT ADD CONSTRAINT FK_HAU2EVENT_HEARDABOUTUS FOREIGN KEY(ABOUTUSID) REFERENCES HEARDABOUTUS(ABOUTUSID);
				ALTER TABLE HAU2EVENT ADD CONSTRAINT FK_HAU2EVENT_EVENT FOREIGN KEY(EVENTID) REFERENCES HEARDABOUTUS(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'HAU2PEOPLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE HAU2PEOPLE
				(
					NAMEID BIGINT NOT NULL,
					ABOUTUSID BIGINT NOT NULL,
					EVENTID VARCHAR(16)
				)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createLinkTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'LINKS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE LINKS
				(
					LINKID INT NOT NULL IDENTITY(1,1),
					NAME VARCHAR(512) NOT NULL,
					HREF VARCHAR(128) NOT NULL,
					TARGET VARCHAR(32),
					TITLE VARCHAR(1024)
				);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createNavigationTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NAVVERSION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NAVVERSION
				(	
					NAVID BIGINT NOT NULL,
					NAVVERID VARCHAR(16) NOT NULL,
					NAVNAME VARCHAR(128) NOT NULL,
					STATUS VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL
				);	
				ALTER TABLE NAVVERSION ADD CONSTRAINT NAVVERSION_PK PRIMARY KEY(NAVID,NAVVERID);
			</cfquery>
		</cfif>
		<!--- Checks to see if the table NAVITEMS exists, if it doesn't then create it --->
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NAVITEMS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NAVITEMS
				(	
					NAVID BIGINT NOT NULL,
					NAVVERID VARCHAR(16) NOT NULL,
					WPID BIGINT NOT NULL,
					NAVITEMID BIGINT NOT NULL,
					SORTORDER INT,
					LINKID BIGINT NOT NULL
				);	
				ALTER TABLE NAVITEMS ADD CONSTRAINT NAVITEMS_PK PRIMARY KEY(NAVITEMID);
				ALTER TABLE NAVITEMS 
				ADD CONSTRAINT NAVITEMS_FK FOREIGN KEY(NAVID,NAVVERID) REFERENCES NAVVERSION(NAVID,NAVVERID);
			</cfquery>
		</cfif>
		
		<!--- Checks to see if the table NAVITEMPARENT exists, if it doesn't then create it --->
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NAVITEMPARENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NAVITEMPARENT
				(
					NAVITEMID BIGINT NOT NULL,
					PARENTNAVID BIGINT NOT NULL
				);
				ALTER TABLE NAVITEMPARENT ADD CONSTRAINT NAVITEMPARENT_PK PRIMARY KEY(NAVITEMID,PARENTNAVID);
			</cfquery>
		</cfif>	
		
		<cfif not variables.tblCheck.viewExists('#arguments.ds#', 'UNIQUENAVID')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE VIEW UNIQUENAVID AS
					SELECT NAVID, MAX(NAVVERID) AS NAVVERID
					FROM NAVVERSION
					GROUP BY NAVID;
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createNewsletterTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfset var getpk1 = 0>
		<cfset var getpk2 = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERTEMPLATE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERTEMPLATE
				(
					NEWSLETTERTEMPLATEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAME VARCHAR(256) NOT NULL,
					DESCRIPTION VARCHAR(1024),
					IMAGEPATH VARCHAR(256),
					TEMPLATE NTEXT NOT NULL,
					STATUS VARCHAR(128) NOT NULL DEFAULT 'Published'
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTER')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTER
				(
					NEWSLETTERID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					NAME VARCHAR(256) NOT NULL,
					HTMLNEWSLETTER NTEXT,
					TEXTNEWSLETTER NTEXT,
					SUBJECT VARCHAR(512),
					CREATEDON VARCHAR(16) NOT NULL,
					UPDATEDON VARCHAR(16) NOT NULL,
					NEWSLETTERTEMPLATEID BIGINT,
					CREATEDBYMASTERID BIGINT NOT NULL,
					REPLYTO VARCHAR(512) NOT NULL,
					SENDFROMNAME VARCHAR(512)
				);
				ALTER TABLE NEWSLETTER ADD FOREIGN KEY(NEWSLETTERTEMPLATEID) REFERENCES NEWSLETTERTEMPLATE(NEWSLETTERTEMPLATEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NEWSLETTER', 'CREATEDBYMASTERID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTER ADD CREATEDBYMASTERID BIGINT NOT NULL
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NEWSLETTER', 'REPLYTO')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTER ADD REPLYTO VARCHAR(512) NOT NULL
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#', 'NEWSLETTER', 'SENDFROMNAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTER ADD SENDFROMNAME VARCHAR(512)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERQUEUE')>
			<cfquery name="create" datasource="#arguments.ds#">		
				CREATE TABLE NEWSLETTERQUEUE
				(
					QUEUEID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
					NEWSLETTERID BIGINT NOT NULL,
					QUEUEDON VARCHAR(16) NOT NULL,
					SENDDATE VARCHAR(16) NOT NULL,
					SENT VARCHAR(1) NOT NULL
				)
				ALTER TABLE NEWSLETTERQUEUE ADD FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','NEWSLETTERQUEUE','SENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTERQUEUE ADD SENT VARCHAR(1) DEFAULT 0
			</cfquery>
			<cfquery name="create" datasource="#arguments.ds#">
				UPDATE NEWSLETTERQUEUE SET SENT=0
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERTRACKING')>
			<cfquery name="create" datasource="#arguments.ds#">	
				CREATE TABLE NEWSLETTERTRACKING
				(
					NEWSLETTERUUID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
					NEWSLETTERID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					TIMESENT VARCHAR(16) NOT NULL,
					SENTTOEMAIL VARCHAR(256) NOT NULL,
				);
					
				ALTER TABLE NEWSLETTERTRACKING ADD FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
				ALTER TABLE NEWSLETTERTRACKING ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERBOUNCED')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERBOUNCED
				(
					NEWSLETTERUUID BIGINT NOT NULL PRIMARY KEY,
					TIMEBOUNCED VARCHAR(16) NOT NULL
				);
				ALTER TABLE NEWSLETTERBOUNCED ADD FOREIGN KEY(NEWSLETTERUUID) REFERENCES NEWSLETTERTRACKING(NEWSLETTERUUID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERVIEWED')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERVIEWED
				(
					NEWSLETTERUUID BIGINT NOT NULL PRIMARY KEY,
					TIMEVIEWED VARCHAR(16) NOT NULL
				);
				ALTER TABLE NEWSLETTERVIEWED ADD FOREIGN KEY(NEWSLETTERUUID) REFERENCES NEWSLETTERTRACKING(NEWSLETTERUUID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERTOUSERGROUP')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERTOUSERGROUP
				(
					NEWSLETTERID BIGINT NOT NULL,
					USERGROUPID VARCHAR(16) NOT NULL,
					EVENTID VARCHAR(16)
				);
				ALTER TABLE NEWSLETTERTOUSERGROUP ADD CONSTRAINT NEWSLETTER2GROUP_NEWSLETTER FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
				ALTER TABLE NEWSLETTERTOUSERGROUP ADD CONSTRAINT NEWSLETTER2GROUP_USERGROUP FOREIGN KEY(USERGROUPID) REFERENCES USERGROUPS(USERGROUPID);
				ALTER TABLE NEWSLETTERTOUSERGROUP ADD CONSTRAINT FK_NEWSLETTERTOUSERGROUP_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);

			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists(arguments.ds,'NEWSLETTERTOUSERGROUP','EVENTID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTERTOUSERGROUP ADD EVENTID VARCHAR(16);
				ALTER TABLE NEWSLETTERTOUSERGROUP ADD CONSTRAINT FK_NEWSLETTERTOUSERGROUP_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERTOUSERGROUPEXCLUDE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERTOUSERGROUPEXCLUDE
				(
					NEWSLETTERID BIGINT NOT NULL,
					USERGROUPID VARCHAR(16) NOT NULL,
					EVENTID VARCHAR(16)
				);
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE ADD CONSTRAINT NEWSLETTER2GROUPEXCLUDE_NEWSLETTER FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE ADD CONSTRAINT NEWSLETTER2GROUPEXCLUDE_USERGROUP FOREIGN KEY(USERGROUPID) REFERENCES USERGROUPS(USERGROUPID);
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE ADD CONSTRAINT FK_NEWSLETTERTOUSERGROUPEXCLUDE_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists(arguments.ds,'NEWSLETTERTOUSERGROUPEXCLUDE','EVENTID')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE ADD EVENTID VARCHAR(16);
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE ADD CONSTRAINT FK_NEWSLETTERTOUSERGROUPEXCLUDE_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERTOEMAILTYPE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERTOEMAILTYPE
				(
					NEWSLETTERID BIGINT NOT NULL,
					EMAILTYPE VARCHAR(16) NOT NULL
				);
				ALTER TABLE NEWSLETTERTOEMAILTYPE ADD CONSTRAINT PK_NEWSLETTERTOMAILTYPE PRIMARY KEY(NEWSLETTERID,EMAILTYPE);
				ALTER TABLE NEWSLETTERTOEMAILTYPE ADD CONSTRAINT FK_NEWSLETTERTOEMAILTYPE_NEWSLETTER FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'NEWSLETTERDELETEVIRTUAL')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE NEWSLETTERDELETEVIRTUAL
				(
					NEWSLETTERID BIGINT NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL
				);
				ALTER TABLE NEWSLETTERDELETEVIRTUAL ADD CONSTRAINT PK_DELETEVIRTUAL PRIMARY KEY(NEWSLETTERID);
				ALTER TABLE NEWSLETTERDELETEVIRTUAL ADD CONSTRAINT FK_DELETEVIRTUAL_NEWSLETTER FOREIGN KEY(NEWSLETTERID) REFERENCES NEWSLETTER(NEWSLETTERID);
			</cfquery>
		</cfif>
		
		<cfquery name="getpk1" datasource="#arguments.ds#">
			select CONSTRAINT_NAME from INFORMATION_SCHEMA.TABLE_constraints 
			where table_name = 'NEWSLETTERTOUSERGROUP'
			AND constraint_type='PRIMARY KEY'
		</cfquery>
		
		<cfif getpk1.recordcount GT 0>
			<cfquery name="dropPk1" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTERTOUSERGROUP DROP CONSTRAINT #getpk1.CONSTRAINT_NAME#
			</cfquery>
		</cfif>
		<cfquery name="getpk2" datasource="#arguments.ds#">
			select CONSTRAINT_NAME from INFORMATION_SCHEMA.TABLE_constraints where table_name = 'NEWSLETTERTOUSERGROUPEXCLUDE'
			AND constraint_type='PRIMARY KEY'
		</cfquery>
		
		<cfif getpk2.recordcount GT 0>
			<cfquery name="dropPk2" datasource="#arguments.ds#">
				ALTER TABLE NEWSLETTERTOUSERGROUPEXCLUDE DROP CONSTRAINT #getpk2.CONSTRAINT_NAME#
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="createSubscriptionTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TERMMEASURE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TERMMEASURE
				(
					TERMMEASURE VARCHAR(32) NOT NULL PRIMARY KEY
				)
				INSERT INTO TERMMEASURE VALUES('Minutes');
				INSERT INTO TERMMEASURE VALUES('Hours');
				INSERT INTO TERMMEASURE VALUES('Days');
				INSERT INTO TERMMEASURE VALUES('Months');
				INSERT INTO TERMMEASURE VALUES('Years');
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTIONPLANS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTIONPLANS
				(
					ID BIGINT NOT NULL PRIMARY KEY,
					SUBSCRIABLEID BIGINT NOT NULL,
					TERM INTEGER NOT NULL,
					TERMMEASURE VARCHAR(32) NOT NULL,
					USABLEMINUTES INTEGER NOT NULL DEFAULT 0,
					ONSALE BIT NOT NULL DEFAULT 1
				)
				ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
				ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(SUBSCRIABLEID) REFERENCES IDPOOL(ID);
				ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(TERMMEASURE) REFERENCES TERMMEASURE(TERMMEASURE);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIBED')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIBED
				(
					SUBSCRIPTIONID BIGINT IDENTITY(1,1) NOT NULL UNIQUE,
					ID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					ACTIVE BIT NOT NULL DEFAULT 1,
					CANCELLED BIT NOT NULL DEFAULT 0
				)
				ALTER TABLE SUBSCRIBED ADD PRIMARY KEY(ID, NAMEID);
				ALTER TABLE SUBSCRIBED ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
				ALTER TABLE SUBSCRIBED ADD FOREIGN KEY(ID) REFERENCES SUBSCRIPTIONPLANS(ID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTIONTOIP')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTIONTOIP
				(
					SUBSCRIPTIONID BIGINT NOT NULL,
					IPADDRESS VARCHAR(16) NOT NULL
				)
				
				ALTER TABLE SUBSCRIPTIONTOIP ADD PRIMARY KEY(SUBSCRIPTIONID, IPADDRESS);
				ALTER TABLE SUBSCRIPTIONTOIP ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTION
				(
					SUBSCRIPTIONID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					RENEWALDATE VARCHAR(16) NOT NULL,
					DATERENEWED VARCHAR(16) NOT NULL
				)
				ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_SUBSCRIPTION_SUBSCRIBED FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
				ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_SUBSCRIPTION_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTIONREMINDER')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTIONREMINDER
				(
					REMINDERID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SUBSCRIPTIONID BIGINT NOT NULL,
					REMINDERMEASURE VARCHAR(32) NOT NULL DEFAULT 'EMAIL',
					REMINDON VARCHAR(16) NOT NULL
				)
				ALTER TABLE SUBSCRIPTIONREMINDER ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTIONACTIVATION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTIONACTIVATION
				(
					ACTIVATIONID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SUBSCRIPTIONID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					ACTIVATED BIGINT NOT NULL DEFAULT 1,
					TIMEDATE VARCHAR(16) NOT NULL
				)
				ALTER TABLE SUBSCRIPTIONACTIVATION ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
				ALTER TABLE SUBSCRIPTIONACTIVATION ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIEWLOG')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIEWLOG
				(
					VIEWLOGID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SUBSCRIPTIONID BIGINT NOT NULL,
					VIEWEDON VARCHAR(16) NOT NULL,
					VIEWTIME INTEGER NOT NULL
				)
				ALTER TABLE VIEWLOG ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'TIMEREMAINING')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE TIMEREMAINING
				(
					TIMEREMAININGID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SUBSCRIPTIONID BIGINT NOT NULL,
					TIMEREMAINING INT NOT NULL
				)
				ALTER TABLE TIMEREMAINING ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SUBSCRIPTION_RECORD')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SUBSCRIPTION_RECORD
				(
					SUBSCRIPTIONID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL,
					CANCELLED BIT DEFAULT 0,
					RECORDEDON VARCHAR(16)
				)
				ALTER TABLE SUBSCRIPTION_RECORD ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
				ALTER TABLE SUBSCRIPTION_RECORD ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'REMINDERLOG')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE REMINDERLOG
				(
					REMINDERID BIGINT NOT NULL,
					MESSAGE NTEXT NOT NULL,
					SENTON VARCHAR(16) NOT NULL
					
				)
				ALTER TABLE REMINDERLOG ADD FOREIGN KEY(REMINDERID) REFERENCES SUBSCRIPTIONREMINDER(REMINDERID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'DEFAULTPLAN')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE DEFAULTPLAN
				(
					ID BIGINT IDENTITY(1,1) NOT NULL,
					TERM INT NOT NULL,
					TERMMEASURE VARCHAR(32) NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL
				)
				ALTER TABLE DEFAULTPLAN ADD CONSTRAINT PK_DEFAULTPLAN PRIMARY KEY(ID);
				ALTER TABLE DEFAULTPLAN ADD CONSTRAINT FK_DEFAULTPLAN_TERMMEASURE FOREIGN KEY(TERMMEASURE)  REFERENCES TERMMEASURE(TERMMEASURE);
				INSERT INTO DEFAULTPLAN(TERM, TERMMEASURE, TIMEDATE) VALUES(7, 'Days', <cfqueryparam value="#mytime.createTimeDate()#">);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createSurveyTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SURVEY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SURVEY
				(
					SURVEYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SURVEYNAME VARCHAR(100) NOT NULL,
					NAMEID BIGINT NOT NULL,
					NUMBEROFTIMESFOR1IP INT DEFAULT 3,
					NUMBEROFTIMESFORNAMEID INT DEFAULT 1,
					STATUS BIT DEFAULT 1,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16),
					ALLOWENDDATE BIT DEFAULT 0,
					ACTIVE BIT DEFAULT 1
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'QUESTIONS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE QUESTIONS 
				(
					QUESTIONID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SURVEYID BIGINT NOT NULL,
					SURVEYQUESTION NTEXT NOT NULL,
					MULTIPLEANSWERS BIT DEFAULT 0,
					TEXTREQUIRED BIT DEFAULT 0,
					SORTORDER INT  DEFAULT 0,
					DISPLAY BIT DEFAULT 1
				);
				ALTER TABLE QUESTIONS ADD FOREIGN KEY (SURVEYID) REFERENCES SURVEY(SURVEYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ANSWERCHOICES')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE ANSWERCHOICES
				(
					ANSWERCHOICEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					QUESTIONID BIGINT NOT NULL,
					ANSWER NTEXT NOT NULL,
					SORTORDER INT DEFAULT 1
				);
				ALTER TABLE ANSWERCHOICES ADD FOREIGN KEY (QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'PEOPLESURVEYED')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE PEOPLESURVEYED
				(
					PEOPLESURVEYEDID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					SURVEYID BIGINT NOT NULL,
					IPADDRESS VARCHAR(24) NOT NULL,
					CFID VARCHAR(50) NOT NULL,
					NAMEID BIGINT
				);
				ALTER TABLE PEOPLESURVEYED ADD FOREIGN KEY(SURVEYID) REFERENCES SURVEY(SURVEYID);
				ALTER TABLE PEOPLESURVEYED ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'RESULTS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE RESULTS
				(
					ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					PEOPLESURVEYEDID BIGINT NOT NULL,
					QUESTIONID BIGINT NOT NULL,
					ANSWERCHOICEID BIGINT NOT NULL,
					DATETIME VARCHAR(16) NOT NULL
				);
				ALTER TABLE RESULTS ADD FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
				ALTER TABLE RESULTS ADD FOREIGN KEY(ANSWERCHOICEID) REFERENCES ANSWERCHOICES(ANSWERCHOICEID);
				ALTER TABLE RESULTS ADD FOREIGN KEY(PEOPLESURVEYEDID) REFERENCES PEOPLESURVEYED(PEOPLESURVEYEDID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'ANSWERS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE ANSWERS
				(
					ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					PEOPLESURVEYEDID BIGINT NOT NULL,
					QUESTIONID BIGINT NOT NULL,
					ANSWER NTEXT NOT NULL
				)
				ALTER TABLE ANSWERS ADD FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID)
				ALTER TABLE ANSWERS ADD FOREIGN KEY(PEOPLESURVEYEDID) REFERENCES PEOPLESURVEYED(PEOPLESURVEYEDID);
			</cfquery>
		</cfif>
		<cfif not variables.tblcheck.tableExists('#arguments.ds#','QRELATION')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE QRELATION
				(
					QRELATIONID BIGINT NOT NULL IDENTITY(1,1),
					QUESTIONID BIGINT NOT NULL,
					ANSWERCHOICEID BIGINT NOT NULL,
					RELATED_QUESTIONID BIGINT NOT NULL
				)
				ALTER TABLE QRELATION ADD CONSTRAINT PK_QRELATIONID PRIMARY KEY(QRELATIONID);
				ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_QUESTIONS FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
				ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_ANSWERCHOICES FOREIGN KEY(ANSWERCHOICEID) REFERENCES ANSWERCHOICES(ANSWERCHOICEID);
				ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_RQUESTIONS FOREIGN KEY(RELATED_QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
		
	<cffunction name="createLastVisitsTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'LASTVISITS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE LASTVISITS
				(
					SECURITYID BIGINT NOT NULL,
					MASTERNAMEID BIGINT,
					SITEID VARCHAR(16) NOT NULL,
					SEC VARCHAR(128) NOT NULL,
					VMOD VARCHAR(128) NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL,
					ACT VARCHAR(128) NOT NULL,
					VURL VARCHAR(256) NOT NULL,
					VARURL NTEXT,
					VARFORM NTEXT
				);
				ALTER TABLE LASTVISITS ADD PRIMARY KEY(SECURITYID, SITEID, SEC, VMOD, ACT, TIMEDATE);
				ALTER TABLE LASTVISITS ADD CONSTRAINT FK_LASTVISITS_SECURITYID FOREIGN KEY(SECURITYID) REFERENCES SITESECURITY(SECURITYID);
			</cfquery>
						
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createVideoLibraryTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif variables.tblCheck.columnExists('#arguments.ds#', 'VIDEOCATEGORY', 'PARENTVIDEOCATEGORYID')>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'VIDEO_TO_VIDEOCATEGORY')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE VIDEO_TO_VIDEOCATEGORY
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOCATEGORY')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE VIDEOCATEGORY
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOS')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE VIDEOS
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'SAMPLEMEDIA')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE SAMPLEMEDIA
				</cfquery>
			</cfif>
				<cfif variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOLIB')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE VIDEOLIB
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOSTATUS')>
				<cfquery name="create" datasource="#arguments.ds#">
				DROP TABLE VIDEOSTATUS
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'MEDIATYPE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE MEDIATYPE
				(
					MEDIATYPEID INT NOT NULL,
					MEDIATYPE VARCHAR(32) NOT NULL
				);
				ALTER TABLE MEDIATYPE ADD CONSTRAINT PK_MEDIATYPE PRIMARY KEY(MEDIATYPEID); 
				INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(1, 'Video');
				INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(2, 'Audio');
				INSERT INTO MEDIATYPE(MEDIATYPEID, MEDIATYPE) VALUES(3, 'File');
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOSTATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEOSTATUS
				(
					STATUS VARCHAR(32) NOT NULL
				);
				ALTER TABLE VIDEOSTATUS ADD CONSTRAINT PK_VIDEOSTATUS PRIMARY KEY(STATUS);
				INSERT INTO VIDEOSTATUS VALUES ('Public');
				INSERT INTO VIDEOSTATUS VALUES ('Private');
				INSERT INTO VIDEOSTATUS VALUES ('Inactive');
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOCATEGORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEOCATEGORY
				(
					VIDEOCATEGORYID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					CATEGORY VARCHAR(32) NOT NULL,
					SORTORDER BIGINT NOT NULL DEFAULT 0
				)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOLIB')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEOLIB
				(
					VID BIGINT NOT NULL PRIMARY KEY,
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
				ALTER TABLE VIDEOLIB ADD CONSTRAINT VIDEOLIB_VIDEOSTATUS FOREIGN KEY(STATUS) REFERENCES VIDEOSTATUS(STATUS);
				ALTER TABLE VIDEOLIB ADD CONSTRAINT VIDEOLIB_MEDIA FOREIGN KEY(MEDIATYPEID) REFERENCES MEDIATYPE(MEDIATYPEID); 
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEOS
				(
					VID BIGINT NOT NULL,
					LENGTH BIGINT NOT NULL
				)
				ALTER TABLE VIDEOS ADD CONSTRAINT PK_VIDEOS PRIMARY KEY(VID);
				ALTER TABLE VIDEOS ADD CONSTRAINT VIDEOS_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SAMPLEMEDIA')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SAMPLEMEDIA
				(
					SAMPLEID BIGINT NOT NULL,
					SAMPLEPATH VARCHAR(1024) NOT NULL,
					VID BIGINT NOT NULL
				)
				ALTER TABLE SAMPLEMEDIA ADD CONSTRAINT PK_SAMPLEMEDIA PRIMARY KEY(SAMPLEID);
				ALTER TABLE SAMPLEMEDIA ADD CONSTRAINT SAMPLEMEDIA_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIEWRECORD')>
			<cfquery name="create" datasource="#arguments.ds#">
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
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEO_TO_CATEGORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEO_TO_CATEGORY
				(
					VID BIGINT NOT NULL PRIMARY KEY,
					VIDEOCATEGORYID INT NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL,
					SORTORDER BIGINT NOT NULL DEFAULT 0
				)
				ALTER TABLE VIDEO_TO_CATEGORY ADD CONSTRAINT VIDEO_TO_CATEGORY_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
				ALTER TABLE VIDEO_TO_CATEGORY ADD CONSTRAINT VIDEO_TO_CATEGORY_VIDEOCATEGORY FOREIGN KEY(VIDEOCATEGORYID) REFERENCES VIDEOCATEGORY(VIDEOCATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'USERVIEW')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE USERVIEW
				(
					VIEWID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL
				)
				ALTER TABLE USERVIEW ADD CONSTRAINT PK_UESRVIEW PRIMARY KEY(VIEWID);
				ALTER TABLE USERVIEW ADD CONSTRAINT USERVIEW_VIEWRECORD FOREIGN KEY(VIEWID) REFERENCES VIEWRECORD(VIEWID);
				ALTER TABLE USERVIEW ADD CONSTRAINT USERVIEW_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'VIDEOLENGTH')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE VIDEOLENGTH
				(
					VID BIGINT NOT NULL,
					LENGTH BIGINT NOT NULL
				)
				ALTER TABLE VIDEOLENGTH ADD CONSTRAINT PK_VIDEOLENGTH PRIMARY KEY(VID);
				ALTER TABLE VIDEOLENGTH ADD CONSTRAINT FK_VIDEOLENGTH_VIDEOLIB FOREIGN KEY(VID) REFERENCES VIDEOLIB(VID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createWebPageTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'WPSTATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE WPSTATUS
				(
					WPSTATUS VARCHAR(128) NOT NULL PRIMARY KEY
				);
			</cfquery>
		</cfif>
			
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'WPVERSION')>	
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE WPVERSION
				(
					WPID BIGINT NOT NULL,
					NAME VARCHAR(128) NOT NULL,
					URLNAME VARCHAR(128) NOT NULL,
					WPCONTENT NTEXT NOT NULL,
					TITLE VARCHAR(1024),
					KEYWORDS VARCHAR(1024),
					DESCRIPTION VARCHAR(1024),
					WPSTATUS VARCHAR(128) NOT NULL,
					STARTDATE VARCHAR(16) NOT NULL,
					ENDDATE VARCHAR(16) NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL,
					AUTHORID BIGINT NOT NULL,
					IGNOREENDDATE BIT DEFAULT 0 NOT NULL
				);
				
				ALTER TABLE WPVERSION ADD CONSTRAINT WPVERSION_PK PRIMARY KEY(WPID,CREATEDON);
				ALTER TABLE WPVERSION ADD CONSTRAINT WPVERSION_WPSTATUS FOREIGN KEY(WPSTATUS) REFERENCES WPSTATUS(WPSTATUS);
			</cfquery>	
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'WPPARENT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE WPPARENT
				(
					WPID BIGINT NOT NULL,
					PID BIGINT NOT NULL
				);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','WPPARENT','NESTLEVEL')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE WPPARENT ADD NESTLEVEL INT
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','WPPARENT','SORTORDER')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE WPPARENT ADD SORTORDER VARCHAR(2048)
			</cfquery>
		</cfif>
			
		<cfloop list="#variables.statuslist#" index="i">	
			<cfinvoke component="webpage" method="getWPStatusList" webdsn="#arguments.ds#" myStatus="#i#" returnvariable="myStatusList">
			<cfif myStatusList.recordcount eq 0>
			<cfquery name="create" datasource="#arguments.ds#">
				INSERT INTO WPSTATUS
				(WPSTATUS)
				VALUES
				(<cfqueryparam value="#i#">)
			</cfquery>
			</cfif>
		</cfloop>
		
		<cfif not variables.tblCheck.viewExists('#arguments.ds#', 'UNIQUEWPID')>
			<cfquery name="create" datasource="#arguments.ds#">
			CREATE VIEW UNIQUEWPID AS
				SELECT WPID, MAX(CREATEDON) AS CREATEDON
				FROM WPVERSION
				GROUP BY WPID;
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'WPTEMPLATE')>
			<cfquery name="create" datasource="#arguments.ds#">
			CREATE TABLE WPTEMPLATE
			(
				WPTEMPLATEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				NAME VARCHAR(256) NOT NULL,
				DESCRIPTION VARCHAR(1024),
				TEMPLATE NTEXT NOT NULL,
				IMAGEPATH VARCHAR(256),
				STATUS VARCHAR(128) NOT NULL DEFAULT 'Published'
			);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createCoupounTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfset var drop =0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'IFTABLE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE IFTABLE
				(
					RULEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
					CATEGORYID INT,
					VIDEOCATEGORYID INT,
					ID BIGINT,
					QUANTITY INTEGER,
					TOTALPRICE FLOAT DEFAULT 0,
					STARTDATE VARCHAR(16),
					ENDDATE VARCHAR(16)
				);
				ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_PRODUCTCATEGORY FOREIGN KEY(CATEGORYID) REFERENCES PRODUCTCATEGORY(CATEGORYID);
				ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
				ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_VIDEOCATEGORY FOREIGN KEY(VIDEOCATEGORYID) REFERENCES VIDEOCATEGORY(VIDEOCATEGORYID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'THENTABLE')>
			<cfquery name="create" datasource="#arguments.ds#">	
				CREATE TABLE THENTABLE
				(
					RULEID BIGINT NOT NULL,
					CATEGORYID INT,
					VIDEOCATEGORYID INT,
					ID BIGINT,
					QUANTITY INTEGER,
					DISCOUNTPERCENT FLOAT NOT NULL DEFAULT 0,
					DISCOUNT FLOAT NOT NULL DEFAULT 0 
				);
				ALTER TABLE THENTABLE ADD CONSTRAINT THENTABLE_IFTABLE FOREIGN KEY(RULEID) REFERENCES IFTABLE(RULEID);
				ALTER TABLE THENTABLE ADD CONSTRAINT THENTABLE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			</cfquery>
		</cfif>
		
		<!--- If this site has old coupoun tables, drop them first--->
		<cfif variables.tblCheck.columnExists('#arguments.ds#', 'COUPOUN', 'COUPOUNCODE')>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'COUPOUNTOITEM')>
				<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE COUPOUNTOITEM
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'COUPOUNTOTRANSACTION')>
				<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE COUPOUNTOTRANSACTION
				</cfquery>
			</cfif>
			<cfif variables.tblCheck.tableExists('#arguments.ds#', 'COUPOUN')>
				<cfquery name="drop" datasource="#arguments.ds#">
					DROP TABLE COUPOUN
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'COUPOUN')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE COUPOUN
				(
					COUPOUN VARCHAR(16) NOT NULL,
					RULEID BIGINT NOT NULL,
					CREATEDON VARCHAR(16) NOT NULL,
					NOOFTIMESALLOWED INT NOT NULL DEFAULT 1
				);
				ALTER TABLE COUPOUN ADD CONSTRAINT PK_COUPOUN PRIMARY KEY(COUPOUN);
				ALTER TABLE COUPOUN ADD CONSTRAINT FK_COUPOUN_IFTABLE FOREIGN KEY(RULEID) REFERENCES IFTABLE(RULEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'COUPOUNUSED')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE COUPOUNUSED
				(
					COUPOUN VARCHAR(16) NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL,
					NAMEID BIGINT NOT NULL
				);
				ALTER TABLE COUPOUNUSED ADD CONSTRAINT FK_COUPOUNUSED_COUPOUN FOREIGN KEY(COUPOUN) REFERENCES COUPOUN(COUPOUN);
				ALTER TABLE COUPOUNUSED ADD CONSTRAINT FK_COUPOUNUSED_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createReviewTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'REVIEW')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE REVIEW
				(
					REVIEWID bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
					REVIEW ntext NULL,
					STARS bigint NOT NULL,
					AUTHORID bigint NOT NULL,
					REVIEWOFCONTACTID bigint NULL,
					STATUS varchar(64) NULL
				);
				ALTER TABLE REVIEW ADD  CONSTRAINT FK_REVIEW_AUTHOR FOREIGN KEY(AUTHORID) REFERENCES NAME (NAMEID);
				ALTER TABLE REVIEW ADD  CONSTRAINT FK_REVIEW_OFCONTACT FOREIGN KEY(REVIEWOFCONTACTID) REFERENCES NAME (NAMEID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.columnExists('#arguments.ds#','REVIEW','STATUS')>
			<cfquery name="create" datasource="#arguments.ds#">
				ALTER TABLE REVIEW ADD STATUS VARCHAR(64)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createAudioLibTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'AUDIOLIB')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE AUDIOLIB
				(
					VID BIGINT NOT NULL PRIMARY KEY,
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
				ALTER TABLE AUDIOLIB ADD CONSTRAINT AUDIOLIB_VIDEOSTATUS FOREIGN KEY(STATUS) REFERENCES VIDEOSTATUS(STATUS);
				ALTER TABLE AUDIOLIB ADD CONSTRAINT AUDIOLIB_MEDIA FOREIGN KEY(MEDIATYPEID) REFERENCES MEDIATYPE(MEDIATYPEID);
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createForumTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','FORUMS')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE FORUMS
					(
						FORUMID BIGINT NOT NULL IDENTITY(1,1),
						NAME VARCHAR(1024) NOT NULL,
						DESCRIPTION VARCHAR(1024),
						CREATEDON VARCHAR(16) NOT NULL,
						STATUS INT DEFAULT 1,
						LASTUPDATED VARCHAR(16),
						NOOFTOPICS BIGINT NOT NULL DEFAULT 0,
						NOOFPOSTS BIGINT NOT NULL DEFAULT 0,
						LASTPOSTID BIGINT,
						LASTPOSTSUBJECT NTEXT,
						LASTPOSTERID BIGINT,
						LASTPOSTERNAME VARCHAR(128),
						LASTPOSTDATE VARCHAR(16)
					);
					ALTER TABLE FORUMS ADD CONSTRAINT PK_FORUMS PRIMARY KEY(FORUMID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','FORUMS_RELATIONS')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE FORUMS_RELATIONS
					(
						RELATIONID BIGINT NOT NULL IDENTITY(1,1),
						FORUMID BIGINT NOT NULL,
						PARENTID BIGINT NOT NULL
					)
					ALTER TABLE FORUMS_RELATIONS ADD CONSTRAINT PK_FORUMS_RELATIONS PRIMARY KEY(RELATIONID);
					ALTER TABLE FORUMS_RELATIONS ADD CONSTRAINT FK_FORUMS_RELATIONS_FORUM_CHILD FOREIGN KEY(FORUMID) REFERENCES FORUMS(FORUMID);
					ALTER TABLE FORUMS_RELATIONS ADD CONSTRAINT FK_FORUMS_RELATIONS_FORUM_PARENT FOREIGN KEY(FORUMID) REFERENCES FORUMS(FORUMID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','TOPICS')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE TOPICS
					(
						TOPICID BIGINT NOT NULL IDENTITY(1,1),
						FORUMID BIGINT NOT NULL,
						TOPICAPPROVED BIT NOT NULL DEFAULT 1,
						TOPICREPORTED BIT NOT NULL DEFAULT 0,
						TOPICTITLE NTEXT NOT NULL,
						TOPICPOSTER BIGINT NOT NULL,
						TOPICPOSTERNAME VARCHAR(128) NOT NULL,
						TOPICDELETED BIT NOT NULL DEFAULT 0,
						CREATEDON VARCHAR(16) NOT NULL,
						NOOFVIEWS BIGINT NOT NULL DEFAULT 0,
						NOOFREPLIES BIGINT NOT NULL DEFAULT 0,
						LASTPOSTID BIGINT,
						LASTPOSTERID BIGINT,
						LASTPOSTERNAME VARCHAR(128),
						LASTPOSTDATE VARCHAR(16),
						LASTUPDATED VARCHAR(16)
					);
					ALTER TABLE TOPICS ADD CONSTRAINT PK_TOPICS PRIMARY KEY(TOPICID);
					ALTER TABLE TOPICS ADD CONSTRAINT FK_TOPICS_FORUMS FOREIGN KEY(FORUMID) REFERENCES FORUMS(FORUMID);
					ALTER TABLE TOPICS ADD CONSTRAINT FK_TOPICS_NAME FOREIGN KEY(TOPICPOSTER) REFERENCES NAME(NAMEID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','POSTS')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE POSTS
					(
						POSTID BIGINT NOT NULL IDENTITY(1,1),
						TOPICID BIGINT NOT NULL,
						FORUMID BIGINT NOT NULL,
						POSTERID BIGINT NOT NULL,
						POSTERIP VARCHAR(16),
						POSTTIME VARCHAR(16),
						POSTAPPROVED BIT DEFAULT 1,
						POSTREPORTED BIT DEFAULT 0,
						POSTDELETED  BIT DEFAULT 0,
						POSTSUBJECT NTEXT,
						POSTTEXT NTEXT
					);
					ALTER TABLE POSTS ADD CONSTRAINT PK_POSTS PRIMARY KEY(POSTID);
					ALTER TABLE POSTS ADD CONSTRAINT FK_POSTS_FORUMS FOREIGN KEY(FORUMID) REFERENCES FORUMS(FORUMID); 
					ALTER TABLE POSTS ADD CONSTRAINT FK_POSTS_NAME FOREIGN KEY(POSTERID) REFERENCES NAME(NAMEID);
					ALTER TABLE POSTS ADD CONSTRAINT FK_POSTS_TOPICS FOREIGN KEY(TOPICID) REFERENCES TOPICS(TOPICID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','TOPICWATCH')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE TOPICWATCH
					(
						TOPICID BIGINT NOT NULL,
						NAMEID BIGINT NOT NULL,
						NOTIFYSTATUS BIT NOT NULL
					)
					ALTER TABLE TOPICWATCH ADD CONSTRAINT PK_TOPICWATCH PRIMARY KEY(TOPICID,NAMEID);
					ALTER TABLE TOPICWATCH ADD CONSTRAINT FK_TOPICWATCH_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
					ALTER TABLE TOPICWATCH ADD CONSTRAINT FK_TOPICWATCH_TOPICS FOREIGN KEY(TOPICID) REFERENCES TOPICS(TOPICID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','PRIVMSGS')>
				<cfquery name="create" datasource="#arguments.ds#">			
					CREATE TABLE PRIVMSGS
					(
						MSGSID BIGINT NOT NULL IDENTITY(1,1),
						MSGSTIME VARCHAR(16) NOT NULL,
						MSGSAUTHOR BIGINT NOT NULL,
						MSGSSUBJECT NTEXT,
						MSGSTEXT NTEXT NOT NULL
					);
					ALTER TABLE PRIVMSGS ADD CONSTRAINT PK_PRIVMSGS PRIMARY KEY(MSGSID)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','MSGSTO')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE MSGSTO
					(
						MSGSTOID BIGINT IDENTITY(1,1) NOT NULL,
						MSGSID BIGINT NOT NULL,
						MSGSFROM BIGINT NOT NULL,
						MSGSTO BIGINT NOT NULL,
						MSGSDELETED BIT DEFAULT 0,
						MSGSNEW BIT DEFAULT 1,
						MSGSFORWARDED BIT DEFAULT 0,
						MSGSREPLIED BIT DEFAULT 0,
						MSGSFOLDER INT NOT NULL DEFAULT -2
					)
					ALTER TABLE MSGSTO ADD CONSTRAINT PK_MSGSTO PRIMARY KEY(MSGSTOID)
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','POSTREPORT')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE POSTREPORT
					(
						REPORTID BIGINT IDENTITY(1,1) NOT NULL,
						USERID BIGINT NOT NULL,
						USERNOTIFY BIT NOT NULL,
						REPORTCLOSED BIT NOT NULL DEFAULT 0,
						REPORTTIME VARCHAR(16) NOT NULL,
						POSTID BIGINT,
						TOPICID BIGINT,
						FORUMID BIGINT
					)
					ALTER TABLE POSTREPORT ADD CONSTRAINT PK_POSTREPORT PRIMARY KEY(REPORTID);
					ALTER TABLE POSTREPORT ADD CONSTRAINT FK_POSTREPORT_NAME FOREIGN KEY(USERID) REFERENCES NAME(NAMEID);
					ALTER TABLE POSTREPORT ADD CONSTRAINT FK_POSTREPORT_POSTS FOREIGN KEY(POSTID) REFERENCES POSTS(POSTID);				
					ALTER TABLE POSTREPORT ADD CONSTRAINT FK_POSTREPORT_TOPICS FOREIGN KEY(TOPICID) REFERENCES TOPICS(TOPICID);
					ALTER TABLE POSTREPORT ADD CONSTRAINT FK_POSTREPORT_FORUMS FOREIGN KEY(FORUMID) REFERENCES FORUMS(FORUMID);
				</cfquery>
			</cfif>
			
			<cfif not variables.tblCheck.tableExists('#arguments.ds#','POSTIMAGE')>
				<cfquery name="create" datasource="#arguments.ds#">
					CREATE TABLE POSTIMAGE
					(
						POSTIMAGEID BIGINT IDENTITY(1,1) NOT NULL,
						POSTID BIGINT NOT NULL,
						IMAGEID BIGINT NOT NULL,
						STATUS INT NOT NULL DEFAULT 1
					)
					ALTER TABLE POSTIMAGE ADD CONSTRAINT PK_POSTIMAGE PRIMARY KEY(POSTIMAGEID);
					ALTER TABLE POSTIMAGE ADD CONSTRAINT FK_POSTIMAGE_POSTS FOREIGN KEY(POSTID) REFERENCES POSTS(POSTID);
					ALTER TABLE POSTIMAGE ADD CONSTRAINT FK_POSTIMAGE_IMAGE FOREIGN KEY(IMAGEID) REFERENCES IMAGE(IMAGEID);
				</cfquery>
			</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="updates" returntype="void" output="false" access="public" hint="I update database. All the update script should be written here">
		<cfargument name="ds" required="true" type="string" hint="I update database">
		<cfset var update=0>	
		<cfif not variables.tblcheck.tableExists('#arguments.ds#','NAVITEMS')>
			<cfquery name="update" datasource="#arguments.ds#">
				ALTER TABLE NAVITEMS ALTER COLUMN SORTORDER INT 
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="createEmailServersTables" returntype="void" output="false" access="public" hint="I create Imageservers table. It function should not be included in buildAllTables">
		<cfargument name="ds" required="true" type="string" hint="database name">
		<cfset var create=0>
		<cfset var addserver=0>
		<cfif NOT variables.tblcheck.tableExists(arguments.ds,'EMAILSERVERS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE EMAILSERVERS
				(
					SERVERID BIGINT IDENTITY(1,1) NOT NULL,
					SERVERNAME VARCHAR(384) NOT NULL,
					PORT VARCHAR(8) NOT NULL,
					USERNAME VARCHAR(32) NOT NULL,
					PASSWORD VARCHAR(32) NOT NULL,
					TOKEN BIT NOT NULL DEFAULT 0,
					STATUS VARCHAR(1) NOT NULL DEFAULT 1
				);
				ALTER TABLE EMAILSERVERS ADD CONSTRAINT PK_EMAILSERVERS PRIMARY KEY (SERVERID);
			</cfquery>
			<cfquery name="addserver" datasource="#arguments.ds#">
				INSERT INTO EMAILSERVERS
				(
					SERVERNAME,
					PORT,
					USERNAME,
					PASSWORD,
					TOKEN
				)
				VALUES
				(
					<cfqueryparam value="ns1l.web-host.net">,
					<cfqueryparam value="25">,
					<cfqueryparam value="drew">,
					<cfqueryparam value="spidey01">,
					<cfqueryparam value="1">
				)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>

	<cffunction name="createDashboardTables" returntype="void" output="false" access="public" hint="I create the new more simple tracking tables for QDCMS 2.0">

		<cfargument name="ds" required="true" type="string" hint="database name">
		<cfset var create=0>
		<cfif NOT variables.tblcheck.tableExists(arguments.ds,'DASHBOARD')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE DASHBOARD
				(
					STREAMID BIGINT IDENTITY(1,1) NOT NULL,
					TIMEDATE VARCHAR(16) NOT NULL,
					MASTERNAMEID BIGINT NOT NULL,
					STREAM NTEXT NOT NULL
				)
			</cfquery>
		</cfif>
		<cfreturn >
	</cffunction>
	
	<cffunction name="createShiftTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTCATEGORYTYPE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTCATEGORYTYPE
				(
					SHIFTCATEGORYTYPEID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTCATEGORYTYPE VARCHAR(128) NOT NULL UNIQUE,
					DISPLAYCOLOR VARCHAR(128)
				)
				ALTER TABLE SHIFTCATEGORYTYPE ADD CONSTRAINT PK_SHIFTCATEGORYTYPE PRIMARY KEY(SHIFTCATEGORYTYPEID)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTBENEFIT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTBENEFIT
				(
					SHIFTBENEFITID BIGINT NOT NULL IDENTITY(1,1),
					BENEFITNAME VARCHAR(128) NOT NULL
				);
				ALTER TABLE SHIFTBENEFIT ADD CONSTRAINT PK_SHIFTBENEFIT PRIMARY KEY(SHIFTBENEFITID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'BENEFIT2SHIFTCATEGORY')>
			<cfquery name="create" datasource="#arguemtns.ds#">
			CREATE TABLE  BENEFIT2SHIFTCATEGORY
			(
				SHIFTCATEGORYTYPEID bigint NOT NULL,
				SHIFTBENEFITID bigint NOT NULL,
				REQUIREDHOURS bigint NOT NULL
			);
			ALTER TABLE BENEFIT2SHIFTCATEGORY ADD CONSTRAINT PK_BENEFIT2SHIFTCATEGORY PRIMARY KEY(SHIFTCATEGORYTYPEID,SHIFTBENEFITID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTS
				(
					SHIFTID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTNAME VARCHAR(128) NOT NULL,
					SHIFTLOCATION VARCHAR(256),
					SHIFTSTARTTIME VARCHAR(16),
					SHIFTENDTIME VARCHAR(16),
					ORGANIZERID BIGINT,
					NOTES NTEXT,
					CATEGORYTYPEID BIGINT NOT NULL,
					EVENTID VARCHAR(16) NOT NULL
				);
				ALTER TABLE SHIFTS ADD CONSTRAINT PK_SHIFTS PRIMARY KEY(SHIFTID);
				ALTER TABLE SHIFTS ADD CONSTRAINT FK_SHIFTS_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTINVENTORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTINVENTORY
				(
					SHIFTINVENTORYID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTID BIGINT NOT NULL,
					TOTALCEILING BIGINT NOT NULL,
					CURRENTTOTAL BIGINT NOT NULL
				);
				ALTER TABLE SHIFTINVENTORY ADD CONSTRAINT PK_SHIFTINVENTORY PRIMARY KEY(SHIFTINVENTORYID);
				ALTER TABLE SHIFTINVENTORY ADD CONSTRAINT FK_SHIFTINVENTORY_SHIFT FOREIGN KEY(SHIFTID) REFERENCES SHIFTS(SHIFTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFT2NAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFT2NAME
				(
					SHIFTID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL
				);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT PK_SHIFT2NAME PRIMARY KEY(SHIFTID,NAMEID);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT FK_SHIFT2NAME_SHIFT FOREIGN KEY(SHIFTID) REFERENCES SHIFTS(SHIFTID);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT FK_SHIFT2NAME_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>

		<cfreturn>
	</cffunction>
</cfcomponent>