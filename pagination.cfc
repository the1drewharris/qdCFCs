<cfcomponent hint="Functions dealing with pagination" displayName="pagination">
	<cffunction name="get" hint="I build dynamic pagination links">
		<cfargument name="prefixURL" default="" hint="prefix for URL">
		<cfargument name="perPage" default="25" hint="number of items per page">
		<cfargument name="totalRows" default="200" hint="number of rows for the record">
		<cfargument name="currentValue" default="0" hint="Current Value of the Query String variable">
		<cfargument name="rowLabel" default="items" hint="What to label to Row Count">
		<cfargument name="delimeter" default="|" hint="Delimeter used between row count and pagination">
		<cfargument name="urlVariable" default="items" hint="Sets whether the variable being passed in the URL should be the first item of the page or the page number itself. Defaults to first item (items). Values can be either items or pages">
		
		<cfset var baseURL = "#arguments.prefixURL#">
		
		<cfsavecontent variable="pagination">
			<cfoutput>
				<cfset numOfPages = Ceiling(#arguments.totalRows#/#arguments.perPage#)>
				<cfif numOfPages EQ 0><cfset numOfPages = 1></cfif>
				<cfset curPage = Int((#arguments.currentValue# / #arguments.perPage#) + 1)>
				<cfset page=1>
				#NumberFormat(arguments.totalRows)# #arguments.rowLabel# #arguments.delimeter# <a href="#baseURL##currentValue#">Page #curPage# of #numOfPages#</a> 
				<cfif numOfPages GT 1>
					#arguments.delimeter# 
					<cfif numOfPages LT 5>
						<cfloop from="0" to="#arguments.totalRows-1#" step="#arguments.perPage#" index="i">
							<cfif arguments.urlVariable EQ "pages">
								<cfset urlVar = page>
							<cfelse>
								<cfset urlVar = i>
							</cfif>
							<a class="topictitle <cfif curPage EQ page>active</cfif>" href="#baseURL##urlVar#">#page#</a>
							
							<cfset page=page+1>
						</cfloop>
					<cfelse>
						<cfset SecondToLastPage = numOfPages - 1>
			
							<cfset startLoop = 1>
							<cfset endLoop = numOfPages>
							<cfif curPage - 2 GT 0><cfset startLoop = curPage - 2></cfif>
							<cfif curPage + 2 LT numOfPages><cfset endLoop = curPage + 2></cfif>
							<cfif endLoop - startLoop LT 5>
								<cfif startLoop LTE 2>
									<cfset endLoop = startLoop + 4>
								<cfelseif endLoop GTE (numOfPages - 1)>
									<cfset startLoop = endLoop - 4>
								</cfif>
							</cfif>
							
							<cfif startLoop NEQ 1>
								<a class="topictitle" href="#baseURL#0">1</a>
								...
							</cfif>
							<cfloop from="#startLoop#" to="#endLoop#" index="page">
								<cfset i = (page - 1) * #arguments.perPage#>
								<a class="topictitle <cfif curPage EQ page>active</cfif>" href="#baseURL##i#">#page#</a>
							</cfloop>
							<cfif endLoop NEQ numOfPages>
								...
								<cfset lastPage = (numOfPages - 1) * #arguments.perPage#>
			
								<a class="topictitle" href="#baseURL##lastPage#">#numOfPages#</a>
							</cfif>
					</cfif>
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn pagination>
	</cffunction>
</cfcomponent>