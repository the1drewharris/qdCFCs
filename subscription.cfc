<cfcomponent hint="Subscription">
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">	
	<cfobject component="timeDateConversion" name="mytime">
	
	<cffunction name="droptable" access="private">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfquery name="droptable" datasource="#subscription#">
			DROP TABLE REMINDERLOG
			DROP TABLE SUBSCRIPTION_RECORD
			DROP TABLE VIEWLOG;
			DROP TABLE TIMEREMAINING;
			DROP TABLE SUBSCRIPTIONACTIVATION;
			DROP TABLE SUBSCRIPTIONREMINDER;
			DROP TABLE SUBSCRIPTIONTOIP;
			DROP TABLE SUBSCRIPTION;
			DROP TABLE SUBSCRIBED;
			DROP TABLE SUBSCRIPTIONPLANS;
			DROP TABLE TERMMEASURE;
		</cfquery>
	</cffunction>
	
	<cffunction name="createtables" access="private">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfquery name="createtables" datasource="#subscriptiondsn#"> 
			CREATE TABLE TERMMEASURE
			(
				TERMMEASURE VARCHAR(32) NOT NULL PRIMARY KEY
			)
			INSERT INTO TERMMEASURE VALUES('Minutes');
			INSERT INTO TERMMEASURE VALUES('Hours');
			INSERT INTO TERMMEASURE VALUES('Days');
			INSERT INTO TERMMEASURE VALUES('Months');
			INSERT INTO TERMMEASURE VALUES('Years');
			CREATE TABLE SUBSCRIPTIONPLANS
			(
				ID BIGINT NOT NULL PRIMARY KEY,
				SUBSCRIABLEID BIGINT NOT NULL,
				TERM INTEGER NOT NULL,
				TERMMEASURE VARCHAR(32) NOT NULL,
				USABLEMINUTES INTEGER NOT NULL DEFAULT 0,
				ONSALE BIT NOT NULL DEFAULT 1
			)
			ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(SUBSCRIABLEID) REFERENCES IDPOOL(ID);
			ALTER TABLE SUBSCRIPTIONPLANS ADD FOREIGN KEY(TERMMEASURE) REFERENCES TERMMEASURE(TERMMEASURE);
			
			CREATE TABLE SUBSCRIBED
			(
				SUBSCRIPTIONID BIGINT IDENTITY(1,1) NOT NULL UNIQUE,
				ID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				ACTIVE BIT NOT NULL DEFAULT 1,
				CANCELLED BIT NOT NULL DEFAULT 0
			)
			ALTER TABLE SUBSCRIBED ADD PRIMARY KEY(ID, NAMEID);
			ALTER TABLE SUBSCRIBED ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
			ALTER TABLE SUBSCRIBED ADD FOREIGN KEY(ID) REFERENCES SUBSCRIPTIONPLANS(ID);
			
			CREATE TABLE SUBSCRIPTIONTOIP
			(
				SUBSCRIPTIONID BIGINT NOT NULL,
				IPADDRESS VARCHAR(16) NOT NULL
			)
			
			ALTER TABLE SUBSCRIPTIONTOIP ADD PRIMARY KEY(SUBSCRIPTIONID, IPADDRESS);
			ALTER TABLE SUBSCRIPTIONTOIP ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID)
			
			CREATE TABLE SUBSCRIPTION
			(
				SUBSCRIPTIONID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				RENEWALDATE VARCHAR(16) NOT NULL,
				DATERENEWED VARCHAR(16) NOT NULL
			)
			ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_SUBSCRIPTION_SUBSCRIBED FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_SUBSCRIPTION_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE SUBSCRIPTIONREMINDER
			(
				REMINDERID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				SUBSCRIPTIONID BIGINT NOT NULL,
				REMINDERMEASURE VARCHAR(32) NOT NULL DEFAULT 'EMAIL',
				REMINDON VARCHAR(16) NOT NULL
			)
			ALTER TABLE SUBSCRIPTIONREMINDER ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			
			CREATE TABLE SUBSCRIPTIONACTIVATION
			(
				ACTIVATIONID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				SUBSCRIPTIONID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				ACTIVATED BIGINT NOT NULL DEFAULT 1,
				TIMEDATE VARCHAR(16) NOT NULL
			)
			ALTER TABLE SUBSCRIPTIONACTIVATION ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			ALTER TABLE SUBSCRIPTIONACTIVATION ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE VIEWLOG
			(
				VIEWLOGID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				SUBSCRIPTIONID BIGINT NOT NULL,
				VIEWEDON VARCHAR(16) NOT NULL,
				VIEWTIME INTEGER NOT NULL
			)
			ALTER TABLE VIEWLOG ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			
			CREATE TABLE TIMEREMAINING
			(
				TIMEREMAININGID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				SUBSCRIPTIONID BIGINT NOT NULL,
				TIMEREMAINING INT NOT NULL
			)
			ALTER TABLE TIMEREMAINING ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID); 
			
			CREATE TABLE SUBSCRIPTION_RECORD
			(
				SUBSCRIPTIONID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				CANCELLED BIT DEFAULT 0,
				RECORDEDON VARCHAR(16)
			)
			ALTER TABLE SUBSCRIPTION_RECORD ADD FOREIGN KEY(SUBSCRIPTIONID) REFERENCES SUBSCRIBED(SUBSCRIPTIONID);
			ALTER TABLE SUBSCRIPTION_RECORD ADD FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE REMINDERLOG
			(
				REMINDERID BIGINT NOT NULL,
				MESSAGE NTEXT NOT NULL,
				SENTON VARCHAR(16) NOT NULL
				
			)
			ALTER TABLE REMINDERLOG ADD FOREIGN KEY(REMINDERID) REFERENCES SUBSCRIPTIONREMINDER(REMINDERID);
			
			CREATE TABLE DEFAULTPLAN
			(
				ID BIGINT IDENTITY(1,1) NOT NULL,
				TERM INT NOT NULL,
				TERMMEASURE VARCHAR(32) NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL
			)
			ALTER TABLE DEFAULTPLAN ADD CONSTRAINT PK_DEFAULTPLAN PRIMARY KEY(ID);
			ALTER TABLE DEFAULTPLAN ADD CONSTRAINT FK_DEFAULTPLAN_TERMMEASURE FOREIGN KEY(TERMMEASURE)  REFERENCES TERMMEASURE(TERMMEASURE);
			INSERT INTO DEFAULTPLAN(TERM, TERMMEASURE, TIMEDATE) VALUES(7, 'Days', '2009012309530000') <!--- CHANGE DATE WHILE EXECUTING --->

			</cfquery>
	</cffunction>
	
	<cffunction name="makeVideoUnsubscriable" access="public" output="false" returntype="void" hint="I make a product unsubscriable">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="vid" required="true" type="String" hint="id of the video">
		<cfset var delete=0>
		<cftry>
			<cftransaction>
				<cfquery name="delete" datasource="#arguments.subscriptiondsn#">
					DELETE FROM PRICE 
					WHERE ID IN 
					(
						SELECT ID FROM SUBSCRIPTIONPLANS 
						WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#">
					) 
				</cfquery>
				<cfquery name="delete" datasource="#arguments.subscriptiondsn#">
					DELETE FROM SUBSCRIPTIONPLANS 
					WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#">
				</cfquery>
				<cfquery name="delete" datasource="#arguments.subscriptiondsn#">
					DELETE FROM IDPOOL 
					WHERE ID IN 
					(
						SELECT ID FROM SUBSCRIPTIONPLANS 
						WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#">
					)
				</cfquery>
				<cfquery name="delete" datasource="#arguments.subscriptiondsn#">
					DELETE FROM SAMPLEMEDIA 
					WHERE VID=<cfqueryparam value="#arguments.vid#">
				</cfquery>
			</cftransaction>
			<cfcatch type="any">
				<cfquery name="delete" datasource="#arguments.subscriptiondsn#">
					UPDATE PRICE SET PRICE=<cfqueryparam  value="0">
					WHERE ID IN
					(
						SELECT ID 
						FROM SUBSCRIPTIONPLANS
						WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#">
					)
				</cfquery>
			</cfcatch>
		</cftry>
		<cfreturn>
	</cffunction>
	
	<cffunction name="addtermmeasure" access="public" returntype="void" hint="I add term measure">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="termmeasure" required="true" type="String" hint="term measure like days, weeks, months or year">
		<cfquery name="add" datasource="#subscriptiondsn#">
			INSERT INTO TERMMEASURE
			(
				TERMMEASURE
			)
			VALUES
			(
				<cfqueryparam value="#termmeasure#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addsubscriptionplans" access="public" returntype="void" hint="I add subscription plans">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriableid" required="true" type="String" hint="id of a subscriable product">
		<cfargument name="id" required="true" type="String" hint="id of the this plan">
		<cfargument name="term" required="true" type="String" hint="Term of subscription">
		<cfargument name="termmeasure" required="true" type="String" hint="term measure like month or year or week or days">
		<cfargument name="usableminutes" required="false" default="0" type="String" hint="Total number of usable minutes">
		
		<cfquery name="addsubscriptionplans" Datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIPTIONPLANS
			(
				ID,
				SUBSCRIABLEID,
				TERM,
				TERMMEASURE,
				USABLEMINUTES
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#subscriableid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#term#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#termmeasure#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#usableminutes#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="addsubscribed" access="public" returntype="string" hint="I add new subscription information">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the subscriber">
		<cfargument name="id" required="true" type="string" hint="id of the subscription plan">
		<cfset var subscribed=0>
		<cfquery name="subscribed" datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIBED
			(
				ID,
				NAMEID
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS SUBSCRIPTIONID
		</cfquery>
		<cfreturn subscribed.SUBSCRIPTIONID>
	</cffunction>
	
	<cffunction name="addsubscription" access="public" hint="Add subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="subscriptionid">
		<cfargument name="nameid" required="true" default=5 type="numeric" hint="Name id">
		<cfargument name="renewaldate" required="true" type="String" hint="new renewal date">
		<cfargument name="price" required="false" type="string" hint="Price">
		<cfargument name="quantity" required="false" type="string" hint="quantity">
		<cfset var addsubscription=0>
		<cfquery name="addsubscription" datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIPTION
			(
				SUBSCRIPTIONID,
				NAMEID,
				RENEWALDATE,
				DATERENEWED
				<cfif isDefined('arguments.price')>
				,PRICE
				</cfif>
				<cfif isDefined('arguments.quantity')>
				,QUANTITY
				</cfif>
			
			)
			VALUES
			(
				<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#renewaldate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('arguments.price')>
				,<cfqueryparam value="#arguments.price#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined('arguments.quantity')>
				,<cfqueryparam value="#arguments.quantity#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addsubscriptionReminder" returntype="string" access="public" output="false" hint="I am not written yet, but I will send a subscription reminder">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="remindon" required="true" type="String" hint="Remind before">
		<cfargument name="remindermeasure" required="false" default="Email" type="String" hint="reminder measure ">
		<cfquery name="addsubscriptionreminder" datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIPTIONREMINDER
			(
				SUBSCRIPTIONID,
				REMINDERMEASURE,
				REMINDON
			)
			VALUES
			(
				<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#remindermeasure#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#remindon#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS REMINDERID;
		</cfquery>
		<cfreturn addsubscriptionreminder.REMINDERID>
	</cffunction>
	
	<cffunction name="deactivatesubscription" access="public" hint="Deactive subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="nameid" required="true" type="String" hint="Nameid of the person who cancelled subscription">
		<cfset var deactivatesubscription=0>
		<cfset var makeinactive=0>
		<cfquery name="deactivatesubscription" datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIPTIONACTIVATION
			(
				SUBSCRIPTIONID,
				NAMEID,
				ACTIVATED,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				0,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfquery name="makeinactive" datasource="#subscriptiondsn#">
			UPDATE SUBSCRIBED
			SET ACTIVE=0
			WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="cancelsubscription" access="public" hint="Cancel Subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="nameid" required="true" type="String" hint="Nameid of the person who cancelled subscription">
		<cfset var cancelsubscription=0>
		<cfset var cancel=0>
		<cftransaction>
			<cfquery name="cancelsubscription" datasource="#subscriptiondsn#">
				INSERT INTO SUBSCRIPTION_RECORD
				(
					SUBSCRIPTIONID,
					NAMEID,
					CANCELLED,
					RECORDEDON
				)
				VALUES
				(
					<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
					1,
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
					
				)
			</cfquery>
			
			<cfquery name="cancel" datasource="#subscriptiondsn#">
				UPDATE SUBSCRIBED
				SET CANCELLED=1 
				WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="revoke_cancellation" access="public" hint="Cancel Subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="nameid" required="true" type="String" hint="Nameid of the person who cancelled subscription">
		<cfset var revoke=0>
		<cfset var revokecancellation=0>
		<cftransaction>		
			<cfquery name="revoke" datasource="#subscriptiondsn#">
				INSERT INTO SUBSCRIPTION_RECORD
				(
					SUBSCRIPTIONID,
					NAMEID,
					CANCELLED,
					RECORDEDON
				)
				VALUES
				(
					<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
					0,
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">	
				)
			</cfquery>
			
			<cfquery name="revokecancellation" datasource="#subscriptiondsn#">
				UPDATE SUBSCRIBED
				SET CANCELLED=0
				WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="activateSubscription" access="public" returntype="String" hint="Renew a subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="nameid" required="false" default="0" type="String" hint="Nameid of the person who activated the subscription">
		<cfset var activatesubscription=0>
		<cfset var activationrecord=0>
			<cfquery name="activatesubscription" datasource="#subscriptiondsn#">
				UPDATE SUBSCRIBED
				SET ACTIVE=1
				WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfquery name="activationrecord" datasource="#subscriptiondsn#">
				INSERT INTO SUBSCRIPTIONACTIVATION
				(
					SUBSCRIPTIONID,
					NAMEID,
					TIMEDATE
				)
				VALUES
				(
					<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
	</cffunction>
	
	<cffunction name="checkduedate" access="public"  returntype="void" hint="I make the subsription inactive if the due date has expired">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the person checking subscription">
		<cfset var check=0>
		<cfquery name="check" datasource="#subscriptiondsn#">
			SELECT TOP 1 RENEWALDATE 
			FROM SUBSCRIPTION 
			WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			AND RENEWALDATE<<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			ORDER BY RENEWALDATE DESC
		</cfquery>
		<cfif check.recordcount GT 0>
			<cfset args=StructNew()>
			<cfset args.subscriptiondsn=subscriptiondsn>
			<cfset args.subscriptionid=subscriptionid>
			<cfset args.nameid=nameid>
			<cfinvoke method="deactivatesubscription" argumentcollection="#args#">
		</cfif>
	</cffunction>
	
	<cffunction name="addiptosubscription" access="public" returntype="void" hint="I add ip address for a subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="ipaddress" required="true" type="String" hint="IP Address">
		<cfargument name="subscriptionid" required="true" type="String" hint="Database name">
		<cfset var add=0>
		<cfquery name="add" datasource="#subscriptiondsn#">
			INSERT INTO SUBSCRIPTIONTOIP
			(
				SUBSCRIPTIONid,
				IP,
			)
			VALUES
			(
				<cfqueryparam value="#subscriptinoid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#ip#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
		
	<cffunction name="adddefaultplan" access="public" returntype="void" hint="I add default plan">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="term" required="true" type="String" hint="term, a number">
		<cfargument name="termmeasure" required="true" type="String" hint="termmeasure like days, months, weeks or years">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.subscriptiondsn#">
			INSERT INTO DEFAULTPLAN
			(
				TERM, 
				TERMMEASURE, 
				TIMEDATE
			) 
			VALUES
			(
				<cfqueryparam value="#arguments.term#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.termmeasure#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getSubscriptionPlanID" access="public" output="false" returntype="string" hint="I get subscription plan id">
		<cfargument name="subscriptiondsn" type="string" required="true" hint="Database name">
		<cfargument name="subscriptionid" type="string" required="true" hint="subscription id">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.subscriptiondsn#">
			SELECT ID FROM SUBSCRIBED
			WHERE SUBSCRIPTIONID=<cfqueryparam value="#arguments.subscriptionid#">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.ID>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getSubscriber" access="public" output="false" returntype="string" hint="Get the Name id of the subsriber">
		<cfargument name="subscriptiondsn" type="string" required="true" hint="Database name">
		<cfargument name="subscriptionid" type="string" required="true" hint="subscription id">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.subscriptiondsn#">
			SELECT NAMEID FROM SUBSCRIBED
			WHERE SUBSCRIPTIONID=<cfqueryparam value="#arguments.subscriptionid#">
		</cfquery>
		<cfreturn get.NAMEID>
	</cffunction>
	
	<cffunction name="getTermMeasure" access="public" returntype="query" hint="Get all term measures">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfset var gettermmeasure=0>
		<cfquery name="gettermmeasure" datasource="#subscriptiondsn#">
			SELECT TERMMEASURE FROM TERMMEASURE
		</cfquery>
		<cfreturn gettermmeasure>
	</cffunction>
	
	<cffunction name="getPlans" access="public" returntype="Query" hint="I get subscription plans for the item">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriableid" required="false" type="String" hint="id of a subscriable product">
		<cfset var Plans=0>
		<cfquery name="Plans" datasource="#subscriptiondsn#">
			SELECT
				IDPOOL.ITEMNAME AS SUBSCRIABLEITEM,
				SUBSCRIPTIONPLANS.ID,
				(SELECT ITEMNAME FROM IDPOOL WHERE IDPOOL.ID=SUBSCRIPTIONPLANS.ID) AS ITEMNAME,
				SUBSCRIPTIONPLANS.TERM,
				SUBSCRIPTIONPLANS.TERMMEASURE,
				SUBSCRIPTIONPLANS.USABLEMINUTES,
				(SELECT TOP 1 PRICE FROM PRICE WHERE ID=SUBSCRIPTIONPLANS.ID AND PRICENAMEID=1 ORDER BY TIMEDATE DESC) AS RETAILPRICE,
				SUBSCRIPTIONPLANS.ONSALE
			FROM SUBSCRIPTIONPLANS, IDPOOL
			WHERE SUBSCRIPTIONPLANS.SUBSCRIABLEID=IDPOOL.ID
			AND SUBSCRIPTIONPLANS.SUBSCRIABLEID=<cfqueryparam value="#subscriableid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn Plans>
	</cffunction>
	
	<cffunction name="getSubscriptionPlans" access="public" returntype="Query" hint="I get all subscription plans for the item. Return fields: ITEMNAME, STOPSELLING, ID, TERM, TERMMEASURE, USABLEMINUTES, ONSALE">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionplanid" required="false" type="String" hint="subscription plan id" default=0>
		<cfset var subscriptionPlans=0>
		<cfquery name="subscriptionPlans" datasource="#subscriptiondsn#">
			SELECT
				IDPOOL.ITEMNAME,
				IDPOOL.STOPSELLING,
				SUBSCRIPTIONPLANS.ID,
				SUBSCRIPTIONPLANS.SUBSCRIABLEID,
				SUBSCRIPTIONPLANS.TERM,
				SUBSCRIPTIONPLANS.TERMMEASURE,
				SUBSCRIPTIONPLANS.USABLEMINUTES,
				SUBSCRIPTIONPLANS.ONSALE
			FROM SUBSCRIPTIONPLANS, IDPOOL
			WHERE SUBSCRIPTIONPLANS.ID=IDPOOL.ID
			<cfif subscriptionplanid NEQ 0>
			AND SUBSCRIPTIONPLANS.ID=<cfqueryparam value="#subscriptionplanid#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn subscriptionPlans>
	</cffunction>
	
	<cffunction name="getSubscriptionId" access="public" returntype="numeric" hint="I check if the subscription already exists">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="subscription plan id">
		<cfargument name="nameid" required="false" type="String" hint="nameid of the the subscriber">
		<cfset var subscription=0>
		<cfquery name="subscription" datasource="#subscriptiondsn#">
			SELECT SUBSCRIPTIONID FROM SUBSCRIBED
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			AND NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif subscription.recordcount GT 0> <cfreturn subscription.subscriptionid>
		<cfelse> <cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getCurrentSubscription" access="public" returntype="query" hint="view subsciption, I return a recordset: ITEMNAME, ID, SUBSCRIABLEID, TERM, TERMMEASURE, USABLEMINUTES, SUBSCRIPTIONID, NAMEID, CANCELLED, FIRSTNAME, .LASTNAME, DATERENEWED, RENEWALDATE"> 
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="nameid" default="0" required="false" type="string" hint="the id of the person's subscription you want">
		<cfset var currentSubscription=0>
	
		<cfquery name="currentSubscription" datasource="#subscriptiondsn#">
			SELECT
				IDPOOL.ITEMNAME,
				SUBSCRIPTIONPLANS.ID,
				SUBSCRIPTIONPLANS.SUBSCRIABLEID,
				SUBSCRIPTIONPLANS.TERM,
				SUBSCRIPTIONPLANS.TERMMEASURE,
				SUBSCRIPTIONPLANS.USABLEMINUTES,
				SUBSCRIBED.SUBSCRIPTIONID,
				SUBSCRIBED.NAMEID,
				SUBSCRIBED.CANCELLED,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.COMPANY,
				(SELECT TOP 1 RENEWALDATE FROM SUBSCRIPTION WHERE SUBSCRIPTIONID=SUBSCRIBED.SUBSCRIPTIONID ORDER BY DATERENEWED DESC) AS RENEWALDATE,
				(SELECT TOP 1 DATERENEWED FROM SUBSCRIPTION WHERE SUBSCRIPTIONID=SUBSCRIBED.SUBSCRIPTIONID ORDER BY DATERENEWED DESC) AS DATERENEWED
			FROM IDPOOL, SUBSCRIPTIONPLANS, SUBSCRIBED, NAME
			WHERE IDPOOL.ID=SUBSCRIPTIONPLANS.ID
			<cfif arguments.nameid neq 0>
			AND SUBSCRIBED.NAMEID = <cfqueryparam value="#arguments.nameid#">
			</cfif>
			AND SUBSCRIPTIONPLANS.ID=SUBSCRIBED.ID
			AND SUBSCRIBED.NAMEID=NAME.NAMEID
			AND SUBSCRIBED.SUBSCRIPTIONID IN (SELECT SUBSCRIPTIONID FROM SUBSCRIPTION WHERE RENEWALDATE ><cfqueryparam value="#mytime.createtimedate()#" cfsqltype="cf_sql_varchar">)
			AND SUBSCRIBED.ACTIVE=1
			ORDER BY RENEWALDATE
		</cfquery>
		<cfreturn currentSubscription>
	</cffunction>
	
	<cffunction name="getInactiveSubscription" access="public" returntype="query" hint="view subsciption"> 
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="false" type="string" default="0" hint="inactive subscriptionid">
		<cfset var inactiveSubscription=0>
	
		<cfquery name="inactiveSubscription" datasource="#subscriptiondsn#">
			SELECT
				IDPOOL.ITEMNAME,
				SUBSCRIPTIONPLANS.ID,
				SUBSCRIPTIONPLANS.SUBSCRIABLEID,
				SUBSCRIPTIONPLANS.TERM,
				SUBSCRIPTIONPLANS.TERMMEASURE,
				SUBSCRIPTIONPLANS.USABLEMINUTES,
				SUBSCRIBED.SUBSCRIPTIONID,
				SUBSCRIBED.NAMEID,
				SUBSCRIBED.CANCELLED,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				(SELECT TOP 1 RENEWALDATE FROM SUBSCRIPTION WHERE SUBSCRIPTIONID=SUBSCRIBED.SUBSCRIPTIONID ORDER BY DATERENEWED DESC) AS RENEWALDATE,
				(SELECT TOP 1 DATERENEWED FROM SUBSCRIPTION WHERE SUBSCRIPTIONID=SUBSCRIBED.SUBSCRIPTIONID ORDER BY DATERENEWED DESC) AS DATERENEWED
			FROM IDPOOL, SUBSCRIPTIONPLANS, SUBSCRIBED, NAME
			WHERE IDPOOL.ID=SUBSCRIPTIONPLANS.ID
			AND SUBSCRIPTIONPLANS.ID=SUBSCRIBED.ID
			AND SUBSCRIBED.NAMEID=NAME.NAMEID
			AND SUBSCRIBED.ACTIVE=0
			<cfif arguments.subscriptionid NEQ "0">
			AND SUBSCRIBED.SUBSCRIPTIONID=<cfqueryparam value="#arguments.subscriptionid#">
			</cfif>
			ORDER BY DATERENEWED DESC
		</cfquery>
		<cfreturn inactiveSubscription>
	</cffunction>
	
	<cffunction name="getsubscriptionhistory" access="public" returntype="Query" hint="get subscription history">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfset var subscriptionhistory=0>
		<cfquery name="subscriptionhistory" datasource="#subscriptiondsn#">
			SELECT
				SUBSCRIPTION.SUBSCRIPTIONID,
				SUBSCRIPTION.NAMEID,
				SUBSCRIPTION.RENEWALDATE,
				SUBSCRIPTION.DATERENEWED
			FROM SUBSCRIPTION
			WHERE SUBSCRIPTION.SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			ORDER BY SUBSCRIPTION.DATERENEWED DESC
		</cfquery>
		<cfreturn subscriptionhistory>
	</cffunction>
	
	<cffunction name="getsubscription_record" access="public" returntype="Query" hint="Get subscription activations">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfset var subscriptionrecord=0>
		<cfquery name="subscriptionrecord" datasource="#subscriptiondsn#">
			SELECT
				SUBSCRIPTION_RECORD.SUBSCRIPTIONID,
				SUBSCRIPTION_RECORD.NAMEID,
				SUBSCRIPTION_RECORD.CANCELLED,
				SUBSCRIPTION_RECORD.RECORDEDON
			FROM SUBSCRIPTION_RECORD
			WHERE SUBSCRIPTION_RECORD.SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
			ORDER BY RECORDEDON DESC			
		</cfquery>
		<cfreturn subscriptionrecord>
	</cffunction>
	
	<cffunction name="getsubscriptionactivations" access="public" returntype="Query" hint="Get subscription activations">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfquery name="cancel" datasource="#subscriptiondsn#">
			SELECT
				SUBSCRIPTIONACTIVATION.ACTIVATIONID,
				SUBSCRIPTIONACTIVATION.SUBSCRIPTIONID,
				SUBSCRIPTIONACTIVATION.ACTIVATED,
				SUBSCRIPTIONACTIVATION.NAMEID,
				SUBSCRIPTIONACTIVATION.TIMEDATE
			FROM SUBSCRIPTIONACTIVATION
			WHERE SUBSCRIPTIONACTIVATION.SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">		
		</cfquery>
		<cfreturn cancel>
	</cffunction>
	
	<cffunction name="getAllvideoPlans" access="public" returntype="Query" hint="Gets all 'all video' plans">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.subscriptiondsn#">
			SELECT
				IDPOOL.ITEMNAME,
				IDPOOL.STOPSELLING,
				SUBSCRIPTIONPLANS.ID,
				SUBSCRIPTIONPLANS.TERM,
				SUBSCRIPTIONPLANS.TERMMEASURE,
				SUBSCRIPTIONPLANS.USABLEMINUTES,
				SUBSCRIPTIONPLANS.ONSALE
			FROM SUBSCRIPTIONPLANS, IDPOOL
			WHERE SUBSCRIPTIONPLANS.ID=IDPOOL.ID
			AND IDPOOL.ITEMNAME LIKE 'All Videos - %'
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getmyvideos" access="public" returntype="Query" hint="I get all the videos the person with the nameid has access to">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="nameid" required="true" type="String" hint="Subscription id">
		<cfargument name="vid" required="false" default="0" type="String" hint="vid of the video. If this value is passed, it acts as a function which checks if a video is subscribed to a person VID, VIDEOPATH, IMAGEPATH, TITLE, MEDIATYPEID, .CAPTION, SUBSCRIPTIONID, NAMEID, ACTIVE, RENEWALDATE - order by RENEWALDATE">
		<cfset var myvideos=0>
		<cfset var myqry=0>
		<cfset var flag=0>
		
		<cfinvoke method="cancelExpiredSubscription" subscriptiondsn="#arguments.subscriptiondsn#">
		<cfinvoke method="getmyplan" subscriptiondsn="#arguments.subscriptiondsn#" nameid="#arguments.nameid#" returnvariable="plans">
		
		<cfloop query="plans">
			<cfif id EQ 0>
				<cfset flag=3>
			<cfelseif id EQ 90>
				<cfset flag=3>
			<cfelseif id EQ 168>
				<cfset flag=2>		
			<cfelseif Trim(itemname) EQ "All">
				<cfset flag=3><cfbreak>
			</cfif>
		</cfloop>
		
		<cfif flag EQ 0>
			<!--- UPDATED BY DREW 1-23-2009 SEE BELOW
			 <cfquery name="myvideos" datasource="#arguments.subscriptiondsn#">
				SELECT VID, VIDEOPATH, IMAGEPATH, TITLE, MEDIATYPEID, CAPTION 
				FROM VIDEOLIB 
				WHERE VID 
				IN
				(
					SELECT SUBSCRIABLEID 
					FROM SUBSCRIPTIONPLANS 
					WHERE ID 
					IN
					(
						SELECT ID 
						FROM SUBSCRIBED 
						WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar"> 
						AND ACTIVE=1
						
					)
					<cfif arguments.vid NEQ 0>
					AND SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
					</cfif>
				);
			</cfquery> --->
			<cfquery name="myvideos" datasource="#arguments.subscriptiondsn#">
			SELECT  
				SUBSCRIPTION.SUBSCRIPTIONID,
				SUBSCRIPTION.RENEWALDATE,   
				SUBSCRIBED.NAMEID,
				SUBSCRIBED.ACTIVE,
				VIDEOLIB.VID, 
				VIDEOLIB.TITLE, 
				VIDEOLIB.STATUS, 
				VIDEOLIB.LINK, 
				VIDEOLIB.LINKTEXT, 
				VIDEOLIB.KEYWORDS, 
				VIDEOLIB.VIDEOPATH, 
				VIDEOLIB.IMAGEPATH, 
				VIDEOLIB.SUMMARY, 
				VIDEOLIB.DESCRIPTION, 
				VIDEOLIB.CAPTION,
				VIDEOLIB.MEDIATYPEID, 
				(SELECT LENGTH FROM  VIDEOLENGTH WHERE VID=VIDEOLIB.VID) AS LENGTH,
				SUBSCRIPTIONPLANS.SUBSCRIABLEID
			FROM
				SUBSCRIPTION,
				SUBSCRIBED,
				SUBSCRIPTIONPLANS,
				VIDEOLIB
			WHERE SUBSCRIBED.ID = SUBSCRIPTIONPLANS.ID 
			AND SUBSCRIBED.SUBSCRIPTIONID = SUBSCRIPTION.SUBSCRIPTIONID
			AND SUBSCRIBED.ACTIVE=1
			AND SUBSCRIPTION.RENEWALDATE = 
				(SELECT TOP 1 RENEWALDATE 
					FROM SUBSCRIPTION SUB
					WHERE SUB.SUBSCRIPTIONID = SUBSCRIPTION.SUBSCRIPTIONID
					ORDER BY RENEWALDATE DESC)
			AND SUBSCRIPTIONPLANS.SUBSCRIABLEID = VIDEOLIB.VID
			AND SUBSCRIBED.NAMEID = <cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			<cfif arguments.vid NEQ 0>
			AND VIDEOLIB.VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			</cfif>
			AND VIDEOLIB.STATUS='Public'
			ORDER BY VIDEOLIB.VID
		</cfquery>
		<cfelse>
			<cfquery name="myqry" datasource="#arguments.subscriptiondsn#">
				SELECT TOP 1 SUBSCRIPTIONID 
				FROM SUBSCRIBED 
				WHERE NAMEID=<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar"> 
				AND ACTIVE=1
			</cfquery>
			<cfif flag EQ 1>
				<cfset variables.mediatypeid=1>
			<cfelseif flag EQ 2>
				<cfset variables.mediatypeid=2>
			</cfif>
			<cfquery name="myvideos" datasource="#subscriptiondsn#">
				SELECT 
					VID, 
					TITLE, 
					STATUS, 
					LINK, 
					LINKTEXT, 
					KEYWORDS, 
					VIDEOPATH, 
					IMAGEPATH, 
					SUMMARY, 
					DESCRIPTION, 
					CAPTION,
					MEDIATYPEID, 
					(SELECT LENGTH FROM  VIDEOLENGTH WHERE VID=VIDEOLIB.VID) AS LENGTH,
					(SELECT TOP 1 RENEWALDATE FROM SUBSCRIPTION WHERE SUBSCRIPTIONID=<cfqueryparam value="#myqry.subscriptionid#" cfsqltype="cf_sql_varchar"> ORDER BY RENEWALDATE DESC) AS RENEWALDATE
				FROM VIDEOLIB
				WHERE STATUS='Public'
				<cfif flag LT 3>
				AND MEDIATYPEID=<cfqueryparam value="#variables.mediatypeid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif vid NEQ 0>
				AND VID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfquery>
		</cfif>
		<cfreturn myvideos>
	</cffunction>
	
	<cffunction name="getmyplan" access="public" returntype="Query" hint="I get all the plans">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="nameid" required="true" type="String" hint="Subscription id">
		<cfset var getmyplan=0>
		<cfquery name="getmyplan" datasource="#subscriptiondsn#">
			SELECT ID, ITEMNAME FROM IDPOOL
			WHERE ID IN
			(
				SELECT SUBSCRIABLEID 
				FROM SUBSCRIPTIONPLANS 
				WHERE ID 
				IN
				(
					SELECT ID 
					FROM SUBSCRIBED 
					WHERE NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar"> 
					AND ACTIVE=1
				)
			);
		</cfquery>
		<cfreturn getmyplan>
	</cffunction>
	
	<cffunction name="getotherplans" access="public" returntype="Query" hint="I get all plans that i dont already have">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="nameid" required="true" type="String" hint="Subscription id">
		<cfset var otherplans=0>
		<cfquery name="otherplans" datasource="#subscriptiondsn#">
			SELECT SUBSCRIPTIONPLANS.ID, IDPOOL.ITEMNAME, IDPOOL.IDFOR FROM IDPOOL, SUBSCRIPTIONPLANS
			WHERE IDPOOL.ID=SUBSCRIPTIONPLANS.ID
			AND IDPOOL.STOPSELLING=0
			AND IDPOOL.ID NOT IN
			(
				SELECT ID FROM IDPOOL
				WHERE ID IN
				(
					SELECT SUBSCRIABLEID 
					FROM SUBSCRIPTIONPLANS 
					WHERE ID 
					IN
					(
						SELECT ID 
						FROM SUBSCRIBED 
						WHERE NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
						AND ACTIVE=1
					)
				)
			);
		</cfquery>
		<cfreturn otherplans>
	</cffunction>
	
	<cffunction name="getRenewalDate" access="public" returntype="String" hint="Get renewal Date for a subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="subscriptionid" required="true" type="String" hint="Subscription id">
		<cfquery name="getrenewaldate" datasource="#subscriptiondsn#">
			SELECT MAX(RENEWALDATE) AS MAXRENEWALDATE FROM SUBSCRIPTION
			WHERE SUBSCRIPTIONID=<cfqueryparam value="#subscriptionid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getrenewaldate.MAXRENEWALDATE>
	</cffunction>
	
	<cffunction name="getretailprice" access="public" returntype="String" hint="I get retail price (7 days subscritption)" >
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="vid" required="true" type="String" hint="id of the product">
		<cfset var getprice=0>
		<cfquery name="getprice" datasource="#subscriptiondsn#">
			SELECT PRICE FROM PRICE
			WHERE ID IN
			(
				SELECT TOP 1 ID 
				FROM SUBSCRIPTIONPLANS
				WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
				ORDER BY ID
			)
			AND PRICENAMEID=<cfqueryparam value="1">
			AND ACTIVE=<cfqueryparam value="1">
		</cfquery>
		<cfreturn getprice.PRICE>
	</cffunction>
	
	<cffunction name="setRetailprice" access="public" returntype="void" hint="I get retail price (7 days subscritption)" >
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="vid" required="true" type="String" hint="id of the product">
		<cfargument name="price" required="true" type="string" hint="price of the product">
		<cfset var setprice=0>
		<cfset var get=0>
		<cfset var timedate="#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">
		<cfquery name="get" datasource="#arguments.subscriptiondsn#">
			SELECT TOP 1 ID 
			FROM SUBSCRIPTIONPLANS
			WHERE SUBSCRIABLEID=<cfqueryparam value="#arguments.vid#" cfsqltype="cf_sql_varchar">
			ORDER BY ID
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfquery name="setprice" datasource="#arguments.subscriptiondsn#">
				UPDATE PRICE SET ACTIVE=<cfqueryparam value="0">
				WHERE PRICENAMEID=<cfqueryparam value="1">
				AND ID=<cfqueryparam value="#get.ID#">
			</cfquery>
			<cfquery name="setprice" datasource="#arguments.subscriptiondsn#">
				INSERT INTO PRICE
				(
					ID,
					PRICENAMEID,
					PRICE,
					TIMEDATE
				)
				VALUES
				(
					<cfqueryparam value="#get.ID#">,
					<cfqueryparam value="1">,
					<cfqueryparam value="#arguments.price#">,
					<cfqueryparam value="#timedate#">
				)
			</cfquery>
		</cfif>
		<cfreturn>
	</cffunction>
	
	
	<cffunction name="getDefaultPlan" access="public" returntype="Query" hint="I get default plan. Return fields: ID, TERM, TERMMEASURE, TIMEDATE">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfset var defaultplan=0>
		<cfquery name="defaultplan" datasource="#subscriptiondsn#">
			SELECT TOP 1 ID, TERM, TERMMEASURE, TIMEDATE
			FROM DEFAULTPLAN
			ORDER BY ID DESC
		</cfquery>
		<cfreturn defaultplan>
	</cffunction>
	
	<cffunction name="checkVideoCategoryOfPlan" access="public" returntype="String" hint="I check if a video of the plan belongs to the given videocategory. I 1 if True and 0 if false">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="true" type="String" hint="ID of the this plan">
		<cfargument name="videocategoryid" required="true" type="String" hint="videocategoryid id of the video included in the plan">
		<cfset var check=0>
		
		<cfquery name="check" datasource="#arguments.subscriptiondsn#">
			SELECT VIDEOCATEGORYID FROM VIDEO_TO_CATEGORY 
			WHERE VIDEOCATEGORYID=<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">
			AND VID IN(SELECT SUBSCRIABLEID AS VID FROM SUBSCRIPTIONPLANS WHERE ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<cfif check.recordcount GT 0><cfreturn 1>
		<cfelse><cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="updatesubscriptionplan" access="public" returntype="void" hint="I update subscriptionplans">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="true" type="String" hint="id of the this plan">
		<cfargument name="term" required="false" type="String" hint="Term of subscription">
		<cfargument name="termmeasure" required="false" type="String" hint="term measure like month or year or week or days">
		<cfargument name="usableminutes" required="false" default="0" type="String" hint="Total number of usable minutes">	
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.subscriptiondsn#">
			UPDATE SUBSCRIPTIONPLANS
			SET USABLEMINUTES=<cfqueryparam value="#arguments.usableminutes#" cfsqltype="cf_sql_varchar">
			<cfif isDefined('arguments.term')>
				,TERM=<cfqueryparam value="#arguments.term#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('arguments.termmeasure')>
				,TERMMEASURE=<cfqueryparam value="#arguments.termmeasure#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="cancelExpiredSubscription" access="public" returntype="void" hint="Cancel Expired Subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database name">
		<cfset var cancelexpired=0>
		<cfquery name="cancelexpired" datasource="#subscriptiondsn#">
			UPDATE SUBSCRIBED SET ACTIVE = 0
			WHERE SUBSCRIPTIONID NOT IN 
			(SELECT DISTINCT SUBSCRIPTIONID 
			FROM SUBSCRIPTION 
			WHERE RENEWALDATE > <cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">)
		</cfquery>
	</cffunction>
	
	<cffunction name="getVideoInfo" access="public" returntype="query" hint="I get video/Audio information for a subscription">
		<cfargument name="subscriptiondsn" required="true" type="String" hint="Database nam e">
		<cfargument name="id" required="true" type="String" hint="subscription plan id">
		<cfset var videoInfo=0>
		<cfquery name="videoInfo" datasource="#arguments.subscriptiondsn#">
			SELECT
				 VID,
				 IMAGEPATH,
				 MEDIATYPEID
			FROM VIDEOLIB
			WHERE VID IN (SELECT SUBSCRIABLEID FROM SUBSCRIPTIONPLANS WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<cfreturn videoInfo>
	</cffunction>
</cfcomponent>