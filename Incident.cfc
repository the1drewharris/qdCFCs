<cfcomponent hint="I handle errors and bugs">
	<cfobject component="timeDateConversion" name="mytime">
	
	<cffunction name="recordIncident" access="public" returntype="void" hint="I record incident">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfargument name="incidentname" type="String" required="true" hint="Name given to the incident">
		<cfargument name="incidenturl" type="String" required="true" hint="URL where the incident occured">
		<cfargument name="nameid" type="String" required="true" hint="Person who reported the incident">
		<cfargument name="errordescription" type="String" required="true" hint="Error message that came up when this incident occured">
		<cfargument name="incidentdoing" type="String" required="false"  default="0" hint="What the user was doing when the incident occured">
		<cfargument name="OSID" type="String" required="false"  default="0" hint="Operating System ID">
		<cfargument name="screenshotid" type="String" required="false" default="0" hint="Screenshot of the webpage when this incident occured">
		<cfargument name="siteid" type="String" required="false" default="0" hint="SITE where this incident occured">
		<cfargument name="emailclientid" type="String" required="false" default="0" hint="Email client that was used when this incident occured">
		<cfargument name="browserid" type="String" required="false"  default="0" hint="Browser that was being used when this incident occured">
		<cfargument name="incidentcategoryid" type="String" required="false"  default="0" hint="Category of the incident">
		<cfargument name="error" type="String" required="false"  default="0" hint="Error">
		<cfargument name="screenres" type="String" required="false"  default="0" hint="Screen Resolution">
		<cfargument name="attachment" type="String" required="false"  default="0" hint="Attachment submitted with the incident">
	
		<cfset var report=0>
		
		<cfquery name="report" datasource="#incidentdsn#">
			INSERT INTO INCIDENT
			(
				INCIDENTNAME,
				INCIDENTURL,
				NAMEID,
				ERRORDESCRIPTION,
				TIMEREPORTED,
				STATUSID
				<cfif arguments.incidentdescription NEQ "0">
				,INCIDENTDESCRIPTION
				</cfif>
				<cfif arguments.incidentdoing NEQ "0">
				,INCIDENTDOING
				</cfif>
				<cfif arguments.screenshotid NEQ "0">
				,SCREENSHOTID
				</cfif>
				<cfif arguments.siteid NEQ "0">
				,SITEID
				</cfif>
				<cfif arguments.emailclientid NEQ "0">
				,EMAILCLIENTID
				</cfif>
				<cfif arguments.browserid NEQ "0">
				,BROWSERID
				</cfif>
				<cfif arguments.osid NEQ "0">
				,OSID
				</cfif>
				<cfif arguments.incidentcategoryid NEQ "0">
				,INCIDENTCATEGORYID
				</cfif>
				<cfif arguments.error NEQ "0">
				,ERROR
				</cfif>
				<cfif arguments.screenres NEQ "0">
				,SCREENRES
				</cfif>
				<cfif arguments.attachment NEQ "0">
				,ATTACHMENT
				</cfif>
			)
			
			VALUES
			(
				<cfqueryparam value="#arguments.incidentname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.incidenturl#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.errordescription#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				'0'
				<cfif arguments.incidentdescription NEQ "0">
				,<cfqueryparam value="#arguments.incidentdescription#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.incidentdoing NEQ "0">
				,<cfqueryparam value="#arguments.incidentdoing#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.screenshotid NEQ "0">
				,<cfqueryparam value="#arguments.screenshotid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.siteid NEQ "0">
				,<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.emailclientid NEQ "0">
				,<cfqueryparam value="#arguments.emailclientid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.browserid NEQ "0">
				,<cfqueryparam value="#arguments.browserid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.osid NEQ "0">
				,<cfqueryparam value="#arguments.osid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.incidentcategoryid NEQ "0">
				,<cfqueryparam value="#arguments.incidentcategoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.error NEQ "0">
				,<cfqueryparam value="#arguments.error#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.screenres NEQ "0">
				,<cfqueryparam value="#arguments.screenres#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.attachment NEQ "0">
				,<cfqueryparam value="#arguments.attachment#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
		
		</cfquery>
	</cffunction>
	
	<cffunction name="addscreenshot" access="public" returntype="String" hint="I add screenshot">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfargument name="screenshotname" type="String" required="true" hint="name of the screenshotfile">
		<cfargument name="nameid" type="String" required="true" hint="Person who is submitting the screenshot">
		<cfset var add=0>
		<cfquery name="add" datasource="#incidentdsn#">
			INSERT INTO SCREENSHOT
			(
				SCREENSHOTNAME,
				NAMEID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.screenshotname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS SCREENSHOTID
		</cfquery>
		<cfreturn add.SCREENSHOTID>
	</cffunction>
	
	<cffunction name="getIncidents" access="public" output="no" returntype="query" hint="I get incidents">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfargument name="nameid" type="string" required="false" default="0" hint="Person who reported the incident">
		<cfargument name="incidentid" required="false" default="0" hint="ID of the incident">
		<cfargument name="siteid" required="false" default="0" hint="siteid">
		<cfargument name="statusid" required="false" default="-1" hint="statusid of the incident">
		<cfset var incidents=0>
		<cfquery name="incidents" datasource="#incidentdsn#">
			SELECT 
				INCIDENT.INCIDENTID,
				INCIDENT.INCIDENTNAME,
				INCIDENT.INCIDENTDESCRIPTION,
				INCIDENT.INCIDENTDOING,
				INCIDENT.INCIDENTURL,
				INCIDENT.SCREENSHOTID,
				SCREENSHOT.SCREENSHOTNAME,
				INCIDENT.SITEID,
				INCIDENT.EMAILCLIENTID,
				INCIDENT.BROWSERID,
				BROWSER.BROWSERNAME,
				INCIDENT.OSID,
				OS.OSNAME,
				INCIDENT.NAMEID,
				INCIDENT.INCIDENTCATEGORYID,
				INCIDENT.ERROR,
				INCIDENT.ERRORDESCRIPTION,
				INCIDENT.SCREENRES,
				INCIDENT.TIMEREPORTED,
				INCIDENT.ATTACHMENT,
				INCIDENT.STATUSID,
				INCIDENT.SOLUTIONID,
				INCIDENT.RESOLVEDON,
				INCIDENT.PRIORITYID
			FROM INCIDENT
			LEFT JOIN SCREENSHOT
			ON INCIDENT.SCREENSHOTID=SCREENSHOT.SCREENSHOTID
			LEFT JOIN OS
			ON INCIDENT.OSID=OS.OSID
			LEFT JOIN BROWSER
			ON INCIDENT.BROWSERID=BROWSER.BROWSERID
			WHERE 1=1
			<cfif arguments.nameid NEQ "0"> 
				AND INCIDENT.NAMEID=<cfqueryparam value="#arguments.nameid#">
			</cfif>
			<cfif incidentid NEQ "0">
				AND INCIDENTID like <cfqueryparam value="#arguments.incidentid#">
			</cfif>
			<cfif arguments.siteid NEQ "0">
				AND SITEID =<cfqueryparam value="#arguments.siteid#" >
			</cfif>
			<cfif arguments.statusid NEQ "-1">
				AND STATUSID=<cfqueryparam value="#arguments.statusid#">
			</cfif>
			ORDER BY TIMEREPORTED DESC
		</cfquery>
		<cfreturn incidents>
	</cffunction>
	
	<cffunction name="getNoOfIncidents" access="public" returntype="string" hint="return value: no of incidents">
		<cfargument name="siteids" required="true" type="string" hint="id of the site">
		<cfargument name="statusid" required="true" type="string" hint="status id of the incident">
		<cfargument name="incidentdsn" required="true" type="string" hint="database name">
		<cfset var get=0>
		<cfset var firstSite=listfirst(arguments.siteids)>
		<cfquery name="get" datasource="#arguments.incidentdsn#">
			SELECT COUNT(*) AS N FROM INCIDENT I
			WHERE STATUSID=<cfqueryparam value="#arguments.statusid#">
			<cfif arguments.siteids NEQ 0>
				AND
				(
					I.SITEID=<cfqueryparam value="#firstSite#">
					<cfif arguments.siteids NEQ firstSite>
						<cfloop list="#arguments.siteids#" index="sid">
							OR I.SITEID=<cfqueryparam value="#sid#">
						</cfloop>
					</cfif>
				)
			</cfif>
		</cfquery>
		<cfreturn get.N>
	</cffunction>
	
	<cffunction name="getIncidentHeaders" access="public" returntype="query" hint="return fields: INCIDENTID, INCIDENTDESCRIPTION, REPORTEDBY, REPORTEDON, SCREENSHOT">
		<cfargument name="siteids" required="true" type="string" hint="id of the site">
		<cfargument name="statusid" required="true" type="string" hint="status id of the incident">
		<cfargument name="incidentdsn" required="true" type="string" hint="database name">
		<cfargument name="startvalue" required="true" type="string" hint="start value">
		<cfargument name="perpage" required="true" type="string" hint="per page">
		<cfset var get=0>
		<cfset var endvalue=arguments.startvalue + arguments.perpage>
		<cfset var firstSite=listfirst(arguments.siteids)>
		<cfquery name="get" datasource="#arguments.incidentdsn#">
			SELECT * FROM 
			(
				SELECT
					I.INCIDENTID,
					I.INCIDENTURL,
					I.INCIDENTDESCRIPTION,
					I.TIMEREPORTED,
					I.NAMEID,
					S.SCREENSHOTNAME,
					ROW_NUMBER() OVER (ORDER BY I.INCIDENTID DESC) AS ROW
				FROM INCIDENT I
				LEFT JOIN SCREENSHOT S
				ON I.SCREENSHOTID=S.SCREENSHOTID
				WHERE I.STATUSID=<cfqueryparam value="#arguments.statusid#">
				<cfif arguments.siteids NEQ 0>
					AND
					(
						I.SITEID=<cfqueryparam value="#firstSite#">
						<cfif arguments.siteids NEQ firstSite>
							<cfloop list="#arguments.siteids#" index="sid">
								OR I.SITEID=<cfqueryparam value="#sid#">
							</cfloop>
						</cfif>
					)
				</cfif>
			) ALLINCIDENTS
			WHERE ROW > <cfqueryparam value='#arguments.startvalue#'>
			AND ROW <= <cfqueryparam value="#endvalue#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="updateIncident" access="public" output="no" returntype="void" hint="I update incident information">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfargument name="incidentid" type="String" required="true" hint="ID of the incident">
		<cfargument name="statusid" type="string" required="false" default="0" hint="Status of the incident">
		<cfargument name="solutionid" type="string" required="false" default="0" hint="Solution of the incident">
		<cfargument name="priority" type="string" required="false" default="0" hint="Priority, 100 being highest priority">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.incidentdsn#">
			UPDATE INCIDENT SET
			STATUSID=<cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.statusid EQ "2">
			,RESOLVEDON=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			<cfelseif arguments.solutionid NEQ "0">
			SOLUTIONID=<cfqueryparam value="#solutionid#" cfsqltype="cf_sql_varchar">
			<cfelseif arguments.priority NEQ "0">
			PRIORITY=<cfqueryparam value="#arguments.priority#" cfsqltype="cf_sql_varchar">
			<cfelseif arguments.solutionid NEQ "0">
			SOLUTIONID=<cfqueryparam value="#arguments.solutionid#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE INCIDENTID=<cfqueryparam value="#arguments.incidentid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="getBrowsers" access="public" output="no" returntype="query" hint="I get list of browsers. Return fields: BROWSERID,BROWSERNAME">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfset var browsers=0>
		<cfquery name="browsers" datasource="#incidentdsn#">
			SELECT
				BROWSERID,
				BROWSERNAME
			FROM BROWSER
		</cfquery>
		<cfreturn browsers>
	</cffunction>
	
	<cffunction name="getOS" access="public" output="no" returntype="query" hint="I get the list of OS. Return fields: OSID,OSNAME">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfset var oslist=0>
		<cfquery name="oslist" datasource="#incidentdsn#">
			SELECT
				OSID,
				OSNAME
			FROM OS
		</cfquery>
		<cfreturn oslist>
	</cffunction>
	
	<cffunction name="getCategories" access="public" output="no" returntype="query" hint="I get the list of incident categories. Return fields: INCIDENTCATEGORYID, INCIDENTCATEGORYNAME">
		<cfargument name="incidentdsn" type="String" required="true" hint="Datasource">
		<cfset var categorylist=0>
		<cfquery name="categorylist" datasource="#incidentdsn#">
			SELECT
				INCIDENTCATEGORYID, 
				INCIDENTCATEGORYNAME
			FROM INCIDENTCATEGORY
		</cfquery>
		<cfreturn categorylist>
	</cffunction>
</cfcomponent>