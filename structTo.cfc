<cfcomponent>
<cffunction name="ToJavascript" access="public" returntype="string" output="false"
hint="Based on CFJASON {http://jehiah.com/projects/cfjson/}, this converts ColdFusion structures to Javascript Object Notation.">
 
<cfargument name="Data" type="any" required="yes" />


<cfscript>


// Define the local scope.
var LOCAL = StructNew();


// Create an object to store the output. We are going to use
// a java string buffer as there may be a large amount of
// concatination.
LOCAL.Output = CreateObject( "java", "java.lang.StringBuffer" ).Init();


// Check to see if the data is an array.
if (IsArray( ARGUMENTS.Data )){


// Loop over the array to encode the items.
for (LOCAL.Index = 1 ; LOCAL.Index LTE ArrayLen( ARGUMENTS.Data ) ; LOCAL.Index = (LOCAL.Index + 1)){


// Encode the value at this index. Call the function
// recursively as this could be any kind of data.
LOCAL.Value = ToJavascript( ARGUMENTS.Data[ LOCAL.Index ] );


// Check to see if we are appending to a current value.
if (LOCAL.Output.Length()){
LOCAL.Output.Append( "," );
}


// Append the encoded value.
LOCAL.Output.Append( LOCAL.Value );


}


// Return the encoded values in an array notation.
return( "[" & LOCAL.Output.ToString() & "]" );


// Check to see if we have a structure.
} else if (IsStruct( ARGUMENTS.Data )){


// Check to see if the structure is empty. If it is, then
// we don't have to do any more work, just return the
// empty object notation.
if (StructIsEmpty( ARGUMENTS.Data )){
return( "{}" );
}


// Get the array of keys in the structure.
LOCAL.Keys = StructKeyArray( ARGUMENTS.Data );


// Loop over the keys in the structure.
for (LOCAL.Index = 1 ; LOCAL.Index LTE ArrayLen( LOCAL.Keys ) ; LOCAL.Index = (LOCAL.Index + 1)){


// Encode the value at this index. Call the function
// recursively as this could be any kind of data.
LOCAL.Value = ToJavascript( ARGUMENTS.Data[ LOCAL.Keys[LOCAL.Index] ] );


// Check to see if we are appending to a current value.
if (LOCAL.Output.Length()){
LOCAL.Output.Append( "," );
}


// Append the encoded value.
LOCAL.Output.Append( """" & LCase( LOCAL.Keys[LOCAL.Index] ) & """:" & LOCAL.Value );


}


// Return the encoded values in an object notation.
return( "{" & LOCAL.Output.ToString() & "}" );


// Check to see if this is some sort of other object.
} else if (IsObject( ARGUMENTS.Data )){


// We found an object that is not a built in type...
// return an unknown type.
return( "unknown-obj" );


// Check to see if we have a simple, numeric value.
} else if (IsSimpleValue( ARGUMENTS.Data ) AND IsNumeric( ARGUMENTS.Data )){


// Return the number as a string.
return( ToString( ARGUMENTS.Data ) );


// Check to see if we have a simple value.
} else if (IsSimpleValue( ARGUMENTS.Data )){


// Return the value encoded for Javascript.
return( """" & JSStringFormat( ToString( ARGUMENTS.Data ) ) & """" );


// Check to see if we have a query.
} else if (IsQuery( ARGUMENTS.Data )){


// We are going to convert the query into an array or
// structures. This is going to be somewhat slower than
// going straight from the query to javascript, but I
// think it will make the query more usable.


// Start by getting an array of the columns.
LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );


// Create an array for the value.
LOCAL.TempData = ArrayNew( 1 );


// Loop over the rows in the query to create structures.
for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){


// Create a structure for the current row.
LOCAL.TempRow = StructNew();


// Loop over the columns to add values to the strucutre.
for (LOCAL.Column = 1 ; LOCAL.Column LTE ArrayLen( LOCAL.Columns ) ; LOCAL.Column = (LOCAL.Column + 1)){


// Add the column value to the structure.
LOCAL.TempRow[ LOCAL.Columns[ LOCAL.Column ] ] = ARGUMENTS.Data[ LOCAL.Columns[ LOCAL.Column ] ][ LOCAL.RowIndex ];


}


// Append the structure to the data array.
ArrayAppend( LOCAL.TempData, LOCAL.TempRow );


}


// ASSERT: At this point, we have converted the query
// into array of structs. Now encode it.


// No need to return with object notation since the JS
// encoding of the array will take care of that for us.
return( ToJavascript( LOCAL.TempData ) );


// Check for default case.
} else {


// If we got this far, then we found a type that we
// are not able to serialize.
return( "unknown" );


}


</cfscript>
</cffunction>
</cfcomponent>