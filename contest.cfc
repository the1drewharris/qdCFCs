<cfcomponent hint="I have funcions for contest">
	<cfobject name="mytime" component="timedateconversion">
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
	<cffunction name="createtables" access="private" returntype="void" hint="I create contest tables">
		<!--- the fieldname description should be treated as name of the contest and longdescription as description of the contest. these fields were added on 20090612 as per request from 918moms(Melanie) --->
		<cfquery name="createtables" datasource="dummy.com">
			DROP TABLE WINNER;
			DROP TABLE CONTESTENTRY;
			DROP TABLE CONTEST;
			
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
	</cffunction>
	
	<cffunction name="addContest" access="public" returntype="numeric" hint="I add contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who creates contest">
		<cfargument name="description" required="true" type="String" hint="Name of the  contest">
		<cfargument name="longdescription" required="false" default="" type="String" hint="Name of the  contest">
		<cfargument name="question" required="false" type="String" Default="" hint="Name of the  contest">
		<cfargument name="startdate" required="true" type="String" hint="Start date for the contest">
		<cfargument name="enddate" required="true" type="String" hint="End date for the contest">
		<cfargument name="answerrequired" required="false" default="0" type="String" hint="1 if answers is required from people participating in the contest">
		<cfargument name="imagerequired" required="false" default="0" type="String" hint="1 if image is required">
		<cfargument name="videorequired" required="false" default="0" type="String" hint="1 if video is required">
		<cfset var addcontest=0>
		<cfquery name="addcontest" datasource="#arguments.contestdsn#">
			INSERT INTO CONTEST
			(
				NAMEID,
				DESCRIPTION,
				LONGDESCRIPTION,
				QUESTION,
				RECORDEDON,
				STARTDATE,
				ENDDATE,
				ANSWERREQUIRED,
				IMAGEREQUIRED,
				VIDEOREQUIRED
			)
			VALUES
			(
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.longdescription#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.question#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.answerrequired#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.imagerequired#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.videorequired#" cfsqltype="cf_sql_varchar">
				
			)
			SELECT @@IDENTITY AS CONTESTID
		</cfquery>
		<cfreturn addcontest.CONTESTID>
	</cffunction> 
	
	<cffunction name="getContest" access="public" returntype="query" hint="I get all the fields of a particular contest. Returned fields:DESCRIPTION,RECORDEDON,STARTDATE,ENDDATE,ANSWERREQUIRED">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest">
		<cfargument name="status" required="false" type="string" default="0" hint="pass value other than 0 to get contest only if it is active"> 
		<cfset var getcontest=0>
		<cfquery name="getcontest" datasource="#arguments.contestdsn#">
			SELECT 
			DESCRIPTION,
			LONGDESCRIPTION,
			QUESTION,
			RECORDEDON,
			STARTDATE,
			ENDDATE,
			ANSWERREQUIRED,
			IMAGEREQUIRED,
			VIDEOREQUIRED
			FROM CONTEST
			WHERE CONTESTID=<cfqueryparam value="#arguments.contestid#" cfsqltype="cf_sql_bigint">
			<cfif status NEQ 0>
			AND	STARTDATE>=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			AND ENDDATE<<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY STARTDATE DESC
		</cfquery>
		<cfreturn getcontest>
	</cffunction>
	
	<cffunction name="editContest" access="public" returntype="void" hint="I edit contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="description" required="true" type="String" hint="Name of the  contest">
		<cfargument name="longdescription" required="false" default="" type="String" hint="Name of the  contest">
		<cfargument name="question" required="false" type="String" Default="" hint="Name of the  contest">
		<cfargument name="startdate" required="true" type="String" hint="Start date for the contest">
		<cfargument name="enddate" required="true" type="String" hint="End date for the contest">
		<cfargument name="answerrequired" required="false" default="0" type="String" hint="1 if answers is required from people participating in the contest">
		<cfargument name="imagerequired" required="false" default="0" type="String" hint="1 if image is required">
		<cfargument name="videorequired" required="false" default="0" type="String" hint="1 if video is required">
		<cfquery name="editcontest" datasource="#arguments.contestdsn#">
			UPDATE CONTEST
			SET
			DESCRIPTION=<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
			LONGDESCRIPTION=<cfqueryparam value="#arguments.longdescription#" cfsqltype="cf_sql_longvarchar">,
			QUESTION=<cfqueryparam value="#arguments.question#" cfsqltype="cf_sql_longvarchar">,
			STARTDATE=<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
			ENDDATE=<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">,
			ANSWERREQUIRED=<cfqueryparam value="#arguments.answerrequired#" cfsqltype="cf_sql_varchar">,
			IMAGEREQUIRED=<cfqueryparam value="#arguments.imagerequired#" cfsqltype="cf_sql_varchar">,
			VIDEOREQUIRED=<cfqueryparam value="#arguments.videorequired#" cfsqltype="cf_sql_varchar">
			WHERE CONTESTID=<cfqueryparam value="#arguments.contestid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction> 
	
	<cffunction name="getAllContest" access="public" returntype="query" hint="I get all contests. Return fields: CONTESTID,DESCRIPTION,RECORDEDON,STARTDATE,ENDDATE,ANSWERREQUIRED">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="nameid" required="false" default="0" type="numeric" hint="nameid of the person who created contests">
		<cfargument name="status" required="false" type="string" default="0" hint="status of the contest">
		<cfargument name="criteria" required="false" type="string" default="0" hint="search criteria">
		<cfset var getallcontest=0>
		<cfquery name="getallcontest" datasource="#contestdsn#">
			SELECT 
			CONTESTID,
			DESCRIPTION,
			LONGDESCRIPTION,
			QUESTION,
			RECORDEDON,
			STARTDATE,
			ENDDATE,
			ANSWERREQUIRED
			FROM CONTEST
			WHERE 1=1
			<cfif arguments.status NEQ 0>
			AND	STARTDATE<=<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			AND ENDDATE><cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.nameid NEQ "0">
			AND NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_bigint">
			</cfif>
			<cfif arguments.criteria NEQ "0">
			AND description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			OR longdescription LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			OR question LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY STARTDATE DESC
		</cfquery>
		<cfreturn getallcontest>
	</cffunction>
	
	<cffunction name="addEntry" access="public" returntype="void" hint="I add contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest">  
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who participates in contest">
		<cfargument name="entrytext" required="false" type="String" default="0" hint="answer if required from people participating in the contest">
		<cfargument name="imageid" required="false" type="String" default="0" hint="imageid if required from people participating in the contest">
		<cfargument name="vid" required="false" type="String" default="0" hint="vid if required from people participating in the contest">
		<cfquery name="addEntry" datasource="#contestdsn#">
			INSERT INTO CONTESTENTRY
			(
				CONTESTID,
				NAMEID
				<cfif arguments.entrytext NEQ "0">
				,ENTRYTEXT
				</cfif>
				<cfif arguments.imageid NEQ "0">
				,IMAGEID
				</cfif>
				<cfif arguments.vid NEQ "0">
				,VID
				</cfif>
				
			)
			VALUES
			(
				<cfqueryparam value="#arguments.contestid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_bigint">
				<cfif arguments.entrytext NEQ "0">
				,<cfqueryparam value="#arguments.entrytext#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.imageid NEQ "0">
				,<cfqueryparam value="#arguments.imageid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.vid NEQ "0">
				,<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
		</cfquery>
	</cffunction> 
	
	<cffunction name="addwinner" access="public" returntype="void" hint="I set winner of the contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId">  
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who won the contest">
		<cfquery name="addwinner" datasource="#contestdsn#">
			INSERT INTO WINNER
			(
				CONTESTID,
				NAMEID,
				SELECTEDON
			)
			VALUES
			(
				<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">,
				<cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getWinners" access="public" returntype="query" hint="I get all the winners for a contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId">  
		
		<cfquery name="getwinners" datasource="#contestdsn#">
			SELECT CONTESTID,NAMEID,SELECTEDON FROM WINNER
			WHERE CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn getwinners>
	</cffunction>
	
	<cffunction name="isWinner" access="public" returntype="boolean" hint="I check if a person is winner">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId">  
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person">
		
		<cfquery name="iswinner" datasource="#contestdsn#">
			SELECT SELECTEDON FROM WINNER
			WHERE CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
			AND NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		
		<cfif iswinner.recordcount NEQ 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
	
	<cffunction name="isContestEmpty" access="public" returntype="boolean" hint="Check if anyone has entered for contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId">
		<cfquery name="getcontestentry" datasource="#contestdsn#">
			SELECT TOP 1 CONTESTID
			FROM CONTESTENTRY
			WHERE
			CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfif getcontestentry.recordcount eq 0>
			<cfreturn TRUE>
		</cfif>
		<cfreturn FALSE>
	</cffunction>

	<cffunction name="isEnteredinContest" access="public" returntype="boolean" hint="Checks if a person in entered in contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest to be edited">  
		<cfargument name="nameid" required="true" type="numeric" hint="nameid of the person who participates in contest">
		<cfquery name="getentrytext" datasource="#contestdsn#">
			SELECT ENTRYTEXT
			FROM CONTESTENTRY
			WHERE CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
			AND NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfif getentrytext.recordcount gt 0>
		<cfreturn TRUE>
		</cfif>
		<cfreturn FALSE>
	</cffunction>
	
	<cffunction name="getEntries" access="public" returntype="query" hint="I get all the people registered to the contest. Return fields:CONTESTID,NAMEID,FIRSTNAME,LASTNAME">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest to be edited"> 
		<cfquery name="getentries" datasource="#contestdsn#">
			SELECT
			CONTESTENTRY.CONTESTID,
			CONTESTENTRY.NAMEID,
			CONTESTENTRY.ENTRYTEXT,
			NAME.FIRSTNAME,
			NAME.LASTNAME,
			NAME.WEMAIL,
			NAME.HEMAIL
			FROM CONTESTENTRY, NAME
			WHERE CONTESTENTRY.CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
			AND CONTESTENTRY.NAMEID=NAME.NAMEID
		</cfquery>
		<cfreturn getentries>
	</cffunction>

	<cffunction name="randomWinner" access="public" returntype="numeric" hint="I randomly pick up a winner">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest">
		<cfset var get=0>
		<cfset var randomwinner=0>
		<cfquery name="get" datasource="#arguments.contestdsn#">
			SELECT NAMEID FROM WINNER 
			WHERE CONTESTID=<cfqueryparam value="#arguments.contestid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset nameids=valuelist(get.nameid)>
		<cfquery name="randomwinner" datasource="#arguments.contestdsn#">
			SELECT TOP 1
			CONTESTENTRY.CONTESTID,
			CONTESTENTRY.NAMEID,
			NAME.FIRSTNAME,
			NAME.LASTNAME
			FROM CONTESTENTRY, NAME
			WHERE CONTESTENTRY.CONTESTID=<cfqueryparam value="#arguments.contestid#" cfsqltype="cf_sql_bigint">
			AND CONTESTENTRY.NAMEID=NAME.NAMEID
			<cfif get.recordcount GT 0>
				AND CONTESTENTRY.NAMEID NOT IN (#nameids#)
			</cfif>
			ORDER BY NEWID()
		</cfquery>
		<cfif randomwinner.recordcount GT 0>
			<cfreturn randomwinner.NAMEID>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteContest" access="public" returntype="void" hint="I delete contest">
		<cfargument name="contestdsn" required="true" type="String" hint="Datasource">
		<cfargument name="contestid" required="true" type="numeric" hint="ContestId of the contest">
		<cfquery name="deletecontest" datasource="#contestdsn#">
			DELETE FROM CONTEST
			WHERE CONTESTID=<cfqueryparam value="#contestid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
</cfcomponent>
