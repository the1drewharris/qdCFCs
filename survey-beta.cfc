<cfcomponent hint="I have all functions for survey">
	
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
	<cfobject component="qdDataMgr" name="tblCheck">
	
	<cffunction name="createSurveyTables" access="public" hint="Create Survey Tables">
	<cfargument name="surveydsn" required="true" type="string" hint="datasource">
	<cfquery name="createSurveyTables" datasource="#surveydsn#">
		<!--- DROP TABLE RESULTS;
		DROP TABLE ANSWERS
		DROP TABLE PEOPLESURVEYED;
		DROP TABLE ANSWERCHOICES;
		DROP TABLE QUESTIONS;
		DROP TABLE SURVEY; --->
		
		CREATE TABLE SURVEY
		(
			SURVEYID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			SURVEYNAME VARCHAR(100) NOT NULL,
			NAMEID BIGINT NOT NULL,
			NUMBEROFTIMESFOR1IP INT DEFAULT 3,
			NUMBEROFTIMESFORNAMEID INT DEFAULT 1,
			STATUS BIT DEFAULT 1,
			STARTDATE VARCHAR(16) NOT NULL,
			ENDDATE VARCHAR(16),
			ALLOWENDDATE BIT DEFAULT 0,
			ACTIVE BIT DEFAULT 1
		);
		
		CREATE TABLE QUESTIONS 
		(
			QUESTIONID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			SURVEYID BIGINT NOT NULL,
			SURVEYQUESTION NTEXT NOT NULL,
			MULTIPLEANSWERS BIT DEFAULT 0,
			TEXTREQUIRED BIT DEFAULT 0,
			SORTORDER INT  DEFAULT 0,
			DISPLAY BIT DEFAULT 1
		);
		ALTER TABLE QUESTIONS ADD FOREIGN KEY (SURVEYID) REFERENCES SURVEY(SURVEYID);
		
		CREATE TABLE ANSWERCHOICES
		(
			ANSWERCHOICEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			QUESTIONID BIGINT NOT NULL,
			ANSWER NTEXT NOT NULL,
			SORTORDER INT DEFAULT 1
		);
		ALTER TABLE ANSWERCHOICES ADD FOREIGN KEY (QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
		
		CREATE TABLE PEOPLESURVEYED
		(
			PEOPLESURVEYEDID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			SURVEYID BIGINT NOT NULL,
			IPADDRESS VARCHAR(24) NOT NULL,
			CFID VARCHAR(50) NOT NULL,
			NAMEID BIGINT
		);
		ALTER TABLE PEOPLESURVEYED ADD FOREIGN KEY(SURVEYID) REFERENCES SURVEY(SURVEYID);
		ALTER TABLE PEOPLESURVEYED ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
		
		CREATE TABLE RESULTS
		(
			ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			PEOPLESURVEYEDID BIGINT NOT NULL,
			QUESTIONID BIGINT NOT NULL,
			ANSWERCHOICEID BIGINT NOT NULL,
			DATETIME VARCHAR(16) NOT NULL
		);
		ALTER TABLE RESULTS ADD FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
		ALTER TABLE RESULTS ADD FOREIGN KEY(ANSWERCHOICEID) REFERENCES ANSWERCHOICES(ANSWERCHOICEID);
		ALTER TABLE RESULTS ADD FOREIGN KEY(PEOPLESURVEYEDID) REFERENCES PEOPLESURVEYED(PEOPLESURVEYEDID);
		
		CREATE TABLE ANSWERS
		(
			ID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			PEOPLESURVEYEDID BIGINT NOT NULL,
			QUESTIONID BIGINT NOT NULL,
			ANSWER NTEXT NOT NULL
		)
		ALTER TABLE ANSWERS ADD FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID)
		ALTER TABLE ANSWERS ADD FOREIGN KEY(PEOPLESURVEYEDID) REFERENCES PEOPLESURVEYED(PEOPLESURVEYEDID);
		
		CREATE TABLE QRELATION
		(
			QRELATIONID BIGINT NOT NULL IDENTITY(1,1),
			QUESTIONID BIGINT NOT NULL,
			ANSWERCHOICEID BIGINT NOT NULL,
			RELATED_QUESTIONID BIGINT NOT NULL
		)
		ALTER TABLE QRELATION ADD CONSTRAINT PK_QRELATIONID PRIMARY KEY(QRELATIONID);
		ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_QUESTIONS FOREIGN KEY(QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
		ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_ANSWERCHOICES FOREIGN KEY(ANSWERCHOICEID) REFERENCES ANSWERCHOICES(ANSWERCHOICEID);
		ALTER TABLE QRELATION ADD CONSTRAINT FK_QRELATION_RQUESTIONS FOREIGN KEY(RELATED_QUESTIONID) REFERENCES QUESTIONS(QUESTIONID);
	</cfquery>
</cffunction>
	
	<cffunction name="getSingleQuestion" access="public" returntype="query" hint="get a survey question. Return fields:SURVEYID,SURVEYQUESTION,MULTIPLEANSWERS">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid">
		<cfquery name="getquestion" datasource="#surveydsn#">
			SELECT
				SURVEYID,
				SURVEYQUESTION,
				MULTIPLEANSWERS,
				TEXTREQUIRED,
				DISPLAY
			FROM QUESTIONS
			WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getquestion>
	</cffunction>
	
	<cffunction name="getSurveyInfo" access="public" returntype="query" hint="I get all information of survey from survey table. Return fields: SURVEYID,SURVEYNAME,NUMBEROFTIMESFOR1IP,NUMBEROFTIMESFORNAMEID,STARTDATE,ENDDATE">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="surveyid of the survey">
		<cfquery name="getsurveyinfo" datasource="#surveydsn#">
			SELECT 
			SURVEYID,
			SURVEYNAME,
			NUMBEROFTIMESFOR1IP,
			NUMBEROFTIMESFORNAMEID,
			STARTDATE,
			ENDDATE,
			ALLOWENDDATE,
			ACTIVE
			FROM SURVEY
			WHERE SURVEYID=<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getsurveyinfo>
	</cffunction>
	
	<cffunction name="getSurveys" access="public" returntype="query" hint="I show all surveys created by name id. If nameid is not passed, I show all surveys. Return fields: SURVEYID,SURVEYNAME,NUMBEROFTIMESFOR1IP,NUMBEROFTIMESFORNAMEID,STARTDATE,ENDDATE">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="all" required="false" type="string" hint="Any value if all  the surveys should be displayed"> 
		
		<cfquery name="getsurveys" datasource="#surveydsn#">
			SELECT 
			SURVEYID, 
			SURVEYNAME,
			NUMBEROFTIMESFOR1IP,
			NUMBEROFTIMESFORNAMEID,
			STARTDATE,
			ENDDATE,
			ALLOWENDDATE,
			ACTIVE
			FROM SURVEY
			<cfif NOT isDefined('all')>
				WHERE
				(ALLOWENDDATE=1 AND ENDDATE > <cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">) 
				OR ALLOWENDDATE=0
				AND ACTIVE=1
				AND STARTDATE < <cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY SURVEYID DESC
		</cfquery>
		
		<cfreturn getsurveys>
	</cffunction>
	
	<cffunction name="editSurvey" access="public" returntype="void" hint="I update the survey">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="surveyid of the survey">
		<cfargument name="surveyname" required="true" type="string" hint="name of the survey">
		<cfargument name="startdate" required="false" type="String" hint="Start date for the survey">
		<cfargument name="enddate" required="false" type="String" hint="End date for the survey">
		<cfargument name="numberoftimesfor1ip" required="false" type="string" hint="no of times a computer is allowed to take part in survey without loggin in">
		<cfargument name="numberoftimesfornameid" required="false" type="string" hint="no of times a registered user is allowed to take part in survey">
		<cfargument name="allowenddate" required="false" type="String" hint="to set and end date or not">
		<cfargument name="active" required="false" type="String" hint="Status of the survey, whether active or not">
		<cfquery name="editsurvey" datasource="#surveydsn#">
			UPDATE SURVEY
			SET 
			SURVEYNAME=<cfqueryparam value="#surveyname#" cfsqltype="cf_sql_varchar">
			<cfif isDefined('startdate')>
			,STARTDATE=<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('enddate')>
			,ENDDATE=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('numberoftimesfor1ip')>
			,NUMBEROFTIMESFOR1IP=<cfqueryparam value="#numberoftimesfor1ip#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif isDefined('numberoftimesfornameid')>
			,NUMBEROFTIMESFORNAMEID=<cfqueryparam value="#numberoftimesfornameid#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif isDefined('allowenddate')>
			,ALLOWENDDATE=<cfqueryparam value="#allowenddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('active')>
			,ACTIVE=<cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE SURVEYID=<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteQuestion" access="public" returntype="void" hint="I delete a surveyquestion">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid">
		<cfquery name="deletequestion" datasource="#surveydsn#">
			DELETE FROM QUESTIONS
			WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAllAnswerchoices" access="public" returntype="void" hint="I delete all answer choices for a questionid">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid">
		<cfquery name="deleteanswerchoice" datasource="#surveydsn#">
			DELETE FROM ANSWERCHOICES
			WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAnswerchoice" access="public" returntype="void" hint="I delete a answer choice from the database">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="answerchoiceid" required="true" type="string" hint="Answerid">
		<cfquery name="deleteanswerchoice" datasource="#surveydsn#">
			DELETE FROM ANSWERCHOICES
			WHERE ANSWERCHOICEID=<cfqueryparam value="#answerchoiceid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="editAnswerChoice" access="public" returntype="void" hint="I  update survey question">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="answerchoiceid" required="true" type="string" hint="Answerid">
		<cfargument name="newanswer" required="true" type="String" hint="new answer choice which replaces the old answer choice">
		<cfquery name="editanswerchoice" datasource="#surveydsn#">
			UPDATE ANSWERCHOICES
			SET ANSWER=<cfqueryparam value="#newanswer#" cfsqltype="cf_sql_longvarchar">
			WHERE ANSWERCHOICEID=<cfqueryparam value="#answerchoiceid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="editQuestion" access="public" returntype="void" hint="I  update survey question">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid">
		<cfargument name="newquestion" required="true" type="String" hint="new question which replaces the old question">
		<cfargument name="multipleanswers" required="false" default="0" type="string" hint="If multiple answers are allowed or not">
		<cfargument name="display" required="false" default="1" type="string" hint="1 if you want to disable the question">
		<cfargument name="textrequired" required="false" default="0" type="string" hint="If text is required to answer the question">
		<cfif multipleanswers NEQ 0>
			<cfset multipleanswers=1>
		</cfif>
		<cfif textrequired NEQ 0>
			<cfset textrequired=1>
		</cfif>
		
		<cfquery name="editquestion" datasource="#arguments.surveydsn#">
			UPDATE QUESTIONS
			SET 
			SURVEYQUESTION=<cfqueryparam value="#arguments.newquestion#" cfsqltype="cf_sql_longvarchar">,
			MULTIPLEANSWERS=<cfqueryparam value="#arguments.multipleanswers#" cfsqltype="cf_sql_varchar">,
			TEXTREQUIRED=<cfqueryparam value="#arguments.textrequired#" cfsqltype="cf_sql_varchar">,
			DISPLAY=<cfqueryparam value="#arguments.display#" cfsqltype="cf_sql_varchar">
			WHERE QUESTIONID=<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="addSurvey" access="public" returntype="numeric" hint="I add a new survey to the database">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyname" required="true" type="String" hint="Name given to survey">
		<cfargument name="nameid" required="true" type="string" hint="Nameid of the surveyer">
		<cfargument name="startdate" required="true" type="String" hint="Start date for the survey">
		<cfargument name="enddate" required="true" type="String" hint="End date for the survey">
		<cfargument name="allowenddate" required="true" type="string" hint="1 if end date should be used, 0 otherwise">
		<cfargument name="active" required="true" type="string" hint="1 if the survey should be activated, 0 otherwise ">
		<cfargument name="numberoftimesfor1ip" required="false" type="string" hint="no of times a computer is allowed to take part in survey without loggin in">
		<cfargument name="numberoftimesfornameid" required="false" type="string" hint="no of times a registered user is allowed to take part in survey">
		<cfargument name="status" required="false" type="binary" hint="Status of the survey, whether active or not">
		
		<cfquery name="addsurvey" datasource="#surveydsn#">
			INSERT INTO SURVEY
			(
				SURVEYNAME,
				NAMEID,
				STARTDATE,
				ALLOWENDDATE,
				ACTIVE
				<cfif isDefined('enddate')>
				,ENDDATE
				</cfif>
				<cfif isDefined('numberoftimesfor1ip')>
				,NUMBEROFTIMESFOR1IP
				</cfif>
				<cfif isDefined('numberoftimesfor1ip')>
				,NUMBEROFTIMESFORNAMEID
				</cfif>
				<cfif isDefined('status')>
				,STATUS
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#surveyname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#allowenddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('enddate')>
				,<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('numberoftimesfor1ip')>
				,<cfqueryparam value="#numberoftimesfor1ip#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined('numberoftimesfornameid')>
				,<cfqueryparam value="#numberoftimesfornameid#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined('status')>
				,<cfqueryparam value="#status#" cfsqltype="cf_sql_bit">
				</cfif>
			)
			SELECT @@IDENTITY AS SURVEYID
		</cfquery>
		<cfreturn addsurvey.SURVEYID>
		
	</cffunction>
	
	<cffunction name="addQuestion" access="public" returntype="string" hint="I add a new question for a survey to the database.">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="Surveyid">
		<cfargument name="question" required="true" type="string" hint="Question for the survey">
		<cfargument name="multipleanswers" required="false" default="0" type="string" hint="If multiple answers are allowed">
		<cfargument name="textrequired" required="false" default="0" type="string" hint="If textual answer is required">
		<cfargument name="display" required="false" default="1" type="string" hint="0 if the question should not be displayed">
		<cfquery name="addsurvey" datasource="#surveydsn#">
			INSERT INTO QUESTIONS
			(
				SURVEYID,
				SURVEYQUESTION,
				DISPLAY,
				SORTORDER
				<cfif multipleanswers NEQ 0>
				,MULTIPLEANSWERS
				</cfif>
				<cfif textrequired NEQ 0>
				,TEXTREQUIRED
				</cfif>
				 
			)
			VALUES
			(
				<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#question#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#display#" cfsqltype="cf_sql_varchar">,
				1000
				<cfif multipleanswers NEQ 0>
				,1
				</cfif>
				<cfif textrequired NEQ 0>
				,1
				</cfif>  	
			)
			SELECT @@IDENTITY AS QUESTIONID
			</cfquery>
			
			<!--- <cfloop index="i" from="1" to="#arrayLen(answers)#">
				<cfquery name="addanswerchoices" datasource="#surveydsn#">
					INSERT INTO ANSWERCHOICES
					(
						QUESTIONID,
						ANSWER
					)
					VALUES
					(
						<cfqueryparam value="#addsurvey.QUESTIONID#" cfsqltype="cf_sql_bigint">,
						<cfqueryparam value="#answers[i]#">
					)
				</cfquery>
			</cfloop> --->
			<cfreturn addsurvey.QUESTIONID>
	</cffunction>
	
	<cffunction name="addAnswerChoice" access="public" returntype="void" hint="add an answer choice to one of the survey questions">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid of the question for which a choice is added">
		<cfargument name="answerchoice" required="true" type="string" hint="answer choice">
		<cfquery name="addanswerchoice" datasource="#surveydsn#">
			INSERT INTO ANSWERCHOICES
				(
					QUESTIONID,
					ANSWER
				)
				VALUES
				(
					<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#answerchoice#">
				)
		</cfquery>
	</cffunction> 
	
	<cffunction name="checknumberoftimes" access="public" returntype="string" hint="It checks if a person have been surveyed before for the survey and adds the person to survey if the person has not been surveyed maximum allowed number of times">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="ipaddress" required="true" type="string" hint="ipaddress of the machine taking part in survey">
		<cfargument name="surveyid" required="true" type="string" hint="Surveyid">
		<cfargument name="nameid" required="false" type="string" hint="nameid of the person taking part in survey">
		
		<cfset numberOfTimes = 0>
			
		<cfif isDefined('nameid')>	
			<cfquery name="getcount" datasource="#surveydsn#">
				SELECT PEOPLESURVEYEDID
				FROM PEOPLESURVEYED
				WHERE SURVEYID=<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">
				AND NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfset numberOfTimes = getCount.recordCount>
		<cfelse>
			<cfquery name="getcountfor1IP" datasource="#surveydsn#">
				SELECT PEOPLESURVEYEDID
				FROM PEOPLESURVEYED
				WHERE SURVEYID=<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">
				AND IPADDRESS=<cfqueryparam value="#ipaddress#" cfsqltype="cf_sql_varchar">
				AND NAMEID IS NULL
			</cfquery>
			<cfset numberOfTimes = getCountFor1IP.recordCount>
		</cfif>
		<cfreturn numberOfTimes>
	</cffunction>
	
	<cffunction name="answerSurveyQuestion" access="public" returntype="void" hint="Answer a survey questions">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid of the survey">
		<cfargument name="answerchoiceid" required="true" type="string" hint="Answer id for the survey question">
		<cfargument name="peoplesurveyedid" required="true" type="String" hint="People surveyed">
		<!--- <cfargument name="multipleanswers" required="false" default="0" type="String" hint="Whether a user can select multiple answers for a single question"> --->
		
		<cfquery name="answersurvey" datasource="#surveydsn#">
			INSERT INTO RESULTS
			(
				PEOPLESURVEYEDID,
				QUESTIONID,
				ANSWERCHOICEID,
				DATETIME
			)
			VALUES
			(
				<cfqueryparam value="#peoplesurveyedid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#answerchoiceid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addPeopleSurveyed" access="public" returntype="numeric" hint="I add people surveyed for a particular survey">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="Surveyid">
		<cfargument name="ipaddress" required="true" type="string" hint="IP address of the machine taking part in survey">
		<cfargument name="cfid" required="true" type="String" hint="session id">
		<cfargument name="nameid" required="false" type="string" hint="Nameid of the person taking part in survey">
		
		<cfquery name="addPeopleSurveyed" datasource="#surveydsn#">
			INSERT INTO PEOPLESURVEYED
			(
				SURVEYID,
				IPADDRESS,
				CFID
				<cfif isDefined('nameid')>
				,NAMEID
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#ipaddress#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#cfid#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('nameid')>
				,<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS ID
		</cfquery>
		<cfreturn addPeopleSurveyed.ID>
	</cffunction> 
	
	<cffunction name="getSurveyid" access="public" returntype="numeric" hint="Get surveyid from nameid">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="Questionid">
		<cfquery name="getsurveyid" datasource="#surveydsn#">
			SELECT TOP 1 surveyid
			FROM QUESTIONS
			WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getsurveyid.recordcount eq 0>
			<cfreturn 0>
		<cfelse>
			<cfreturn getsurveyid.surveyid>
		</cfif>
	</cffunction> 

	<cffunction name="getSurveyQuestions" access="public" returntype="query" hint="Get survey questions using surveyid. Return fields: QUESTIONID, SURVEYQUESTION">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="Surveyid">
		<cfargument name="sort" required="false" default="0" type="string" hint="1 to sort the result by sortorder">
		<cfargument name="displayinactive" required="false" type="string" default="1" hint="pass 0 for not displaying inactive questions">
		<cfargument name="onlywithanswerchoices" required="false" type="string" default="0" hint=" pass 1 to get question only with answerchoices">
		<cfargument name="excludelist" required="false" type="string" default="0" hint="pass the list of id of questions to exclude">
		<cfset var createSORTORDER=0>
		<cfset var createDISPLAY=0>
		<cfset var update=0>
		<cfset var getsurveyquestions=0>
		<cfif not tblCheck.columnExists('#arguments.surveydsn#', 'QUESTIONS', 'SORTORDER')>
			<cfquery name="createSORTORDER" datasource="#arguments.surveydsn#">
				ALTER TABLE QUESTIONS ADD SORTORDER INT DEFAULT 0;
			</cfquery>
			<cfquery name="update" datasource="#arguments.surveydsn#">
				UPDATE QUESTIONS SET SORTORDER=0;
			</cfquery>
		</cfif>
		
		<cfif not tblCheck.columnExists('#arguments.surveydsn#', 'QUESTIONS', 'DISPLAY')>
			<cfquery name="createDISPLAY" datasource="#arguments.surveydsn#">
				ALTER TABLE QUESTIONS ADD DISPLAY BIT DEFAULT 1;
			</cfquery>
			<cfquery name="update" datasource="#arguments.surveydsn#">
				UPDATE QUESTIONS SET DISPLAY=1;
			</cfquery>
		</cfif>
	
		<cfquery name="getsurveyquestions" datasource="#surveydsn#">
			SELECT QUESTIONID, SURVEYQUESTION, MULTIPLEANSWERS, TEXTREQUIRED, DISPLAY, SORTORDER
			FROM QUESTIONS
			WHERE SURVEYID=<cfqueryparam value="#surveyid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.displayinactive EQ 0>
			AND DISPLAY=1
			</cfif>
			<cfif arguments.onlywithanswerchoices EQ 1>
			AND QUESTIONID IN (SELECT QUESTIONID FROM ANSWERCHOICES WHERE SURVEYID=<cfqueryparam value="#arguments.surveyid#" cfsqltype="cf_sql_varchar">)
			</cfif>
			<cfif arguments.excludelist NEQ "0">
			AND QUESTIONID NOT IN ('#arguments.excludelist#')
			AND QUESTIONID NOT IN (SELECT RELATED_QUESTIONID FROM QRELATION WHERE QUESTIONID IN ('#arguments.excludelist#'))
			</cfif>
			<cfif arguments.sort EQ 1>
			ORDER BY SORTORDER
			</cfif>
		</cfquery>
		<cfreturn getsurveyquestions>
	</cffunction>

	<cffunction name="getAnswerChoices" access="public" returntype="query" hint="Get answer choices for a particular survey question. Return fields:ANSWERCHOICEID, ANSWER">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid">
		<cfquery name="getanswerchoices" datasource="#arguments.surveydsn#">
			SELECT ANSWERCHOICEID, ANSWER
			FROM ANSWERCHOICES
			WHERE QUESTIONID=<cfqueryparam  value="#questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getanswerchoices>
	</cffunction>
	
	<cffunction name="getQuestionid" access="public" returntype="numeric" hint="Get Questionid from answerchoiceid">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="answerchoiceid" required="true" type="string" hint="answerchoiceid">
		<cfquery name="getquestionid" datasource="#surveydsn#">
			SELECT DISTINCT QUESTIONID
			FROM ANSWERCHOICES
			WHERE ANSWERCHOICEID=<cfqueryparam  value="#answerchoiceid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfoutput>#getquestionid.QUESTIONID#</cfoutput>
		<cfreturn getquestionid.QUESTIONID>
	</cffunction>

	<cffunction name="getAnswer" access="public" returntype="String" output="false" hint="get answer string from answer id">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="answerid" required="true" type="string" hint="answer id from answer table">
		<cfquery name="getanswer" datasource="#surveydsn#">
			SELECT ANSWER
			FROM ANSWERCHOICES
			WHERE ANSWERCHOICEID=<cfqueryparam value="#answerid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getanswer.ANSWER >
	</cffunction>
	
	<cffunction name="isSessionUsed" access="public" returntype="boolean" hint="Check if the session has already participated in the survey">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="cfid" required="true" type="string" hint="Sessionid">
		<cfquery name="checksession" datasource="#surveydsn#">
			SELECT CFID 
			FROM PEOPLESURVEYED
			WHERE CFID=<cfqueryparam value="#cfid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif checksession.recordcount eq 0>
			<cfreturn FALSE>
		<cfelse>
			<cfreturn TRUE>
		</cfif>
	</cffunction>
	
	<cffunction name="getResultofoneperson" access="public" returntype="Query" hint="I get answers of a question for a person">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid of the survey">
		<cfargument name="nameid" required="true" type="string" hint="questionid of the survey">
		<cfset var result=0>
		<cfquery name="result" datasource="#surveydsn#">
			SELECT RESULTS.ANSWERCHOICEID, ANSWERCHOICES.ANSWER
			FROM RESULTS, ANSWERCHOICES
			WHERE RESULTS.QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
			AND RESULTS.ANSWERCHOICEID=ANSWERCHOICES.ANSWERCHOICEID
			AND RESULTS.PEOPLESURVEYEDID IN 
			(SELECT TOP 1 PEOPLESURVEYEDID 
			FROM PEOPLESURVEYED 
			WHERE NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			ORDER BY PEOPLESURVEYEDID DESC)
		</cfquery>
		<cfreturn result>
	</cffunction> 
	
	<cffunction name="gettextanswer" access="public" returntype="String" hint="I get text answer for a question">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid of the survey">
		<cfargument name="nameid" required="true" type="string" hint="nameid of the person">
		<cfset var myanswer=0>
		<cfquery name="myanswer" datasource="#surveydsn#">
			SELECT ANSWER FROM ANSWERS
			WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
			AND PEOPLESURVEYEDID IN (SELECT TOP 1 PEOPLESURVEYEDID FROM PEOPLESURVEYED WHERE NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar"> ORDER BY PEOPLESURVEYEDID DESC)
		</cfquery>
		<cfif myanswer.recordcount GT 0>
		<cfreturn myanswer.answer>
		<cfelse> <cfreturn "no data">
		</cfif>
	</cffunction> 
	
	<cffunction name="getResult" access="public" returntype="Struct" hint="I get the result of a survey question. The structure contains totalparticipant,answerchoices and 2 dimenssional array results. The arrary contains the anwerchoiceid and number of votes the answer got.">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid of the survey">
		<cfset result=StructNew()>
		<cfinvoke component="survey" method="getAnswerChoices" returnvariable="answerchoices" surveydsn="#arguments.surveydsn#" questionid="#arguments.questionid#">
		<cfquery name="getresult" datasource="#surveydsn#">
			SELECT ANSWERCHOICEID
			FROM RESULTS
			WHERE QUESTIONID=<cfqueryparam value="#questionid#">
		</cfquery>
		
		<cfset result.totalparticipant=getresult.recordcount>
		<cfset result.answerchoices=answerchoices.recordcount>
		<cfset result.results=ArrayNew(2)>
		<cfset i=1>
		<cfloop query="answerchoices">
			<cfquery name="individualresults" datasource="#surveydsn#">
				SELECT ANSWERCHOICEID
				FROM RESULTS
				WHERE  QUESTIONID=<cfqueryparam value="#questionid#">
				AND ANSWERCHOICEID=<cfqueryparam value="#answerchoices.answerchoiceid#">
			</cfquery>
			<cfset result.results[i][1]=answerchoices.answerchoiceid>
			<cfset result.results[i][2]=individualresults.recordcount>
			<cfset i= i+1>
		</cfloop>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="isSurveyEmpty" access="public" returntype="numeric" hint="I check if people has be surveyed at all">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="surveyid" required="true" type="string" hint="surveyid of the survey">
		
		<cfinvoke method="getSurveyQuestions" returnvariable="surveyquestions" surveydsn="#surveydsn#" surveyid="#surveyid#">
		
		<cfif surveyquestions.recordcount gt 0>
			<cfloop query="surveyquestions">
				<cfquery name="getresult" datasource="#surveydsn#">
					SELECT ANSWERCHOICEID FROM RESULTS
					WHERE QUESTIONID=<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getresult.recordcount gt 0>
					<cfreturn 0>
				</cfif>
			</cfloop>
		<cfelse>
			<cfreturn 1>
		</cfif>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="answerintext" access="public" returntype="void" hint="I add answer to question which require text answer">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid of the question">
		<cfargument name="peoplesurveyedid" required="true" type="string" hint="peoplesurveyedid">
		<cfargument name="answer" required="true" type="string" hint="answer">
		<cfset var ans=0>
		<cfquery name="ans" datasource="#surveydsn#">
			INSERT INTO ANSWERS
			(
				PEOPLESURVEYEDID,
				QUESTIONID,
				ANSWER
			)
			VALUES
			(
				<cfqueryparam value="#peoplesurveyedid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#questionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#answer#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="sortquestions" access="public" returntype="void" hint="I sort questions">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="sortlist" required="true" type="String" hint="sorted order of questionid in which they should appear in the database">
		<cfset var sort=0>
		<cfset myorder=0>
		<cfloop list="#sortlist#" index="qid">
			<cfquery name="sort" datasource="#arguments.surveydsn#">
				UPDATE QUESTIONS
				SET SORTORDER=<cfqueryparam value="#myorder#" cfsqltype="cf_sql_varchar">
				WHERE QUESTIONID=<cfqueryparam value="#qid#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset myorder=myorder + 10>
		</cfloop>
	</cffunction>
	
	<cffunction name="enablequestion" access="public" returntype="void" hint="I make question show up in a survey">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid">
		<cfset var enable=0>
		<cfquery name="enable" datasource="#arguments.surveydsn#">
			UPDATE QUESTIONS
			SET ENABLE=1
			WHERE QUESTIONID=<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="disablequestion" access="public" returntype="void" hint="I make question show up in a survey">
		<cfargument name="surveydsn" required="true" type="string" hint="Datasource">
		<cfargument name="questionid" required="true" type="string" hint="questionid">
		<cfset var enable=0>
		<cfquery name="enable" datasource="#arguments.surveydsn#">
			UPDATE QUESTIONS
			SET ENABLE=0
			WHERE QUESTIONID=<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="addrelatedquestion" access="public" returntype="string" hint="I add related question">
		<cfargument name="surveydsn" required="true" type="string" hint="I am the datasource of the survey">
		<cfargument name="questionid" required="true" type="string" hint="primary questions">
		<cfargument name="answerchoiceid" required="true" type="string" hint="answer of primary question">
		<cfargument name="related_questionid" required="true" type="string" hint="I am the related question that must be answered if above answer is selected for above questions">
		<cfset var add=0>
		<cfset var get=0>
		<cfif arguments.questionid NEQ arguments.related_questionid>
			<cfquery name="get" datasource="#arguments.surveydsn#">
				SELECT COUNT(QUESTIONID) AS QUESTIONCOUNT FROM QRELATION
				WHERE QUESTIONID=<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">
				AND (
					ANSWERCHOICEID=<cfqueryparam value="#arguments.answerchoiceid#" cfsqltype="cf_sql_varchar">
					OR RELATED_QUESTIONID=<cfqueryparam value="#arguments.related_questionid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			
			<cfif get.QUESTIONCOUNT EQ 0>
				<cfquery name="add" datasource="#arguments.surveydsn#">
					INSERT INTO QRELATION
					(
						QUESTIONID,
						ANSWERCHOICEID,
						RELATED_QUESTIONID
					)
					VALUES
					(
						<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.answerchoiceid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.related_questionid#" cfsqltype="cf_sql_varchar">
					)
					SELECT @@IDENTITY AS QRELATIONID
				</cfquery>
				<cfreturn add.QRELATIONID>
			</cfif>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="getrelatedquestions" access="public" returntype="query" hint="I get related questions">
		<cfargument name="surveydsn" required="true" type="string" hint="I am the data source for the survey">
		<cfargument name="surveyid" required="true" type="string" hint="I am the id of the survey">
		<cfargument name="questionid" required="false" type="string" default="0" hint="I am the primary questionid">
		<cfargument name="answerchoiceid" required="false" type="string" default="0" hint="I am the answer to the primary question">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.surveydsn#">
			SELECT
				QRELATION.QRELATIONID, 
				QRELATION.QUESTIONID,
				QRELATION.ANSWERCHOICEID,
				QRELATION.RELATED_QUESTIONID,
				QUESTIONS.SURVEYQUESTION,
				(SELECT SURVEYQUESTION FROM QUESTIONS WHERE QUESTIONID=QRELATION.RELATED_QUESTIONID) AS RELATED_QUESTION,
				ANSWERCHOICES.ANSWER
			FROM QRELATION, QUESTIONS, ANSWERCHOICES
			WHERE QRELATION.QUESTIONID IN (SELECT QUESTIONID FROM QUESTIONS WHERE SURVEYID=<cfqueryparam value="#arguments.surveyid#" cfsqltype="cf_sql_varchar">) 
			AND QUESTIONS.QUESTIONID=QRELATION.QUESTIONID
			AND ANSWERCHOICES.ANSWERCHOICEID=QRELATION.ANSWERCHOICEID
			<cfif arguments.questionid NEQ "0">
			AND QRELATION.QUESTIONID=<cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.answerchoiceid NEQ "0">
			AND QRELATION.ANSWERCHOICEID IN ('#arguments.answerchoiceid#')
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction> 
	
	<cffunction name="deleterelation" access="public" returntype="string" hint="I delete related question relationship">
		<cfargument name="surveydsn" required="true" type="string" hint="I am the data source">
		<cfargument name="qrelationidList" required="true" type="string" hint="I am the list of qrelationid to delete">
		<cfset var delete=0>
		<cfquery name="delete" datasource="#arguments.surveydsn#">
			DELETE FROM QRELATION WHERE QRELATIONID IN ('#qrelationidList#')
		</cfquery>
		<cfreturn 1>
	</cffunction>

	<cffunction name="sortSurveyQuestions" access="public" returntype="void" hint="I sort survey questions">
		<cfargument name="surveydsn" required="true" type="string" hint="database name">
		<cfargument name="questionlist" required="true" type="string" hint="list of questions">
		<cfargument name="sortorderlist" required="true" type="string" hint="order in which corresponding question should appear">
		<cfset var update=0>
		<cfset var qlen=listlen(arguments.questionlist)>
		<cfset var solen=listlen(arguments.sortorderlist)>
		<cfif (qlen EQ solen) AND (qlen GT 0)>
			<cfquery name="update" datasource="#arguments.surveydsn#">
				UPDATE QUESTIONS
					SET SORTORDER = CASE QUESTIONID
						<cfloop from="1" to="#qlen#" index="i">
							WHEN <cfqueryparam value="#listGetAt(arguments.questionlist,i)#"> THEN <cfqueryparam value="#listGetAt(arguments.sortorderlist,i)#">
						</cfloop>
					END
				WHERE QUESTIONID IN (#arguments.questionlist#)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="doesSurveyHasRelatedQuestion" access="public" returntype="boolean" hint="Return TRUE or FALSE">
		<cfargument name="surveydsn" required="true" type="string" hint="false">
		<cfargument name="surveyid" required="true" type="string" hint="">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.surveydsn#">
			SELECT COUNT(*) AS NOOFRELATEDQUESTION FROM QRELATION
			WHERE QUESTIONID IN (SELECT QUESTIONID FROM QUESTIONS WHERE SURVEYID=<cfqueryparam value="#arguments.surveyid#">) 
		</cfquery>
		<cfif get.NOOFRELATEDQUESTION GT 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
</cfcomponent>