<cfcomponent hint="I handle reviews">

<cffunction name="getReview" access="public" returntype="query" hint="I get reviews made by users. Output fields: REVIEWID,REVIEW,STARS,AUTHORID,REVIEWCONTACTID, status">
	<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="reviewid" required="true" type="string" hint="id of the review">
	<cfargument name="maxRows" required="false" type="string" hint="Maximum Number of records to return, default return all records." default="-1">
	<cfquery name="getreview" datasource="#reviewdsn#" maxRows="#maxRows#">
		SELECT
			REVIEWID,
			REVIEW,
			STARS,
			AUTHORID,
			REVIEWOFCONTACTID,
			STATUS
		FROM REVIEW
		WHERE REVIEWID=<cfqueryparam value="#reviewid#">
	</cfquery>
	<cfreturn getreview>
</cffunction>

<cffunction name="getReviewsByStatus" access="public" returntype="query" hint="I get reviews by status passed to me. Output fields: REVIEWID,REVIEW,STARS,AUTHORID,REVIEWCONTACTID, status">
	<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="reviewid" required="true" type="string" hint="id of the review">
	<cfargument name="status" required="true" type="string" hint="status value">
	<cfargument name="maxRows" required="false" type="string" hint="Maximum Number of records to return, default return all records." default="-1">
	<cfquery name="getreview" datasource="#reviewdsn#" maxRows="#maxRows#">
		SELECT
			REVIEWID,
			REVIEW,
			STARS,
			AUTHORID,
			REVIEWOFCONTACTID,
			STATUS
		FROM REVIEW
		WHERE STATUS=<cfqueryparam value="#STATUS#">
	</cfquery>
	<cfreturn getreview>
</cffunction>

<cffunction name="getReviewbyNameid" access="public" returntype="query" hint="I get reviews of a specific contact based on the passed in CONTACTID. Output fields: REVIEWID,REVIEW,STARS,AUTHORID,REVIEWCONTACTID, status">
<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="nameid" required="true" type="string" hint="id of the contact for whom review is made">
	<cfargument name="maxRows" required="false" type="string" hint="Maximum Number of records to return, default return all records." default="-1">
	<cfargument name="showNoStar" required="false" type="string" hint="Show no Start reviews or not" default="no">
	<cfquery name="getreview" datasource="#reviewdsn#" maxRows="#maxRows#">
		SELECT
			REVIEWID,
			REVIEW,
			STARS,
			AUTHORID,
			REVIEWOFCONTACTID,
			NAME.FIRSTNAME,
			NAME.LASTNAME,
			NAME.USERNAME,
			REVIEW.STATUS
		FROM REVIEW, NAME
		WHERE REVIEWOFCONTACTID=<cfqueryparam value="#nameid#">
		AND REVIEW.STATUS<>'Deleted'
		<cfif showNoStar EQ "no">AND STARS <> '0'</cfif>
		AND NAME.NAMEID = REVIEW.AUTHORID
		ORDER BY REVIEWID DESC
	</cfquery>
	<cfreturn getreview>
</cffunction>

<cffunction name="editReview" access="public" hint="I edit reviews made by users">
	<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="reviewid" required="true" type="string" hint="ID of the Review">
	<cfargument name="stars" required="true" type="string" hint="The number of stars given by the users.">
	<cfargument name="authorid" required="true" type="string" hint="ID of person who is doing the review">
	<cfargument name="review" required="true" type="string" hint="The review made by user">
	<cfargument name="contactid" required="true" type="numeric" hint="ID of contact being reviewed">
	<cfargument name="status" required="false" type="string" hint="Status of the Review" default="Public">
	<cfquery name="editReview" datasource="#reviewdsn#">
		UPDATE REVIEW
		SET STARS = <cfqueryparam value="#stars#">,
			AUTHORID = <cfqueryparam value="#authorid#">, 
			REVIEW = <cfqueryparam value="#review#">,
			STATUS = <cfqueryparam value="#status#">,
			REVIEWOFCONTACTID = <cfqueryparam value="#contactid#">
		WHERE 
			REVIEWID = <cfqueryparam value="#reviewid#">
	</cfquery>
</cffunction>

<cffunction name="addReview" access="public" hint="I record reviews made by users">
	<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="contactid" required="true" type="string" hint="Id of a person or organization who is being reviewed">
	<cfargument name="stars" required="true" type="string" hint="The number of stars given by the users">
	<cfargument name="authorid" required="true" type="string" hint="Id of a person who is doing the review" >
	<cfargument name="review" required="false" type="string" default="" hint="The review made by other users">
	<cfargument name="status" required="false" type="string" default="Public" hint="the status of the review">
	<cfset var addreview=0>
	<cfset var setHasReviews=0>
	<cfset var get=0>
	<cf_textareaformat input="#arguments.review#" output="thisreview">
	<cfquery name="get" datasource="#arguments.reviewdsn#">
		SELECT REVIEWID 
		FROM REVIEW 
		WHERE AUTHORID=<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">
		AND REVIEWOFCONTACTID=<cfqueryparam value="#arguments.contactid#" cfsqltype="cf_sql_varchar">
		AND STATUS<>'Deleted'
	</cfquery>
	<cfif get.recordcount EQ 0>
		<cfquery name="addreview" datasource="#arguments.reviewdsn#">
			INSERT INTO REVIEW
			(
				REVIEW,
				STARS,
				AUTHORID,
				REVIEWOFCONTACTID,
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#thisreview#">,
				<cfqueryparam value="#arguments.stars#">,
				<cfqueryparam value="#arguments.authorid#">,
				<cfqueryparam value="#arguments.contactid#">,
				<cfqueryparam value="#arguments.status#">
			)
		</cfquery>
		<cfquery name="setHasReviews" datasource="#arguments.reviewdsn#">
			UPDATE NAME SET 
			HASREVIEWS=1 
			WHERE NAMEID=<cfqueryparam value="#arguments.contactid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	<cfelse>
		<cfquery name="addreview" datasource="#arguments.reviewdsn#">
			UPDATE REVIEW SET
			REVIEW=<cfqueryparam value="#thisreview#" cfsqltype="cf_sql_varchar">,
			STARS=<cfqueryparam value="#arguments.stars#" cfsqltype="cf_sql_varchar">,
			STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			WHERE REVIEWID=<cfqueryparam value="#get.reviewid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="deleteReview" access="public" returntype="void" hint="I delete Reviews">
	<cfargument name="reviewdsn" required="true" type="string" hint="datasource">
	<cfargument name="reviewid" required="true" type="string" hint="id of the review">
	<cfset var delete=0>
	<cfset var unsetHasReviews=0>
	<cfset var get=0>
	<cfset var getnameid=0>
	<cfquery name="getnameid" datasource="#arguments.reviewdsn#">
		SELECT REVIEWOFCONTACTID FROM REVIEW
		WHERE REVIEWID=<cfqueryparam value="#arguments.reviewid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset contactid=getnameid.REVIEWOFCONTACTID>
	<cfquery name="delete" datasource="#arguments.reviewdsn#">
		UPDATE REVIEW
		SET STATUS='Deleted'
		WHERE REVIEWID=<cfqueryparam value="#arguments.reviewid#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfquery name="get" datasource="#arguments.reviewdsn#">
		SELECT REVIEWID 
		FROM REVIEW 
		WHERE REVIEWOFCONTACTID=<cfqueryparam value="#contactid#" cfsqltype="cf_sql_varchar">
		AND STATUS<>'Deleted'
	</cfquery>
	<cfif get.recordcount EQ 0>
		<cfquery name="unsetHasReviews" datasource="#arguments.reviewdsn#">
			UPDATE NAME SET 
			HASREVIEWS=0 
			WHERE NAMEID=<cfqueryparam value="#contactid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>
</cffunction>
</cfcomponent>