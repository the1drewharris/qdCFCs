<cfcomponent hint="I am the new security cfc">
	<cfset masterdsn="deltasystem">
	<cfset mastersiteid='2006062008281315'>
	
	<cffunction name="addProduct" access="public" returntype="string" hint="I add quantum delta product">
		<cfargument name="productname" required="true" type="string" hint="name of the qd product">
		<cfargument name="description" required="false" type="string" default="" hint="description of the product">
		<cfset var add=0>
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(PRODUCT_NAME) AS NOOFRECS FROM QD_PRODUCTS 
			WHERE PRODUCT_NAME=<cfqueryparam value="#arguments.productname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_PRODUCTS
				(
					PRODUCT_NAME,
					DESCRIPTION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.productname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
				) 
				SELECT @@IDENTITY AS PRODUCTID
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn add.PRODUCTID>
	</cffunction>
	
	<cffunction name="addSections" access="public" returntype="string" hint="I add section">
		<cfargument name="sectionname" required="true" type="string" hint="name of the section">
		<cfargument name="caption" required="true" type="string" hint="caption of the section">
		<cfargument name="description" required="false" type="string" default="" hint="description of the section">
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(SECTION_NAME) AS NOOFRECS FROM QD_SECTIONS 
			WHERE SECTION_NAME=<cfqueryparam value="#arguments.sectionname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_SECTIONS
				(
					SECTION_NAME,
					CAPTION,
					DESCRIPTION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.sectionname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
				) 
				SELECT @@IDENTITY AS SECTIONID
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn add.SECTIONID>
	</cffunction>
	
	<cffunction name="addSectionToProduct" access="public" returntype="string" hint="I add section to product">
		<cfargument name="productid" required="true" type="string" hint="id of the product">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfargument name="sortorder" required="false" type="string" default="0" hint="sort order of the section">
		<cfset var add=0>
		<cfset var get=0>
		<cfset var getsortorder=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(PRODUCTID) AS NOOFRECS FROM QD_SECTIONS_TO_QD_PRODUCTS 
			WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			AND SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfif arguments.sortorder EQ 0>
				<cfquery name="getsortorder" datasource="#masterdsn#">
					SELECT MAX(SORTORDER) AS MAXSORTORDER FROM QD_SECTIONS_TO_QD_PRODUCTS
					WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getsortorder.MAXSORTORDER EQ "">
					<cfset arguments.sortorder=getsortorder.maxsortorder+10>
				<cfelse>
					<cfset arguments.sortorder=10>
				</cfif>
			</cfif>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_SECTIONS_TO_QD_PRODUCTS
				(
					PRODUCTID,
					SECTIONID,
					SORTORDER
				)
				VALUES
				(
					<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="removeSectionFromProducts" access="public" returntype="void" hint="I remove section from products">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfargument name="productid" required="false" type="string" default="0" hint="id of the product">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#masterdsn#">
			DELETE FROM QD_SECTIONS_TO_QD_PRODUCTS
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.productid NEQ 0>
			AND PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="addModules" access="public" returntype="string" hint="I add modules">
		<cfargument name="modulename" required="true" type="string" hint="name of the module">
		<cfargument name="caption" required="true" type="string" hint="caption of the module">
		<cfargument name="description" required="false" type="string" default="" hint="description of the module">
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(MODULE_NAME) AS NOOFRECS FROM QD_MODULES
			WHERE MODULE_NAME=<cfqueryparam value="#arguments.modulename#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_MODULES
				(
					MODULE_NAME,
					CAPTION,
					DESCRIPTION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.modulename#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
				)
				SELECT @@IDENTITY AS MODULEID
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn add.MODULEID>
	</cffunction>
	
	<cffunction name="addModulesToSections" access="public" returntype="string" hint="I add modules to sections">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="sortorder" required="false" type="string" default="0" hint="sortorder of the module in the section">
		<cfset var get=0>
		<cfset var add=0>
		<cfset var getsortorder=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(SECTIONID) AS NOOFRECS FROM QD_MODULES_TO_QD_SECTIONS
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>		
		<cfif get.NOOFRECS EQ 0>
			<cfif arguments.sortorder EQ 0>
				<cfquery name="getsortorder" datasource="#masterdsn#">
					SELECT MAX(SORTORDER) AS MAXSORTORDER 
					FROM QD_MODULES_TO_QD_SECTIONS
					WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#">
				</cfquery>
				<cfif getsortorder.MAXSORTORDER NEQ "">
					<cfset arguments.sortorder=getsortorder.maxsortorder+10>
				<cfelse>
					<cfset arguments.sortorder=10>
				</cfif>
			</cfif>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_MODULES_TO_QD_SECTIONS
				(
					SECTIONID,
					MODULEID,
					SORTORDER
				)
				VALUES
				(
					<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.sortorder#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn 1>
	</cffunction>

	<cffunction name="addModulesToSite" access="public" returntype="string" hint="I add modules to site">
		<cfargument name="siteid" required="true" type="string" hint="siteid">
		<cfargument name="moduleid" required="true" type="string" hint="moduleid">
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(SITEID) AS NOOFRECS FROM QD_MODULES_TO_SITE
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_MODULES_TO_SITE
				(
					SITEID,
					MODULEID
				)
				VALUES
				(
					<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn 1>
	</cffunction>

	<cffunction name="addModulesToUser" access="public" returntype="string" hint="I add modules to user. Return values: -1: Site has no access, 0: Already in db, 1: success">
		<cfargument name="nameid" required="true" type="string" hint="master nameid of the person">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="permission" required="false" type="string" default="3" hint="permission">
		<cfset var getPermission=0>
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="getPermission" datasource="#masterdsn#">
			SELECT COUNT(SITEID) AS NOOFRECS FROM QD_MODULES_TO_SITE
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getPermission.NOOFRECS GT 0>
			<cfquery name="get" datasource="#masterdsn#">
				SELECT COUNT(MODULEID) AS NOOFRECS FROM QD_MODULES_TO_USER
				WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
				AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
				AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif get.NOOFRECS EQ 0>
				<cfquery name="add" datasource="#masterdsn#">
					INSERT INTO QD_MODULES_TO_USER
					(
						NAMEID,
						SITEID,
						MODULEID,
						PERMISSION
					)
					VALUES
					(
						<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.permission#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			<cfelse>
				<cfreturn 0>
			</cfif>
		<cfelse>
			<cfreturn -1>
		</cfif>
		<cfreturn 1>
	</cffunction>

	<cffunction name="addSecurityRoles" access="public" returntype="string" hint="I add new security roles">
		<cfargument name="securityrole" required="true" type="string" hint="name of the role">
		<cfargument name="description" required="true" type="string" hint="description of the role">
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(ROLEID) AS NOOFRECS FROM QD_SECURITY_ROLES
			WHERE SECURITYROLE=<cfqueryparam value="#arguments.securityrole#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_SECURITY_ROLES
				(
					SECURITYROLE,
					DESCRIPTION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.securityrole#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
				)
				SELECT @@IDENTITY AS ROLEID
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn add.ROLEID>
	</cffunction>

	<cffunction name="addModulesToSecurityRoles" access="public" returntype="string" hint="I add modules to roles">
		<cfargument name="roleid" required="true" type="string" hint="id of the role">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="permission" required="false" type="string" default="3" hint="permission: 1: read, write and edit your work, 2: also read others work, 3:also edit others work">
		<cfset var get=0>
		<cfset var add=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(ROLEID) AS NOOFRECS FROM QD_MODULES_TO_QD_SECURITY_ROLES
			WHERE ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			AND PERMISSION=<cfqueryparam value="#arguments.permission#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfquery name="add" datasource="#masterdsn#">
				INSERT INTO QD_MODULES_TO_QD_SECURITY_ROLES
				(
					ROLEID,
					MODULEID,
					PERMISSION
				)
				VALUES
				(
					<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.permission#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn 1>
	</cffunction>

	<cffunction name="assignRoletoUser" access="public" returntype="string" hint="I assign role to a user">
		<cfargument name="nameid" required="true" type="string" hint="I am the id of the name">
		<cfargument name="roleid" required="true" type="string" hint="I am the id of the role">
		<cfargument name="siteid" required="true" type="string" hint="I am the id of the site, pass any value if roleid is 7">
		<cfset var get=0>
		<cfset var assign=0>

		<cfif arguments.siteid EQ mastersiteid AND arguments.roleid LT 7>
			<cfreturn 0>
		</cfif>
	
		<cfquery name="get" datasource="#masterdsn#">
			SELECT COUNT(SITEID) AS NOOFRECS FROM USER_TO_QD_SECURITY_ROLES
			WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.NOOFRECS EQ 0>
			<cfif arguments.roleid EQ 7>
				<cfset arguments.siteid = mastersiteid>
			</cfif>
			<cfquery name="assign" datasource="#masterdsn#">
				INSERT INTO USER_TO_QD_SECURITY_ROLES
				(
					SITEID,
					NAMEID,
					ROLEID
				)
				VALUES
				(
					<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfquery name="checkFirst" datasource="#masterdsn#">
				SELECT
				NAMEID
				FROM 
				USER_TO_QD_SECURITY_ROLES
				WHERE SITEID=<cfqueryparam value="#arguments.siteid#">
				AND ROLEID=<cfqueryparam value="#arguments.roleid#">
				AND NAMEID=<cfqueryparam value="#arguments.nameid#">
			</cfquery>
			<cfif checkFirst.recordcount eq 0>
				<cfquery name="assign" datasource="#masterdsn#">
					UPDATE USER_TO_QD_SECURITY_ROLES SET 
					ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
					WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
					AND	NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="removeUserFromSite" access="public" returntype="void" hint="I delete user from site">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of user">
		<cfargument name="siteid" required="false" type="string" default="0" hint="I am the id of the site">
		<cfset var delete1=0>
		<cfset var delete2=0>
		<cfquery name="delete2" datasource="#masterdsn#">
			DELETE FROM USER_TO_QD_SECURITY_ROLES
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.siteid NEQ "0">
				AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfquery name="delete2" datasource="#masterdsn#">
			DELETE FROM QD_MODULES_TO_USER
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.siteid NEQ 0>
				AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getModulesInSection" access="public" output="false" returntype="query" hint="I get modules in a section">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT
				M.MODULE_NAME,
				MTS.MODULEID,
				MTS.SORTORDER
			FROM QD_MODULES M, QD_MODULES_TO_QD_SECTIONS MTS
			WHERE M.MODULEID=MTS.MODULEID
			AND MTS.SECTIONID=<cfqueryparam value="#arguments.sectionid#">
			ORDER BY MTS.SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="sortModulesInSection" access="public" output="false" returntype="void" hint="I sort modules in a section">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfargument name="modulelist" requried="true" type="string" hint="I am the list of modules">
		<cfargument name="sortvaluelist" required="true" type="string" hint="I am the list of sortvalues">
		<cfset var sort=0>
		<cfset noofmodules=listlen(arguments.modulelist)>
		<cfquery name="sort" datasource="#masterdsn#">
			UPDATE QD_MODULES_TO_QD_SECTIONS
			SET SORTORDER = CASE MODULEID
			<cfloop from="1" to="#noofmodules#" index="i">
				WHEN #listGetAt(arguments.modulelist,i)# THEN #listGetAt(arguments.sortvaluelist,i)#
			</cfloop>
			END
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#">
			AND MODULEID IN (#arguments.modulelist#)
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getModulesForUser" access="public" returntype="string" hint="I get list of modules for a user">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of user">
		<cfargument name="siteid" required="true" type="string" hint="I am the id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT MODULEID
			FROM QD_MODULES_TO_USER
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn ValueList(get.moduleid)>
	</cffunction>

	<cffunction name="getAcl" access="public" returntype="Struct" hint="I return access control list structure. Elements of structure are: roleid, acl(list), permission(list)">
		<cfargument name="nameid" required="true" type="string" hint="I am the maternameid of the person">
		<cfargument name="siteid" required="true" type="string" hint="I am the id of the site">
		<cfset var getAdmin=0>
		<cfset var getRole=0>
		<cfset var getModules=0>
		<cfset var aclStruct=StructNew()>
		<cfquery name="getAdmin" datasource="#masterdsn#">
			SELECT ROLEID FROM USER_TO_QD_SECURITY_ROLES
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND SITEID=<cfqueryparam value="#mastersiteid#" cfsqltype="cf_sql_varchar">
			AND ROLEID=<cfqueryparam value="7" cfsqltype="cf_sql_varchar">
		</cfquery><!--- Admin? --->
		<cfif getAdmin.recordcount GT 0> <!--- Yes ---> 
			<cfset aclstruct.roleid=getAdmin.ROLEID>
			<cfset aclStruct.aclids=0>  
			<cfset aclstruct.aclmodules="">
			<cfset aclstruct.permission="">
		<cfelse> <!--- No --->
			<cfquery name="getRole" datasource="#masterdsn#"> <!--- find the person's role --->
				SELECT ROLEID FROM USER_TO_QD_SECURITY_ROLES
				WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
				AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfquery> <!--- Role found? --->
			<cfif getRole.recordcount GT 0> <!--- Yes --->
				<cfset aclStruct.roleid=getRole.ROLEID>
				<cfquery name="getModules" datasource="#masterdsn#"> <!--- get modules from QD_MODULES_TO_QD_SECURITY_ROLES table --->
					SELECT
						QD_MODULES_TO_QD_SECURITY_ROLES.MODULEID,
						QD_MODULES.MODULE_NAME,
						QD_MODULES_TO_QD_SECURITY_ROLES.PERMISSION
					FROM QD_MODULES_TO_QD_SECURITY_ROLES
					INNER JOIN QD_MODULES
					ON QD_MODULES_TO_QD_SECURITY_ROLES.MODULEID=QD_MODULES.MODULEID
					WHERE QD_MODULES_TO_QD_SECURITY_ROLES.ROLEID=<cfqueryparam value="#getRole.ROLEID#" cfsqltype="cf_sql_varchar">
					AND QD_MODULES_TO_QD_SECURITY_ROLES.MODULEID IN (SELECT MODULEID FROM QD_MODULES_TO_SITE WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">)
					UNION
					SELECT 
						QD_MODULES_TO_USER.MODULEID,
						QD_MODULES.MODULE_NAME,
						QD_MODULES_TO_USER.PERMISSION
					FROM QD_MODULES_TO_USER
					INNER JOIN QD_MODULES
					ON QD_MODULES_TO_USER.MODULEID=QD_MODULES.MODULEID
					WHERE QD_MODULES_TO_USER.NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
					AND QD_MODULES_TO_USER.SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
					AND QD_MODULES_TO_USER.MODULEID IN (SELECT MODULEID FROM QD_MODULES_TO_SITE WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">)
				</cfquery>
				<cfset aclStruct.aclids=ValueList(getModules.MODULEID)>  
				<cfset aclStruct.aclmodules=ValueList(getModules.MODULE_NAME)>
				<cfset aclStruct.permission=ValueList(getModules.PERMISSION)>
			<cfelse> <!--- No --->
				<cfset aclStruct.roleid=-1>
				<cfset aclStruct.aclids=-1>
				<cfset aclStruct.aclmodules="">
				<cfset aclStruct.permission="">
			</cfif>
		</cfif>
		<cfreturn aclStruct>
	</cffunction>

	<cffunction name="getQdProducts" access="public" returntype="query" hint="I get the list of products:PRODUCTID,PRODUCT_NAME,DESCRIPTION">
		<cfargument name="productid" required="false" type="string" default="0" hint="id of the product">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT 
				PRODUCTID,
				PRODUCT_NAME,
				DESCRIPTION
			FROM QD_PRODUCTS
			<cfif arguments.productid NEQ "0">
			WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="updateQdProduct" access="public" returntype="void" hint="I update qd_products">
		<cfargument name="productid" required="true" type="string" default="0" hint="id of the product">
		<cfargument name="productname" required="true" type="string" default="0" hint="name of the qd product">
		<cfargument name="description" required="true" type="string" default="0" hint="description of the qd product">
		<cfset var update=0>
		<cfquery name="update" datasource="#masterdsn#">
			UPDATE QD_PRODUCTS SET
				PRODUCT_NAME=<cfqueryparam value="#arguments.productname#" cfsqltype="cf_sql_varchar">
				DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getQdSections" access="public" returntype="query" hint="I get Sections:SECTIONID, SECTION_NAME, DESCRIPTION">
		<cfargument name="sectionid" required="false" type="string" default="0" hint="id of the section">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT
				SECTIONID,
				SECTION_NAME,
				DESCRIPTION
			FROM QD_SECTIONS
			<cfif arguments.sectionid NEQ "0">
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="updateQdSection" access="public" returntype="void" hint="I update qd_sections">
		<cfargument name="sectionid" required="true" type="string" hint="id of the product">
		<cfargument name="sectionname" required="true" type="string"  hint="new name of the section">
		<cfargument name="caption" required="true" type="string" hint="caption of the section">
		<cfargument name="description" required="true" type="string" hint="new description">
		<cfset var update=0>
		<cfquery name="update" datasource="#masterdsn#">
			UPDATE QD_SECTIONS SET
				SECTION_NAME=<cfqueryparam value="#arguments.sectionname#" cfsqltype="cf_sql_varchar">,
				CAPTION=<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">,
				DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getSectionsInProduct" access="public" returntype="query" hint="I get all the sections in a product">
		<cfargument name="productid" required="true" type="string" hint="id of the product">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT
				QD_SECTIONS_TO_QD_PRODUCTS.SECTIONID,
				QD_SECTIONS_TO_QD_PRODUCTS.SORTORDER,
				QD_SECTIONS.SECTION_NAME,
				QD_SECTIONS.DESCRIPTION
			FROM QD_SECTIONS_TO_QD_PRODUCTS
			INNER JOIN QD_SECTIONS
			ON QD_SECTIONS.SECTIONID = QD_SECTIONS_TO_QD_PRODUCTS.SECTIONID
			WHERE QD_SECTIONS_TO_QD_PRODUCTS.PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			ORDER BY QD_SECTIONS_TO_QD_PRODUCTS.SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="sortSectionsInProduct" access="public" returntype="void" hint="I sort products in a product">
		<cfargument name="productid" required="true" type="string" hint="id of the product">
		<cfargument name="sectionlist" required="true" type="string" hint="list of ids of sections">
		<cfargument name="sortorderlist" required="true" type="string" hint="list of sortorder value for sections">
		<cfset var sort=0>
		<cfset noofsections=listlen(arguments.sectionlist)>
		<cfquery name="sort" datasource="#masterdsn#">
			UPDATE QD_SECTIONS_TO_QD_PRODUCTS 
			SET SORTORDER = CASE SECTIONID
			<cfloop from="1" to="#noofsections#" index="i">
				WHEN #listGetAt(arguments.sectionlist,i)# THEN #listGetAt(arguments.sortorderlist,i)#
			</cfloop>
			END
			WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			AND SECTIONID IN (#arguments.sectionlist#)
		</cfquery>
	</cffunction>
	
	<cffunction name="removeSectionFromProduct" access="public" returntype="void" hint="I remove section from product">
		<cfargument name="productid" required="true" type="string" hint="id of the product">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#masterdsn#">
			DELETE FROM QD_SECTIONS_TO_QD_PRODUCTS
			WHERE PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			AND SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getProductsaSectionBelongsto" access="public" returntype="query" hint="I return productIds">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT PRODUCTID FROM QD_SECTIONS_TO_QD_PRODUCTS
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="deleteSection" access="public" returntype="void" hint="I remove section from database">
		<cfargument name="sectionid" required="true" type="string" hint="id of the section">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#masterdsn#">
			DELETE FROM QD_SECTIONS
			WHERE SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getQdModules" access="public" returntype="query" hint="I get qd modules">
		<cfargument name="moduleid" required="false" type="string" default="0" hint="id of the module">
		<cfargument name="sectionid" required="false" type="string" default="0" hint="id of the section to which modules belong to">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT 
				MODULEID,
				MODULE_NAME,
				CAPTION,
				DESCRIPTION
			FROM QD_MODULES
			WHERE 1=1
			<cfif arguments.moduleid NEQ "0">
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.sectionid NEQ "0">
			AND MODULEID IN (SELECT MODULEID FROM QD_MODULES_TO_QD_SECTIONS WHERE SECTINOID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">)
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="updateQdModule" access="public" returntype="void" hint="I update qd modules">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="modulename" required="true" type="string" hint="name of the module">
		<cfargument name="caption" required="true" type="string" hint="caption of the module">
		<cfargument name="description" required="true" type="string" hint="description of the module">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			UPDATE QD_MODULES SET
				MODULE_NAME=<cfqueryparam value="#arguments.modulename#" cfsqltype="cf_sql_varchar">,
				CAPTION=<cfqueryparam value="#arguments.caption#" cfsqltype="cf_sql_varchar">,
				DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="removeModuleFromSection" access="public" returntype="void" hint="I remove module from section">
		<cfargument name="moduleid" required="false" default="0" type="string" hint="id of the module">
		<cfargument name="sectionid" required="false" default="0" hint="id of the section">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#masterdsn#">
			DELETE FROM QD_MODULES_TO_QD_SECTIONS
			WHERE 1=1
			<cfif arguments.moduleid NEQ 0>
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.sectionid NEQ 0>
			AND SECTIONID=<cfqueryparam value="#arguments.sectionid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getModulesInSite" access="public" returntype="query" hint="I get all the modules in a site">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT 
				MODULEID,
				MODULE_NAME,
				CAPTION,
				DESCRIPTION
			FROM QD_MODULES
			WHERE MODULEID IN (SELECT MODULEID FROM QD_MODULES_TO_SITE WHERE SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">) 
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="removeModuleFromSite" access="public" returntype="void" hint="I remove module from site">
		<cfargument name="moduleid" required="false" type="string" default="0" hint="id of the module">
		<cfargument name="siteid" required="false" type="string" default="0" hint="id of the site">
		<cfset var get=0>
		<cfif arguments.moduleid EQ 0 AND arguments.siteid EQ 0><cfreturn></cfif>
		<cfquery name="get" datasource="#masterdsn#">
			DELETE FROM QD_MODULES_TO_SITE
			WHERE 1=1
			<cfif arguments.moduleid NEQ 0>
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.siteid NEQ 0>
			AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="removeModulesForUser" access="public" returntype="void" hint="I remove module from user's access control list">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="userid" required="false" default="0" type="string" hint="nameid of the user">
		<cfargument name="siteid" required="false" type="string" default="0" hint="id of the site">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#masterdsn#">
			DELETE FROM QD_MODULES_TO_USER
			WHERE MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.siteid NEQ "0">
			AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.userid NEQ "0">
			AND NAMEID=<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">
			</cfif> 
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteModule" access="public" returntype="void" hint="I remove module">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfset var delete="0">
		<cfquery name="delete" datasource="#masterdsn#">
			DELETE FROM QD_MODULES
			WHERE MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="updateUserPermissionOnModule" access="public" returntype="void" hint="I update user permission on a module">
		<cfargument name="userid" required="true" type="string" hint="nameid of the user">
		<cfargument name="siteid" required="true" type="string" hint="id of the site">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfargument name="permission" required="true" type="string" hint="permission:0,1,2,3">
		<cfset var update=0>
		<cfquery name="update" datasource="#masterdsn#">
			UPDATE QD_MODULES_TO_USER SET
			PERMISSION=<cfqueryparam value="#arguments.permission#" cfsqltype="cf_sql_varchar">
			WHERE MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			AND SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
	</cffunction>

	<cffunction name="getSectionsaModuleBelongsTo" access="public" returntype="query" hint="I get sectionids of sections a module belongs to">
		<cfargument name="moduleid" required="true" type="string" hint="id of the module">
		<cfset var get =0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT SECTIONID FROM QD_MODULES_TO_QD_SECTIONS
			WHERE MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="getSecurityRoles" access="public" returntype="query" hint="I get admin roles: ROLEID,SECURITYROLE,DESCRIPTION">
		<cfargument name="roleid" required="false" type="string" default="0" hint="name of the role">
		<cfargument name="maxroleid" required="false" type="string" default="0" hint="max id of the role">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT 
				ROLEID,
				SECURITYROLE,
				DESCRIPTION
			FROM  QD_SECURITY_ROLES
			WHERE 1=1
			<cfif arguments.roleid NEQ 0>
			AND ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.maxroleid NEQ 0>
			AND ROLEID<=<cfqueryparam value="#arguments.maxroleid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="updateSecrurityRole" access="public" returntype="void" hint="I update security role">
		<cfargument name="roleid" required="true" type="string" hint="id of the role">
		<cfargument name="securityrole" required="true" type="string" hint="name of the role">
		<cfargument name="description" required="true" type="string" hint="description of the role">
		<cfset var update=0>
		<cfquery name="update" datasource="#masterdsn#">
			UPDATE QD_SECURITY_ROLES SET
			SECURITYROLE=<cfqueryparam value="#arguments.securityrole#" cfsqltype="cf_sql_varchar">,
			DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			WHERE ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getModulesInSecurityRole" access="public" returntype="query" hint="I get roles in a security Role:MODULEID,MODULE_NAME,DESCRIPTION">
		<cfargument name="roleid" required="true" type="string" hint="id of the role">
		<cfset var get=0>
		<cfquery name="get" datasource="#masterdsn#">
			SELECT
				MODULEID,
				MODULE_NAME,
				DESCRIPTION
			FROM QD_MODULES
			WHERE MODULEID IN (SELECT MODULEID FROM QD_MODULES_TO_QD_SECURITY_ROLES WHERE ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="removeModulefromSecurityRole" access="public" returntype="void" hint="I remove a module from security role">
		<cfargument name="roleid" required="true" type="string" hint="id of the role">
		<cfargument name="moduleid" required="false" type="string" default="0" hint="id of the module">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#masterdsn#">
			DELETE FROM QD_MODULES_TO_QD_SECURITY_ROLES
			WHERE ROLEID=<cfqueryparam value="#arguments.roleid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.moduleid NEQ 0>
			AND MODULEID=<cfqueryparam value="#arguments.moduleid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getUsersRole" access="public" returntype="query" hint="I get role of a user: SITEID,SITEURL,ROLEID,SECURITYROLE">
	 	<cfargument name="nameid" required="true" type="string" hint="Name of the role">
	 	<cfargument name="siteid" required="false" type="string" default="0" hint="id of the site">
	 	<cfset var get=0>
	 	<cfquery name="get" datasource="#masterdsn#">
			SELECT
				USER_TO_QD_SECURITY_ROLES.NAMEID,
				USER_TO_QD_SECURITY_ROLES.SITEID,
				USER_TO_QD_SECURITY_ROLES.ROLEID,
				SITE.SITENAME,
				QD_SECURITY_ROLES.SECURITYROLE
			FROM USER_TO_QD_SECURITY_ROLES
			INNER JOIN SITE ON USER_TO_QD_SECURITY_ROLES.SITEID=SITE.SITEID
			INNER JOIN QD_SECURITY_ROLES ON USER_TO_QD_SECURITY_ROLES.ROLEID=QD_SECURITY_ROLES.ROLEID
			WHERE USER_TO_QD_SECURITY_ROLES.NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.siteid NEQ 0>
			AND USER_TO_QD_SECURITY_ROLES.SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			</cfif> 
		</cfquery>
		<cfreturn get>
	</cffunction>

	<cffunction name="getNavigation" access="public" returntype="any" output="true" hint="I create Navigation for a user for a site, returns XML">
		<cfargument name="productid" required="false" type="string" default="1" hint="id of the product, default is qdcms">
		<cfargument name="aclids" required="false" type="string" default="0" hint="list of modules, if passed nothing gets all for a product">
		<cfset var getSections=0>
		<cfset var getModules=0>
		<cfset var allowedSections="">
		<cfquery name="getSections" datasource="#masterdsn#">
			SELECT 
				QD_SECTIONS.SECTION_NAME,
				QD_SECTIONS_TO_QD_PRODUCTS.SECTIONID
			FROM QD_SECTIONS
			INNER JOIN QD_SECTIONS_TO_QD_PRODUCTS ON QD_SECTIONS_TO_QD_PRODUCTS.SECTIONID=QD_SECTIONS.SECTIONID
			AND QD_SECTIONS_TO_QD_PRODUCTS.PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar">
			ORDER BY QD_SECTIONS_To_QD_PRODUCTS.SORTORDER
		</cfquery>
		<cfoutput>
			<cfsavecontent variable="mynav">
				<Navigation>
					<cfloop query="getSections">
						<cfquery name="getModules" datasource="#masterdsn#">
							SELECT 
							QD_MODULES.MODULE_NAME,
							QD_MODULES.CAPTION,
							QD_MODULES_TO_QD_SECTIONS.MODULEID
							FROM QD_MODULES
							INNER JOIN QD_MODULES_TO_QD_SECTIONS ON QD_MODULES_TO_QD_SECTIONS.MODULEID=QD_MODULES.MODULEID
							AND QD_MODULES_TO_QD_SECTIONS.SECTIONID=<cfqueryparam value="#sectionid#">
							<cfif arguments.aclids NEQ "0">
							AND QD_MODULES_TO_QD_SECTIONS.MODULEID IN (#arguments.aclids#)
							</cfif>
							ORDER BY QD_MODULES_TO_QD_SECTIONS.SORTORDER
						</cfquery>
						<cfif getModules.recordcount GT 0>
							<cfset allowedSections=listAppend(allowedSections,SECTION_NAME)>
							<Section name="#SECTION_NAME#">
								<cfloop query="getModules">
									<Module>
										<Name>#MODULE_NAME#</Name>
										<DisplayName><cfif CAPTION NEQ "">#CAPTION#<cfelse>#MODULE_NAME#</cfif></DisplayName>
									</Module>
								</cfloop>
							</Section>
						</cfif>
					</cfloop>
					<Sections>#allowedSections#</Sections>
				</Navigation>
			</cfsavecontent>
		</cfoutput>
		<cfreturn mynav>
	</cffunction>

	<cffunction name="authenicate" access="public" returntype="struct" hint="Authenicate the username and password">
		<cfargument name="myusername" type="string" required="true">
		<cfargument name="pass" type="string" required="true">
		<cfset var checkpassword=0>
		<cfset var checkusername=0>
		<cfset var getrole=0>
		<cfset var secure=structNew()>
		<cfset var updatelastlogin=0>
		<cfset var getLastSite=0>
		
		<cfquery name="checkusername" datasource="#masterdsn#">
			SELECT COUNT(NAMEID) AS NOOFRECS
			FROM NAME
			WHERE USERNAME LIKE <cfqueryparam value="#arguments.myusername#">
			AND STATUS=<cfqueryparam value="1">
		</cfquery>

		<cfif checkusername.recordcount GT 0>
			<cfquery name="checkpassword" datasource="#masterdsn#">
				SELECT
					NAMEID,
					FIRSTNAME,
					LASTNAME,
					LASTSITEID
				FROM NAME
				WHERE PASSWORD = <cfqueryparam value="#arguments.pass#">
				AND USERNAME = <cfqueryparam value="#arguments.myusername#">
			</cfquery>
			<cfif checkusername.recordcount gt 0>
				<cfset secure.authenicated = 1>
				<cfset secure.userid=checkpassword.NAMEID>
				<cfset secure.firstname=checkpassword.firstname>
				<cfset secure.lastname=checkpassword.lastname>
				<cfif len(checkpassword.lastsiteid) EQ 16>
					<cfset secure.lastsiteid=checkpassword.lastsiteid>
				<cfelse>
					<cfset secure.lastsiteid=0>
				</cfif>
				<cfset secure.roleid=-1> <!--- means role not set --->
				<cfquery name="getrole" datasource="#masterdsn#">
					SELECT ROLEID FROM USER_TO_QD_SECURITY_ROLES 
					WHERE NAMEID =<cfqueryparam value="#secure.userid#" cfsqltype="cf_sql_varchar">
					AND ROLEID = 7
				</cfquery>
				<cfif getrole.recordcount GT 0>
					<cfset secure.roleid=getrole.ROLEID>
				</cfif>
			<cfelse>
				<cfset secure.authenicated = 0>
				<cfset secure.message = "Your login information is incorrect. You may have it emailed to you">
			</cfif>
		<cfelse>
			<cfset secure.authenicated = 0>
			<cfset secure.message = "Your username was not found">
		</cfif>
		<cfreturn secure>
	</cffunction>

	<cffunction name="getSitesWithPermission" access="public" returntype="query" hint="I get the sites for the user passed to me, I return a list of SITEID">
		<cfargument name="userid" type="string" required="false" default="0" hint="the id of the user you need site info on">
		<cfset var mysites=0>
		<cfif arguments.userid NEQ 0>
			<cfquery name="mysites" datasource="#masterdsn#">
				SELECT     
					USER_TO_QD_SECURITY_ROLES.SITEID,
					USER_TO_QD_SECURITY_ROLES.ROLEID,
					SITE.SITENAME,
					SITE.SITEURL
				FROM USER_TO_QD_SECURITY_ROLES, SITE 
				WHERE USER_TO_QD_SECURITY_ROLES.NAMEID = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">
				AND SITE.SITEID=USER_TO_QD_SECURITY_ROLES.SITEID
				ORDER BY SITE.SITENAME
			</cfquery>
		<cfelse>
			<cfquery name="mysites" datasource="#masterdsn#">
				SELECT     
					SITEID,
					7 AS ROLEID,
					SITE.SITENAME,
					SITE.SITEURL
				FROM SITE 
				ORDER BY SITENAME
			</cfquery>
		</cfif>
		<cfreturn mysites>
	</cffunction>

	<cffunction name="getUserInfo" access="public" returntype="query" hint="I get user information: FIRSTNAME,LASTNAME,WEMAIL,COMPANY,TITLE,USERNAME,PASSWORD,HPHONE,WPHONE,MPHONE,ADDRESS1,ADDRESS,CITY,STATE,ZIP,SITES">
		<cfargument name="nameid" required="true" type="string" hint="name of the user">
		<cfset var getinfo=0>
		<cfquery name="getinfo" datasource="#masterdsn#">
			SELECT
				FIRSTNAME,
				LASTNAME,
				WEMAIL,
				COMPANY,
				TITLE,
				USERNAME,
				PASSWORD,
				HPHONE,
				WPHONE,
				MPHONE,
				ADDRESS1,
				ADDRESS2,
				CITY,
				STATE,
				ZIP
			FROM NAME,ADDRESS
			WHERE NAME.NAMEID=ADDRESS.NAMEID
			AND NAME.NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getinfo>
	</cffunction>

	<cffunction name="getSecurityUsers" access="public" returntype="query" hint="I get all security users, the users can access or modify">
		<cfargument name="nameid" required="true" type="string" hint="I am the nameid of the adminstrator">
		<cfargument name="siteid" required="true" type="string" hint="I am the id of the site">
		<cfset var getAdmin=0>
		<cfset var getUsers=0>
		<cfquery name="getAdmin" datasource="#masterdsn#">
			SELECT ROLEID FROM USER_TO_QD_SECURITY_ROLES
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND 
			(
				SITEID=<cfqueryparam value="#mastersiteid#" cfsqltype="cf_sql_varchar">
				OR SITEID=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
			)
			AND ROLEID>=<cfqueryparam value="4" cfsqltype="cf_sql_varchar">
		</cfquery><!--- Admin? --->
		<cfif getAdmin.recordcount GT 0>
			<cfquery name="getUsers" datasource="#masterdsn#">
				SELECT 
					N.NAMEID,
					FIRSTNAME,
					LASTNAME,
					WEMAIL,
					COMPANY,
					HPHONE,
					WPHONE,
					MPHONE,
					ADDRESS1,
					ADDRESS2,
					CITY,
					STATE,
					ZIP,
					(
						SELECT SECURITYROLE FROM QD_SECURITY_ROLES 
						WHERE ROLEID=(SELECT ROLEID FROM USER_TO_QD_SECURITY_ROLES WHERE SITEID=<cfqueryparam value="#arguments.siteid#"> AND NAMEID=N.NAMEID)
					) AS ROLE 
				FROM NAME N,ADDRESS
				WHERE N.NAMEID=ADDRESS.NAMEID
				AND N.NAMEID IN (SELECT NAMEID FROM USER_TO_QD_SECURITY_ROLES WHERE SITEID=<cfqueryparam value="#arguments.siteid#"> AND ROLEID<=<cfqueryparam value="#getAdmin.roleid#">)
			</cfquery>
		</cfif>
		<cfreturn getUsers>
	</cffunction>

</cfcomponent>