<cfcomponent hint="Hierarchal tree creator">
<cfif IsDefined("arrayOfStructuresToQuery")><cfset dvar=1></cfif>
	<cfscript>
	/**
	* Converts an array of structures to a CF Query Object.
	* 6-19-02: Minor revision by Rob Brooks-Bilson (rbils@amkor.com)
	*
	* Update to handle empty array passed in. Mod by Nathan Dintenfass. Also no longer using list func.
	*
	* @param Array      The array of structures to be converted to a query object. Assumes each array element contains structure with same (Required)
	* @return Returns a query object.
	* @author David Crawford (rbils@amkor.comdcrawford@acteksoft.com)
	* @version 2, March 19, 2003
	*/
	function arrayOfStructuresToQuery(theArray){
		var colNames = "";
		var theQuery = queryNew("");
		var i=0;
		var j=0;
		//if there's nothing in the array, return the empty query
		if(NOT arrayLen(theArray))
			return theQuery;
		//get the column names into an array =    
		colNames = structKeyArray(theArray[1]);
		//build the query based on the colNames
		theQuery = queryNew(arrayToList(colNames));
		//add the right number of rows to the query
		queryAddRow(theQuery, arrayLen(theArray));
		//for each element in the array, loop through the columns, populating the query
		for(i=1; i LTE arrayLen(theArray); i=i+1){
			for(j=1; j LTE arrayLen(colNames); j=j+1){
				querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
			}
		}
		return theQuery;
	}
	</cfscript>
	<cfscript>
	function QueryJoin(query1,query2) {
		var tempQuery = QueryNew(query1.ColumnList);
		var i = 1;
		if (query1.ColumnList eq query2.ColumnList) {
			for (i=1; i lte query1.RecordCount; i=i+1) {
				QueryAddRow(tempQuery);
				for (j=1; j lte ListLen(query1.ColumnList); j=j+1) {
					QuerySetCell(tempQuery, ListGetAt(query1.ColumnList,j),  query1[ListGetAt(query1.ColumnList,j)][i]);
				}
			}
			for (i=1; i lte query2.RecordCount; i=i+1) {
				QueryAddRow(tempQuery);
				for (j=1; j lte ListLen(query2.ColumnList); j=j+1) {
					QuerySetCell(tempQuery, ListGetAt(query2.ColumnList,j),  query2[ListGetAt(query2.ColumnList,j)][i]);
				}
			}
		}
		return tempQuery;
	}
	</cfscript>
	<cffunction name="makeBranches">
		<cfargument name="theQuery" required="yes" hint="Query to create nest levels from. Requires column names: nestlevel (anything can be in this column), id, and parent (must be an id that matches id column)">
		<cfargument name="thisBranch" default="" hint="ID of the branch to use (will only return children from this specific branch, not the beginning of the branch). Default is to return all branches">
		<cfargument name="nestLevel" default="1" hint="The starting number for the nest level. Default: 1">
		
		<cfscript>
		var resultQuery = QueryNew(theQuery.ColumnList);
		var cols = theQuery.ColumnList;
		var i = 1;
		var j = 1;
		
		for (i=1; i lte theQuery.RecordCount; i=i+1) {
			if (theQuery.parent[i] eq thisBranch) {
				QueryAddRow(resultQuery);
				for (j=1; j lte ListLen(cols); j=j+1) {
					QuerySetCell(resultQuery, ListGetAt(cols,j),  theQuery[ListGetAt(cols,j)][i]);
				}
				QuerySetCell(resultQuery, "nestLevel",  nestLevel);
				
				resultQuery = QueryJoin(resultQuery,makeBranches(theQuery,theQuery.id[i],(nestLevel+1)));
			}
		}
		if ( thisBranch eq '' AND resultQuery.RecordCount eq 0 AND nestLevel eq 1) {
			resultQuery = makeBranches(theQuery,0);
		}
		return resultQuery;
		</cfscript>
		
	</cffunction>

</cfcomponent>