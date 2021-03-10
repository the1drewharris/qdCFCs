<cfcomponent hint="I handle shifts">
<cfobject component="textConversions" name="txtConversions">
<cfobject component="timeDateConversion" name="mytime">
<cfobject component="qdDataMgr" name="variables.tblCheck">
<cfset timedate=mytime.createTimeDate>
	
	<cffunction name="createShiftTables" returntype="void" output="false" access="public" hint="I create tables">
		<cfargument name="ds" type="string" required="true" hint="Data source">
		<cfset var create = 0>
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTCATEGORYTYPE')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTCATEGORYTYPE
				(
					SHIFTCATEGORYTYPEID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTCATEGORYTYPE VARCHAR(128) NOT NULL UNIQUE,
					DISPLAYCOLOR VARCHAR(128)
				)
				ALTER TABLE SHIFTCATEGORYTYPE ADD CONSTRAINT PK_SHIFTCATEGORYTYPE PRIMARY KEY(SHIFTCATEGORYTYPEID)
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTBENEFIT')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTBENEFIT
				(
					SHIFTBENEFITID BIGINT NOT NULL IDENTITY(1,1),
					BENEFITNAME VARCHAR(128) NOT NULL
				);
				ALTER TABLE SHIFTBENEFIT ADD CONSTRAINT PK_SHIFTBENEFIT PRIMARY KEY(SHIFTBENEFITID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTS')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTS
				(
					SHIFTID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTNAME VARCHAR(128) NOT NULL,
					SHIFTLOCATION VARCHAR(256),
					SHIFTSTARTTIME VARCHAR(16),
					SHIFTENDTIME VARCHAR(16),
					ORGANIZERID BIGINT,
					NOTES NTEXT,
					CATEGORYTYPEID BIGINT NOT NULL,
					EVENTID VARCHAR(16) NOT NULL
				);
				ALTER TABLE SHIFTS ADD CONSTRAINT PK_SHIFTS PRIMARY KEY(SHIFTID);
				ALTER TABLE SHIFTS ADD CONSTRAINT FK_SHIFTS_EVENT FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFTINVENTORY')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFTINVENTORY
				(
					SHIFTINVENTORYID BIGINT NOT NULL IDENTITY(1,1),
					SHIFTID BIGINT NOT NULL,
					TOTALCEILING BIGINT NOT NULL,
					CURRENTTOTAL BIGINT NOT NULL
				);
				ALTER TABLE SHIFTINVENTORY ADD CONSTRAINT PK_SHIFTINVENTORY PRIMARY KEY(SHIFTINVENTORYID);
				ALTER TABLE SHIFTINVENTORY ADD CONSTRAINT FK_SHIFTINVENTORY_SHIFT FOREIGN KEY(SHIFTID) REFERENCES SHIFTS(SHIFTID);
			</cfquery>
		</cfif>
		
		<cfif not variables.tblCheck.tableExists('#arguments.ds#', 'SHIFT2NAME')>
			<cfquery name="create" datasource="#arguments.ds#">
				CREATE TABLE SHIFT2NAME
				(
					SHIFTID BIGINT NOT NULL,
					NAMEID BIGINT NOT NULL
				);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT PK_SHIFT2NAME PRIMARY KEY(SHIFTID,NAMEID);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT FK_SHIFT2NAME_SHIFT FOREIGN KEY(SHIFTID) REFERENCES SHIFTS(SHIFTID);
				ALTER TABLE SHIFT2NAME ADD CONSTRAINT FK_SHIFT2NAME_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			</cfquery>
		</cfif>

		<cfreturn>
	</cffunction>
	
	<cffunction name="getShiftTypes" access="public" returntype="query" output="false" hint="I get all of the shift types for the datasource passed to me, return a recordset:typeid, type">
	<cfargument name="ds" type="string" required="true" hint="datasource">
	<cfset var shifttypes=0>
	<cfquery name="shifttypes" datasource="#arguments.ds#" >
	SELECT 
		SHIFTCATEGORYTYPEID as typeid, 
		SHIFTCATEGORYTYPE as type
	FROM 
		SHIFTCATEGORYTYPE
	</cfquery>
	<cfreturn shifttypes>
	</cffunction>

	<cffunction name="getBenefits" access="public" returntype="query" output="false" hint="I get all of the benefits for the the datasource passed to me and I return a recordset: shiftbenefitid, benefitname">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfset var benefits=0>
		<cfquery name="benefits" datasource="#arguments.ds#" >
		SELECT 
			SHIFTBENEFITID,
			BENEFITNAME
		FROM 
			SHIFTBENEFIT
		</cfquery>
	<cfreturn benefits>
	</cffunction>

	<cffunction name="benefitDetails" access="public" returntype="query" output="false" hint="I get the details of the benefitids passed to me and I return a recordset: SHIFTBENEFITID, BENEFITNAME, SHIFTCATEGORYTYPEID, REQUIREDHOURS, SHIFTCATEGORYTYPE">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="benefitid" type="string" default="0" required="false" hint="the id of the benefit you want details on">
		<cfset var mybenefitdetails=0>
		<cfquery name="mybenefitdetails" datasource="#arguments.ds#" >
		SELECT 
			SHIFTBENEFIT.SHIFTBENEFITID, 
			SHIFTBENEFIT.BENEFITNAME,
			BENEFIT2SHIFTCATEGORY.SHIFTCATEGORYTYPEID,
			BENEFIT2SHIFTCATEGORY.REQUIREDHOURS,
			SHIFTCATEGORYTYPE.SHIFTCATEGORYTYPE
		FROM 
			SHIFTBENEFIT,
			BENEFIT2SHIFTCATEGORY,
			SHIFTCATEGORYTYPE
		WHERE
			SHIFTBENEFIT.SHIFTBENEFITID = BENEFIT2SHIFTCATEGORY.SHIFTBENEFITID
			AND BENEFIT2SHIFTCATEGORY.SHIFTCATEGORYTYPEID = SHIFTCATEGORYTYPE.SHIFTCATEGORYTYPEID
			<cfif benefitid neq 0>AND SHIFTBENEFIT.SHIFTBENEFITID = <cfqueryparam value="#arguments.benefitid#"></cfif>
		ORDER BY SHIFTBENEFIT.SHIFTBENEFITID, BENEFIT2SHIFTCATEGORY.SHIFTCATEGORYTYPEID ASC
		</cfquery>
	<cfreturn mybenefitdetails>
	</cffunction>
	
	<cffunction name="checkShiftInventory" access="public" returntype="query" output="false" hint="I get the inventory for the shiftid passed to me, I return a recordset: SHIFTID, CURRENTTOTAL, TOTALCEILING">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="shiftid" type="string" default="0" required="true" hint="the id for the shift you want the inventory for">
		<cfset var checkinventory=0>
		<cfquery name="checkinventory" datasource="#arguments.ds#">
		SELECT 
			SHIFTID,
			CURRENTTOTAL,
			TOTALCEILING
		FROM SHIFTINVENTORY
		WHERE SHIFTID = <cfqueryparam value="#arguments.shiftid#">
		</cfquery>
		<cfreturn checkinventory>
	</cffunction>
	
	<cffunction name="getShifts" access="public" returntype="query" output="false" hint="I get all of the shifts for an event, return a recordset: SHIFTID, SHIFTNAME, SHIFTLOCATION, SHIFTSTARTTIME, SHIFTENDTIME, ORGANIZERID, SHIFTCATEGORYTYPE, NOTES, EVENTID, CATEGORYTYPEID,">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="eventid" type="string" default="0" required="true" hint="the id for the event you want to retrieve shifts for">
		<cfset var selectshift=0>
		<cfquery name="selectshifts" datasource="#arguments.ds#">
		SELECT 
			SHIFTS.SHIFTID,
			SHIFTS.SHIFTNAME,
			SHIFTS.SHIFTLOCATION,
			SHIFTS.SHIFTSTARTTIME,
			SHIFTS.SHIFTENDTIME,
			SHIFTS.ORGANIZERID,
			SHIFTS.NOTES,
			SHIFTCATEGORYTYPE.SHIFTCATEGORYTYPE,
			SHIFTCATEGORYTYPE.SHIFTCATEGORYTYPEID,
			SHIFTINVENTORY.TOTALCEILING,
			SHIFTINVENTORY.CURRENTTOTAL
		FROM
			SHIFTS,
			SHIFTCATEGORYTYPE,
			SHIFTINVENTORY
		WHERE
			SHIFTS.CATEGORYTYPEID = SHIFTCATEGORYTYPE.SHIFTCATEGORYTYPEID
		AND SHIFTS.SHIFTID = SHIFTINVENTORY.SHIFTID
			AND SHIFTS.EVENTID = <cfqueryparam value="#arguments.eventid#">
		ORDER BY 
			SHIFTS.SHIFTSTARTTIME ASC
		</cfquery>
		<cfreturn selectshifts>
	</cffunction>
	
	<cffunction name="addShift" access="public" returntype="struct" output="false" hint="I add the shift info passed to me as a new shift">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="SHIFTNAME" type="string" required="true" hint="name of the shift">
		<cfargument name="SHIFTLOCATION" type="string" required="true" hint="location of the shift">
		<cfargument name="SHIFTSTARTTIME" type="string" required="true" hint="starttime of the shift">
		<cfargument name="SHIFTENDTIME" type="string" required="true" hint="endtime of the shift">
		<cfargument name="ORGANIZERID" type="string" required="true" hint="nameid of the shift organizer">
		<cfargument name="NOTES" type="string" required="true" hint="notes for the shift">
		<cfargument name="EVENTID" type="string" required="true" hint="eventid this shift should be tied to">
		<cfargument name="CATEGORYTYPEID" type="string" required="true" hint="id of the category this shift should be tied to">
		<cfargument name="TOTALCEILING" type="string" required="true" hint="total number of people required to fill this shift">
		<cfset var addThisShift=0>
		<cfset var addShiftInventory=0>
		<cfset var shiftData=StructNew()>
		<cftransaction>
		<cfquery name="addThisShift" datasource="#arguments.ds#">
		INSERT INTO SHIFTS
			(SHIFTNAME,
			SHIFTLOCATION,
			SHIFTSTARTTIME,
			SHIFTENDTIME,
			ORGANIZERID,
			NOTES,
			EVENTID,
			CATEGORYTYPEID)
		VALUES
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHIFTNAME#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHIFTLOCATION#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHIFTSTARTTIME#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHIFTENDTIME#">,
			<cfqueryparam value="#arguments.organizerid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NOTES#">,
			<cfqueryparam value="#eventid#">,
			<cfqueryparam value="#arguments.CATEGORYTYPEID#">)
			SELECT @@IDENTITY AS SHIFTID
		</cfquery>
		<cfquery name="addShiftInventory" datasource="#arguments.ds#">
		INSERT INTO SHIFTINVENTORY
			(SHIFTID,
			TOTALCEILING,
			CURRENTTOTAL)
		VALUES
			('#addThisShift.SHIFTID#',
			<cfqueryparam value="#arguments.TOTALCEILING#">,
			'0')
		</cfquery>
		</cftransaction>
		<cfset shiftData.success=true>
		<cfreturn shiftData>
	</cffunction>
	
	<cffunction name="moveShifts" access="public" returntype="void" output="false" hint="I move the shifts from one event to another, I return nothing">
		<cfargument name="ds" type="string" required="true" hint="datasource">
		<cfargument name="oldeventid" type="string" default="0" required="true" hint="the id for the old event">
		<cfargument name="neweventid" type="string" default="0" required="true" hint="the id for new event">
		<cfquery name="selectshifts" datasource="#arguments.ds#">
		UPDATE SHIFTS
		SET EVENTID = <cfqueryparam value="#attributes.neweventid#">
		WHERE EVENTID = <cfqueryparam value="#attributes.oldeventid#">
		</cfquery>
	</cffunction>
	
</cfcomponent>