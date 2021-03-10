<cfcomponent hint="Security">
	<cfobject component="timeDateConversion" name="mytime">
	<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="init" access="public" returntype="void" hint="I run createSiteSecurityTables">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfinvoke component="Security" method="createSiteSecurityTables" argumentcollection="#arguments#">
	</cffunction>
	
	<cffunction name="getAcl" access="public" returntype="query" hint="I get access control list">
		<cfargument name="siteid" required="true" type="string" hint="I am the id of the site">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of the person">
		<cfargument name="roleid" required="true" type="string" hint="I am the roleid">
		<cfset var get=0>
		<cfswitch expression="#arguments.roleid#">
			<cfcase value="4,5,6,7">
				
			</cfcase>
			<cfcase value="3">
			</cfcase>
			<cfcase value="2">
			</cfcase>
			<cfcase value="1">
				
			</cfcase>
			<cfdefaultcase>
				<cfquery name="get" datasource="deltasystem">
					SELECT
						SITEMODULES_TO_USER.NAMEID,
						SITEMODULES_TO_USER.SITEID,
						SITEMODULES_TO_USER.MODULEID,
						SITEMODULES_TO_USER.PERMISSION,
						SECTIONS.SECTIONID,
						SECTIONS.SECTION,
						SITEMODULES.MODULE,
						SECTIONS.SECTION_SORTORDER,
						SITEMODULES.MODULE_SORTORDER
					FROM SITEMODULES_TO_USER, SITEMODULES, SECTIONS, SECTION_TO_SITEMODULES
					WHERE SITEMODULES_TO_USER.SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
					AND SITEMODULES_TO_USER.NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
					AND SITEMODULES_TO_USER.MODULEID=SITEMODULES.MODULEID
					AND MODULES.MODULEID=SECTION_TO_SITEMODULES.MODULEID
					AND SECTION_TO_SITEMOUDULES.SECTIONID=SECTIONS.SECTIONID
					ORDER BY SECTIONS.SECTION_SORTORDER,SITEMODULES.MODULE_SORTORDER
				</cfquery>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="authenicate" access="public" returntype="struct" hint="Authenicate the username and password">
		<cfargument name="dsn" type="string" required="false" default="deltasystem">
		<cfargument name="myusername" type="string" required="true">
		<cfargument name="pass" type="string" required="true">
		<cfargument name="status" type="string" required="false" default="1">
		<cfset var checkusername=0>
		<cfset var checkpassword=0>
		<cfset var secure=structNew()>
		<cfset var updatelastlogin=0>
		<cfset var getLastSite=0>
			<!--- check username --->
			<cfquery name="checkusername" datasource="#arguments.dsn#">
			SELECT 
				NAMEID,
				USERNAME
			FROM NAME
			WHERE USERNAME LIKE <cfqueryparam value="#arguments.myusername#">
			AND STATUS=<cfqueryparam value="#arguments.status#">
			</cfquery>
			<cfif checkusername.recordcount gt 0>
				<!--- check password --->
				<cfquery name="checkpassword" datasource="#arguments.dsn#" maxrows="1">
				SELECT
					NAMEID,
					USERNAME,
					FIRSTNAME,
					LASTNAME,
					WEMAIL,
					HEMAIL,
					PASSWORD,
					COMPANY,
					DESCRIPTION
					<cfif dsn eq "deltasystem">
						, LASTLOGIN
						, LASTSITEID
					</cfif>
				FROM NAME
				WHERE PASSWORD = <cfqueryparam value="#arguments.pass#">
				AND USERNAME = <cfqueryparam value="#arguments.myusername#">
				</cfquery>
				<cfif checkpassword.recordcount gt 0>
					<cfset secure.authenicated = 1>
					<cfset secure.message = "Thank you for logging in!">
					<cfset secure.userid="#checkpassword.NAMEID#">
					<cfset secure.username="#checkpassword.username#">
					<cfset secure.wemail="#checkpassword.WEMAIL#">
					<cfset secure.hemail="#checkpassword.HEMAIL#">
					<cfset secure.firstname="#checkpassword.firstname#">
					<cfset secure.lastname="#checkpassword.lastname#">
					<cfset secure.company="#checkpassword.company#">
					<cfset secure.description="#checkpassword.description#">
					<cfif dsn eq "deltasystem">
						<cfset secure.lastlogin=checkpassword.lastlogin>
						<cfset secure.lastsiteid=checkpassword.lastsiteid>
					<cfelse>
						<cfset secure.lastlogin=0>
						<cfset secure.lastsiteid=0>
					</cfif>
				<cfelse>
					<cfset secure.authenicated = 0>
					<cfset secure.message = "Your password is incorrect. You may have it emailed to you">
				</cfif>
			<cfelse>
				<!---username was not found --->
				<cfset secure.authenicated = 0>
				<cfset secure.message = "Your username was not found">
			</cfif>
		<cfreturn secure>
	</cffunction>
	
	<cffunction name="jbfauthenicate" access="public" returntype="struct" hint="Authenicate the username and password">
		<cfargument name="dsn" type="string" required="false" default="deltasystem">
		<cfargument name="myusername" type="string" required="true">
		<cfargument name="pass" type="string" required="true">
		<cfset var check=0>
		<cfset var secure=structNew()>
			
		<!--- check username --->
		<cfquery name="check" datasource="#arguments.dsn#">
			SELECT 
				NAMEID,
				CLIENTUSERID,
				FIRSTNAME,
				LASTNAME,
				PASSWORD
			FROM NAME
			WHERE CLIENTUSERID = <cfqueryparam value="#arguments.myusername#">
		</cfquery>
		<cfif check.recordcount GT 0>
			<cfif Compare(pass,check.password) EQ 0>
				<cfset secure.authenicated = 1>
				<cfset secure.message = "Thank you for logging in!">
				<cfset secure.userid="#check.NAMEID#">
				<cfset secure.firstname="#check.firstname#">
				<cfset secure.lastname="#check.lastname#">
			<cfelse>
				<cfset secure.authenicated = 0>
				<cfset secure.message = "Sorry, your password is incorrect, you may have it emailed to you">
			</cfif>
		<cfelse>
			<!---username was not found --->
			<cfset secure.authenicated = 0>
			<cfset secure.message = "Sorry, your username was not found">
		</cfif>
		<cfreturn secure>
	</cffunction>
	
	<cffunction name="getjbfpass" access="public" returntype="query" hint="I return username and password">
		<cfargument name="dsn" required="true" type="string" hint="name of the datasource">
		<cfargument name="email" required="true" type="string" hint="Email of the user">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.dsn#">
			SELECT TOP 1
				FIRSTNAME,
				LASTNAME,
				CLIENTUSERID,
				PASSWORD
			FROM NAME
			WHERE STATUS=1
			AND
			(
				HEMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
				OR WEMAIL=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="ssauthenicate" access="public" returntype="struct" hint="Authenicate the username and password">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="myusername" type="string" required="yes">
		<cfargument name="pass" type="string" required="yes">
		<cfset var checkusername=0>
		<cfset var checkpassword=0>
		<cfset var secure=structNew()>
		<cfset var updatelastlogin=0>
		<cfset var getLastSite=0>
			<!--- check username --->
			<cfquery name="checkusername" datasource="#dsn#">
			SELECT 
				SECURITYID,
				USERNAME
			FROM SITESECURITY
			WHERE USERNAME LIKE <cfqueryparam value="#myusername#">
			</cfquery>
			<cfif checkusername.recordcount gt 0>
				<!--- check password --->
				<cfquery name="checkpassword" datasource="#dsn#" maxrows="1">
				SELECT
					SITESECURITYID,
					USERNAME,
					FIRSTNAME,
					LASTNAME,
					EMAIL,
					STATUS,
					PASSWORD,
					MASTERROLE
				FROM SITESECURITY
				WHERE PASS = <cfqueryparam value="#pass#">
				AND USERNAME = <cfqueryparam value="#myusername#">
				</cfquery>
				<cfif checkpassword.recordcount gt 0>
					<cfset secure.authenicated = 1>
					<cfset secure.message = "Thank you for logging in!">
					<cfset secure.userid="#checkpassword.sitesecurityid#">
					<cfset secure.username="#checkpassword.username#">
					<cfset secure.email="#checkpassword.EMAIL#">
					<cfset secure.firstname="#checkpassword.firstname#">
					<cfset secure.lastname="#checkpassword.lastname#">
				<cfelse>
					<cfset secure.authenicated = 0>
					<cfset secure.message = "Sorry, your password is incorrect, you may have it emailed to you">
				</cfif>
			<cfelse>
				<!---username was not found --->
				<cfset secure.authenicated = 0>
				<cfset secure.message = "Sorry, your username was not found">
			</cfif>
		<cfreturn secure>
	</cffunction>
	
	<cffunction name="checkUsernameAndLength" access="public" returntype="Numeric" hint="I check if the username already exists: no error: 0, username exists: 1 short username: 2, long username: 3">
		<!--- no error: 0, username exists: 1 short username: 2, long username: 3 --->
		<cfargument name="dsn" required="true" type="String" hint="Datasource">
		<cfargument name="shortest" required="false" default="3" hint="the shortest length of username you want to accept">
		<cfargument name="longest" required="false" default="60" hint="the longest length of username you want to accept">		
		<cfargument name="myusername" type="String" required="true" hint="username">
		<cfset var checkemail=0>
		<cfquery name="checkemail" datasource="#dsn#">
			SELECT 
			USERNAME
			FROM NAME
			WHERE
			USERNAME=<cfqueryparam value="#myusername#">
		</cfquery>
		<cfif checkemail.recordcount gt 0>
			<cfreturn 1>
		<cfelseif len(myusername) lt #shortest#>
			<cfreturn 2>
		<cfelseif len(myusername) gt #longest#>
			<cfreturn 3>
		<cfelse>
			<cfreturn 0>	
		</cfif>
	</cffunction>

	<cffunction name="checkPassword" access="public" returntype="Numeric" hint="I check if the password is of correct size. results: no error: 0, short password: 1, long password: 2">
		<cfargument name="mypassword" required="true" type="String" hint="Password ">
		<cfargument name="shortest" required="false" default="3" hint="the shortest length of password you want to accept">
		<cfargument name="longest" required="false" default="60" hint="the longest length of password you want to accept">		
		<cfif len(mypassword) lt #shortest#>
			<cfreturn 1>
		<cfelseif len(mypassword) gt #longest#>
			<cfreturn 2>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>	
	
	<cffunction name="checkEmail" access="public" returntype="boolean" hint="I check if the wemail address is already registered">
	<cfargument name="dsn" required="true" type="String" hint="Datasource">
	<cfargument name="email" type="String" required="true" hint="User's email address">
	<cfset var checkmail=0>
	<cfquery name="checkemail" datasource="#dsn#">
		SELECT 
		WEMAIL
		FROM NAME
		WHERE
		WEMAIL=<cfqueryparam value="#email#">
	</cfquery>
	<cfif checkemail.recordcount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
	</cffunction>
	
	<cffunction name="checkSecurityEmail" access="public" returntype="boolean" hint="I check if the email address is already registered">
	<cfargument name="dsn" required="true" type="String" hint="Datasource">
	<cfargument name="email" type="String" required="true" hint="User's email address">
	<cfset var checkmail=0>
	<cfquery name="checkemail" datasource="#dsn#">
		SELECT 
		EMAIL
		FROM SITESECURITY
		WHERE
		EMAIL=<cfqueryparam value="#email#">
	</cfquery>
	<cfif checkemail.recordcount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
	</cffunction>
	
	<cffunction name="getRandomUsername" access="public" returntype="String" Hint="I generate a random username">
		<cfset var ststring=0>
		<cfset var randomusername=0>
		<cfset ststring=structNew()>
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

	<cffunction name="generatePassword" hint="Generates a random password from a list of distinct characters." returntype="String" access="Public" output="No">
		<!--- Input Arguments --->
		<cfargument name="Length" type="Numeric" required="no" hint="The length of the password to be returned." />
		<!--- Set Local Scope --->
		<cfset var local = StructNew() />
		<cfset var Password_DefaultLen=8>
		<!--- Set the length --->
		<cfif NOT IsDefined("arguments.Length")>
			<cfset arguments.Length = Password_DefaultLen>
		</cfif>
		
		<cfset local.CharSet = "QWERTYUPASDFGHJKLZXCVBNM23456789" />
		<cfset local.CurChar = "" />
		<cfset local.Password = "" />
		<cfloop from="1" to="#arguments.Length#" index="local.Cnt">
			<cfset local.CurChar = Mid(local.CharSet, RandRange(1, Len(local.CharSet)), 1) />
			<cfset local.Password = local.Password & local.CurChar />
		</cfloop>
		<!--- Return the Password --->
		<cfreturn local.Password />
	</cffunction> 
	
	<cffunction name="getpermissions" access="public" returntype="struct" hint="I get the permissions for the user passed to me">
		<cfargument name="userid" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfset var getpermissions=0>
		<cfset var permissions=structNew()>
		<cfset var lc_circuit=0>
		<cfquery name="getpermissions" datasource="#dsn#">
		SELECT     
			NAME.NAMEID AS USERID, 
			NAME.USERNAME, 
			PEOPLE2USERGROUPS.NAMEID AS groupuserid, 
			PEOPLE2USERGROUPS.USERGROUPID, 
			USERGROUPS.USERGROUPNAME, 
			PERMISSIONSTOGROUPS.USERGROUPID AS permissiongroupid, 
			PERMISSIONSTOGROUPS.PERMISSIONID AS grouppermissionid, 
			PERMISSIONS.PERMISSIONID, 
			PERMISSIONS.PERMISSIONNAME, 
			PERMISSIONS.CIRCUITID AS permissioncircuitid, 
			CIRCUITVERSION.CIRCUITID, 
			CIRCUITVERSION.CIRCUITNAME AS CIRCUIT, 
			CIRCUITVERSION.CIRCUITPARENTID,
			CIRCUITVERSION.CIRCUITDISPLAY
		FROM
			NAME, 
			USERGROUPS, 
			PERMISSIONSTOGROUPS,
			PERMISSIONS,
			PEOPLE2USERGROUPS,
			CIRCUITVERSION 
		WHERE     
			NAME.NAMEID = <cfqueryparam value="#userid#">
			AND CIRCUITVERSION.CIRCUITID = PERMISSIONS.CIRCUITID 
			AND PERMISSIONSTOGROUPS.PERMISSIONID = PERMISSIONS.PERMISSIONID 
			AND USERGROUPS.USERGROUPID = PERMISSIONSTOGROUPS.USERGROUPID
			AND USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID 
			AND NAME.NAMEID = PEOPLE2USERGROUPS.NAMEID
		ORDER BY 
			CIRCUITVERSION.CIRCUITDISPLAY
		</cfquery>
		<!--- Set the client users circuits and permissions to client scoped variables --->
		<cfset permissions.permissions = "">
		<cfoutput query="getpermissions" group="permissionid">
			<cfset lc_circuit = "#lcase(circuitdisplay)#">
			<cfset permission = "#lc_circuit#.#permissionname#">
			<cfset permissions.permissions = "#listappend(permissions.permissions, permission, ":")#">
		</cfoutput>
		<cfset permissions.modules = "#ValueList(getpermissions.CIRCUITDISPLAY)#">
		<cfreturn permissions>
	</cffunction>
	
	<cffunction name="getusergroups" access="public" returntype="struct" hint="I get the usergroups for the user passed to me">
		<cfargument name="userid" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfset var getgroups=0>
		<cfset var usergroups=0>
		<cfquery name="getgroups" datasource="#dsn#">
		SELECT		
			USERGROUPS.USERGROUPID AS GROUPID,
			USERGROUPS.USERGROUPNAME AS NAME,
			USERGROUPS.USERGROUPDESCRIPTION AS DESCRIPTION
		FROM 
			USERGROUPS,
			PEOPLE2USERGROUPS
		WHERE PEOPLE2USERGROUPS.NAMEID = <cfqueryparam value="#userid#">
		AND USERGROUPS.USERGROUPID = PEOPLE2USERGROUPS.USERGROUPID
		</cfquery>
		<cfset usergroups.mygroups="">
		<cfset usergroups.mygroupnames="">
		<cfoutput query="getgroups">
			<cfset usergroups.mygroups="#listappend(usergroups.mygroups, groupid)#">
			<cfset usergroups.mygroupnames="#listappend(usergroups.mygroupnames, name)#">
		</cfoutput>
		<cfreturn usergroups>
	</cffunction>
	
	<cffunction name="getsites" access="public" returntype="string" hint="I get the sites for the user passed to me, I return a list of the site ids">
		<cfargument name="userid" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfset var getsites=0>
		<cfset var sites=0>
		<cfquery name="getsites" datasource="#dsn#">
		SELECT     
			SITEID, 
			NAMEID AS USERID,
			SITESECURITYID
		FROM
			PEOPLE2SITE 
		WHERE
			NAMEID = <cfqueryparam value="#userid#">
			AND RELATIONSHIPID = '1'
		</cfquery>
		<cfset sites = "#ValueList(getsites.siteid)#">
		<cfreturn sites>
	</cffunction>
	
	<cffunction name="getmysites" access="public" returntype="query" hint="I get the sites for the user passed to me, I return a query:SITEID, USERID, SITESECURITYID">
		<cfargument name="dsn" type="string" required="yes" hint="The datasource you want to look in">
		<cfargument name="userid" type="string" required="yes" hint="the id of the user you need site info on">
		<cfargument name="siteid" type="string" required="false" default="0" hint="the optional id of a site">
		<cfset var mysites=0>
		<cfquery name="mysites" datasource="#arguments.dsn#">
		SELECT     
			SITEID, 
			NAMEID AS USERID,
			SITESECURITYID
		FROM
			PEOPLE2SITE 
		WHERE
			NAMEID = <cfqueryparam value="#arguments.userid#">
		<cfif arguments.siteid neq "0"> 
		AND SITEID = <cfqueryparam value="#arguments.siteid#">
		</cfif>
		</cfquery>
		<cfreturn mysites>
	</cffunction>
	
	<cffunction name="getSitesWithPermission" access="public" returntype="string" hint="I get the sites for the user passed to me, I return a list of SITEID">
		<cfargument name="userid" type="string" required="yes" hint="the id of the user you need site info on">
		<cfset var mysites=0>
		<cfquery name="mysites" datasource="deltasystem">
		SELECT     
			SITEID
		FROM
			PEOPLE2SITE 
		WHERE
			NAMEID = <cfqueryparam value="#arguments.userid#">
		</cfquery>
		<cfreturn valuelist(mysites.siteid)>
	</cffunction>
	
	<cffunction name="getmyroles" access="public" returntype="query" hint="I get the roles for the info passed to me, I return a query: siteid, userid, roleid">
		<cfargument name="dsn" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="securityid" type="string" default="none" required="false" hint="the securityid for the user you are looking for">
		<cfargument name="userid" type="string" default="none" required="false" hint="the id the for the user you are looking for">
		<cfargument name="roleid" type="string" default="none" required="false" hint="the id the for the site roles you are looking for">
		<cfset var getroles=0>
		<cfquery name="getroles" datasource="#dsn#">
		SELECT     
			SITEID, 
			NAMEID AS USERID,
			SECURITYID,
			ROLEID
		FROM
			USER2ROLE 
		WHERE 1=1
		<cfif userid neq "none">
		AND	NAMEID = <cfqueryparam value="#userid#">
		</cfif>
		<cfif security neq "none">
		AND	SECURITYID = <cfqueryparam value="#securityid#">
		</cfif>
		<cfif roleid neq "none">
		AND ROLEID = <cfqueryparam value="#roleid#">
		</cfif>
		</cfquery>
		<cfreturn getroles>
	</cffunction>
	
	<cffunction name="getmymasterroles" access="public" returntype="query" hint="I get the roles for the info passed to me, I return a query: siteid, userid, roleid">
		<cfargument name="dsn" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="userid" type="string" default="none" required="false" hint="the id the for the user you are looking for">
		<cfargument name="roleid" type="string" default="none" required="false" hint="the id the for the site roles you are looking for">
		<cfset var getroles=0>
		<cfquery name="getroles" datasource="#dsn#">
		SELECT     
			MASTERROLE.ROLEID, 
			MASTERROLE.ROLENAME
		FROM
			NAME2MASTERROLE,
			MASTERROLE 
		WHERE NAME2MASTERROLE.ROLEID = MASTERROLE.ROLEID
		<cfif userid neq "none">
		AND	NAME2MASTERROLE.NAMEID = <cfqueryparam value="#userid#">
		</cfif>
		<cfif roleid neq "none">
		AND MASTERROLE.ROLEID = <cfqueryparam value="#roleid#">
		</cfif>
		ORDER BY MASTERROLE.ROLEID DESC
		</cfquery>
		<cfreturn getroles>
	</cffunction>
	
	<cffunction name="getUsersinRole" access="public" returntype="query" hint="I get the users in a role, I return a query: securityid, userid, firstname, lastname, username, email">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="roleid" type="string" default="none" required="false" hint="the id the for the site roles you are looking for">
		<cfset var usersInRole=0>
		<cfquery name="usersInRole" datasource="#ds#">
		SELECT     
			SITESECURITY.NAMEID AS USERID,
			SITESECURITY.SECURITYID,
			SITESECURITY.FIRSTNAME,
			SITESECURITY.LASTNAME,
			SITESECURITY.USERNAME,
			SITESECURITY.EMAIL
		FROM
			SITESECURITY,
			USER2ROLE 
		WHERE 
			SITESECURITY.SECURITYID=USER2ROLE.SECURITYID
		AND USER2ROLE.ROLEID = <cfqueryparam value="#roleid#">
		</cfquery>
		<cfreturn usersInRole>
	</cffunction>
	
	<cffunction name="searchUsers" access="public" returntype="query" hint="I get the users, I return a query: MASTERNAMEID, securityid, userid, firstname, lastname, username, email">
		<cfargument name="dsn" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="searchType" type="string" required="false" default="exact" hint="The type of search you want to run: fuzzy, exact">
		<cfargument name="masternameid" type="string" required="false" default="0" hint="the masternameid of the user you are searching for">
		<cfargument name="securityid" type="string" default="0" required="false" hint="the securityid of the user you are looking for">
		<cfargument name="nameid" type="string" default="0" required="false" hint="the nameid of the user you are looking for">
		<cfargument name="firstname" type="string" default="0" required="false" hint="the firstname of the user you are looking for">
		<cfargument name="username" type="string" default="0" required="false" hint="the username of the user you are looking for">
		<cfargument name="email" type="string" default="0" required="false" hint="the email of the user you are looking for">
		<cfset var userResults=0> 
		<cfswitch expression="searchType">
			<cfcase value="exact">
				<cfquery name="userResults" datasource="#arguments.dsn#">
				SELECT     
					MASTERNAMEID,
					SECURITYID,
					FIRSTNAME,
					LASTNAME,
					USERNAME,
					EMAIL
				FROM
					SITESECURITY
				WHERE 
					1=1
				<cfif arguments.masternameid neq 0>AND MASTERNAMEID = <cfqueryparam value="#arguments.masternameid#"></cfif>
				<cfif arguments.securityid neq 0>AND SECURITYID = <cfqueryparam value="#arguments.securityid#"></cfif>
				<cfif arguments.firstname neq 0>AND FIRSTNAME = <cfqueryparam value="#arguments.firstname#"></cfif>
				<cfif arguments.username neq 0>AND USERNAME = <cfqueryparam value="#arguments.username#"></cfif>
				<cfif arguments.email neq 0>AND EMAIL = <cfqueryparam value="#arguments.email#"></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="fuzzy">
				<cfquery name="userResults" datasource="#arguments.dsn#">
				SELECT     
					MASTERNAMEID,
					SECURITYID,
					FIRSTNAME,
					LASTNAME,
					USERNAME,
					EMAIL
				FROM
					SITESECURITY
				WHERE 
					1=1
				<cfif arguments.masternameid neq 0>AND masternameid like '%' + <cfqueryparam value="#arguments.masternameid#"> + '%'</cfif>
				<cfif arguments.securityid neq 0>AND SECURITYID like '%' + <cfqueryparam value="#arguments.securityid#"> + '%'</cfif>
				<cfif arguments.firstname neq 0>AND FIRSTNAME like '%' + <cfqueryparam value="#arguments.firstname#"> + '%'</cfif>
				<cfif arguments.username neq 0>AND USERNAME like '%' + <cfqueryparam value="#arguments.username#"> + '%'</cfif>
				<cfif arguments.email neq 0>AND EMAIL like '%' + <cfqueryparam value="#arguments.email#"> + '%'</cfif>
				</cfquery>
			</cfcase>
			<!---Just on some off chance the type var is not specified--->
			<cfdefaultcase>
				<cfquery name="userResults" datasource="#arguments.dsn#">
				SELECT     
					MASTERNAMEID,
					SECURITYID,
					FIRSTNAME,
					LASTNAME,
					USERNAME,
					EMAIL
				FROM
					SITESECURITY
				WHERE 
					1=1
				<cfif arguments.masternameid neq 0>AND MASTERNAMEID = <cfqueryparam value="#arguments.masternameid#"></cfif>
				<cfif arguments.securityid neq 0>AND SECURITYID = <cfqueryparam value="#arguments.securityid#"></cfif>
				<cfif arguments.firstname neq 0>AND FIRSTNAME = <cfqueryparam value="#arguments.firstname#"></cfif>
				<cfif arguments.username neq 0>AND USERNAME = <cfqueryparam value="#arguments.username#"></cfif>
				<cfif arguments.email neq 0>AND EMAIL = <cfqueryparam value="#arguments.email#"></cfif>
				</cfquery>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn userResults>
	</cffunction>
	
	<cffunction name="addSiteUsuer" access="public" returntype="string" hint="I add a sitesecurity user">
		<cfargument name="ds" type="string" required="true" hint="datasource you want to add user to">
		<cfargument name="username" required="true" default="0" type="string" hint="the username of the person you are adding">
		<cfargument name="firstname" required="false" default="0" type="string" hint="the first name of the person you are adding">
		<cfargument name="lastname" required="false" default="0" type="string" hint="the last name of the person you are adding">
		<cfargument name="pass" required="false" default="0" type="string" hint="the password of the person you are adding">
		<cfargument name="email" required="false" default="0" type="string" hint="the email address of the person you are adding">
		<cfargument name="nameid" required="false" default="0" type="string" hint="the master nameid of the person you are adding">
		<cfargument name="status" required="false" default="1" type="string" hint="the status of the person you are updating">
		<cfset var addSiteUser=0>
		<cfquery name="addThisSiteUser" datasource="#arguments.ds#">
			INSERT INTO SITESECURITY 
			(
				MASTERNAMEID,
				FIRSTNAME,
				LASTNAME,
				USERNAME,
				PASS,
				EMAIL
			)
			VALUES
			(
				<cfqueryparam value="#arguments.NAMEID#">,
				<cfqueryparam value="#arguments.FIRSTNAME#">,
				<cfqueryparam value="#arguments.LASTNAME#">,
				<cfqueryparam value="#arguments.USERNAME#">,
				<cfqueryparam value="#arguments.PASS#">,
				<cfqueryparam value="#arguments.EMAIL#">
			)
			SELECT @@IDENTITY AS SECURITYID
		</cfquery>
	
		<cfreturn addThisSiteUser.SECURITYID>
	</cffunction>
	
	<cffunction name="updateSiteUser" access="public" returntype="query" hint="I update a sitesecurity user">
		<cfargument name="ds" type="string" required="true" hint="datasource you would use to make this update">
		<cfargument name="sitesecuritid" required="true" default="0" type="string" hint="the sitesecurityid of the person you are updating">
		<cfargument name="firstname" required="true" default="0" type="string" hint="the first name of the person you are updating">
		<cfargument name="lastname" required="true" default="0" type="string" hint="the last name of the person you are updating">
		<cfargument name="username" required="true" default="0" type="string" hint="the username of the person you are updating">
		<cfargument name="pass" required="true" default="0" type="string" hint="the password of the person you are updating">
		<cfargument name="email" required="true" default="0" type="string" hint="the email address of the person you are updating">
		<cfargument name="nameid" required="false" default="0" type="string" hint="the master nameid of the person you are updating">
		<cfargument name="status" required="false" default="1" type="string" hint="the status of the person you are updating">
		<cfset var upateThisSiteUser=0>		
		<cfquery name="upateThisSiteUser" datasource="#ds#">
			UPDATE SITESECURITY SET
			STATUS=<cfqueryparam value="#status#">
			<cfif firstname neq 0>, FIRSTNAME=<cfqueryparam value="#firstname#"></cfif>
			<cfif lastname neq 0>, LASTNAME=<cfqueryparam value="#lastname#"></cfif>
			<cfif username neq 0>, USERNAME=<cfqueryparam value="#username#"></cfif>
			<cfif pass neq 0>, PASS=<cfqueryparam value="#pass#"></cfif>
			<cfif email neq 0>, EMAIL=<cfqueryparam value="#email#"></cfif>
			WHERE SITESECURITYID = <cfqueryparam value="#sitesecurityid#">
		</cfquery>
		<cfreturn upateThisSiteUser>
	</cffunction>
	
	<cffunction name="getallroles" access="public" returntype="query" hint="I get all the roles in the role table for the datasource passed to me, I return a recordset: roleid, securityrole">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check">
		<cfset allroles=0>
		<cfquery name="allroles" datasource="#ds#">
		SELECT     
			SECURITYROLE,
			ROLEID
		FROM
			SECURITYROLE 
		</cfquery>
		<cfreturn allroles>
	</cffunction>
	
	<cffunction name="getallMasterroles" access="public" returntype="query" hint="I get all the roles in the role table for the datasource passed to me, I return a recordset: roleid, securityrole">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check">
		<cfset var allroles=0>
		<cfquery name="allroles" datasource="#ds#">
		SELECT     
			ROLENAME,
			ROLEID
		FROM
			MASTERROLE 
		</cfquery>
		<cfreturn allroles>
	</cffunction>
	
	<cffunction name="updateMyMasterRole" access="public" returntype="void" hint="I update the role for the nameid passed to me">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check" default="deltasystem">
		<cfargument name="masternameid" type="string" default="0" required="true" hint="the masternameid of the person you are updating">
		<cfargument name="masterroleid" type="string" default="0" required="false" hint="the masterroleid of the person you are updating">
		<cfset var checkMasterRole=0>
		<cfset var addthisUsertoMasterRole=0>
		<cfif masternameid neq 0>
			<cfquery name="checkMasterRole" datasource="#arguments.ds#">
			SELECT 
				NAMEID,
				ROLEID
			FROM NAME2MASTERROLE
			WHERE NAMEID=<cfqueryparam value="#arguments.masternameid#">
			AND ROLEID=<cfqueryparam value="#arguments.masterroleid#">
			</cfquery>
			<cfif checkMasterRole.recordcount eq 0>
				<cfquery name="addthisUsertoMasterRole" datasource="#arguments.ds#">
				INSERT INTO NAME2MASTERROLE
				(NAMEID,
				ROLEID)
				VALUES
				(<cfqueryparam value="#arguments.masternameid#">,
				<cfqueryparam value="#arguments.masterroleid#">)
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="addMasterUsertoSite" access="public" returntype="void" hint="I add the masteruser to the site">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check" default="deltasystem">
		<cfargument name="masternameid" type="string" default="0" required="true" hint="the masternameid of the user">
		<cfargument name="siteid" type="string" default="0" required="true" hint="the siteid you want to assign this user to">
		<cfargument name="sitesecurityid" type="string" default="0" required="true" hint="the sitesecurityid of the person you are adding">
		<cfargument name="relationshipid" type="string" default="0" required="false" hint="0 is general site user like braden clients 1 is siteadmin this was before we set up the new role table.">
		<cfargument name="masterroleid" type="string" default="0" required="false" hint="0 secureSiteUser, 1 siteAdmin, 2 siteOwner, 3 reseller, 4 QDTechSupport, 5 QDAdmin, 6 QDSysAdmin, 7 QD Founder">
		<cfif siteid neq 0 and masternameid neq 0>
		<cftransaction>
			<cfquery name="deleteMasterUser2Site" datasource="#ds#">
			DELETE FROM PEOPLE2SITE
			WHERE NAMEID = <cfqueryparam value="#masternameid#">
			AND SITEID = <cfqueryparam value="#siteid#">
			</cfquery>
			<cfquery name="addThisUsertoSite" datasource="#ds#">
			INSERT INTO PEOPLE2SITE
			(NAMEID,
			SITEID,
			RELATIONSHIPID,
			SITESECURITYID,
			ROLEID)
			VALUES
			(<cfqueryparam value="#masternameid#">,
			<cfqueryparam value="#siteid#">,
			<cfqueryparam value="#relationshipid#">,
			<cfqueryparam value="#sitesecurityid#">,
			<cfqueryparam value="#masterroleid#">)
			</cfquery>
		</cftransaction>
		</cfif>
	</cffunction>
	
	<cffunction name="getroleinfo" access="public" returntype="query" hint="I get all the role info for the roleid passed to me, I return a recordset: roleid, securityrole, sec, mod">
		<cfargument name="ds" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="roleid" type="string" required="true" hint="I am the roleid you want info on">
		<cfset var roleinfo=0>
		<cfquery name="roleinfo" datasource="#ds#">
		SELECT     
			SECURITYROLE.ROLEID,
			SECURITYROLE.SECURITYROLE,
			MOD2ROLE.MOD,
			SEC2ROLE.SEC
		FROM
			SECURITYROLE,
			MOD2ROLE,
			SEC2ROLE
		WHERE SECURITYROLE.ROLEID = <cfqueryparam value="#roleid#">
		AND MOD2ROLE.ROLEID = SECURITYROLE.ROLEID
		AND SEC2ROLE.ROLEID = SECURITYROLE.ROLEID
		</cfquery>
		<cfreturn roleinfo>
	</cffunction>
	
	<cffunction name="isinSecurity" access="public" returntype="query" hint="I check to see if a user is in the security database, If yes, I return the security userid, if not I return 0">
		<cfargument name="dsn" type="string" required="true" hint="datasource you would like to check">
		<cfargument name="sitenameid" type="string" required="true" hint="I am the id for the user in your databas you want to look up">
		<cfargument name="siteid" type="string" required="true" hint="I am the id for the site you currently have selected">
		<cfset var checkinSecurity=0>
		<cfset var thisuserid=0>
		<cfquery name="checkinSecurity" datasource="#dsn#" maxrows="1">
		SELECT     
			SITEID, 
			NAMEID AS USERID,
			SITENAMEID
		FROM
			PEOPLE2SITE 
		WHERE SITENAMEID = <cfqueryparam value="#sitenameid#">
		AND SITEID = <cfqueryparam value="#siteid#">
		</cfquery>
		<cfif checkinSecurity.recordcount eq 1>
			<cfset thisuserid=checkinSecurity.userid>
		<cfelse>
			<cfset thisuserid=0>
		</cfif>
		<cfreturn thisuserid>
	</cffunction>
	
	<cffunction name="createSecurityTables" access="public" returntype="void" hint="I add the security specific tables to database">
		<cfargument name="dsn" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfset var createtables=0>
		<cfquery name="createtables" datasource="#dsn#">
		<!--- ALTER TABLE USER2ROLE DROP CONSTRAINT FK_USERROLE_ROLEID;
		ALTER TABLE USER2ROLE DROP CONSTRAINT FK_USERROLE_NAMEID;
		ALTER TABLE SEC2ROLE DROP CONSTRAINT FK_SECROLE_NAMEID;
		ALTER TABLE MOD2ROLE DROP CONSTRAINT FK_MODROLE_ROLEID;
		ALTER TABLE PEOPLE2SITE DROP CONSTRAINT FK_PEOPLE2SITE_NAMEID;
		ALTER TABLE PEOPLE2SITE DROP CONSTRAINT FK_PEOPLE2SITE_SITEID;
		DROP TABLE SECURITYROLE;
		DROP TABLE USER2ROLE;
		DROP TABLE SEC2ROLE;
		DROP TABLE MOD2ROLE;
		DROP TABLE PEOPLE2SITE; --->
		CREATE TABLE SITESECURITY
		(
			SECURITYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			NAMEID BIGINT NOT NULL,
			EMAIL VARCHAR(1024) NOT NULL,
			FIRSTNAME VARCHAR(1024) NOT NULL,
			LASTNAME VARCHAR(1024) NOT NULL,
			USERNAME VARCHAR(1024) NOT NULL,
			PASS VARCHAR(1024) NOT NULL,
			STATUS BIT NOT NULL DEFAULT 1
		);
		
		CREATE TABLE MASTERROLE
		(
			ROLEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			ROLENAME VARCHAR(128) NOT NULL
		);
		
		CREATE TABLE USER2ROLE
		(
			ROLEID BIGINT NOT NULL,
			NAMEID BIGINT NOT NULL,
			SITEID VARCHAR(16) NOT NULL,
			SECURITYID BIGINT NOT NULL
		);
		
		CREATE TABLE SEC2ROLE
		(
			SEC VARCHAR(128) NOT NULL,
			ROLEID BIGINT NOT NULL
		);
		
		ALTER TABLE SEC2ROLE ADD PRIMARY KEY(SEC, ROLEID);
		
		CREATE TABLE MOD2ROLE
		(
			MOD VARCHAR(128) NOT NULL,
			ROLEID BIGINT NOT NULL
		);
		
		ALTER TABLE MOD2ROLE ADD PRIMARY KEY(MOD, ROLEID);
		
		CREATE TABLE PEOPLE2SITE
		(
			NAMEID BIGINT NOT NULL,
			SITEID VARCHAR(16) NOT NULL,
			SITENAMEID BIGINT NOT NULL
		);
		
	
		ALTER TABLE USER2ROLE ADD CONSTRAINT FK_USERROLE_SECURITYID FOREIGN KEY(SECURITYID) REFERENCES SITESECURITY(SECURITYID);
		ALTER TABLE USER2ROLE ADD CONSTRAINT FK_USERROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES MASTERROLE(ROLEID);
		ALTER TABLE USER2ROLE ADD CONSTRAINT FK_USERROLE_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
		ALTER TABLE SEC2ROLE ADD CONSTRAINT FK_SECROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES SECURITYROLE(ROLEID);
		ALTER TABLE MOD2ROLE ADD CONSTRAINT FK_MODROLE_ROLEID FOREIGN KEY(ROLEID) REFERENCES SECURITYROLE(ROLEID);
		ALTER TABLE PEOPLE2SITE ADD CONSTRAINT FK_PEOPLE2SITE_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
		ALTER TABLE PEOPLE2SITE ADD CONSTRAINT FK_PEOPLE2SITE_SITEID FOREIGN KEY(SITEID) REFERENCES SITE(SITEID);
		
		</cfquery>
	</cffunction>
	
	<cffunction name="createSiteSecurityTables" access="public" returntype="void" hint="I add the tracking specific tables to database">
		<cfargument name="ds" type="string" required="true" hint="I am the dsn you want to create tables for">
		<cfset var createtables=0>
		<!---ALTER TABLE USER2ROLE DROP CONSTRAINT FK_USERROLE_SECURITYID;
		ALTER TABLE USER2ROLE DROP CONSTRAINT FK_USERROLE_ROLEID;
		ALTER TABLE USER2ROLE DROP CONSTRAINT FK_USERROLE_NAMEID;
		ALTER TABLE SEC2ROLE DROP CONSTRAINT FK_SECROLE_ROLEID;
		ALTER TABLE MOD2ROLE DROP CONSTRAINT FK_MODROLE_ROLEID;			
		DROP TABLE USER2ROLE;
		DROP TABLE SEC2ROLE;
		DROP TABLE MOD2ROLE; 
		DROP TABLE SITESECURITY;
		DROP TABLE SECURITYROLE;--->
		<cfif not tblCheck.tableExists('#arguments.ds#', 'SITESECURITY')>
		<cfquery name="createsitesecuritytable" datasource="#arguments.ds#">
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
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'SECURITYROLE')>
		<cfquery name="createSECURITYROLE" datasource="#arguments.ds#">
		CREATE TABLE SECURITYROLE
		(
			ROLEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			SECURITYROLE VARCHAR(128) NOT NULL
		);
		</cfquery>
		</cfif>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'USER2ROLE')>
		<cfquery name="createUSER2ROLE" datasource="#arguments.ds#">
		CREATE TABLE USER2ROLE
		(
			ROLEID BIGINT NOT NULL,
			SECURITYID BIGINT NOT NULL
		);
		
		ALTER TABLE USER2ROLE ADD PRIMARY KEY(ROLEID, SECURITYID);
		</cfquery>
		</cfif>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'SEC2ROLE')>
		<cfquery name="createSEC2ROLE" datasource="#arguments.ds#">
		CREATE TABLE SEC2ROLE
		(
			SEC VARCHAR(128) NOT NULL,
			ROLEID BIGINT NOT NULL,
			SITEID VARCHAR(16) NOT NULL
		);
		
		ALTER TABLE SEC2ROLE ADD PRIMARY KEY(SEC, ROLEID, SITEID);
		</cfquery>
		</cfif>
		
		<cfif not tblCheck.tableExists('#arguments.ds#', 'MOD2ROLE')>
		<cfquery name="createMOD2ROLE" datasource="#arguments.ds#">
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
	</cffunction>
				
</cfcomponent>