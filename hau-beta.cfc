<cfcomponent hint="I have all the heard about us functions">
	<cffunction name="init" access="public" output="no" returntype="void" hint="Initialization, create tables if necessary">
		<cfreturn>
	</cffunction>

	<cffunction name="addhauoption" access="public" output="false" returntype="string" hint="add hau entry">
		<cfargument name="haudsn" required="true" type="String" hint="Data Source">
		<cfargument name="aboutus" required="true" type="String" hint="Where you heard about us">
		<cfargument name="aboutusparentid" required="false" default="0" type="String" hint="Parentid">
		<cfargument name="status" required="false" default="Public" type="String" hint="Status of the entry, could be Public or Deleted">
		<cfset var addentry=0>
		<cfquery name="addentry" datasource="#arguments.haudsn#">
			INSERT INTO HEARDABOUTUS
			(
				ABOUTUS,
				ABOUTUSPARENTID,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#arguments.aboutus#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.aboutusparentid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS ABOUTUSID
		</cfquery>
		<cfreturn addentry.ABOUTUSID>
	</cffunction>
	
	<cffunction name="setSortOrderAndNestLevel" access="public" output="false" returntype="void" hint="I set sortorder and nestlevel">
		<cfargument name="haudsn" required="true" type="String" hint="Data Source">
		<cfargument name="aboutusid" required="true" type="String" hint="I am the aboutusid">
		<cfargument name="sortordervalue" required="true" type="String" hint="I am the sortorder value of aboutusid">
		<cfargument name="aboutusparentid" required="false" type="string" default="0" hint="I am the ">
		<cfset var getParent=0>
		<cfset var update=0>
		<cfif aboutusparentid NEQ 0>
			<cfquery name="getParent" datasource="#arguments.haudsn#">
				SELECT 
					NESTLEVEL,
					SORTORDER
				FROM HEARDABOUTUS
				WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusparentid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset nestlevel=getParent.NESTLEVEL + 1>
			<cfset sortorder="#getParent.SORTORDER#.#arguments.sortordervalue#">
		<cfelse>
			<cfset nestlevel=0>
			<cfset sortorder=arguments.sortordervalue>
		</cfif>
		<cfquery name="update" datasource="#arguments.haudsn#">
			UPDATE HEARDABOUTUS SET 
				NESTLEVEL=<cfqueryparam value="#nestlevel#" cfsqltype="cf_sql_varchar">,
				SORTORDER=<cfqueryparam value="#sortorder#" cfsqltype="cf_sql_varchar">
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="deletehauoption" access="public" output="false" returntype="void" hint="I delete hau option">
		<cfargument name="haudsn" required="true" type="String" hint="Data Source">
		<cfargument name="aboutusid" required="true" type="String" hint="I am the aboutusid">
		<cfset var getparent=0>
		<cfset var getparentinfo=0>
		<cfset var getchildren=0>
		<cfset var update=0>
		<cfset var delete=0>
		
		<cfquery name="getparent" datasource="#arguments.haudsn#">
			SELECT ABOUTUSPARENTID FROM HEARDABOUTUS
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset firstGenerationParent=getparent.ABOUTUSPARENTID>
		<cfif getparent.ABOUTUSPARENTID NEQ 0>
			<cfquery name="getparentinfo" datasource="#arguments.haudsn#">
				SELECT SORTORDER FROM HEARDABOUTUS
				WHERE ABOUTUSID=<cfqueryparam value="#getParent.ABOUTUSPARENTID#">
			</cfquery> 
			<cfset parentSortOrder=getparentinfo.sortorder>
		<cfelse>
			<cfset parentSortOrder=0>
		</cfif>
		
		<cfquery name="getchildren" datasource="#arguments.haudsn#">
			SELECT ABOUTUSID FROM HEARDABOUTUS 
			WHERE ABOUTUSPARENTID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset descendants=ValueList(getchildren.ABOUTUSID)>
		<cfset firstGeneration=descendants>
		
		<cfloop condition="len(descendants) GT 0">
			<cfset me=listFirst(descendants)>
			<cfset descendants=ListDeleteAt(descendants,1)>
			<cfset sortcode=application.objtextconversion.convertNumberToSortCode(me)>
			<cfif listfindnocase(firstgeneration,me) GT 0>
				<cfif parentsortorder NEQ 0>
					<cfset sortcode="#parentSortOrder#.#sortcode#">
				</cfif>
				<cfquery name="update" datasource="#arguments.haudsn#">
					UPDATE HEARDABOUTUS SET
						ABOUTUSPARENTID=<cfqueryparam value="#firstGenerationParent#" cfsqltype="cf_sql_varchar">,
						SORTORDER=<cfqueryparam value="#sortcode#" cfsqltype="cf_sql_varchar">,
						NESTLEVEL=((SELECT NESTLEVEL FROM HEARDABOUTUS WHERE ABOUTUSID=<cfqueryparam value="#me#">)-1)
					WHERE ABOUTUSID=<cfqueryparam value="#me#" cfsqltype="cf_sql_varchar">
				</cfquery>
			<cfelse>
				<cfquery name="get" datasource="#arguments.haudsn#">
					SELECT SORTORDER FROM HEARDABOUTUS
					WHERE ABOUTUSID IN (SELECT ABOUTUSPARENTID FROM HEARDABOUTUS WHERE ABOUTUSID=<cfqueryparam value="#me#">)
				</cfquery>
				<cfset sortcode="#get.SORTORDER#.#sortcode#">
				<cfquery name="update" datasource="#arguments.haudsn#">
					UPDATE HEARDABOUTUS SET
						SORTORDER=<cfqueryparam value="#sortcode#" cfsqltype="cf_sql_varchar">,
						NESTLEVEL=((SELECT NESTLEVEL FROM HEARDABOUTUS WHERE ABOUTUSID=<cfqueryparam value="#me#">)-1)
					WHERE ABOUTUSID=<cfqueryparam value="#me#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
			<cfquery name="get" datasource="#arguments.haudsn#">
				SELECT ABOUTUSID FROM HEARDABOUTUS 
				WHERE ABOUTUSPARENTID=<cfqueryparam value="#me#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif get.recordcount GT 0>
				<cfset children=valueList(get.ABOUTUSID)>
				<cfset descendants=ListAppend(descendants,children)>
			</cfif>
		</cfloop>
		
		<cfquery name="delete" datasource="#arguments.haudsn#">
			UPDATE HEARDABOUTUS SET
				STATUS=<cfqueryparam value="Deleted" cfsqltype="cf_sql_varchar">,
				ABOUTUSPARENTID=<cfqueryparam value="0" cfsqltype="cf_sql_varchar">
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="getDescendants" access="public" output="false" returntype="string" hint="I return list of descendants of heard about us option">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="aboutusid">
		<cfset var get=0>
		<cfset var sortordervalue=getSortOrder(arguments.haudsn,arguments.aboutusid)>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT ABOUTUSID FROM HEARDABOUTUS
			WHERE SORTORDER LIKE <cfqueryparam value="#sortordervalue#.%">
			AND STATUS <> <cfqueryparam value="deleted" cfsqltype="cf_sql_varchar">
			ORDER BY NESTLEVEL
		</cfquery>
		<cfreturn valueList(get.aboutusid)>
	</cffunction>

	<cffunction name="updatehauoption" access="public" output="true" returntype="void" hint="edit hau entry">
		<cfargument name="haudsn" required="true" type="String" hint="Data Source">
		<cfargument name="aboutusid" required="true" type="String" hint="I am the aboutusid">
		<cfargument name="aboutus" required="true" default="0" type="String" hint="Where you heard about us">
		<cfargument name="aboutusparentid" required="false" default="-1" type="String" hint="Parentid">
		<cfargument name="status" required="false" default="0" type="String" hint="Status of the entry, could be Public or Deleted">
		<cfset var update=0>
		<cfset var getinfo=0>
		<cfset var get=0>
		<cfset var descendants="">
		<cfset var nestlevelvalue=0>
		<cfset var sortordervalue=application.objtextconversion.convertNumberToSortCode(arguments.aboutusid)>
		<cfif arguments.aboutusparentid NEQ -1>
			<cfset descendants=getDescendants(arguments.haudsn,arguments.aboutusid)>
			<cfset sortordervalue=application.objtextconversion.convertNumberToSortCode(arguments.aboutusid)>
			<cfif arguments.aboutusparentid NEQ 0>
				<cfquery name="getinfo" datasource="#arguments.haudsn#">
					SELECT SORTORDER,NESTLEVEL FROM HEARDABOUTUS
					WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusparentid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfset sortordervalue="#getinfo.sortorder#.#sortordervalue#">
				<cfset nestlevelvalue=getinfo.nestlevel + 1>
			</cfif>
		</cfif>
		
		<cfquery name="update" datasource="#arguments.haudsn#">
			UPDATE HEARDABOUTUS SET 
				ABOUTUS=<cfqueryparam value="#arguments.aboutus#" cfsqltype="cf_sql_varchar">
				<cfif arguments.aboutusparentid NEQ -1>
					,ABOUTUSPARENTID=<cfqueryparam value="#arguments.aboutusparentid#" cfsqltype="cf_sql_varchar">
					,SORTORDER=<cfqueryparam value="#sortordervalue#" cfsqltype="cf_sql_varchar">
					,NESTLEVEL=<cfqueryparam value="#nestlevelvalue#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.status NEQ 0>
					,STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				</cfif>
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif listlen(descendants) GT 0>
			<cfdump var="#descendants#">
			<cfloop list="#descendants#" index="descendant">
				<cfset myparent=getparent(arguments.haudsn,descendant)>
				<cfset sortordervalue=application.objtextconversion.convertNumberToSortCode(descendant)>
				<cfquery name="getinfo" datasource="#arguments.haudsn#">
					SELECT SORTORDER,NESTLEVEL FROM HEARDABOUTUS
					WHERE ABOUTUSID=<cfqueryparam value="#myparent#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfdump var="#getinfo#">
				<cfset sortordervalue="#getinfo.sortorder#.#sortordervalue#">
				<cfset nestlevelvalue=getinfo.nestlevel + 1>
				<cfquery name="update" datasource="#arguments.haudsn#">
					UPDATE HEARDABOUTUS SET
						SORTORDER=<cfqueryparam value="#sortordervalue#" cfsqltype="cf_sql_varchar">,
						NESTLEVEL=<cfqueryparam value="#nestlevelvalue#" cfsqltype="cf_sql_varchar">
					WHERE ABOUTUSID=<cfqueryparam value="#descendant#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfloop>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getchildren" access="public" output="false" returntype="query" hint="I get all children of the heardaboutus whose id is passed">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="aboutusid">
		<cfset var children=0>
		<cfquery name="children" datasource="#arguments.haudsn#" >
			SELECT
				ABOUTUSID,
				ABOUTUS,
				STATUS
			FROM HEARDABOUTUS
			WHERE STATUS <> 'DELETED'
			<cfif arguments.heardaboutusid NEQ 0>
			AND ABOUTUSPARENTID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn children>
	</cffunction> 
	
	<cffunction name="getHau" access="public" output="false" returntype="query" hint="I get all hau except the ones deleted. Return fields: ABOUTUSID, ABOUTUS, ABOUTUSPARENTID, STATUS">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="aboutusid">
		<cfargument name="orderby" required="false" default="0" type="String" hint="If 1 is passed, query will be order by aboutusparentid">
		<cfargument name="excludelist" required="false" default="0" type="any" hint="I am the list of aboutusid to exclude">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#" >
			SELECT
				ABOUTUSID,
				ABOUTUS,
				ABOUTUSPARENTID,
				STATUS
			FROM HEARDABOUTUS
			WHERE STATUS <> 'DELETED'
			<cfif arguments.aboutusid NEQ 0>
			AND ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.excludelist NEQ "0">
			AND ABOUTUSID NOT IN (#arguments.excludelist#)
			</cfif>
			<cfif orderby EQ "1">
			ORDER BY ABOUTUSPARENTID
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getHauOptions" access="public" output="false" returntype="query" hint="I get all hau except the ones deleted. Return fields: ABOUTUSID, ABOUTUS, ABOUTUSPARENTID, STATUS">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="excludelist" required="false" default="0" type="string" hint="I am the list of aboutusid to exclude">
		<cfargument name="aboutusid" required="false" default="0" type="string" hint="I am the id of the aboutus">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#" >
			SELECT
				ABOUTUSID,
				ABOUTUS,
				ABOUTUSPARENTID,
				NESTLEVEL,
				SORTORDER,
				STATUS
			FROM HEARDABOUTUS
			WHERE STATUS <> 'DELETED'
			<cfif arguments.excludelist NEQ "0">
			AND ABOUTUSID NOT IN (#arguments.excludelist#)
			</cfif>
			<cfif arguments.aboutusid NEQ 0>
			AND ABOUTUSID = <cfqueryparam value="#arguments.aboutusid#">
			</cfif>
			<cfif arguments.aboutusid EQ 0>
			ORDER BY SORTORDER
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getEvents" access="public" output="false" returntype="query" hint="I get all the events">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT     
				DISTINCT
				EVENT.EVENTID, 
				EVENT.EVENTNAME,
				USERGROUPS.USERGROUPNAME,
				USERGROUPS.USERGROUPID
			FROM         
				EVENT2USERGROUP,
				EVENT,
				EVENTVERSION,
				USERGROUPS
				WHERE  EVENT2USERGROUP.EVENTID = EVENT.EVENTID
				AND EVENT.EVENTID = EVENTVERSION.EVENTID
				AND EVENT2USERGROUP.USERGROUPID = USERGROUPS.USERGROUPID
				AND (EVENT2USERGROUP.USERGROUPID IS NOT NULL)  
				AND EVENTVERSION.STATUS = 'PUBLIC'
				ORDER BY EVENT.EVENTID, USERGROUPS.USERGROUPID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="gethauonevent" access="public" returntype="query" output="false" hint="I get all the heardaboutus items. If the intheevent is 1, the aboutus is in the event, else its not. Return fields: ABOUTUSID,ABOUTUS,ABOUTUSPARENTID,STATUS,INTHEEVENT">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="regeventid" required="true" type="String" hint="registered event id">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT
				HEARDABOUTUS.ABOUTUSID,
				HEARDABOUTUS.ABOUTUS,
				HEARDABOUTUS.ABOUTUSPARENTID,
				HEARDABOUTUS.NESTLEVEL,
				HEARDABOUTUS.SORTORDER,
				HEARDABOUTUS.STATUS,
				1 AS INTHEEVENT
			FROM HEARDABOUTUS, HAU2EVENT
			WHERE HAU2EVENT.EVENTID = <cfqueryparam value="#arguments.regeventid#" cfsqltype="cf_sql_varchar">
			AND	HEARDABOUTUS.STATUS <> <cfqueryparam value="Deleted" cfsqltype="cf_sql_varchar">
			AND HEARDABOUTUS.ABOUTUSID = HAU2EVENT.ABOUTUSID
			UNION
			SELECT
				ABOUTUSID,
				ABOUTUS,
				ABOUTUSPARENTID,
				NESTLEVEL,
				SORTORDER,
				STATUS,
				0 AS INTHEEVENT
			FROM HEARDABOUTUS
			WHERE ABOUTUSID NOT IN
			( 
				SELECT HEARDABOUTUS.ABOUTUSID
				FROM HEARDABOUTUS, HAU2EVENT
				WHERE HAU2EVENT.EVENTID = <cfqueryparam value="#arguments.regeventid#" cfsqltype="cf_sql_varchar">
				AND HEARDABOUTUS.ABOUTUSID = HAU2EVENT.ABOUTUSID
			)
			AND	HEARDABOUTUS.STATUS <> <cfqueryparam value="Deleted" cfsqltype="cf_sql_varchar">
			ORDER BY HEARDABOUTUS.SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="deletehau2event" access="public" output="false" hint="I delete hau from an event">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="eventid" required="true" type="String" hint="registered event id">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.haudsn#" >
			DELETE FROM HAU2EVENT
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="updatehau2event" access="public" output="false" hint="I delete hau from an event">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="oldeventid" required="true" type="String" hint="old event id">
		<cfargument name="neweventid" required="true" type="String" hint="new event id">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.haudsn#" >
			UPDATE HAU2EVENT
			SET EVENTID=<cfqueryparam value="#arguments.neweventid#" cfsqltype="cf_sql_varchar">
			WHERE EVENTID=<cfqueryparam value="#arguments.oldeventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="getreport" access="public" returntype="query" output="false" hint="I generate report for hau event">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="eventid" required="true" type="String" hint="I am the event for which report is requested">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT 
				ABOUTUSID, 
				(SELECT ABOUTUS FROM HEARDABOUTUS WHERE ABOUTUSID=HAU2PEOPLE.ABOUTUSID) AS ABOUTUS,
				COUNT(ABOUTUSID) AS NOOFPEOPLE
			FROM HAU2PEOPLE
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
			GROUP BY ABOUTUSID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="addhautoevent" access="public" returntype="void" output="false" hint="I">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="eventid" required="true" type="String" hint="I am the event to which hau should be added">
		<cfargument name="aboutusid" required="true" type="String" hint="I am the aboutusid">
		<cfset var add=0>
		<cfset var addparent=0>
		<cfset var parentid=getparent(arguments.haudsn,arguments.aboutusid)>
		
		<cfif parentid NEQ 0>
			<cfquery name="check" datasource="#arguments.haudsn#">
				SELECT ABOUTUSID FROM HAU2EVENT
				WHERE ABOUTUSID=<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">	
			</cfquery>
			<cfif check.recordcount EQ 0>
				<cfquery name="addparent" datasource="#arguments.haudsn#">
					INSERT INTO HAU2EVENT
					(
						ABOUTUSID,
						EVENTID
					)
					VALUES
					(
						<cfqueryparam value="#parentid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfif>
		</cfif>
		<cfquery name="add" datasource="#arguments.haudsn#">
			INSERT INTO HAU2EVENT
			(
				ABOUTUSID,
				EVENTID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addhaulisttoevent" access="public" returntype="void" output="false" hint="I">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="eventid" required="true" type="String" hint="I am the event to which hau should be added">
		<cfargument name="haulist" required="true" type="String" hint="I am the aboutusid">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.haudsn#">
			<cfloop list="#arguments.haulist#" index="i">
				INSERT INTO HAU2EVENT
				(
					ABOUTUSID,
					EVENTID
				)
				VALUES
				(
					<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
				)
			</cfloop>
		</cfquery>
	</cffunction>

	<cffunction name="deleteFromEvent" access="public" returntype="query" output="false" hint="I delete heard about us from an event">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="eventid" required="true" type="String" hint="I am the event to which hau should be added">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="I am the aboutusid">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.haudsn#">
			DELETE FROM HAU2EVENT 
			WHERE EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
			<cfif aboutusid NEQ "0">			
			AND ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
	</cffunction>
	
	<cffunction name="getparent" access="public" returntype="String" output="false" hint="I return parentid of the aboutus">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="I am the aboutusid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT 
				ABOUTUSPARENTID
			FROM HEARDABOUTUS
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
			AND STATUS <> 'DELETED'
		</cfquery>
		<cfreturn get.ABOUTUSPARENTID>
	</cffunction>
	
	<cffunction name="getmyparent" access="public" returntype="String" output="false" hint="I return parentid,nestlevel,status">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" default="0" type="String" hint="I am the aboutusid">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT 
				ABOUTUSPARENTID,
				NESTLEVEL,
				SORTORDER
			FROM HEARDABOUTUS
			WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
			AND STATUS <> 'DELETED'
		</cfquery>
		<cfreturn get.ABOUTUSPARENTID>
	</cffunction>
	
	<cffunction name="getelligibleparent" access="public" returntype="query" output="false" hint="I return HAU entries whose parentid is 0. Return fields: ABOUTUSID, ABOUTUS, STATUS. I am about to be obselete">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT
				ABOUTUSID,
				ABOUTUS,
				STATUS
			FROM HEARDABOUTUS
			WHERE ABOUTUSPARENTID=0
			AND STATUS <> 'DELETED'
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getmyelligibleparent" access="public" returntype="query" output="false" hint="I return HAU entries whose parentid is 0. Return fields: ABOUTUSID, ABOUTUS, STATUS. I will replace getelligibleparent">
		<cfargument name="haudsn" required="true" type="String" hint="data source">
		<cfargument name="aboutusid" required="false" type="string" default="0" hint="id of the hau option whose elligible parents are to be found">
		<cfset var get=0>
		<cfset var descendants="">
		<cfif arguments.aboutusid NEQ 0>
			<cfset descendants=getDescendants(arguments.haudsn,arguments.aboutusid)>
		</cfif>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT
				ABOUTUSID,
				ABOUTUS,
				NESTLEVEL,
				STATUS
			FROM HEARDABOUTUS
			WHERE STATUS <> 'DELETED'
			<cfif arguments.aboutusid NEQ 0>
				AND ABOUTUSID <> <cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
				<cfif descendants NEQ "">
					AND ABOUTUSID NOT IN (#descendants#)
				</cfif>
			</cfif>
			ORDER BY SORTORDER
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="addhau2people" access="public" returntype="void" output="false" hint="I add hau to people entry">
		<cfargument name="haudsn" required="true" type="string" hint="data source">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person participating in hau survey">
		<cfargument name="haulist" required="true" type="string" hint="List of hau ids">
		<cfargument name="eventid" required="true" type="string" hint="Id of the event">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.haudsn#">
			<cfloop list="#arguments.haulist#" index="i">
				INSERT INTO HAU2PEOPLE
				(
					ABOUTUSID,
					NAMEID,
					EVENTID
				)
				VALUES
				(
					<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
				)
			</cfloop>
		</cfquery>
	</cffunction>
		
	<cffunction name="updatehau2people" access="public" returntype="void" output="false" hint="I add hau to people entry">
		<cfargument name="haudsn" required="true" type="string" hint="data source">
		<cfargument name="oldeventid" required="true" type="string" hint="old eventid">
		<cfargument name="neweventid" required="true" type="string" hint="new eventid">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.haudsn#">
			UPDATE HAU2PEOPLE
			SET EVENTID=<cfqueryparam value="#arguments.neweventid#" cfsqltype="cf_sql_varchar">
			WHERE EVENTID=<cfqueryparam value="#arguments.oldeventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="getmyhau" access="public" returntype="query" output="false" hint="I get the the latest hau entry of a person for the event">
		<cfargument name="haudsn" required="true" type="string" hint="data source">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person participating in hau survey">
		<cfargument name="eventid" required="true" type="string" hint="Id of the event">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT
				ABOUTUSID,
				NAMEID,
				EVENTID
			FROM HAU2PEOPLE
			WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			AND EVENTID=<cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getSortOrder" access="public" returntype="string" output="false" hint="I return sortorder of the hau option">
		<cfargument name="haudsn" required="true" type="string" hint="data source">
		<cfargument name="aboutusid" required="true" type="string" hint="id of the heard about us option">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.haudsn#">
			SELECT SORTORDER FROM HEARDABOUTUS WHERE ABOUTUSID=<cfqueryparam value="#arguments.aboutusid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.SORTORDER>
	</cffunction>
</cfcomponent>