<cfcomponent hint="I am the Data Manager type functions just for QuantumDelta">
	
	<cffunction name="tableExists" returntype="boolean" output="false" access="public" hint="I check to see if a table exists, I return a boolean value">
		<cfargument name="mydsn" type="string" required="true" hint="I am the datasource for the table you want to check">
		<cfargument name="mytable" type="string" required="true" hint="I am the table name you want to check">
		<cfset var checkTableExists = 0>
		<cfset var myTableExists = 0>
		
		<cfquery name="checkTableExists" datasource="#arguments.mydsn#">
		select * from INFORMATION_SCHEMA.tables where table_name = '#arguments.mytable#'
		</cfquery>
		<cfif checkTableExists.recordcount gt 0>
			<cfset myTableExists=true>
		<cfelse>
			<cfset myTableExists=false>
		</cfif>
	<cfreturn myTableExists>
	</cffunction>
	
	<cffunction name="columnExists" returntype="boolean" output="false" access="public" hint="I check to see if a column exists, I return a boolean value">
		<cfargument name="mydsn" type="string" required="true" hint="I am the datasource for the table you want to check">
		<cfargument name="mytable" type="string" required="true" hint="I am the table name you want to check">
		<cfargument name="mycolumn" type="string" required="true" hint="I am the column name you want to check">
		<cfset var checkColumnExists = 0>
		<cfset var myColumnExists = 0>
		
		<cfquery name="checkColumnExists" datasource="#arguments.mydsn#">
		select * from INFORMATION_SCHEMA.COLUMNS
		where TABLE_NAME='#arguments.myTable#'
		and COLUMN_NAME='#arguments.myColumn#'
		</cfquery>
		<cfif checkColumnExists.recordcount gt 0>
			<cfset mycolumnExists=true>
		<cfelse>
			<cfset mycolumnExists=false>
		</cfif>
	<cfreturn mycolumnExists>
	</cffunction>
	
	<cffunction name="viewExists" returntype="boolean" output="false" access="public" hint="I check to see if a view exists, I return a boolean value">
		<cfargument name="mydsn" type="string" required="true" hint="I am the datasource for the table you want to check">
		<cfargument name="myview" type="string" required="true" hint="I am the view name you want to check">
		<cfset var checkViewExists = 0>
		<cfset var myViewExists = 0>
		
		<cfquery name="checkViewExists" datasource="#arguments.mydsn#">
		select * from INFORMATION_SCHEMA.VIEWS
		where TABLE_NAME='#arguments.myview#'
		</cfquery>
		<cfif checkViewExists.recordcount gt 0>
			<cfset myViewExists=true>
		<cfelse>
			<cfset myViewExists=false>
		</cfif>
	<cfreturn myViewExists>
	</cffunction>
	
	<cffunction name="constraintExists" returntype="boolean" output="false" access="public" hint="I check to see if a view exists, I return a boolean value">
		<cfargument name="mydsn" type="string" required="true" hint="I am the datasource for the table you want to check">
		<cfargument name="mytable" type="string" required="true" hint="I am the table name you want to check">
		<cfargument name="constraintType" type="string" required="true" default="Primary Key" hint="the type of constraint you are looking for, I default to (Primary Key)">
		<cfset var checkconstraintExists = 0>
		<cfset var myconstaintExists = 0>
		
		<cfquery name="checkconstraintExists" datasource="#arguments.mydsn#">
		select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
		where TABLE_NAME='#arguments.mytable#'
		and CONSTRAINT_TYPE='#arguments.constraintType#'
		</cfquery>
		<cfif checkconstraintExists.recordcount gt 0>
			<cfset myconstaintExists=true>
		<cfelse>
			<cfset myconstaintExists=false>
		</cfif>
	<cfreturn myconstaintExists>
	</cffunction>
	
	<cffunction name="getConstraintName" output="true" access="public" returntype="query" hint="I get the name of the contraint you are seeking">
		<cfargument name="mydsn" type="string" required="true" hint="I am the datasource for the table you want to check">
		<cfargument name="mytable" type="string" required="true" hint="I am the table name you want to check">
		<cfargument name="constraintType" type="string" required="true" default="Primary Key" hint="the type of constraint you are looking for, I default to (Primary Key)">
		<cfset var myConstraint=0>
		<cfquery name="myConstraint" datasource="#arguments.mydsn#">
			SELECT
				CONSTRAINT_NAME
			FROM
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='#arguments.mytable#'
			AND CONSTRAINT_TYPE='#arguments.constraintType#'
		</cfquery>
	<cfreturn myConstraint>
	</cffunction>
	
	<cffunction name="QueryToStruct" access="public" returntype="any" output="false" hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">
    <cfargument name="Query" type="query" required="true" />
    <cfargument name="Row" type="numeric" required="false" default="0" />

    <cfscript>

    // Define the local scope.
    var LOCAL = StructNew();

    // Determine the indexes that we will need to loop over.
    // To do so, check to see if we are working with a given row,
    // or the whole record set.
    if (ARGUMENTS.Row){

    // We are only looping over one row.
    LOCAL.FromIndex = ARGUMENTS.Row;
    LOCAL.ToIndex = ARGUMENTS.Row;

    } else {

    // We are looping over the entire query.
    LOCAL.FromIndex = 1;
    LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

    }

    // Get the list of columns as an array and the column count.
    LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
    LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

    // Create an array to keep all the objects.
    LOCAL.DataArray = ArrayNew( 1 );

    // Loop over the rows to create a structure for each row.
    for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

    // Create a new structure for this row.
    ArrayAppend( LOCAL.DataArray, StructNew() );

    // Get the index of the current data array object.
    LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

    // Loop over the columns to set the structure values.
    for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

    // Get the column value.
    LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

    // Set column value into the structure.
    LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

    }

    }


    // At this point, we have an array of structure objects that
    // represent the rows in the query over the indexes that we
    // wanted to convert. If we did not want to convert a specific
    // record, return the array. If we wanted to convert a single
    // row, then return the just that STRUCTURE, not the array.
    if (ARGUMENTS.Row){

    // Return the first array item.
    return( LOCAL.DataArray[ 1 ] );

    } else {

    // Return the entire array.
    return( LOCAL.DataArray );

    }

    </cfscript>
    </cffunction>
	
</cfcomponent>