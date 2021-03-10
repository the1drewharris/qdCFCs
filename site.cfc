<cfcomponent hint="I handle sites">
	<cfobject component="timeDateConversion" name="mytime">
	
	<cffunction name="getDatabasesToSync" access="public" output="false" returntype="string" hint="I get databases which needs to be synced">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT ALTNAMEDB FROM SITE
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#">
		</cfquery>
		<cfreturn get.ALTNAMEDB>
	</cffunction>
	
	<cffunction name="getParentSiteUrl" access="public" returntype="string" hint="I return parent site url">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var getParent=0>
		<cfset var  get=0>
		<cfset parentsiteinfo="">
		<cfquery name="getParent" datasource="deltasystem">
			SELECT PARENTSITEID FROM SITE WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getParent.recordcount GT 0>
			<cfset parentsiteid=getParent.PARENTSITEID>
			<cfquery name="get" datasource="deltasystem">
				SELECT SITEURL FROM SITE WHERE SITEID=<cfqueryparam value="#parentsiteid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset parentsiteinfo=get.SITEURL>
		</cfif>
		<cfreturn parentsiteinfo>
	</cffunction>
	
	<cffunction name="getSiteUrlAndId" access="public" returntype="query" hint="I return siteurl and siteid">
		<cfargument name="sitelist" required="false" default="0" type="string" hint="list of siteids">
		<cfargument name="system" required="false" default="-1" type="string" hint="status of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT SITEID, SITENAME, SITEURL, STATUS, SYSTEM FROM SITE
			WHERE STATUS <> <cfqueryparam value="Deleted">
			<cfif arguments.sitelist NEQ 0>
			AND SITEID IN (#sitelist#)
			</cfif>
			<cfif arguments.system NEQ -1>
			AND SYSTEM=<cfqueryparam value="#arguments.system#">
			</cfif>
			ORDER BY SITENAME
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="isSiteId" access="public" returntype="boolean" hint="I return TRUE if the value passed is siteid">
		<cfargument name="siteid" required="true" type="string" hint="Id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT COUNT(*) SITECOUNT FROM SITE 
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.SITECOUNT GT 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
	
	<cffunction name="getSiteInfo" returntype="query" access="public" hint="I get the site info for the siteid you pass to me, I return a recordset (SITEID, SITENAME, SITEURL, IMGPATH, STATUS, SITEKEYWORDS, PRINTCSS, SCREENCSS, SITETITLE, SUBTITLE,  PARENTID,  SCITY,  SSTATE, SITEAGENCYID, CLIENTSITEID, DESCRIPTION AS SITEDESCRIPTION,  USEMISSINGNUMBERS,  STARTMISSINGNUMBERS,  orgphone, ORGNAME, DEFAULTAREACODE, COMMENTEMAIL, FLATTEN2HTML, ALTNAMEDB, ALTDSN, SMALLTHUMB, MEDTHUMB, LARGETHUMB, EXTPOP3, EXTSMTP, EXTFTP, EXTFTPACCT, EXTFTPPASSWORD, EXTFTPPATH, NAVNUM, VOLUNTEERSCHEDULE, HEARDABOUTUS)">
		<cfargument name="sitedsn" type="string" required="false" default="deltasystem" hint="I am the datasource for the sites">
		<cfargument name="siteurl" type="string" required="false" default="0" hint="I am the site you want info on">
		<cfargument name="siteid" type="string" default="0" required="false" hint="I am the id for the site you want">
		<cfset var getsite=0>
		<cfquery name="getsite" datasource="#arguments.sitedsn#" maxrows="1">
		SELECT
			SITEID, 
			SITENAME, 
			SITEURL, 
			IMAGEPATH AS IMGPATH, 
			STATUS, 
			SITEKEYWORDS, 
			PRINTCSS, 
			SCREENCSS, 
			SITETITLE, 
			SUBTITLE, 
			PARENTSITEID AS PARENTID, 
			CITY AS SCITY, 
			STATE AS SSTATE, 
			SITEAGENCYID, 
			CLIENTSITEID, 
			DESCRIPTION AS SITEDESCRIPTION, 
			USEMISSINGNUMBERS, 
			STARTMISSINGNUMBERS, 
			PHONE as orgphone,
			ORGNAME,
			DEFAULTAREACODE,
			COMMENTEMAIL,
			CC_COMMENTEMAIL,
			FLATTEN2HTML,
			ALTNAMEDB,
			ALTDSN,
			TINYTHUMB,
			SMALLTHUMB,
			MEDTHUMB,
			LARGETHUMB,
			EXTPOP3,
			EXTSMTP,
			EXTFTP,
			EXTFTPACCT,
			EXTFTPPASSWORD,
			EXTFTPPATH,
			NAVNUM,
			VOLUNTEERSCHEDULE,
			HEARDABOUTUS,
			LAYOUTID,
			COLORSCHEMEID,
			FONTFAMILYID,
			GALLERYTHUMBSTYLE,
			IMAGESTHUMBSTYLE,
			IMAGESPERROW,
			IMAGESPERPAGE,
			PASSWORDNEEDED,
			ADDRESSNEEDED,
			PHONENEEDED,
			SHOWTHEMEPICKER
		FROM         
			SITE 
		WHERE 1=1
		<cfif arguments.siteid neq 0>AND SITEID = <cfqueryparam value="#arguments.siteid#"></cfif>
		<cfif arguments.siteurl neq 0>AND SITEURL = <cfqueryparam value="#arguments.siteurl#"></cfif>
		</cfquery>
	<cfreturn getsite> 	
	</cffunction>
	
	<cffunction name="getSites" returntype="query" access="public" hint="I get the site info for the siteid you pass to me I return a recordset (SITEID, SITENAME, SITEURL, IMGPATH, STATUS, SITEKEYWORDS, PRINTCSS, SCREENCSS, SITETITLE, SUBTITLE,  PARENTID,  SCITY,  SSTATE, SITEAGENCYID, CLIENTSITEID, DESCRIPTION AS SITEDESCRIPTION,  USEMISSINGNUMBERS,  STARTMISSINGNUMBERS,  orgphone, ORGNAME, DEFAULTAREACODE, COMMENTEMAIL, FLATTEN2HTML, ALTNAMEDB, ALTDSN, SMALLTHUMB, MEDTHUMB, LARGETHUMB, EXTPOP3, EXTSMTP, EXTFTP, EXTFTPACCT, EXTFTPPASSWORD, EXTFTPPATH, NAVNUM, VOLUNTEERSCHEDULE, HEARDABOUTUS)">">
		<cfargument name="sitedsn" type="string" required="false" default="deltasystem" hint="I am the datasource for the sites">
		<cfargument name="sites" type="string" required="false" default="0" hint="I am the list of site ids you want">
		<cfargument name="status" type="string" required="false" default="0" hint="I am the status of the sites you want">
		<cfargument name="excludeList" type="string" required="false" default="0" hint="the list of sites you want to exclude">
		<cfargument name="siteurlLike" type="string" required="false" default="0" hint="If you pass something into me, I will have the query search for siteurl's that contain the string you pass into me.">
		<cfargument name="state" type="string" required="false" default="0" hint="If passed in I return all sites for that state.">
		<cfargument name="orderby" type="string" required="false" default="sitename" hint="The way you want to sort your recordset">
		<cfargument name="parentsite" type="string" required="false" default="0" hint="If you pass something into me, I will have the query just get the children sites of this site">
		<cfset var getmysites = 0>
		<cfquery name="getmysites" datasource="#arguments.sitedsn#">
		SELECT
			SITEID, 
			SITENAME, 
			SITEURL, 
			IMAGEPATH AS IMGPATH, 
			STATUS, 
			SITEKEYWORDS, 
			PRINTCSS, 
			SCREENCSS, 
			SITETITLE, 
			SUBTITLE, 
			PARENTSITEID AS PARENTID, 
			CITY AS SCITY, 
			STATE AS SSTATE, 
			SITEAGENCYID, 
			CLIENTSITEID, 
			DESCRIPTION AS SITEDESCRIPTION, 
			USEMISSINGNUMBERS, 
			STARTMISSINGNUMBERS, 
			PHONE as orgphone,
			ORGNAME,
			DEFAULTAREACODE,
			COMMENTEMAIL,
			FLATTEN2HTML,
			ALTNAMEDB,
			ALTDSN,
			TINYTHUMB,
			SMALLTHUMB,
			MEDTHUMB,
			LARGETHUMB,
			EXTPOP3,
			EXTSMTP,
			EXTFTP,
			EXTFTPACCT,
			EXTFTPPASSWORD,
			EXTFTPPATH,
			NAVNUM,
			VOLUNTEERSCHEDULE,
			HEARDABOUTUS
		FROM         
			SITE 
		WHERE  1=1
		<cfif arguments.sites neq 0 AND arguments.sites neq "All">AND SITEID IN (<cfqueryparam value="#arguments.sites#" list="true" cfsqltype="cf_sql_varchar">)</cfif>
		<cfif arguments.excludelist neq 0>AND SITEURL NOT IN (<cfqueryparam value="#arguments.excludeList#" list="true" cfsqltype="cf_sql_varchar">)</cfif>
		<cfif arguments.siteurlLike neq 0>AND SITEURL LIKE <cfqueryparam value="%#arguments.siteurlLike#%" cfsqltype="cf_sql_varchar"></cfif>
		<cfif arguments.state neq 0>AND SITE.STATE LIKE <cfqueryparam value="#arguments.state#" CFSQLType="CF_SQL_VARCHAR"></cfif>
		<cfif arguments.status neq 0>AND STATUS=<cfqueryparam value="#arguments.status#"></cfif>
		<cfif arguments.parentsite neq 0>AND PARENTSITEID = <cfqueryparam value="#arguments.parentsite#"></cfif>
		ORDER BY #ARGUMENTS.ORDERBY#
		</cfquery>
	<cfreturn getmysites> 	
	</cffunction>
	
	<cffunction name="copyFiles" returntype="void" access="public" hint="I copy the core files needed to run a new site from spiderwebmaster.net">
		<cfargument name="siteurl" type="string" required="true" hint="the url for the new site">
		<cfargument name="basePath" type="string" required="false" default="/home/drew/domains">
		<cfargument name="domainSource" type="string" required="false" default="spiderwebmaster.net/public_html" hint="the root source to copy files from">
		<cfargument name="fileList" type="string" required="false" default=".htaccess, index.cfm,Application.cfc,js/captcha.js,js/editor.js,actions/completed.cfm,actions/captchacontent.cfm,fla/videoPlayerSkin.xml,fla/vplayer.swf" hint="A list of filenames you want to copy to the new site">
			<cfloop list="#arguments.fileList#" index="i">
				<cffile action="copy" source="#arguments.basePath#/#arguments.domainSource#/#i#" destination="#arguments.basePath#/#arguments.siteurl#/public_html/" mode="775">
			</cfloop>
	</cffunction>
	
	<cffunction name="getStateSiteCount" returnType="query" access="public" hint="I get the State site count for sites under a specific parent Site ID, I return a recordset (STATE, STATECOUNT)">
		<cfargument name="parentSiteID" type="string" required="false" default="2003110422051614" hint="Parent site ID">
		<cfset var stateSiteCountQuery = 0>
		<cfquery name="stateSiteCountQuery" datasource="deltasystem">
		SELECT     
			SITE.STATE,
			COUNT(SITE.STATE) AS STATECOUNT
		FROM         
			STATES, 
			SITE
		WHERE STATES.STATENAME = SITE.STATE
		AND (SITE.STATUS <> 'deleted') 
		AND (SITE.PARENTSITEID = '#arguments.parentSiteID#')
		GROUP BY SITE.STATE
		ORDER BY SITE.STATE
		</cfquery>
		<cfreturn stateSiteCountQuery>		
	</cffunction>
	
	<!--- tested and working --->
	<cffunction name="addSite" access="public" returntype="string" hint="I add a site to the database">
		<cfargument name="SITENAME" type="string" required="true" hint="name of the site"> 
		<cfargument name="SITEURL" type="string" required="true" hint="URL of the site"> 
		<cfargument name="sitedsn" type="string" required="false" default="deltasystem" hint="I am the datasource for storing the sites">
		<cfargument name="IMAGEPATH" type="string" required="false" hint="path to the images" default="images"> 
		<cfargument name="STATUS" type="string" required="false" default="DEV" hint="status of the site"> 
		<cfargument name="SITEKEYWORDS" type="string" required="false" hint="keywords for the site" default="Site Powered by QuantumDelta"> 
		<cfargument name="PRINTCSS" type="string" required="false" default="print.css" hint="print css for the site"> 
		<cfargument name="SCREENCSS" type="string" required="false" default="screen.css" hint="screen css for the site"> 
		<cfargument name="SITETITLE" type="string" default="" required="false" hint="title of the site"> 
		<cfargument name="SUBTITLE" type="string" default="" required="false" hint="subtite of the site"> 
		<cfargument name="PARENTSITEID" type="string" required="false" default="0" hint="id for the parentsite"> 
		<cfargument name="SCITY" type="string" default="" required="false" hint="city for the site"> 
		<cfargument name="SSTATE" type="string" default="" required="false" hint="state for the site"> 
		<cfargument name="SITEAGENCYID" type="string" default="" required="false" hint="siteagencyid"> 
		<cfargument name="CLIENTSITEID" type="string" default="0" required="false" hint="client user id"> 
		<cfargument name="DESCRIPTION" type="string" default="" required="false" hint="site description"> 
		<cfargument name="USEMISSINGNUMBERS" type="string" required="false" default="false" hint="use missing numbers for clientuserid"> 
		<cfargument name="STARTMISSINGNUMBERS" type="string" required="false" default="1" hint="number you want to start using your missing numbers for clientuserid"> 
		<cfargument name="PHONE" type="string" required="false" default="" hint="phone number you want to display on the site">
		<cfargument name="ORGNAME" type="string" required="false" default="" hint="name of the organization">
		<cfargument name="DEFAULTAREACODE" type="string" required="false" default="" hint="default area code for the site">
		<cfargument name="COMMENTEMAIL" type="string" required="false" default="" hint="email address that the comments for the site would go to">
		<cfargument name="CC_COMMENTEMAIL" type="string" required="false" default="" hint="CC email address that the comments for the site would go to">
		<cfargument name="FLATTEN2HTML" type="string" required="false" default="1" hint="I am the datasource for storing the sites">
		<cfargument name="ALTNAMEDB" type="string" required="false" default="" hint="I am the datasource for storing the sites">
		<cfargument name="ALTDSN" type="string" required="false" default="" hint="I am the datasource for storing the sites">
		<cfargument name="TINYTHUMB" type="string" required="false" default="60" hint="size of tiny thumbnail image">
		<cfargument name="SMALLTHUMB" type="string" required="false" default="80" hint="size of small thumbnail image">
		<cfargument name="MEDTHUMB" type="string" required="false" default="400" hint="size of medium thumbnail image">
		<cfargument name="LARGETHUMB" type="string" required="false" default="500" hint="size of larg thumbnail image">
		<cfargument name="EXTPOP3" type="string" required="false" default="0" hint="External pop3 server">
		<cfargument name="EXTSMTP" type="string" required="false" default="0" hint="external smtp server">
		<cfargument name="EXTFTP" type="string" required="false" default="0" hint="external ftp server">
		<cfargument name="EXTFTPACCT" type="string" required="false" default="0" hint="external ftp account name">
		<cfargument name="EXTFTPPASSWORD" type="string" required="false" default="0" hint="external ftp password">
		<cfargument name="EXTFTPPATH" type="string" required="false" default="0" hint="external ftp path">
		<cfargument name="NAVNUM" type="string" required="false" default="0" hint="number of navigations for the site">
		<cfargument name="VOLUNTEERSCHEDULE" type="string" default="0" required="false" hint="whether or not this site utilzes voluteer scheduling">
		<cfargument name="HEARDABOUTUS" type="string" default="0" required="false" hint="whether or not this site utilizes heard about us">
		<cfargument name="layoutid" default="0" type="string" required="false" hint="Id of the template for quick design sites">
		<cfargument name="colorschemeid" default="0" type="string" required="false" hint="color scheme id for quick design sites">
		<cfargument name="fontfamilyid" default="0" type="string" required="false" hint="font family id for sites">
		<cfargument name="gallerythumbstyle" default="0" type="string" required="false" hint="Thumb style for gallery e.g. rounded_corners or reflection">
		<cfargument name="imagesthumbstyle" default="0" type="string" required="false" hint="Image thumb style e.g. rounded_corners or reflection">
		<cfargument name="imagesperrow" default="0" type="string" required="false" hint="No of images per row">
		<cfargument name="imagesperpage" default="0" type="string" required="false" hint="No of images per page">
		<cfargument name="passwordneeded" default="-1" type="string" required="false" hint="0 if password is not needed during registration, 1 password is needed during registration">
		<cfargument name="addressneeded" default="-1" type="string" required="false" hint="1 if address is needed, 0 if address is not needed">
		<cfargument name="phoneneeded" default="-1" type="string" required="false" hint="1 if phone is needed, 0 if phone is not needed">
		<cfargument name="showthemepicker" default="-1" type="string" required="false" hint="1 if theme picker should be shown on site, 0 if theme picker should not be shown on site">
		<cfset var addMySite=0>
		<cfset timedate=mytime.createtimedate()>
		<cfquery name="addMySite" datasource="#arguments.sitedsn#">
		INSERT INTO SITE
			(
			LAYOUTID,
			COLORSCHEMEID,
			FONTFAMILYID,
			GALLERYTHUMBSTYLE,
			IMAGESTHUMBSTYLE,
			IMAGESPERROW,
			IMAGESPERPAGE,
			PASSWORDNEEDED,
			ADDRESSNEEDED,
			PHONENEEDED,
			SHOWTHEMEPICKER,
			SITEID, 
			SITENAME, 
			SITEURL, 
			IMAGEPATH, 
			STATUS, 
			SITEKEYWORDS, 
			PRINTCSS, 
			SCREENCSS, 
			SITETITLE, 
			SUBTITLE, 
			PARENTSITEID, 
			CITY, 
			STATE, 
			SITEAGENCYID, 
			CLIENTSITEID, 
			DESCRIPTION, 
			USEMISSINGNUMBERS, 
			STARTMISSINGNUMBERS, 
			PHONE,
			ORGNAME,
			DEFAULTAREACODE,
			COMMENTEMAIL,
			CC_COMMENTEMAIL,
			FLATTEN2HTML,
			ALTNAMEDB,
			ALTDSN,
			TINYTHUMB,
			SMALLTHUMB,
			MEDTHUMB,
			LARGETHUMB,
			EXTPOP3,
			EXTSMTP,
			EXTFTP,
			EXTFTPACCT,
			EXTFTPPASSWORD,
			EXTFTPPATH,
			NAVNUM,
			VOLUNTEERSCHEDULE,
			HEARDABOUTUS,
			VERSIONID)
		VALUES
			(
			
		 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.layoutid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.colorschemeid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fontfamilyid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gallerythumbstyle#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesthumbstyle#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesperrow#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesperpage#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.passwordneeded#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressneeded#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phoneneeded#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.showthemepicker#">,
			<cfqueryparam value="#timedate#">, 
			<cfqueryparam value="#arguments.SITENAME#">, 
			<cfqueryparam value="#arguments.SITEURL#">, 
			<cfqueryparam value="#arguments.IMAGEPATH#">, 
			<cfqueryparam value="#arguments.STATUS#">, 
			<cfqueryparam value="#arguments.SITEKEYWORDS#">, 
			<cfqueryparam value="#arguments.PRINTCSS#">, 
			<cfqueryparam value="#arguments.SCREENCSS#">, 
			<cfqueryparam value="#arguments.SITETITLE#">, 
			<cfqueryparam value="#arguments.SUBTITLE#">, 
			<cfqueryparam value="#arguments.PARENTSITEID#">, 
			<cfqueryparam value="#arguments.SCITY#">, 
			<cfqueryparam value="#arguments.SSTATE#">, 
			<cfqueryparam value="#arguments.SITEAGENCYID#">, 
			<cfqueryparam value="#arguments.CLIENTSITEID#">, 
			<cfqueryparam value="#arguments.DESCRIPTION#">, 
			<cfqueryparam value="#arguments.USEMISSINGNUMBERS#">,
			<cfqueryparam value="#arguments.STARTMISSINGNUMBERS#">, 
			<cfqueryparam value="#arguments.PHONE#">,
			<cfqueryparam value="#arguments.ORGNAME#">,
			<cfqueryparam value="#arguments.DEFAULTAREACODE#">,
			<cfqueryparam value="#arguments.COMMENTEMAIL#">,
			<cfqueryparam value="#arguments.CC_COMMENTEMAIL#">,
			<cfqueryparam value="#arguments.FLATTEN2HTML#">,
			<cfqueryparam value="#arguments.ALTNAMEDB#">,
			<cfqueryparam value="#arguments.ALTDSN#">,
			<cfqueryparam value="#arguments.TINYTHUMB#">,
			<cfqueryparam value="#arguments.SMALLTHUMB#">,
			<cfqueryparam value="#arguments.MEDTHUMB#">,
			<cfqueryparam value="#arguments.LARGETHUMB#">,
			<cfqueryparam value="#arguments.EXTPOP3#">,
			<cfqueryparam value="#arguments.EXTSMTP#">,
			<cfqueryparam value="#arguments.EXTFTP#">,
			<cfqueryparam value="#arguments.EXTFTPACCT#">,
			<cfqueryparam value="#arguments.EXTFTPPASSWORD#">,
			<cfqueryparam value="#arguments.EXTFTPPATH#">,
			<cfqueryparam value="#arguments.NAVNUM#">,
			<cfqueryparam value="#arguments.VOLUNTEERSCHEDULE#">,
			<cfqueryparam value="#arguments.HEARDABOUTUS#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#timedate#">)
		</cfquery>
		<cfreturn timedate> 
	</cffunction>
	
	<!--- tested and working --->
	<cffunction name="updateSite" access="public" returntype="void" hint="I update a site in the database">
		<cfargument name="siteid" type="string" required="true" hint="id of the site">
		<cfargument name="SITEURL" default="0" type="string" required="false" hint="URL of the site"> 
		<cfargument name="sitedsn" type="string" required="false" default="deltasystem" hint="I am the datasource for storing the sites">
		<cfargument name="SITENAME" default="0" type="string" required="false" hint="name of the site"> 
		<cfargument name="IMGPATH" default="0" type="string" required="false" hint="path to the images"> 
		<cfargument name="STATUS"type="string" required="false" default="DEV" hint="status of the site"> 
		<cfargument name="SITEKEYWORDS" default="0" type="string" required="false" hint="keywords for the site"> 
		<cfargument name="PRINTCSS" type="string" required="false" default="print.css" hint="print css for the site"> 
		<cfargument name="SCREENCSS" type="string" required="false" default="screen.css" hint="screen css for the site"> 
		<cfargument name="SITETITLE" type="string" required="false" hint="title of the site"> 
		<cfargument name="SUBTITLE" type="string" required="false" hint="subtite of the site"> 
		<cfargument name="PARENTSITEID" type="string" required="false" default="0" hint="id for the parentsite"> 
		<cfargument name="SCITY" default="0" type="string" required="false" hint="city for the site"> 
		<cfargument name="SSTATE" default="0" type="string" required="false" hint="state for the site"> 
		<cfargument name="SITEAGENCYID" default="0" type="string" required="false" hint="siteagencyid"> 
		<cfargument name="CLIENTSITEID" default="0" type="string" required="false" hint="client user id"> 
		<cfargument name="SITEDESCRIPTION" default="0" type="string" required="false" hint="site description"> 
		<cfargument name="USEMISSINGNUMBERS" type="string" required="false" default="false" hint="use missing numbers for clientuserid"> 
		<cfargument name="STARTMISSINGNUMBERS" type="string" required="false" default="1" hint="number you want to start using your missing numbers for clientuserid"> 
		<cfargument name="orgphone" default="0" type="string" required="false" hint="phone number you want to display on the site">
		<cfargument name="ORGNAME" default="0" type="string" required="false" hint="name of the organization">
		<cfargument name="DEFAULTAREACODE" default="0" type="string" required="false" hint="default area code for the site">
		<cfargument name="COMMENTEMAIL" default="0" type="string" required="false" hint="email address that the comments for the site would go to">
		<cfargument name="CC_COMMENTEMAIL" default="0" type="string" required="false" hint="CC email address that the comments for the site would go to">
		<cfargument name="FLATTEN2HTML" default="0" type="string" required="false" hint="I am the datasource for storing the sites">
		<cfargument name="ALTNAMEDB" default="0" type="string" required="false" hint="I am the datasource for storing the sites">
		<cfargument name="ALTDSN" default="0" type="string" required="false" hint="I am the datasource for storing the sites">
		<cfargument name="TINYTHUMB" type="string" required="false" default="60" hint="size of tiny thumbnail image">
		<cfargument name="SMALLTHUMB" type="string" required="false" default="80" hint="size of small thumbnail image">
		<cfargument name="MEDTHUMB" type="string" required="false" default="400" hint="size of medium thumbnail image">
		<cfargument name="LARGETHUMB" type="string" required="false" default="500" hint="size of larg thumbnail image">
		<cfargument name="EXTPOP3" default="0" type="string" required="false" hint="External pop3 server">
		<cfargument name="EXTSMTP" default="0" type="string" required="false" hint="external smtp server">
		<cfargument name="EXTFTP" default="0" type="string" required="false" hint="external ftp server">
		<cfargument name="EXTFTPACCT" default="0" type="string" required="false" hint="external ftp account name">
		<cfargument name="EXTFTPPASSWORD" default="0" type="string" required="false" hint="external ftp password">
		<cfargument name="EXTFTPPATH" default="0" type="string" required="false" hint="external ftp path">
		<cfargument name="NUMNAV" default="0" type="string" required="false" hint="number of navigations for the site">
		<cfargument name="VOLUNTEERSCHEDULE" default="0" type="string" required="false" hint="whether or not this site utilzes voluteer scheduling">
		<cfargument name="HEARDABOUTUS" default="0" type="string" required="false" hint="whether or not this site utilizes heard about us">
		<cfargument name="layoutid" default="0" type="string" required="false" hint="Id of the template for quick design sites">
		<cfargument name="colorschemeid" default="0" type="string" required="false" hint="color scheme id for quick design sites">
		<cfargument name="fontfamilyid" default="0" type="string" required="false" hint="font family id for sites">
		<cfargument name="gallerythumbstyle" default="0" type="string" required="false" hint="Thumb style for gallery e.g. rounded_corners or reflection">
		<cfargument name="imagesthumbstyle" default="0" type="string" required="false" hint="Image thumb style e.g. rounded_corners or reflection">
		<cfargument name="imagesperrow" default="0" type="string" required="false" hint="No of images per row">
		<cfargument name="imagesperpage" default="0" type="string" required="false" hint="No of images per page">
		<cfargument name="parentid" default="0" type="string" required="false" hint="Parent ID">
		<cfargument name="passwordneeded" default="-1" type="string" required="false" hint="0 if password is not needed during registration, 1 password is needed during registration">
		<cfargument name="addressneeded" default="-1" type="string" required="false" hint="1 if address is needed, 0 if address is not needed">
		<cfargument name="phoneneeded" default="-1" type="string" required="false" hint="1 if phone is needed, 0 if phone is not needed">
		<cfargument name="showthemepicker" default="-1" type="string" required="false" hint="1 if theme picker should be shown on site, 0 if theme picker should not be shown on site">
		<cfset var updateMySite = 0>
		<cfquery name="updateMySite" datasource="#arguments.sitedsn#">
		UPDATE SITE
		SET	VERSIONID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mytime.createTimeDate()#">
		<cfif arguments.layoutid NEQ 0>
		, LAYOUTID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.layoutid#">
		</cfif>
		<cfif arguments.parentid NEQ 0>
		, PARENTSITEID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PARENTID#">
		</cfif>
		<cfif arguments.colorschemeid NEQ 0>
		, COLORSCHEMEID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.colorschemeid#">
		</cfif>
		<cfif arguments.fontfamilyid NEQ 0>
		, FONTFAMILYID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fontfamilyid#">
		</cfif>
		<cfif arguments.gallerythumbstyle NEQ 0>
		, GALLERYTHUMBSTYLE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gallerythumbstyle#">
		</cfif>
		<cfif arguments.imagesthumbstyle NEQ 0>
		, IMAGESTHUMBSTYLE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesthumbstyle#">
		</cfif>
		<cfif arguments.imagesperrow NEQ 0>
		, IMAGESPERROW=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesperrow#">
		</cfif>
		<cfif arguments.imagesperpage NEQ 0>
		, IMAGESPERPAGE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imagesperpage#">
		</cfif>
		<cfif arguments.passwordneeded NEQ -1>
		, PASSWORDNEEDED=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.passwordneeded#">
		</cfif>
		<cfif arguments.addressneeded NEQ -1>
		, ADDRESSNEEDED=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressneeded#">
		</cfif>
		<cfif arguments.addressneeded NEQ -1>
		, PHONENEEDED=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phoneneeded#">
		</cfif>
		<cfif arguments.addressneeded NEQ -1>
		, SHOWTHEMEPICKER=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.showthemepicker#">
		</cfif>
		<cfif arguments.parentsiteid neq 0>
		, PARENTSITEID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentsiteid#">
		</cfif>
		<cfif arguments.sitename neq 0>
		, SITENAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sitename#">
		</cfif>
		<cfif arguments.sitetitle neq 0>
		, SITETITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sitetitle#">
		</cfif>
		<cfif arguments.siteurl neq 0>
		, SITEURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteurl#">
		</cfif>
		<cfif arguments.HEARDABOUTUS neq 0>
		, HEARDABOUTUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.HEARDABOUTUS#">
		</cfif>
		<cfif arguments.VOLUNTEERSCHEDULE neq 0>
		, VOLUNTEERSCHEDULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VOLUNTEERSCHEDULE#">
		</cfif>
		<cfif arguments.status neq 0>
		, STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
		</cfif>
		<cfif arguments.usemissingnumbers neq 0>
		, USEMISSINGNUMBERS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.usemissingnumbers#">
		</cfif>
		<cfif arguments.usemissingnumbers neq 0>
		, IMAGEPATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imgpath#">
		</cfif>
		<cfif arguments.startmissingnumbers neq 0>
		, STARTMISSINGNUMBERS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.startmissingnumbers#">
		</cfif>
		<cfif arguments.SITEDESCRIPTION neq 0>
		, DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITEDESCRIPTION#">
		</cfif>
		<cfif arguments.SITEKEYWORDS neq 0>
		, SITEKEYWORDS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITEKEYWORDS#">
		</cfif>
		<cfif arguments.PRINTCSS neq 0>
		, PRINTCSS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRINTCSS#">
		</cfif>
		<cfif arguments.SCREENCSS neq 0>
		, SCREENCSS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SCREENCSS#">
		</cfif>
		<cfif arguments.ORGPHONE neq 0>
		, PHONE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orgphone#">
		</cfif>
		<cfif arguments.orgname neq 0>
		, ORGNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orgname#">
		</cfif>
		<cfif arguments.scity neq 0>
		, CITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SCITY#">
		</cfif>
		<cfif arguments.SSTATE neq 0>
		, STATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSTATE#">
		</cfif>
		<cfif arguments.SUBTITLE neq 0>
		, SUBTITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SUBTITLE#">
		</cfif>
		<cfif arguments.CLIENTSITEID neq 0>
		, CLIENTSITEID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLIENTSITEID#">
		</cfif>
		<cfif arguments.defaultareacode neq 0>
		, DEFAULTAREACODE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEFAULTAREACODE#">
		</cfif>
		<cfif arguments.commentemail neq 0>
		, COMMENTEMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMMENTEMAIL#">
		</cfif>
		<cfif arguments.cc_commentemail neq 0>
		, CC_COMMENTEMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CC_COMMENTEMAIL#">
		</cfif>
		<cfif arguments.flatten2html neq 0>
		, flatten2html = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.flatten2html#">
		</cfif>
		<cfif arguments.altnamedb neq 0>
		, altnamedb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.altnamedb#">
		</cfif>
		<cfif arguments.altdsn neq 0>
		, altdsn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.altdsn#">
		</cfif>
		<cfif arguments.smallthumb neq 0>
		, smallthumb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.smallthumb#">
		</cfif>
		<cfif arguments.medthumb neq 0>
		, medthumb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.medthumb#">
		</cfif>
		<cfif arguments.largethumb neq 0>
		, largethumb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.largethumb#">
		</cfif>
		<cfif arguments.extpop3 neq 0>
		, extpop3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extpop3#">
		</cfif>
		<cfif arguments.extsmtp neq 0>
		, extsmtp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extsmtp#">
		</cfif>
		<cfif arguments.extftp neq 0>
		, extftp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extftp#">
		</cfif>
		<cfif arguments.extftppath neq 0>
		, extftppath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extftppath#">
		</cfif>
		<cfif arguments.extftpacct neq 0>
		, extftpacct = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extftpacct#">
		</cfif>
		<cfif arguments.extftppassword neq 0>
		, extftppassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extftppassword#">
		</cfif>
		<cfif arguments.numnav neq 0>
		, navnum = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.numnav#">
		</cfif>	
		WHERE SITEID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.siteid#">
	</cfquery>
	<!---<cfinvoke component="webpage" method="writeSiteMapXML" weburl="#arguments.SITEURL#">--->
	</cffunction>
	
	<!--- tested and working --->
	<cffunction name="updateSiteStatus" access="public" returntype="void" hint="I update the status of the site in the database">
		<cfargument name="sitedsn" type="string" required="false" default="deltasystem" hint="I am the datasource for storing the sites">
		<cfargument name="siteid" type="string" required="true" hint="id of the site"> 
		<cfargument name="STATUS" type="string" required="false" default="DEV" hint="status of the site"> 
		<cfquery name="updateSiteStatus" datasource="#arguments.sitedsn#">
		UPDATE SITE
		SET STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
		WHERE SITEID=<cfqueryparam value="#siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<!--- tested and working --->
	<cffunction name="deleteAllSiteData" access="public" returntype="void" hint="I delete all of the data from the database">
		<cfargument name="siteurl" type="string" required="true" hint="I am the siteurl of the site you need to delete all of the data from">
		<cfset var deleteSiteData=0>
			
		<!--- if this is a jbf subsite, set it up correctly --->
		<cfif listcontainsnocase(#arguments.siteurl#, "jbfsale", ".")>
			<cfquery name="deleteSiteData" datasource="#arguments.siteurl#">
				delete from LASTVISITS;
				delete from HAU2PEOPLE;
				delete from HAU2EVENT;	
				delete from HEARDABOUTUS;
				
				delete from FILETOIDPOOL;
				
				delete from ANSWERS;
				delete from RESULTS;
				delete from PEOPLESURVEYED;
				delete from QRELATION;
				delete from ANSWERCHOICES;
				delete from QUESTIONS;
				delete from SURVEY;
				
				delete from REMINDERLOG
				delete from SUBSCRIPTION_RECORD
				delete from VIEWLOG;
				delete from TIMEREMAINING;
				delete from SUBSCRIPTIONACTIVATION;
				delete from SUBSCRIPTIONREMINDER;
				delete from SUBSCRIPTIONTOIP;
				delete from SUBSCRIPTION;
				delete from SUBSCRIBED;
				delete from SUBSCRIPTIONPLANS;
				delete from DEFAULTPLAN;
				delete from TERMMEASURE;
				
				delete from CARTOWNER;
				delete from CART2ITEM;
				delete from CART;
				
				delete from COUPOUNUSED;
				delete from COUPOUN;
				delete from THENTABLE;
				delete from IFTABLE;
				delete from DAMAGED;
				delete from RETURNEDPRODUCT;
				delete from SALESRECORD;
				delete from TRANSACTIONS;
				delete from PRICE;
				delete from PRODUCTGROUP;
				delete from PRODUCTLOG;
				delete from ITEMIMAGES;
				delete from PRODUCT;
				delete from PRICENAMES;
				delete from PRODUCTCATEGORY;
				
				delete from VIDEOLENGTH
				Delete from USERVIEW
				Delete from VIEWRECORD;
				Delete from SAMPLEMEDIA;
				Delete from VIDEO_TO_CATEGORY;
				Delete from VIDEOLIB;
				Delete from VIDEOCATEGORY;
				
				delete from IDPOOL;
				
				delete from qdcmsBLOGENTRYTOBLOGCAT;
				delete from qdcmsBLOGENTRYTOBLOG;
				delete from qdcmsBLOGENTRY;
				delete from qdcmsBLOGCATEGORY;
				delete from qdcmsBLOG;
				
				delete from COMMENTSORT;
				delete from COMMENT;
				
				delete from WINNER;
				delete from CONTESTENTRY;
				delete from CONTEST;
				
				delete from POSTREPORT;
				delete from MSGSTO;
				delete from PRIVMSGS;
				delete from TOPICWATCH;
				delete from POSTS;
				delete from TOPICS;
				delete from FORUMS_RELATIONS;
				delete from FORUMS;
				
				delete from NEWSLETTERDELETEVIRTUAL;
				delete from NEWSLETTERTOEMAILTYPE;
				delete from NEWSLETTERTOUSERGROUPEXCLUDE;
				delete from NEWSLETTERVIEWED;
				delete from NEWSLETTERBOUNCED;
				delete from NEWSLETTERQUEUE;
				delete from NEWSLETTERTRACKING;
				delete from NEWSLETTERTEMPLATE;
				delete from NEWSLETTERTOUSERGROUP;
				delete from NEWSLETTER;
				
				delete from AD_TO_ZONE;
				delete from DAILY_IMPRESSIONS;
				delete from IMPRESSION_COUNTS;
				delete from IMPRESSION_TEMP;
				delete from IMPRESSION_RECORD;
				delete from DELETEDADS;
				delete from RENEWAD;
				delete from BANNERAD;
		
				delete from PEOPLE2USERGROUPS;
				
				delete from PEOPLE2EVENT;
				
				delete from ADDRESS;
				delete from NAME;
				
				delete from EVENT2USERGROUP;
				
				delete from IMAGE2IMAGECATEGORY;
				delete from IMAGE;
				
				delete from FILECATEGORY;
				delete from FILES;
				
				delete from REPEATINGEVENTS;
				delete from EVENTVERSION;
				delete from EVENT;
				
				delete from IMAGE;
				delete from IMAGECATEGORY;
				delete from SITESECURITY;
				</cfquery>
		<cfelse>
			<cfquery name="deleteSiteData" datasource="#arguments.siteurl#">
				delete from LASTVISITS;
				delete from HAU2PEOPLE;
				delete from HAU2EVENT;	
				delete from HEARDABOUTUS;
				
				delete from FILETOIDPOOL;
				
				delete from ANSWERS;
				delete from RESULTS;
				delete from PEOPLESURVEYED;
				delete from QRELATION;
				delete from ANSWERCHOICES;
				delete from QUESTIONS;
				delete from SURVEY;
				
				delete from REMINDERLOG
				delete from SUBSCRIPTION_RECORD
				delete from VIEWLOG;
				delete from TIMEREMAINING;
				delete from SUBSCRIPTIONACTIVATION;
				delete from SUBSCRIPTIONREMINDER;
				delete from SUBSCRIPTIONTOIP;
				delete from SUBSCRIPTION;
				delete from SUBSCRIBED;
				delete from SUBSCRIPTIONPLANS;
				delete from DEFAULTPLAN;
				delete from TERMMEASURE;
				
				delete from CARTOWNER;
				delete from CART2ITEM;
				delete from CART;
				
				delete from COUPOUNUSED;
				delete from COUPOUN;
				delete from THENTABLE;
				delete from IFTABLE;
				delete from DAMAGED;
				delete from RETURNEDPRODUCT;
				delete from SALESRECORD;
				delete from TRANSACTIONS;
				delete from PRICE;
				delete from PRODUCTGROUP;
				delete from PRODUCTLOG;
				delete from ITEMIMAGES;
				delete from PRODUCT;
				delete from PRICENAMES;
				delete from PRODUCTCATEGORY;
				
				
				delete from VIDEOLENGTH
				Delete from USERVIEW
				Delete from VIEWRECORD;
				Delete from SAMPLEMEDIA;
				Delete from VIDEO_TO_CATEGORY;
				Delete from VIDEOLIB;
				Delete from VIDEOCATEGORY;
				
				delete from IDPOOL;
				
				delete from NAVITEMS;
				delete from NAVITEMPARENT;
				
				delete from LINKS;	
				delete from NAVVERSION;		
				delete from WPVERSION;
				delete from WPPARENT;
				delete from WPTEMPLATE;
				
				delete from qdcmsBLOGENTRYTOBLOGCAT;
				delete from qdcmsBLOGENTRYTOBLOG;
				delete from qdcmsBLOGSTATUS;
				delete from qdcmsBLOGENTRY;
				delete from qdcmsBLOGCATEGORY;
				delete from qdcmsBLOG;
				
				delete from COMMENTSORT;
				delete from COMMENT;
				
				delete from WINNER;
				delete from CONTESTENTRY;
				delete from CONTEST;
				
				delete from POSTREPORT;
				delete from MSGSTO;
				delete from PRIVMSGS;
				delete from TOPICWATCH;
				delete from POSTS;
				delete from TOPICS;
				delete from FORUMS_RELATIONS;
				delete from FORUMS;
				
				delete from NEWSLETTERDELETEVIRTUAL;
				delete from NEWSLETTERTOEMAILTYPE;
				delete from NEWSLETTERTOUSERGROUPEXCLUDE;
				delete from NEWSLETTERVIEWED;
				delete from NEWSLETTERBOUNCED;
				delete from NEWSLETTERQUEUE;
				delete from NEWSLETTERTRACKING;
				delete from NEWSLETTERTEMPLATE;
				delete from NEWSLETTERTOUSERGROUP;
				delete from NEWSLETTER;
				
				delete from AD_TO_ZONE;
				delete from DAILY_IMPRESSIONS;
				delete from IMPRESSION_COUNTS;
				delete from IMPRESSION_TEMP;
				delete from IMPRESSION_RECORD;
				delete from DELETEDADS;
				delete from RENEWAD;
				delete from BANNERAD;
		
				delete from PEOPLE2USERGROUPS;
				
				delete from PEOPLE2EVENT;
				
				delete from ADDRESS;
				delete from NAME;
				
				delete from EVENT2USERGROUP;
				
				delete from IMAGE2IMAGECATEGORY;
				delete from IMAGE;
				
				delete from FILECATEGORY;
				delete from FILES;
				
				delete from REPEATINGEVENTS;
				delete from EVENTVERSION;
				delete from EVENT;
				
				delete from IMAGE;
				delete from IMAGECATEGORY;
				delete from SITESECURITY;
				</cfquery>
			</cfif>
	</cffunction>
	
	<cffunction name="validatePage" access="public" returntype="struct" hint="I check a site XML for a specific page and if found return its structure 	otherwise I return a structure for displaying error information">
		<cfargument name="pageXML" type="array" required="true" hint="XML for a specific page">
		<cfset var page = StructNew()>
			<cfif arrayLen(arguments.pageXML)>
				<cfset page = arguments.pageXML[1].XmlAttributes>
				<cfset page.content = arguments.pageXML[1].XmlText>
			<cfelse>
				<cfset page.name = "404 Page Not Found">
				<cfset page.title = page.name>
				<cfset page.id = "404">
				<cfsavecontent variable="page.content">
					<h2 class="error">404 Page Not Found</h2>
					<p>
						There could be a few different reasons for this:
						<ul>
							<li>The page was moved.</li>
							<li>The page no longer exists.</li>
							<li>The URL is slightly incorrect.</li>
						</ul>
					</p>
				</cfsavecontent>
			</cfif>
		<cfreturn page>
	</cffunction>	

	<!--- tested and working --->
	<cffunction name="addDsn" access="public" returntype="void" hint="I add the DSN passed to me to the server(instance) that I am ran on">
		<cfargument name="sitedsn" type="string" required="true" hint="I am the datasource for storing the sites">
		<cfargument name="host" type="string" required="false" hint="IP of database server" default="208.65.113.156"> 
		<cfargument name="pwd" type="string" required="false" hint="password for the database user account" default="spidey01"> 
		<cfargument name="dbusername" type="string" required="false" default="qdelta" hint="username for the database"> 
		<cfargument name="adminpass" type="string" required="false" hint="admin password for cfadmin" default="spidey01">
		<cfargument name="dbtype" type="string" required="false" hint="type of database" default="MSSQLServer">
		<cfargument name="port" type="string" required="false" default="1433" hint="port number">
		<cfscript>
	    //Login is always required. This example uses two lines of code.
	    adminObj = createObject("component","cfide.adminapi.administrator");
	    adminObj.login(arguments.adminpass);
	
	    // Instantiate the data source object.
	    myObj = createObject("component","cfide.adminapi.datasource");
	
	    // Create a DSN.
	    myObj.setMSSQL(
	    	driver=arguments.dbtype, 
	        name=arguments.sitedsn, 
	        host = arguments.host, 
	        port = arguments.port,
	        database = arguments.sitedsn,
	        username = arguments.dbusername,
			password = arguments.pwd,
	        login_timeout = "29",
	        timeout = "23",
	        interval = 6,
	        buffer = "256000",
	        blob_buffer = "64000",
	        setStringParameterAsUnicode = "false",
	        description = siteurl,
	        pooling = true,
	        maxpooledstatements = 999,
	        enableMaxConnections = "true",
	        maxConnections = "299",
	        enable_clob = true,
	        enable_blob = true,
	        disable = false,
	        storedProc = true,
	        alter = true,
	        grant = true,
	        select = true,
	        update = true,
	        create = true,
	        delete = true,
	        drop = false,
	        revoke = false );
		</cfscript>
	</cffunction>
	
	<cffunction name="addLegacySite" access="public" returntype="string" hint="I add a site to the database">
		<cfargument name="SITENAME" type="string" required="true" hint="name of the site"> 
		<cfargument name="SITEURL" type="string" required="true" hint="URL of the site"> 
		<cfargument name="siteid" type="string" required="true" hint="I am the id of the site your are adding">
		<cfargument name="sitedsn" type="string" required="false" default="qdelta" hint="I am the datasource for storing the sites">
		<cfargument name="userid" type="string" required="false" default="1065" hint="I am the id of the person adding the site, I default to Drew's ID">
		<cfargument name="IMAGEPATH" type="string" required="false" hint="path to the images" default="images"> 
		<cfargument name="STATUS" type="string" required="false" default="DEV" hint="status of the site"> 
		<cfargument name="SITEKEYWORDS" type="string" required="false" hint="keywords for the site" default="Site Powered by QuantumDelta"> 
		<cfargument name="PRINTCSS" type="string" required="false" default="print.css" hint="print css for the site"> 
		<cfargument name="SCREENCSS" type="string" required="false" default="screen.css" hint="screen css for the site"> 
		<cfargument name="SITETITLE" type="string" default="" required="false" hint="title of the site"> 
		<cfargument name="SUBTITLE" type="string" default="" required="false" hint="subtite of the site"> 
		<cfargument name="PARENTSITEID" type="string" required="false" default="0" hint="id for the parentsite"> 
		<cfargument name="CITY" type="string" default="" required="false" hint="city for the site"> 
		<cfargument name="STATE" type="string" default="" required="false" hint="state for the site"> 
		<cfargument name="SITEAGENCYID" type="string" default="" required="false" hint="siteagencyid"> 
		<cfargument name="CLIENTSITEID" type="string" default="0" required="false" hint="client user id"> 
		<cfargument name="DESCRIPTION" type="string" default="" required="false" hint="site description"> 
		<cfargument name="USEMISSINGNUMBERS" type="string" required="false" default="false" hint="use missing numbers for clientuserid"> 
		<cfargument name="STARTMISSINGNUMBERS" type="string" required="false" default="1" hint="number you want to start using your missing numbers for clientuserid"> 
		<cfargument name="PHONE" type="string" required="false" default="" hint="phone number you want to display on the site">
		<cfargument name="ORGNAME" type="string" required="false" default="" hint="name of the organization">
		<cfargument name="DEFAULTAREACODE" type="string" required="false" default="" hint="default area code for the site">
		<cfargument name="COMMENTEMAIL" type="string" required="false" default="" hint="email address that the comments for the site would go to">
		<cfargument name="CC_COMMENTEMAIL" type="string" required="false" default="" hint="CC email address that the comments for the site would go to">
		<cfargument name="FLATTEN2HTML" type="string" required="false" default="1" hint="I am the datasource for storing the sites">
		<cfargument name="ALTNAMEDB" type="string" required="false" default="" hint="I am the datasource for storing the sites">
		<cfargument name="ALTDSN" type="string" required="false" default="" hint="I am the datasource for storing the sites">
		<cfargument name="TINYTHUMB" type="string" required="false" default="60" hint="size of tiny thumbnail image">
		<cfargument name="SMALLTHUMB" type="string" required="false" default="80" hint="size of small thumbnail image">
		<cfargument name="MEDTHUMB" type="string" required="false" default="400" hint="size of medium thumbnail image">
		<cfargument name="LARGETHUMB" type="string" required="false" default="500" hint="size of larg thumbnail image">
		<cfargument name="EXTPOP3" type="string" required="false" default="0" hint="External pop3 server">
		<cfargument name="EXTSMTP" type="string" required="false" default="0" hint="external smtp server">
		<cfargument name="EXTFTP" type="string" required="false" default="0" hint="external ftp server">
		<cfargument name="EXTFTPACCT" type="string" required="false" default="0" hint="external ftp account name">
		<cfargument name="EXTFTPPASSWORD" type="string" required="false" default="0" hint="external ftp password">
		<cfargument name="EXTFTPPATH" type="string" required="false" default="0" hint="external ftp path">
		<cfargument name="NAVNUM" type="string" required="false" default="0" hint="number of navigations for the site">
		<cfargument name="VOLUNTEERSCHEDULE" type="string" default="0" required="false" hint="whether or not this site utilzes voluteer scheduling">
		<cfargument name="HEARDABOUTUS" type="string" default="0" required="false" hint="whether or not this site utilizes heard about us">
		<cfargument name="layoutid" default="0" type="string" required="false" hint="Id of the template for quick design sites">
		<cfargument name="colorschemeid" default="0" type="string" required="false" hint="color scheme id for quick design sites">
		<cfargument name="fontfamilyid" default="0" type="string" required="false" hint="font family id for sites">
		<cfargument name="gallerythumbstyle" default="0" type="string" required="false" hint="Thumb style for gallery e.g. rounded_corners or reflection">
		<cfargument name="imagesthumbstyle" default="0" type="string" required="false" hint="Image thumb style e.g. rounded_corners or reflection">
		<cfargument name="imagesperrow" default="0" type="string" required="false" hint="No of images per row">
		<cfargument name="imagesperpage" default="0" type="string" required="false" hint="No of images per page">
		<cfargument name="passwordneeded" default="-1" type="string" required="false" hint="0 if password is not needed during registration, 1 password is needed during registration">
		<cfargument name="addressneeded" default="-1" type="string" required="false" hint="1 if address is needed, 0 if address is not needed">
		<cfargument name="phoneneeded" default="-1" type="string" required="false" hint="1 if phone is needed, 0 if phone is not needed">
		<cfargument name="showthemepicker" default="-1" type="string" required="false" hint="1 if theme picker should be shown on site, 0 if theme picker should not be shown on site">
		<cfset var addMySite=0>
		<cfset var addMySiteVersion=0>
		<cfset timedate=mytime.createtimedate()>
		<cftransaction >
		<cfquery name="qry_OLDaddsite" datasource="qdelta">
		INSERT INTO SITE
			(SITEID, 
			SITENAME,
			CREATEDBYID)
		VALUES
			(<cfqueryparam value="#arguments.siteid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sitename#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">)
		</cfquery>
		<cfquery name="addMySite" datasource="#arguments.sitedsn#">
		INSERT INTO SITEVERSION
		(CREATEDBYID,
		SITEID, 
		VERSIONID,
		PARENTSITEID, 
		SITENAME,
		SITETITLE,
		SITEURL,
		IMAGEPATH,
		STATUS,
		USEMISSINGNUMBERS
		, STARTMISSINGNUMBERS
		, DESCRIPTION
		, CITY
		, STATE)
		VALUES
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.USERID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITEID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#TIMEDATE#">,
			<cfqueryparam value="#arguments.PARENTSITEID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITENAME#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITETITLE#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITEURL#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IMAGEPATH#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.USEMISSINGNUMBERS#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STARTMISSINGNUMBERS#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#">,
			<cfqueryparam value="#arguments.CITY#">, 
			<cfqueryparam value="#arguments.STATE#">)
		</cfquery>
		</cftransaction>
		<cfreturn timedate> 
	</cffunction>
	
	<!--- tested and working --->
	<cffunction name="addDatabase" access="public" returntype="string" hint="I add the database to the SQL server by doing a backup and restore">
		<cfargument name="siteurl" type="string" required="true" hint="the URL for the site you want to add">
		<cfargument name="sourcedb" type="string" required="false" default="hjklaw.com" hint="source database">
			<cfoutput>
			<!--- if this is a jbf subsite, set it up correctly --->
			<cfif listcontainsnocase(#arguments.siteurl#, "jbfsale", ".")>
				<cfquery name="backuprestore" datasource="mymaster">
				BACKUP DATABASE "tulsa.jbfsale.com"
					TO DISK = 'K:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					RESTORE FILELISTONLY 
					   FROM DISK = 'K:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					RESTORE DATABASE "#arguments.siteurl#"
					   FROM DISK =  'K:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					   WITH MOVE 'domains_dat' TO 'K:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.mdf',
					   MOVE 'domains_log' TO 'L:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.ldf';
				</cfquery>
			 <!--- this is not a jbf subsite --->
			 <cfelse>
				<cfquery name="backuprestore" datasource="mymaster">
				BACKUP DATABASE "#arguments.sourcedb#"
					TO DISK = 'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					RESTORE FILELISTONLY 
					   FROM DISK = 'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					RESTORE DATABASE "#arguments.siteurl#"
					   FROM DISK =  'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.bak'
					   WITH MOVE 'domains_dat' TO 'H:\db\ MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.mdf',
					   MOVE 'domains_log' TO 'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.ldf';
				</cfquery>
			</cfif>
			<!--- email David to let him know --->
			<cfmail to="byte@web-host.net" cc="drew@quantumdelta.com" subject="New Database created: #arguments.siteurl#" from="Drew Harris<drew@quantumdelta.com>">
			Dude, there was a new database added to the database server today at #mytime.createtimedate()#.  Here is the database name: #arguments.siteurl#.  It was created like(FROM DISK =  'K:\MSSQL10.CELEBRIANSQL\MSSQL\DATA\spidey.bak' or qdcmsJBF.bak if it was a JBF DB 
					   WITH MOVE 'domains_dat' TO 'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.mdf',
					   MOVE 'domains_log' TO 'H:\db\MSSQL10.CELEBRIANSQL\MSSQL\DATA\#arguments.siteurl#.ldf';).
			</cfmail>
			</cfoutput>
	</cffunction>
	
	<!--- not tested --->
	<cffunction name="addpeople2site" access="public" returntype="string" hint="I add people to site">
		<cfargument name="ds" required="false" default="deltasystem" hint="I am the data source. I default to deltasystem">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person being added">
		<cfargument name="relationshipid" required="false" default="" hint="I dont know what this is"> 
		<cfargument name="sitesecurityid" required="false" default="0" hint="Again i dont know what this is">
		<cfargument name="roleid" required="false" default="2" hint="role of the person added to the security">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.ds#">
			INSERT INTO PEOPLE2SITE
			(
				NAMEID,
				SITEID,
				RELATIONSHIPID,
				SITESECURITYID,
				ROLEID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.relationshipid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.sitesecurityid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getSiteUrl" access="public" returntype="string" hint="I get url of the site if siteid is passed to me">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT 
				SITEURL 
			FROM SITE 
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#"  cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.SITEURL>
	</cffunction>
	
	<cffunction name="isLegacySite" access="public" returntype="string" hint="I get url of the site if siteid is passed to me">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT 
				SYSTEM
			FROM SITE 
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#"  cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.SYSTEM EQ 1>
			<cfreturn true>
		<cfelseif get.SYSTEM EQ 2>
			<cfreturn true>
		<cfelseif get.SYSTEM EQ ''>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="getSystemId" access="public" returntype="string" hint="I get id of the system. 1: Old Legacy, 2: Legacy, 3: QDCMS">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT SYSTEM FROM SITE
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#"  cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.SYSTEM>
	</cffunction>
	
	<cffunction name="setSiteAsUpgraded" access="public" returntype="void" hint="I set as site as QDCMS powered site">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var update=0>
		<cfquery name="update" datasource="deltasystem">
			UPDATE SITE SET
			SYSTEM=3
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	<!--- not yet written --->
	<cffunction name="deleteSite" access="public" returntype="void" hint="I am not yet written, I completely delete the site from the database">
	</cffunction>
	
	<!--- not yet written --->
	<cffunction name="getPendingQuickDesignSites" access="public" returntype="void" hint="I am not yet written, I get the pending QuickDesign Sites">
	</cffunction>
	
	<!--- not yet written--->
	<cffunction name="publishQuickDesign" access="public" returntype="void" hint="I am not yet written, I move a QuickDesign temp site to the production database">
	</cffunction>
	
</cfcomponent>