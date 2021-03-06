<!--- 2.2 Alpha 3 (Build 131) --->
<!--- Last Updated: 2008-05-28 --->
<!--- Created by Beth Bowden and Steve Bryant 2007-01-14 --->
<cfcomponent extends="DataMgr" displayname="Data Manager for Oracle" hint="I manage data interactions with the Oracle database. I can be used to handle inserts/updates.">

<cffunction name="getDatabase" access="public" returntype="string" output="no" hint="I return the database platform being used (Access,MS SQL,MySQL etc).">
	<cfreturn "Oracle">
</cffunction>

<cffunction name="getDatabaseShortString" access="public" returntype="string" output="no" hint="I return the string that can be found in the driver or JDBC URL for the database platform being used.">
	<cfreturn "oracle">
</cffunction>

<cffunction name="getDatabaseProperties" access="public" returntype="struct" output="no" hint="I return some properties about this database">
	
	<cfset var sProps = StructNew()>
	
	<cfset sProps["areSubqueriesSortable"] = false>
	
	<cfreturn sProps>
</cffunction>

<cffunction name="getCreateSQL" access="public" returntype="string" output="no" hint="I return the SQL to create the given table.">
	<cfargument name="tablename" type="string" required="yes" />

	<cfset var i = 0><!--- generic counter --->
	<cfset var arrFields = getFields(arguments.tablename)><!--- table structure --->
	<cfset var CreateSQL = ""><!--- holds sql to create table --->
	<cfset var pkfields = "">
	<cfset var pkfieldsSQL = "">
	<cfset var thisField = "">
	<cfset var seqField = 0>
	<cfset var lf = chr(10)>

	<!--- Find Primary Key fields --->
	<cfloop index="i" from="1" to="#ArrayLen(arrFields)#" step="1">
		<cfif arrFields[i].PrimaryKey>
			<cfset pkfields = ListAppend(pkfields, arrFields[i].ColumnName) />
			<cfset pkfieldsSQL = ListAppend(pkfieldsSQL, escape(arrFields[i].ColumnName)) />
		</cfif>
	</cfloop>

	<!--- create sql to create table --->
	<cfsavecontent variable="CreateSQL"><cfoutput>
CREATE TABLE #escape(arguments.tablename)# (<cfloop index="i" from="1" to="#ArrayLen(arrFields)#" step="1">
	#escape(arrFields[i].ColumnName)# #UCase(getDBDataType(arrFields[i].CF_DataType))#<cfif isStringType(getDBDataType(arrFields[i].CF_DataType))>(<cfif StructKeyExists(arrFields[i],"Length") AND isNumeric(arrFields[i].Length) AND arrFields[i].Length gt 0>#arrFields[i].Length#<cfelse>255</cfif>)</cfif><cfif StructKeyExists(arrFields[i],"Default") AND Len(Trim(arrFields[i].Default))> DEFAULT #arrFields[i].Default#</cfif> <cfif ListFindNoCase(pkfields,arrFields[i].ColumnName) OR NOT arrFields[i].AllowNulls>NOT </cfif>NULL <cfif StructKeyExists(arrFields[i],"Increment") AND arrFields[i].Increment><cfset seqField = i></cfif><cfif i lt ArrayLen(arrFields)>,</cfif></cfloop><cfif listlen(pkfields) gt 0>,
	CONSTRAINT "#arguments.tablename#_PK" PRIMARY KEY (#pkfieldsSQL#) ENABLE</cfif>
)<cfif seqField>;
CREATE SEQUENCE #escape("#arguments.tablename#_SEQ")#;
CREATE OR REPLACE TRIGGER #escape("BI_#arguments.tablename#")# #lf#  before insert on #escape(arguments.tablename)##lf#  for each row #lf#begin  #lf#    select #escape("#arguments.tablename#_SEQ")#.nextval into :NEW.#escape(arrFields[seqField].ColumnName)# from dual|DataMgr_SemiColon|#lf#end|DataMgr_SemiColon|
	</cfif>
	</cfoutput></cfsavecontent>
	
	<cfreturn CreateSQL>
</cffunction>

<cffunction name="concat" access="public" returntype="string" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="fields" type="string" required="yes" hint="I am a list of fields">
	<cfargument name="delimeter" type="string" default="" hint="I am the delimiter but I cannot be a single quote">

	<cfset var result  = "">

	<!--- @@Note: Steve, I think the listChangeDelims function does what you want it to --->
	<cfset var colname = "">
	<cfloop index="colname" list="#arguments.fields#">
		<cfif Len(result)>
			<cfset result =  result & " || '#arguments.delimeter#' || #colname#">
		<cfelse>
			<cfset result = "CAST(#colname# AS varchar(500))">
		</cfif>
	</cfloop>
	<!--- <cfset result = listChangeDelims( arguments.fields, "|| '#arguments.delimeter#' ||", "," )/> --->

	<cfreturn result>
</cffunction>

<cffunction name="concatFields" access="public" returntype="array" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="fields" type="string" required="yes">
	<cfargument name="delimeter" type="string" default=",">
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var col = "">
	<cfset var aSQL = ArrayNew(1)>
	<cfset var fieldSQL = 0>
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfloop index="colname" list="#arguments.fields#">
		<cfset fieldSQL = getFieldSelectSQL(tablename=arguments.tablename,field=colname,tablealias=arguments.tablealias,useFieldAlias=false)>
		<cfif ArrayLen(aSQL)>
			<cfset ArrayAppend(aSQL," || '#arguments.delimeter#' || ")>
		</cfif>
		<cfif isSimpleValue(fieldSQL)>
			<cfset ArrayAppend(aSQL,"NVL(CAST(#fieldSQL# AS varchar(500)),'')")>
		<cfelse>
			<cfset ArrayAppend(aSQL,"NVL(CAST(")>
			<cfset ArrayAppend(aSQL,fieldSQL)>
			<cfset ArrayAppend(aSQL," AS varchar(500)),'')")>
		</cfif>
	</cfloop>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="escape" access="public" returntype="string" output="no" hint="I return an escaped value for a table or field.">
	<cfargument name="name" type="string" required="yes" comments="I am a period-delimited list" />

	<cfset var result = "">
	<!--- @@Note: Steve, I think the listQualify function does what you want it to. --->
	<!---
    <cfset var item = "" />

  	<cfloop index="item" list="#arguments.name#" delimiters=".">
	  	<cfset result = ListAppend(result, '"#item#"',  ".")>
  	</cfloop>
  --->
	<cfset result = ListQualify(UCase(arguments.name), '#chr(34)#', ".", "all" )>

	<cfreturn result>
</cffunction>

<cffunction name="getDatabaseTables" access="public" returntype="string" output="no" hint="I get a list of all tables in the current database.">

	<cfset var qTables = runSQL("SELECT object_name Table_Name FROM user_objects WHERE object_Type = 'TABLE'") />

	<cfreturn ValueList(qTables.Table_Name)>
</cffunction>

<cffunction name="getDBTableStruct" access="public" returntype="array" output="no" hint="I return the structure of the given table in the database.">
	<cfargument name="tablename" type="string" required="yes" />

	<cfscript>
		var qStructure   = 0;
		var qPrimaryKeys = 0;
		var qIndices     = 0;
		var TableData    = ArrayNew(1);
		var tmpStruct    = StructNew();
		var PrimaryKeys  = "";
		var sqlarray     = ArrayNew(1);

  	var qSequences = 0;
  	var Sequences = "";

    /* @@Note: The table name in the config file may be specified as upper, lower or mixed case.
                Almost everyone in the known universe create table and column names in upper case.
                So first check for the table as provided. If not found, then check for the
                uppercased table.
    */
	  var qTable = runSQL("SELECT object_name table_name FROM user_objects where object_type = 'TABLE' and	object_name = '#arguments.tablename#'");
	</cfscript>

  <cfif qTable.recordCount eq 0>
	  <cfset qTable = runSQL("SELECT object_name table_name FROM user_objects where object_type = 'TABLE' and	object_name = '#ucase(arguments.tablename)#") />
  </cfif>

	<cfif qTable.RecordCount eq 0>
		<cfthrow message="Data Manager: No such table ('#arguments.tablename#'). Trying to load a table that doesn't exist." type="DataMgr">
	</cfif>

	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT" ) />
	<cfset ArrayAppend(sqlarray,"  	    col.COLUMN_NAME       as field," ) />
	<cfset ArrayAppend(sqlarray,"       col.DATA_TYPE         as type," ) />
	<cfset ArrayAppend(sqlarray,"       case" ) />
	<cfset ArrayAppend(sqlarray,"         /* 26 is the length of now() in ColdFusion (i.e. {ts '2006-06-26 13:10:14'})*/" ) />
	<cfset ArrayAppend(sqlarray,"         when col.data_type = 'DATE'   then 26" ) />
	<cfset ArrayAppend(sqlarray,"         else col.data_length" ) />
	<cfset ArrayAppend(sqlarray,"       end	                  as MaxLength," ) />
	<cfset ArrayAppend(sqlarray,"       CASE" ) />
	<cfset ArrayAppend(sqlarray,"			WHEN col.NULLABLE = 'Y' THEN 'true'" ) />
	<cfset ArrayAppend(sqlarray,"			ELSE 'false'" ) />
	<cfset ArrayAppend(sqlarray,"       END	     as AllowNulls," ) />
	<cfset ArrayAppend(sqlarray,"       col.DATA_DEFAULT      as ""DEFAULT""," ) />
	<cfset ArrayAppend(sqlarray,"       col.data_precision    as precision," ) />
	<cfset ArrayAppend(sqlarray,"		col.data_scale        as Scale" ) />
	<cfset ArrayAppend(sqlarray," FROM  all_tab_columns   col" ) />
	<cfset ArrayAppend(sqlarray," WHERE col.table_name = '#qTable.table_name#'" ) />
	<cfset ArrayAppend(sqlarray," ORDER BY col.column_id" ) />
	<cfset qStructure = runSQLArray(sqlarray)>

	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray," SELECT colcon.column_name" ) />
	<cfset ArrayAppend(sqlarray,"   FROM all_cons_columns colcon" ) />
	<cfset ArrayAppend(sqlarray," ,      all_constraints tabcon" ) />
	<cfset ArrayAppend(sqlarray,"  WHERE tabcon.table_name = '#qTable.table_name#'" ) />
	<cfset ArrayAppend(sqlarray,"    AND colcon.constraint_name = tabcon.constraint_name" ) />
	<cfset ArrayAppend(sqlarray,"    AND colcon.table_name = tabcon.table_name" ) />
	<cfset ArrayAppend(sqlarray,"    AND tabcon.constraint_type = 'P'" ) />
	<cfset qPrimaryKeys = runSQLArray(sqlarray)>

	<cfif qPrimaryKeys.RecordCount>
		<cfset PrimaryKeys = ValueList(qPrimaryKeys.Column_Name)>
	</cfif>

	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT	sequence_name")>
	<cfset ArrayAppend(sqlarray,"FROM	user_sequences")>
	<cfset ArrayAppend(sqlarray,"WHERE	sequence_name LIKE '#arguments.tablename#%'")>
	<cfset qSequences = runSQLArray(sqlarray)>

	<cfoutput query="qSequences">
		<cfset Sequences = ListAppend(Sequences,ReplaceNoCase(ReplaceNoCase(relname, "#arguments.tablename#_", ""), "_seq", "") )>
	</cfoutput>

	<cfoutput query="qStructure">
		<cfset tmpStruct = StructNew() />
		<cfset tmpStruct["ColumnName"]  = Field />
		<cfset tmpStruct["CF_DataType"] = getCFDataType(Type) />
		<cfif ListFindNoCase(PrimaryKeys,Field)>
			<cfset tmpStruct["PrimaryKey"] = true />
		<cfelse>
			<cfset tmpStruct["PrimaryKey"] = false />
		</cfif>
	  <!--- @@Note: Oracle has no equivalent to autoincrement or  identity  --->
		<cfset tmpStruct["Increment"] = false>
		<cfif   Len(MaxLength)
        AND isNumeric(MaxLength)
        AND NOT tmpStruct["CF_DataType"] eq "CF_SQL_LONGVARCHAR">
			<cfset tmpStruct["length"] = MaxLength />
		</cfif>
		<cfif isBoolean(Trim(AllowNulls))>
			<cfset tmpStruct["AllowNulls"] = Trim(AllowNulls)/>
		<cfelse>
			<cfset tmpStruct["AllowNulls"] = true />
		</cfif>
		<cfset tmpStruct["Precision"] = Precision />
		<cfset tmpStruct["Scale"]     = Scale />
		<cfif Len(Default)>
			<cfset tmpStruct["Default"] = Default />
		</cfif>
		<cfset tmpStruct["Special"] = "" />

		<cfif Len(tmpStruct.CF_DataType)>
			<cfset ArrayAppend(TableData,StructCopy(tmpStruct))>
		</cfif>
	</cfoutput>

	<cfreturn TableData />
</cffunction>

<cffunction name="getCFDataType" access="public" returntype="string" output="no" hint="I return the cfqueryparam datatype from the database datatype.">
	<cfargument name="type" type="string" required="yes" hint="The database data type." />

	<cfset var result = "" />

	<!--- most commonly used types --->
	<cfif compareNocase(arguments.type, "varchar2") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "date") is 0>
		<cfset result = "date" />
	<cfelseif compareNocase(arguments.type, "integer") is 0>
		<cfset result = "numeric" />
	<cfelseif compareNocase(arguments.type, "number") is 0>
		<cfset result = "numeric" />

  <!--- misc --->
	<cfelseif compareNocase(arguments.type, "rowid") is 0>
		<cfset result = "string" />

	<!--- time --->
	<cfelseif compareNocase(arguments.type, "timestamp(6)") is 0>
		<cfset result = "date" />

  <!--- strings --->
	<cfelseif compareNocase(arguments.type, "char") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "nchar") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "varchar") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "nvarchar2") is 0>
		<cfset result = "string" />

	<!--- long --->
	<!---   @@Note: bfile  not supported --->
	<cfelseif compareNocase(arguments.type, "blob") is 0>
		<cfset result = "binary" />
	<cfelseif compareNocase(arguments.type, "clob") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "nclob") is 0>
		<cfset result = "string" />
	<cfelseif compareNocase(arguments.type, "long") is 0>
		<cfset result = "string" />
   <cfelseif compareNocase(arguments.type, "long raw") is 0>
		<cfset result = "binary" />
	<cfelseif compareNocase(arguments.type, "raw") is 0>
		<cfset result = "binary" />

	<!--- numerics --->
	<cfelseif compareNocase(arguments.type, "float") is 0>
		<cfset result = "numeric" />
	<cfelseif compareNocase(arguments.type, "real") is 0>
		<cfset result = "numeric" />
  <cfelse>
     <cfthrow message="DataMgr object cannot handle this data type." type="DataMgr" detail="DataMgr cannot handle data type '#arguments.CF_Datatype#'" errorcode="InvalidDataType"/>
	</cfif>

	<cfreturn result />
</cffunction>

<cffunction name="getDBDataType" access="public" returntype="string" output="no" hint="I return the database datatype from the cfqueryparam datatype.">
	<cfargument name="CF_Datatype" type="string" required="yes" />

	<cfset var result = "" />

  <cfswitch expression="#arguments.CF_Datatype#">
		<cfcase value="CF_SQL_BIGINT">       <cfset result = "number">      </cfcase>
		<cfcase value="CF_SQL_BIT">          <cfset result = "char(1)">  </cfcase>
		<cfcase value="CF_SQL_BLOB">         <cfset result = "blob">     </cfcase>
		<cfcase value="CF_SQL_CHAR">         <cfset result = "char">     </cfcase>
		<cfcase value="CF_SQL_CLOB">         <cfset result = "long">     </cfcase>
		<cfcase value="CF_SQL_DATE">         <cfset result = "date">     </cfcase>
		<cfcase value="CF_SQL_DECIMAL">      <cfset result = "decimal">  </cfcase>
		<cfcase value="CF_SQL_DOUBLE">       <cfset result = "double">   </cfcase>
		<cfcase value="CF_SQL_FLOAT">        <cfset result = "float">    </cfcase>
		<cfcase value="CF_SQL_INTEGER">      <cfset result = "number">  </cfcase>
    <!--- @@Note: CF_SQL_LONGVARBINARY is more properly translated as "long raw". However, this can
          lead to problems as tables in Oracle can only have one "long" column
      --->
		<cfcase value="CCF_SQL_LONGVARBINARY"><cfset result = "blob"> </cfcase>
    <!--- @@Note: CF_SQL_LONGVARCHAR is more properly translated as "long". However, this can
          lead to problems as tables in Oracle can only have one "long" column
      --->
		<cfcase value="CF_SQL_LONGVARCHAR">  <cfset result = "clob">     </cfcase>
		<cfcase value="CF_SQL_NUMERIC">      <cfset result = "number">   </cfcase>
		<cfcase value="CF_SQL_REAL">         <cfset result = "real">     </cfcase>
		<cfcase value="CF_SQL_SMALLINT">     <cfset result = "smallint"> </cfcase>
		<cfcase value="CF_SQL_TIMESTAMP">    <cfset result = "date">     </cfcase>
		<cfcase value="CF_SQL_TINYINT">      <cfset result = "tinyint">  </cfcase>
		<cfcase value="CF_SQL_VARBINARY">    <cfset result = "raw">      </cfcase>
		<cfcase value="CF_SQL_VARCHAR">      <cfset result = "varchar2"> </cfcase>
		<cfdefaultcase><cfthrow message="DataMgr object cannot handle this data type." type="DataMgr" detail="DataMgr cannot handle data type '#arguments.CF_Datatype#'" errorcode="InvalidDataType"></cfdefaultcase>
	</cfswitch>
	<cfreturn result />
</cffunction>

<cffunction name="getFieldSQL_Has" access="private" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var dtype = getEffectiveDataType(arguments.tablename,sField.Relation.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var sAdvSQL = StructNew()>
	<cfset var sJoin = StructNew()>
	<cfset var sArgs = StructNew()>
	<cfset var temp = "">
	
	<cfswitch expression="#dtype#">
	<cfcase value="numeric">
		<cfset ArrayAppend(aSQL,"nvl(CASE WHEN (")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") > 0 THEN 1 ELSE 0 END,0)")>
	</cfcase>
	<cfcase value="string">
		<cfset ArrayAppend(aSQL,"nvl(length(")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,"),0)")>
	</cfcase>
	<cfcase value="date">
		<cfset ArrayAppend(aSQL,"CASE WHEN (")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") IS NULL THEN 0 ELSE 1 END")>
	</cfcase>
	<cfcase value="boolean">
		<cfset ArrayAppend(aSQL,"nvl(")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,",0)")>
	</cfcase>
	</cfswitch>
	
	<cfreturn aSQL>	
</cffunction>

<cffunction name="getNowSQL" access="public" returntype="string" output="no" hint="I return the SQL for the current date/time.">
	<cfreturn "SYSDATE">
</cffunction>

<!--- @@Note: Steve, just a stray comment - ignore at will :-). All  the Datamgr_xxxx objects override checkTable identically to the below. DataMgr_XML doesn't.
      Off the top of my head, it seems like the below should be in DataMgr.cfc. Why would XML be treated differently?
      --->
<cffunction name="checkTable" access="private" returntype="boolean" output="no" hint="I check to see if the given table exists in the Datamgr.">
	<cfargument name="tablename" type="string" required="yes">

	<cfif NOT StructKeyExists(variables.tables,arguments.tablename)>
		<cfset loadTable(arguments.tablename) />
	</cfif>

	<cfreturn true>
</cffunction>

<!--- @@Note: Steve, how do you want to handle this? Oracle doesn't use identity or autonumber fields. --->
<!--- <cffunction name="getInsertedIdentity" access="private" returntype="void" output="no" hint="I get the value of the identity field that was just inserted into the given table.">

  <cfthrow message="#getDatabase()# Database does not use identities." type="DataMgr" detail="#getDatabase()# Database does not use identities." errorcode="InvalidStatement" />

</cffunction> --->

<cffunction name="isStringType" access="private" returntype="boolean" output="no" hint="I indicate if the given datatype is valid for string data.">
	<cfargument name="type" type="string" />

	<cfset var strtypes = "char,nchar,nvarchar,nvarchar2,varchar,varchar2" />
	<cfset var result = false />
	<cfif ListFindNoCase(strtypes, arguments.type)>
		<cfset result = true />
	</cfif>

	<cfreturn result />
</cffunction>

<cffunction name="getMaxRowsPrefix" access="public" returntype="string" output="no" hint="I get the SQL before the field list in the select statement to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	<cfreturn " ">
</cffunction>

<cffunction name="getMaxRowsSuffix" access="public" returntype="string" output="no" hint="I get the SQL before the field list in the select statement to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	<cfreturn ""><!--- %%Must fix this by adding a new type of row limiter --->
	<cfreturn " where rownum <= #arguments.maxrows# ">
</cffunction>

<cffunction name="getMaxRowsWhere" access="public" returntype="string" output="no" hint="I get the SQL in the where statement to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	
	<cfreturn "rownum <= #arguments.maxrows# ">
</cffunction>

</cfcomponent>