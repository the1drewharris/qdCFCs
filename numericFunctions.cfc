<cfcomponent hint="I have numeric functions">
<cffunction name="getFirstMissingNumber" access="public" returntype="string" hint="I return the first missing number from the list.">
	<cfargument name="numberlist" type="string" required="true" hint="sorted list of numbers">
	<cfargument name="startNumber" type="string" required="true" hint="I am the the least value of the number that should be returned">

	<cfset size=listlen(numberlist)>
	<cfset maxvalue=listlast(numberlist)>
	<cfset startindex=listfindNoCase(numberlist,startNumber)>
	<cfif maxvalue LT startNumber>
		<cfreturn startNumber>
	<cfelseif startindex EQ 0>
		<cfreturn startNumber>
	<cfelseif size GT 0>
		<cfset oldNum=startNumber>
		<cfset beginindex=startindex+1>
		<cfloop from="#beginindex#" to="#size#" index="i">
			<cfset result=listgetAt(numberlist,i)>
			<cfif (result-oldnum) GT 1>
				<cfset searchNum=oldnum+1>
				<cfreturn searchNum>
			<cfelse>
				<cfset oldNum=result>
			</cfif>
		</cfloop>
		<cfset searchNum=maxvalue+1>
	</cfif>
	<cfreturn searchNum>
</cffunction>

</cfcomponent>