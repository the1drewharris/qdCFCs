<cfoutput>
<!-- #GetFileFromPath( GetCurrentTemplatePath() )#-->
</cfoutput>

<!---
|| BEGIN FUSEDOC ||
	
|| Properties ||
Name: Secure.cfm
Author: hal.helms@TeamAllaire.com

|| Responsibilities ||


|| Attributes ||
++> request.self: a FILENAME
++> client.ApplicationID
++> client.userID

==> attributes.requiredPermission
==> attributes.circuitName
==> [attributes.XFA]: a FUSEACTION 

<== [caller.Secure]: a BOOLEAN 

|| END FUSEDOC ||--->


<cftry>
	<cfparam name="attributes.requiredPermission">
	<cfparam name="attributes.circuitName">
	<cfparam name="request.self">
	<cfparam name="client.userID">
	<cfparam name="request.DSN">
	<cfcatch>
		There was a fatal error. Either the requiredPermission, request.self, request.DSN, and/or attributes.circuit is not present.
		<cfabort>
	</cfcatch>
</cftry>

<cfquery datasource="#request.DSN#" name="UserPermissions">
SELECT UNIQUE
	   Permissions.CD_PERMISSION_NAME AS permissionName, 
	   Permissions.CD_PERMISSION_BIT_VALUE AS bitValue, 
	   Circuits.CD_CIRCUIT_ID_PK AS circuitID, 
	   Circuits.CD_CIRCUIT_NAME AS circuitName	   
FROM   
	   DEVELOPMENT.CD_EMP Users,
	   DEVELOPMENT.CD_CIRCUITS Circuits, 
	   DEVELOPMENT.CD_PERMISSIONS Permissions, 
	   DEVELOPMENT.CD_USER_GROUP UserGroups, 
	   DEVELOPMENT.CD_USER_GROUP_ASSIGNMENTS UserGroupAssignments, 
	   DEVELOPMENT.CD_PERMISSION_GROUP_JOIN PermissionGroups
WHERE 
	   Users.CD_EMP_NUM_PK = UserGroupAssignments.CD_EMP_ID_FK 
	   AND
	   UserGroupAssignments.CD_USER_GROUP_ID_FK = UserGroups.CD_USER_GROUP_ID_PK 
	   AND
	   PermissionGroups.CD_USER_GROUP_ID_FK = UserGroups.CD_USER_GROUP_ID_PK 
	   AND
	   PermissionGroups.CD_PERMISSION_ID_FK = Permissions.CD_PERMISSION_ID_PK 
	   AND
	   Permissions.CD_CIRCUIT_ID_FK = Circuits.CD_CIRCUIT_ID_PK
	  AND 
	  Circuits.CD_CIRCUIT_NAME = '#attributes.circuitName#'
	  AND
	  Users.CD_EMP_NUM_PK = '#client.userID#'
</cfquery>

<cfset userCircuitPermissions = 0>
<cfloop query="UserPermissions">
	<cfset userCircuitPermissions = BitOr( userCircuitPermissions, bitValue )>
</cfloop> 


	<cfif BitAnd( attributes.requiredPermission, userCircuitPermissions )>
		<cfset caller.Secure = TRUE> 
	<cfelse>
		<cfif IsDefined( 'attributes.XFA' )>
			<cflocation url="#request.self#?fuseaction=#attributes.XFA#" addtoken="Yes">
		<cfelse>
			<cfset caller.Secure = FALSE>
		</cfif>
	</cfif>
