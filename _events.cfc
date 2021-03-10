<!--- Note: All events are repeating events. If an event does not repeat, it appears in repeatingevents table once --->

<cfcomponent hint="I handle events">
<cfobject component="textConversions" name="txtConversions">
<cfobject component="timeDateConversion" name="DateTimes">
<cfobject component="qdDataMgr" name="tblCheck">

<!--- <cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#"> --->		
<cffunction name="init" accss="public" output="false" returntype="void" hint="Initialization, create table for recurring events if the tables are not already there">
	<cfargument name="ds" required="true" type="String" hint="datasource">
	<cfset var myURL = 0>
	<cfinvoke component="events" method="buildTables" ds="#arguments.ds#">
	<cfif listLen('#ds#', '.') eq 3>
		<cfset myURL = listGetAt('#ds#', 2, '.')>
	<cfelse>
		<cfset myURL = listFirst('#ds#', '.')>
	</cfif>
	<cfif myURL eq 'jbfcms'>
		<cfinvoke component="events" method="convertEventCategories" ds="#arguments.ds#">
	</cfif>
	<!--- <cfinvoke component="events" method="populateRepeatingEvents" ds="#arguments.ds#"> --->
</cffunction>

<cffunction name="buildTables" access="public" output="false" returntype="void" hint="I build the tables for events">
	<cfargument name="ds" type="string" required="true" hint="datasource">
	<cfset var eventcategorytbl=0>
	<cfset var eventtbl=0>
	<cfset var eventversiontbl=0>
	<cfset var event2addresstbl=0>
	<cfset var event2usergrouptbl=0>
	<cfset var repeatingeventstbl=0>
	<cfif not tblCheck.tableExists('#arguments.ds#', 'EVENTCATEGORY')>
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
	
	<cfif not tblCheck.tableExists('#arguments.ds#', 'EVENT')>
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
			ALTER TABLE EVENT ADD CONSTRAINT FK_EVENT_NAME FOREIGN KEY (CONTACTID) REFERENCES NAME(NAMEID); 
		
			INSERT INTO EVENTCATEGORY 
			(
				EVENTCATEGORYID, 
				EVENTCATEGORY, 
				VERSIONID
			) 
			VALUES
			(
				'2007113011051309',
				'Online Sign-up Event',
				'2007113011051309'
			)
		</cfquery>
	</cfif>
	
	<cfif not tblCheck.tableExists('#arguments.ds#', 'EVENTVERSION')>
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
	
	
	<cfif not tblCheck.tableExists('#arguments.ds#', 'EVENT2ADDRESS')>
		<cfquery name="event2addresstbl" datasource="#arguments.ds#">
			CREATE TABLE EVENT2ADDRESS(
			ADDRESSID bigint NULL,
			EVENTID varchar(16) NULL
			);
			ALTER TABLE EVENT2ADDRESS ADD CONSTRAINT FK_EVENT2ADDRESS_ADDRESS FOREIGN KEY(ADDRESSID) REFERENCES ADDRESS(ADDRESSID);
			ALTER TABLE EVENT2ADDRESS ADD CONSTRAINT FK_EVENT2ADDRESS_EVENT FOREIGN KEY (EVENTID) REFERENCES EVENT(EVENTID);		
		</cfquery>
	</cfif>
	<cfif not tblCheck.tableExists('#arguments.ds#','EVENT2USERGROUP')>
		<cfquery name="event2usergrouptbl" datasource="#arguments.ds#">
			CREATE TABLE EVENT2USERGROUP(
			EVENTID varchar(16) NOT NULL,
			USERGROUPID varchar(16) NOT NULL
			);
		</cfquery>
	</cfif>
	<cfif not tblCheck.tableExists('#arguments.ds#', 'REPEATINGEVENTS')>
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
			ALTER TABLE REPEATINGEVENTS ADD CONSTRAINT PK_REPEATINGEVENTS PRIMARY KEY (EVENTID, ACTUALSTARTTIME);
			ALTER TABLE REPEATINGEVENTS ADD CONSTRAINT FK_REPEATINGEVENTS_EVENTS FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="convertEventCategories" access="public" output="false" hint="I convert Event Categories so they can be used in qdcms">
	<cfargument name="ds" type="string" required="true" hint="datasource">
	<cfargument name="catList" type="string" required="false" default="Consignment Sale,Worker Confirmation email" hint="the list of the event categories you want to add the word Event on the end of">
	<cfloop list="#arguments.catList#" index="i">
		<cfinvoke component="events" method="getCategories" eventdsn="#arguments.ds#" excludelist="#i# Event" eventcategory="#i#" returnvariable="myCat">
		<cfif myCat.recordcount eq 1>
			<cfinvoke component="events" method="updateEventCat" ds="#arguments.ds#" eventcategoryid="#myCat.eventcategoryid#" eventcategory="#i# Event">
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="getCategories" access="public" returntype="query" output="false" hint="I get the event categories you request based on what you pass to me and return a recordset (EVENTCATEGORYID, EVENTCATEGORY, DESCRIPTION, PARENTEVENTCATEGORYID, STATUS, VERSIONID, VERSIONDESCRIPTION, COLOR, ARCHIVEXMO, AGENCYCATEGORYID)">
	<cfargument name="eventdsn" required="true" type="String" hint="datasource">
	<cfargument name="eventcategory" type="String" required="false" default="0" hint="name of the category you are looking for">
	<cfargument name="excludelist" type="string" required="false" default="0" hint="I am the list of categories you want to exclude from your get">
	<cfargument name="status" type="string" required="false" default="public" hint="Status of the category"> 
	<cfargument name="eventcategoryid" required="false" type="string" default="0" hint="the id of the eventcategory">
	<cfset var thisCategory=0>
	<cfquery name="thisCategory" datasource="#arguments.eventdsn#">
	SELECT
		EVENTCATEGORYID,
		EVENTCATEGORY,
		DESCRIPTION,
		PARENTEVENTCATEGORYID,
		STATUS,
		VERSIONID,
		VERSIONDESCRIPTION,
		COLOR,
		ARCHIVEXMO,
		AGENCYCATEGORYID
	FROM         
		EVENTCATEGORY
	WHERE 1=1
	<cfif eventcategory NEQ "0">
		AND EVENTCATEGORY like '%#arguments.eventcategory#%'
	</cfif>
	<cfif arguments.excludelist neq 0>
	AND EVENTCATEGORYID NOT IN (<cfqueryparam value="#arguments.excludelist#" list="true">)
	</cfif>
	<cfif arguments.status NEQ "all">
	AND STATUS = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif arguments.eventcategoryid NEQ "0">
	AND EVENTCATEGORYID=<cfqueryparam value="#arguments.eventcategoryid#" cfsqltype="cf_sql_varchar">
	</cfif>
	</cfquery>
		
<cfreturn thisCategory>
</cffunction>

<cffunction name="addEventCat" access="public" returntype="string" hint="I add event category">
	<cfargument name="ds" required="true" type="String" hint="datasource">
	<cfargument name="eventcategoryid" required="true" type="string" hint="the id of the eventcategory you wish to update">
	<cfargument name="eventcategory" type="String" required="false" hint="New name of the category you are updating">
	<cfargument name="DESCRIPTION" type="String" default="0" required="false" hint="description of the category you are updating">
	<cfargument name="PARENTEVENTCATEGORYID" type="String" default="0" required="false" hint="parent categoryid category you are updating">
	<cfargument name="STATUS" type="String" default="0" required="false" hint="status of the category you are updating">
	<cfargument name="COLOR" type="String" default="0" required="false" hint="Color of the category you are updating">
	<cfargument name="ARCHIVEXMO" type="String" default="0" required="false" hint="number of months you want to archive these types of events">
	<cfset var updateCategory=0>
	<cfset timedate=DateTimes.createtimedate()>
	<cfquery name="updateMyCat" datasource="#arguments.ds#">
	INSERT INTO EVENTCATEGORY
	(
		EVENTCATEGORYID,
		EVENTCATEGORY,
		DESCRIPTION,
		PARENTEVENTCATEGORYID,
		STATUS,
		COLOR,
		ARCHIVEXMO,
		VERSIONID
	)
	VALUES
	(
		<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.eventcategory#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.PARENTEVENTCATEGORYID#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.STATUS#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.COLOR#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#arguments.ARCHIVEXMO#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
	)
	</cfquery>
	<cfreturn timedate>
</cffunction>

<cffunction name="updateEventCat" access="public" returntype="void" output="false" hint="I update the event category information you pass to me">
	<cfargument name="ds" required="true" type="String" hint="datasource">
	<cfargument name="eventcategoryid" required="true" type="string" hint="the id of the eventcategory you wish to update">
	<cfargument name="eventcategory" type="String" required="false" hint="New name of the category you are updating">
	<cfargument name="DESCRIPTION" type="String" default="0" required="false" hint="description of the category you are updating">
	<cfargument name="PARENTEVENTCATEGORYID" type="String" default="0" required="false" hint="parent categoryid category you are updating">
	<cfargument name="STATUS" type="String" default="0" required="false" hint="status of the category you are updating">
	<cfargument name="COLOR" type="String" default="0" required="false" hint="Color of the category you are updating">
	<cfargument name="ARCHIVEXMO" type="String" default="0" required="false" hint="number of months you want to archive these types of events">
	<cfset var updateCategory=0>
	<cfquery name="updateMyCat" datasource="#arguments.ds#">
	UPDATE EVENTCATEGORY
	SET EVENTCATEGORYID = <cfqueryparam value="#arguments.EVENTCATEGORYID#">
	<cfif arguments.eventcategoryid EQ "0">
	,EVENTCATEGORY = <cfqueryparam value="#arguments.eventcategory#">
	</cfif>
	<cfif arguments.description neq 0>
	,DESCRIPTION = <cfqueryparam value="#arguments.description#">
	</cfif>
	<cfif arguments.COLOR neq 0>
	,COLOR = <cfqueryparam value="#arguments.COLOR#">
	</cfif>
	<cfif arguments.ARCHIVEXMO neq 0>
	,ARCHIVEXMO = <cfqueryparam value="#arguments.ARCHIVEXMO#">
	</cfif>
	<cfif arguments.STATUS neq 0>
	,STATUS = <cfqueryparam value="#arguments.STATUS#">
	</cfif>
	<cfif arguments.PARENTEVENTCATEGORYID neq 0>
	,PARENTEVENTCATEGORYID = <cfqueryparam value="#arguments.PARENTEVENTCATEGORYID#">
	</cfif>
	WHERE EVENTCATEGORYID = <cfqueryparam value="#arguments.eventcategoryid#">
	</cfquery>
</cffunction>

<cffunction name="createEventXML" access="public" returnType="xml" output="false" hint="I return the XML necessary to build the event XML">
<cfargument name="eventdsn" required="true" type="String" hint="datasource">
<cfset var getCalendarEvents=0>
<cfset var eventXML=0>
<cfinvoke component="events" method="getEvents" eventdsn="#arguments.eventdsn#" returnVariable="getCalendarEvents" />
<cfxml variable="eventXML">	
	<events>
	<cfoutput query="getCalendarEvents" group="eventid">
		<cfif frequency NEQ "none">
			<cfset dates = #repeatEvents("#starttime#","#endtime#","#frequency#","#repeatend#","#until#","#count#")#>
			<cfloop from="1" index="i" to="#arrayLen(dates)#">
				<Vevent>
					<id>#eventid##numberFormat(i,"00")#</id>
					<dtstart date="#xmlFormat(dates[i][1])#">#xmlFormat(left(dates[i][1],"8"))#</dtstart>
					<dtend date="#xmlFormat(dates[i][2])#">#xmlFormat(left(dates[i][2],"8"))#</dtend>
					<price  default="#xmlFormat(defaultprice)#" 
							discounttype="#xmlFormat(discounttype)#" 
							percentoff="#xmlFormat(percentoff)#"
							discountprice="#xmlFormat(discountprice)#"
							guestprice="#xmlFormat(guestprice)#"></price>
					<summary>#xmlFormat(eventname)#</summary>
					<url>#xmlFormat(eventurl)#</url>
					<organizer  firstname="#xmlFormat(contactfirstname)#" 
								lastname="#xmlFormat(contactlastname)#"
								phone="#xmlFormat(contactphone)#"
								email="#xmlFormat(contactemail)#"
								address1="#xmlFormat(contactaddress1)#"
								address2="#xmlFormat(contactaddress2)#"
								city="#xmlFormat(contactcity)#"
								state="#xmlFormat(contactstate)#"
								zip="#xmlFormat(contactzip)#"
								lat="#xmlFormat(contactlat)#"
								lon="#xmlFormat(contactlon)#"
								intersection="#xmlFormat(contactintersection)#">#xmlFormat(CONTACTFIRSTNAME)# #xmlformat(CONTACTLASTNAME)#</organizer>
					<desc>#xmlFormat(description)#</desc>
					<location  locationname="#xmlFormat(locationname)#" 
								phone="#xmlFormat(locationphone)#"
								id="#xmlFormat(locationid)#"
								email="#xmlFormat(locationemail)#"
								address1="#xmlFormat(locationaddress1)#"
								address2="#xmlFormat(locationaddress2)#"
								city="#xmlFormat(locationcity)#"
								state="#xmlFormat(locationstate)#"
								zip="#xmlFormat(locationzip)#"
								lat="#xmlFormat(locationlat)#"
								lon="#xmlFormat(locationlon)#"
								intersection="#xmlFormat(locationintersection)#">#xmlFormat(locationname)#</location>
				</Vevent>
			</cfloop>
		<cfelse>
			<Vevent>
					<id>#eventid#01</id>
					<dtstart date="#xmlFormat(starttime)#">#xmlFormat(left(starttime,"8"))#</dtstart>
					<dtend date="#xmlFormat(endtime)#">#xmlFormat(left(endtime,"8"))#</dtend>
					<price  default="#xmlFormat(defaultprice)#" 
							discounttype="#xmlFormat(discounttype)#" 
							percentoff="#xmlFormat(percentoff)#"
							discountprice="#xmlFormat(discountprice)#"
							guestprice="#xmlFormat(guestprice)#"></price>
					<summary>#xmlFormat(eventname)#</summary>
					<url>#xmlFormat(eventurl)#</url>
					<organizer  firstname="#xmlFormat(contactfirstname)#" 
								lastname="#xmlFormat(contactlastname)#"
								phone="#xmlFormat(contactphone)#"
								email="#xmlFormat(contactemail)#"
								address1="#xmlFormat(contactaddress1)#"
								address2="#xmlFormat(contactaddress2)#"
								city="#xmlFormat(contactcity)#"
								state="#xmlFormat(contactstate)#"
								zip="#xmlFormat(contactzip)#"
								lat="#xmlFormat(contactlat)#"
								lon="#xmlFormat(contactlon)#"
								intersection="#xmlFormat(contactintersection)#">#xmlFormat(CONTACTFIRSTNAME)# #xmlformat(CONTACTLASTNAME)#</organizer>
					<desc>#xmlFormat(description)#</desc>
					<location  locationname="#xmlFormat(locationname)#" 
								phone="#xmlFormat(locationphone)#"
								email="#xmlFormat(locationemail)#"
								id="#xmlFormat(locationid)#"
								address1="#xmlFormat(locationaddress1)#"
								address2="#xmlFormat(locationaddress2)#"
								city="#xmlFormat(locationcity)#"
								state="#xmlFormat(locationstate)#"
								zip="#xmlFormat(locationzip)#"
								lat="#xmlFormat(locationlat)#"
								lon="#xmlFormat(locationlon)#"
								intersection="#xmlFormat(locationintersection)#">#xmlFormat(locationname)#</location>
			</Vevent>
		</cfif>
	</cfoutput>
	</events>
	</cfxml>

<cfreturn eventXML>
</cffunction>

<cffunction name="getEvents" access="public" returntype="query" output="false" hint="I get the events you request based on what you pass to me and return a recordset (EVENTURL, CONTACTID, LOCATIONID, EVENTID,  EVENTNAME, PAGENAME,  STATUS,  VERSIONID, STARTTIME, ENDTIME,  ACTUALSTARTTIME, ACTUALENDTIME, SEDESCRIPTION, KEYWORDS,  TITLE,  DESCRIPTION, MENUIMAGECAPTION, MENUIMAGELINK,  PREDESSOREVENTID, PARENTEVENTID, FUSEACTIONID,  PEERORDERNUMBER,  IMAGEID,  PERCENTCOMPLETE, CUSTOMCSS, PRINTCSS, SCREENCSS, NAVNUM, PLACEHOLDER, ALTLAYOUT, SITEID, FREQUENCY, FROMEMAIL, CC, SUBJECT, MESSAGE, DEFAULTPRICE, DISCOUNTTYPE, PERCENTOFF, DISCOUNTPRICE, GUESTPRICE, INTERVAL, COUNT, UNTIL, REPEATEND, EVENTCATEGORYID, EVENTCATEGORY, LOCATIONNAME, LOCATIONEMAIL, LOCATIONPHONE,  LOCATIONADDRESS1, LOCATIONADDRESS2, LOCATIONCITY,  LOCATIONSTATE, LOCATIONCOUNTRY, LOCATIONZIP, LOCATIONINTERSECTION, LOCATIONLAT, LOCATIONLON, ONTACTFIRSTNAME, CONTACTLASTNAME, CONTACTPHONE, CONTACTEMAIL, CONTACTADDRESS1,  CONTACTADDRESS2, CONTACTCITY, CONTACTSTATE,  CONTACTCOUNTRY, CONTACTZIP, CONTACTINTERSECTION, CONTACTLAT, CONTACTLON)">
<cfargument name="eventdsn" required="true" type="String" hint="datasource">
<cfargument name="status" default="0" required="false" type="String" hint="status of the events you are looking for">
<cfargument name="eventcategory" default="0" type="String" required="false" hint="id of the category you are looking for">
<cfargument name="sortlist" default="0" type="String" required="false" hint="a list of the columns you want to sort by">
<cfargument name="repeatend" type="String" required="false" default="0" hint="timestamp when repeating events ends">
<cfset var thisevent=0>
<cfquery name="thisevent" datasource="#arguments.eventdsn#">
SELECT
	EVENT.URL AS EVENTURL,
	EVENT.CONTACTID,
	EVENTVERSION.LOCATIONID,
	EVENTVERSION.EVENTID, 
	EVENTVERSION.EVENTNAME, 
	EVENTVERSION.PAGENAME, 
	EVENTVERSION.STATUS, 
	EVENTVERSION.VERSIONID, 
	EVENTVERSION.STARTTIME,
	EVENTVERSION.ENDTIME, 
	EVENTVERSION.ACTUALSTARTTIME, 
	EVENTVERSION.ACTUALENDTIME, 
	EVENTVERSION.SEDESCRIPTION, 
	EVENTVERSION.KEYWORDS, 
	EVENTVERSION.TITLE, 
	EVENTVERSION.DESCRIPTION, 
	EVENTVERSION.MENUIMAGECAPTION, 
	EVENTVERSION.MENUIMAGELINK, 
	EVENTVERSION.PREDESSOREVENTID, 
	EVENTVERSION.PARENTEVENTID, 
	EVENTVERSION.FUSEACTIONID, 
	EVENTVERSION.PEERORDERNUMBER, 
	EVENTVERSION.IMAGEID, 
	EVENTVERSION.PERCENTCOMPLETE, 
	EVENTVERSION.CUSTOMCSS,
	EVENTVERSION.PRINTCSS,
	EVENTVERSION.SCREENCSS,
	EVENTVERSION.NAVNUM,
	EVENTVERSION.PLACEHOLDER,
	EVENTVERSION.ALTLAYOUT,
	EVENTVERSION.SITEID,
	EVENTVERSION.FREQUENCY,
	EVENTVERSION.FROMEMAIL,
	EVENTVERSION.CC,
	EVENTVERSION.SUBJECT,
	EVENTVERSION.MESSAGE,
	EVENTVERSION.DEFAULTPRICE,
	EVENTVERSION.DISCOUNTTYPE,
	EVENTVERSION.PERCENTOFF,
	EVENTVERSION.DISCOUNTPRICE,
	EVENTVERSION.GUESTPRICE,
	EVENTVERSION.INTERVAL,
	EVENTVERSION.COUNT,
	EVENTVERSION.UNTIL,
	EVENTVERSION.REPEATEND,
	EVENTVERSION.CREATEDBYID,
	EVENTCATEGORY.EVENTCATEGORYID,
	EVENTCATEGORY.EVENTCATEGORY,
	EL.COMPANY AS LOCATIONNAME,
	EL.WEMAIL AS LOCATIONEMAIL,
	EL.WPHONE AS LOCATIONPHONE,
	EL.ADDRESS1 AS LOCATIONADDRESS1,
	EL.ADDRESS2 AS LOCATIONADDRESS2,
	EL.CITY AS LOCATIONCITY,
	EL.STATE AS LOCATIONSTATE,
	EL.COUNTRY AS LOCATIONCOUNTRY,
	EL.ZIP AS LOCATIONZIP,
	EL.INTERSECTION AS LOCATIONINTERSECTION,
	EL.LAT AS LOCATIONLAT,
	EL.LON AS LOCATIONLON,
	EC.FIRSTNAME AS CONTACTFIRSTNAME,
	EC.LASTNAME AS CONTACTLASTNAME,
	EC.WPHONE AS CONTACTPHONE,
	EC.WEMAIL AS CONTACTEMAIL,
	EC.ADDRESS1 AS CONTACTADDRESS1,
	EC.ADDRESS2 AS CONTACTADDRESS2,
	EC.CITY AS CONTACTCITY,
	EC.STATE AS CONTACTSTATE,
	EC.COUNTRY AS CONTACTCOUNTRY,
	EC.ZIP AS CONTACTZIP,
	EC.INTERSECTION AS CONTACTINTERSECTION,
	EC.LAT AS CONTACTLAT,
	EC.LON AS CONTACTLON
	FROM         
	EVENT
	LEFT JOIN vwNameAddress as EC
	ON EC.NAMEID = EVENT.CONTACTID,
	EVENTVERSION 
	LEFT JOIN vwNameAddress as EL
	ON EL.nameid = EVENTVERSION.LOCATIONID,
	EVENTCATEGORY
	WHERE
	EVENT.EVENTID = EVENTVERSION.EVENTID
	AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
	AND (EVENTVERSION.VERSIONID =
          (SELECT MAX(VERSIONID)
            FROM EVENTVERSION
            WHERE EVENTID = EVENT.EVENTID
            AND EVENTVERSION.STATUS <> 'Deleted'))
	<cfif arguments.eventcategory neq 0>AND EVENTCATEGORY.EVENTCATEGORY=<cfqueryparam value="#arguments.eventcategory#"></cfif>
	<cfif arguments.status neq 0>AND EVENTVERSION.STATUS=<cfqueryparam value="#arguments.status#"></cfif>
	<cfif arguments.repeatend NEQ 0>
	AND EVENTVERSION.REPEATEND=<cfqueryparam value="#arguments.repeatend#" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif arguments.sortlist neq 0>
	ORDER BY #arguments.sortlist#
	<cfelse>
	ORDER BY EVENT.EVENTID, EVENTVERSION.VERSIONID DESC
	</cfif>
</cfquery>
	
<cfreturn thisevent>
</cffunction>

<cffunction name="getEventInfo" access="public" returntype="query" output="false" hint="I get the event info for the eventid you pass to me, I will likely return several records since events are created with versioning I return this recordset (EVENTURL, CONTACTID, LOCATIONID, EVENTID,  EVENTNAME, PAGENAME,  STATUS,  VERSIONID, STARTTIME, ENDTIME,  ACTUALSTARTTIME, ACTUALENDTIME, SEDESCRIPTION, KEYWORDS,  TITLE,  DESCRIPTION, MENUIMAGECAPTION, MENUIMAGELINK,  PREDESSOREVENTID, PARENTEVENTID, FUSEACTIONID,  PEERORDERNUMBER,  IMAGEID,  PERCENTCOMPLETE, CUSTOMCSS, PRINTCSS, SCREENCSS, NAVNUM, PLACEHOLDER, ALTLAYOUT, SITEID, FREQUENCY, FROMEMAIL, CC, SUBJECT, MESSAGE, DEFAULTPRICE, DISCOUNTTYPE, PERCENTOFF, DISCOUNTPRICE, GUESTPRICE, INTERVAL, COUNT, UNTIL, REPEATEND, EVENTCATEGORYID, EVENTCATEGORY, LOCATIONNAME, LOCATIONEMAIL, LOCATIONPHONE,  LOCATIONADDRESS1, LOCATIONADDRESS2, LOCATIONCITY,  LOCATIONSTATE, LOCATIONCOUNTRY, LOCATIONZIP, LOCATIONINTERSECTION, LOCATIONLAT, LOCATIONLON, ONTACTFIRSTNAME, CONTACTLASTNAME, CONTACTPHONE, CONTACTEMAIL, CONTACTADDRESS1,  CONTACTADDRESS2, CONTACTCITY, CONTACTSTATE,  CONTACTCOUNTRY, CONTACTZIP, CONTACTINTERSECTION, CONTACTLAT, CONTACTLON)">
	<cfargument name="eventdsn" required="true" type="String" hint="datasource">
	<cfargument name="eventid" required="false" default="0" type="string" hint="the id for the event you are looking for">
	<cfargument name="eventinstanceid" required="false" default="0" type="string" hint="the instance id of the event">
	<cfset var myevent=0>
	<cfset var get=0>
	<cfif arguments.eventinstanceid NEQ 0>
		<cfquery name="get" datasource="#arguments.eventdsn#">
			SELECT TOP 1 EVENTID FROM REPEATINGEVENTS WHERE EVENTINSTANCEID=<cfqueryparam value="#arguments.eventinstanceid#" cfsqltype="cf_sql_varchar">  
		</cfquery>
		<cfset arguments.eventid=get.eventid>
	</cfif>
	
	<cfquery name="myevent" datasource="#arguments.eventdsn#">
	SELECT
		EVENT.URL AS EVENTURL,
		EVENT.CONTACTID,
		EVENTVERSION.LOCATIONID,
		EVENTVERSION.EVENTID, 
		EVENTVERSION.EVENTNAME, 
		EVENTVERSION.PAGENAME, 
		EVENTVERSION.STATUS, 
		EVENTVERSION.VERSIONID, 
		EVENTVERSION.STARTTIME AS REGSTARTTIME,
		EVENTVERSION.ENDTIME AS REGENDTIME, 
		EVENTVERSION.ACTUALSTARTTIME AS STARTTIME,
		EVENTVERSION.ACTUALENDTIME AS ENDTIME,
		EVENTVERSION.ACTUALSTARTTIME, 
		EVENTVERSION.ACTUALENDTIME, 
		EVENTVERSION.SEDESCRIPTION, 
		EVENTVERSION.KEYWORDS, 
		EVENTVERSION.TITLE, 
		EVENTVERSION.DESCRIPTION, 
		EVENTVERSION.MENUIMAGECAPTION, 
		EVENTVERSION.MENUIMAGELINK, 
		EVENTVERSION.PREDESSOREVENTID, 
		EVENTVERSION.PARENTEVENTID, 
		EVENTVERSION.FUSEACTIONID, 
		EVENTVERSION.PEERORDERNUMBER, 
		EVENTVERSION.IMAGEID, 
		EVENTVERSION.PERCENTCOMPLETE, 
		EVENTVERSION.CUSTOMCSS,
		EVENTVERSION.PRINTCSS,
		EVENTVERSION.SCREENCSS,
		EVENTVERSION.NAVNUM,
		EVENTVERSION.PLACEHOLDER,
		EVENTVERSION.ALTLAYOUT,
		EVENTVERSION.SITEID,
		EVENTVERSION.FREQUENCY,
		EVENTVERSION.FROMEMAIL,
		EVENTVERSION.CC,
		EVENTVERSION.SUBJECT,
		EVENTVERSION.MESSAGE,
		EVENTVERSION.DEFAULTPRICE,
		EVENTVERSION.DISCOUNTTYPE,
		EVENTVERSION.PERCENTOFF,
		EVENTVERSION.DISCOUNTPRICE,
		EVENTVERSION.GUESTPRICE,
		EVENTVERSION.INTERVAL,
		EVENTVERSION.COUNT AS REPEATAFTER,
		EVENTVERSION.UNTIL,
		EVENTVERSION.REPEATEND,
		EVENTCATEGORY.EVENTCATEGORYID,
		EVENTCATEGORY.EVENTCATEGORY,
		EL.COMPANY AS LOCATIONNAME,
		EL.WEMAIL AS LOCATIONEMAIL,
		EL.WPHONE AS LOCATIONPHONE,
		EL.ADDRESS1 AS LOCATIONADDRESS1,
		EL.ADDRESS2 AS LOCATIONADDRESS2,
		EL.CITY AS LOCATIONCITY,
		EL.STATE AS LOCATIONSTATE,
		EL.COUNTRY AS LOCATIONCOUNTRY,
		EL.ZIP AS LOCATIONZIP,
		EL.INTERSECTION AS LOCATIONINTERSECTION,
		EL.LAT AS LOCATIONLAT,
		EL.LON AS LOCATIONLON,
		EC.FIRSTNAME AS CONTACTFIRSTNAME,
		EC.LASTNAME AS CONTACTLASTNAME,
		EC.WPHONE AS CONTACTPHONE,
		EC.WEMAIL AS CONTACTEMAIL,
		EC.ADDRESS1 AS CONTACTADDRESS1,
		EC.ADDRESS2 AS CONTACTADDRESS2,
		EC.CITY AS CONTACTCITY,
		EC.STATE AS CONTACTSTATE,
		EC.COUNTRY AS CONTACTCOUNTRY,
		EC.ZIP AS CONTACTZIP,
		EC.INTERSECTION AS CONTACTINTERSECTION,
		EC.LAT AS CONTACTLAT,
		EC.LON AS CONTACTLON
	FROM         
		EVENT
	LEFT JOIN vwNameAddress as EC
	ON EC.NAMEID = EVENT.CONTACTID,
		EVENTVERSION 
	LEFT JOIN vwNameAddress as EL
	ON EL.nameid = EVENTVERSION.LOCATIONID,
		EVENTCATEGORY
	WHERE	EVENT.EVENTID = EVENTVERSION.EVENTID
	AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
	AND EVENT.EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	ORDER BY EVENT.EVENTID, EVENTVERSION.VERSIONID DESC
	</cfquery>
		
<cfreturn myevent>
</cffunction>

<cffunction name="updateEventStatus" access="public" output="false" returntype="void" hint="I update the status of the event you pass to me">
	<cfargument name="eventdsn" required="true" type="string" hint="datasource to use for the update">
	<cfargument name="eventid" required="true" type="string" hint="I am the ID of the event you want to update">
	<cfargument name="status" required="true" type="string" hint="I am the new status of the event">
	<cfset var updateStatus=0>
	<cfquery name="updateStatus" datasource="#arguments.eventdsn#">
		UPDATE EVENTVERSION
		SET STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		
		UPDATE REPEATINGEVENTS
		SET STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="addEvent" access="public" output="true" returntype="string" hint="I add a new event to the datasource you pass to me">
	<cfargument name="eventdsn" type="string" required="true" hint="I am the datasource for the event you would like to add">
	<cfargument name="eventname" type="string" required="true" hint="I am the name of the event you are adding">
	<cfargument name="eventcategoryid" type="string" required="true" hint="I am the id of the event category you are createing this event in">
	<cfargument name="description" type="string" required="false" hint="I am the description of the event you are creating" default="">
	<cfargument name="status" type="string" required="false" hint="I am the status of the event you are creating" default="pending">
	<cfargument name="starttime" type="string" required="false" hint="I am the startday and time of the event you are creating" default="">
	<cfargument name="endtime" type="string" required="false" hint="I am the endday and time of the event you are creating" default="">
	<cfargument name="repeat" type="string" required="false" hint="I am when this event will repeat (every day, every year, every month) I map to the Frequency field in the database" default="">
	<cfargument name="repeatdate" type="string" required="false" hint="I am the date in which the event you are creating will end" default="">
	<cfargument name="repeatend" type="string" required="false" hint="I am how the event will repeat, I should be either Never or repeat-date, I default to Never" default="Never">
	<cfargument name="fromemail" type="string" required="false" hint="I am the email address from which you wish to send the email confirmation message for the event you are creating" default="">
	<cfargument name="cc" type="string" required="false" hint="I am the email address of the person you want to cc with each email confirmation message for the event you are creating" default="">
	<cfargument name="subject" type="string" required="false" hint="I am the confirmation message subject for the event you are creating" default="">
	<cfargument name="message" type="string" required="false" hint="I am the confirmation message for the event you are creating" default="">
	<cfargument name="defaultprice" type="string" required="false" hint="I am the regular price the event you are creating" default="">
	<cfargument name="discountType" type="string" required="false" hint="I am the discount type for the event you are creating" default="">
	<cfargument name="percentOff" type="string" required="false" hint="I am the Percent off for the event you are creating" default="">
	<cfargument name="discountprice" type="string" required="false" hint="I am the Guest Price for the event you are creating" default="">
	<cfargument name="guestprice" type="string" required="false" hint="I am the description of the event you are creating" default="">
	<cfargument name="eventinterval" type="string" required="false" hint="I do not really understand what I am used for, but I default to 1" default="1">
	<cfargument name="eventurl" type="string" required="false" hint="I am the for the event, please leave off the http:// when you create me, I just need the domain" default="">
	<cfargument name="repeatafter" type="string" required="false"  hint="I am the number of occurances in which the event you are creating will end, I default to 1" default="1">
	<cfargument name="parenteventid" type="string" required="false" hint="I am the parent event id for this event, if you do not pass me in I default to 0" default="0">
	<cfargument name="createdbyid" type="string" required="false" hint="I am the name id of the person creating the event" default="0">
	<cfargument name="regstarttime" type="string" required="false" hint="I am the registration start day and time of the event you are creating" default="">
	<cfargument name="regendtime" type="string" required="false" hint="I am the registration end day and time of the event you are creating" default="">
	<cfset var addevent=0>
	<cfset var timedate=DateTimes.CreateTimeDate()>
	<cfset var args=StructNew()>
	<cfquery name="addevent" datasource="#arguments.eventdsn#">
		INSERT INTO EVENT
		(
			EVENTID, 
			EVENTNAME,
			URL,
			EVENTCATEGORYID
		)
		VALUES
		(
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventurl#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.EVENTCATEGORYID#" cfsqltype="cf_sql_varchar">
		)
		
		INSERT INTO EVENTVERSION
		(
			EVENTID,
			PARENTEVENTID,
			EVENTNAME,
			DESCRIPTION,
			STATUS,
			STARTTIME,
			ENDTIME,
			ACTUALSTARTTIME,
			ACTUALENDTIME,
			TITLE,
			EVENTCATEGORYID,
			FREQUENCY,
			INTERVAL,
			COUNT,
			UNTIL,
			REPEATEND,
			FROMEMAIL,
			KEYWORDS,
			CC,
			SUBJECT,
			MESSAGE,
			DEFAULTPRICE,
			DISCOUNTTYPE,
			PERCENTOFF,
			DISCOUNTPRICE,
			GUESTPRICE,
			CREATEDBYID,
			VERSIONID
		)
		VALUES
		(
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.parenteventid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.regstarttime#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.regendtime#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.starttime#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.endtime#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventcategoryid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.repeat#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.eventinterval#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.repeatafter#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.repeatdate#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.repeatend#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.fromemail#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.fromemail#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.cc#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.message#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.defaultprice#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.discountType#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.percentOff#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.discountprice#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.guestprice#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.createdbyid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- 
	This  part was added by Binod on 20090413. This part populates repeating events table. If the event is non repeating,
	it adds one entry in the repeatingevents table. 
	--->
	
	<cfset neweventid = "#timedate#">
	<cfset args.eventdsn=arguments.eventdsn>
	<cfset args.eventid=timedate>
	<cfset args.start=arguments.starttime>
	<cfset args.endtime=arguments.endtime>
	<cfset args.registrationstart=arguments.regstarttime>
	<cfset args.registrationend=arguments.regendtime>
	<cfset args.frequency=arguments.repeat>
	<cfset args.status=arguments.status>
	<cfset args.repeatend=arguments.repeatend>
	
	
	<cfif arguments.repeat EQ "None">
		<cfset args.nooftimes=1>
	<cfelse>
		<cfswitch expression="#Trim(arguments.repeatend)#">
			<cfcase value="repeat-after">
				<cfset args.nooftimes=arguments.repeatafter>
			</cfcase>
			<cfcase value="repeat-date">
				<cfset args.end=arguments.repeatdate>
			</cfcase>
		</cfswitch>
	</cfif>
	<cfinvoke method="recordRepeatingEvent" argumentcollection="#args#">
	<cfreturn neweventid>
</cffunction>

<cffunction name="updateEvent" access="public" output="false" returntype="void" hint="I update the event in the datasource you pass to me">
	<cfargument name="eventdsn" type="string" required="true" hint="I am the datasource for the event you would like to add">
	<cfargument name="eventid" type="string" required="true" hint="I am the id of the event you want to update">
	<cfargument name="eventname" type="string" required="true" hint="I am the name of the event you are adding">
	<cfargument name="eventcategoryid" type="string" required="true" hint="I am the id of the event category you are updating this event in">
	<cfargument name="description" type="string" required="false" hint="I am the description of the event you are updating">
	<cfargument name="title" type="string" required="false" hint="I am the title of the event you are updating">
	<cfargument name="status" type="string" required="false" hint="I am the status of the event you are updating">
	<cfargument name="regstarttime" type="string" required="false" hint="I am the startday and time of the event you are updating">
	<cfargument name="regendtime" type="string" required="false" hint="I am the endday and time of the event you are updating">
	<cfargument name="starttime" type="string" required="false" hint="I am the startday and time of the event you are updating">
	<cfargument name="endtime" type="string" required="false" hint="I am the endday and time of the event you are updating">
	<cfargument name="repeat" type="string" required="false" hint="I am when this event will repeat (every day, every year, every month) I map to the Frequency field in the database">
	<cfargument name="repeatdate" type="string" required="false" hint="I am the date in which the event you are updating will end">
	<cfargument name="repeatend" type="string" required="false" hint="I am how the event will repeat, I should be either Never or repeat-date, I default to Never" default="Never">
	<cfargument name="fromemail" type="string" required="false" hint="I am the email address from which you wish to send the email confirmation message for the event you are updating">
	<cfargument name="cc" type="string" required="false" hint="I am the email address of the person you want to cc with each email confirmation message for the event you are updating">
	<cfargument name="subject" type="string" required="false" hint="I am the confirmation message subject for the event you are updating">
	<cfargument name="message" type="string" required="false" hint="I am the confirmation message for the event you are updating">
	<cfargument name="defaultprice" type="string" required="false" hint="I am the regular price the event you are updating">
	<cfargument name="discountType" type="string" required="false" hint="I am the discount type for the event you are updating">
	<cfargument name="percentOff" type="string" required="false" hint="I am the Percent off for the event you are updating">
	<cfargument name="discountprice" type="string" required="false" hint="I am the Guest Price for the event you are updating">
	<cfargument name="guestprice" type="string" required="false" hint="I am the description of the event you are updating">
	<cfargument name="eventinterval" type="numeric" required="false" hint="I do not really understand what I am used for, but I default to 1">
	<cfargument name="eventurl" type="string" required="false" hint="I am the for the event, please leave off the http:// when you create me, I just need the domain">
	<cfargument name="repeatafter" type="numeric" required="false" default="1" hint="I am the number of occurances in which the event you are updating will end, I default to 1">
	<cfargument name="parenteventid" type="string" required="false" default="0" hint="I am the parent event id for this event, if you do not pass me in I default to 0">
	<cfset var updatevent=0>
	<cfset var addversion=0>
	<cfset var timedate=DateTimes.CreateTimeDate()>
	<cfquery name="updateevent" datasource="#arguments.eventdsn#">
	UPDATE EVENT
	SET EVENTNAME=<cfqueryparam value="#arguments.eventname#" cfsqltype="cf_sql_varchar">
		<cfif isdefined('arguments.eventurl')>, URL=<cfqueryparam value="#arguments.eventurl#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.eventcategoryid')>, EVENTCATEGORYID=<cfqueryparam value="#arguments.EVENTCATEGORYID#" cfsqltype="cf_sql_varchar"></cfif>
	WHERE EVENTID=<cfqueryparam value="#eventid#">
	</cfquery>
	<cfquery name="addeventversion" datasource="#arguments.eventdsn#">
	UPDATE EVENTVERSION
		SET EVENTNAME=<cfqueryparam  value="#arguments.eventname#">,
		VERSIONID=<cfqueryparam value="#timedate#">
		<cfif isdefined('arguments.parentevenid')>, PARENTEVENTID=<cfqueryparam value="#arguments.parenteventid#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.description')>, DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.status')>, STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.regstarttime')>, STARTTIME=<cfqueryparam value="#arguments.regstarttime#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.regendtime')>, ENDTIME=<cfqueryparam value="#arguments.regendtime#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.starttime')>, ACTUALSTARTTIME=<cfqueryparam value="#arguments.starttime#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.endtime')>, ACTUALENDTIME=<cfqueryparam value="#arguments.endtime#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.title')>, TITLE=<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('eventcategoryid')>, EVENTCATEGORYID=<cfqueryparam value="#arguments.eventcategoryid#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.repeat')>, FREQUENCY=<cfqueryparam value="#arguments.repeat#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.eventinterval')>, INTERVAL=<cfqueryparam value="#arguments.eventinterval#" cfsqltype="cf_sql_integer"></cfif>
		<cfif isdefined('arguments.repeatafter')>, COUNT=<cfqueryparam value="#arguments.repeatafter#" cfsqltype="cf_sql_integer"></cfif>
		<cfif isdefined('arguments.repeatdate')>, UNTIL=<cfqueryparam value="#arguments.repeatdate#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.repeatend')>, REPEATEND=<cfqueryparam value="#arguments.repeatend#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.fromemail')> 
			,FROMEMAIL=<cfqueryparam value="#arguments.fromemail#" cfsqltype="cf_sql_varchar">,
			KEYWORDS=<cfqueryparam value="#arguments.fromemail#" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif isdefined('arguments.cc')>, CC=<cfqueryparam value="#arguments.cc#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.subject')>, SUBJECT=<cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.message')>, MESSAGE=<cfqueryparam value="#arguments.message#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.defaultprice')>, DEFAULTPRICE=<cfqueryparam value="#arguments.defaultprice#" cfsqltype="cf_sql_money"></cfif>
		<cfif isdefined('arguments.discounttype')>, DISCOUNTTYPE=<cfqueryparam value="#arguments.discountType#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.percentoff')>, PERCENTOFF=<cfqueryparam value="#arguments.percentOff#" cfsqltype="cf_sql_varchar"></cfif>
		<cfif isdefined('arguments.discountprice')>, DISCOUNTPRICE=<cfqueryparam value="#arguments.discountprice#" cfsqltype="cf_sql_money"></cfif>
		<cfif isdefined('arguments.guestprice')>, GUESTPRICE=<cfqueryparam value="#arguments.guestprice#" cfsqltype="cf_sql_money"></cfif>
	WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	</cfquery>

</cffunction>

<cffunction name="deleteEvent" access="public" output="false" hint="I delete the event and all of the data tied to it">
	<cfargument name="eventid" type="string" required="true" hint="I am the id of the event you want to delete">
	<cfargument name="eventdsn" type="string" required="true" hint="I am the datasource">
	<cfset var deleteEventVersion=0>
		<cfquery name="deleteEventVersion" datasource="#arguments.eventdsn#">
			DELETE FROM  REPEATINGEVENTS 
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
			
			DELETE FROM  EVENTVERSION 
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		
			DELETE FROM  EVENT2USERGROUP 
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		
			DELETE FROM EVENT2ADDRESS 
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
</cffunction>

<cffunction name="addContactToEvent" access="public" output="false" returntype="void" hint="I add a contact to the event">
	<cfargument name="eventdsn" type="string" required="true" hint="I am the datasource for the event you would like to add">
	<cfargument name="eventid" type="string" required="true" hint="I am the eventid for the event you want to add the contact to">
	<cfargument name="contactid" type="string" required="true" hint="I am the id of the contact you want to add to the event">
	<cfset var addcontact2event=0>
	<cfquery name="addcontact2event" datasource="#arguments.eventdsn#">
		UPDATE EVENT
		SET CONTACTID = <cfqueryparam value="#arguments.contactid#" cfsqltype="cf_sql_varchar">
		WHERE EVENTID = <cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="addLocationToEvent" access="public" output="false" returntype="void" hint="I add a location to the event">
	<cfargument name="eventdsn" type="string" required="true" hint="I am the datasource for the event you would like to add">
	<cfargument name="eventid" type="string" required="true" hint="I am the eventid for the event you want to add the contact to">
	<cfargument name="contactid" type="string" required="true" hint="I am the id of the contact you want to add to the event">
	<cfset var addcontact2event=0>
	<cfquery name="addcontact2event" datasource="#arguments.eventdsn#">
	UPDATE EVENTVERSION
	SET LOCATIONID = <cfqueryparam value="#arguments.contactid#">
	WHERE EVENTID = <cfqueryparam value="#arguments.eventid#">
	</cfquery>
</cffunction>

<cffunction name="addGroupsToEvent" access="public" output="false" returntype="void" hint="I remove all groups tied to this event and add the ones you pass to me">
	<cfargument name="eventdsn" required="true" type="string" hint="I am the event datasource">
	<cfargument name="eventid" required="true" type="string" hint="I am the id for the event you are updating">
	<cfargument name="groups" required="true" type="string" hint="I am a list of the groups you want to add to this event">
	<cfset var deletegroups=0>
	<cfset var qrygroup2event=0>
	<cfset var ID=0>
	<cfquery name="deletegroups" datasource="#arguments.eventdsn#">
	DELETE
	FROM EVENT2USERGROUP
	where eventid = '#arguments.eventid#'
	</cfquery>
	<!--- Loop over the list of GROUPS AND add this EVENT to each GROUP --->
	<cfloop list="#groups#" index="ID">
		<cfquery name="qrygroup2event" datasource="#arguments.eventdsn#">
		INSERT	INTO  EVENT2USERGROUP
			(USERGROUPID,
			 EVENTID)
		VALUES
			('#ID#',
			'#arguments.EVENTID#')
		</cfquery>
	</cfloop>
</cffunction>

<cffunction name="getMoEvents" access="public" output="false" returntype="query" hint="I get all of the events for a month, I Return these columns:EVENTID, STATUS,EVENTNAME, STARTTIME,ENDTIME, ACTUALSTARTTIME, ACTUALENDTIME, TITLE, FREQUENCY,INTERVAL,COUNT,UNTIL,REPEATEND,EVENTCATEGORYID,EVENTCATEGORY">
	<cfargument name="dsn" required="true" type="string" hint="The datasource for the events" default="0">
	<cfargument name="day" required="true" type="string" hint="The day of the events you want to get: DD" default="#day(Now())#">
	<cfargument name="month" required="true" type="string" hint="The Month of the events you want to get: MM" default="#month(Now())#">
	<cfargument name="year" required="true" type="string" hint="The year of the events you want: YYYY" default="#year(Now())#">
	<cfargument name="type" required="true" type="string" hint="The Type of results to return: day, month" default="month">

	<cfset var rightnow = 0>
	<cfset var MoEvents = 0>
	<cfset var leftCnt = 0>
	<cfif type EQ 'month'>
		<cfset rightnow="#year##numberFormat(month,00)#">
		<cfset leftCnt = 6>
	<cfelse>
		<cfset rightnow="#year##numberFormat(month,00)##numberFormat(day,00)#">
		<cfset leftCnt = 8>
	</cfif>
	<cfquery datasource="#arguments.dsn#" name="MoEvents">
	SELECT
		EVENT.EVENTID, 
		EVENTVERSION.STATUS,
		EVENTVERSION.EVENTNAME, 
		EVENTVERSION.STARTTIME,
		EVENTVERSION.ENDTIME, 
		EVENTVERSION.ACTUALSTARTTIME, 
		EVENTVERSION.ACTUALENDTIME, 
		EVENTVERSION.TITLE, 
		EVENTVERSION.FREQUENCY,
		EVENTVERSION.INTERVAL,
		EVENTVERSION.COUNT,
		EVENTVERSION.UNTIL,
		EVENTVERSION.REPEATEND,
		EVENTCATEGORY.EVENTCATEGORYID,
		EVENTCATEGORY.EVENTCATEGORY
	FROM         
		EVENT,
		EVENTVERSION,
		EVENTCATEGORY
	WHERE
		EVENT.EVENTID = EVENTVERSION.EVENTID
		AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
		AND EVENTVERSION.STATUS = 'Public'	
		AND EVENTCATEGORY.EVENTCATEGORY LIKE '%Event%'
		AND (EVENTVERSION.VERSIONID =
		  (SELECT     MAX(VERSIONID)
			FROM          EVENTVERSION
			WHERE      EVENTID = EVENT.EVENTID
			AND    EVENTVERSION.STATUS = 'Public'))
		AND ((EVENTVERSION.REPEATEND = 'repeat-date'
		AND LEFT(EVENTVERSION.UNTIL, #leftCnt#) >= '#rightnow#'
		AND LEFT(EVENTVERSION.STARTTIME, #leftCnt#) <= '#rightnow#' 
		AND (EVENTVERSION.FREQUENCY <> 'None'
		OR EVENTVERSION.FREQUENCY <> ''))
		OR (LEFT(EVENTVERSION.STARTTIME, #leftCnt#) >= '#rightnow#'
		AND LEFT(EVENTVERSION.ENDTIME, #leftCnt#) <= '#rightnow#'))
		ORDER BY EVENTVERSION.STARTTIME 
	</cfquery>
	<cfreturn MoEvents>
</cffunction>

<cffunction name="getMoEventsmod" access="public" output="false" returntype="query" hint="I get all of the events for a month, I Return these columns:EVENTID, STATUS,EVENTNAME, STARTTIME,ENDTIME, ACTUALSTARTTIME, ACTUALENDTIME, TITLE, FREQUENCY,INTERVAL,COUNT,UNTIL,REPEATEND,EVENTCATEGORYID,EVENTCATEGORY">
	<cfargument name="ds" required="true" type="string" hint="The datasource for the events" default="0">
	<cfargument name="day" required="false" type="string" hint="The day of the events you want to get: DD" default="#day(Now())#">
	<cfargument name="month" required="false" type="string" hint="The Month of the events you want to get: MM" default="#month(Now())#">
	<cfargument name="year" required="false" type="string" hint="The year of the events you want: YYYY" default="#year(Now())#">
	<cfargument name="type" required="false" type="string" hint="The Type of results to return: day, month" default="month">

	<cfset var rightnow = 0>
	<cfset var MoEvents = 0>
	<cfset var leftCnt = 0>
	<cfif type EQ 'month'>
		<cfset rightnow="#year##numberFormat(month,00)#">
		<cfset leftCnt = 6>
	<cfelse>
		<cfset rightnow="#year##numberFormat(month,00)##numberFormat(day,00)#">
		<cfset leftCnt = 8>
	</cfif>
	<cfquery datasource="#arguments.ds#" name="MoEvents">
	SELECT
		EVENT.EVENTID, 
		EVENTVERSION.EVENTNAME, 
		EVENTVERSION.ACTUALSTARTTIME, 
		EVENTVERSION.ACTUALENDTIME, 
		EVENTVERSION.TITLE, 
		EVENTVERSION.FREQUENCY,
		EVENTVERSION.INTERVAL,
		EVENTVERSION.COUNT,
		EVENTVERSION.UNTIL,
		EVENTVERSION.REPEATEND,
		EVENTCATEGORY.EVENTCATEGORYID,
		EVENTCATEGORY.EVENTCATEGORY,
		REPEATINGEVENTS.STATUS,
		REPEATINGEVENTS.STARTTIME,
		REPEATINGEVENTS.ENDTIME 
	FROM         
		EVENTVERSION,
		EVENTCATEGORY,
		EVENT LEFT OUTER JOIN REPEATINGEVENTS ON REPEATINGEVENTS.EVENTID=EVENT.EVENTID
	WHERE
		EVENT.EVENTID = EVENTVERSION.EVENTID
		AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
		AND EVENTVERSION.STATUS = 'Public'	
		AND EVENTCATEGORY.EVENTCATEGORY LIKE '%Event%'
		AND (EVENTVERSION.VERSIONID =
		  (SELECT MAX(VERSIONID)
			FROM EVENTVERSION
			WHERE EVENTID = EVENT.EVENTID
			AND EVENTVERSION.STATUS = 'Public'))
		AND ((EVENTVERSION.REPEATEND = 'repeat-date'
		AND LEFT(EVENTVERSION.UNTIL, #leftCnt#) >= '#rightnow#'
		AND LEFT(EVENTVERSION.STARTTIME, #leftCnt#) <= '#rightnow#' 
		AND (EVENTVERSION.FREQUENCY <> 'None'
		OR EVENTVERSION.FREQUENCY <> ''))
		OR (LEFT(EVENTVERSION.STARTTIME, #leftCnt#) <= '#rightnow#'
		AND LEFT(EVENTVERSION.ENDTIME, #leftCnt#) >= '#rightnow#'))
		ORDER BY EVENTVERSION.STARTTIME 
	</cfquery>
	<cfreturn MoEvents>
</cffunction>

<cffunction name="createEventsStruct" returnType="struct">
	<cfargument name="dsn" required="yes" hint="Datasource">
	<cfargument name="year" required="no" default="#year(Now())#">
	<cfargument name="month" required="no" default="#month(Now())#">
	<cfargument name="day" required="no" default="#day(Now())#">
	<cfargument name="type" required="no" default="month">
	<cfobject component="events" name="eventCFC">
	<cfinvoke component="#eventCFC#" method="getMoEvents" dsn="#arguments.dsn#" 
		year="#arguments.year#" month="#arguments.month#" day="#arguments.day#" type="#arguments.type#" returnVariable="curMonthEvents" />

	<cfset poo = 0>
	<cfset Calendar = StructNew()>
	<cfoutput query="curMonthEvents">
		<cfif (len(starttime) GTE 16) AND (len(endtime) GTE 16) >
		<cfset date = CreateDateTime(DateTimes.convertDate(starttime,'yyyy'),
			DateTimes.convertDate(starttime,'mm'),
			DateTimes.convertDate(starttime,'dd'),
			DateTimes.convertTime(starttime,'HH'),
			DateTimes.convertTime(starttime,'mm'),
			DateTimes.convertTime(starttime,'ss'))>
		<cfset endDate = CreateDateTime(DateTimes.convertDate(endtime,'yyyy'),
			DateTimes.convertDate(endtime,'mm'),
			DateTimes.convertDate(endtime,'dd'),
			DateTimes.convertTime(endtime,'HH'),
			DateTimes.convertTime(endtime,'mm'),
			DateTimes.convertTime(endtime,'ss'))>

		<cfif frequency NEQ '' AND frequency NEQ 'None'>
			
			<cfif arguments.type EQ 'month'>
				<cfset firstOfMonth = CreateDate(year,month,1)>
				<cfset daysInMonth = DaysInMonth(firstOfMonth)>
				<cfset endOfMonth = CreateDateTime(year,month,daysInMonth,23,59,59)>
			<cfelse>
				<cfset currentDay = CreateDateTime(year,month,day,23,59,59)>
				<cfset previousDay = DateAdd('d',-1,currentDay)>
				<cfset nextDay = DateAdd('d',1,currentDay)>
				<cfset firstOfMonth = previousDay>
				<cfset endOfMonth = nextDay>
			</cfif>
			
			<cfif len(until) EQ 16>
				<cfset dateUntil = createDateTime(DateTimes.convertDate(until,'yyyy'),DateTimes.convertDate(until,'mm'),DateTimes.convertDate(until,'dd'),'23','59','59')>
			<cfelse>
				<cfset dateUntil=date>
			</cfif>
			
			<cfswitch expression="#frequency#">
				<cfcase value="Every Day"><cfset countStr = 'd'></cfcase>
				<cfcase value="Every Week"><cfset countStr = 'ww'></cfcase>
				<cfcase value="Every Year"><cfset countStr = 'yyyy'></cfcase>
				<cfdefaultcase><cfset countStr = 'm'></cfdefaultcase>
			</cfswitch>
			<!--- Gets Number of Times Event Recurs --->
			<cfset numberOfRecurringEvents = DateDiff(countStr,date,dateUntil)>
			<!--- Gets Number of Repeating Events Prior to month being displayed --->
			<cfif month(date) NEQ month>
				<cfset eventsPriorToMonth = DateDiff(countStr,date,firstOfMonth)>
			<cfelse>
				<cfset eventsPriorToMonth = -1>
			</cfif>
			<!--- Gets Number of Repeating Events Until the end of the month being displayed --->
			<cfif month(dateUntil) NEQ month>
				<cfset eventsThroughMonth = DateDiff(countStr,date,endOfMonth)>
			<cfelse>
				<cfset eventsThroughMonth = numberOfRecurringEvents>
			</cfif>
			<!--- Number of Events in Particular Month --->
			<Cfset eventsInMonth = eventsThroughMonth - eventsPriorToMonth>

			<cfset loopStart = #eventsPriorToMonth# + 1>
			<cfif loopStart GTE 0 AND eventsThroughMonth GT 0>
			<cfloop from="#loopStart#" to="#eventsThroughMonth#" index="i">
					<cfset startDate = DateAdd(countStr,i,date)>
				<cfif (day(startDate) EQ day AND type EQ 'day') OR type EQ 'month'>
					<cfset dateEnd = DateAdd(countStr,i,endDate)>
					<cfset id = "#eventid##numberFormat(i,"00")#">
					<cfset eventItem = eventCFC.addItemToEventStruct(date,startDate,dateEnd,title,id)>
					<cfset poo = poo + 1>					
					<cfset Calendar[poo] = eventItem>
					<cfset Calendar[poo].loop = "#loopStart# - #eventsThroughMonth#">
				</cfif>
					<!--- <li>#information#</li> --->
			</cfloop>
			</cfif>
		<cfelse>
			<cfif (day(date) EQ day AND type EQ 'day') OR type EQ 'month'>
				<cfset eventItem = eventCFC.addItemToEventStruct(date,date,endDate,title,eventid)>
				<cfset poo = poo + 1>
				<cfset Calendar[poo] = eventItem>
			</cfif>
			<!--- <li>#information#</li> --->
		</cfif>
	</cfif>
	</cfoutput>
	<cfreturn Calendar>
</cffunction>

<cffunction name="addItemToEventStruct" returnType="struct">
	<cfargument name="firstOccuranceDate" required="yes">
	<cfargument name="startDate" required="yes">
	<cfargument name="endDate" required="yes">
	<cfargument name="title" required="yes">
	<cfargument name="id" required="yes">
		<cfset var eventItem = StructNew()>
		<cfset eventItem.startDate = startDate>
		<cfset eventItem.endDate = endDate>
		<cfset eventItem.title = title>
		<cfset eventItem.id = id>
		<cfset eventItem.dayList = ''>
		<cfif day(startDate) NEQ day(endDate)>
			<cfloop from="1" to="#DateDiff('d',startDate,endDate)#" index="j">
				<cfset eventItem.dayList = ListAppend(eventItem.dayList,Day(DateAdd('d',j,startDate)))>
			</cfloop>
		<cfelse>
			<cfset eventItem.dayList = day(startDate)>
		</cfif>
	<cfreturn eventItem>
</cffunction>

<cffunction name="repeatEvents">
	<cfargument name="start" required="yes" type="string" hint="The date that the recursion begins at.">
	<cfargument name="end" required="yes" type="string" hint="The end date that the recursion begins at.">
	<cfargument name="repeat" required="yes" type="string">
	<cfargument name="repeatend" required="yes" type="string">
	<cfargument name="until" required="yes" type="string">
	<cfargument name="endafter" required="yes" type="string">
	
	<cfset curmonth = #convertDate(start,"mm")#>
	<cfset curday = #convertDate(start,"dd")#>
	<cfset curyear = #convertDate(start,"yyyy")#>
	<cfset curtime = #convertTime(start,"HHmmss")#>
	<cfset curendtime = #convertTime(end,"HHmmss")#>
	<cfset curendday = #convertDate(end,"dd")#>
	<cfset curendmonth = #convertDate(end,"mm")#>
	<cfset curendyear = #convertDate(end,"yyyy")#>
	<cfset stopmonth = #convertDate(until,"mm")#>
	<cfset stopday = #convertDate(until,"dd")#>
	<cfset stopyear = #convertDate(until,"yyyy")#>
	<cfset numYears = 0>
	<cfset numDays = 1>
	<cfset actualYears = 1>
	<cfset numMonths = 1>
	
	<cfset diffYear = curendyear - curyear>
	<cfset diffMonth = curendmonth - curmonth>
	<cfset diffDay = curendday - curday>
	
	<cfif stopyear NEQ curyear>
		<cfset stop = stopyear & "." & stopmonth>
		<cfset current = curyear & "." & curmonth>
		<cfset actualYears = stop - current>
		<cfset numYears = Fix(actualYears)>
	</cfif>
	
	<!---This loop finds out the number of times to loop for years --->
	<cfset tempYears = 0>
	<cfset tempMonth = curMonth>
	<cfset tempYear = curYear>
	<cfloop from="1" to="#numYears#" index="i">
		<cfset request.date = #CreateDate(tempYear, tempMonth, 1)#>
		<cfset maxDay = DaysInMonth(request.date)>
		<cfif maxDay GTE curday AND i NEQ numMonths>
			<cfset tempYears = tempYears + 1>
		<cfelseif i EQ numYears and stopday EQ curday>
			<cfset tempYears = tempYears + 1>
		</cfif>
		<cfset tempYear = tempYear + 1>
	</cfloop>
	<cfset numYears = tempYears>
	
	<cfset numMonths = (numYears * 12) + (stopmonth - curmonth) + 1>
	
	<!---This loop finds out the number of times to loop for months --->
	<cfoutput>
	<cfset tempMonths = 0>
	<cfset tempMonth = curMonth>
	<cfset tempYear = curYear>
	
	<cfif numMonths GT 1>
		<cfloop from="1" to="#numMonths#" index="i">
			<cfif tempMonth EQ 12>
				<cfset tempMonth = "01">
				<cfset tempYear = tempYear + 1>
			</cfif>
			<cfset request.date = #CreateDate(tempYear, tempMonth, 1)#>
			<cfset maxDay = DaysInMonth(request.date)>
			<cfif i EQ 1>
				<cfset numDays = maxDay - curday + numDays>
			<cfelseif i EQ numMonths>
				<cfset numDays = stopday + numDays>
			<cfelse>
				<cfset numDays = maxDay + numDays>
			</cfif>
			<cfif maxDay GTE curday AND i NEQ numMonths>
				<cfset tempMonths = tempMonths + 1>
			<cfelseif i EQ numMonths and stopday EQ curday>
				<cfset tempMonths = tempMonths + 1>
			</cfif>
				<cfset tempMonth = tempMonth + 1>
		</cfloop>
	<cfelse>
		<cfset numDays = stopday - curday + 1>
	</cfif>
	</cfoutput>
	
	
	<cfset numMonths = tempMonths>
	<cfset numWeeks = Ceiling(numDays/7)>
	
	<!---
		<strong>Loop Information</strong> (numbers to use in order to properly loop)<br />
		<cfoutput>Number of Days: #numDays#<br /></cfoutput>
		<cfoutput>Number of Weeks: #numWeeks#<br /></cfoutput>
		<cfoutput>Number of Months: #numMonths#<br /></cfoutput>
		<cfoutput>Number of Years: #numYears#</cfoutput>
	--->
	
	<!--- Checks to see if recursion ends after X number of times or after a certain Day --->
	<cfif repeatend EQ "repeat-date">
		<cfswitch expression="#repeat#">
			<cfcase value="Every Day">
				<cfset endafter = numDays>
			</cfcase>
			<cfcase value="Every Week">
				<cfset endafter = numWeeks>
			</cfcase>
			<cfcase value="Every Month">
				<cfset endafter = numMonths>
			</cfcase> 
			<cfcase value="Every Year">
				<cfset endafter = numYears>
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfset dates = ArrayNew(2)>
	
	<cfswitch expression="#repeat#">
		<cfcase value="Every Day">
			<cfoutput>
			<cfset curmonth = #convertDate(starttime,"mm")#>
			<cfset curday = #convertDate(starttime,"dd")#>
			<cfset curyear = #convertDate(starttime,"yyyy")#>
			<cfset dayCount = 1>
			<cfloop condition="dayCount LESS THAN OR EQUAL TO endafter">
					<cfset dates[dayCount][1] = "#curyear##curmonth##curday##curtime#00">
					<cfset endyear = curyear + diffYear>
					<cfset endmonth = curmonth + diffMonth>
					<cfset endday = curday + diffDay>
					<cfset dates[dayCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
				<cfset request.date = #CreateDate(curYear, curmonth, curday)#>
				<cfset maxDay = DaysInMonth(request.date)>
				<cfif curmonth EQ "12" AND curday + 1 GT maxDay>
					<cfset curyear = curyear + 1>
					<cfset curday = NumberFormat(1,"00")>
					<cfset curmonth = "01">
				<cfelseif curday + 1 GT maxday>
					<cfset curday = NumberFormat(1,"00")>
					<cfset curmonth = NumberFormat(curmonth + 1,"00")>
				<cfelse>
					<cfset curday =  NumberFormat(curday + 1,"00")>
				</cfif>
					<cfset dayCount = dayCount + 1>
			</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="Every Week">
			<cfoutput>
			<cfset curmonth = #convertDate(starttime,"mm")#>
			<cfset curday = #convertDate(starttime,"dd")# - 7>
			<cfset curyear = #convertDate(starttime,"yyyy")#>
			<cfset weekCount = 1>
			<cfloop condition="weekCount LESS THAN OR EQUAL TO endafter">
				<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
				<cfset maxDay = DaysInMonth(request.date)>
				<cfif curmonth EQ "12" AND curday + 7 GT maxDay>
					<cfset curyear = curyear + 1>
					<cfset curday = NumberFormat(7 - (maxDay - curday),"00")>
					<cfset curmonth = "01">
				<cfelseif curday + 7 GT maxday>
					<cfset curday = NumberFormat(7 - (maxDay - curday),"00")>
					<cfset curmonth = NumberFormat(curmonth + 1,"00")>
				<cfelse>
					<cfset curday =  NumberFormat(curday + 7,"00")>
				</cfif>
					<cfset dates[weekCount][1] = "#curyear##curmonth##curday##curtime#00">
					<cfset endyear = curyear + diffYear>
					<cfset endmonth = curmonth + diffMonth>
					<cfset endday = curday + diffDay>
					<cfset dates[weekCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
					<cfset weekCount = weekCount + 1>
			</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="Every Month">
			<cfoutput>
			<cfset curmonth = #convertDate(starttime,"mm")# - 1>
			<cfset curday = #convertDate(starttime,"dd")#>
			<cfset curyear = #convertDate(starttime,"yyyy")#>
			<cfset monthCount = 1>
			<cfloop condition="monthCount LESS THAN OR EQUAL TO endafter">
				
				<cfif curmonth EQ "12">
					<cfset curyear = curyear + 1>
					<cfset curmonth = "01">
				<cfelse>
					<cfset curmonth =  NumberFormat(curmonth + 1,"00")>
				</cfif>
				<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
				<cfset maxDay = DaysInMonth(request.date)>
				<cfif maxDay GTE curday>
					<cfset dates[monthCount][1] = "#curyear##curmonth##curday##curtime#00">
					<cfset endyear = curyear + diffYear>
					<cfset endmonth = curmonth + diffMonth>
					<cfset endday = curday + diffDay>
					<cfset dates[monthCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
					<cfset monthCount = monthCount + 1>
				</cfif>
			</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="Every Year">
			<cfoutput>
			<cfset curmonth = #convertDate(date,"mm")#>
			<cfset curday = #convertDate(date,"dd")#>
			<cfset curyear = #convertDate(date,"yyyy")# - 1>
			<cfset yearCount = 1>
			<cfloop condition="yearCount LESS THAN OR EQUAL TO endafter">
				<cfset curyear = curyear + 1>
				<cfset request.date = #CreateDate(curYear, curmonth, 1)#>
				<cfset maxDay = DaysInMonth(request.date)>
				<cfif maxDay GTE curday>
					<cfset dates[yearCount][1] = "#curyear##curmonth##curday##curtime#00">
					<cfset endyear = curyear + diffYear>
					<cfset endmonth = curmonth + diffMonth>
					<cfset endday = curday + diffDay>
					<cfset dates[yearCount][2] = "#endyear##numberFormat(endmonth,"00")##numberFormat(endday,"00")##curendtime#00">
					<cfset yearCount = yearCount + 1>
				</cfif>
			</cfloop>
			</cfoutput>
		</cfcase>
	</cfswitch>
	<cfreturn dates>
</cffunction>

<cffunction name="recordRepeatingEvent" access="public" returntype="void" output="true" hint="I populate the repeatingevents table with list of dates the event will occur on">
	<cfargument name="eventdsn" type="string" required="true" hint="Datasource">
	<cfargument name="eventid" type="String" required="true" hint="Id of the Event">
	<cfargument name="start" type="String" required="true" hint="timestamp when the event will start">
	<cfargument name="endtime" type="String" required="true" hint="I am the time when the event ends">
	<cfargument name="frequency" type="String" required="true" hint="value can be None, every day, every week, every month, every year">
	<cfargument name="registrationstart" type="String" required="false" default="0" hint="time when registration starts for the event or first repeating event">
	<cfargument name="registrationend" type="String" required="false" default="0" hint="time when registration ends for the event or first repeating event">
	<cfargument name="status" type="string" required="false" hint="I am the status of the event you are creating" default="public">
	<cfargument name="repeatend" type="string" required="false" hint="I am how the event will repeat, I should be either Never or repeat-date or repeat-after, I default to Never" default="Never">
	<cfargument name="end" type="String" required="false" default="0" hint="I am the end date the repeating event. If I am not set, nooftimes should have value other than 0">
	<cfargument name="nooftimes" type="String" required="false" default="0" hint="I am the number of times the event should repeat. If i am not set, end should have a valid date">
	<cfset var add=0>
	
	<!--- Return if repeat end is never --->
	<cfif Trim(arguments.repeatend) EQ "Never">
		<cfset ayearfromnow=DateAdd("yyyy",1,now())>
		<cfset end = "#DateFormat(ayearfromnow,'yyyy')#123100000000">
		<cfset arguments.repeatend="repeat-date">
	</cfif>
	
	<cfif (Trim(arguments.frequency) EQ "") OR (Trim(arguments.frequency) EQ "None")>
		<cfquery name="add" datasource="#arguments.eventdsn#">
			INSERT INTO REPEATINGEVENTS
			(
				EVENTID,
				ACTUALSTARTTIME,
				ACTUALENDTIME,
				STATUS,
				STARTTIME,
				ENDTIME
			)
			VALUES
			(
				<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.start#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.endtime#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.registrationstart#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.registrationend#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn>
	</cfif>
	
	<cfset startyear=DateTimes.getdatepart(start,'yyyy')>
	<cfset startmonth=DateTimes.getdatepart(start,'m')>
	<cfset startday=DateTimes.getdatepart(start,'d')>
	<cfset starthour=DateTimes.getdatepart(start,'h')>
	<cfset startmins=DateTimes.getdatepart(start,'n')>
	<cfset startsecs=DateTimes.getdatepart(start,'s')>
	
	<cfset yeardiff=DateTimes.getdatepart(endtime,'yyyy')-startyear>
	<cfset monthdiff=DateTimes.getdatepart(endtime,'m')-startmonth>
	<cfset daydiff=DateTimes.getdatepart(endtime,'d')-startday>
	<cfset hourdiff=DateTimes.getdatepart(endtime,'h')-starthour>
	<cfset minsdiff=DateTimes.getdatepart(endtime,'n')-startmins>
	<cfset secsdiff=DateTimes.getdatepart(endtime,'s')-startsecs>
	
	<cfset startdate=DateTimes.stringtodate(start)>
	<cfset enddate=DateTimes.stringtodate(endtime)>
	<cfset registrationenddate=DateTimes.stringtodate(registrationend)>
	
	<cfset regdiffyears=Datediff("yyyy",startdate,registrationenddate)>
	<cfset regdiffmonths=Datediff("m",startdate,registrationenddate)>
	<cfset regdiffdays=Datediff("d",startdate,registrationenddate)>
	<cfset regdiffhours=Datediff("h",startdate,registrationenddate)>
	<cfset regdiffminutes=Datediff("n",startdate,registrationenddate)>
	<cfset regdiffsecs=Datediff("s",startdate,registrationenddate)>
	
	<cfset strstartdate=DateTimes.stringtodate(start)>
	<cfif arguments.end NEQ "0">
	<cfset ende=DateTimes.stringtodate(end)>
	</cfif>
	<cfset strstartdate = "#DateFormat(startdate,'yyyymmdd')##timeformat(startdate,'HHmmss')#00">
	<cfset strenddate = "#DateFormat(enddate,'yyyymmdd')##timeformat(enddate,'HHmmss')#00">
	
	<cfswitch expression="#Trim(arguments.frequency)#">
		<cfcase value="Every day">
			<cfset interval="d">
		</cfcase>
		<cfcase value="Every week">
			<cfset interval="ww">
		</cfcase>
		<cfcase value="Every month">
			<cfset interval="m">
			<cfoutput>I was here</cfoutput>
		</cfcase>
		<cfcase value="Every year">
			<cfset interval="yyyy">
		</cfcase>
	</cfswitch>

	<cfif Trim(arguments.repeatend) EQ "repeat-date">
		<cfloop condition="#startdate# LTE #ende#">
			<cfquery name="add" datasource="#arguments.eventdsn#">
				INSERT INTO REPEATINGEVENTS
				(
					EVENTID,
					ACTUALSTARTTIME,
					ACTUALENDTIME,
					STATUS,
					STARTTIME,
					ENDTIME
				)
				VALUES
				(
					<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#strstartdate#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#strenddate#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.registrationstart#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.registrationend#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<!--- <cfoutput>#eventid# #interval# #frequency# #startdate#<br /></cfoutput> --->
			<cfset startdate=DateAdd(interval,1,startdate)>
			<cfset strstartdate = "#DateFormat(startdate,'yyyymmdd')##timeformat(startdate,'HHmmss')#00">
			<cfset enddate=DateAdd("yyyy",yeardiff,startdate)>
			<cfset enddate=DateAdd("m",monthdiff,enddate)>
			<cfset enddate=DateAdd("d",daydiff,enddate)>
			<cfset enddate=DateAdd("h",hourdiff,enddate)>
			<cfset enddate=DateAdd("n",minsdiff,enddate)>
			<cfset enddate=DateAdd("s",secsdiff,enddate)>
			<cfset strenddate = "#DateFormat(enddate,'yyyymmdd')##timeformat(enddate,'HHmmss')#00">
			
			<cfset registrationenddate=DateAdd("yyyy",regdiffyears,startdate)>
			<cfset registrationenddate=DateAdd("m",regdiffmonths,startdate)>
			<cfset registrationenddate=DateAdd("d",regdiffdays,startdate)>
			<cfset registrationenddate=DateAdd("h",regdiffhours,startdate)>
			<cfset registrationenddate=DateAdd("n",regdiffminutes,startdate)>
			<cfset registrationenddate=DateAdd("s",regdiffsecs,startdate)>
			<cfset arguments.registrationend = "#DateFormat(registrationenddate,'yyyymmdd')##timeformat(registrationenddate,'HHmmss')#00">
		</cfloop>
	<cfelseif Trim(arguments.repeatend) EQ "repeat-after">
		<cfloop from="1" to="#nooftimes#" index="i">
		<cfquery name="add" datasource="#arguments.eventdsn#">
			INSERT INTO REPEATINGEVENTS
			(
				EVENTID,
				ACTUALSTARTTIME,
				ACTUALENDTIME,
				STATUS,
				STARTTIME,
				ENDTIME
			)
			VALUES
			(
				<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#strstartdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#strenddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.registrationstart#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.registrationend#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfset startdate=DateAdd(interval,1,startdate)>
		<cfset strstartdate = "#DateFormat(startdate,'yyyymmdd')##timeformat(startdate,'HHmmss')#00">
		<cfset enddate=DateAdd("yyyy",yeardiff,startdate)>
		<cfset enddate=DateAdd("m",monthdiff,enddate)>
		<cfset enddate=DateAdd("d",daydiff,enddate)>
		<cfset enddate=DateAdd("h",hourdiff,enddate)>
		<cfset enddate=DateAdd("n",minsdiff,enddate)>
		<cfset enddate=DateAdd("s",secsdiff,enddate)>
		<cfset strenddate = "#DateFormat(enddate,'yyyymmdd')##timeformat(enddate,'HHmmss')#00">
		
		<cfset registrationenddate=DateAdd("yyyy",regdiffyears,startdate)>
		<cfset registrationenddate=DateAdd("m",regdiffmonths,startdate)>
		<cfset registrationenddate=DateAdd("d",regdiffdays,startdate)>
		<cfset registrationenddate=DateAdd("h",regdiffhours,startdate)>
		<cfset registrationenddate=DateAdd("n",regdiffminutes,startdate)>
		<cfset registrationenddate=DateAdd("s",regdiffsecs,startdate)>
		<cfset arguments.registrationend = "#DateFormat(registrationenddate,'yyyymmdd')##timeformat(registrationenddate,'HHmmss')#00">
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="deleterecurringevent" access="public" returntype="void" hint="I delete future recurring event">
	<cfargument name="eventdsn" type="string" required="true" hint="Datasource">
	<cfargument name="eventid" type="String" required="true" hint="Id of the Event">
	<cfargument name="startingdate" required="false" default="0" type="string" hint="All the events on or after this date will be deleted">
	<cfset var delete=0>
	<cfif startingdate EQ "0">
		<cfset startingdate=DateTimes.createTimeDate()>
	</cfif>
	<cfquery name="delete" datasource="#arguments.eventdsn#">
		DELETE FROM REPEATINGEVENTS
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		AND ACTUALSTARTTIME>=<cfqueryparam value="#arguments.startingdate#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="deleteOneRecurringEvent" access="public" returntype="void" hint="I delete future recurring event">
	<cfargument name="eventdsn" type="string" required="true" hint="Datasource">
	<cfargument name="eventinstanceid" type="String" required="true" hint="Id of the Event Instance that needs to be deleted">
	<cfset var delete=0>
	<cfquery name="delete" datasource="#arguments.eventdsn#">
		DELETE FROM REPEATINGEVENTS
		WHERE EVENTINSTANCEID=<cfqueryparam value="#arguments.eventinstanceid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="populateRepeatingEvents" access="public" returntype="void" output="false" hint="I populate the repeatingevents table using current values in the database">
<cfargument name="ds" type="string" required="true" hint="Datasource">
<cfargument name="rightnow" type="string" required="false"  default="0" hint="last time value">
<!--- get all repeating events --->
	<cfif arguments.rightnow EQ "0">
		<cfset arguments.rightnow="#DateFormat(Now(),'yyyymmdd')#">
	</cfif>
	<cfset leftCnt = 8>
	
	<cfquery datasource="#arguments.ds#" name="allcurrentevents">
		SELECT
			EVENT.EVENTID, 
			EVENTVERSION.STATUS,
			EVENTVERSION.EVENTNAME, 
			EVENTVERSION.STARTTIME,
			EVENTVERSION.ENDTIME, 
			EVENTVERSION.ACTUALSTARTTIME, 
			EVENTVERSION.ACTUALENDTIME, 
			EVENTVERSION.TITLE, 
			EVENTVERSION.FREQUENCY,
			EVENTVERSION.INTERVAL,
			EVENTVERSION.COUNT,
			EVENTVERSION.UNTIL,
			EVENTVERSION.REPEATEND,
			EVENTCATEGORY.EVENTCATEGORYID,
			EVENTCATEGORY.EVENTCATEGORY
		FROM         
			EVENT,
			EVENTVERSION,
			EVENTCATEGORY
		WHERE
			EVENT.EVENTID = EVENTVERSION.EVENTID
			AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
			AND EVENTVERSION.STATUS = 'Public'	
			AND (EVENTVERSION.VERSIONID =
			  (SELECT MAX(VERSIONID)
				FROM  EVENTVERSION
				WHERE EVENTID = EVENT.EVENTID
				AND EVENTVERSION.STATUS = 'Public'))
			AND ((EVENTVERSION.REPEATEND = 'repeat-date'
			AND LEFT(EVENTVERSION.UNTIL, #leftCnt#) >= '#arguments.rightnow#'
			AND LEFT(EVENTVERSION.STARTTIME, #leftCnt#) <= '#arguments.rightnow#' 
			AND (EVENTVERSION.FREQUENCY <> 'None'
			OR EVENTVERSION.FREQUENCY <> ''))
			OR (LEFT(EVENTVERSION.STARTTIME, #leftCnt#) >= '#arguments.rightnow#'
			AND LEFT(EVENTVERSION.ENDTIME, #leftCnt#) <= '#arguments.rightnow#'))
			ORDER BY EVENTVERSION.STARTTIME 
	</cfquery>
	
	<cfset args=StructNew()>
	<cfset args.eventdsn="#arguments.ds#">
	<cfloop query="allcurrentevents">
		<cfset args.eventid=eventid>
		<cfset args.start=starttime>
		<cfset args.endtime=endtime>
		<cfset args.end=until>
		<cfset args.frequency=frequency>
		<cfset args.repeatend=repeatend>
		<cfset args.status=status>
		<cfinvoke component="events" method="recordRepeatingEvent" argumentcollection="#args#">
	</cfloop>
</cffunction>

<cffunction name="getGroupsforEvent" access="public" returntype="query" output="false" hint="I get all the groups for an event. Return fields: USERGROUPID,USERGROUPNAME">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="eventid" required="true" type="String" hint="I am the eventid">
	<cfset var mygroup=0>
	<cfquery name="mygroup" datasource="#arguments.eventdsn#">
		SELECT
			USERGROUPID,
			USERGROUPNAME
		FROM USERGROUPS 
		WHERE USERGROUPID IN (SELECT USERGROUPID FROM EVENT2USERGROUP WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	<cfreturn mygroup>
</cffunction>

<cffunction name="getEventsWithGroupsAsssigned" access="public" returntype="query" output="false" hint="I get the events with groups assigned">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfset var get=0>
	<cfquery name="get" datasource="#eventdsn#">
		SELECT 
			EVENTID,
			EVENTNAME
		FROM EVENTVERSION
		WHERE EVENTID IN(SELECT EVENTID FROM EVENT2USERGROUP)
		GROUP BY EVENTID, EVENTNAME
		ORDER BY EVENTID
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="getEventGroups" access="public" returntype="query" output="false" hint="I get all event groups for">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfset var myeventgroups=0>
	<cfquery name="myeventgroups" datasource="#arguments.eventdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
			USERGROUPS.USERGROUPNAME AS NAME,
			USERGROUPS.USERGROUPDESCRIPTION AS DESCRIPTION,
			PEOPLE2EVENT.EVENTID
		FROM 
			USERGROUPS,
			PEOPLE2EVENT
		WHERE USERGROUPS.USERGROUPID = PEOPLE2EVENT.USERGROUPID
		AND PEOPLE2EVENT.NAMEID = <cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn myeventgroups>
</cffunction>

<cffunction name="getGroupsInEvent" access="public" returntype="query" output="false" hint="I get all usergroups for a event">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="eventid" required="true" type="String" hint="I am the nameid">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
			USERGROUPS.USERGROUPNAME AS NAME,
			USERGROUPS.USERGROUPDESCRIPTION AS DESCRIPTION,
			EVENT2USERGROUP.EVENTID
		FROM 
			USERGROUPS,
			EVENT2USERGROUP
		WHERE USERGROUPS.USERGROUPID = EVENT2USERGROUP.USERGROUPID
		AND EVENT2USERGROUP.EVENTID = <cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="deleteallgroupsfornameid" access="public" returntype="void" output="false" hint="I delete all event group for a nameid">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="eventid" required="false" default="0" type="String" hint="I am the id of the event">
	<cfset var delete=0>
	<cfquery name="delete" datasource="#arguments.eventdsn#">
		DELETE FROM PEOPLE2EVENT 
		WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		<cfif arguments.eventid NEQ 0>
		AND EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfquery>
</cffunction>

<cffunction name="addpeople2event" access="public" returntype="void" output="false" hint="I associate a person with an eventgroup">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="usergroupid" required="true" type="String" hint="I am the usergroupid">
	<cfargument name="eventid" required="true" type="String" hint="I am eventid">
	<cfset var add=0>
	<cfquery name="add" datasource="#arguments.eventdsn#">
		INSERT INTO PEOPLE2EVENT
		(
			EVENTID,
			USERGROUPID,
			NAMEID
		)
		VALUES
		(
			<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.usergroupid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
</cffunction>

<cffunction name="updatepeople2event" access="public" returntype="void" output="false" hint="I associate a person with an eventgroup">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the datasource">
	<cfargument name="oldeventid" required="true" type="String" hint="I am the old eventid">
	<cfargument name="neweventid" required="true" type="String" hint="I am the old eventid">
	<cfset var update=0>
	<cfquery name="update" datasource="#arguments.eventdsn#">
		UPDATE PEOPLE2EVENT
		SET EVENTID=<cfqueryparam value="#arguments.neweventid#" cfsqltype="cf_sql_varchar">
		WHERE EVENTID=<cfqueryparam value="#arguments.oldeventid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="checkpeopleinEventGroup" access="public" returntype="String" output="false" hint="I return 1 if a person is in event group and return 0 otherwise">
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="usergroupid" required="true" type="String" hint="I am the usergroupid">
	<cfargument name="eventid" required="true" type="String" hint="I am eventid">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT NAMEID FROM PEOPLE2EVENT
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		AND USERGROUPID=<cfqueryparam value="#arguments.usergroupid#" cfsqltype="cf_sql_varchar">
		AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif get.recordcount GT 0>
		<cfreturn 1>
	</cfif>
	<cfreturn 0>
</cffunction> 

<cffunction name="isRegisteredForEvent" access="public" returntype="string" output="false" hint="I return TRUE if the person is registered for the event and FALSE otherwise">
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="eventid" required="true" type="String" hint="I am eventid">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT NAMEID FROM PEOPLE2EVENT 
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif get.RECORDCOUNT EQ 0>
		<cfreturn FALSE>
	<cfelse>
		<cfreturn TRUE>
	</cfif>
</cffunction>

<cffunction name="getEventGroupsISignedUpFor" access="public" returntype="query" output="false" hint="I get the groups I signed up for in an event">>
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="eventid" required="true" type="String" hint="I am eventid">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT 
			USERGROUPID,
			USERGROUPNAME
		FROM USERGROUPS
		WHERE USERGROUPID IN 
		(
			SELECT 
				USERGROUPID
			FROM PEOPLE2EVENT
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar"> 
		) 
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="checkEventGroupsISignedUpFor" access="public" returntype="query" output="false" hint="I check to see if the user is registered for the event, and group you pass to me">
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfargument name="nameid" required="true" type="String" hint="I am the nameid">
	<cfargument name="eventid" required="true" type="String" hint="I am eventid">
	<cfargument name="group" required="true" type="String" hint="I am groupname">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT 
			USERGROUPID,
			USERGROUPNAME
		FROM USERGROUPS
		WHERE USERGROUPNAME = <cfqueryparam value="#arguments.group#">
		AND USERGROUPID IN 
		(
			SELECT 
				USERGROUPID
			FROM PEOPLE2EVENT
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar"> 
		) 
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="getAllEvents" access="public" returntype="query" hint="I return all events. Return fields: EVENTID, actualstarttime as STARTTIME, actualendtime as ENDTIME, eight character of starttime as STARTDATE, STATUS, EVENTNAME and EVENTCATEGORYID">
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfargument name="start" type="String" required="true" hint="start of the date since when all events are to be displayed">
	<cfargument name="end" type="String" required="false" hint="end of the date upto which events are to be displayed">
	<cfargument name="status" type="string" required="false" default="Public" hint="I am the status of the event that should be returned">
	<cfargument name="category" type="string" required="false" default="0" hint="I am the event category id">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT
			REPEATINGEVENTS.EVENTINSTANCEID,
			REPEATINGEVENTS.EVENTID,
			REPEATINGEVENTS.ACTUALSTARTTIME AS STARTTIME,
			left(REPEATINGEVENTS.ACTUALSTARTTIME,8) AS STARTDATE,
			REPEATINGEVENTS.ACTUALENDTIME AS ENDTIME,
			REPEATINGEVENTS.STATUS,
			(SELECT TOP 1 EVENTNAME FROM EVENTVERSION WHERE EVENTID=REPEATINGEVENTS.EVENTID ORDER BY VERSIONID DESC) AS EVENTNAME,
			(SELECT TOP 1 EVENTCATEGORYID FROM EVENT WHERE EVENTID=REPEATINGEVENTS.EVENTID) AS EVENTCATEGORYID
		FROM REPEATINGEVENTS
		WHERE REPEATINGEVENTS.ACTUALSTARTTIME>=<cfqueryparam value="#arguments.start#" cfsqltype="cf_sql_varchar">
		AND REPEATINGEVENTS.ACTUALSTARTTIME<=<cfqueryparam value="#arguments.end#" cfsqltype="cf_sql_varchar">
		<cfif arguments.category NEQ "0">
		AND REPEATINGEVENTS.EVENTID IN (SELECT EVENTID FROM EVENT WHERE EVENTCATEGORYID=<cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_varchar">)
		</cfif>
		AND LEN(REPEATINGEVENTS.ACTUALSTARTTIME)>=14
		AND LEN(REPEATINGEVENTS.ACTUALENDTIME)>=14
		<cfif arguments.status NEQ "All">
		AND STATUS like <cfqueryparam value="#arguments.status#%" cfsqltype="cf_sql_varchar">
		</cfif>
		ORDER BY REPEATINGEVENTS.ACTUALSTARTTIME
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="deletegroupsforevent" access="public" returntype="void" hint="I delete groups from events">
	<cfargument name="eventdsn" required="true" type="String" hint="I am the data source">
	<cfargument name="eventid" required="true" type="string" hint="eventid for which groups are to be deleted">
	<cfset var delete=0>
	<cfquery name="delete" datasource="#request.dsn#">
		DELETE
		FROM EVENT2USERGROUP
		WHERE EVENTID = <cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cffunction>

<cffunction name="getEventContactGroup" access="public" returntype="string" hint="I get Event Contact Group and create one if it is not defined">
	<cfargument name="eventdsn" required="true" type="string" hint="I am the data source">
	<cfset var get=0>
	
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT
			USERGROUPID,
			USERGROUPNAME
		FROM
			USERGROUPS
		WHERE USERGROUPNAME LIKE 'Event Contacts'
	</cfquery>
	<cfif get.recordcount GT 0>
		<cfreturn get.usergroupid>
	<cfelse>
		<cfset groupid=DateTimes.createTimeDate()>
		<cfquery name="get" datasource="#arguments.eventdsn#">
			INSERT INTO USERGROUPS
			(
				USERGROUPID,
				USERGROUPNAME
			)
			VALUES
			(
				<cfqueryparam value="#groupid#" cfsqltype="cf_sql_varchar">,
				'Event Contacts'
			)
		</cfquery>
		<cfreturn groupid>
	</cfif>
</cffunction>

<cffunction name="getEventLocationGroup" access="public" returntype="string" hint="I get Event Location Group and create one if it is not defined">
	<cfargument name="eventdsn" required="true" type="string" hint="I am the data source">
	<cfset var get=0>
	
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT TOP 1
			USERGROUPID,
			USERGROUPNAME
		FROM
			USERGROUPS
		WHERE USERGROUPNAME LIKE 'Event Locations'
		ORDER BY USERGROUPID
	</cfquery>
	<cfif get.recordcount GT 0>
		<cfreturn get.usergroupid>
	<cfelse>
		<cfset groupid=DateTimes.createTimeDate()>
		<cfquery name="get" datasource="#arguments.eventdsn#">
			INSERT INTO USERGROUPS
			(
				USERGROUPID,
				USERGROUPNAME
			)
			VALUES
			(
				<cfqueryparam value="#groupid#" cfsqltype="cf_sql_varchar">,
				'Event Locations'
			)
		</cfquery>
		<cfreturn groupid>
	</cfif>
</cffunction>

<cffunction name="getRepeatingEventInfo" access="public" returntype="query" hint="I get repeatingEventInfo">
	<cfargument name="eventdsn" type="String" required="true" hint="Data source">
	<cfargument name="eventinstanceid" required="true" hint="Repeating Event Instance ID">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT
			EVENTINSTANCEID,
			EVENTID,
			ACTUALSTARTTIME,
			ACTUALENDTIME,
			STARTTIME AS REGSTARTTIME,
			ENDTIME AS REGENDTIME,
			STATUS
		FROM REPEATINGEVENTS
		WHERE EVENTINSTANCEID=<cfqueryparam value="#arguments.eventinstanceid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="getInstancesOfEvent" access="public" returntype="query" hint="I get all the existing instances of a event">
	<cfargument name="eventdsn" type="String" required="true" hint="Data source">
	<cfargument name="eventid" type="string" required="true" hint="Repeating Event Instance ID">
	<cfargument name="noofinstancestoreturn" required="false" type="string"  default="0" hint="no of instances to return">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT 
			<cfif arguments.noofinstancestoreturn NEQ "0">
			TOP #arguments.noofinstances#
			</cfif>
			(SELECT TOP 1 EVENTNAME FROM EVENTVERSION WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar"> ORDER BY VERSIONID DESC) AS EVENTNAME,
			EVENTINSTANCEID,
			EVENTID,
			ACTUALSTARTTIME,
			ACTUALENDTIME,
			STARTTIME AS REGSTARTTIME,
			ENDTIME AS REGENDTIME,
			STATUS
		FROM REPEATINGEVENTS
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		ORDER BY ACTUALSTARTTIME DESC
	</cfquery>
	<cfreturn get>
</cffunction> 

<cffunction name="searchEvents" access="public" returntype="query" hint="I search for events matching keyword">
	<cfargument name="eventdsn" type="String" required="true" hint="Data source">
	<cfargument name="keyword" type="string" required="true" hint="Keyword to search">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT
			REPEATINGEVENTS.EVENTINSTANCEID,
			REPEATINGEVENTS.EVENTID,
			REPEATINGEVENTS.ACTUALSTARTTIME AS STARTTIME,
			left(REPEATINGEVENTS.ACTUALSTARTTIME,8) AS STARTDATE,
			REPEATINGEVENTS.ACTUALENDTIME AS ENDTIME,
			REPEATINGEVENTS.STATUS,
			(SELECT TOP 1 EVENTNAME FROM EVENTVERSION WHERE EVENTID=REPEATINGEVENTS.EVENTID ORDER BY VERSIONID DESC) AS EVENTNAME,
			(SELECT TOP 1 EVENTCATEGORYID FROM EVENT WHERE EVENTID=REPEATINGEVENTS.EVENTID) AS EVENTCATEGORYID
		FROM REPEATINGEVENTS
		WHERE EVENTID IN 
		(SELECT EVENTID FROM EVENTVERSION WHERE EVENTNAME LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR DESCRIPTION LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">)
		ORDER BY REPEATINGEVENTS.ACTUALSTARTTIME DESC 
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="getRegistrationOpenEvents" access="public" returntype="query" hint="I return events whose registration is open Return fields: EVENTID, actualstarttime as STARTTIME, actualendtime as ENDTIME, eight character of starttime as STARTDATE, STATUS, EVENTNAME and EVENTCATEGORYID">
	<cfargument name="eventdsn" type="String" required="true" hint="I am the datasource">
	<cfset var get=0>
	<cfset datenow=datetimes.createtimedate()>
	<cfquery name="get" datasource="#arguments.eventdsn#">
	SELECT
		EVENT.URL AS EVENTURL,
		EVENT.CONTACTID,
		EVENTVERSION.LOCATIONID,
		EVENTVERSION.EVENTID, 
		EVENTVERSION.EVENTNAME, 
		EVENTVERSION.PAGENAME, 
		EVENTVERSION.STATUS, 
		EVENTVERSION.VERSIONID, 
		EVENTVERSION.STARTTIME,
		EVENTVERSION.ENDTIME, 
		EVENTVERSION.ACTUALSTARTTIME, 
		EVENTVERSION.ACTUALENDTIME, 
		EVENTVERSION.SEDESCRIPTION, 
		EVENTVERSION.KEYWORDS, 
		EVENTVERSION.TITLE, 
		EVENTVERSION.DESCRIPTION, 
		EVENTVERSION.MENUIMAGECAPTION, 
		EVENTVERSION.MENUIMAGELINK, 
		EVENTVERSION.PREDESSOREVENTID, 
		EVENTVERSION.PARENTEVENTID, 
		EVENTVERSION.FUSEACTIONID, 
		EVENTVERSION.PEERORDERNUMBER, 
		EVENTVERSION.IMAGEID, 
		EVENTVERSION.PERCENTCOMPLETE, 
		EVENTVERSION.CUSTOMCSS,
		EVENTVERSION.PRINTCSS,
		EVENTVERSION.SCREENCSS,
		EVENTVERSION.NAVNUM,
		EVENTVERSION.PLACEHOLDER,
		EVENTVERSION.ALTLAYOUT,
		EVENTVERSION.SITEID,
		EVENTVERSION.FREQUENCY,
		EVENTVERSION.FROMEMAIL,
		EVENTVERSION.CC,
		EVENTVERSION.SUBJECT,
		EVENTVERSION.MESSAGE,
		EVENTVERSION.DEFAULTPRICE,
		EVENTVERSION.DISCOUNTTYPE,
		EVENTVERSION.PERCENTOFF,
		EVENTVERSION.DISCOUNTPRICE,
		EVENTVERSION.GUESTPRICE,
		EVENTVERSION.INTERVAL,
		EVENTVERSION.COUNT,
		EVENTVERSION.UNTIL,
		EVENTVERSION.REPEATEND,
		EVENTVERSION.CREATEDBYID,
		EVENTCATEGORY.EVENTCATEGORYID,
		EVENTCATEGORY.EVENTCATEGORY,
		EL.COMPANY AS LOCATIONNAME,
		EL.WEMAIL AS LOCATIONEMAIL,
		EL.WPHONE AS LOCATIONPHONE,
		EL.ADDRESS1 AS LOCATIONADDRESS1,
		EL.ADDRESS2 AS LOCATIONADDRESS2,
		EL.CITY AS LOCATIONCITY,
		EL.STATE AS LOCATIONSTATE,
		EL.COUNTRY AS LOCATIONCOUNTRY,
		EL.ZIP AS LOCATIONZIP,
		EL.INTERSECTION AS LOCATIONINTERSECTION,
		EL.LAT AS LOCATIONLAT,
		EL.LON AS LOCATIONLON,
		EC.FIRSTNAME AS CONTACTFIRSTNAME,
		EC.LASTNAME AS CONTACTLASTNAME,
		EC.WPHONE AS CONTACTPHONE,
		EC.WEMAIL AS CONTACTEMAIL,
		EC.ADDRESS1 AS CONTACTADDRESS1,
		EC.ADDRESS2 AS CONTACTADDRESS2,
		EC.CITY AS CONTACTCITY,
		EC.STATE AS CONTACTSTATE,
		EC.COUNTRY AS CONTACTCOUNTRY,
		EC.ZIP AS CONTACTZIP,
		EC.INTERSECTION AS CONTACTINTERSECTION,
		EC.LAT AS CONTACTLAT,
		EC.LON AS CONTACTLON
	FROM         
	EVENT
	LEFT JOIN vwNameAddress as EC
	ON EC.NAMEID = EVENT.CONTACTID,
	EVENTVERSION 
	LEFT JOIN vwNameAddress as EL
	ON EL.nameid = EVENTVERSION.LOCATIONID,
	EVENTCATEGORY
	WHERE
	EVENT.EVENTID = EVENTVERSION.EVENTID
	AND EVENTVERSION.EVENTCATEGORYID = EVENTCATEGORY.EVENTCATEGORYID
	AND (EVENTVERSION.VERSIONID =
          (SELECT MAX(VERSIONID)
            FROM EVENTVERSION
            WHERE EVENTID = EVENT.EVENTID
            AND EVENTVERSION.STATUS = 'Public'))
	AND EVENTVERSION.STARTTIME<<cfqueryparam value="#datenow#">
	AND EVENTVERSION.ENDTIME><cfqueryparam value="#datenow#">
	ORDER BY EVENTVERSION.EVENTID
	</cfquery>
	<cfreturn get>
</cffunction>

<cffunction name="getInstancecount" access="public" returntype="string" hint="I return no of instances in the event">
	<cfargument name="eventdsn" required="true" type="string" hint="datasource">
	<cfargument name="eventid" required="true" type="string" hint="id of the event">
	<cfargument name="eventinstanceid" required="false" type="string" default="0" hint="id of the instance">
	<cfset var get=0>
	<cfquery name="get" datasource="#arguments.eventdsn#">
		SELECT COUNT(*) AS NOOFINSTANCES FROM REPEATINGEVENTS
		WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		<cfif arguments.eventinstanceid GT 0>
			AND EVENTINSTANCEID >= <cfqueryparam value="#arguments.eventinstanceid#" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfquery>
	<cfif get.recordcount GT 0>
		<cfreturn get.NOOFINSTANCES>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

</cfcomponent>