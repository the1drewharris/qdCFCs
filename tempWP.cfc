<cffunction name="getPageInfo" 
			hint="I get all the detailed information for a page passed to me" 
			output="false"
			returntype="query">
	<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
	<cfargument name="wpid" required="true" hint="I am the id for the web page that you want info on">
	<cfquery name="pageInfo" datasource="#webdsn#">
	SELECT
		WPVERSION.WPID,
		WPVERSION.NAME,
		WPVERSION.URLNAME,
		WPVERSION.WPCONTENT,
		WPVERSION.TITLE,
		WPVERSION.KEYWORDS,
		WPVERSION.DESCRIPTION,
		WPVERSION.WPSTATUS,
		WPVERSION.STARTDATE,
		WPVERSION.ENDDATE,
		WPVERSION.CREATEDON,
		WPVERSION.AUTHORID,
		WPPARENT.PID,
		NAME.FIRSTNAME,
		NAME.LASTNAME
	FROM
		NAME,
		WPVERSION LEFT OUTER JOIN WPPARENT
		ON WPVERSION.WPID=WPPARENT.WPID
	WHERE
		WPVERSION.AUTHORID=NAME.NAMEID
	</cfquery>
</cffunction>

<cffunction name="getPageParent" 
			hint="I get the parentid for a page passed to me" 
			output="false"
			returntype="query">
	<cfargument name="webdsn" required="true" type="string" hint="I am the datasource for the web pages">
	<cfargument name="wpid" required="true" hint="I am the id for the web page that you want info on">
	<cfquery name="pageInfo" datasource="#webdsn#">
	SELECT
		WPID,
		PID
	FROM
		WPPARENT
	WHERE
		WPID=<cfqueryparam value="#wpid#">
	</cfquery>
</cffunction>