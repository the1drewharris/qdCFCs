<cfcomponent hint="addressbook functions">
	<cfobject component="textConversions" name="txtConvert">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="tree" name="treeCFC">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="init" access="public" returntype="void" hint="I run createBlogTables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke component="buildTables" method="createaddressbooktables" ds="#arguments.ds#">
	</cffunction>
	
	<cffunction name="getGroupNameOnly" access="public" output="false" hint="I get name of the group">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="false" type="string" default="0" hint="id of the group">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT USERGROUPNAME FROM USERGROUPS
			WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
		</cfquery>
		<cfreturn get.USERGROUPNAME>
	</cffunction>
	
	<cffunction name="addContactWithNameID" access="public" hint="Add contact to address book" returntype="void" output="false">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">	
		<cfargument name="nameid" required="true" type="string" hint="nameid">
		<cfargument name="firstname" type="String" required="false" default="" hint="First Name">
		<cfargument name="lastname" type="String" required="false" default="" hint="Last Name">
		<cfargument name="address1" type="String" required="false" default="" hint="Address">
		<cfargument name="address2" type="String" required="false" default="" hint="Address second line such as apartment or suite number">
		<cfargument name="city" type="String" required="false" default="" hint="city">
		<cfargument name="state" type="String" required="false" default="" hint="State">
		<cfargument name="zip" type="String" required="false" default="" hint="Zip">	
		<cfargument name="country" required="false" type="String" default="US" hint="Country">
		<cfargument name="intersection" required="false" type="String" default="0" hint="Nearest Street intersection">
		<cfargument name="title" type="String" required="false" default="0" hint="title">
		<cfargument name="middlename" type="String" required="false" default="0" hint="Middle Name">
		<cfargument name="myusername" type="String" required="false" default="0" hint="Username">
		<cfargument name="mypassword" type="String" required="false" default="0" hint="password">
		<cfargument name="wemail" type="String" required="false" default="0" hint="Work Email"> 
		<cfargument name="hemail" type="String" required="false" default="0" hint="Home Email">
		<cfargument name="memail" type="String" required="false" default="0" hint="Mobile Email">
		<cfargument name="oemail" type="String" required="false" default="0" hint="Other Email">
		<cfargument name="hphone" type="String" required="false" default="0" hint="Home phone">  
		<cfargument name="wphone" type="String" required="false" default="0" hint="Work phone"> 
		<cfargument name="mphone" type="String" required="false" default="0" hint="Mobile phone"> 
		<cfargument name="fphone" type="String" required="false" default="0" hint="Fax phone number">
		<cfargument name="ophone" type="String" required="false" default="0" hint="Other phone"> 
		<cfargument name="gender" type="String" required="false" default="3" hint="Gender of User, 0=female, 1=male, 3=n/a or unknown">
		<cfargument name="maritalstatus" type="String" required="false" default="0" hint="Marital Status, 0=Single, 1=Married">
		<cfargument name="referredby" type="String" required="false" default="0" hint="Reffered by">
		<cfargument name="spousename" type="String" required="false" default="0" hint="Spouse name">
		<cfargument name="myurl" type="String" required="false" default="0" hint="Home page">
		<cfargument name="icq" type="String" required="false" default="0" hint="ICQ IM number">
		<cfargument name="aol" type="String" required="false" default="0" hint="AOL IM">
		<cfargument name="yahoo" type="String" required="false" default="0" hint="YAHOO IM">
		<cfargument name="msn" type="String" required="false" default="0" hint="MSN IM">
		<cfargument name="mac" type="String" required="false" default="0" hint=".mac account name">
		<cfargument name="jabber" type="String" required="false" default="0" hint="JABBER">
		<cfargument name="status" type="String" required="false" default="1" hint="1 = Active, 0 = NonActive">
		<cfargument name="gmail" type="String" required="false" default="0" hint="DOB">
		<cfargument name="description" type="String" required="false" default="Contact description goes here" hint="Description or bio for the contact">
		<cfargument name="dob" type="String" required="false" default="0" hint="Date of birth">
		<cfargument name="yearsinbiz" type="String" required="false" default="0" hint="Years in Business">
		<cfargument name="bizest" type="String" required="false" default="0" hint="Business Established date">
		<cfargument name="ccaccepted" type="String" required="false" default="0" hint="Credit Cards Accepted">
		<cfargument name="slogan" type="String" required="false" default="0" hint="Business Slogan">
		<cfargument name="headnameid" type="String" required="false" default="0" hint="nameid of the Head of Household for this contact, rarely if ever used">
		<cfargument name="clientuserid" type="String" required="false" default="0" hint="Client user id, number for admin to manually assign to user for thier own records"> 
		<cfargument name="company" type="String" required="false" default="0" hint="Company name">
		<cfargument name="locationname" type="String" required ="false" default="0" hint="Name of a location, usually used when adding a location(contact) when adding an event">
		<cfargument name="altnamedb" type="String" required="false" default="0" hint="Alternate database">
		<cfargument name="usemissingnumbers" type="boolean" required="false" default="false" hint="used with clientuserid">
		<cfargument name="twitter" type="string" required="false" default="0" hint="username of twitter account">
		<cfargument name="linkedin" type="string" required="false" default="0" hint="username of linkedin account">
		<cfargument name="youtube" type="string" required="false" default="0" hint="username of youtube account">
		<cfargument name="plaxo" type="string" required="false" default="0" hint="username of plaxo account">
		<cfargument name="facebook" type="string" required="false" default="0" hint="username of facebook account">
		<cfargument name="myspace" type="string" required="false" default="0" hint="username of myspace account">
		<cfargument name="friendfeed" type="string" required="false" default="0" hint="username of friendfeed account">
		<cfargument name="lat" type="string" required="false" default="0" hint="latitute of the address">
		<cfargument name="lon" type="string" required="false" default="0" hint="longitue of the address">
		
		<cfset var timenow="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfquery datasource="#arguments.contactdsn#">
			SET IDENTITY_INSERT NAME ON
			INSERT INTO NAME
			(
				NAMEID,
				FIRSTNAME,  
				LASTNAME, 
				TIMECREATED,
				LASTUPDATED,
				GENDER
				<cfif arguments.myusername NEQ 0>,USERNAME</cfif>
				<cfif arguments.mypassword NEQ 0>,PASSWORD</cfif>
				<cfif arguments.middlename NEQ "0">,MIDDLENAME</cfif>
				<cfif arguments.clientuserid NEQ "0">,CLIENTUSERID</cfif>
				<cfif arguments.wemail NEQ "0">,WEMAIL</cfif>
				<cfif arguments.hemail NEQ "0">,HEMAIL</cfif>
				<cfif arguments.oemail NEQ "0">,OEMAIL</cfif>
				<cfif arguments.memail NEQ "0">,MEMAIL</cfif>
				<cfif arguments.status NEQ "-1">,STATUS</cfif>
				<cfif arguments.title NEQ "0">,TITLE</cfif>
				<cfif arguments.hphone NEQ "0">,HPHONE</cfif>
				<cfif arguments.wphone NEQ "0">,WPHONE</cfif> 
				<cfif arguments.mphone NEQ "0">,MPHONE</cfif>
				<cfif arguments.ophone NEQ "0">,OPHONE</cfif> 
				<cfif arguments.fphone NEQ "0">,FPHONE</cfif> 
				<cfif (arguments.company NEQ "0") OR (arguments.locationname NEQ "0")>,COMPANY</cfif>
				<cfif (maritalstatus EQ 0) OR (maritalstatus EQ 1)>,MARITALSTATUS</cfif>
				<cfif arguments.referredby NEQ "0">,REFERREDBY</cfif>
				<cfif arguments.spousename NEQ "0">,SPOUSENAME</cfif>
				<cfif arguments.myurl NEQ "0">,URL</cfif>
				<cfif arguments.icq NEQ "0">,ICQ</cfif>
				<cfif arguments.aol NEQ "0">,AOL</cfif>
				<cfif arguments.yahoo NEQ "0">,YAHOO</cfif>
				<cfif arguments.msn NEQ "0">,MSN</cfif>
				<cfif arguments.mac NEQ "0">,MAC</cfif>
				<cfif arguments.jabber NEQ "0">,JABBER</cfif>
				<cfif arguments.gmail NEQ "0">,GMAIL</cfif>
				<cfif arguments.dob NEQ "0">,DOB</cfif>
				<cfif arguments.description NEQ "0">,DESCRIPTION</cfif>
				<cfif arguments.headnameid NEQ "0">,HEADNAMEID</cfif>
				<cfif arguments.yearsinbiz NEQ "0">,YEARSINBIZ</cfif>
				<cfif arguments.bizest NEQ "0">,BIZEST</cfif>
				<cfif arguments.ccaccepted NEQ "0">,CCACCEPTED</cfif>
				<cfif arguments.slogan NEQ "0">,SLOGAN</cfif>
				<cfif arguments.twitter NEQ "0">,TWITTER</cfif>
				<cfif arguments.linkedin NEQ "0">,LINKEDIN</cfif>
				<cfif arguments.youtube NEQ "0">,YOUTUBE</cfif>
				<cfif arguments.plaxo NEQ "0">,PLAXO</cfif>
				<cfif arguments.facebook NEQ "0">,FACEBOOK</cfif>
				<cfif arguments.myspace NEQ "0">,MYSPACE</cfif>
				<cfif arguments.friendfeed NEQ "0">,FRIENDFEED</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.nameid#">,
				<cfqueryparam value="#arguments.firstname#">, 
				<cfqueryparam value="#arguments.lastname#">, 
				<cfqueryparam value="#timenow#">,
				<cfqueryparam value="#timenow#">,
				<cfqueryparam value="#arguments.gender#">
				<cfif arguments.myusername NEQ 0>,<cfqueryparam value="#arguments.myusername#"></cfif>
				<cfif arguments.mypassword NEQ 0>,<cfqueryparam value="#arguments.mypassword#"></cfif>
				<cfif arguments.middlename NEQ "0">,<cfqueryparam value="#arguments.middlename#"></cfif>
				<cfif arguments.clientuserid NEQ "0">,<cfqueryparam value="#arguments.clientuserid#"></cfif>
				<cfif arguments.wemail NEQ "0">,<cfqueryparam value="#arguments.wemail#"></cfif>
				<cfif arguments.hemail NEQ "0">,<cfqueryparam value="#arguments.hemail#"></cfif>
				<cfif arguments.oemail NEQ "0">,<cfqueryparam value="#arguments.oemail#"></cfif>
				<cfif arguments.memail NEQ "0">,<cfqueryparam value="#arguments.memail#"></cfif>
				<cfif arguments.status NEQ "-1">,<cfqueryparam value="#arguments.status#"></cfif>
				<cfif arguments.title NEQ "0">,<cfqueryparam value="#arguments.title#"></cfif>
				<cfif arguments.hphone NEQ "0">,<cfqueryparam value="#arguments.hphone#"></cfif>
				<cfif arguments.wphone NEQ "0">,<cfqueryparam value="#arguments.wphone#"></cfif>
				<cfif arguments.mphone NEQ "0">,<cfqueryparam value="#arguments.mphone#"></cfif>
				<cfif arguments.ophone NEQ "0">,<cfqueryparam value="#arguments.ophone#"></cfif>
				<cfif arguments.fphone NEQ "0">,<cfqueryparam value="#arguments.fphone#"></cfif>
				<cfif (arguments.company NEQ "0") OR (arguments.locationname NEQ "0")><cfif arguments.company NEQ "0">,<cfqueryparam value="#arguments.company#"><cfelseif arguments.locationname NEQ "0">,<cfqueryparam value="#arguments.locationname#"></cfif></cfif>
				<cfif (arguments.maritalstatus EQ 0) OR (arguments.maritalstatus EQ 1)>,<cfqueryparam value="#arguments.maritalstatus#"></cfif>
				<cfif arguments.referredby NEQ "0">,<cfqueryparam value="#arguments.referredby#"></cfif> 
				<cfif arguments.spousename NEQ "0">,<cfqueryparam value="#arguments.spousename#"></cfif>
				<cfif arguments.myurl NEQ "0">,<cfqueryparam value="#arguments.myurl#"></cfif>
				<cfif arguments.icq NEQ "0">,<cfqueryparam value="#arguments.icq#"></cfif>
				<cfif arguments.aol NEQ "0">,<cfqueryparam value="#arguments.aol#"></cfif>
				<cfif arguments.yahoo NEQ "0">,<cfqueryparam value="#arguments.yahoo#"></cfif>
				<cfif arguments.msn NEQ "0">,<cfqueryparam value="#arguments.msn#"></cfif>
				<cfif arguments.mac NEQ "0">,<cfqueryparam value="#arguments.mac#"></cfif>
				<cfif arguments.jabber NEQ "0">,<cfqueryparam value="#arguments.jabber#"></cfif>
				<cfif arguments.gmail NEQ "0">,<cfqueryparam value="#arguments.gmail#"></cfif>
				<cfif arguments.dob NEQ "0">,<cfqueryparam value="#arguments.dob#"></cfif>
				<cfif arguments.description NEQ "0">,<cfqueryparam value="#arguments.description#"></cfif>
				<cfif arguments.headnameid NEQ "0">,<cfqueryparam value="#arguments.headnameid#"></cfif>
				<cfif arguments.yearsinbiz NEQ "0">,<cfqueryparam value="#arguments.yearsinbiz#"></cfif>
				<cfif arguments.bizest NEQ "0">,<cfqueryparam value="#arguments.bizest#"></cfif>
				<cfif arguments.ccaccepted NEQ "0">,<cfqueryparam value="#arguments.ccaccepted#"></cfif>
				<cfif arguments.slogan NEQ "0">,<cfqueryparam value="#arguments.slogan#"></cfif>
				<cfif arguments.twitter NEQ "0">,<cfqueryparam value="#arguments.twitter#"></cfif>
				<cfif arguments.linkedin NEQ "0">,<cfqueryparam value="#arguments.linkedin#"></cfif>
				<cfif arguments.youtube NEQ "0">,<cfqueryparam value="#arguments.youtube#"></cfif>
				<cfif arguments.plaxo NEQ "0">,<cfqueryparam value="#arguments.plaxo#"></cfif>
				<cfif arguments.facebook NEQ "0">,<cfqueryparam value="#arguments.facebook#"></cfif>
				<cfif arguments.myspace NEQ "0">,<cfqueryparam value="#arguments.myspace#"></cfif>
				<cfif arguments.friendfeed NEQ "0">,<cfqueryparam value="#arguments.friendfeed#"></cfif>
			)
			SET IDENTITY_INSERT NAME OFF
		</cfquery>
		
		<cfquery name="add" datasource="#arguments.contactdsn#">
			INSERT INTO ADDRESS
			(
				NAMEID,
				ADDRESSTYPEID, 
				ADDRESS1, 
				ADDRESS2, 
				CITY, 
				STATE, 
				COUNTRY, 
				ZIP, 
				<cfif arguments.lat NEQ 0>LAT,</cfif>
				<cfif arguments.lon NEQ 0>LON,</cfif>
				<cfif arguments.intersection NEQ "0">INTERSECTION,</cfif>
				LASTUPDATED
			)
			VALUES
			(
				<cfqueryparam value="#arguments.nameid#">,
				<cfqueryparam value="1">, 
				<cfqueryparam value="#arguments.address1#">, 
				<cfqueryparam value="#arguments.address2#">, 
				<cfqueryparam value="#arguments.city#">, 
				<cfqueryparam value="#arguments.state#">, 
				<cfqueryparam value="#arguments.country#">, 
				<cfqueryparam value="#arguments.zip#">,
				<cfif arguments.lat NEQ 0><cfqueryparam value="#arguments.lat#">,</cfif>
				<cfif arguments.lon NEQ 0><cfqueryparam value="#arguments.lon#">,</cfif>
				<cfif arguments.intersection NEQ "0"><cfqueryparam value="#arguments.intersection#">,</cfif>
				<cfqueryparam value="#timenow#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getMaxIdsFromSyncedAB" access="public" returntype="struct" hint="return elements:nameid,clientuserid">
		<cfargument name="dbList" required="true" type="string" hint="list of databases">
		<cfset var get=0>
		<cfset var ids=StructNew()>
		<cfset ids.maxnameid=0>
		<cfset ids.maxclientuserid=0>
		<cfloop list="#arguments.dbList#" index="databasename">
			<cfquery name="get" datasource="#databasename#">
				SELECT 
					MAX(NAMEID) AS MN,
					(SELECT TOP 1 CAST(CLIENTUSERID AS numeric) AS UID FROM NAME WHERE isNumeric(CLIENTUSERID)=1 ORDER BY UID DESC) AS MC
				FROM NAME
			</cfquery>
			<cfif isNumeric(get.MN)>
				<cfif get.MN GT ids.maxnameid>
					<cfset ids.maxnameid=get.MN>
				</cfif>
			</cfif>
			<cfif isNumeric(get.MC)>
				<cfif get.MC GT ids.maxclientuserid>
					<cfset ids.maxclientuserid=get.MC>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn ids>
	</cffunction>
	
	<cffunction name="getNameofContact" access="public" returntype="query" output="false" hint="I return firstname, lastname and nameid">
		<cfargument name="contactdsn" type="string" required="true" hint="I am the datasource">
		<cfargument name="nameid" type="string" required="true" hint="I am the id of the name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT
				NAMEID,
				USERNAME,
				FIRSTNAME,
				LASTNAME
			FROM NAME
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND STATUS<><cfqueryparam value="0" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="deletecontacts" access="public" returntype="void" output="false" hint="delete contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource">
		<cfargument name="contactlist" required="true" type="string" hint="ids of the contacts">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.contactdsn#">
			UPDATE NAME 
			SET STATUS=0,
			LASTUPDATED=<cfqueryparam value="#mytime.createtimedate()#">
			WHERE NAMEID IN (#arguments.contactlist#);
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="restorecontacts" access="public" returntype="void" output="false" hint="delete contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource">
		<cfargument name="contactlist" required="true" type="string" hint="ids of the contacts">
		<cfset var restore=0>
		<cfset var timenow=mytime.createtimedate()>
		<cfquery name="restore" datasource="#arguments.contactdsn#">
			UPDATE NAME SET 
			STATUS=1,
			LASTUPDATED=<cfqueryparam value="#timenow#">
			WHERE NAMEID IN (#arguments.contactlist#);
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="checkIfGroupCanBeDeleted" access="public" returntype="boolean" output="false" hint="I return true if a group can be deleted">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="false" default="0" type="String" hint="id of a group">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT USERGROUPID FROM PEOPLE2EVENT WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
			UNION
			SELECT USERGROUPID FROM PEOPLE2USERGROUPS WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
			UNION
			SELECT USERGROUPID FROM EVENT2USERGROUP WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="removeDuplicateAddress" access="public" returntype="void" output="false" hint="I remove duplicate address from the database">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the name of the database">
		<cfset var getdup=0>
		<cfset var getaddresstosave=0>
		<cfset var deletedup=0>
		<cfset var settounique=0>
		<cfquery name="getdup" datasource="#arguments.contactdsn#">
			SELECT NAMEID FROM ADDRESS GROUP BY NAMEID HAVING COUNT(*)>1	
		</cfquery>
		<cfloop query="getdup">
			<cfset thisperson=nameid>
			<cfquery name="getaddresstosave" datasource="#arguments.contactdsn#">
				SELECT MAX(ADDRESSID) AS ADDRESSTOSAVE FROM ADDRESS WHERE NAMEID=<cfqueryparam value="#thisperson#">
			</cfquery>
			<cfset thispersonsaddress=getaddresstosave.addresstosave>
			<cfquery name="delete" datasource="#arguments.contactdsn#">
				DELETE FROM ADDRESS WHERE NAMEID=<cfqueryparam value="#thisperson#"> AND ADDRESSID < <cfqueryparam value="#thispersonsaddress#">
			</cfquery>
		</cfloop>
		<cfquery name="settounique" datasource="#arguments.contactdsn#">
			ALTER TABLE ADDRESS ADD UNIQUE (NAMEID);
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getActivationCode" access="public" returntype="string" output="false" hint="I get activationcode for a user">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the name of the database">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT ACTIVATIONCODE FROM USERACTIVATION
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.ACTIVATIONCODE>
	</cffunction>
	
	<cffunction name="isUsernameAndPasswordSet" access="public" returntype="string" output="false" hint="I find out if username and password are set">
		<cfargument name="contactdsn" required="true" type="string" hint="name of the database">
		<cfargument name="email" required="true" type="string" hint="email of the user">
		<cfset var check=0>
		<cfset var result=TRUE>
		<cfquery name="check" datasource="#arguments.contactdsn#">
			SELECT
				USERNAME,
				PASSWORD
			FROM NAME
			WHERE STATUS=1
			AND
			( 
				USERNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR WEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR HEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				OR OEMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			)
		</cfquery>
		<cfif Trim(check.username) EQ "">
			<cfset result=FALSE>
		<cfelseif Trim(check.password) EQ "">
			<cfset result=FALSE>
		</cfif>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="getDirectoryListings" access="public" returntype="query" output="false" hint="I get the listings in direcotry">
		<cfargument name="contactdsn" required="true" type="string" hint="database name">
		<cfargument name="directoryid" required="true" type="string" hint="id of the directory">
		<cfargument name="sortby" required="true" type="string" default="0" hint="name of the column to sort by">
		<cfargument name="sort" required="true" type="string" default="ASC" hint="ASC or DESC">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT 
				NAME.NAMEID, 
				PEOPLE2USERGROUPS.USERGROUPID,
				NAME.COMPANY,
				NAME.WPHONE,
				NAME.DESCRIPTION,
				NAME.LOGOID,
				NAME.URL,
				NAME.WPHONE,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				USERGROUPS.USERGROUPNAME,
				USERGROUPS.USERGROUPDESCRIPTION,
				(SELECT avg(cast(STARS AS REAL)) FROM REVIEW WHERE REVIEWOFCONTACTID=NAME.NAMEID AND REVIEW.STATUS<>'Deleted' AND STARS<>0) AS RATING,
				(SELECT count(*) FROM REVIEW WHERE REVIEWOFCONTACTID=NAME.NAMEID AND REVIEW.STATUS<>'Deleted' AND STARS<>0) AS NOOFREVIEWS
			FROM 
				PEOPLE2USERGROUPS,
				NAME, 
				ADDRESS, 
				USERGROUPS
			WHERE PEOPLE2USERGROUPS.NAMEID = NAME.NAMEID
			AND NAME.NAMEID = ADDRESS.NAMEID
			AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
			AND PEOPLE2USERGROUPS.USERGROUPID = <cfqueryparam value="#arguments.directoryid#" cfsqltype="cf_sql_varchar">
			AND NAME.STATUS = '1'
			ORDER BY
			<cfswitch expression="#arguments.sort#">
				<cfcase value="name">NAME.COMPANY</cfcase>
				<cfcase value="zip">ADDRESS.ZIP</cfcase>
				<cfcase value="rating">RATING</cfcase>
				<cfdefaultcase>NAME.COMPANY</cfdefaultcase>
			</cfswitch> 
			<cfswitch expression="#arguments.sortby#">
				<cfcase value="DESC">DESC</cfcase>
				<cfdefaultcase>ASC</cfdefaultcase>
			</cfswitch>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getDirectories" access="public" returntype="query" output="false" hint="I get list of directories">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the the data source">
		<cfargument name="parentgroupid" required="true" type="string" hint="I am the groupid of the parent">
		<cfargument name="excludelist" required="false" type="string" default="0" hint="I am the list of group names that must be excluded">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT
			    USERGROUPS.USERGROUPID,
			    USERGROUPS.USERGROUPNAME,
				USERGROUPS.PARENTUSERGROUPID,
			    COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT
			FROM
			    USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
			    ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
			WHERE USERGROUPS.PARENTUSERGROUPID = <cfqueryparam value="#arguments.parentgroupid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.excludelist NEQ 0>
			AND USERGROUPS.USERGROUPNAME NOT IN ('#arguments.excludelist#')
			</cfif>
			GROUP BY USERGROUPS.USERGROUPID, USERGROUPS.USERGROUPNAME, USERGROUPS.PARENTUSERGROUPID
			ORDER BY USERGROUPS.USERGROUPNAME
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getContactviaNameid" access="public" returntype="query" hint="I search for simple contact data with a nameid and return a recordset: firstname, lastname, nameid, wemail, hemail, oemail, username">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the name of the database">
		<cfargument name="nameid" required="true" type="string"  hint="nameid of the person. This person can already have the email address">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#" maxrows="1">
			SELECT 
				NAMEID,
				FIRSTNAME,
				LASTNAME,
				HEMAIL,
				WEMAIL,
				OEMAIL,
				USERNAME
			FROM NAME
			WHERE NAMEID = <cfqueryparam value="#arguments.nameid#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="searchEmail" access="public" returntype="query" hint="I search for email in addressbook">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the name of the database">
		<cfargument name="email" required="true" type="string" hint="Email">
		<cfargument name="nameid" required="false" type="string" default="0" hint="nameid of the person. This person can already have the email address">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT NAMEID, USERNAME, STATUS
			FROM NAME
			WHERE 1=1
			AND 
			(
				STATUS=1
				OR
				NAMEID IN (SELECT NAMEID FROM USERACTIVATION WHERE ACTIVATEDON=<cfqueryparam value="NOT ACTIVATED"> AND EXPIRYDATE><cfqueryparam value="#mytime.createTimeDate()#" cfsqltype="cf_sql_varchar">)
			)
			 
			AND(
				HEMAIL LIKE <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
				OR WEMAIL LIKE <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar"> 
				OR MEMAIL LIKE <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
				OR OEMAIL LIKE <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
				OR USERNAME LIKE <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
			)
			<cfif arguments.nameid NEQ "0">
				AND NAMEID<><cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="regReplace" access="public" returntype="string" hint="I replace as follows: @firstname:first name, @lastname: last name">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the name of the database">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of the user">
		<cfargument name="inputStr" required="true" type="string" hint="I am the input string">
		<cfinvoke method="getContactInfo" contactdsn="#arguments.contactdsn#" nameid="#arguments.nameid#" returnvariable="contactInfo">
		<cfset arguments.inputStr=Rereplace(arguments.inputStr,'@firstname',contactInfo.firstname,'All')>
		<cfset arguments.inputStr=Rereplace(arguments.inputStr,'@lastname',contactInfo.lastname,'All')>
		<cfset arguments.inputStr=Rereplace(arguments.inputStr,'@hemail',contactInfo.hemail,'All')>
		<cfset arguments.inputStr=REreplace(arguments.inputStr,'@wemail',contactInfo.wemail,'All')>
		<cfset arguments.inputStr=REreplace(arguments.inputStr,'@hphone',contactInfo.hphone,'All')>
		<cfset arguments.inputStr=REreplace(arguments.inputStr,'@wphone',contactInfo.wphone,'All')>
		<cfreturn arguments.inputStr>
	</cffunction>
	
	<cffunction name="addActivationRecord" access="public" returntype="string" hint="I add an activation record">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the data source">
		<cfargument name="nameid" required="true" type="string" hint="Name id">
		<cfargument name="key" required="false" type="string" default="0" hint="key">
		<cfargument name="expirydate" required="false" type="string" default="0" hint="time stamp when the key will expire">
		<cfset var add=0>
		
		<cfif arguments.key NEQ "0">
			<cfset activationcode=hash("#key##nameid#","SHA")>
		<cfelse>
			<cfset k=getrandomusername()>
			<cfset activationcode=hash("#k##nameid#","SHA")>
		</cfif>
		
		<cfif arguments.expirydate EQ "0">
			<cfset arguments.expirydate = "#DateFormat(DateAdd('m',1,now()),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfelseif not isNumeric(arguments.expirydate)>
			<cfset arguments.expirydate = "#DateFormat(DateAdd('m',1,now()),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfelseif len(arguments.expirydate) NEQ 16>
			<cfset arguments.expirydate = "#DateFormat(DateAdd('m',1,now()),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		</cfif>
		
		<cfquery name="add" datasource="#arguments.contactdsn#">
			INSERT INTO USERACTIVATION
			(
				ACTIVATIONCODE,
				NAMEID,
				EXPIRYDATE
			)
			VALUES
			(
				<cfqueryparam value="#activationcode#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.expirydate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn activationcode>	
	</cffunction>
	
	<cffunction name="activateAccount" access="public" returntype="string" hint="I activate user account">
		<cfargument name="contactdsn" required="true" type="string" hint="I am the data source">
		<cfargument name="activationcode" required="true" type="string" hint="Code sent via email for activation">
		<cfset var get=0>
		<cfset var activate=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT 
				NAMEID,
				EXPIRYDATE 
			FROM USERACTIVATION
			WHERE ACTIVATIONCODE=<cfqueryparam value="#arguments.activationcode#" cfsqltype="cf_sql_varchar"> 
			AND ACTIVATEDON='NOT ACTIVATED'
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn "0">
		<cfelseif get.EXPIRYDATE LT mytime.createtimedate()>
			<cfreturn "-1">
		</cfif>
		
		<cfquery name="activate" datasource="#arguments.contactdsn#">
			UPDATE NAME SET STATUS=1 WHERE NAMEID=<cfqueryparam value="#get.nameid#" cfsqltype="cf_sql_varchar">
			UPDATE USERACTIVATION SET ACTIVATEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar"> WHERE NAMEID=<cfqueryparam value="#get.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.NAMEID>
	</cffunction>
	
	<cffunction name="getallClientuserid" access="public" returntype="string" hint="I get a new clientuserid">
		<cfargument name="contactdsn" required="true" type="string" hint="Name of the database">
		<cfargument name="startMissingNumber" required="false" type="string" default="0" hint="start value of the missing Number">
		<cfset var get=0>
		<cfset allclientuserid="">
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT 
			DISTINCT CAST(CLIENTUSERID AS INT) AS UID
			FROM NAME 
			WHERE isNumeric(CLIENTUSERID)=1
			AND CAST(CLIENTUSERID AS INT)>=<cfqueryparam value="#arguments.startMissingNumber#" cfsqltype="cf_sql_varchar">
			ORDER BY UID
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset allclientuserid=ValueList(get.uid)>
		</cfif>
		<cfreturn allclientuserid>
	</cffunction>
	
	<cffunction name="getLastClientUserid" access="public" returntype="string" hint="I get latest clientuserid">
		<cfargument name="contactdsn" required="true" type="string" hint="Name of the database">
		<cfset var get=0>
		<cfset lastclientuserid=0>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT TOP 1 
			CAST(CLIENTUSERID AS INT) AS UID
			FROM NAME 
			WHERE isNumeric(CLIENTUSERID)=1 
			ORDER BY UID DESC
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset lastclientuserid=get.UID>
		</cfif>
		<cfreturn lastclientuserid>
	</cffunction>
	
	<cffunction name="getNewClientUserid" access="public" returntype="string" hint="I get a new clientuserid">
		<cfargument name="contactdsn" required="true" type="string" hint="Name of the database">
		<cfset var get=0>
		<cfset newclientuserid=1>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT TOP 1 
			CAST(CLIENTUSERID AS NUMERIC) AS UID
			FROM NAME 
			WHERE isNumeric(CLIENTUSERID)=1 
			ORDER BY UID DESC
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfset get.UID=int(get.uid)>
			<cfset newclientuserid=get.UID + 1>
		</cfif>
		<cfreturn newclientuserid>
	</cffunction>
	
	<cffunction name="zeroAdoptOrphanGroups" access="public" returntype="void" hint="I update the groups with no parents to have a parent of 0">
		<cfargument name="ds" type="string" hint="datasource">
		<cfset var zeroAdopt = 0>
		<cfquery name="zeroAdopt" datasource="#arguments.ds#">
		UPDATE USERGROUPS
		SET PARENTUSERGROUPID = '0'
		WHERE PARENTUSERGROUPID = ''
		OR PARENTUSERGROUPID IS NULL
		</cfquery>
	</cffunction>
	
	<cffunction name="getRecentContacts" access="public" returnType="query" hint="I return recent Contacts from the Address Book (USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, URL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, LASTUPDATED, MARITALSTATUS, CLIENTUSERID, REFERREDBY, URL, ICQ, AOL, YAHOO, MAC, MSN, JABBER, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION)">
		<cfargument name="contactdsn" type="string" required="true" hint="Database name">
		<cfargument name="contactStatus" type="string" required="false" default="1">
		<cfquery name="getRecent" datasource="#arguments.contactdsn#">
			SELECT TOP 10
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.URL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.LASTUPDATED,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.REFERREDBY,
				NAME.URL,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				ADDRESS.INTERSECTION
			FROM 
				NAME,
				ADDRESS
			WHERE NAME.NAMEID = ADDRESS.NAMEID
			AND NAME.STATUS = '#arguments.contactstatus#'
			ORDER BY NAME.LASTUPDATED DESC
		</cfquery>
		
		<cfreturn getRecent>
	</cffunction>

	<cffunction name="getPersonalInfo" access="public" returntype="query" hint="I return personal information about a person: FIRSTNAME, LASTNAME, COMPANY, ADDRESS1, ADDRESS2, CITY, STATE, ZIP, HEMAIL, WEMAIL, PPHONE, WPHONE, DOB, GENDER, MARITALSTATUS, DESCRIPTION,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="nameid" type="String" required="false"  default="0" hint="name id">
		<cfargument name="email" type="string" required="false" default="0">
		<cfset var personal=0>
		<cfquery name="personal" datasource="#contactdsn#">
			SELECT 
				FIRSTNAME,
				LASTNAME,
				COMPANY,
				ADDRESS1,
				ADDRESS2,
				CITY,
				STATE,
				ZIP,
				HEMAIL,
				WEMAIL,
				PPHONE,
				HPHONE,
				WPHONE,
				MPHONE,
				COUNTRY,
				PASSWORD,
				DOB,
				GENDER,
				MARITALSTATUS,
				DESCRIPTION,
				TWITTER,
				LINKEDIN,
				YOUTUBE,
				PLAXO,
				FACEBOOK,
				MYSPACE,
				FRIENDFEED
			FROM NAME, ADDRESS
			WHERE  1=1
			<cfif arguments.nameid neq 0>AND NAME.NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar"></cfif>
			<cfif arguments.email neq 0>
				AND 
				(NAME.WEMAIL LIKE <cfqueryparam value="%#arguments.email#%" cfsqltype="cf_sql_varchar">
				OR NAME.HEMAIL LIKE <cfqueryparam value="%#arguments.email#%" cfsqltype="cf_sql_varchar">
				OR NAME.USERNAME LIKE <cfqueryparam value="%#arguments.email#%" cfsqltype="cf_sql_varchar">)
			</cfif>
			AND NAME.NAMEID=ADDRESS.NAMEID
		</cfquery>
		<cfreturn personal>
	</cffunction>
	
	<cffunction name="getStates" access="public" returntype="query" hint="I return all the States of a given Country (provide country code): STATEID, COUNTRYID, STATENAME, TAXRATE">
		<cfargument name="country" required="false" default="US" hint="Country Code for a specific country. Default: US">
		<cfset var getStates=0>
		<cfquery name="getStates" datasource="deltasystem">
		SELECT     
			STATES.STATEID, 
			STATES.COUNTRYID, 
			STATES.STATENAME, 
			STATES.TAXRATE
		FROM         
			STATES
		WHERE STATES.COUNTRYID = <cfqueryparam value="#country#" cfsqltype="CF_SQL_VARCHAR">
		order by states.statename
		</cfquery>
		<cfreturn getStates>
	</cffunction>
	
	<cffunction name="getCountries" access="public" returntype="query" hint="I return all of the Countries: COUNTRYID, COUNTRYNAME">
		<cfset var getCountries=0>
		<cfquery name="getCountries" datasource="deltasystem">
			SELECT
				COUNTRYID,
				COUNTRYNAME
			FROM
				COUNTRIES
			ORDER BY COUNTRYNAME	
		</cfquery>
		<cfreturn getCountries>
	</cffunction>
	
	<cffunction name="getusers" access="public" returntype="query" hint="I get users">
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfset var users=0>
		<cfquery name="users" datasource="#contactdsn#">
			SELECT 
				NAMEID, 
				FIRSTNAME, 
				LASTNAME, 
				COMPANY,
				HEMAIL,
				WEMAIL,
				MEMAIL,
				OEMAIL,
				USERNAME
			FROM NAME
			WHERE COMPANY <> ''
			OR (FIRSTNAME <>  '' AND LASTNAME <> '')
		</cfquery>
		<cfreturn users>
	</cffunction>
	
	<cffunction name="getCompanyAndNameid" access="public" returntype="query" hint="I get company name and nameid">
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfargument name="usergroup" required="false" default="advertiser" type="string" hint="usergroup name">
		<cfargument name="groupstatus" required="false" type="string" hint="I am the status for the group">
		<cfargument name="contactstatus" required="false" type="string" hint="I am the status for the contacts">
		<cfargument name="sortlist" required="false" type="string" hint="I am the list of how you want to sort the results">
		<cfset var getcompanyandnameid=0>
		<cfquery name="getcompanyandnameid" datasource="#contactdsn#">
				SELECT 
				NAME.NAMEID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.URL AS MYURL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.REFERREDBY,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				NAME.LOGOID,
				NAME.TWITTER,
				NAME.LINKEDIN,
				NAME.YOUTUBE,
				NAME.PLAXO,
				NAME.FACEBOOK,
				NAME.MYSPACE,
				NAME.FRIENDFEED,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT, 
				ADDRESS.LON,
				ADDRESS.INTERSECTION
			FROM
				NAME, 
				ADDRESS,
				USERGROUPS,
				PEOPLE2USERGROUPS
			WHERE
				NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID 
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
				AND USERGROUPS.USERGROUPNAME=<cfqueryparam value="#usergroup#" cfsqltype="cf_sql_varchar">
				<cfif isdefined('groupstatus')>AND USERGROUPS.STATUS=<cfqueryparam value="#groupstatus#"></cfif>
			<cfif isdefined('sortlist')>
			ORDER BY #SORTLIST#
			<cfelse>
			ORDER BY COMPANY, LASTNAME, FIRSTNAME
			</cfif>
		</cfquery>
		<cfreturn getcompanyandnameid>
	</cffunction>
	
	<cffunction name="getpass" access="public" returntype="query" hint="I get password. Return fields: firstname, lastname, username, password">
		<cfargument name="ds" required="true" type="string" hint="name of the datasource">
		<cfargument name="email" required="true" type="string" hint="Email of the user">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT
				FIRSTNAME,
				LASTNAME,
				USERNAME,
				PASSWORD
			FROM NAME
			WHERE WEMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="checkPassword" access="public" returntype="Numeric" hint="I check if the password is of correct size. results: no error: 0, short password: 1, long password: 2">
		<cfargument name="mypassword" required="true" type="String" hint="Password ">
		<cfif len(mypassword) lt 6>
			<cfreturn 1>
		<cfelseif len(mypassword) gt 30>
			<cfreturn 2>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>	

	<cffunction name="checkUsernameAndLength" access="public" returntype="Numeric" hint="I check if the username already exists: no error: 0, username exists: 1 short username: 2, long username: 3">
		<!--- no error: 0, username exists: 1 short username: 2, long username: 3 --->
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfargument name="myusername" required="true" type="String" hint="username">
		<cfargument name="nameid" required="false" type="string" default="0" hint="nameid to exclude from search">
		<cfset var checkusername=0>
		<cfif len(Trim(myusername)) lt 3><cfreturn 2></cfif>
		<cfquery name="checkusername" datasource="#contactdsn#">
			SELECT 
			USERNAME
			FROM NAME
			WHERE
			USERNAME='#myusername#'
			<cfif arguments.nameid GT 0>
			AND NAMEID<><cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfif checkusername.recordcount gt 0>
			<cfreturn 1>
		<cfelseif len(myusername) gt 60>
			<cfreturn 3>
		<cfelse>
			<cfreturn 0>	
		</cfif>
	</cffunction>

	<cffunction name="checkEmail" access="public" returntype="boolean" hint="I check if the wemail address is already registered">
	<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
	<cfargument name="email" type="String" required="true" hint="User's email address">
	<cfset var checkemail=0>
	<cfquery name="checkemail" datasource="#contactdsn#">
		SELECT 
		WEMAIL
		FROM NAME
		WHERE
		WEMAIL='#email#'
	</cfquery>
	<cfif checkemail.recordcount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
	</cffunction>
	
	<cffunction name="getRandomUsername" access="public" returntype="String" Hint="I generate a random username">
		<cfset var ststring=structNew()>
		<cfloop index="i" from="1" to="10" step="1">
		
		    <cfset a = randrange(48,122)>
		
		    <cfif (#a# gt 57 and #a# lt 65) or (#a# gt 90 and #a# lt 97)>
		        <cfset ststring["#i#"]="E">
		    <cfelse>
		        <cfset ststring["#i#"]="#chr(a)#">
		    </cfif>
		
		</cfloop>
		<cfset randomusername ="#ststring[1]##ststring[2]##ststring[3]##ststring[4]##ststring[5]##ststring[6]##ststring[7]##ststring[8]##ststring[9]##ststring[10]#">
		<cfreturn randomusername>
	</cffunction>
	
	<cffunction name="findDups" access="public" returntype="query" hint="I find the duplicate records and return a recordset: nameid,company,firstname,lastname,username,HPHONE,WPHONE,WEMAIL,HEMAIL,OPHONE,MPHONE,clientuserid,addressid,address1,city,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED">
		<cfargument name="findDup" type="string" required="false" default="name" hint="I am the type of dups you are searching for: wemail, hemail, address, name, clientuserid, username">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource.">
		<cfargument name="recordsPerPage" required="false" type="string" hint="Number of Records to return per page" default="60">
		<cfargument name="pageNumber" required="false" type="string" hint="Current Page Number" default="1">
		<cfset var start=0>
		<cfset var end=0>
		<cfset var name=0>
		<cfset var getNoOfRecords=0>
		<cfset start = recordsPerPage * (pageNumber - 1)>
		<cfset end = recordsPerPage * pageNumber>
	
		<cfswitch expression="#arguments.findDup#">
			<cfcase value="name">
				<cfquery name="getNoOfRecords" datasource="#arguments.ds#">
					SELECT COUNT(NAME.NAMEID) AS NOOFRECORDS FROM NAME
					INNER JOIN
					(
						SELECT FIRSTNAME, LASTNAME
						FROM NAME 
						WHERE STATUS=1
						GROUP BY FIRSTNAME, LASTNAME
						HAVING COUNT(*) >= 2
					) AS DUPTABLE
					ON 
					(
						NAME.FIRSTNAME = DUPTABLE.FIRSTNAME
						AND NAME.LASTNAME = DUPTABLE.LASTNAME
					)
					WHERE DATALENGTH(NAME.FIRSTNAME)>0
					AND DATALENGTH(NAME.LASTNAME)> 0
					AND STATUS=1
				</cfquery>
			
				<cfquery name="getPeople" datasource="#arguments.ds#">
					SELECT * FROM 
					(
						SELECT 
							DISTINCT ROW_NUMBER() OVER (ORDER BY NAME.LASTNAME, NAME.FIRSTNAME) AS ROWNUM,
							NAME.NAMEID AS USERID,
							NAME.COMPANY,
							NAME.TITLE,
							NAME.FIRSTNAME,
							NAME.LASTNAME,
							NAME.MIDDLENAME,
							NAME.HPHONE,
							NAME.WPHONE,
							NAME.OPHONE,
							NAME.MPHONE,
							NAME.FPHONE,
							NAME.CLIENTUSERID,
							NAME.USERNAME,
							NAME.MEMAIL,
							NAME.HEMAIL,
							NAME.WEMAIL,
							NAME.GENDER,
							NAME.OEMAIL,
							NAME.LOGOID,
							NAME.STATUS,
							NAME.URL AS MYURL,
							ADDRESS.ADDRESSID,
							ADDRESS.ADDRESS1,
							ADDRESS.ADDRESS2,
							ADDRESS.CITY,
							ADDRESS.STATE,
							ADDRESS.COUNTRY,
							ADDRESS.ZIP,
							ADDRESS.LAT,
							ADDRESS.LON,
							#getNoOfRecords.NOOFRECORDS# AS NUMOFRECORDS,
							0 AS HASREVIEWS,
							IMAGE.IMAGEPATH
						FROM NAME 
						LEFT OUTER JOIN IMAGE
							ON NAME.LOGOID=IMAGE.IMAGEID
						INNER JOIN ADDRESS 
							ON NAME.NAMEID = ADDRESS.NAMEID
						INNER JOIN 
						(
							SELECT FIRSTNAME, LASTNAME 
							FROM NAME
							WHERE STATUS=1
							GROUP BY FIRSTNAME, LASTNAME
							HAVING COUNT(*) >= 2
						) AS DUPTABLE
							ON 
							(
								NAME.FIRSTNAME = DUPTABLE.FIRSTNAME
								AND NAME.LASTNAME = DUPTABLE.LASTNAME
							)
						WHERE DATALENGTH(NAME.FIRSTNAME) > 0
						AND DATALENGTH(NAME.LASTNAME) > 0
						AND NAME.STATUS=1	
					) AS A
					WHERE 1=1
					<cfif arguments.recordsPerPage GTE 0> AND A.rownum BETWEEN (#start#) AND (#end#)</cfif>
					ORDER BY LASTNAME, FIRSTNAME
				</cfquery>
			</cfcase>
			<cfcase value="clientuserid,username,hemail,wemail">
				<cfquery name="getNoOfRecords" datasource="#arguments.ds#">
					SELECT COUNT(NAME.NAMEID) AS NOOFRECORDS FROM NAME
					INNER JOIN
					(
						SELECT #arguments.findDup#
						FROM NAME 
						WHERE STATUS=1
						GROUP BY #arguments.findDup#
						HAVING COUNT(*) >= 2
					) AS DUPTABLE
						ON 
						(
							NAME.#arguments.findDup# = DUPTABLE.#arguments.findDup#
						)
					WHERE DATALENGTH(NAME.#arguments.findDup#)>0
					AND NAME.#arguments.findDup# IS NOT NULL
					AND STATUS=1
				</cfquery>
				
				<cfquery name="getPeople" datasource="#arguments.ds#">
					SELECT * FROM 
					(
						SELECT 
							ROW_NUMBER() OVER (ORDER BY NAME.#arguments.findDup#) AS ROWNUM,
							NAME.NAMEID AS USERID,
							NAME.COMPANY,
							NAME.TITLE,
							NAME.FIRSTNAME,
							NAME.LASTNAME,
							NAME.MIDDLENAME,
							NAME.HPHONE,
							NAME.WPHONE,
							NAME.OPHONE,
							NAME.MPHONE,
							NAME.FPHONE,
							NAME.CLIENTUSERID,
							NAME.USERNAME,
							NAME.MEMAIL,
							NAME.HEMAIL,
							NAME.WEMAIL,
							NAME.GENDER,
							NAME.OEMAIL,
							NAME.LOGOID,
							NAME.STATUS,
							NAME.URL AS MYURL,
							ADDRESS.ADDRESSID,
							ADDRESS.ADDRESS1,
							ADDRESS.ADDRESS2,
							ADDRESS.CITY,
							ADDRESS.STATE,
							ADDRESS.COUNTRY,
							ADDRESS.ZIP,
							ADDRESS.LAT,
							ADDRESS.LON,
							#getNoOfRecords.NOOFRECORDS# AS NUMOFRECORDS,
							0 AS HASREVIEWS,
							IMAGE.IMAGEPATH
						FROM NAME 
						LEFT OUTER JOIN IMAGE
							ON NAME.LOGOID=IMAGE.IMAGEID
						INNER JOIN ADDRESS 
							ON NAME.NAMEID = ADDRESS.NAMEID
						INNER JOIN 
						(
							SELECT #arguments.findDup#
							FROM NAME
							WHERE STATUS=1
							GROUP BY #arguments.findDup#
							HAVING COUNT(*) >= 2
						) AS DUPTABLE
							ON 
							(
								NAME.#arguments.findDup# = DUPTABLE.#arguments.findDup#
							)
						WHERE DATALENGTH(NAME.#arguments.findDup#) > 0
					) AS A
					WHERE 1=1
					<cfif RECORDSPERPAGE GTE 0> AND A.ROWNUM BETWEEN (#START#) AND (#END#)</cfif>
					ORDER BY #arguments.findDup#
				</cfquery>
			</cfcase>
			<cfcase value="address">
				<cfquery name="getNoOfRecords" datasource="#arguments.ds#">
					SELECT COUNT(ADDRESS.ADDRESSID) AS NOOFRECORDS FROM ADDRESS
					INNER JOIN
					(
						SELECT ADDRESS1
						FROM ADDRESS
						WHERE NAMEID IN (SELECT NAMEID FROM NAME WHERE STATUS=1)
						AND NAMEID IN (SELECT DISTINCT NAMEID FROM ADDRESS)
						GROUP BY ADDRESS1
						HAVING COUNT(*) >= 2
					) AS DUPTABLE
						ON 
						(
							ADDRESS.ADDRESS1 = DUPTABLE.ADDRESS1
						)
					WHERE ADDRESS.ADDRESS1<>''
					AND ADDRESS.ADDRESS1 IS NOT NULL
					AND ADDRESS.ADDRESS1<>'0'
				</cfquery>
				
				<cfquery name="getPeople" datasource="#ds#">
					SELECT * FROM 
					(
						SELECT 
							ROW_NUMBER() OVER (ORDER BY ADDRESS.ADDRESS1) AS ROWNUM,
							NAME.NAMEID AS USERID,
							NAME.COMPANY,
							NAME.TITLE,
							NAME.FIRSTNAME,
							NAME.LASTNAME,
							NAME.MIDDLENAME,
							NAME.HPHONE,
							NAME.WPHONE,
							NAME.OPHONE,
							NAME.MPHONE,
							NAME.FPHONE,
							NAME.CLIENTUSERID,
							NAME.USERNAME,
							NAME.MEMAIL,
							NAME.HEMAIL,
							NAME.WEMAIL,
							NAME.GENDER,
							NAME.OEMAIL,
							NAME.LOGOID,
							NAME.STATUS,
							NAME.URL AS MYURL,
							ADDRESS.ADDRESSID,
							ADDRESS.ADDRESS1,
							ADDRESS.ADDRESS2,
							ADDRESS.CITY,
							ADDRESS.STATE,
							ADDRESS.COUNTRY,
							ADDRESS.ZIP,
							ADDRESS.LAT,
							ADDRESS.LON,
							#getNoOfRecords.NOOFRECORDS# AS NUMOFRECORDS,
							0 AS HASREVIEWS,
							IMAGE.IMAGEPATH
						FROM NAME 
						LEFT OUTER JOIN IMAGE
							ON NAME.LOGOID=IMAGE.IMAGEID
						INNER JOIN ADDRESS 
							ON NAME.NAMEID = ADDRESS.NAMEID
						INNER JOIN 
						(
							SELECT ADDRESS1
							FROM ADDRESS
							WHERE NAMEID IN (SELECT NAMEID FROM NAME WHERE STATUS=1)
							AND NAMEID IN (SELECT DISTINCT NAMEID FROM ADDRESS)
							GROUP BY ADDRESS1
							HAVING COUNT(*) >= 2
						) AS DUPTABLE
							ON 
							(
								ADDRESS.ADDRESS1 = DUPTABLE.ADDRESS1
							)
							WHERE ADDRESS.ADDRESS1<>''
							AND ADDRESS.ADDRESS1 IS NOT NULL
							AND ADDRESS.ADDRESS1<>'0'
					)AS A
					WHERE 1 = 1
					<cfif RECORDSPERPAGE GTE 0> AND A.ROWNUM BETWEEN (#START#) AND (#END#)</cfif>
					ORDER BY ADDRESS1
				</cfquery>
			</cfcase>
		</cfswitch>
		<cfreturn getPeople>
	</cffunction>
		
	<cffunction name="changePassword" returntype="void" access="public" hint="I change password">
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfargument name="myusername" required="true" type="String" hint="username">
		<cfargument name="newpassword" required="true" type="String" hint="new password">
		<cfset var updatepassword=0>
		<cfquery name="updatepassword" datasource="#contactdsn#">
			UPDATE NAME
			SET PASSWORD=<cfqueryparam value="#newpassword#">
			WHERE
			USERNAME='#myusername#'
		</cfquery>
	</cffunction>
	
	<cffunction name="changeUsername" returntype="void" access="public" hint="I change username">
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfargument name="oldusername" required="true" type="String" hint="Old Username">
		<cfargument name="newusername" required="true" type="String" hint="New Username">
		<cfset var updateusername=0>
		<cfquery name="updateusername" datasource="#contactdsn#">
			UPDATE NAME
			SET USERNAME=<cfqueryparam value="#newusername#">
			WHERE
			USERNAME='#oldusername#'
		</cfquery>
	</cffunction>

	<cffunction name="hoursOfOperationToMilTime" access="public" hint="I convert hours of operation to miltary Time. Output: Structure with elements opentime and closetime" returntype="struct">
		<cfargument name="starthour" required="true" type="String"> 
		<cfargument name="startmin" required="true" type="String"> 
		<cfargument name="startampm" required="true" type="String">
		<cfargument name="endhour" required="true" type="String">
		<cfargument name="endmin" required="true" type="String">
		<cfargument name="endampm" required="true" type="String"> 	
		<cfset var opentime = 0>
		<cfset var closetime = 0>
		<cfset var hoursofop=structnew()>
		<cfif startampm EQ "PM">
			<cfset starthour = starthour + 12>
		</cfif> 
		
		<cfif endampm EQ "PM">
			<cfset endhour = endhour + 12>
		</cfif>
		
		<cfset opentime = "#starthour##startmin#">
		<cfset closetime = "#endhour##endmin#">
		<cfset hoursofop=structnew()>
		<cfset hoursofop.opentime=opentime>
		<cfset hoursofop.closetime=closetime>
		<cfreturn hoursofop>
	</cffunction>

	<cffunction name="updateContact" access="public" output="false" hint="I update the contact for the mynameid passed to me">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">	
		<cfargument name="mynameid" required="true" type="String" hint="The nameid of the contact you are updating">
		<cfargument name="firstname" type="String" required="false" hint="First Name">
		<cfargument name="middlename" type="String" required="false" hint="Middle Name">
		<cfargument name="lastname" type="String" required="false" hint="Last Name">
		<cfargument name="address1" type="String" required="false" hint="Address">
		<cfargument name="address2" required="false" type="String" default="0" hint="Address second line such as apartment or suite number">
		<cfargument name="city" type="String" required="false" hint="city">
		<cfargument name="state" type="String" required="false" hint="State">
		<cfargument name="zip" type="String" required="false" hint="Zip">	
		<cfargument name="country" required="false" type="String" default="US" hint="Country">
		<cfargument name="intersection" required="false" type="String" default="" hint="Nearest Street intersection">
		<cfargument name="myusername" type="String" required="false" hint="Username">
		<cfargument name="mypassword" type="String" required="false" default="" hint="password">
		<cfargument name="title" type="String" required="false" default="" hint="title">
		<cfargument name="wemail" type="String" required="false" hint="Work Email"> 
		<cfargument name="hemail" type="String" required="false" hint="Home Email"> 
		<cfargument name="oemail" type="String" required="false" hint="Other Email">
		<cfargument name="hphone" type="String" required="false" hint="Home phone">  
		<cfargument name="wphone" type="String" required="false" hint="Work phone"> 
		<cfargument name="mphone" type="String" required="false" hint="Mobile phone"> 
		<cfargument name="fphone" type="String" required="false" hint="Fax phone number">
		<cfargument name="ophone" type="String" required="false" hint="Other phone"> 
		<cfargument name="gender" type="String" required="false" hint="Gender of User, 0=female, 1=male, 3=n/a or unknown">
		<cfargument name="maritalstatus" type="String" required="false" hint="Marital Status, 0=Single, 1=Married" default="0">
		<cfargument name="referredby" type="String" required="false" hint="Reffered by">
		<cfargument name="spousename" type="String" required="false" hint="Spouse name">
		<cfargument name="myurl" type="String" required="false" hint="Home page">
		<cfargument name="icq" type="String" required="false" hint="ICQ IM number">
		<cfargument name="aol" type="String" required="false" hint="AOL IM">
		<cfargument name="yahoo" type="String" required="false" hint="YAHOO IM">
		<cfargument name="msn" type="String" required="false" hint="MSN IM">
		<cfargument name="mac" type="String" required="false" hint=".mac account name">
		<cfargument name="jabber" type="String" required="false" hint="JABBER">
		<cfargument name="status" type="boolean" required="false" default=1 hint="1 = Active, 0 = NonActive">
		<cfargument name="gmail" type="String" required="false" hint="GMAIL">
		<cfargument name="description" type="String" required="false" default="Contact description goes here" hint="Description or bio for the contact">
		<cfargument name="dob" type="String" required="false" hint="Date of birth">
		<cfargument name="yearsinbiz" type="String" required="false" hint="Years in Business">
		<cfargument name="bizest" type="String" required="false" hint="Business Established date">
		<cfargument name="ccaccepted" type="String" required="false" hint="Credit Cards Accepted">
		<cfargument name="slogan" type="String" required="false" hint="Business Slogan">
		<cfargument name="headnameid" type="String" required="false" hint="nameid of the Head of Household for this contact, rarely if ever used">
		<cfargument name="clientuserid" type="String" required="false" hint="Client user id, number for admin to manually assign to user for thier own records"> 
		<cfargument name="company" type="String" required="false" hint="Company name">
		<cfargument name="locationname" type="String" required ="false" hint="Name of a location, usually used when adding a location(contact) when adding an event">
		<cfargument name="twitter" type="string" required="false" default="0" hint="username of twitter account">
		<cfargument name="linkedin" type="string" required="false" default="0" hint="username of linkedin account">
		<cfargument name="youtube" type="string" required="false" default="0" hint="username of youtube account">
		<cfargument name="plaxo" type="string" required="false" default="0" hint="username of plaxo account">
		<cfargument name="facebook" type="string" required="false" default="0" hint="username of facebook account">
		<cfargument name="myspace" type="string" required="false" default="0" hint="username of myspace account">
		<cfargument name="friendfeed" type="string" required="false" default="0" hint="username of friendfeed account">
		<cfset var qryupdatename=0>
		<cfset var newaddress=structNew()>
		<cfquery name="qryupdatename" datasource="#arguments.contactdsn#">
			UPDATE NAME SET
				LASTUPDATED = <cfqueryparam value="#mytime.createTimeDate()#" cfsqltype="CF_SQL_VARCHAR">
				<cfif isdefined('myusername')>
					,USERNAME = <cfqueryparam value="#myusername#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				
				<cfif mypassword neq "">
					,PASSWORD=<cfqueryparam value="#mypassword#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				
				<cfif isdefined('firstname')>
					,FIRSTNAME = <cfqueryparam value="#firstname#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				
				<cfif isdefined('lastname')>
					,LASTNAME = <cfqueryparam value="#lastname#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif isDefined('middlename')>
					,MIDDLENAME=<cfqueryparam value="#middlename#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isdefined('hphone')>
					,HPHONE = <cfqueryparam value="#hphone#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('wphone')>
					,WPHONE = <cfqueryparam value="#wphone#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif isdefined('mphone')>
					,MPHONE = <cfqueryparam value="#mphone#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('fphone')>
					,FPHONE=<cfqueryparam value="#fphone#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('ophone')>
					,OPHONE=<cfqueryparam value="#ophone#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('title')>
					,TITLE=<cfqueryparam value="#title#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('description')>
					,DESCRIPTION = <cfqueryparam value="#description#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('referredby')>
					,REFERREDBY = <cfqueryparam value="#referredby#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('company')>
					,COMPANY = <cfqueryparam value="#company#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('wemail')> 
					,WEMAIL = <cfqueryparam value="#wemail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('hemail')> 
					,HEMAIL = <cfqueryparam value="#hemail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('oemail')>
					,OEMAIL = <cfqueryparam value="#oemail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('memail')>
					,MEMAIL = <cfqueryparam value="#memail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('gender')>
					,GENDER = <cfqueryparam value="#gender#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif maritalstatus EQ 0 or maritalstatus EQ 1>
					,MARITALSTATUS = <cfqueryparam value="#maritalstatus#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('dob')>
					,DOB = <cfqueryparam value="#dob#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif isdefined('spousename')>
					,SPOUSENAME = <cfqueryparam value="#spousename#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif isdefined('icq')>
					,ICQ = <cfqueryparam value="#icq#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('yahoo')>
					,YAHOO = <cfqueryparam value="#yahoo#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('aol')>
					,AOL = <cfqueryparam value="#aol#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('jabber')>
					,JABBER = <cfqueryparam value="#jabber#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('mac')>
					,MAC = <cfqueryparam value="#mac#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('msn')>
					,MSN = <cfqueryparam value="#msn#" cfsqltype="CF_SQL_VARCHAR"> 
				</cfif>
				<cfif isdefined('gmail')>
					,GMAIL = <cfqueryparam value="#gmail#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('myurl')>
					,URL = <cfqueryparam value="#myurl#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('status')>
					,STATUS=<cfqueryparam value="#status#" cfsqltype="CF_SQL_BIT">
				</cfif>
				<cfif isdefined('yearsinbiz')>
					,YEARSINBIZ=<cfqueryparam value="#yearsinbiz#">
				</cfif>
				<cfif isdefined('bizest')>
					,BIZEST=<cfqueryparam value="#bizest#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('ccaccepted')>
					,CCACCEPTED=<cfqueryparam value="#ccaccepted#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('slogan')>
					,SLOGAN=<cfqueryparam value="#slogan#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif arguments.TWITTER NEQ "0">
					,TWITTER=<cfqueryparam value="#arguments.TWITTER#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.LINKEDIN NEQ "0">
					,LINKEDIN=<cfqueryparam value="#arguments.LINKEDIN#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.YOUTUBE NEQ "0">
					,YOUTUBE=<cfqueryparam value="#arguments.YOUTUBE#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.PLAXO NEQ "0">
					,PLAXO=<cfqueryparam value="#arguments.PLAXO#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.FACEBOOK NEQ "0">
					,FACEBOOK=<cfqueryparam value="#arguments.FACEBOOK#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.MYSPACE NEQ "0">
					,MYSPACE=<cfqueryparam value="#arguments.MYSPACE#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.FRIENDFEED NEQ "0">
					,FRIENDFEED=<cfqueryparam value="#arguments.FRIENDFEED#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('arguments.clientuserid')>
					,CLIENTUSERID=<cfqueryparam value="#arguments.clientuserid#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE NAMEID = <cfqueryparam value="#arguments.mynameid#">
		</cfquery>
		
		<cfif isdefined('arguments.address1') AND isdefined('arguments.city') AND isdefined('arguments.state') AND isdefined('arguments.zip')>
			<cfinvoke component="LatLon" method="get" address = "#arguments.address1#" city = "#arguments.city#" state = "#arguments.state#" zip = "#arguments.zip#" returnvariable="newaddress">
			
			<cfquery name="qryupdateaddress" datasource="#contactdsn#">
				UPDATE ADDRESS SET
					ADDRESS1 = <cfqueryparam value="#arguments.address1#" cfsqltype="CF_SQL_VARCHAR">,
					<cfif isdefined('newaddress.lat')>LAT = '#newaddress.lat#',</cfif>
					<cfif isdefined('newaddress.lon')>LON = '#newaddress.lon#',</cfif>
					<cfif Trim(arguments.address2) NEQ "0">
					ADDRESS2=<cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">,
					</cfif>
					CITY = <cfqueryparam value="#arguments.city#" cfsqltype="CF_SQL_VARCHAR">,
					STATE = <cfqueryparam value="#arguments.state#" cfsqltype="CF_SQL_VARCHAR">,
					ZIP = <cfqueryparam value="#arguments.zip#" cfsqltype="CF_SQL_VARCHAR">
					<cfif isDefined('arguments.country')>, COUNTRY = <cfqueryparam value="#arguments.country#" cfsqltype="CF_SQLVARCHAR"></cfif>
				WHERE NAMEID = <cfqueryparam value="#arguments.mynameid#">
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="getGroupInfo" output="false" access="public" returntype="query" hint="I get the information for the groupid passed to me, I return a query (parentid AS parent, PARENTID, groupid AS id, groupid, groupid AS nestLevel, name, description, parentname, keywords, status, groupcount)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="false" default="0" type="String" hint="id of the group you want data on">
		<cfargument name="status" required="false" type="string" hint="status of the groups you want">
		<cfargument name="excludelist" required="false" default="0" hint="I am a list of groupid's you want to exclude">
		<cfargument name="sortlist" required="false" default="USERGROUPS.USERGROUPNAME" type="string" hint="list of columns you want to sort by">
		<cfset var getgroup=0>
		<!--- <cfquery name="getgroup" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
    		USERGROUPS.USERGROUPNAME AS NAME,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
    		COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
   			USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
    		ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		WHERE USERGROUPS.USERGROUPID =<cfqueryparam value="#groupid#">
		<cfif isdefined('status')>
		AND STATUS=<cfqueryparam value="#status#">
		</cfif>
		GROUP BY 
			USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			USERGROUPS.PARENTUSERGROUPID, 
			USERGROUPS.STATUS, 
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION)
		ORDER BY #SORTLIST#
		</cfquery> --->
		<cfquery name="getgroup" datasource="#arguments.contactdsn#">
		SELECT
			USERGROUPS.USERGROUPID AS GROUPID,
		    USERGROUPS.USERGROUPNAME AS NAME,
		    USERGROUPS.KEYWORDS,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
			(SELECT USERGROUPNAME FROM USERGROUPS UG WHERE UG.USERGROUPID = USERGROUPS.PARENTUSERGROUPID) AS PARENTNAME,
			(SELECT COUNT(USERGROUPID) FROM PEOPLE2USERGROUPS P WHERE P.USERGROUPID = USERGROUPS.USERGROUPID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
		   USERGROUPS
		WHERE 1=1
		<cfif arguments.groupid neq 0>AND USERGROUPS.USERGROUPID = <cfqueryparam value="#arguments.groupid#"></cfif>
		<cfif arguments.excludelist neq 0>AND USERGROUPS.USERGROUPID NOT IN (<cfqueryparam value="#arguments.excludelist#" List="True">)</cfif>
		</cfquery>
		<cfif arguments.groupid eq 0>
			<cfquery name="makeTree" dbtype="query">
				select 
					parentid AS parent,
					PARENTID,
					groupid AS id,
					groupid,
					groupid AS nestLevel,
					name,
					description,
					parentname,
					keywords,
					status,
					groupcount
				from getgroup
			</cfquery>
	
			<cfinvoke component="#treeCFC#" method="makeBranches" theQuery="#makeTree#" thisBranch="0"
			nestLevel="0" returnVariable="getgroup" />
		</cfif>
		<cfreturn getgroup>
	</cffunction>
	
	<cffunction name="getGroupName" output="false" access="public" returntype="query" hint="I get basic information about all groups for a DSN, I return a query (parent, parentid, id, groupid, nestlevel, name)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="false" type="string" default="0" hint="id of the group">
		<cfset var getgroup=0>
		<!--- <cfquery name="getgroup" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
    		USERGROUPS.USERGROUPNAME AS NAME,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
    		COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
   			USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
    		ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		WHERE USERGROUPS.USERGROUPID =<cfqueryparam value="#groupid#">
		<cfif isdefined('status')>
		AND STATUS=<cfqueryparam value="#status#">
		</cfif>
		GROUP BY 
			USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			USERGROUPS.PARENTUSERGROUPID, 
			USERGROUPS.STATUS, 
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION)
		ORDER BY #SORTLIST#
		</cfquery> --->
		<cfquery name="getgroup" datasource="#arguments.contactdsn#">
		SELECT
			USERGROUPS.USERGROUPID AS GROUPID,
		    USERGROUPS.USERGROUPNAME AS NAME,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID
		FROM
		   USERGROUPS
		 <cfif arguments.groupid NEQ 0>
			WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_varchar">
		</cfif> 
		</cfquery>
		<cfif arguments.groupid eq 0>
			<cfquery name="makeTree" dbtype="query">
				select 
					parentid AS parent,
					PARENTID,
					groupid AS id,
					groupid,
					groupid AS nestLevel,
					name
				from getgroup
				order by name
			</cfquery>
	
			<cfinvoke component="#treeCFC#" method="makeBranches" theQuery="#makeTree#" thisBranch="0"
			nestLevel="0" returnVariable="getgroup" />
		</cfif>
		<cfreturn getgroup>
	</cffunction>
	
	<cffunction name="addContactToGroup" access="public" returntype="void">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="nameid" type="String" required="true" hint="name id">
		<cfargument name="groupid" type="String" required="true" hint="group id">
		<cfset var checkpeopleusergroup=0>
		<cfset var qryaddpeople2group=0>
		<!--- check to see if the person is already in this usergroup --->
		<cfquery name="checkpeopleusergroup" datasource="#contactdsn#">
			SELECT
				USERGROUPID
			FROM
				PEOPLE2USERGROUPS
			WHERE USERGROUPID = <cfqueryparam value="#groupid#">
			AND NAMEID = <cfqueryparam value="#nameid#">
		</cfquery>
		<cfif checkpeopleusergroup.recordcount lt 1>
			<!--- go ahead and add them to the usergroup --->
			<cfquery name="qryddpeople2group" datasource="#contactdsn#">
				INSERT INTO PEOPLE2USERGROUPS
					(NAMEID,
					USERGROUPID)
				VALUES
					(<cfqueryparam value="#nameid#">,
					<cfqueryparam value="#groupid#">)
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="checkUsername" returntype="boolean" output="false" access="public" hint="I check to see if the username already exists in the database, if it exist, I return true if not I return false">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">	
		<cfargument name="myusername" required="true" type="string" hint="The username to check">
		<cfargument name="nameid" required="false" type="string" default="0" hint="nameid of the user">
		<cfset var checkThisUsername=0>
		<cfquery name="checkThisUsername" datasource="#arguments.contactdsn#">
			SELECT USERNAME
			FROM NAME
			WHERE USERNAME=<cfqueryparam value="#arguments.myusername#" cfsqltype="cf_sql_varchar">
			AND STATUS=1
			<cfif arguments.nameid NEQ 0>
			AND NAMEID<><cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfif checkThisUsername.recordcount gt 0>
			<cfset usernameExists=true>
		<cfelse>
			<cfset usernameExists=false>
		</cfif>
		<cfreturn usernameExists>
	</cffunction>

	<cffunction name="addGroup" access="public" returntype="String" hint="I add the group info passed to me to the database">
		<cfargument name="contactdsn" type="String" required="true" hint="Datasource">
		<cfargument name="usergroupname" type="String" required="true" hint="Group name">
		<cfargument name="parentusergroupid" type="String" required="false" hint="Parent group id" default="0">
		<cfargument name="usergroupdescription" type="String" required="false" hint="Short description of the group">
		<cfargument name="keywords" type="String" required="false" hint="keywords for the group">
		<cfargument name="nameid" type="String" required="false" hint="nameid of the creator">
		<cfargument name="status" type="String" required="false" hint="status (Public, Private)">
		<cfset var checkusergroup=0>
		<cfset var addgroup=0>
		<cfset var thistime=0>
		<cfset thistime = mytime.createTimeDate()>
		<cfquery name="checkusergroup" datasource="#contactdsn#">
			SELECT USERGROUPID 
			FROM USERGROUPS
			WHERE USERGROUPNAME=<cfqueryparam value="#usergroupname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif checkusergroup.recordcount EQ 0>
			<cfquery name="addgroup" datasource="#contactdsn#">
				
				INSERT INTO USERGROUPS
				(
					USERGROUPID,
					USERGROUPNAME
					, PARENTUSERGROUPID
					<cfif isdefined('usergroupdescription')>, USERGROUPDESCRIPTION</cfif>
					<cfif isdefined('keywords')>, KEYWORDS</cfif>
					<cfif isdefined('nameid')>, NAMEID</cfif>
					<cfif isdefined('STATUS')>, STATUS</cfif>
				)
				VALUES
				(
						<cfqueryparam value="#thistime#">,
						<cfqueryparam value="#usergroupname#">
						,<cfqueryparam value="#arguments.parentusergroupid#">
						
						<cfif isdefined('usergroupdescription')>
							,<cfqueryparam value="#usergroupdescription#">
						</cfif>
						
						<cfif isdefined('keywords')>
							,<cfqueryparam value="#keywords#">
						</cfif>
						
						<cfif isdefined('nameid')>
							,<cfqueryparam value="#nameid#">
						</cfif>
						
						<cfif isdefined('status')>
							,<cfqueryparam value="#status#">
						</cfif>
					)
				</cfquery>
				<cfreturn thistime>
			<cfelse>
				<cfreturn checkusergroup.USERGROUPID>
			</cfif>
	</cffunction>	
	
	<cffunction name="searchGroup" access="public" output="false" returntype="query" hint="I search for groups using group name, I return (groupid, groupname, parentid, keywords, description, status, groupstatus)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="criteria" required="false" default="" type="String" hint="criteria">
		<cfargument name="groupid" required="false" type="string" default="0" hint="an id for a groupid you want to search for.">
		<cfargument name="status" required="false" type="string" default="0" hint="status of the groups you want">
		<cfargument name="parentgroupid" required="false" type="string" default="0" hint="the id of a parentgroup">
		<cfargument name="sortlist" required="false" default="USERGROUPS.USERGROUPNAME" type="string" hint="list of columns you want to sort by">
		<cfset var getGroup=0>
		<cfquery name="getGroup" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
    		USERGROUPS.USERGROUPNAME AS NAME,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
    		COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
   			USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
    		ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		WHERE USERGROUPNAME like <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
		<cfif arguments.groupid NEQ 0>
		AND USERGROUPS.USERGROUPID=<cfqueryparam value="#arguments.groupid#">
		</cfif>
		<cfif arguments.status NEQ 0>
		AND USERGROUPS.STATUS=<cfqueryparam value="#arguments.status#">
		</cfif>
		<cfif arguments.parentgroupid neq 0>
		AND USERGROUPS.PARENTUSERGROUPID=<cfqueryparam value="#arguments.parentgroupid#">
		</cfif>
		GROUP BY 
			USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			USERGROUPS.PARENTUSERGROUPID, 
			USERGROUPS.STATUS, 
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION)
		ORDER BY #arguments.SORTLIST#
		</cfquery>
		
		<cfreturn getGroup>
	</cffunction>

	<cffunction name="getGroupFromNameid" access="public" output="false" returntype="query" hint="I get the information on the group for the nameid passed to me, I return (groupid, groupname, parentid, keywords, description, status)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="The nameid for the group">
		<cfset var getGropuFromNameid=0>
		<cfquery name="getGroup" datasource="#contactdsn#">
			SELECT		
				USERGROUPID AS GROUPID,
				USERGROUPNAME AS GROUPNAME,
				PARENTUSERGROUPID AS PARENTID,
				KEYWORDS,
				USERGROUPDESCRIPTION AS DESCRIPTION,
				STATUS
			FROM 
				USERGROUPS
			WHERE NAMEID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#nameid#">
		</cfquery>
		<cfreturn getGroup>
	</cffunction>

	<cffunction name="getRandomGroupContacts" output="false" access="public" returntype="query" hint="Output: nameid as userid, company, description, firstname, lastname">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="true" type="String" hint="groupid of client">
		<cfargument name="numberofcontacts" required="false" type="numeric" default="3" hint="the number of random contacts you want from the group, I default to 3">
		<cfargument name="groupstatus" required="false" type="string" hint="I am the status for the group">
		<cfargument name="contactStatus" required="false" type="string" hint="the Status of the Contacts you are seeking 1 = Active, 0 = NonActive" default="1">
		<cfargument name="imageRequired" required="false" type="string" hint="Whether or not you want to just get random contacts that have an image 1 = true, 0 = false, I default to 0" default="0">
		<cfset var getPeople=0>
		<cfquery name="getPeople" datasource="#arguments.contactdsn#">
			SELECT TOP #arguments.numberofcontacts#
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.URL AS MYURL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.REFERREDBY,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				NAME.LOGOID,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				ADDRESS.INTERSECTION,
				NewID() as Random
			FROM
				NAME, 
				ADDRESS,
				USERGROUPS,
				PEOPLE2USERGROUPS
			WHERE
				NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID 
				AND NAME.STATUS = '#arguments.contactStatus#'
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
				AND USERGROUPS.USERGROUPID = '#arguments.groupid#'
				<cfif isdefined('arguments.groupstatus')>AND USERGROUPS.STATUS=<cfqueryparam value="#arguments.groupstatus#"></cfif>
				<cfif imageRequired neq 0>AND NAME.LOGOID IS NOT NULL</cfif>
			ORDER BY Random
		</cfquery>
		<cfreturn getpeople>
	</cffunction>

	<cffunction name="getGroupContactsWithImages" output="false" access="public" returntype="query" hint="Output: nameid as userid, company, description, firstname, lastname">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="true" type="String" hint="groupid of client">
		<cfset var getPeople=0>
		<cfquery name="getPeople" datasource="#arguments.contactdsn#">
			SELECT
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.LOGOID,
				IMAGE.IMAGEPATH
			FROM
				NAME, 
				ADDRESS,
				USERGROUPS,
				PEOPLE2USERGROUPS,
				IMAGE
			WHERE
				NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID 
				AND NAME.STATUS = <cfqueryparam value="1">
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
				AND USERGROUPS.USERGROUPID = <cfqueryparam value="#arguments.groupid#">
				AND NAME.LOGOID IS NOT NULL
				AND IMAGE.IMAGEID=NAME.LOGOID
		</cfquery>
		<cfreturn getpeople>
	</cffunction>
	
	<cffunction name="getGroupContacts" output="false" access="public" returntype="query" hint="Output: NAME.NAMEID AS USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, MYURL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, MARITALSTATUS, CLIENTUSERID, USERNAME, REFERREDBY, ICQ, AOL, YAHOO, MAC, MSN, JABBER, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, LOGOID, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" default="0" required="false" type="String" hint="groupid of client">
		<cfargument name="groupstatus" required="false" type="string" hint="I am the status for the group">
		<cfargument name="contactStatus" required="false" type="string" hint="the Status of the Contacts you are seeking 1 = Active, 0 = NonActive" default="1">
		<cfargument name="groupname" required="false" type="string" default="0" hint="the name of the group">
		<cfargument name="sortlist" required="false" type="string" hint="I am the list of how you want to sort the results">
		<cfset var getPeople=0>
		<cfquery name="getPeople" datasource="#contactdsn#">
			SELECT 
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.URL AS MYURL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.PASSWORD,
				NAME.REFERREDBY,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				NAME.LOGOID,
				NAME.TITLE,
				NAME.TIMECREATED,
				NAME.LASTLOGIN,
				NAME.LASTUPDATED,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				ADDRESS.INTERSECTION,
				IMAGE.IMAGEPATH
			FROM
				ADDRESS,
				USERGROUPS,
				PEOPLE2USERGROUPS
				, NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
			WHERE
				NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID 
				AND NAME.STATUS = '#arguments.contactStatus#'
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
			<cfif arguments.groupid neq 0>AND USERGROUPS.USERGROUPID = <cfqueryparam value="#groupid#"></cfif>
			<cfif isdefined('groupstatus')>AND USERGROUPS.STATUS=<cfqueryparam value="#groupstatus#"></cfif>
			<cfif arguments.groupname neq 0>AND USERGROUPS.USERGROUPNAME=<cfqueryparam value="#arguments.groupname#"></cfif>
			<cfif isdefined('sortlist')>
			ORDER BY #SORTLIST#
			<cfelse>
			ORDER BY LASTNAME, FIRSTNAME, COMPANY
			</cfif>
		</cfquery>
		<cfreturn getpeople>
	</cffunction>
	
	<cffunction name="checkUserAndPass" output="false" access="public" returnType="struct" hint="I check if username and password are correct">
		<cfargument name="contactdsn" required="true" type="string">
		<cfargument name="username" required="true" type="string">
		<cfargument name="password" required="true" type="string">
		<cfset var qryCheckUser=0>
		<cfset var returnVar=structNew()>
		<cfquery name="qryCheckUser" datasource="#contactdsn#">
			SELECT
				NAMEID
			FROM
				NAME
			WHERE 
				NAME.USERNAME LIKE <cfqueryparam value="#username#"> AND
				NAME.PASSWORD LIKE <cfqueryparam value="#password#">
		</cfquery>
		<cfif qryCheckUser.recordCount GTE 1>
			<cfset returnVar['login'] = 1>
			<cfset returnVar['userid'] = qryCheckUser.nameid>
		<cfelse>
			<cfset returnVar['login'] = 0>
			<cfset returnVar['userid'] = 0>
		</cfif>
		<cfreturn returnVar>
	</cffunction>

	<cffunction name="quickSearchContacts" output="false" access="public" returntype="query" hint="I search for contacts that match what you pass to me. Output: NAME.NAMEID AS USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, MYURL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, MARITALSTATUS, CLIENTUSERID, USERNAME, REFERREDBY, ICQ, AOL, YAHOO, MAC, MSN, JABBER, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, LOGOID, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="criteria" required="false" type="String" hint="generic search data" default="">
		<cfargument name="userid" required="false" type="String" hint="I am the User ID of the contact being searched for" default="">
		<cfargument name="sortlist" required="false" type="string" default="0" hint="I am the list of how you want to sort the results">
		<cfargument name="recordsPerPage" required="false" type="string" hint="Number of Records to return per page" default="-1">
		<cfargument name="pageNumber" required="false" type="string" hint="Current Page Number" default="1">
		<cfargument name="groupid" required="false" type="string" hint="Group to search in" default="0">
		<cfargument name="contactStatus" required="false" type="string" hint="the Status of the Contacts you are seeking 1 = Active, 0 = NonActive" default="1">
		<cfset var start=0>
		<cfset var end=0>
		<cfset var getPeople=0>
		<cfset start = arguments.recordsPerPage * (arguments.pageNumber - 1) + 1>
		<cfset ende = arguments.recordsPerPage * arguments.pageNumber>
		
		<!--- Accept active and non active as well, binod@quantumdelta.com, 20090715 --->
		<cfif arguments.contactStatus EQ 'Active'>
			<cfset arguments.contactStatus=1>
		<cfelseif arguments.contactStatus EQ 'NonActive'>
			<cfset arguments.contactStatus=0>
		<cfelseif arguments.groupid EQ -2>
			<cfset arguments.contactStatus=0>
		</cfif>
		
		<cfquery name="getPeople" datasource="#arguments.contactdsn#">
			SELECT * FROM
			(
			SELECT row_number() OVER (ORDER BY NAME.LASTUPDATED DESC) AS rownum, 
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.MIDDLENAME,
				NAME.LASTNAME,
				NAME.URL AS MYURL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.REFERREDBY,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.TWITTER,
				NAME.LINKEDIN,
				NAME.YOUTUBE,
				NAME.PLAXO,
				NAME.FACEBOOK,
				NAME.MYSPACE,
				NAME.FRIENDFEED,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				NAME.LOGOID,
				NAME.TITLE,
				NAME.TIMECREATED,
				NAME.LASTLOGIN,
				NAME.LASTUPDATED,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				ADDRESS.INTERSECTION,
				IMAGE.IMAGEPATH,
				(
					SELECT COUNT(NAME.NAMEID) 
					
					FROM 
					<cfif arguments.groupid GT 0>USERGROUPS, PEOPLE2USERGROUPS, </cfif>
					NAME 
						LEFT OUTER JOIN IMAGE
							ON NAME.LOGOID=IMAGE.IMAGEID
						LEFT OUTER JOIN ADDRESS 
							ON NAME.NAMEID = ADDRESS.NAMEID
					
					WHERE
						NAME.STATUS = <cfqueryparam value="#arguments.contactStatus#">
						<cfif arguments.groupid EQ -1>
							AND NAME.NAMEID NOT IN (SELECT DISTINCT NAMEID FROM PEOPLE2USERGROUPS)
						<cfelseif arguments.groupid GT 0>
							AND NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID
							AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
							AND USERGROUPS.USERGROUPID = <cfqueryparam value="#arguments.groupid#">
						</cfif>
						<cfif arguments.userid neq "">AND NAME.NAMEID = <cfqueryparam value="#arguments.userid#"></cfif>
						<cfif len(arguments.criteria)>AND  
						(
						<cfloop from="1" to="#listLen(arguments.criteria,' ')#" index="i">
							(
								NAME.FIRSTNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.LASTNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MIDDLENAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.USERNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.HEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.WEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.COMPANY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.DESCRIPTION LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.CITY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.STATE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.ZIP LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.CLIENTUSERID LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.REFERREDBY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.TWITTER LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.LINKEDIN LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.YOUTUBE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.PLAXO LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.FACEBOOK LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MYSPACE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.FRIENDFEED LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
							)
							<cfif i LT listLen(arguments.criteria,' ')> OR</cfif>
						</cfloop>)</cfif>
				) AS NUMOFRECORDS,
				NAME.HASREVIEWS
			FROM 
				ADDRESS
				<cfif arguments.groupid GT 0>,
				USERGROUPS,
				PEOPLE2USERGROUPS</cfif>
				, NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
			WHERE
				NAME.NAMEID = ADDRESS.NAMEID
				AND NAME.STATUS = '#arguments.contactStatus#'
				<cfif arguments.groupid EQ -1>
				AND NAME.NAMEID NOT IN (SELECT DISTINCT NAMEID FROM PEOPLE2USERGROUPS)
				<cfelseif arguments.groupid GT 0>
				AND NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID
				AND PEOPLE2USERGROUPS.USERGROUPID = USERGROUPS.USERGROUPID
				AND USERGROUPS.USERGROUPID = <cfqueryparam value="#arguments.groupid#">
				</cfif>
				<cfif arguments.userid neq "">AND NAME.NAMEID = <cfqueryparam value="#arguments.userid#"></cfif>
				<cfif len(arguments.criteria)>
				AND(
						<cfloop from="1" to="#listLen(arguments.criteria,' ')#" index="i">
							(
								NAME.FIRSTNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.LASTNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MIDDLENAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.USERNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.HEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.WEMAIL LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.COMPANY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.DESCRIPTION LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.CITY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.STATE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR ADDRESS.ZIP LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.CLIENTUSERID LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.REFERREDBY LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.TWITTER LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.LINKEDIN LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.YOUTUBE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.PLAXO LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.FACEBOOK LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.MYSPACE LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
								OR NAME.FRIENDFEED LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
							)
							<cfif i LT listLen(arguments.criteria,' ')> OR </cfif>
						</cfloop>
					)
				</cfif>
			) AS A
			WHERE 
				1 = 1
				<cfif arguments.recordsPerPage GTE 0> AND A.rownum BETWEEN (#start#) AND (#ende#)</cfif>
			</cfquery>
		<cfreturn getpeople>
	</cffunction>

	<cffunction name="lookupContacts" output="false" access="public" returntype="query" hint="I look up contacts">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="firstname" required="false" default="" type="String" hint="first name">
		<cfargument name="lastname" required="false" default="" type="String" hint="last name">
		<cfargument name="housenumber" required="false" default="" type="String" hint="house number">
		<cfargument name="consignornumber" required="false" default="" type="String" hint="Consignor Number">
		<cfset var getPeople=0>
		<cfif Trim(arguments.firstname) NEQ "">
			<cfquery name="getPeople" datasource="#arguments.contactdsn#">
				SELECT TOP 1
					NAME.NAMEID AS USERID,
					NAME.FIRSTNAME,
					NAME.LASTNAME,
					NAME.CLIENTUSERID,
					ADDRESS.ADDRESS1,
					ADDRESS.ADDRESS2,
					ADDRESS.CITY,
					ADDRESS.STATE,
					ADDRESS.ZIP
				FROM NAME,ADDRESS 
				WHERE NAME.STATUS=1 
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND NAME.FIRSTNAME LIKE <cfqueryparam value="%#arguments.firstname#%">
				AND NAME.LASTNAME LIKE <cfqueryparam value="%#arguments.lastname#%">
				AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#arguments.housenumber#%">
				ORDER BY NEWID()
			</cfquery>
		<cfelse>
			<cfquery name="getPeople" datasource="#arguments.contactdsn#">
				SELECT
					NAME.NAMEID AS USERID,
					NAME.FIRSTNAME,
					NAME.LASTNAME,
					NAME.CLIENTUSERID,
					ADDRESS.ADDRESS1,
					ADDRESS.ADDRESS2,
					ADDRESS.CITY,
					ADDRESS.STATE,
					ADDRESS.ZIP
				FROM NAME,ADDRESS 
				WHERE NAME.STATUS=1 
				AND NAME.NAMEID = ADDRESS.NAMEID
				AND NAME.CLIENTUSERID = <cfqueryparam value="#Trim(arguments.consignornumber)#">
			</cfquery>
		</cfif>
		<cfreturn getpeople>
	</cffunction>

	<cffunction name="getNameIdsOfContacts" output="false" access="public" returntype="query" hint="I search for contacts that match what you pass to me. Output: NAMEID">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="address1" default="0" required="false" type="String" hint="address 1 to search">
		<cfargument name="address2" default="0" required="false" type="String" hint="address 2 to search">
		<cfargument name="company" default="0" required="false" type="String" hint="company to search">
		<cfargument name="city" default="0" required="false" type="String" hint="city to search">
		<cfargument name="state" default="0" required="false" type="String" hint="state to search">
		<cfargument name="clientuserid" default="0" required="false" type="String" hint="clientuserid to search">
		<cfargument name="areacode" default="0" required="false" type="String" hint="areacode to search">
		<cfargument name="zip" default="0" required="false" type="String" hint="zip to search">
		<cfargument name="firstname" default="0" required="false" type="String" hint="firstname to search">
		<cfargument name="lastname" default="0" required="false" type="String" hint="lastname to search">
		<cfargument name="middlename" default="0" required="false" type="String" hint="middlename to search">
		<cfargument name="email" default="0" required="false" type="String" hint="email to search">
		<cfargument name="userid" default="0" required="false" type="String" hint="userid to search">
		<cfargument name="groupstatus" default="0" required="false" type="string" hint="I am the status for the group">
		<cfargument name="contactStatus" required="false" type="string" hint="the Status of the Contacts you are seeking 1 = Active, 0 = NonActive" default="1">
		<cfargument name="mypassword" default="0" required="false" type="string" hint="I am the pasword for the contacts">
		<cfargument name="myusername" default="0" required="false" type="string" hint="I am the username for the contacts">
		<cfargument name="grouplist" default="0" required="false" type="string" hint="I am a list of group ids you want me to search">
		<cfargument name="eventid" default="0" required="false" type="string" hint="I am the id of the event">
		<cfargument name="housenumber" default="0" required="false" type="string" hint="The house number you are looking for">
		<cfargument name="registrationStartDate" default="0" required="false" type="string" hint="I am the start of date range when the contact was registered">
		<cfargument name="registrationEndDate" default="0" required="false" type="string" hint="I am the end of date range when the contact was registered">
		<cfargument name="twitter" type="string" required="false" default="0" hint="username of twitter account">
		<cfargument name="linkedin" type="string" required="false" default="0" hint="username of linkedin account">
		<cfargument name="youtube" type="string" required="false" default="0" hint="username of youtube account">
		<cfargument name="plaxo" type="string" required="false" default="0" hint="username of plaxo account">
		<cfargument name="facebook" type="string" required="false" default="0" hint="username of facebook account">
		<cfargument name="myspace" type="string" required="false" default="0" hint="username of myspace account">
		<cfargument name="friendfeed" type="string" required="false" default="0" hint="username of friendfeed account">
		
		<cfset var getcount=0>
		<cfif arguments.contactStatus EQ 'Active'>
			<cfset arguments.contactStatus=1>
		<cfelseif arguments.contactStatus EQ 'NonActive'>
			<cfset arguments.contactStatus=0>
		</cfif>
		
		<cfset notinanygroup=listfindnocase(arguments.grouplist,'-1')>
		<cfif  notinanygroup GT 0>
			<cfset arguments.grouplist=listDeleteAt(arguments.grouplist, notinanygroup)>
		</cfif>
		
		<cfquery name="getcount" datasource="#arguments.contactdsn#">
			SELECT 
				NAME.NAMEID
			FROM
				ADDRESS,
				NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
			WHERE NAME.NAMEID = ADDRESS.NAMEID
			AND NAME.STATUS = <cfqueryparam value='#arguments.contactStatus#'>
			<cfif arguments.eventid NEQ '0'>
				<cfif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
					<cfloop list="#arguments.grouplist#" index="thisgroupid">
						AND NAME.NAMEID IN 
						(
							SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
							AND USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">
						)
					</cfloop>
				<cfelse>
					AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">) 
				</cfif>
			<cfelseif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
				<cfloop list="#arguments.grouplist#" index="thisgroupid">
					AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2USERGROUPS WHERE USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">)
				</cfloop>
			</cfif>
			<cfif notinanygroup GT 0>
				AND NAME.NAMEID NOT IN (SELECT DISTINCT NAMEID FROM PEOPLE2USERGROUPS)
			</cfif>
			<cfif arguments.address1 neq 0>
			AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#arguments.address1#%">
			</cfif>
			<cfif arguments.address2 neq 0>
			AND ADDRESS.ADDRESS2 LIKE <cfqueryparam value="%#arguments.address2#%">
			</cfif>
			<cfif arguments.myusername neq 0>
			AND NAME.USERNAME LIKE <cfqueryparam value="%#arguments.myusername#%">
			</cfif>
			<cfif arguments.mypassword neq 0>
			AND NAME.PASSWORD LIKE <cfqueryparam value="%#arguments.mypassword#%">
			</cfif>
			<cfif arguments.company neq 0>
			AND NAME.COMPANY LIKE <cfqueryparam value="%#arguments.company#%">
			</cfif>
			<cfif arguments.city neq 0>
			AND ADDRESS.CITY LIKE <cfqueryparam value="%#arguments.city#%">
			</cfif>
			<cfif arguments.state neq 0>
			AND ADDRESS.STATE LIKE <cfqueryparam value="%#arguments.state#%">
			</cfif>
			<cfif arguments.areacode neq 0>
			AND (NAME.HPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
			OR NAME.OPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
			OR NAME.MPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
			OR NAME.FPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">)
			</cfif>
			<cfif arguments.zip neq 0>
			AND ADDRESS.ZIP LIKE <cfqueryparam value="%#arguments.zip#%">
			</cfif>
			<cfif arguments.firstname neq 0>
			AND NAME.FIRSTNAME LIKE <cfqueryparam value="%#arguments.firstname#%">
			</cfif>
			<cfif arguments.lastname neq 0>
			AND NAME.LASTNAME LIKE <cfqueryparam value="%#arguments.lastname#%">
			</cfif>
			<cfif arguments.middlename neq 0>
			AND NAME.MIDDLENAME LIKE <cfqueryparam value="%#arguments.middlename#%">
			</cfif>
			<cfif arguments.email neq 0>
			AND (NAME.HEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
			OR NAME.WEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
			OR NAME.OEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">)
			</cfif>
			<cfif arguments.clientuserid neq 0>
			AND NAME.CLIENTUSERID LIKE <cfqueryparam value="%#arguments.CLIENTUSERID#%">
			</cfif>
			<cfif arguments.userid neq 0>
			AND NAME.NAMEID = <cfqueryparam value="#arguments.USERID#">
			</cfif>
			<cfif arguments.registrationStartDate GT 0>
			AND NAME.TIMECREATED >=<cfqueryparam value="#arguments.registrationStartDate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.registrationEndDate GT 0>
			AND NAME.TIMECREATED <=<cfqueryparam value="#arguments.registrationEndDate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.twitter NEQ 0>
			AND NAME.twitter =<cfqueryparam value="#arguments.twitter#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.facebook NEQ 0>
			AND NAME.facebook =<cfqueryparam value="#arguments.facebook#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.linkedin NEQ 0>
			AND NAME.linkedin =<cfqueryparam value="#arguments.linkedin#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.myspace NEQ 0>
			AND NAME.myspace =<cfqueryparam value="#arguments.myspace#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.youtube NEQ 0>
			AND NAME.youtube =<cfqueryparam value="#arguments.youtube#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.plaxo NEQ 0>
			AND NAME.plaxo =<cfqueryparam value="#arguments.plaxo#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.friendfeed NEQ 0>
			AND NAME.friendfeed =<cfqueryparam value="#arguments.friendfeed#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.housenumber neq 0>
				<cfif listcontainsnocase('attributes.housenumber','o' ,'x')>
					AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#%">
				<cfelse>
					AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#">
				</cfif>
			</cfif>
		</cfquery>
		<cfreturn getcount>
	</cffunction>

	<cffunction name="searchContacts" output="false" access="public" returntype="query" hint="I search for contacts that match what you pass to me. Output: USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, MYURL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, MARITALSTATUS, CLIENTUSERID, USERNAME, REFERREDBY, ICQ, AOL, YAHOO, MAC, MSN, JABBER, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, LOGOID, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="address1" default="0" required="false" type="String" hint="address 1 to search">
		<cfargument name="address2" default="0" required="false" type="String" hint="address 2 to search">
		<cfargument name="company" default="0" required="false" type="String" hint="company to search">
		<cfargument name="city" default="0" required="false" type="String" hint="city to search">
		<cfargument name="state" default="0" required="false" type="String" hint="state to search">
		<cfargument name="clientuserid" default="0" required="false" type="String" hint="clientuserid to search">
		<cfargument name="areacode" default="0" required="false" type="String" hint="areacode to search">
		<cfargument name="zip" default="0" required="false" type="String" hint="zip to search">
		<cfargument name="firstname" default="0" required="false" type="String" hint="firstname to search">
		<cfargument name="lastname" default="0" required="false" type="String" hint="lastname to search">
		<cfargument name="middlename" default="0" required="false" type="String" hint="middlename to search">
		<cfargument name="email" default="0" required="false" type="String" hint="email to search">
		<cfargument name="userid" default="0" required="false" type="String" hint="userid to search">
		<cfargument name="groupstatus" default="0" required="false" type="string" hint="I am the status for the group">
		<cfargument name="contactStatus" required="false" type="string" hint="the Status of the Contacts you are seeking 1 = Active, 0 = NonActive" default="1">
		<cfargument name="mypassword" default="0" required="false" type="string" hint="I am the pasword for the contacts">
		<cfargument name="myusername" default="0" required="false" type="string" hint="I am the username for the contacts">
		<cfargument name="grouplist" default="0" required="false" type="string" hint="I am a list of group ids you want me to search">
		<cfargument name="sortlist" default="0" required="false" type="string" hint="I am the list of how you want to sort the results">
		<cfargument name="eventid" default="0" required="false" type="string" hint="I am the id of the event">
		<cfargument name="housenumber" default="0" required="false" type="string" hint="The house number you are looking for">
		<cfargument name="registrationStartDate" default="0" required="false" type="string" hint="I am the start of date range when the contact was registered">
		<cfargument name="registrationEndDate" default="0" required="false" type="string" hint="I am the end of date range when the contact was registered">
		<cfargument name="twitter" type="string" required="false" default="0" hint="username of twitter account">
		<cfargument name="linkedin" type="string" required="false" default="0" hint="username of linkedin account">
		<cfargument name="youtube" type="string" required="false" default="0" hint="username of youtube account">
		<cfargument name="plaxo" type="string" required="false" default="0" hint="username of plaxo account">
		<cfargument name="facebook" type="string" required="false" default="0" hint="username of facebook account">
		<cfargument name="myspace" type="string" required="false" default="0" hint="username of myspace account">
		<cfargument name="friendfeed" type="string" required="false" default="0" hint="username of friendfeed account">
		<cfargument name="pagenumber" type="string" required="false" default="1" hint="page number">
		<cfargument name="numofContacts" type="string" required="false" default="60" hint="number of records to retrieve">
		
		<cfset var getPeople=0>
		<cfset var getcount=0>
		<cfset var startrecord=0>
		<cfset var endrecord=0>
		
		<cfif arguments.pagenumber LT 0>
			<cfset arguments.pagenumber=1>
		<cfelseif NOT isNumeric(arguments.pagenumber)>
			<cfset arguments.pagenumber=1>
		</cfif>
		
		<cfset startrecord=#arguments.numofContacts#*(arguments.pagenumber-1)>
		<cfset endrecord=#arguments.numofContacts#*arguments.pagenumber>
		
		<!--- Accept active and non active as well, binod@quantumdelta.com, 20090715 --->
		<cfif arguments.contactStatus EQ 'Active'>
			<cfset arguments.contactStatus=1>
		<cfelseif arguments.contactStatus EQ 'NonActive'>
			<cfset arguments.contactStatus=0>
		</cfif>
		
		<cfset notinanygroup=listfindnocase(arguments.grouplist,'-1')>
		<cfif  notinanygroup GT 0>
			<cfset arguments.grouplist=listDeleteAt(arguments.grouplist, notinanygroup)>
		</cfif>
		
		<cfquery name="getcount" datasource="#arguments.contactdsn#">
			SELECT 
				COUNT(NAME.NAMEID) AS NUMOFRECORDS
			FROM
				ADDRESS,
				NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
			WHERE
				NAME.NAMEID = ADDRESS.NAMEID
				AND NAME.STATUS = '#arguments.contactStatus#'
				<cfif arguments.eventid NEQ '0'>
					<cfif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
						<cfloop list="#arguments.grouplist#" index="thisgroupid">
							AND NAME.NAMEID IN 
							(
								SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
								AND USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">
							)
						</cfloop>
					<cfelse>
						AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">) 
					</cfif>
				<cfelseif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
					<cfloop list="#arguments.grouplist#" index="thisgroupid">
						AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2USERGROUPS WHERE USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">)
					</cfloop>
				</cfif>
				<cfif notinanygroup GT 0>
					AND NAME.NAMEID NOT IN (SELECT DISTINCT NAMEID FROM PEOPLE2USERGROUPS)
				</cfif>
				<cfif arguments.address1 neq 0>
				AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#arguments.address1#%">
				</cfif>
				<cfif arguments.address2 neq 0>
				AND ADDRESS.ADDRESS2 LIKE <cfqueryparam value="%#arguments.address2#%">
				</cfif>
				<cfif arguments.myusername neq 0>
				AND NAME.USERNAME LIKE <cfqueryparam value="%#arguments.myusername#%">
				</cfif>
				<cfif arguments.mypassword neq 0>
				AND NAME.PASSWORD LIKE <cfqueryparam value="%#arguments.mypassword#%">
				</cfif>
				<cfif arguments.company neq 0>
				AND NAME.COMPANY LIKE <cfqueryparam value="%#arguments.company#%">
				</cfif>
				<cfif arguments.city neq 0>
				AND ADDRESS.CITY LIKE <cfqueryparam value="%#arguments.city#%">
				</cfif>
				<cfif arguments.state neq 0>
				AND ADDRESS.STATE LIKE <cfqueryparam value="%#arguments.state#%">
				</cfif>
				<cfif arguments.areacode neq 0>
				AND (NAME.HPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.OPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.MPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.FPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">)
				</cfif>
				<cfif arguments.zip neq 0>
				AND ADDRESS.ZIP LIKE <cfqueryparam value="%#arguments.zip#%">
				</cfif>
				<cfif arguments.firstname neq 0>
				AND NAME.FIRSTNAME LIKE <cfqueryparam value="%#arguments.firstname#%">
				</cfif>
				<cfif arguments.lastname neq 0>
				AND NAME.LASTNAME LIKE <cfqueryparam value="%#arguments.lastname#%">
				</cfif>
				<cfif arguments.middlename neq 0>
				AND NAME.MIDDLENAME LIKE <cfqueryparam value="%#arguments.middlename#%">
				</cfif>
				<cfif arguments.email neq 0>
				AND (NAME.HEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
				OR NAME.WEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
				OR NAME.OEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">)
				</cfif>
				<cfif arguments.clientuserid neq 0>
				AND NAME.CLIENTUSERID LIKE <cfqueryparam value="%#arguments.CLIENTUSERID#%">
				</cfif>
				<cfif arguments.userid neq 0>
				AND NAME.NAMEID = <cfqueryparam value="#arguments.USERID#">
				</cfif>
				<cfif arguments.registrationStartDate GT 0>
				AND NAME.TIMECREATED >=<cfqueryparam value="#arguments.registrationStartDate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.registrationEndDate GT 0>
				AND NAME.TIMECREATED <=<cfqueryparam value="#arguments.registrationEndDate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.twitter NEQ 0>
				AND NAME.twitter =<cfqueryparam value="#arguments.twitter#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.facebook NEQ 0>
				AND NAME.facebook =<cfqueryparam value="#arguments.facebook#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.linkedin NEQ 0>
				AND NAME.linkedin =<cfqueryparam value="#arguments.linkedin#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.myspace NEQ 0>
				AND NAME.myspace =<cfqueryparam value="#arguments.myspace#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.youtube NEQ 0>
				AND NAME.youtube =<cfqueryparam value="#arguments.youtube#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.plaxo NEQ 0>
				AND NAME.plaxo =<cfqueryparam value="#arguments.plaxo#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.friendfeed NEQ 0>
				AND NAME.friendfeed =<cfqueryparam value="#arguments.friendfeed#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.housenumber neq 0>
					<cfif listcontainsnocase('attributes.housenumber','o' ,'x')>
						AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#%">
					<cfelse>
						AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#">
					</cfif>
				</cfif>
		</cfquery>
		
		<cfquery name="getPeople" datasource="#arguments.contactdsn#">
			SELECT * FROM (
			SELECT 
				NAME.NAMEID AS USERID,
				NAME.COMPANY,
				NAME.DESCRIPTION,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.MIDDLENAME,
				NAME.TITLE,
				NAME.URL AS MYURL,
				NAME.DOB,
				NAME.HPHONE,
				NAME.WPHONE,
				NAME.OPHONE,
				NAME.SPOUSENAME,
				NAME.MPHONE,
				NAME.FPHONE,
				NAME.MARITALSTATUS,
				NAME.CLIENTUSERID,
				NAME.USERNAME,
				NAME.REFERREDBY,
				NAME.ICQ,
				NAME.AOL,
				NAME.YAHOO,
				NAME.MAC,
				NAME.MSN,
				NAME.JABBER,
				NAME.MEMAIL,
				NAME.HEMAIL,
				NAME.WEMAIL,
				NAME.GENDER,
				NAME.OEMAIL,
				NAME.TWITTER,
				NAME.LINKEDIN,
				NAME.YOUTUBE,
				NAME.PLAXO,
				NAME.FACEBOOK,
				NAME.MYSPACE,
				NAME.FRIENDFEED,
				NAME.YEARSINBIZ,
				NAME.BIZEST,
				NAME.CCACCEPTED,
				NAME.SLOGAN,
				NAME.LOGOID,
				NAME.TIMECREATED,
				NAME.LASTLOGIN,
				NAME.LASTUPDATED,
				ADDRESS.ADDRESSID,
				ADDRESS.ADDRESS1,
				ADDRESS.ADDRESS2,
				ADDRESS.CITY,
				ADDRESS.STATE,
				ADDRESS.COUNTRY,
				ADDRESS.ZIP,
				ADDRESS.LAT,
				ADDRESS.LON,
				ADDRESS.INTERSECTION,
				IMAGE.IMAGEPATH,
				#getcount.NUMOFRECORDS# AS NUMOFRECORDS,
				NAME.HASREVIEWS,
				ROW_NUMBER() OVER (ORDER BY NAME.LASTUPDATED DESC) AS ROW
			FROM
				ADDRESS,
				NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
			WHERE
				NAME.NAMEID = ADDRESS.NAMEID
				AND NAME.STATUS = '#arguments.contactStatus#'
				<cfif arguments.eventid NEQ '0'>
					<cfif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
						<cfloop list="#arguments.grouplist#" index="thisgroupid">
							AND NAME.NAMEID IN 
							(
								SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
								AND USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">
							)
						</cfloop>
					<cfelse>
						AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2EVENT WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">) 
					</cfif>
				<cfelseif arguments.grouplist NEQ 0 AND listlen(arguments.grouplist) GT 0>
					<cfloop list="#arguments.grouplist#" index="thisgroupid">
						AND NAME.NAMEID IN (SELECT NAMEID FROM PEOPLE2USERGROUPS WHERE USERGROUPID=<cfqueryparam value="#thisgroupid#" cfsqltype="cf_sql_varchar">)
					</cfloop>
				</cfif>
				<cfif notinanygroup GT 0>
					AND NAME.NAMEID NOT IN (SELECT DISTINCT NAMEID FROM PEOPLE2USERGROUPS)
				</cfif>
				<cfif arguments.address1 neq 0>
				AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#arguments.address1#%">
				</cfif>
				<cfif arguments.address2 neq 0>
				AND ADDRESS.ADDRESS2 LIKE <cfqueryparam value="%#arguments.address2#%">
				</cfif>
				<cfif arguments.myusername neq 0>
				AND NAME.USERNAME LIKE <cfqueryparam value="%#arguments.myusername#%">
				</cfif>
				<cfif arguments.mypassword neq 0>
				AND NAME.PASSWORD LIKE <cfqueryparam value="%#arguments.mypassword#%">
				</cfif>
				<cfif arguments.company neq 0>
				AND NAME.COMPANY LIKE <cfqueryparam value="%#arguments.company#%">
				</cfif>
				<cfif arguments.city neq 0>
				AND ADDRESS.CITY LIKE <cfqueryparam value="%#arguments.city#%">
				</cfif>
				<cfif arguments.state neq 0>
				AND ADDRESS.STATE LIKE <cfqueryparam value="%#arguments.state#%">
				</cfif>
				<cfif arguments.areacode neq 0>
				AND (NAME.HPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.OPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.MPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">
				OR NAME.FPHONE LIKE <cfqueryparam value="%#arguments.areacode#%">)
				</cfif>
				<cfif arguments.zip neq 0>
				AND ADDRESS.ZIP LIKE <cfqueryparam value="%#arguments.zip#%">
				</cfif>
				<cfif arguments.firstname neq 0>
				AND NAME.FIRSTNAME LIKE <cfqueryparam value="%#arguments.firstname#%">
				</cfif>
				<cfif arguments.lastname neq 0>
				AND NAME.LASTNAME LIKE <cfqueryparam value="%#arguments.lastname#%">
				</cfif>
				<cfif arguments.middlename neq 0>
				AND NAME.MIDDLENAME LIKE <cfqueryparam value="%#arguments.middlename#%">
				</cfif>
				<cfif arguments.email neq 0>
				AND (NAME.HEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
				OR NAME.WEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">
				OR NAME.OEMAIL LIKE <cfqueryparam value="%#arguments.EMAIL#%">)
				</cfif>
				<cfif arguments.clientuserid neq 0>
				AND NAME.CLIENTUSERID LIKE <cfqueryparam value="%#arguments.CLIENTUSERID#%">
				</cfif>
				<cfif arguments.userid neq 0>
				AND NAME.NAMEID = <cfqueryparam value="#arguments.USERID#">
				</cfif>
				<cfif arguments.registrationStartDate GT 0>
				AND NAME.TIMECREATED >=<cfqueryparam value="#arguments.registrationStartDate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.registrationEndDate GT 0>
				AND NAME.TIMECREATED <=<cfqueryparam value="#arguments.registrationEndDate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.twitter NEQ 0>
				AND NAME.twitter =<cfqueryparam value="#arguments.twitter#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.facebook NEQ 0>
				AND NAME.facebook =<cfqueryparam value="#arguments.facebook#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.linkedin NEQ 0>
				AND NAME.linkedin =<cfqueryparam value="#arguments.linkedin#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.myspace NEQ 0>
				AND NAME.myspace =<cfqueryparam value="#arguments.myspace#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.youtube NEQ 0>
				AND NAME.youtube =<cfqueryparam value="#arguments.youtube#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.plaxo NEQ 0>
				AND NAME.plaxo =<cfqueryparam value="#arguments.plaxo#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.friendfeed NEQ 0>
				AND NAME.friendfeed =<cfqueryparam value="#arguments.friendfeed#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.housenumber neq 0>
					<cfif listcontainsnocase('attributes.housenumber','o' ,'x')>
						AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#%">
					<cfelse>
						AND ADDRESS.ADDRESS1 LIKE <cfqueryparam value="%#trim(ATTRIBUTES.HOUSENUMBER)#">
					</cfif>
				</cfif>
			) ALLCONTACTS
			WHERE ROW > <cfqueryparam value="#startrecord#">
			AND ROW <= <cfqueryparam value="#endrecord#">
		</cfquery>
		<cfreturn getpeople>
	</cffunction>
	
	<cffunction name="jbfLegacyExport" output="false" access="public" returntype="string" hint="I export contacts in legacy format">
		<cfargument name="nameids" required="true" type="string" hint="list of the ids for the contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource to use to lookup the contacts">
		<cfsavecontent variable="myCSV">
		<cfoutput><table>
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email Address </th>
				<th>Clientuserid</th>
				<th>Address1</th>
				<th>Address2</th>
				<th>City</th>
				<th>State</th>
				<th>Zip</th>
				<th>Referred By</th> 
				<th>Home Phone</th>
				<th>Cell Phone</th>
				<th>Work Phone</th>
			</tr>
				<cfinvoke method="getcontactinfo" contactdsn="#arguments.contactdsn#" nameid="#arguments.nameids#" returnvariable="myContactInfo">
				<cfloop query="mycontactinfo">
				<!--- invoke get contact info --->
				<tr>
					<td>#myContactInfo.firstname#</td>
					<td>#myContactInfo.LastName#</td>
					<td>#myContactInfo.hemail#</td>
					<td>#myContactInfo.clientuserid#</td>
					<td>#myContactInfo.address1#</td>
					<td>#myContactInfo.address2#</td>
					<td>#myContactInfo.city#</td>
					<td>#myContactInfo.state#</td>
					<td>#myContactInfo.zip#</td>
					<td>#myContactInfo.referredby#</td>
					<td>#myContactInfo.hphone#</td>
					<td>#myContactInfo.mphone#</td>
					<td>#myContactInfo.wphone#</td>
				</tr>
				</cfloop>
			</table></cfoutput>
		</cfsavecontent>
		<cfreturn myCSV>
	</cffunction> 
	
	<cffunction name="makeCSV" output="false" access="public" returntype="string" hint="I make the guts of a table export of the contacts you pass to me.">
		<cfargument name="nameids" required="true" type="string" hint="list of the ids for the contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource to use to lookup the contacts">
		<cfargument name="clientuserid" default="0" required="false" type="string">
		<cfargument name="username" default="0" required="false" type="string">
		<cfargument name="thePassword" default="0" required="false" type="string">
		<cfargument name="lastname" default="0" required="false" type="string">
		<cfargument name="firstname" default="0" required="false" type="string">
		<cfargument name="company" default="0" required="false" type="string">
		<cfargument name="title" default="0" required="false" type="string">
		<cfargument name="dob" default="0" required="false" type="string">
		<cfargument name="wphone" default="0" required="false" type="string">
		<cfargument name="hphone" default="0" required="false" type="string">
		<cfargument name="mphone" default="0" required="false" type="string">
		<cfargument name="hemail" default="0" required="false" type="string">
		<cfargument name="wemail" default="0" required="false" type="string"> 
		<cfargument name="memail" default="0" required="false" type="string"> 
		<cfargument name="oemail" default="0" required="false" type="string"> 
		<cfargument name="lat" default="0" required="false" type="string">
		<cfargument name="lon" default="0" required="false" type="string">
		<cfargument name="intersection" default="0" required="false" type="string">
		<cfargument name="address1" default="0" required="false" type="string">
		<cfargument name="address2" default="0" required="false" type="string">
		<cfargument name="city" default="0" required="false" type="string">
		<cfargument name="state" default="0" required="false" type="string">
		<cfargument name="zip" default="0" required="false" type="string">
		<cfargument name="country" default="0" required="false" type="string">
		<cfargument name="referredby" default="0" required="false" type="string"> 
		<cfargument name="gender" default="0" required="false" type="string"> 
		<cfargument name="maritalstatus" default="0" required="false" type="string"> 
		<cfargument name="spousename" default="0" required="false" type="string"> 
		<cfargument name="icq" default="0" required="false" type="string"> 
		<cfargument name="aol" default="0" required="false" type="string"> 
		<cfargument name="yahoo" default="0" required="false" type="string"> 
		<cfargument name="jabber" default="0" required="false" type="string"> 
		<cfargument name="mac" default="0" required="false" type="string"> 
		<cfargument name="msn" default="0" required="false" type="string"> 
		<cfargument name="myurl" default="0" required="false" type="string"> 
		<cfargument name="description" default="0" required="false" type="string"> 
		<cfargument name="YEARSINBIZ" default="0" required="false" type="string">
		<cfargument name="BIZEST" default="0" required="false" type="string">
		<cfargument name="CCACCEPTED" default="0" required="false" type="string">
		<cfargument name="SLOGAN" default="0" required="false" type="string">
		<cfargument name="LOGOID" default="0" required="false" type="string">
		<cfargument name="TIMECREATED" default="0" required="false" type="string">
		<cfargument name="LASTLOGIN" default="0" required="false" type="string">
		<cfargument name="LASTUPDATED" default="0" required="false" type="string">
		<cfargument name="TWITTER" default="0" required="false" type="string">
		<cfargument name="LINKEDIN" default="0" required="false" type="string">
		<cfargument name="YOUTUBE" default="0" required="false" type="string">
		<cfargument name="PLAXO" default="0" required="false" type="string">
		<cfargument name="MYSPACE" default="0" required="false" type="string">
		<cfargument name="FRIENDFEED" default="0" required="false" type="string">
		<cfargument name="FACEBOOK" type="string" required="false" default="0">
		<cfargument name="imagepath" default="0" required="false" type="string">
		<cfargument name="groups" default="0" required="false" type="string">
		<cfset var myCSV = 0>
		<cfset var mygrouplist = 0>
		<cfset var myContactInfo = 0>
		<!--- invoke get contact info --->
		<cfsavecontent variable="myCSV">
		<cfoutput><table>
			<tr>
				<th>UID</th>
				<cfif arguments.clientuserid neq 0><th>Client User ID</th></cfif>
				<cfif arguments.username neq 0><th>Username</th></cfif>
				<cfif arguments.thePassword neq 0><th>Password</th></cfif>
				<cfif arguments.lastname neq 0><th>Last Name</th></cfif>
				<cfif arguments.firstname neq 0><th>First Name</th></cfif>
				<cfif arguments.company neq 0><th>Company</th></cfif>
				<cfif arguments.title neq 0><th>Title</th></cfif>
				<cfif arguments.dob neq 0><th>DOB</th></cfif>
				<cfif arguments.wphone neq 0><th>Work Phone</th></cfif>
				<cfif arguments.hphone neq 0><th>Home Phone</th></cfif>
				<cfif arguments.mphone neq 0><th>Mobil Phone</th></cfif>
				<cfif arguments.hemail neq 0><th>Home Email </th></cfif>
				<cfif arguments.wemail neq 0><th>Work Email</th></cfif> 
				<cfif arguments.memail neq 0><th>Mobil Email</th></cfif> 
				<cfif arguments.oemail neq 0><th>Other Email</th></cfif> 
				<cfif arguments.lat neq 0><th>LAT</th></cfif>
				<cfif arguments.lon neq 0><th>LON</th></cfif>
				<cfif arguments.address1 neq 0><th>Address 1</th></cfif>
				<cfif arguments.address2 neq 0><th>Address 2</th></cfif>
				<cfif arguments.city neq 0 ><th>City</th></cfif>
				<cfif arguments.state neq 0><th>State</th></cfif>
				<cfif arguments.country neq 0><th>Country</th></cfif>
				<cfif arguments.zip neq 0><th>Zip</th></cfif>
				<cfif arguments.referredby neq 0><th>Referred By</th></cfif> 
				<cfif arguments.gender neq 0><th>Gender</th></cfif> 
				<cfif arguments.maritalstatus neq 0><th>Marital Status</th></cfif> 
				<cfif arguments.spousename neq 0><th>Spouse Name</th></cfif> 
				<cfif arguments.icq neq 0><th>ICQ</th></cfif> 
				<cfif arguments.aol neq 0><th>AOL</th></cfif> 
				<cfif arguments.yahoo neq 0><th>Yahoo</th></cfif> 
				<cfif arguments.jabber neq 0><th>Jabber</th></cfif> 
				<cfif arguments.mac neq 0><th>.Mac</th></cfif> 
				<cfif arguments.msn neq 0><th>MSN</th></cfif> 
				<cfif arguments.myurl neq 0><th>Website</th></cfif> 
				<cfif arguments.description neq 0><th>Description</th></cfif> 
				<cfif arguments.YEARSINBIZ neq 0><th>Years in Biz</th></cfif>
				<cfif arguments.BIZEST neq 0><th>Biz Established</th></cfif>
				<cfif arguments.CCACCEPTED neq 0><th>Credit Cards Accepted</th></cfif>
				<cfif arguments.SLOGAN neq 0><th>Slogan</th></cfif>
				<cfif arguments.LOGOID neq 0><th>Logoid</th></cfif>
				<cfif arguments.TIMECREATED neq 0><th>Time Created</th></cfif>
				<cfif arguments.LASTLOGIN neq 0><th>Last Login</th></cfif>
				<cfif arguments.LASTUPDATED neq 0><th>Last Updated</th></cfif>
				<cfif arguments.TWITTER neq 0><th>Twitter</th></cfif>
				<cfif arguments.LINKEDIN neq 0><th>LinkedIn</th></cfif>
				<cfif arguments.YOUTUBE neq 0><th>You Tube</th></cfif>
				<cfif arguments.PLAXO neq 0><th>Plaxo</th></cfif>
				<cfif arguments.MYSPACE neq 0><th>My Space</th></cfif>
				<cfif arguments.FRIENDFEED neq 0><th>Friend Feed</th></cfif>
				<cfif arguments.FACEBOOK neq 0><th>Facebook</th></cfif>
				<cfif arguments.imagepath neq 0><th>Imagepath</th></cfif>
				<cfif arguments.groups neq 0><th>Groups</th></cfif>
			</tr>
				<cfinvoke method="getcontactinfo" contactdsn="#arguments.contactdsn#" nameid="#arguments.nameids#" returnvariable="myContactInfo">
				<cfloop query="mycontactinfo">
				<!--- invoke get contact info --->
				<tr>
					<td>#myContactInfo.userid#</td>
					<cfif arguments.clientuserid neq 0><td>#myContactInfo.clientuserid#</td></cfif>
					<cfif arguments.username neq 0><td>#myContactInfo.username#</td></cfif>
					<cfif arguments.thePassword neq 0><td>#myContactInfo.password#</td></cfif>
					<cfif arguments.lastname neq 0><td>#myContactInfo.LastName#</td></cfif>
					<cfif arguments.firstname neq 0><td>#myContactInfo.firstname#</td></cfif>
					<cfif arguments.company neq 0><td>#myContactInfo.Company#</td></cfif>
					<cfif arguments.title neq 0><td>#myContactInfo.title#</td></cfif>
					<cfif arguments.dob neq 0><td>#myContactInfo.DOB#</td></cfif>
					<cfif arguments.wphone neq 0><td>#myContactInfo.wphone#</td></cfif>
					<cfif arguments.hphone neq 0><td>#myContactInfo.hphone#</td></cfif>
					<cfif arguments.mphone neq 0><td>#myContactInfo.mphone#</td></cfif>
					<cfif arguments.hemail neq 0><td>#myContactInfo.hemail#</td></cfif>
					<cfif arguments.wemail neq 0><td>#myContactInfo.wemail#</td></cfif> 
					<cfif arguments.memail neq 0><td>#myContactInfo.memail#</td></cfif> 
					<cfif arguments.oemail neq 0><td>#myContactInfo.oemail#</td></cfif> 
					<cfif arguments.lat neq 0><td>#myContactInfo.LAT#</td></cfif>
					<cfif arguments.lon neq 0><td>#myContactInfo.LON#</td></cfif>
					<cfif arguments.address1 neq 0><td>#myContactInfo.address1#</td></cfif>
					<cfif arguments.address2 neq 0><td>#myContactInfo.address2#</td></cfif>
					<cfif arguments.city neq 0 ><td>#myContactInfo.city#</td></cfif>
					<cfif arguments.state neq 0><td>#myContactInfo.state#</td></cfif>
					<cfif arguments.country neq 0><td>#myContactInfo.country#</td></cfif>
					<cfif arguments.zip neq 0><td>#myContactInfo.zip#</td></cfif>
					<cfif arguments.referredby neq 0><td>#myContactInfo.referredby#</td></cfif> 
					<cfif arguments.gender neq 0><td>#myContactInfo.gender#</td></cfif> 
					<cfif arguments.maritalstatus neq 0><td>#myContactInfo.maritalstatus#</td></cfif> 
					<cfif arguments.spousename neq 0><td>#myContactInfo.spousename#</td></cfif> 
					<cfif arguments.icq neq 0><td>#myContactInfo.ICQ#</td></cfif> 
					<cfif arguments.aol neq 0><td>#myContactInfo.aol#</td></cfif> 
					<cfif arguments.yahoo neq 0><td>#myContactInfo.yahoo#</td></cfif> 
					<cfif arguments.jabber neq 0><td>#myContactInfo.jabber#</td></cfif> 
					<cfif arguments.mac neq 0><td>#myContactInfo.mac#</td></cfif> 
					<cfif arguments.msn neq 0><td>#myContactInfo.msn#</td></cfif> 
					<cfif arguments.myurl neq 0><td>#myContactInfo.myurl#</td></cfif> 
					<cfif arguments.description neq 0><td>#myContactInfo.description#</td></cfif> 
					<cfif arguments.YEARSINBIZ neq 0><td>#myContactInfo.YEARSINBIZ#</td></cfif>
					<cfif arguments.BIZEST neq 0><td>#myContactInfo.BIZEST#</td></cfif>
					<cfif arguments.CCACCEPTED neq 0><td>#myContactInfo.CCACCEPTED#</td></cfif>
					<cfif arguments.SLOGAN neq 0><td>#myContactInfo.SLOGAN#</td></cfif>
					<cfif arguments.LOGOID neq 0><td>#myContactInfo.LOGOID#</td></cfif>
					<cfif arguments.TIMECREATED neq 0><td>#mytime.convertdate(myContactInfo.TIMECREATED,"yyyy-mm-dd")#</td></cfif>
					<cfif arguments.LASTLOGIN neq 0><td>#myContactInfo.LASTLOGIN#</td></cfif>
					<cfif arguments.LASTUPDATED neq 0><td>#mytime.convertdate(myContactInfo.LASTUPDATED,"yyyy-mm-dd")#</td></cfif>
					<cfif arguments.TWITTER neq 0><td>#myContactInfo.Twitter#</td></cfif>
					<cfif arguments.LINKEDIN neq 0><td>#myContactInfo.LinkedIn#</td></cfif>
					<cfif arguments.YOUTUBE neq 0><td>#myContactInfo.YouTube#</td></cfif>
					<cfif arguments.PLAXO neq 0><td>#myContactInfo.Plaxo#</td></cfif>
					<cfif arguments.MYSPACE neq 0><td>#myContactInfo.MySpace#</td></cfif>
					<cfif arguments.FRIENDFEED neq 0><td>#myContactInfo.FriendFeed#</td></cfif>
					<cfif arguments.FACEBOOK neq 0><th>#myConatactInfo.FACEBOOK#</th></cfif>
					<cfif arguments.imagepath neq 0><td>#myContactInfo.imagepath#</td></cfif>
					<cfif arguments.groups neq 0>
						<!--- invoke the groups --->
						<cfinvoke method="getContactGroups" contactdsn="#arguments.contactdsn#" nameid="#myContactInfo.userid#" returnvariable="myGroups">
						<cfset mygrouplist = "">
						<cfloop query="myGroups">
							<cfset mygrouplist = listappend(#mygrouplist#, '#myGroups.name#')>
						</cfloop>
						<td>#mygrouplist#</td>
					</cfif>
				</tr>
				</cfloop>
			</table></cfoutput>
		</cfsavecontent>
		<cfreturn myCSV>
	</cffunction>
	
	<cffunction name="makeVCARD" output="false" access="public" returntype="string" hint="I make a vcard for contacts you pass to me.">
		<cfargument name="nameids" required="true" type="string" hint="list of the ids for the contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource to use to lookup the contacts">
		<cfargument name="clientuserid" default="0" required="false" type="string">
		<cfargument name="lastname" default="0" required="false" type="string">
		<cfargument name="firstname" default="0" required="false" type="string">
		<cfargument name="company" default="0" required="false" type="string">
		<cfargument name="title" default="0" required="false" type="string">
		<cfargument name="dob" default="0" required="false" type="string">
		<cfargument name="wphone" default="0" required="false" type="string">
		<cfargument name="hphone" default="0" required="false" type="string">
		<cfargument name="mphone" default="0" required="false" type="string">
		<cfargument name="hemail" default="0" required="false" type="string">
		<cfargument name="wemail" default="0" required="false" type="string"> 
		<cfargument name="memail" default="0" required="false" type="string"> 
		<cfargument name="oemail" default="0" required="false" type="string"> 
		<cfargument name="lat" default="0" required="false" type="string">
		<cfargument name="lon" default="0" required="false" type="string">
		<cfargument name="intersection" default="0" required="false" type="string">
		<cfargument name="address1" default="0" required="false" type="string">
		<cfargument name="address2" default="0" required="false" type="string">
		<cfargument name="city" default="0" required="false" type="string">
		<cfargument name="state" default="0" required="false" type="string">
		<cfargument name="zip" default="0" required="false" type="string">
		<cfargument name="referredby" default="0" required="false" type="string"> 
		<cfargument name="gender" default="0" required="false" type="string"> 
		<cfargument name="maritalstatus" default="0" required="false" type="string"> 
		<cfargument name="spousename" default="0" required="false" type="string"> 
		<cfargument name="icq" default="0" required="false" type="string"> 
		<cfargument name="aol" default="0" required="false" type="string"> 
		<cfargument name="yahoo" default="0" required="false" type="string"> 
		<cfargument name="jabber" default="0" required="false" type="string"> 
		<cfargument name="mac" default="0" required="false" type="string"> 
		<cfargument name="msn" default="0" required="false" type="string"> 
		<cfargument name="url" default="0" required="false" type="string"> 
		<cfargument name="description" default="0" required="false" type="string"> 
		<cfargument name="YEARSINBIZ" default="0" required="false" type="string">
		<cfargument name="BIZEST" default="0" required="false" type="string">
		<cfargument name="CCACCEPTED" default="0" required="false" type="string">
		<cfargument name="SLOGAN" default="0" required="false" type="string">
		<cfargument name="LOGOID" default="0" required="false" type="string">
		<cfargument name="TIMECREATED" default="0" required="false" type="string">
		<cfargument name="LASTLOGIN" default="0" required="false" type="string">
		<cfargument name="LASTUPDATED" default="0" required="false" type="string">
		<cfargument name="imagepath" default="0" required="false" type="string">
		<cfargument name="groups" default="0" required="false" type="string">
		<cfset var myVcard = 0>
		<cfset var myContactInfo = 0>
		<cfset var NewLine = Chr(13) & Chr(10)>
		<cfset var glist=ArrayNew(1)>
		<!--- invoke get contact info --->
		<cfinvoke method="getcontactinfo" contactdsn="#arguments.contactdsn#" nameid="#arguments.nameids#" returnvariable="myContactInfo">
		<cfif arguments.groups NEQ 0>
			<cfloop query="mycontactinfo">
				<cfinvoke method="getContactGroups" contactdsn="#arguments.contactdsn#" nameid="#userid#" returnvariable="myGroups">
				<cfset glist[currentRow]=valueList(myGroups.name)>
			</cfloop>
		</cfif>
		
<cfsavecontent variable="myVcard"><cfoutput><cfloop query="mycontactinfo">BEGIN:VCARD
VERSION:3.0
ContactID:#myContactInfo.userid#
N:<cfif arguments.lastname neq "" and arguments.firstname neq "">#myContactInfo.lastname#;#myContactInfo.firstname#<cfelse>#myContactInfo.company#</cfif>
FN:<cfif lastname neq "" and firstname neq "">#myContactInfo.firstname# #myContactInfo.lastname#<cfelse>#myContactInfo.company#</cfif>
ADR;type=WORK;type=pref:;;#myContactInfo.address1#;#myContactInfo.city#;#myContactInfo.state#;#myContactInfo.zip#;
<cfif arguments.company neq 0>ORG:#myContactInfo.company#; #newline#</cfif><cfif arguments.wemail neq 0>EMAIL;type=WORK:#myContactInfo.wemail# #newline#</cfif><cfif arguments.hemail neq 0>EMAIL;type=HOME:#myContactInfo.hemail# #newline#</cfif><cfif arguments.wphone neq 0>TEL;type=WORK;type=pref:#myContactInfo.wphone# #newline#</cfif><cfif arguments.mphone neq 0>TEL;type=CELL:#myContactInfo.mphone# #newline#</cfif><cfif arguments.hphone neq 0>TEL;type=HOME:#myContactInfo.hphone# #newline#</cfif><cfif arguments.url neq 0>URL;type=WORK:#myContactInfo.url# #newline#</cfif><cfif arguments.aol neq 0>X-AIM;type=WORK;type=pref:#myContactInfo.aol# #newline#</cfif><cfif arguments.yahoo neq 0>X-YAHOO;type=WORK;type=pref:#myContactInfo.yahoo# #newline#</cfif><cfif arguments.icq neq 0>X-ICQ;type=WORK;type=pref:#myContactInfo.icq# #newline#</cfif><cfif arguments.clientuserid neq 0>Clientuserid:#myContactInfo.clientuserid# #newline#</cfif><cfif arguments.groups neq 0>CATEGORIES:#glist[currentRow]# #newline#</cfif>END:VCARD
</cfloop></cfoutput></cfsavecontent>
<cfreturn myVcard>
	</cffunction>

	<cffunction name="makeRDF" output="false" access="public" returntype="string" hint="I make the guts of a table export of the contacts you pass to me.">
		<cfargument name="nameids" required="true" type="string" hint="list of the ids for the contacts">
		<cfargument name="contactdsn" required="true" type="string" hint="datasource to use to lookup the contacts">
		<cfargument name="clientuserid" default="0" required="false" type="string">
		<cfargument name="lastname" default="0" required="false" type="string">
		<cfargument name="firstname" default="0" required="false" type="string">
		<cfargument name="company" default="0" required="false" type="string">
		<cfargument name="title" default="0" required="false" type="string">
		<cfargument name="dob" default="0" required="false" type="string">
		<cfargument name="wphone" default="0" required="false" type="string">
		<cfargument name="hphone" default="0" required="false" type="string">
		<cfargument name="mphone" default="0" required="false" type="string">
		<cfargument name="hemail" default="0" required="false" type="string">
		<cfargument name="wemail" default="0" required="false" type="string"> 
		<cfargument name="memail" default="0" required="false" type="string"> 
		<cfargument name="oemail" default="0" required="false" type="string"> 
		<cfargument name="lat" default="0" required="false" type="string">
		<cfargument name="lon" default="0" required="false" type="string">
		<cfargument name="intersection" default="0" required="false" type="string">
		<cfargument name="address1" default="0" required="false" type="string">
		<cfargument name="address2" default="0" required="false" type="string">
		<cfargument name="city" default="0" required="false" type="string">
		<cfargument name="state" default="0" required="false" type="string">
		<cfargument name="zip" default="0" required="false" type="string">
		<cfargument name="referredby" default="0" required="false" type="string"> 
		<cfargument name="gender" default="0" required="false" type="string"> 
		<cfargument name="maritalstatus" default="0" required="false" type="string"> 
		<cfargument name="spousename" default="0" required="false" type="string"> 
		<cfargument name="icq" default="0" required="false" type="string"> 
		<cfargument name="aol" default="0" required="false" type="string"> 
		<cfargument name="yahoo" default="0" required="false" type="string"> 
		<cfargument name="jabber" default="0" required="false" type="string"> 
		<cfargument name="mac" default="0" required="false" type="string"> 
		<cfargument name="msn" default="0" required="false" type="string"> 
		<cfargument name="myurl" default="0" required="false" type="string"> 
		<cfargument name="description" default="0" required="false" type="string"> 
		<cfargument name="YEARSINBIZ" default="0" required="false" type="string">
		<cfargument name="BIZEST" default="0" required="false" type="string">
		<cfargument name="CCACCEPTED" default="0" required="false" type="string">
		<cfargument name="SLOGAN" default="0" required="false" type="string">
		<cfargument name="LOGOID" default="0" required="false" type="string">
		<cfargument name="TIMECREATED" default="0" required="false" type="string">
		<cfargument name="LASTLOGIN" default="0" required="false" type="string">
		<cfargument name="LASTUPDATED" default="0" required="false" type="string">
		<cfargument name="imagepath" default="0" required="false" type="string">
		<cfargument name="groups" default="0" required="false" type="string">
		<cfset var myRDF = 0>
		<cfset var mygrouplist = 0>
		<cfset var myContactInfo = 0>
		
		<cfsavecontent variable="myRDF">
			<cfoutput>
				<cfinvoke method="getcontactinfo" contactdsn="#arguments.contactdsn#" nameid="#arguments.nameids#" returnvariable="myContactInfo">
					<cfloop query="myContactInfo">
						<rdf:RDF xmlns:rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns##"  xmlns:vCard = "http://www.w3.org/2001/vcard-rdf/3.0##">
						<vCard:FN><cfif arguments.lastname neq 0 and arguments.firstname neq 0>#myContactInfo.lastname#;#myContactInfo.firstname#<cfelse>#myContactInfo.company#</cfif></vCard:FN>
					      <vCard:UID>#nameid#</vCard:UID>
						  <vCard:N rdf:parseType="Resource">
					        <cfif arguments.lastname neq 0><vCard:Family> #myContactInfo.lastname# </vCard:Family></cfif>
					        <cfif arguments.firstname neq 0><vCard:Given>  #myContactInfo.firstname# </vCard:Given></cfif>
					      </vCard:N>
					      <cfif arguments.dob neq 0><vCard:BDAY> #myContactInfo.dob# </vCard:BDAY></cfif>
						 <cfif arguments.wphone neq 0>
						  <vCard:TEL rdf:parseType="Resource">
					        <rdf:value> #myContactInfo.wphone# </rdf:value>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##work"/>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##voice"/>
					      </vCard:TEL>
						  </cfif>	  
						  <cfif arguments.hphone neq 0>
						  <vCard:TEL rdf:parseType="Resource">
					        <rdf:value> #myContactInfo.hphone# </rdf:value>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##home"/>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##voice"/>
					      </vCard:TEL>
						  </cfif>
						  <cfif arguments.mphone neq 0>
						  <vCard:TEL rdf:parseType="Resource">
					        <rdf:value> #myContactInfo.mphone# </rdf:value>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##cell"/>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##voice"/>
					      </vCard:TEL>
						  </cfif>
					     <cfif arguments.hemail neq 0>
						  <vCard:EMAIL rdf:parseType="Resource">
					        <rdf:value> #myContactInfo.hemail# </rdf:value>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##home"/>
					      </vCard:EMAIL>
						  </cfif>
						  <cfif arguments.wemail neq 0>
						  <vCard:EMAIL rdf:parseType="Resource">
					        <rdf:value> #myContactInfo.wemail# </rdf:value>
					        <rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0##work"/>
					      </vCard:EMAIL>
						  </cfif>
						  <vCard:GEO>
						  	<cfif arguments.lat neq 0><vCard:LAT> #myContactInfo.lat#</vCard:LAT></cfif>
							<cfif arguments.lon neq 0><vCard:LON> #myContactInfo.lon#</vCard:LON></cfif>
						  </vCard:GEO>
					      <vCard:ADR rdf:parseType="Resource">
					        <cfif arguments.address1 neq 0>
							<vCard:Street>  #myContactInfo.address1#<cfif arguments.address2 neq 0>, #myContactInfo.address2#</cfif></vCard:Street>
							</cfif>
					        <cfif arguments.city neq 0><vCard:Locality>#myContactInfo.city#</vCard:Locality></cfif>
							<cfif arguments.state neq 0><vCard:Region>#myContactInfo.state#</vCard:Locality></cfif>
					        <cfif arguments.zip neq 0><vCard:Pcode>#myContactInfo.zip# </vCard:Pcode></cfif>
					      </vCard:ADR>					
						<cfif arguments.groups neq 0>
							<!--- invoke the groups --->
							<cfinvoke method="getContactGroups" contactdsn="#arguments.contactdsn#" nameid="#mycontactinfo.userid#" returnvariable="myGroups">
							<cfset mygrouplist = "">
							<cfloop query="myGroups">
								<cfset mygrouplist = listappend(#mygrouplist#, '#myGroups.name#')>
							</cfloop>
							 <vCard:GROUP rdf:parseType="Resource">#mygrouplist#</vCard:GROUP>
						</cfif>
					</rdf:RDF>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfreturn myRDF>
	</cffunction>

	<cffunction name="updateGroup" access="public" returntype="void" output="false" hint="I update the group information passed to me.">
		<cfargument name="contactdsn" type="String" required="true" hint="Datasource">
		<cfargument name="groupid" type="string" required="true" hint="the id for the group that I need to update">
		<cfargument name="usergroupname" type="String" required="true" hint="Group name">
		<cfargument name="parentusergroupid" type="String" required="false" hint="Parent group id">
		<cfargument name="usergroupdescription" type="String" required="false" hint="Short description of the group">
		<cfargument name="keywords" type="String" required="false" hint="keywords for the group">
		<cfargument name="nameid" type="String" required="false" hint="nameid of the creator">
		<cfargument name="status" type="String" required="false" hint="status of the group">
		<cfset var addgroup=0>
		<cfquery name="addgroup" datasource="#arguments.contactdsn#">
			UPDATE USERGROUPS
			SET USERGROUPNAME=<cfqueryparam value="#arguments.usergroupname#">
				<cfif isdefined('arguments.parentusergroupid')>, PARENTUSERGROUPID=<cfqueryparam value="#arguments.parentusergroupid#"></cfif>
				<cfif isdefined('arguments.usergroupdescription')>, USERGROUPDESCRIPTION=<cfqueryparam value="#arguments.usergroupdescription#"></cfif>
				<cfif isdefined('arguments.nameid')>, NAMEID=<cfqueryparam value="#arguments.nameid#"></cfif>
				<cfif isdefined('arguments.status')>, STATUS=<cfqueryparam value="#arguments.STATUS#"></cfif>
				<cfif isdefined('arguments.keywords')>, KEYWORDS=<cfqueryparam value="#arguments.keywords#"></cfif>
			WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="addContactAsGroup" access="public" hint="Add contacts as group" returntype="String">
		<cfargument name="contactdsn" type="String" required="true" hint="Datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfset var getName=0>
		<cfset var groupname=0>
		<cfset var groupid=0>
		<cfquery name="getName" datasource="#contactdsn#">
			SELECT				
				COMPANY,	
				FIRSTNAME,
				LASTNAME
			FROM 
				NAME
			WHERE
				NAMEID = <cfqueryparam value="#nameid#"> 
		</cfquery>
		
		<!--- Generate Group name --->
		 <cfif len(getName.firstname)>
			<cfset groupname = #getName.firstname# & " " & #getName.lastname#>
		<cfelseif len(getName.company)>
			<cfset groupname = getName.company>
		<cfelse>
			<cfset groupname = "not defined">
		</cfif>
		
		<cfinvoke method="addgroup" returnvariable="groupid">
			<cfinvokeargument  name="contactdsn" value="#contactdsn#">
			<cfinvokeargument name="usergroupname" value="#groupname#">
			<cfinvokeargument name="nameid" value="#nameid#">
		</cfinvoke>
		<cfreturn groupid>
	</cffunction>
	
	<cffunction name="removeContactFromGroup" access="public" output="false" returntype="void" hint="I remove the contact from the group passed to me">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="nameid" type="String" default="0" required="false" hint="name id">
		<cfargument name="groupid" type="String" required="true" hint="group id">
		<cfset var deletepeople2usergroups=0>
		<cfquery name="deletepeople2usergroups" datasource="#arguments.contactdsn#">
		delete 
		from
		people2usergroups
		where 1=1
		<cfif arguments.nameid neq "0">and nameid = <cfqueryparam value="#arguments.nameid#"></cfif>
		and usergroupid=<cfqueryparam value="#arguments.groupid#">
		</cfquery>
	</cffunction>

	<cffunction name="removeMembersFromGroup" access="public" output="false" returntype="void" hint="I remove all of the members (contacts) from the group passed to me">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="groupid" type="String" required="true" hint="group id">
		<cfset var deletepeople2usergroups=0>
		<cfquery name="deletepeople2usergroups" datasource="#contactdsn#">
		DELETE 
		FROM
		PEOPLE2USERGROUPS
		WHERE USERGROUPID=<cfqueryparam value="#groupid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteGroup" access="public" output="false" returntype="void" hint="I delete a usergroup">
		<cfargument name="contactdsn" type="string" required="true" hint="datasource name">
		<cfargument name="groupid" type="string" required="true" hint="group id">
		<cfset var deletethisgroup=0>
		<cfinvoke method="removeMembersFromGroup" argumentcollection="#arguments#">
		<cfquery name="deletethisgroup" datasource="#arguments.contactdsn#">
			DELETE
			FROM
			USERGROUPS
			WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="getContactInfo" output="false" access="public" returntype="query" hint="I get all the info for the contact and return a query recordset (USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, URL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, MARITALSTATUS, CLIENTUSERID, USERNAME, REFERREDBY, MYURL, ICQ, AOL, YAHOO, MAC, MSN, JABBER, IMAGEPATH, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, LOGOID, STATUS, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfset getName=0>
		<cfquery name="getName" datasource="#contactdsn#">
		SELECT		
			NAME.NAMEID AS USERID,
			NAME.COMPANY,
			NAME.DESCRIPTION,
			NAME.FIRSTNAME,
			NAME.MIDDLENAME,
			NAME.LASTNAME,
			NAME.URL,
			NAME.DOB,
			NAME.HPHONE,
			NAME.WPHONE,
			NAME.OPHONE,
			NAME.SPOUSENAME,
			NAME.MPHONE,
			NAME.FPHONE,
			NAME.MARITALSTATUS,
			NAME.CLIENTUSERID,
			NAME.USERNAME,
			NAME.PASSWORD,
			NAME.REFERREDBY,
			NAME.URL AS MYURL,
			NAME.ICQ,
			NAME.AOL,
			NAME.YAHOO,
			NAME.MAC,
			NAME.MSN,
			NAME.LASTUPDATED,
			NAME.JABBER,
			NAME.MEMAIL,
			NAME.HEMAIL,
			NAME.WEMAIL,
			NAME.GENDER,
			NAME.OEMAIL,
			NAME.TWITTER,
			NAME.LINKEDIN,
			NAME.YOUTUBE,
			NAME.PLAXO,
			NAME.FACEBOOK,
			NAME.MYSPACE,
			NAME.FRIENDFEED,
			NAME.YEARSINBIZ,
			NAME.BIZEST,
			NAME.CCACCEPTED,
			NAME.SLOGAN,
			NAME.LOGOID,
			NAME.STATUS,
			NAME.TITLE,
			NAME.TIMECREATED,
			NAME.LASTLOGIN,
			NAME.LASTUPDATED,
			ADDRESS.ADDRESSID,
			ADDRESS.ADDRESS1,
			ADDRESS.ADDRESS2,
			ADDRESS.CITY,
			ADDRESS.STATE,
			ADDRESS.COUNTRY,
			ADDRESS.ZIP,
			ADDRESS.LAT,
			ADDRESS.LON,
			ADDRESS.INTERSECTION, 
			IMAGE.IMAGEPATH
		FROM 
			ADDRESS
			, NAME LEFT OUTER JOIN IMAGE ON NAME.LOGOID=IMAGE.IMAGEID
		WHERE NAME.NAMEID = ADDRESS.NAMEID
		AND NAME.NAMEID IN(#arguments.nameid#)
	</cfquery>
	<cfreturn getName>
	</cffunction>
	
	<cffunction name="getStatusContacts" output="false" access="public" returntype="query" hint="I get all the info for the contacts that match the status you pass to me and return a query recordset (USERID, COMPANY, DESCRIPTION, FIRSTNAME, LASTNAME, URL, DOB, HPHONE, WPHONE, OPHONE, SPOUSENAME, MPHONE, FPHONE, MARITALSTATUS, CLIENTUSERID, USERNAME, REFERREDBY, MYURL, ICQ, AOL, YAHOO, MAC, MSN, JABBER, MEMAIL, HEMAIL, WEMAIL, GENDER, OEMAIL, YEARSINBIZ, BIZEST, CCACCEPTED, SLOGAN, LOGOID, STATUS, ADDRESSID, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, ZIP, LAT, LON, INTERSECTION,TWITTER,LINKEDIN,YOUTUBE,PLAXO,FACEBOOK,MYSPACE,FRIENDFEED)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfargument name="status" type="String" required="true" hint="status of the contacts you want to recieve">
		<cfset var getName=0>
		<cfquery name="getName" datasource="#contactdsn#">
		SELECT		
			NAME.NAMEID AS USERID,
			NAME.COMPANY,
			NAME.DESCRIPTION,
			NAME.FIRSTNAME,
			NAME.LASTNAME,
			NAME.URL,
			NAME.DOB,
			NAME.HPHONE,
			NAME.WPHONE,
			NAME.OPHONE,
			NAME.SPOUSENAME,
			NAME.MPHONE,
			NAME.FPHONE,
			NAME.MARITALSTATUS,
			NAME.CLIENTUSERID,
			NAME.USERNAME,
			NAME.REFERREDBY,
			NAME.URL AS MYURL,
			NAME.ICQ,
			NAME.AOL,
			NAME.YAHOO,
			NAME.MAC,
			NAME.MSN,
			NAME.JABBER,
			NAME.MEMAIL,
			NAME.HEMAIL,
			NAME.WEMAIL,
			NAME.GENDER,
			NAME.OEMAIL,
			NAME.TWITTER,
			NAME.LINKEDIN,
			NAME.YOUTUBE,
			NAME.PLAXO,
			NAME.FACEBOOK,
			NAME.MYSPACE,
			NAME.FRIENDFEED,
			NAME.YEARSINBIZ,
			NAME.BIZEST,
			NAME.CCACCEPTED,
			NAME.SLOGAN,
			NAME.LOGOID,
			NAME.STATUS,
			ADDRESS.ADDRESSID,
			ADDRESS.ADDRESS1,
			ADDRESS.ADDRESS2,
			ADDRESS.CITY,
			ADDRESS.STATE,
			ADDRESS.COUNTRY,
			ADDRESS.ZIP,
			ADDRESS.LAT,
			ADDRESS.LON,
			ADDRESS.INTERSECTION
		FROM 
			NAME,
			ADDRESS
		WHERE NAME.NAMEID = ADDRESS.NAMEID
		AND NAME.STATUS = <cfqueryparam value="#STATUS#">
	</cfquery>
	<cfreturn getName>
	</cffunction>
	
	<cffunction name="updateContactStatus" returntype="void" output="false" access="public" hint="I update the status of the contact passed to me">
		<cfargument name="contactdsn" type="string" required="true" hint="datasource for the update">
		<cfargument name="status" type="boolean" required="true" hint="1 = Active, 0 = NonActive">
		<cfargument name="nameid" type="String" required="true" hint="id for the contact we are updating">
		<cfset var updateNameStatus=0>
		<cfquery name="updateNameStatus" datasource="#contactdsn#">
			UPDATE NAME SET 
				STATUS=<cfqueryparam value="#arguments.status#">,
				LASTUPDATED=<cfqueryparam value="#mytime.createtimedate()#">
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#">
		</cfquery>
	</cffunction>

	<cffunction name="getLogo" returntype="string" output="false" access="public" hint="I logo imageid for the nameid passed to me">
		<cfargument name="contactdsn" type="string" required="true" hint="datasource for the update">
		<cfargument name="nameid" type="String" required="true" hint="id for the contact we are updating">
		<cfset var getMyLogo=0>
		<cfquery name="getMyLogo" datasource="#contactdsn#">
		SELECT IMAGE.IMAGEPATH,
		NAME.LOGOID
		FROM IMAGE, NAME
		WHERE NAME.LOGOID = IMAGE.IMAGEID
		AND NAME.NAMEID=<cfqueryparam value="#nameid#">
		</cfquery>
		<cfreturn getMyLogo.logoid> 
	</cffunction>

	<cffunction name="removeContactFromAllGroups" access="public" output="false" returntype="void" hint="I remove the contact from all of the groups they are a part of">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="nameid" type="String" required="true" hint="name id">
		<cfset var deletepeople2usergroups=0>
		<cfquery name="deletepeople2usergroups" datasource="#contactdsn#">
		delete 
		from
		people2usergroups
		where nameid=<cfqueryparam value="#nameid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="updateLogo" returntype="void" output="false" access="public" hint="I update the logo of the contact passed to me">
		<cfargument name="contactdsn" type="string" required="true" hint="datasource for the update">
		<cfargument name="logoid" type="string" required="true" hint="imageid for the logo of this contact">
		<cfargument name="nameid" type="String" required="true" hint="id for the contact we are updating">
		<cfset var updateNameStatus=0>
		<cfquery name="updateNameStatus" datasource="#contactdsn#">
		UPDATE NAME
		SET LOGOID=<cfqueryparam value="#logoid#">
		WHERE NAMEID=<cfqueryparam value="#nameid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteContact" access="public" output="false" hint="I completely remove the contact from every table in the database">
		<cfargument name="contactdsn" type ="String" required="true" hint="Database name">
		<cfargument name="nameid" type="String" required="true" hint="name id">
		<cfargument name="altnamedb" type="String" required="false" hint="Alternate database" default="0">
		<cfset var deletehau2people=0>
		<cfset var deleteNAME2HAU=0>
		<cfset var myColumnExist=0>
		<cfset var deletePEOPLE2PEOPLE1=0>
		<cfset var deletePEOPLE2PEOPLE2=0>
		<cfset var deletehoursofoperation=0>
		<cfset var deletecomment=0>
		<cfset var deletepeople2usergroups=0>
		<cfset var deletepeople2site=0>
		<cfset var deleteaddress=0>
		<cfset var deletename=0>
		<cfobject component="qdDataMgr" name="qdDataMgr">
		<cftransaction>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","NAMEUDF","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehau2people" datasource="#contactdsn#">
			delete 
			from
			NAMEUDF
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","SURVEY","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deleteSURVEY" datasource="#contactdsn#">
			delete 
			from
			SURVEY
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","PEOPLESURVEYED","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="getmyresults" datasource="#contactdsn#">
			select peoplesurveyedid from peoplesurveyed
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
			<cfloop query="getmyresults">
				<cfquery name="deleteanswers" datasource="#contactdsn#">
				delete from answers
				where peoplesurveyedid = '#peoplesurveyedid#'
				</cfquery>
				<cfquery name="deleteResults" datasource="#contactdsn#">
				delete from results
				where peoplesurveyedid = '#peoplesurveyedid#'
				</cfquery>
			</cfloop>
			<cfquery name="deletePEOPLESURVEYED" datasource="#contactdsn#">
			delete 
			from
			PEOPLESURVEYED
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","SUBSCRIPTION","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deleteSUBSCRIPTION" datasource="#contactdsn#">
			delete 
			from
			SUBSCRIPTION
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","SUBSCRIBED","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deleteSUBSCRIBED" datasource="#contactdsn#">
			delete 
			from
			SUBSCRIBED
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","CARTOWNER","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="DELETECARTOWNER" datasource="#contactdsn#">
			delete 
			from
			CARTOWNER
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","HAU2PEOPLE","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehau2people" datasource="#contactdsn#">
			delete 
			from
			HAU2PEOPLE
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","NAME2HEARDABOUTUS","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deleteNAME2HAU" datasource="#contactdsn#">
			delete 
			from
			NAME2HEARDABOUTUS
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","PEOPLE2PEOPLE","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletePEOPLE2PEOPLE1" datasource="#contactdsn#">
			delete 
			from
			PEOPLE2PEOPLE
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","PEOPLE2PEOPLE","secondarynameid")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletePEOPLE2PEOPLE2" datasource="#contactdsn#">
			delete 
			from
			PEOPLE2PEOPLE
			where secondarynameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","HOURSOFOPERATION","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehoursofoperation" datasource="#contactdsn#">
			delete 
			from
			HOURSOFOPERATION
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","comment","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletecomment" datasource="#contactdsn#">
			delete 
			from
			comment
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","people2usergroups","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletepeople2usergroups" datasource="#contactdsn#">
			delete 
			from
			people2usergroups
			where nameid=<cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","USERGROUPS","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletepeople2usergroups" datasource="#contactdsn#">
			delete 
			from
			usergroups
			where nameid=<cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
	
		<cfif  contactdsn eq "deltasystem">
			<cfquery name="deletepeople2site" datasource="#contactdsn#">
			delete from people2site where nameid =  '#nameid#'
			</cfquery>
		<cfelse>
			<cfquery name="deletepeople2event" datasource="#contactdsn#">
			delete 
			from
			people2event
			where nameid = '#nameid#'
			</cfquery>
		</cfif>
		
		<cfquery name="deleteaddress" datasource="#contactdsn#">
		delete 
		from
		address
		where nameid = '#nameid#'
		</cfquery>
		
		<cfquery name="deletename" datasource="#contactdsn#">
		delete 
		from
		name
		where nameid = '#nameid#'
		</cfquery>
		</cftransaction>
		
		<cfif altnamedb neq 0>
		<cfset contactdsn = "#altnamedb#">
		
		<cftransaction>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","NAMEUDF","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehau2people" datasource="#contactdsn#">
			delete 
			from
			NAMEUDF
			where nameid = '#nameid#'
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","HAU2PEOPLE","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehau2people" datasource="#contactdsn#">
			delete 
			from
			HAU2PEOPLE
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","NAME2HEARDABOUTUS","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deleteNAME2HAU" datasource="#contactdsn#">
			delete 
			from
			NAME2HEARDABOUTUS
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","PEOPLE2PEOPLE","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletePEOPLE2PEOPLE1" datasource="#contactdsn#">
			delete 
			from
			PEOPLE2PEOPLE
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","PEOPLE2PEOPLE","secondarynameid")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletePEOPLE2PEOPLE2" datasource="#contactdsn#">
			delete 
			from
			PEOPLE2PEOPLE
			where secondarynameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","HOURSOFOPERATION","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletehoursofoperation" datasource="#contactdsn#">
			delete 
			from
			HOURSOFOPERATION
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","comment","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletecomment" datasource="#contactdsn#">
			delete 
			from
			comment
			where nameid = <cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
		<cfset myColumnExist = #qdDataMgr.columnExists("#contactdsn#","people2usergroups","NAMEID")#>
		<cfif myColumnExist eq true>
			<cfquery name="deletepeople2usergroups" datasource="#contactdsn#">
			delete 
			from
			people2usergroups
			where nameid=<cfqueryparam value="#nameid#">
			</cfquery>
		</cfif>
	
		<cfif  contactdsn eq "deltasystem">
			<cfquery name="deletepeople2site" datasource="#contactdsn#">
			delete from people2site where nameid =  '#nameid#'
			</cfquery>
		<cfelse>
			<cfquery name="deletepeople2event" datasource="#contactdsn#">
			delete 
			from
			people2event
			where nameid = '#nameid#'
			</cfquery>
		</cfif>
		
		<cfquery name="deleteaddress" datasource="#contactdsn#">
		delete 
		from
		address
		where nameid = '#nameid#'
		</cfquery>
		
		<cfquery name="deletename" datasource="#contactdsn#">
		delete 
		from
		name
		where nameid = '#nameid#'
		</cfquery>
		</cftransaction>
		</cfif>
	</cffunction>

	<cffunction name="deleteGroupMembers" access="public" returntype="void" output="false" hint="I delete every member of the group passed to me">
		<cfargument name="contactdsn" required="true" type="String" hint="Datasource">
		<cfargument name="groupid" required="true" type="String" hint="Groupid">
		<cfset var getPeople=0>
		<cfset var mynameid=0>
		<cfflush interval="5">
		<!--- <cfinclude template="../groups/queries/getPeople.cfm"> --->
		<cfinvoke method="getGroupContacts" returnvariable="getPeople">
			<cfinvokeargument name="contactdsn" value="#contactdsn#">
			<cfinvokeargument name="groupid" value="#groupid#">
		</cfinvoke>
		<ul>
			<cfoutput query="getPeople">
				<cfset mynameid = nameid>
				<!--- <cfinclude template="/addressbook/queries/delete.cfm"> --->
				<cfinvoke method="deleteContact">
					<cfinvokeargument name="contactdsn" value="#contactdsn#">
					<cfinvokeargument name="nameid" value="#mynameid#">
				</cfinvoke>
			
				<li>#mynameid# (#getPeople.currentRow#) removed</li>
			</cfoutput>
		</ul>
	</cffunction>
	
	<cffunction name="addContactToEvent" access="public" returntype="void">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="name id">
		<cfargument name="EVENTID" Type="String" required="true" hint="event id">
		<cfargument name="USERGROUPID" type ="String" required="true" hint="group id f">
		<cfargument name="eventprice" type="String" required="false" hint="price of the event">
		<cfset var checkpeopleusergroupEVENT=0>
		<cfset var qryaddpeople2event=0>
		<cfset var checkpeopleusergroup=0>
		<cfset var qryddpeople2group=0>
		<cfquery name="checkpeopleusergroupEVENT" datasource="#contactdsn#">
			SELECT
				USERGROUPID
			FROM
				PEOPLE2EVENT
			WHERE USERGROUPID = <cfqueryparam value="#USERGROUPID#">
			AND NAMEID = <cfqueryparam value="#nameid#">
			AND EVENTID = <cfqueryparam value="#EVENTID#">
		</cfquery>
		<cfif checkpeopleusergroupEVENT.recordcount lt 1>
			<cfquery name="qryaddpeople2event" datasource="#contactdsn#">
			INSERT INTO PEOPLE2EVENT
			(
				NAMEID,
				EVENTID, 
				<cfif isdefined('eventprice')>
				PRICE,
				</cfif>
				USERGROUPID
			)
			VALUES
			(
				<cfqueryparam value="#nameid#">,
				<cfqueryparam value="#EVENTID#">,
				<cfif isdefined('eventprice')>
					<cfqueryparam value="#Evaluate('eventprice')#">,
				</cfif>
				<cfqueryparam value="#USERGROUPID#">)
			</cfquery>
		</cfif>
		
		<!--- check to see if the person is already in this usergroup --->
		<cfquery name="checkpeopleusergroup" datasource="#contactdsn#">
		SELECT
			USERGROUPID
		FROM
			PEOPLE2USERGROUPS
		WHERE USERGROUPID = <cfqueryparam value="#USERGROUPID#">
		AND NAMEID = <cfqueryparam value="#nameid#">
		</cfquery>
		<cfif checkpeopleusergroup.recordcount lt 1>
			<!--- go ahead and add them to the usergroup --->
			<cfquery name="qryddpeople2group" datasource="#contactdsn#">
			INSERT INTO PEOPLE2USERGROUPS
			(
				NAMEID,
				USERGROUPID
			)
			VALUES
				(<cfqueryparam value="#nameid#">,
				<cfqueryparam value="#USERGROUPID#">)
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getContactGroups" access="public" returntype="query" output="false" hint="I get all of the contacts groups and return a query  (groupid, name, description, parentgroupid, keywords, status)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfargument name="status" type="String" required="false" hint="status">
		<cfargument name="groupname" type="string" required="false" default="0" hint="The name of a particular group you are seeking, I use the like and wildcards to find a group like the string you pass me">
		<cfset var getmygroups=0>
		<cfquery name="getmygroups" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
			USERGROUPS.USERGROUPNAME AS NAME,
			USERGROUPS.USERGROUPDESCRIPTION AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID,
			USERGROUPS.KEYWORDS,
			USERGROUPS.STATUS
		FROM 
			USERGROUPS,
			PEOPLE2USERGROUPS
		WHERE PEOPLE2USERGROUPS.NAMEID = <cfqueryparam value="#nameid#">
		AND USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		<cfif isdefined('status')>AND USERGROUPS.STATUS=<cfqueryparam value="#status#"></cfif>
		<cfif arguments.groupname neq 0>AND USERGROUPS.USERGROUPNAME LIKE '%#ARGUMENTS.GROUPNAME#%'</cfif>
		</cfquery>
		<cfreturn getmygroups>
	</cffunction>
	
	<cffunction name="getAllGroups" access="public" returntype="query" output="false" hint="I get all of thegroups and return a query (groupid, name, description, parentgroupid, keywords, status, groupcount)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="status" required="false" type="string" hint="status of the groups you want">
		<cfargument name="sortlist" required="false" default="USERGROUPS.USERGROUPNAME" type="string" hint="list of columns you want to sort by">
		<cfset var getmygroups=0>
		<cfquery name="getmygroups" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
    		USERGROUPS.USERGROUPNAME AS NAME,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
    		COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
   			USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
    		ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		<cfif isdefined('status')>
		WHERE STATUS=<cfqueryparam value="#status#">
		</cfif>
		GROUP BY 
			USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			USERGROUPS.PARENTUSERGROUPID, 
			USERGROUPS.STATUS, 
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION)
		ORDER BY #SORTLIST#
		</cfquery>
		<cfreturn getmygroups>
	</cffunction>
	
	<cffunction name="getGroupChildren" access="public" returntype="query" output="false" hint="I get all of the child groups for the groupid passed to me and return a query  (groupid, name, description, parentgroupid, keywords, status, groupcount)">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="parentgroupid" type="String" required="true" hint="groupid">
		<cfargument name="status" required="false" type="string" hint="status of the groups you want">
		<cfargument name="sortlist" required="false" default="USERGROUPS.USERGROUPNAME" type="string" hint="list of columns you want to sort by">
		<cfset var getmygroups=0>
		<cfquery name="getmygroups" datasource="#contactdsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
    		USERGROUPS.USERGROUPNAME AS NAME,
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION) AS DESCRIPTION,
			USERGROUPS.PARENTUSERGROUPID AS PARENTID,
    		COUNT(PEOPLE2USERGROUPS.NAMEID) AS GROUPCOUNT,
			USERGROUPS.STATUS
		FROM
   			USERGROUPS LEFT OUTER JOIN PEOPLE2USERGROUPS
    		ON USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		WHERE 1=1
		<cfif isdefined('parentgroupid')>
		AND USERGROUPS.PARENTUSERGROUPID=<cfqueryparam value="#parentgroupid#">
		</cfif>
		<cfif isdefined('status')>
		AND STATUS=<cfqueryparam value="#status#">
		</cfif>
		GROUP BY 
			USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			USERGROUPS.PARENTUSERGROUPID, 
			USERGROUPS.STATUS, 
			convert(VARCHAR(1000),USERGROUPS.USERGROUPDESCRIPTION)
		ORDER BY #SORTLIST#
		</cfquery>
		<cfreturn getmygroups>
	</cffunction>
	
	<cffunction name="addHoursOfOperation" access="public" returntype="void" output="false" hint="I add the hours of operation for the contact passed to me">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfargument name="dayofweek" type="String" required="true" hint="The day of the week represented by a number 1 to 7, 1 being Monday">
		<cfargument name="opentime" type="string" required="true" hint="time start in 24 hour format (i.e. 0800 is 8:00 AM, 1400 is 2:00 PM)">
		<cfargument name="closetime" type="String" required="true" hint="time end in 24 hour format (i.e. 0800 is 8:00 AM, 1400 is 2:00 PM)">
		<cfargument name="openclosed" type="String" required="true" hint="open=1, closed=0">
		<cfset var addHoursOperation=0>
		<cfquery name="addHoursOperation" datasource="#contactdsn#">
		INSERT INTO HOURSOFOPERATION
			(NAMEID,
			DAYOFWEEK,
			OPENTIME,
			CLOSETIME,
			OPENCLOSED
			)
		VALUES
			(<cfqueryparam value="#nameid#">, 
			<cfqueryparam value="#dayofweek#">, 
			<cfqueryparam value="#opentime#">,
			<cfqueryparam value="#closetime#">,
			<cfqueryparam value="#openclosed#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="updateHoursOfOperation" access="public" returntype="void" output="false" hint="I update the hours of operation for the contact passed to me">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="nameid">
		<cfargument name="dayofweek" type="String" required="true" hint="The day of the week represented by a number 1 to 7, 1 being Monday">
		<cfargument name="opentime" type="string" required="true" hint="time start in 24 hour format (i.e. 0800 is 8:00 AM, 1400 is 2:00 PM)">
		<cfargument name="closetime" type="String" required="true" hint="time end in 24 hour format (i.e. 0800 is 8:00 AM, 1400 is 2:00 PM)">
		<cfargument name="openclosed" type="String" required="true" hint="open=1, closed=0">
		<cfset var thisdayhours=0>
		<cfset var updateHoursOperation=0>
		<cfinvoke method="getHoursOfOperation" contactdsn="#contactdsn#" nameid="#nameid#" dayofweek="#dayofweek#" returnvariable="thisdayhours">
		<cfif thisdayhours.recordcount gt 0>
			<cfquery name="updateHoursOperation" datasource="#contactdsn#">
				UPDATE HOURSOFOPERATION
				SET OPENTIME=<cfqueryparam value="#opentime#">,
					CLOSETIME=<cfqueryparam value="#closetime#">,
					OPENCLOSED=<cfqueryparam value="#openclosed#">
				WHERE NAMEID=<cfqueryparam value="#nameid#">
				AND DAYOFWEEK=<cfqueryparam value="#dayofweek#">
			</cfquery>
		<cfelse>
			<cfinvoke method="addHoursOfOperation" contactdsn="#contactdsn#" nameid="#nameid#" dayofweek="#dayofweek#" opentime="#opentime#" openclosed="#openclosed#" closetime="#closetime#">
		</cfif>
	</cffunction>
	
	<cffunction name="getHoursOfOperation" access="public" returntype="query" hint="I get the hours of operation for the contact passed to me">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">
		<cfargument name="nameid" type="String" required="true" hint="name id">
		<cfargument name="dayofweek" type="String" required="false">
		<cfset var getHoursofOperation=0>
		<cfquery name="getHoursofOperation" datasource="#contactdsn#">
			SELECT
				NAMEID,
				OPENCLOSED,
				OPENTIME,
				CLOSETIME,
				DAYOFWEEK
			FROM HOURSOFOPERATION
			WHERE NAMEID = <cfqueryparam value="#nameid#">
			<cfif isdefined('dayofweek')>
			AND DAYOFWEEK=<cfqueryparam value="#dayofweek#">
			</cfif>
		</cfquery>
		<cfreturn getHoursofOperation>
	</cffunction>
	
	<cffunction name="addContact" access="public" hint="Add contact to address book" returntype="numeric" output="false">
		<cfargument name="contactdsn" required="true" type="String" hint="datasource">	
		<cfargument name="firstname" type="String" required="false" default="" hint="First Name">
		<cfargument name="lastname" type="String" required="false" default="" hint="Last Name">
		<cfargument name="address1" type="String" required="false" default="" hint="Address">
		<cfargument name="address2" required="false" type="String" default="" hint="Address second line such as apartment or suite number">
		<cfargument name="city" type="String" required="false" default="" hint="city">
		<cfargument name="state" type="String" required="false" default="" hint="State">
		<cfargument name="zip" type="String" required="false" default="" hint="Zip">	
		<cfargument name="country" required="false" type="String" default="US" hint="Country">
		<cfargument name="intersection" required="false" type="String" default="0" hint="Nearest Street intersection">
		<cfargument name="title" type="String" required="false" default="0" hint="title">
		<cfargument name="middlename" type="String" required="false" default="0" hint="Middle Name">
		<cfargument name="myusername" type="String" required="false" default="0" hint="Username">
		<cfargument name="mypassword" type="String" required="false" default="0" hint="password">
		<cfargument name="wemail" type="String" required="false" default="0" hint="Work Email"> 
		<cfargument name="hemail" type="String" required="false" default="0" hint="Home Email">
		<cfargument name="memail" type="String" required="false" default="0" hint="Mobile Email">
		<cfargument name="oemail" type="String" required="false" default="0" hint="Other Email">
		<cfargument name="hphone" type="String" required="false" default="0" hint="Home phone">  
		<cfargument name="wphone" type="String" required="false" default="0" hint="Work phone"> 
		<cfargument name="mphone" type="String" required="false" default="0" hint="Mobile phone"> 
		<cfargument name="fphone" type="String" required="false" default="0" hint="Fax phone number">
		<cfargument name="ophone" type="String" required="false" default="0" hint="Other phone"> 
		<cfargument name="gender" type="String" required="false" default="3" hint="Gender of User, 0=female, 1=male, 3=n/a or unknown">
		<cfargument name="maritalstatus" type="String" required="false" default="0" hint="Marital Status, 0=Single, 1=Married">
		<cfargument name="referredby" type="String" required="false" default="0" hint="Reffered by">
		<cfargument name="spousename" type="String" required="false" default="0" hint="Spouse name">
		<cfargument name="myurl" type="String" required="false" default="0" hint="Home page">
		<cfargument name="icq" type="String" required="false" default="0" hint="ICQ IM number">
		<cfargument name="aol" type="String" required="false" default="0" hint="AOL IM">
		<cfargument name="yahoo" type="String" required="false" default="0" hint="YAHOO IM">
		<cfargument name="msn" type="String" required="false" default="0" hint="MSN IM">
		<cfargument name="mac" type="String" required="false" default="0" hint=".mac account name">
		<cfargument name="jabber" type="String" required="false" default="0" hint="JABBER">
		<cfargument name="status" type="String" required="false" default="1" hint="1 = Active, 0 = NonActive">
		<cfargument name="gmail" type="String" required="false" default="0" hint="DOB">
		<cfargument name="description" type="String" required="false" default="Contact description goes here" hint="Description or bio for the contact">
		<cfargument name="dob" type="String" required="false" default="0" hint="Date of birth">
		<cfargument name="yearsinbiz" type="String" required="false" default="0" hint="Years in Business">
		<cfargument name="bizest" type="String" required="false" default="0" hint="Business Established date">
		<cfargument name="ccaccepted" type="String" required="false" default="0" hint="Credit Cards Accepted">
		<cfargument name="slogan" type="String" required="false" default="0" hint="Business Slogan">
		<cfargument name="headnameid" type="String" required="false" default="0" hint="nameid of the Head of Household for this contact, rarely if ever used">
		<cfargument name="clientuserid" type="String" required="false" default="0" hint="Client user id, number for admin to manually assign to user for thier own records"> 
		<cfargument name="company" type="String" required="false" default="0" hint="Company name">
		<cfargument name="locationname" type="String" required ="false" default="0" hint="Name of a location, usually used when adding a location(contact) when adding an event">
		<cfargument name="altnamedb" type="String" required="false" default="0" hint="Alternate database">
		<cfargument name="usemissingnumbers" type="boolean" required="false" default="false" hint="used with clientuserid">
		<cfargument name="twitter" type="string" required="false" default="0" hint="username of twitter account">
		<cfargument name="linkedin" type="string" required="false" default="0" hint="username of linkedin account">
		<cfargument name="youtube" type="string" required="false" default="0" hint="username of youtube account">
		<cfargument name="plaxo" type="string" required="false" default="0" hint="username of plaxo account">
		<cfargument name="facebook" type="string" required="false" default="0" hint="username of facebook account">
		<cfargument name="myspace" type="string" required="false" default="0" hint="username of myspace account">
		<cfargument name="friendfeed" type="string" required="false" default="0" hint="username of friendfeed account">
		<cfset var randomnum = RandRange(1,9999)>
		<cfset var qryaddname=0>
		<cfset var qryaddname2=0>
		<cfset var newaddress=structNew()>
		<cfset var qryconvertaddress=0>
		<cfset var qryconvertaddress2=0>
		
		<!--- written for error correction --->
		<cfif arguments.status EQ "public">
			<cfset arguments.status = 1>
		</cfif>
		<!--- Add Person --->
		<cfif arguments.myusername EQ "0">
			<cfif arguments.wemail NEQ "0">
				<cfset myusername = arguments.wemail>
			<cfelse>
				<cfif arguments.hemail NeQ "0">
					<cfset myusername = arguments.hemail>
				<cfelse>
					<cfif arguments.memail NeQ "0">
						<cfset myusername = arguments.memail>
					<cfelse>
						<cfif arguments.oemail NEQ "0">
							<cfset myusername = arguments.oemail>
						<cfelse>
							<cfset myusername = "#arguments.lastname##randomnum##arguments.firstname#">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif arguments.mypassword EQ "0"><cfset arguments.mypassword = "#arguments.lastname##arguments.firstname##randomnum#"></cfif>
	
		<cfif arguments.clientuserid EQ "0" OR Trim(arguments.clientuserid) EQ "">
			<cfset arguments.clientuserid=getNewclientuserid(#arguments.contactdsn#)>
		</cfif>
		
		<cfquery name="qryaddname" datasource="#contactdsn#">
		INSERT INTO NAME
		(
			USERNAME, 
			FIRSTNAME, 
			PASSWORD, 
			LASTNAME, 
			TIMECREATED,
			LASTUPDATED,
			GENDER
			<cfif arguments.middlename NEQ "0"> 
			,MIDDLENAME
			</cfif>
			<cfif arguments.clientuserid NEQ "0"> 
			,clientuserid
			</cfif>
			<cfif arguments.wemail NEQ "0"> 
			,WEMAIL
			</cfif>
			<cfif arguments.hemail NEQ "0">  
			,HEMAIL
			</cfif>
			<cfif arguments.oemail NEQ "0"> 
			,OEMAIL
			</cfif>
			<cfif arguments.memail NEQ "0"> 
			,MEMAIL
			</cfif>
			<cfif arguments.status NEQ "-1">
			,STATUS
			</cfif>
			<cfif arguments.title NEQ "0">  
			,TITLE
			</cfif>
			<cfif arguments.hphone NEQ "0"> 
			,HPHONE
			</cfif>
			<cfif arguments.wphone NEQ "0">  
			,WPHONE
			</cfif> 
			<cfif arguments.mphone NEQ "0"> 
			,MPHONE
			</cfif>
			<cfif arguments.ophone NEQ "0"> 
			,OPHONE
			</cfif> 
			<cfif arguments.fphone NEQ "0"> 
			,FPHONE
			</cfif> 
			<cfif (arguments.company NEQ "0") or (arguments.locationname NEQ "0")> 
			,COMPANY
			</cfif>
			<cfif (maritalstatus EQ 0) or (maritalstatus EQ 1)> 
			,MARITALSTATUS
			</cfif>
			<cfif arguments.referredby NEQ "0"> 
			,REFERREDBY
			</cfif>
			<cfif arguments.spousename NEQ "0"> 
			,SPOUSENAME
			</cfif>
			<cfif arguments.myurl NEQ "0"> 
			,URL
			</cfif>
			<cfif arguments.icq NEQ "0"> 
			,ICQ
			</cfif>
			<cfif arguments.aol NEQ "0"> 
			,AOL
			</cfif>
			<cfif arguments.yahoo NEQ "0"> 
			,YAHOO
			</cfif>
			<cfif arguments.msn NEQ "0"> 
			,MSN
			</cfif>
			<cfif arguments.mac NEQ "0"> 
			,MAC
			</cfif>
			<cfif arguments.jabber NEQ "0"> 
			,JABBER
			</cfif>
			<cfif arguments.gmail NEQ "0"> 
			,GMAIL
			</cfif>
			<cfif arguments.dob NEQ "0"> 
			,DOB
			</cfif>
			<cfif arguments.description NEQ "0"> 
			,DESCRIPTION
			</cfif>
			<cfif arguments.headnameid NEQ "0"> 
			,HEADNAMEID
			</cfif>
			<cfif arguments.yearsinbiz NEQ "0">
			,YEARSINBIZ
			</cfif>
			<cfif arguments.bizest NEQ "0">
			, BIZEST
			</cfif>
			<cfif arguments.ccaccepted NEQ "0">
			, CCACCEPTED
			</cfif>
			<cfif arguments.slogan NEQ "0">
			, SLOGAN
			</cfif>
			<cfif arguments.TWITTER NEQ "0">
			, TWITTER
			</cfif>
			<cfif arguments.LINKEDIN NEQ "0">
			, LINKEDIN
			</cfif>
			<cfif arguments.YOUTUBE NEQ "0">
			, YOUTUBE
			</cfif>
			<cfif arguments.PLAXO NEQ "0">
			, PLAXO
			</cfif>
			<cfif arguments.FACEBOOK NEQ "0">
			, FACEBOOK
			</cfif>
			<cfif arguments.MYSPACE NEQ "0">
			, MYSPACE
			</cfif>
			<cfif arguments.FRIENDFEED NEQ "0">
			, FRIENDFEED
			</cfif>
			)
			
			
		VALUES
		(
			<cfqueryparam value="#myusername#">, 
			<cfqueryparam value="#arguments.firstname#">, 
			<cfqueryparam value="#arguments.mypassword#">, 
			<cfqueryparam value="#arguments.lastname#">, 
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar"> 
			
			<cfif arguments.middlename NEQ "0">
			,<cfqueryparam value="#arguments.MIDDLENAME#">
			</cfif>
			
			<cfif arguments.clientuserid NEQ "0">
			,<cfqueryparam value="#arguments.CLIENTUSERID#">
			</cfif>
			
			<cfif arguments.wemail NEQ "0">
			,<cfqueryparam value="#arguments.wemail#">
			</cfif>
			
			<cfif arguments.hemail NEQ "0">
			,<cfqueryparam value="#arguments.hemail#"> 
			</cfif>
			
			<cfif arguments.oemail NEQ "0">
			,<cfqueryparam value="#arguments.oemail#"> 
			</cfif>
			
			<cfif arguments.memail NEQ "0">
			,<cfqueryparam value="#arguments.memail#"> 
			</cfif>
			
			<cfif arguments.status NEQ "-1">
			,<cfqueryparam value="#arguments.STATUS#"> 
			</cfif>
			
			<cfif arguments.title NEQ "0">  
			,<cfqueryparam value="#arguments.TITLE#"> 
			</cfif>
			
			<cfif arguments.hphone NEQ "0">
			,<cfqueryparam value="#arguments.hphone#"> 
			</cfif>
			
			<cfif arguments.wphone NEQ "0">
			,<cfqueryparam value="#wphone#"> 
			</cfif>
			
			<cfif arguments.mphone NEQ "0">
			,<cfqueryparam value="#arguments.mphone#">
			</cfif>
			
			<cfif arguments.ophone NEQ "0">
			,<cfqueryparam value="#arguments.ophone#"> 
			</cfif>
			
			<cfif arguments.fphone NEQ "0">
			,<cfqueryparam value="#arguments.fphone#"> 
			</cfif>
			
			<cfif (arguments.company NEQ "0") or (arguments.locationname NEQ "0")>
				<cfif arguments.company NEQ "0">
					,<cfqueryparam value="#arguments.company#">
				<cfelseif arguments.locationname NEQ "0">
					,<cfqueryparam value="#arguments.locationname#">
				</cfif>
			</cfif>
			
			<cfif (maritalstatus EQ 0) or (maritalstatus EQ 1)>
			,<cfqueryparam value="#arguments.maritalstatus#"> 
			</cfif>
			
			<cfif arguments.referredby NEQ "0">
			,<cfqueryparam value="#arguments.referredby#">
			</cfif> 
			
			<cfif arguments.spousename NEQ "0">
			,<cfqueryparam value="#arguments.spousename#">
			</cfif>
			
			<cfif arguments.myurl NEQ "0">
			,<cfqueryparam value="#arguments.myurl#">
			</cfif>
			
			<cfif arguments.icq NEQ "0">
			,<cfqueryparam value="#arguments.icq#"> 
			</cfif>
			
			<cfif arguments.aol NEQ "0">
			,<cfqueryparam value="#arguments.aol#"> 
			</cfif>
			
			<cfif arguments.yahoo NEQ "0">
			,<cfqueryparam value="#arguments.yahoo#">
			</cfif>
			
			<cfif arguments.msn NEQ "0">
			,<cfqueryparam value="#arguments.msn#">
			</cfif>
			
			<cfif arguments.mac NEQ "0">
			,<cfqueryparam value="#arguments.mac#"> 
			</cfif>
			
			<cfif arguments.jabber NEQ "0">
			,<cfqueryparam value="#arguments.jabber#">
			</cfif>
			
			<cfif arguments.gmail NEQ "0">
			,<cfqueryparam value="#arguments.gmail#">
			</cfif>
			
			<cfif arguments.dob NEQ "0">
			,<cfqueryparam value="#arguments.dob#">
			</cfif>
			
			<cfif arguments.description NEQ "0"> 
			,<cfqueryparam value="#arguments.description#">
			</cfif>
			
			<cfif arguments.headnameid NEQ "0"> 
			,<cfqueryparam value="#arguments.headnameid#">
			</cfif>
			
			<cfif arguments.yearsinbiz NEQ "0">
			,<cfqueryparam value="#arguments.YEARSINBIZ#">
			</cfif>
			
			<cfif arguments.bizest NEQ "0">
			, <cfqueryparam value="#arguments.BIZEST#">
			</cfif>
			
			<cfif arguments.ccaccepted NEQ "0">
			, <cfqueryparam value="#arguments.CCACCEPTED#">
			</cfif>
			
			<cfif arguments.slogan NEQ "0">
			, <cfqueryparam value="#arguments.SLOGAN#">
			</cfif>
			
			<cfif arguments.TWITTER NEQ "0">
			, <cfqueryparam value="#arguments.TWITTER#">
			</cfif>
			
			<cfif arguments.LINKEDIN NEQ "0">
			, <cfqueryparam value="#arguments.LINKEDIN#">
			</cfif>
			
			<cfif arguments.YOUTUBE NEQ "0">
			, <cfqueryparam value="#arguments.YOUTUBE#">
			</cfif>
			
			<cfif arguments.PLAXO NEQ "0">
			, <cfqueryparam value="#arguments.PLAXO#">
			</cfif>
			
			<cfif arguments.FACEBOOK NEQ "0">
			, <cfqueryparam value="#arguments.FACEBOOK#">
			</cfif>
			
			<cfif arguments.MYSPACE NEQ "0">
			, <cfqueryparam value="#arguments.MYSPACE#">
			</cfif>
			
			<cfif arguments.FRIENDFEED NEQ "0">
			, <cfqueryparam value="#arguments.FRIENDFEED#">
			</cfif>
			)
		SELECT @@IDENTITY AS NAMEID
		</cfquery>
		
		<cfif arguments.altnamedb NEQ "0">
		<cfquery name="qryaddname2" datasource="#arguments.altnamedb#">
		SET IDENTITY_INSERT NAME ON
		
		INSERT INTO NAME
		(
			NAMEID,
			USERNAME, 
			FIRSTNAME, 
			PASSWORD, 
			LASTNAME, 
			TIMECREATED,
			LASTUPDATED,
			GENDER
			<cfif arguments.middlename NEQ "0"> 
			,MIDDLENAME
			</cfif>
			<cfif arguments.clientuserid NEQ "0"> 
			,clientuserid
			</cfif>
			<cfif arguments.wemail NEQ "0"> 
			,WEMAIL
			</cfif>
			<cfif arguments.hemail NEQ "0">  
			,HEMAIL
			</cfif>
			<cfif arguments.oemail NEQ "0"> 
			,OEMAIL
			</cfif>
			<cfif arguments.memail NEQ "0"> 
			,MEMAIL
			</cfif>
			<cfif arguments.status NEQ "0">
			,STATUS
			</cfif>
			<cfif arguments.TITLE NEQ "0">
			,TITLE
			</cfif>
			<cfif arguments.hphone NEQ "0"> 
			,HPHONE
			</cfif>
			<cfif arguments.wphone NEQ "0">  
			,WPHONE
			</cfif> 
			<cfif arguments.mphone NEQ "0"> 
			,MPHONE
			</cfif>
			<cfif arguments.ophone NEQ "0"> 
			,OPHONE
			</cfif> 
			<cfif arguments.fphone NEQ "0"> 
			,FPHONE
			</cfif> 
			<cfif (arguments.company NEQ "0") or (arguments.locationname NEQ "0")> 
			,COMPANY
			</cfif>
			<cfif arguments.maritalstatus NEQ "0"> 
			,MARITALSTATUS
			</cfif>
			<cfif arguments.referredby NEQ "0"> 
			,REFERREDBY
			</cfif>
			<cfif arguments.spousename NEQ "0"> 
			,SPOUSENAME
			</cfif>
			<cfif arguments.myurl NEQ "0"> 
			,URL
			</cfif>
			<cfif arguments.icq NEQ "0"> 
			,ICQ
			</cfif>
			<cfif arguments.aol NEQ "0"> 
			,AOL
			</cfif>
			<cfif arguments.yahoo NEQ "0"> 
			,YAHOO
			</cfif>
			<cfif arguments.msn NEQ "0"> 
			,MSN
			</cfif>
			<cfif arguments.mac NEQ "0"> 
			,MAC
			</cfif>
			<cfif arguments.jabber NEQ "0"> 
			,JABBER
			</cfif>
			<cfif arguments.gmail NEQ "0"> 
			,GMAIL
			</cfif>
			<cfif arguments.dob NEQ "0"> 
			,DOB
			</cfif>
			<cfif arguments.description NEQ "0"> 
			,DESCRIPTION
			</cfif>
			<cfif arguments.headnameid NEQ "0"> 
			,HEADNAMEID
			</cfif>
			<cfif arguments.yearsinbiz NEQ "0">
			,YEARSINBIZ
			</cfif>
			<cfif arguments.bizest NEQ "0">
			, BIZEST
			</cfif>
			<cfif arguments.ccaccepted NEQ "0">
			, CCACCEPTED
			</cfif>
			<cfif arguments.slogan NEQ "0">
			, SLOGAN
			</cfif>
			<cfif arguments.TWITTER NEQ "0">
			, TWITTER
			</cfif>
			<cfif arguments.LINKEDIN NEQ "0">
			, LINKEDIN
			</cfif>
			<cfif arguments.YOUTUBE NEQ "0">
			, YOUTUBE
			</cfif>
			<cfif arguments.PLAXO NEQ "0">
			, PLAXO
			</cfif>
			<cfif arguments.FACEBOOK NEQ "0">
			, FACEBOOK
			</cfif>
			<cfif arguments.MYSPACE NEQ "0">
			, MYSPACE
			</cfif>
			<cfif arguments.FRIENDFEED NEQ "0">
			, FRIENDFEED
			</cfif>
		)
		VALUES
		(
			<cfqueryparam value="#qryaddname.nameid#">,
			<cfqueryparam value="#myusername#">, 
			<cfqueryparam value="#firstname#">, 
			<cfqueryparam value="#mypassword#">, 
			<cfqueryparam value="#lastname#">, 
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#arguments.gender#"> 
			<cfif arguments.middlename NEQ "0">
			,<cfqueryparam value="#arguments.MIDDLENAME#">
			</cfif>
			
			<cfif arguments.clientuserid NEQ "0">
			,<cfqueryparam value="#arguments.CLIENTUSERID#">
			</cfif>
			
			<cfif arguments.wemail NEQ "0">
			,<cfqueryparam value="#arguments.wemail#">
			</cfif>
			
			<cfif arguments.hemail NEQ "0">
			,<cfqueryparam value="#arguments.hemail#"> 
			</cfif>
			
			<cfif arguments.oemail NEQ "0">
			,<cfqueryparam value="#arguments.oemail#"> 
			</cfif>
			
			<cfif arguments.memail NEQ "0">
			,<cfqueryparam value="#arguments.memail#"> 
			</cfif>
			
			<cfif arguments.status NEQ "0">
			,<cfqueryparam value="#arguments.status#"> 
			</cfif>
			
			<cfif arguments.TITLE NEQ "0">
			,<cfqueryparam value="#arguments.TITLE#">
			</cfif>
			
			<cfif arguments.hphone NEQ "0">
			,<cfqueryparam value="#arguments.hphone#"> 
			</cfif>
			
			
			<cfif arguments.wphone NEQ "0">
			,<cfqueryparam value="#arguments.wphone#"> 
			</cfif>
			
			<cfif arguments.mphone NEQ "0">
			,<cfqueryparam value="#arguments.mphone#">
			</cfif>
			
			<cfif arguments.ophone NEQ "0">
			,<cfqueryparam value="#arguments.ophone#"> 
			</cfif>
			
			<cfif arguments.fphone NEQ "0">
			,<cfqueryparam value="#arguments.fphone#"> 
			</cfif>
			
			<cfif (arguments.company NEQ "0") or (arguments.locationname NEQ "0")>
				<cfif arguments.company NEQ "0">
					,<cfqueryparam value="#arguments.company#">
				<cfelseif arguments.locationname NEQ "0">
					,<cfqueryparam value="#arguments.locationname#">
				</cfif>
			</cfif>
			
			<cfif (arguments.maritalstatus EQ 0) or (arguments.maritalstatus EQ 1)>
			,<cfqueryparam value="#arguments.maritalstatus#"> 
			</cfif>
			
			<cfif arguments.referredby NEQ "0">
			,<cfqueryparam value="#arguments.referredby#">
			</cfif> 
			
			<cfif arguments.spousename NEQ "0">
			,<cfqueryparam value="#arguments.spousename#">
			</cfif>
			
			<cfif arguments.myurl NEQ "0">
			,<cfqueryparam value="#arguments.myurl#">
			</cfif>
			
			<cfif arguments.icq NEQ "0">
			,<cfqueryparam value="#arguments.icq#"> 
			</cfif>
			
			<cfif arguments.aol NEQ "0">
			,<cfqueryparam value="#arguments.aol#"> 
			</cfif>
			
			<cfif arguments.yahoo NEQ "0">
			,<cfqueryparam value="#arguments.yahoo#">
			</cfif>
			
			<cfif arguments.msn NEQ "0">
			,<cfqueryparam value="#arguments.msn#">
			</cfif>
			
			<cfif arguments.mac NEQ "0">
			,<cfqueryparam value="#arguments.mac#"> 
			</cfif>
			
			<cfif arguments.jabber NEQ "0">
			,<cfqueryparam value="#arguments.jabber#">
			</cfif>
			
			<cfif arguments.gmail NEQ "0">
			,<cfqueryparam value="#arguments.gmail#">
			</cfif>
			
			<cfif arguments.dob NEQ "0">
			,<cfqueryparam value="#arguments.dob#">
			</cfif>
			
			<cfif arguments.description NEQ "0"> 
			,<cfqueryparam value="#arguments.description#">
			</cfif>
			
			<cfif arguments.headnameid NEQ "0"> 
			,<cfqueryparam value="#arguments.headnameid#">
			</cfif>
			
			<cfif arguments.yearsinbiz NEQ "0">
			,<cfqueryparam value="#arguments.YEARSINBIZ#">
			</cfif>
			
			<cfif arguments.bizest NEQ "0">
			, <cfqueryparam value="#arguments.BIZEST#">
			</cfif>
			
			<cfif arguments.ccaccepted NEQ "0">
			, <cfqueryparam value="#arguments.CCACCEPTED#">
			</cfif>
			
			<cfif arguments.slogan NEQ "0">
			, <cfqueryparam value="#arguments.SLOGAN#">
			</cfif>
			
			<cfif arguments.TWITTER NEQ "0">
			, <cfqueryparam value="#arguments.TWITTER#">
			</cfif>
			
			<cfif arguments.LINKEDIN NEQ "0">
			, <cfqueryparam value="#arguments.LINKEDIN#">
			</cfif>
			
			<cfif arguments.YOUTUBE NEQ "0">
			, <cfqueryparam value="#arguments.YOUTUBE#">
			</cfif>
			
			<cfif arguments.PLAXO NEQ "0">
			, <cfqueryparam value="#arguments.PLAXO#">
			</cfif>
			
			<cfif arguments.FACEBOOK NEQ "0">
			, <cfqueryparam value="#arguments.FACEBOOK#">
			</cfif>
			
			<cfif arguments.MYSPACE NEQ "0">
			, <cfqueryparam value="#arguments.MYSPACE#">
			</cfif>
			
			<cfif arguments.FRIENDFEED NEQ "0">
			, <cfqueryparam value="#arguments.FRIENDFEED#">
			</cfif>
			)
			SET IDENTITY_INSERT NAME OFF
		</cfquery>
		</cfif>
		
		<!--- Third Part --->
		<cfset url.nameid = qryaddname.NAMEID>
		<!--- Get LatLon to Add to Database for Maps --->
		<!---<cfif Trim(arguments.address1) NEQ "" AND Trim(arguments.city) NEQ "" AND Trim(arguments.state) NEQ "" AND Trim(arguments.zip) NEQ "">
			<cfinvoke component="LatLon" method="get" address = "#arguments.address1#" city = "#arguments.city#" state = "#arguments.state#" zip = "#arguments.zip#" returnvariable="newaddress">
		</cfif>--->
		<!--- Adds address information to database --->
		<cfif arguments.address2 EQ "0">
			<cfset arguments.address2 = "">
		</cfif>
		<cfquery name="qryconvertaddress" datasource="#arguments.contactdsn#">
		INSERT INTO ADDRESS
			(NAMEID,
			ADDRESSTYPEID, 
			ADDRESS1, 
			ADDRESS2, 
			CITY, 
			STATE, 
			COUNTRY, 
			ZIP, 
			<cfif isdefined('newaddress.lat')>
			LAT,
			</cfif>
			<cfif isdefined('newaddress.lon')>
			LON,
			</cfif>
			<cfif arguments.intersection NEQ "0">
			INTERSECTION,
			</cfif>
			LASTUPDATED)
		VALUES
			('#qryaddname.nameid#',
			'1', 
			<cfqueryparam value="#arguments.ADDRESS1#">, 
			<cfqueryparam value="#arguments.ADDRESS2#">, 
			<cfqueryparam value="#arguments.CITY#">, 
			<cfqueryparam value="#arguments.STATE#">, 
			<cfqueryparam value="#arguments.country#">, 
			<cfqueryparam value="#arguments.ZIP#">,
			<cfif isdefined('newaddress.lat')>
			<cfqueryparam value="#newaddress.lat#">,
			</cfif>
			<cfif isdefined('newaddress.lon')>
			<cfqueryparam value="#newaddress.lon#">,
			</cfif>
			<cfif arguments.intersection NEQ "0">
			<cfqueryparam value="#arguments.INTERSECTION#">,
			</cfif>
			<cfqueryparam value="#mytime.createTimeDate()#">)
			SELECT @@IDENTITY AS ADDRESSID
		</cfquery>
		
		<cfif arguments.altnamedb NEQ "0">
			<cfquery name="qryconvertaddress2" datasource="#arguments.altnamedb#">
				SET IDENTITY_INSERT ADDRESS ON
			
				INSERT INTO ADDRESS
				(ADDRESSID,
				NAMEID,
				ADDRESSTYPEID, 
				ADDRESS1, 
				ADDRESS2, 
				CITY, 
				STATE, 
				ZIP, 
				<cfif newaddress.exist neq "0">
				LAT,
				LON,
				</cfif>
				<cfif arguments.intersection NEQ "0">
					INTERSECTION,
				</cfif>
				LASTUPDATED)
				VALUES
				(
					'#qryconvertaddress.ADDRESSID#',
					'#qryaddname.nameid#',
					'1', 
					<cfqueryparam value="#arguments.ADDRESS1#">, 
					<cfqueryparam value="#arguments.ADDRESS2#">, 
					<cfqueryparam value="#arguments.CITY#">, 
					<cfqueryparam value="#arguments.STATE#">, 
					<cfqueryparam value="#arguments.ZIP#">,
					<cfif newaddress.exist neq "0">
					<cfqueryparam value="#newaddress.lat#">,
					<cfqueryparam value="#newaddress.lon#">,
					</cfif>
					<cfif arguments.intersection NEQ "0">
					<cfqueryparam value="#arguments.INTERSECTION#">,
					</cfif>
					<cfqueryparam value="#mytime.createTimeDate()#">)
				SET IDENTITY_INSERT ADDRESS OFF
			</cfquery>
		</cfif>
		<cfreturn qryaddname.nameid>
	</cffunction>
	
	<cffunction name="quickSearchNameIds" access="public" returntype="query" hint="I return NAMEIDs of general search">
		<cfargument name="contactdsn" required="true" type="string" hint="database name">
		<cfargument name="groupid" required="false" type="string" default="0" hint="Id of the group">
		<cfargument name="searchkey" required="false" type="string" default="0" hint="search key">
		<cfset var get=0>
		<cfset var keylist=Trim(arguments.searchkey)>
		<cfset var l=listlen(keylist," ")>
		<cfquery name="get" datasource="#arguments.contactdsn#">
			SELECT N.NAMEID 
			FROM NAME N <cfif keylist NEQ '0'>,ADDRESS A</cfif>
			WHERE STATUS=<cfqueryparam value="1">
			<cfif keylist NEQ '0'>
			AND N.NAMEID=A.NAMEID	
			</cfif>
			<cfif arguments.groupid NEQ 0>
			AND N.NAMEID IN (SELECT NAMEID FROM PEOPLE2USERGROUPS WHERE USERGROUPID=<cfqueryparam value="#arguments.groupid#">)
			</cfif>
			<cfif keylist NEQ 0>
				<cfif l GT 0>
					AND
					(
					<cfloop from="1" to="#l#" index="i">
						<cfset key=listGetAt(keylist,i," ")>
						<cfif i GT 1>OR</cfif>
						(
							N.FIRSTNAME LIKE <cfqueryparam value="%#key#%">
							OR N.LASTNAME LIKE <cfqueryparam value="%#key#%">
							OR N.MIDDLENAME LIKE <cfqueryparam value="%#key#%">
							OR N.USERNAME LIKE <cfqueryparam value="%#key#%">
							OR N.HEMAIL LIKE <cfqueryparam value="%#key#%">
							OR N.MEMAIL LIKE <cfqueryparam value="%#key#%">
							OR N.WEMAIL LIKE <cfqueryparam value="%#key#%">
							OR N.COMPANY LIKE <cfqueryparam value="%#key#%">
							OR N.DESCRIPTION LIKE <cfqueryparam value="%#key#%">
							OR A.ADDRESS1 LIKE <cfqueryparam value="%#key#%">
							OR A.CITY LIKE <cfqueryparam value="%#key#%">
							OR A.STATE LIKE <cfqueryparam value="%#key#%">
							OR A.ZIP LIKE <cfqueryparam value="%#key#%">
							OR N.CLIENTUSERID LIKE <cfqueryparam value="%#key#%">
							OR N.REFERREDBY LIKE <cfqueryparam value="%#key#%">
							OR N.TWITTER LIKE <cfqueryparam value="%#key#%">
							OR N.LINKEDIN LIKE <cfqueryparam value="%#key#%">
							OR N.YOUTUBE LIKE <cfqueryparam value="%#key#%">
							OR N.PLAXO LIKE <cfqueryparam value="%#key#%">
							OR N.FACEBOOK LIKE <cfqueryparam value="%#key#%">
							OR N.MYSPACE LIKE <cfqueryparam value="%#key#%">
							OR N.FRIENDFEED LIKE <cfqueryparam value="%#key#%">
						)
					</cfloop>
					)
				</cfif> 	
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getNameIdsOfDuplicates" access="public" returntype="query" hint="I return NAMEIDs of duplicates">
		<cfargument name="contactdsn" required="true" type="string" hint="database name">
		<cfargument name="dup" required="true" type="string" hint="duplicate what">
		<cfset var get=0>
		<cfswitch expression="#arguments.dup#">
			<cfcase value="clientuserid,username,hemail,wemail">
				<cfquery name="get" datasource="#arguments.contactdsn#">
					SELECT NAMEID FROM NAME
					INNER JOIN
					(
						SELECT #arguments.dup#
						FROM NAME WHERE STATUS=<cfqueryparam value="1">
						GROUP BY #arguments.dup#
						HAVING COUNT(*)>=2
					) AS DUPTABLE ON
					(
						NAME.#arguments.dup# = DUPTABLE.#arguments.dup# 
					)
					WHERE DATALENGTH(NAME.#arguments.dup#)>0
					AND NAME.#arguments.dup# IS NOT NULL
					AND NAME.STATUS=<cfqueryparam value="1">
				</cfquery>
			</cfcase>
			<cfcase value="address">
				<cfquery name="get" datasource="#arguments.contactdsn#">
					SELECT NAMEID FROM ADDRESS
					INNER JOIN
					(
						SELECT ADDRESS1
						FROM ADDRESS
						WHERE NAMEID IN (SELECT NAMEID FROM NAME WHERE STATUS=1)
						AND NAMEID IN (SELECT DISTINCT NAMEID FROM ADDRESS)
						GROUP BY ADDRESS1
						HAVING COUNT(*) >= <cfqueryparam value="2">
					) AS DUPTABLE
						ON 
						(
							ADDRESS.ADDRESS1 = DUPTABLE.ADDRESS1
						)
					WHERE ADDRESS.ADDRESS1<>''
					AND ADDRESS.ADDRESS1 IS NOT NULL
					AND ADDRESS.ADDRESS1<><cfqueryparam value="0">
				</cfquery>
			</cfcase>
			<cfdefaultcase>
				<cfquery name="get" datasource="#arguments.contactdsn#">
					SELECT NAMEID FROM NAME
					INNER JOIN
					(
						SELECT FIRSTNAME, LASTNAME
						FROM NAME 
						WHERE STATUS=<cfqueryparam value="1">
						GROUP BY FIRSTNAME, LASTNAME
						HAVING COUNT(*) >= 2
					) AS DUPTABLE
					ON 
					(
						NAME.FIRSTNAME = DUPTABLE.FIRSTNAME
						AND NAME.LASTNAME = DUPTABLE.LASTNAME
					)
					WHERE DATALENGTH(NAME.FIRSTNAME)>0
					AND DATALENGTH(NAME.LASTNAME)> 0
					AND STATUS=<cfqueryparam value="1">
				</cfquery>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn get>
	</cffunction>
	
	<cfscript>
	/**
	 * Generates Unique Username
	 * @param contactdsn  (Required)
	 * output: unique username
	 */
	function getUniqueUsername(contactdsn) 
	{
		var notUnique=TRUE;
		var uniqueUsername="";
		
		
		while(notUnique eq TRUE)
		{
			uniqueUsername=getRandomUsername();
			notUnique=checkUsername(contactdsn, uniqueUsername);
		}
	
		return (uniqueUsername);
	}
	</cfscript>
</cfcomponent>