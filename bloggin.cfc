<cfcomponent hint="New Blog CFC">
	<cfobject component="timeDateConversion" name="mytime">
	<cfobject component="textConversions-beta" name="objtextconversions">
	
	<cffunction name="getqdcode" access="public" returntype="string" hint="I return code for number">
		<cfargument name="number" type="string" required="true" default="I am the ">
		<cfif number GT 1000> <cfreturn -1></cfif>
		<cfset noofzs=number/36>
		<cfset reminder=number mod 36>
		<cfset code="">
		<cfloop from="1" to="#noofzs#" index="i">
			<cfset code="#code#z">
		</cfloop>
		<cfset code="#code##FormatBaseN(reminder,36)#">
		<cfreturn code>
	</cffunction>
	
	<cffunction name="setAuthor" access="public" returntype="void" hint="I set the author of the blog entry">
		<cfargument name="ds" required="true" type="string" hint="Name of the data source">
		<cfargument name="blogEntryid" required="true" type="string" hint="id of the blog entry">
		<cfargument name="newauthorid" required="true" type="string" hint="masternameid of the person">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE qdcmsBLOGENTRY SET 
			AUTHORID= <cfqueryparam value="#arguments.newauthorid#" cfsqltype="cf_sql_varchar">
			WHERE BLOGENTRYID=<cfqueryparam value="#arguments.blogEntryid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getBloggerName" access="public" returntype="query" hint="I get the name of the blogger">
		<cfargument name="authorid" required="true" type="string" hint="Name of the author">
		<cfset var get=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT NAMEID, FIRSTNAME, LASTNAME FROM NAME WHERE NAMEID=<cfqueryparam value="#arguments.authorid#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getBloggers" access="public" returntype="query" hint="I get bloggers and no of posts they have made">
		<cfargument name="ds" type="string" required="true" hint="data source">
		<cfset var getcount=0>
		<cfset var getnames=0>
		<cfset var bloggerids="0">
		<cfquery name="getcount" datasource="#arguments.ds#">
			SELECT 
				AUTHORID, 
				COUNT(BLOGENTRYID) AS NOOFENTRIES 
			FROM QDCMSBLOGENTRY 
			WHERE QDCMS.BLOGENTRY.ENTRYSTATUS='Published' 
			GROUP BY AUTHORID 
			ORDER BY NOOFENTRIES DESC
		</cfquery>
		<cfif getcount.recordcount EQ 0><cfreturn getcount></cfif>
		<cfset bloggerids=ValueList(getcount.authorid)>
		<cfquery name="getnames" datasource="deltasystem">
			SELECT 
				NAMEID, 
				FIRSTNAME, 
				LASTNAME 
			FROM NAME 
			WHERE NAMEID IN (#bloggerids#);
		</cfquery>
		
		<cfquery name="bloggers" Dbtype="query">
			SELECT NAMEID, FIRSTNAME, LASTNAME, NOOFENTRIES FROM getcount, getnames where getcount.authorid=getnames.nameid 
		</cfquery>
		<cfreturn bloggers>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="getBlogStatus" returntype="query" hint="I get the list of blog statuses, I return a recordset: blogstatus" access="public" output="false">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="=" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the status you are looking for">
		<cfset var getMyBlogStatuses=0>
		<cfquery name="getMyBlogStatuses" datasource="#arguments.ds#">
		SELECT 
			BLOGSTATUS
		FROM qdcmsBLOGSTATUS
		<cfif arguments.criteria neq 0>
		WHERE BLOGSTATUS 
			<cfif arguments.searchtype eq 'like'>
				LIKE <cfqueryparam value="%#arguments.criteria#%">
			<cfelse>
				= <cfqueryparam value="#arguments.criteria#">
			</cfif>
		</cfif>
		</cfquery>
		<cfreturn getMyBlogStatuses>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="addBlog" returntype="string" access="public" hint="I add the blog you pass to me, I return the id of the new blog">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="Name" type="string" required="true" hint="I am the name of the new Blog">
		<cfargument name="authorid" type="string" required="true" hint="I am the id of the author of this new blog">
		<cfargument name="Title" type="string" required="false" default="#arguments.Name#" hint="I am the title for the new Blog">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog">
		<cfargument name="status" type="string" required="false" default="Published" hint="I am the description for the new Blog">
		<cfset var addNewBlog=0>
		<cfset var urlname=objtextconversions.getUniqueUrlName(arguments.ds,'qdcmsblog','urlname',arguments.name)>
		<cfquery name="addNewBlog" datasource="#arguments.ds#">
			INSERT INTO qdcmsBLOG
			(
				NAME,
				TITLE,
				<cfif arguments.keywords neq 0>KEYWORDS,</cfif>
				<cfif arguments.description neq 0>DESCRIPTION,</cfif>
				CREATEDON,
				AUTHORID,
				STATUS,
				URLNAME
			)	
			VALUES
			(
				<cfqueryparam value="#arguments.Name#">,
				<cfqueryparam value="#arguments.Title#">,
				<cfif arguments.keywords neq 0><cfqueryparam value="#arguments.keywords#">,</cfif>
				<cfif arguments.description neq 0><cfqueryparam value="#arguments.description#">,</cfif>
				<cfqueryparam value="#mytime.createTimeDate()#">,
				<cfqueryparam value="#arguments.authorid#">,
				<cfqueryparam value="#arguments.status#">,
				<cfqueryparam value="#urlname#">
			)
			SELECT @@IDENTITY AS BLOGID
		</cfquery>
		<cfreturn addNewBlog.blogid>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="updateBlog" returntype="void" access="public" hint="I update the blog you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogid" type="string" required="true" hint="The ID for the blog you are updating">
		<cfargument name="authorid" type="string" required="true" hint="I am the id of the author of this new blog">
		<cfargument name="Name" type="string" required="false" default="0" hint="I am the name of the new Blog">
		<cfargument name="Title" type="string" required="false" default="0" hint="I am the title for the new Blog">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog">
		<cfargument name="status" type="string" required="false" default="0" hint="I am the description for the new Blog">
		<cfset var updateMyBlog=0>
		<cfset var urlname=objtextconversions.getUniqueUrlName(arguments.ds,'qdcmsblog','urlname',arguments.name,'blogid',arguments.blogid)>
		<cfquery name="updateMyBlog" datasource="#arguments.ds#">
		UPDATE qdcmsBLOG SET
		AUTHORID = <cfqueryparam value="#arguments.authorid#">,
		URLNAME = <cfqueryparam value="#urlname#">
		<cfif arguments.Name neq 0>, NAME = <cfqueryparam value="#arguments.Name#"></cfif>
		<cfif arguments.Title neq 0>, TITLE = <cfqueryparam value="#arguments.Title#"></cfif>
		<cfif arguments.keywords neq 0>, KEYWORDS = <cfqueryparam value="#arguments.keywords#"></cfif>
		<cfif arguments.description neq 0>, DESCRIPTION = <cfqueryparam value="#arguments.description#"></cfif>
		<cfif arguments.status neq 0>, STATUS = <cfqueryparam value="#arguments.status#"></cfif>
		WHERE BLOGID = <cfqueryparam value="#arguments.blogid#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="deleteBlog" returntype="struct" access="public" hint="I delete the blog you pass to me, I return a stucture stuct.delete will be 1 if deleted and 0 if not and stuct.deletemsg will have a message about whether or not I deleted your blog">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogid" type="string" required="true" hint="The ID for the blog you are deleting">
		<cfset var deleteMyBlog=0>
		<cfset var deleteThisBlog = StructNew()>
		<!--- first check to see if the blog has any entries --->
		<cfinvoke component="bloggin" method="getBlogEntries" blogid="#arguments.blogid#" argumentcollection="#arguments#" returnvariable="myBlogEntries">
		<!--- this blog has entries and can not be deleted --->
		<cfif myBlogEntries.recordcount gt 0>
			<cfset deleteThisBlog.deletemsg = "The Blog you are attempting to delete has entries and can not be deleted until all entries are removed.">
			<cfset deleteThisBlog.delete=0>
		<!--- there are no entries for this blog so it is safe to go ahead and delete it --->
		<cfelse>
			<cfquery name="deleteMyBlog" datasource="#arguments.ds#">
			DELETE FROM qdcmsBLOG
			WHERE BLOGID = <cfqueryparam value="#arguments.blogid#">
			</cfquery>
			<cfset deleteThisBlog.deletemsg = "Your Blog had no entries so it was deleted.">
			<cfset deleteThisBlog.delete=1>
		</cfif>
		<cfreturn deleteThisBlog>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="addBlogCategory" returntype="string" access="public" hint="I add the blog category you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="Name" type="string" required="true" hint="I am the name of the new Blog Category">
		<cfargument name="authorid" type="string" required="true" hint="I am the id of the author of this new blog Category">
		<cfargument name="Title" type="string" required="false" default="#arguments.Name#" hint="I am the title for the new Blog Category">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog Category">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog Category">
		<cfargument name="blogcategorystatus" type="string" required="false" default="Published" hint="I am the status of the category you want to create">
		<cfset var addNewBlogCategory=0>
		<cfquery name="addNewBlogCategory" datasource="#arguments.ds#">
		INSERT INTO qdcmsBLOGCATEGORY
			(NAME,
			TITLE,
			<cfif arguments.keywords neq 0>KEYWORDS,</cfif>
			<cfif arguments.description neq 0>DESCRIPTION,</cfif>
			CREATEDON,
			AUTHORID,
			BLOGCATEGORYSTATUS)	
		VALUES
			(<cfqueryparam value="#arguments.Name#">,
			<cfqueryparam value="#arguments.Title#">,
			<cfif arguments.keywords neq 0><cfqueryparam value="#arguments.keywords#">,</cfif>
			<cfif arguments.description neq 0><cfqueryparam value="#arguments.description#">,</cfif>
			<cfqueryparam value="#mytime.createTimeDate()#">,
			<cfqueryparam value="#arguments.authorid#">,
			<cfqueryparam value="#arguments.blogcategorystatus#">)
		SELECT @@IDENTITY AS CATEGORYID
		</cfquery>
		<cfreturn addNewBlogCategory.categoryid>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="updateBlogCategory" returntype="void" access="public" hint="I update the blog category you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogcategoryid" type="string" required="true" hint="I am the id of the blog category you want to update">
		<cfargument name="authorid" type="string" required="true" hint="I am the id of the author of this new blog Category">
		<cfargument name="name" type="string" required="false" default="0" hint="I am the name of the new Blog Category">
		<cfargument name="title" type="string" required="false" default="0" hint="I am the title for the new Blog Category">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog Category">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog Category">
		<cfargument name="blogcategorystatus" type="string" required="false" default="0" hint="I am the status of the category you want to create">
		<cfset var updateMyBlogCat=0>
		<cfquery name="updateMyBlogCat" datasource="#arguments.ds#">
		UPDATE qdcmsBLOGCATEGORY SET
		AUTHORID = <cfqueryparam value="#arguments.authorid#">
		<cfif arguments.Name neq 0>, NAME = <cfqueryparam value="#arguments.Name#"></cfif>
		<cfif arguments.Title neq 0>, TITLE = <cfqueryparam value="#arguments.Title#"></cfif>
		<cfif arguments.keywords neq 0>, KEYWORDS = <cfqueryparam value="#arguments.keywords#"></cfif>
		<cfif arguments.description neq 0>, DESCRIPTION = <cfqueryparam value="#arguments.description#"></cfif>
		<cfif arguments.blogcategorystatus neq 0>, BLOGCATEGORYSTATUS = <cfqueryparam value="#arguments.blogcategorystatus#"></cfif>
		WHERE BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="updateBlogCategoryStatus" returntype="void" access="public" hint="I update the status of the blog category you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogcategorystatus" type="string" required="true" hint="I am the status of the category you want to create">
		<cfargument name="blogCategoryid" type="string" required="true" hint="I am the id of the blog category you want to update">
		<cfset var updateMyBlogCat=0>
		<cfquery name="updateMyBlogCat" datasource="#arguments.ds#">
		UPDATE qdcmsBLOGCATEGORY SET
		BLOGCATEGORYSTATUS = <cfqueryparam value="#arguments.blogcategorystatus#">
		WHERE BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="deleteBlogCategory" returntype="void" access="public" hint="I delete the blog category you pass to me,  I return a stucture stuct.delete will be 1 if deleted and 0 if not and stuct.deletemsg will have a message about whether or not I deleted your blog category">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogCategoryid" type="string" required="true" hint="I am the id of the blog category you want to update">
		<cfset var deleteMyBlogCat=0>
		<cfset var deleteThisBlogCat = StructNew()>
		<!--- first check to see if the blog has any entries --->
		<cfinvoke component="bloggin" method="getBlogEntries" argumentcollection="#arguments#" returnvariable="myBlogEntries">
		<!--- this blog has entries and can not be deleted --->
		<cfif myBlogEntries.recordcount gt 0>
			<cfset deleteThisBlogCat.deletemsg = "The Blog Category you are attempting to delete has entries and can not be deleted until all entries are removed.">
			<cfset deleteThisBlogCat.delete=0>
		<!--- there are no entries for this blog so it is safe to go ahead and delete it --->
		<cfelse>
			<cfquery name="deleteMyBlogCat" datasource="#arguments.ds#">
			DELETE FROM qdcmsBLOGCATEGORY
			WHERE BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
			</cfquery>
			<cfset deleteThisBlogCat.deletemsg = "Your Blog Category had no entries so it was deleted.">
			<cfset deleteThisBlogCat.delete=1>
		</cfif>
		<cfreturn >
	</cffunction>
	
	<cffunction name="addBlogEntry" returntype="string" access="public" hint="I add the blog entry you pass to me, I return the id for this entry">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="name" type="string" required="true" hint="I am the name of the new Blog entry">
		<cfargument name="authorid" type="string" required="true" hint="I am the id of the author of this new blog entry">
		<cfargument name="entry" type="string" required="true" hint="I am the entry itself">
		<cfargument name="postdate" type="string" required="false" default="#mytime.createTimeDate()#" hint="I am the postdate for this entry and I should be in yyyymmddHHmmsstc format">
		<cfargument name="entryStatus" type="string" required="false" default="Draft" hint="I am the status of this blog entry, I default to Draft">
		<cfargument name="title" type="string" required="false" default="#arguments.title#" hint="I am the title for the new Blog entry">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog entry">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog entry">
		<cfargument name="lastupdatedby" type="string" required="true" hint="I am the person who updated the blog entry">
		<cfset var addNewBlogEntry=0>
		<cfset var urlname=objtextconversions.getUniqueUrlName(arguments.ds,'qdcmsBlogEntry','urlname',arguments.name)>
		<cfset timenow=mytime.createTimeDate()>
		<cfquery name="addNewBlogEntry" datasource="#arguments.ds#">
			INSERT INTO qdcmsBLOGENTRY
			(
				NAME,
				TITLE,
				ENTRY,
				POSTDATE,
				ENTRYSTATUS,
				<cfif arguments.keywords neq 0>KEYWORDS,</cfif>
				<cfif arguments.description neq 0>DESCRIPTION,</cfif>
				CREATEDON,
				AUTHORID,
				LASTUPDATEDBY,
				URLNAME
			)	
			VALUES
			(
				<cfqueryparam value="#arguments.Name#">,
				<cfqueryparam value="#arguments.Title#">,
				<cfqueryparam value="#arguments.entry#">,
				<cfqueryparam value="#arguments.postdate#">,
				<cfqueryparam value="#arguments.entryStatus#">,
				<cfif arguments.keywords neq 0><cfqueryparam value="#arguments.keywords#">,</cfif>
				<cfif arguments.description neq 0><cfqueryparam value="#description#">,</cfif>
				<cfqueryparam value="#timenow#">,
				<cfqueryparam value="#arguments.authorid#">,
				<cfqueryparam value="#arguments.lastupdatedby#">,
				<cfqueryparam value="#urlname#">
			)
			SELECT @@IDENTITY AS BLOGENTRYID
		</cfquery>
		<cfreturn addNewBlogEntry.BLOGENTRYID>
	</cffunction>
	
	<!--- done, not tested (added by Joseph) --->
	<cffunction name="updateBlogEntry" returntype="string" access="public" hint="I update the blog entry you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogentryid" type="string" required="true" hint="I am the id of the blog entry you want to update">
		<cfargument name="lastupdatedby" type="string" required="true" hint="I am the person who updated the blog entry">
		<cfargument name="name" type="string" required="false" default="0" hint="I am the name of the new Blog entry">
		<cfargument name="entry" type="string" required="false" default="0" hint="I am the entry content for the new Blog entry">
		<cfargument name="title" type="string" required="false" default="0" hint="I am the title for the new Blog entry">
		<cfargument name="keywords" type="string" required="false" default="0" hint="I am the keywords for the new Blog entry">
		<cfargument name="description" type="string" required="false" default="0" hint="I am the description for the new Blog entry">
		<cfargument name="entryStatus" type="string" required="false" default="0" hint="I am the status of the entry you want to create">
		<cfargument name="postdate" type="string" required="false" default="0" hint="I am the date when the blog entry should be posted">
		<cfset var updateMyBlogEntry=0>
		<cfset var urlname=objtextconversions.getUniqueUrlName(arguments.ds,'qdcmsblogentry','urlname',arguments.name,'blogentryid',arguments.blogentryid)>
		<cfquery name="updateMyBlogEntry" datasource="#arguments.ds#">
			UPDATE qdcmsBLOGENTRY SET
				LASTUPDATEDBY = <cfqueryparam value="#arguments.LASTUPDATEDBY#">,
				URLNAME = <cfqueryparam value="#urlname#">
				<cfif arguments.Name neq 0>, NAME = <cfqueryparam value="#arguments.Name#"></cfif>
				<cfif arguments.Entry neq 0>, ENTRY = <cfqueryparam value="#arguments.Entry#"></cfif>
				<cfif arguments.Title neq 0>, TITLE = <cfqueryparam value="#arguments.Title#"></cfif>
				<cfif arguments.keywords neq 0>, KEYWORDS = <cfqueryparam value="#arguments.keywords#"></cfif>
				<cfif arguments.description neq 0>, DESCRIPTION = <cfqueryparam value="#arguments.description#"></cfif>
				<cfif arguments.entrystatus neq 0>, ENTRYSTATUS = <cfqueryparam value="#arguments.entrystatus#"></cfif>
				<cfif arguments.postdate neq 0>, POSTDATE = <cfqueryparam value="#arguments.postdate#"></cfif>
			WHERE BLOGENTRYID = <cfqueryparam value="#arguments.blogentryid#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="updateBlogEntryStatus" returntype="void" access="public" hint="I update the blog entry status you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to update">
		<cfargument name="entryStatus" type="string" required="false" default="Draft" hint="I am the status of this blog entry, I default to Draft">
		<cfset var updateMyBlogEntryStatus=0>
		<cfquery name="updateMyBlogEntryStatus" datasource="#arguments.ds#">
		UPDATE qdcmsBLOGENTRY
		SET ENTRYSTATUS = <cfqueryparam value="#arguments.entryStatus#">
		WHERE BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="deleteBlogEntry" returntype="void" access="public" hint="I delete the blog entry you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to delete">
		<cfquery name="deleteEntry2Cat" datasource="#arguments.ds#">
		DELETE FROM qdcmsBLOGENTRYTOBLOGCAT
		WHERE BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		</cfquery>
		<cfquery name="deleteMyBlog" datasource="#arguments.ds#">
		DELETE FROM qdcmsBLOGENTRYTOBLOG
		WHERE BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		</cfquery>
		<cfquery name="deleteEntry2Blog" datasource="#arguments.ds#">
		DELETE FROM qdcmsBLOGENTRY
		WHERE BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="addBlogEntrytoBlog" returntype="void" access="public" hint="I add the blog you pass to me to the blog entry you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogid" type="string" required="true" hint="I am the id for the blog you want to add the entry to">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to delete">
		<cfset var insertMyBlogEntryfromBlog=0>
		<cfset var thisblogid=0>
		<!--- loop over the list of blogids in case there is more than one blogid being passed in --->
		<cfloop list="#arguments.blogid#" index="thisblogid">
			<!--- check to see if this blog entry is already in this blog --->
			<cfinvoke component="bloggin" method="getBlogEntries" ds="#arguments.ds#" blogentryid="#arguments.blogentryid#" blogid="#thisblogid#"  returnvariable="myBlogEntry">
			<cfif myBlogEntry.recordcount eq 0>
				<cfquery name="insertMyBlogEntryfromBlog" datasource="#arguments.ds#">
				INSERT INTO qdcmsBLOGENTRYTOBLOG
				(BLOGID,
				BLOGENTRYID,
				CREATEDON)
				VALUES
				(<cfqueryparam value="#thisblogid#">,
				<cfqueryparam value="#arguments.blogEntryId#">,
				<cfqueryparam value="#mytime.createTimeDate()#">)
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="removeBlogEntryfromBlog" returntype="void" access="public" hint="I remove the blog entry you pass to me from the blog you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to delete">
		<cfargument name="blogid" type="string" required="false" default="0" hint="I am the id for the blog you want to add the entry to">
		<cfset var removeMyBlogEntryfromBlog=0>
		<cfquery name="removeMyBlogEntryfromBlog" datasource="#arguments.ds#">
		DELETE FROM qdcmsBLOGENTRYTOBLOG
		WHERE 
		BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		<cfif arguments.blogId neq 0>
			AND BLOGID = <cfqueryparam value="#arguments.blogid#">
		</cfif>
		
		</cfquery>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="addBlogEntrytoBlogCategory" returntype="void" access="public" hint="I add the blog entry you pass to me to the blog category you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to add to this category">
		<cfargument name="blogcategoryid" type="string" required="true" hint="I am the id of the blog category add this entry to">
		<cfset var insertMyBlogEntrytoCat=0>
		<cfset var thisblogcatid=0>
		<!--- loop over the list of blogcategoryids in case there is more than one categoryid being passed in --->
		<cfloop list="#arguments.blogcategoryid#" index="thisblogcatid">
			<!--- check to see if this blog entry is already in this blog category --->
			<cfinvoke component="bloggin" method="getBlogEntries" ds="#arguments.ds#" blogentryid="#arguments.blogentryid#" blogcategoryid="#thisblogcatid#" returnvariable="myBlogEntry">
			<cfif myBlogEntry.recordcount eq 0>
				<cfquery name="insertMyBlogEntrytoCat" datasource="#arguments.ds#">
				INSERT INTO qdcmsBLOGENTRYTOBLOGCAT
				(BLOGCATEGORYID,
				BLOGENTRYID,
				CREATEDON)
				VALUES
				(<cfqueryparam value="#thisblogcatid#">,
				<cfqueryparam value="#arguments.blogEntryId#">,
				<cfqueryparam value="#mytime.createTimeDate()#">)
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- done, not tested --->
	<cffunction name="removeBlogEntryfromBlogCategory" returntype="void" access="public" hint="I remove the blog entry you pass to me from the blog category you pass to me">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="blogEntryId" type="string" required="true" hint="the id of the entry you want to remove for this category">
		<cfargument name="blogcategoryid" type="string" required="false" default="0" hint="I am the id of the blog category remove this entry from">
		<cfquery name="deleteMyBlog" datasource="#arguments.ds#">
		DELETE FROM qdcmsBLOGENTRYTOBLOGCAT
		WHERE 
		BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		<cfif arguments.blogcategoryid neq 0>
			AND BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfif>
		</cfquery>
	</cffunction>
	
	<cffunction name="getBlogEntryHeaders" access="public" returntype="query" hint="I return following fields:BLOGENTRYID,NAME,FIRSTNAME,LASTNAME,ENTRYSTATUS,LASTUPDATEDBY,CREATEDON">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="LIKE" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the word you are looking for">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog you wish to find entries for">
		<cfargument name="blogCategoryId" type="string" default="0" required="false" hint="I am the id of the blog category you want to get">
		<cfargument name="authorid" type="string" required="false" default="0" hint="the id of the author you want to get the blog entries for">
		<cfargument name="daterange" type="string" required="false" default="all" hint="I am the date range you want to get blogentries for, you need to pass me in like (yyyymmdd-yyyymmdd) you can leave off the dd on the end and just pass in a date like (yyyymm) and I will get all entries for that month">
		<cfargument name="noofentries" type="string" required="false" default="25" hint="No of blog entries required">				
		<cfargument name="startrow" type="string" required="false" default="1" hint="The startrow of the blog entries that you want">
		<cfargument name="orderby" type="string" required="false" default="BE.CREATEDON DESC"  hint="I am the way the recordset is sorted and I default to createdon-DESC ">
		<cfset var get=0>
		<cfset var startday=0>
		<cfset var endday=0>
		<cfset var upperlimit=startrow + noofentries-1>
		<cfif arguments.daterange NEQ "all">
			<cfset startday=listfirst(arguments.daterange,'-')>
			<cfset endday=listlast(arguments.daterange,'-')>
		</cfif>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT *
			FROM 
			(
				SELECT 
					BE.BLOGENTRYID,
					BE.NAME,
					BE.AUTHORID,
					BE.ENTRYSTATUS,
					BE.LASTUPDATEDBY,
					BE.CREATEDON,
					ROW_NUMBER() OVER (ORDER BY #arguments.orderby#) AS ROW
				FROM qdcmsBLOGENTRY BE
				WHERE BE.ENTRYSTATUS<><cfqueryparam value="Deleted" cfsqltype="cf_sql_varchar">
				<cfif arguments.criteria NEQ "0">
					AND 
					(
						BE.NAME #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
						BE.TITLE #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
						BE.KEYWORDS #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
						BE.DESCRIPTION #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%">
					)
				</cfif>
				<cfif arguments.blogid NEQ '0'>
					AND BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOG WHERE BLOGID=<cfqueryparam value="#arguments.blogid#" cfsqltype="cf_sql_varchar">)
				</cfif>
				<cfif arguments.blogcategoryid NEQ '0'>
					AND BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOGCAT WHERE BLOGCATEGORYID=<cfqueryparam value="#arguments.blogcategoryid#" cfsqltype="cf_sql_varchar">)
				</cfif>
				<cfif authorid NEQ 0>
					AND AUTHORID=<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.daterange NEQ 'all'>
					<cfif listLen('#arguments.daterange#','-') gt 1>
						AND BE.CREATEDON >= <cfqueryparam value="#startday#">
						AND BE.CREATEDON <= <cfqueryparam value="#endday#">
					<cfelse>
						AND BE.CREATEDON LIKE <cfqueryparam value="#arguments.daterange#%">
					</cfif>
				</cfif>
			) ENTRYHEADERS
			WHERE ROW BETWEEN <cfqueryparam value="#arguments.startrow#"> AND <cfqueryparam value="#upperlimit#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getBlogEntryCount" access="public" returntype="string" hint="I return no of entries meeting the search criteria">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="LIKE" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the word you are looking for">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog you wish to find entries for">
		<cfargument name="blogCategoryId" type="string" default="0" required="false" hint="I am the id of the blog category you want to get">
		<cfargument name="authorid" type="string" required="false" default="0" hint="the id of the author you want to get the blog entries for">
		<cfargument name="daterange" type="string" required="false" default="all" hint="I am the date range you want to get blogentries for, you need to pass me in like (yyyymmdd-yyyymmdd) you can leave off the dd on the end and just pass in a date like (yyyymm) and I will get all entries for that month">
		<cfargument name="entryStatus" type="string" required="false" default="0" hint="status of the entry">
		<cfset var get=0>
		<cfset var startday=0>
		<cfset var endday=0>
		<cfif arguments.daterange NEQ "all">
			<cfset startday=listfirst(arguments.daterange,'-')>
			<cfset endday=listlast(arguments.daterange,'-')>
		</cfif>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS RESULTCOUNT
			FROM qdcmsBLOGENTRY BE
			WHERE BE.ENTRYSTATUS<><cfqueryparam value="Deleted" cfsqltype="cf_sql_varchar">
			<cfif arguments.entrystatus NEQ '0'>
			AND BE.ENTRYSTATUS=<cfqueryparam value="#arguments.entrystatus#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.criteria NEQ "0">
				AND 
				(
					BE.NAME #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
					BE.TITLE #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
					BE.KEYWORDS #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
					BE.DESCRIPTION #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%">
				)
			</cfif>
			<cfif arguments.blogid NEQ '0'>
				AND BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOG WHERE BLOGID=<cfqueryparam value="#arguments.blogid#" cfsqltype="cf_sql_varchar">)
			</cfif>
			<cfif arguments.blogcategoryid NEQ '0'>
				AND BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOGCAT WHERE BLOGCATEGORYID=<cfqueryparam value="#arguments.blogcategoryid#" cfsqltype="cf_sql_varchar">)
			</cfif>
			<cfif authorid NEQ 0>
				AND AUTHORID=<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif arguments.daterange NEQ 'all'>
				<cfif listLen('#arguments.daterange#','-') gt 1>
					AND BE.POSTDATE >= <cfqueryparam value="#startday#">
					AND BE.POSTDATE <= <cfqueryparam value="#endday#">
				<cfelse>
					AND BE.POSTDATE LIKE <cfqueryparam value="#arguments.daterange#%">
				</cfif>
			</cfif>
		</cfquery>
		<cfreturn get.RESULTCOUNT>
	</cffunction>
	
	<cffunction name="getBlogEntries" returntype="query" access="public" hint="I get the blog entries you are looking for based on the data you pass me, I return a recordset:">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="LIKE" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the word you are looking for">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog you wish to find entries for">
		<cfargument name="blogCategoryId" type="string" default="0" required="false" hint="I am the id of the blog category you want to get">
		<cfargument name="blogEntryId" type="string" default="0" required="false" hint="the id of the entry you want to get">
		<cfargument name="entryStatus" type="string" required="false" default="0" hint="the status of the entries you are looking for">
		<cfargument name="authorid" type="string" required="false" default="0" hint="the id of the author you want to get the blog entries for">
		<cfargument name="orderby" type="string" required="false" default="BE.POSTDATE DESC"  hint="I am the way the recordset is sorted and I default to createdon-DESC ">
		<cfargument name="daterange" type="string" required="false" default="all" hint="I am the date range you want to get blogentries for, you need to pass me in like (yyyymmdd-yyyymmdd) you can leave off the dd on the end and just pass in a date like (yyyymm) and I will get all entries for that month">
		<cfargument name="noofentries" type="string" required="false" default="0" hint="No of blog entries required">
		<cfargument name="startrow" type="string" required="false" default="0" hint="The startrow of the blog entries that you want">
		<cfargument name="urlname" type="string" required="false" default="0" hint="I am the blog entry URLname">
		<cfset var getMyEntries=0>
		<cfset var startday=0>
		<cfset var endday=0>
		<cfoutput>
		<cfquery name="getMyEntries" datasource="#arguments.ds#" >
		SELECT
			<cfif arguments.noofentries NEQ "0">
			TOP #noofentries#
			</cfif>
			BE.BLOGENTRYID,
			BE.NAME,
			BE.ENTRY,
			BE.TITLE,
			BE.KEYWORDS,
			BE.DESCRIPTION,
			BE.ENTRYSTATUS,
			BE.POSTDATE,
			BE.CREATEDON,
			BE.AUTHORID,
			BE.LASTUPDATEDBY,
			BE.URLNAME,
			(SELECT COUNT(COMMENTID)
				FROM COMMENT
				<cfif arguments.blogcategoryid neq 0>
				, qdcmsBLOGENTRYTOBLOGCAT
				</cfif>
				<cfif arguments.blogid neq 0>
				, qdcmsBLOGENTRYTOBLOG
				</cfif>
				WHERE COMMENT.BLOGENTRYID = BE.BLOGENTRYID
				AND STATUS = 'Published'
				<cfif arguments.blogcategoryid neq 0>
				AND qdcmsBLOGENTRYTOBLOGCAT.BLOGENTRYID = COMMENT.BLOGENTRYID
				AND qdcmsBLOGENTRYTOBLOGCAT.BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
				</cfif>
				<cfif arguments.blogid neq 0>
				AND qdcmsBLOGENTRYTOBLOG.BLOGENTRYID = COMMENT.BLOGENTRYID
				AND qdcmsBLOGENTRYTOBLOG.BLOGID = <cfqueryparam value="#arguments.blogid#">
				</cfif>) AS commentCount
		FROM qdcmsBLOGENTRY BE
		<cfif arguments.blogid neq 0>, qdcmsBLOGENTRYTOBLOG</cfif>
		<cfif arguments.blogcategoryid neq 0>, qdcmsBLOGENTRYTOBLOGCAT</cfif>
		WHERE BE.ENTRYSTATUS <> 'Deleted'
		<cfif arguments.criteria neq 0>
			AND (BE.NAME #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
			BE.TITLE #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
			BE.KEYWORDS #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%"> OR
			BE.DESCRIPTION #arguments.searchtype# <cfqueryparam value="%#arguments.criteria#%">)
		</cfif>
		<cfif arguments.blogentryid neq 0>
		AND BE.BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryId#">
		</cfif>
		<cfif arguments.urlname neq 0>
		AND BE.URLNAME = <cfqueryparam value="#arguments.urlname#">
		</cfif>
		<cfif arguments.daterange neq 'all'>
			<cfif listLen('#arguments.daterange#','-') gt 1>
				<cfset startday = listfirst('#arguments.daterange#','-')>
				<cfset endday = listlast('#arguments.daterange#','-')>
				AND BE.POSTDATE >= <cfqueryparam value="#startday#">
				AND BE.POSTDATE <= <cfqueryparam value="#endday#">
			<cfelse>
				AND BE.POSTDATE LIKE <cfqueryparam value="#arguments.daterange#%">
			</cfif>
		</cfif>
		<cfif arguments.blogcategoryid neq 0>
		AND qdcmsBLOGENTRYTOBLOGCAT.BLOGENTRYID = BE.BLOGENTRYID
		AND qdcmsBLOGENTRYTOBLOGCAT.BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfif>
		<cfif arguments.blogid neq 0>
		AND qdcmsBLOGENTRYTOBLOG.BLOGENTRYID = BE.BLOGENTRYID
		AND qdcmsBLOGENTRYTOBLOG.BLOGID = <cfqueryparam value="#arguments.blogid#">
		</cfif>
		<cfif arguments.authorid neq 0>
		AND BE.AUTHORID = <cfqueryparam value="#arguments.authorid#">
		</cfif>
		<cfif arguments.entryStatus neq "0">
		AND BE.ENTRYSTATUS = <cfqueryparam value="#arguments.entryStatus#">
		<cfelse>
		AND BE.ENTRYSTATUS <>'Deactive'
		</cfif>
		<cfif arguments.entryStatus EQ "Published">
		AND BE.POSTDATE < <cfqueryparam value="#mytime.createtimedate()#">
		</cfif>
		ORDER BY #arguments.orderby#
		</cfquery>
		</cfoutput>
	<cfreturn getMyEntries>
	</cffunction> 
	
	<!--- done, not tested --->
	<cffunction name="getBlogs" returntype="query" access="public" hint="I get the blogs you are seaching for, and return a recordset:BLOGID, NAME, TITLE, KEYWORDS, DESCRIPTION, CREATEDON, AUTHORID, STATUS, ENTRYCOUNT">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="=" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the status you are looking for">
		<cfargument name="blogid" type="string" default="0" required="false" hint="I am the id of the blog you want to get">
		<cfargument name="blogname" type="string" default="0" required="false" hint="The name of the blog you are looking for">
		<cfargument name="authorid" type="string" default="0" required="false" hint="I am the id of the author you want to get blogs for">
		<cfargument name="status" type="string" default="0" required="false" hint="I am the status of the blogs you are looking for">
		<cfargument name="blogEntryid" type="string" default="0" required="false" hint="I am the id of the blogentry you want to get the list of categories for">
		<cfset var getMyBlogs=0>
		<cfquery name="getMyBlogs" datasource="#arguments.ds#">
		SELECT
			B.BLOGID,
			B.NAME,
			B.TITLE,
			B.KEYWORDS,
			B.DESCRIPTION,
			B.CREATEDON,
			B.AUTHORID,
			B.STATUS,
			B.URLNAME,
			(SELECT COUNT(qdcmsBLOGENTRYTOBLOG.BLOGENTRYID)
				FROM qdcmsBLOGENTRYTOBLOG, qdcmsBLOGENTRY
				WHERE B.BLOGID = qdcmsBLOGENTRYTOBLOG.BLOGID
				and qdcmsBLOGENTRYTOBLOG.BLOGENTRYID=qdcmsblogentry.blogentryid
				and qdcmsblogentry.entrystatus<>'Deleted') AS ENTRYCOUNT
		FROM qdcmsBLOG B
		<cfif arguments.blogEntryid neq 0>
		, qdcmsBLOGENTRYTOBLOG BE
		</cfif>
		WHERE 1=1
		<cfif arguments.criteria neq 0>
			AND (NAME #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			TITLE #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			KEYWORDS #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			DESCRIPTION #arguments.searchtype# <cfqueryparam value="#arguments.criteria#">)
		</cfif>
		<cfif arguments.blogid neq 0>
		AND B.BLOGID = <cfqueryparam value="#arguments.blogid#">
		</cfif>
		<cfif arguments.blogname neq 0>
		AND B.NAME = <cfqueryparam value="#arguments.blogname#">
		</cfif>
		<cfif arguments.authorid neq 0>
		AND B.AUTHORID = <cfqueryparam value="#arguments.authorid#">
		</cfif>
		<cfif arguments.status neq 0>
		AND B.STATUS = <cfqueryparam value="#arguments.status#">
		</cfif>
		<cfif arguments.blogEntryid neq 0>
		AND BE.BLOGID = B.BLOGID
		AND BE.BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryid#">
		</cfif>
		</cfquery>
	<cfreturn getMyBlogs>
	</cffunction>
	
	<cffunction name="getBlogNameList" access="public" returntype="query" hint="I return the list of blog names">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="withEntries" required="false" type="boolean" default="false">
		<cfargument name="status" required='false' type="string" default="Published">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT  BLOGID, URLNAME, NAME FROM qdcmsBLOG B
			WHERE B.STATUS=<cfqueryparam value='#arguments.status#'>
			<cfif withEntries>
			AND 
			(
					SELECT COUNT(qdcmsBLOGENTRYTOBLOG.BLOGENTRYID) 
					FROM qdcmsBLOGENTRYTOBLOG, qdcmsBLOGENTRY 
					WHERE B.BLOGID=qdcmsBLOGENTRYTOBLOG.BLOGID 
					AND qdcmsBLOGENTRYTOBLOG.BLOGENTRYID=qdcmsBLOGENTRY.BLOGENTRYID 
					AND qdcmsBLOGENTRY.ENTRYSTATUS=<cfqueryparam value='Published'>
			) > 0
			</cfif>
			ORDER BY BLOGID
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getBlogId" access="public" returntype="string" hint="I return the id of the blog">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="urlname" type="string" required="true" hint="I am the name of the blog">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT BLOGID FROM qdcmsBLOG
			WHERE URLNAME=<cfqueryparam value="#arguments.urlname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.blogid>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getBlogUrlname" access="public" returntype="string" hint="I return the urlname of the blog">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog">
		<cfargument name="blogentryid" type="string" required="false" default="0" hint="id of the blog entry">
		<cfset var get=0>
		<cfset var getblogid=0>
		<cfif arguments.blogid EQ 0>
			<cfif arguments.blogentryid NEQ 0>
				<cfquery name="getblogid" datasource="#arguments.ds#">
					SELECT TOP 1 BLOGID FROM qdcmsBLOGENTRYTOBLOG
					WHERE blogentryid=<cfqueryparam value="#arguments.blogentryid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getblogid.recordcount GT 0>
					<cfset arguments.blogid=getblogid.BLOGID>
				</cfif>
			</cfif>
		</cfif>
		<cfif arguments.blogid NEQ 0>
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT URLNAME FROM qdcmsBLOG 
				WHERE BLOGID=<cfqueryparam value="#arguments.blogid#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfreturn get.urlname>
		<cfelse>
			<cfreturn "-1">
		</cfif>
	</cffunction>
	
	<cffunction name="getBlogEntryUrlname" access="public" returntype="string" hint="I return the urlname of the blog">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="blogentryid" type="string" required="true" hint="the id of the blogentry">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT URLNAME FROM qdcmsBLOGENTRY 
			WHERE BLOGENTRYID=<cfqueryparam value="#arguments.blogentryid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.urlname>
	</cffunction>
	
	<cffunction name="getBlogCategoryid" access="public" returntype="string" hint="I return blog categoryid of the blog">
		<cfargument name="ds" type="string" required="true" hint="I am the data source">
		<cfargument name="name" type="string" required="true" hint="I am the name of the blog category">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT BLOGCATEGORYID FROM qdcmsBLOGCATEGORY 
			WHERE NAME=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.BLOGCATEGORYID>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getblogentryid" access="public" returntype="string" hint="I return blog entryid">
		<cfargument name="ds" required="true" type="string" default="I am the data source">
		<cfargument name="urlname" required="true" type="string" default="name of the blogentry">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT BLOGENTRYID FROM qdcmsBLOGENTRY
			WHERE URLNAME=<cfqueryparam value="#arguments.urlname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.BLOGENTRYID>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getBlogCategories" returntype="query" access="public" hint="I get the blog categories you are looking for based on the data you pass to me, I return a recordset: BLOGCATEGORYID, NAME, TITLE, KEYWORDS, DESCRIPTION, CREATEDON, AUTHORID, BLOGCATEGORYSTATUS, ENTRYCOUNT ">
		<cfargument name="ds" type="string" required="true" hint="I am the datasource">
		<cfargument name="searchtype" type="string" required="false" default="=" hint="pass in the word 'like' if you want a fuzzy search">
		<cfargument name="criteria" type="string" required="false" default="0" hint="pass in the status you are looking for">
		<cfargument name="categoryname" type="string" required="false" default="0" hint="the name of the category you are looking for">
		<cfargument name="blogCategoryId" type="string" default="0" required="false" hint="I am the id of the blog category you want to get">
		<cfargument name="authorid" type="string" default="0" required="false" hint="I am the id of the author you want to get categories for">
		<cfargument name="blogcategorystatus" type="string" default="0" required="false" hint="I am the status of the categories you are looking for">
		<cfargument name="blogentrystatus" type="string" default="0" required="false" hint="I am the status of the entry that should be included in count">
		<cfargument name="blogEntryid" type="string" default="0" required="false" hint="I am the id of the blogentry you want to get the list of categories for">
		<cfargument name="donotincludelist" type="string" default="istandfornone" required="false" hint="I am the list of categories that should not be included">
		<cfset var getMyBlogCats=0>
		<cfquery name="getMyBlogCats" datasource="#arguments.ds#">
		SELECT
			C.BLOGCATEGORYID,
			C.NAME,
			C.TITLE,
			C.KEYWORDS,
			C.DESCRIPTION,
			C.CREATEDON,
			C.AUTHORID,
			C.BLOGCATEGORYSTATUS,
			(SELECT COUNT(qdcmsBLOGENTRYTOBLOGCAT.BLOGENTRYID)
				FROM qdcmsBLOGENTRYTOBLOGCAT, qdcmsBLOGENTRY
				WHERE C.BLOGCATEGORYID = BLOGCATEGORYID
				AND qdcmsBLOGENTRYTOBLOGCAT.BLOGENTRYID=qdcmsBLOGENTRY.BLOGENTRYID
				<cfif blogentrystatus NEQ 0>
				AND qdcmsBLOGENTRY.ENTRYSTATUS=<cfqueryparam value="#arguments.blogentrystatus#">
				<cfelse>
				AND qdcmsBLOGENTRY.ENTRYSTATUS<>'Deleted'
				</cfif>
				) AS ENTRYCOUNT
		FROM qdcmsBLOGCATEGORY C
		<cfif arguments.blogEntryid neq 0>
		, qdcmsBLOGENTRYTOBLOGCAT
		</cfif>
		WHERE C.NAME NOT IN (<cfqueryparam value="#arguments.donotincludelist#">)
		<cfif arguments.criteria neq 0>
			AND (C.NAME #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			C.TITLE #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			C.KEYWORDS #arguments.searchtype# <cfqueryparam value="#arguments.criteria#"> OR
			C.DESCRIPTION #arguments.searchtype# <cfqueryparam value="#arguments.criteria#">)
		</cfif>
		<cfif arguments.blogCategoryId neq 0>
		AND C.BLOGCATEGORYID = <cfqueryparam value="#arguments.blogCategoryId#">
		</cfif>
		<cfif arguments.authorid neq 0>
		AND C.AUTHORID = <cfqueryparam value="#arguments.authorid#">
		</cfif>
		<cfif arguments.blogcategorystatus neq 0>
		AND C.BLOGCATEGORYSTATUS = <cfqueryparam value="#arguments.blogcategorystatus#">
		</cfif>
		<cfif arguments.categoryname neq 0>
		AND C.NAME = <cfqueryparam value="#arguments.categoryname#">
		</cfif>
		<cfif arguments.blogEntryid neq 0>
		AND qdcmsBLOGENTRYTOBLOGCAT.BLOGCATEGORYID = C.BLOGCATEGORYID
		AND qdcmsBLOGENTRYTOBLOGCAT.BLOGENTRYID = <cfqueryparam value="#arguments.blogEntryid#">
		</cfif>
		</cfquery>
	<cfreturn getMyBlogCats>
	</cffunction>
	
	<cffunction name="getMonthCounts" access="public" returntype="query" hint="I get the blog entry counts for each month for the date range passed to me.">
		<cfargument name="ds" type="string" required="true" hint="database">
		<cfargument name="startrange" type="string" required="false" default="0" hint="the start range needs to be in yyyymmdd format">
		<cfargument name="endrange" type="string" required="false" default="0" hint="the end range needs to be in yyyymmdd format">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog you wish to find entries for">
		<cfargument name="blogcategoryid" type="string" required="false" default="0" hint="I am the id of the blog category you want to get">
		<cfset var monthcount=0>
		<cfquery name="monthcount" datasource="#ds#">
		SELECT
			SUBSTRING(BE.POSTDATE, 1,6) POSTMONTH,	
			COUNT(*) AS monthcount
		FROM         
			qdcmsBLOGENTRY BE
			<cfif arguments.blogcategoryid NEQ 0>
			, qdcmsBLOGENTRYTOBLOGCAT C
			</cfif>
		WHERE 
		BE.ENTRYSTATUS = 'Published'
		<cfif arguments.startrange NEQ 0 AND arguments.endrange NEQ 0>
		AND BE.POSTDATE BETWEEN '#startrange#%' AND '#endrange#%'
		AND BE.POSTDATE < <cfqueryparam value="#mytime.createtimedate()#">
		</cfif>
		<cfif arguments.blogid neq 0>
		AND BE.BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOG WHERE BLOGID=<cfqueryparam value="#arguments.blogid#">)
		</cfif>
		<cfif arguments.blogcategoryid neq 0>
		AND C.BLOGENTRYID = BE.BLOGENTRYID
		AND C.BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfif>
		GROUP BY 
		SUBSTRING(BE.POSTDATE, 1,6)
		ORDER BY SUBSTRING(BE.POSTDATE, 1,6) DESC
		</cfquery>
		<cfreturn monthcount>
	</cffunction>
	
	<cffunction name="getYearCounts" access="public" returntype="query" hint="I get the blog entry counts for each month for the date range passed to me.">
		<cfargument name="ds" type="string" required="true" hint="database">
		<cfargument name="startrange" type="string" required="false" default="0" hint="the start range needs to be in yyyymmdd format">
		<cfargument name="endrange" type="string" required="false" default="0" hint="the end range needs to be in yyyymmdd format">
		<cfargument name="blogid" type="string" required="false" default="0" hint="the id of the blog you wish to find entries for">
		<cfargument name="blogcategoryid" type="string" required="false" default="0" hint="I am the id of the blog category you want to get">
		<cfset var yearcount=0>
		<cfquery name="yearcount" datasource="#ds#">
		SELECT
			SUBSTRING(BE.POSTDATE, 1,4) POSTYEAR,	
			COUNT(*) AS yearcount
		FROM         
			qdcmsBLOGENTRY BE
			<cfif arguments.blogcategoryid NEQ 0>
			, qdcmsBLOGENTRYTOBLOGCAT C
			</cfif>
		WHERE 
		BE.ENTRYSTATUS = <cfqueryparam value="Published">
		<cfif arguments.startrange NEQ 0 AND arguments.endrange NEQ 0>
		AND BE.POSTDATE BETWEEN '#startrange#%' AND '#endrange#%'
		AND BE.POSTDATE < <cfqueryparam value="#mytime.createtimedate()#">
		</cfif>
		<cfif arguments.blogid neq 0>
		AND BE.BLOGENTRYID IN (SELECT BLOGENTRYID FROM qdcmsBLOGENTRYTOBLOG WHERE BLOGID=<cfqueryparam value="#arguments.blogid#">)
		</cfif>
		<cfif arguments.blogcategoryid neq 0>
		AND C.BLOGENTRYID = BE.BLOGENTRYID
		AND C.BLOGCATEGORYID = <cfqueryparam value="#arguments.blogcategoryid#">
		</cfif>
		GROUP BY 
		SUBSTRING(BE.POSTDATE, 1,4)
		ORDER BY SUBSTRING(BE.POSTDATE, 1,4) DESC
		</cfquery>
		<cfreturn yearcount>
	</cffunction>
	
	<cffunction name="createRSS" access="public" returntype="string" hint="I publish the RSS feed to the site">
		<cfargument name="domain" type="string" required="true" hint="domain to write this rss feed to">
		<cfargument name="ds" type="string" required="false" default="#arguments.domain#" hint="the datasource to get the blog entries from, I default to the domain you pass to me">
		<cfargument name="basepath" required="false" default="/home/drew/domains" hint="I am the base path to the domains folder on the server">
		<cfset var hasSubdomain=FALSE>
		<cfset var gettheblog=0>
		<cfinvoke method="getBlogEntries" ds="#arguments.ds#" noofentries="20" entryStatus="Published" returnvariable="myRSSfeed">
		<cfinvoke component="site" method="getSiteInfo" siteurl="#arguments.domain#" returnvariable="mySiteData">
		<cfobject component="addressbook" name="objAB">
		
		<cfif listlen(arguments.domain,'.') LT 3>
			<cfset partialpath = "#arguments.domain#/public_html">
		<cfelse>
			<cfset hasSubdomain=TRUE>
			<cfset partialpath="#listgetAt(arguments.domain,2,'.')#.#listgetAt(arguments.domain,3,'.')#/public_html/#listfirst(arguments.domain,'.')#">
		</cfif>
		
		<cfsavecontent variable="rssfeed"><?xml version="1.0" encoding="utf-8"?>
			<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
			  <channel>
			    <cfoutput><title>#xmlformat(mySiteData.sitetitle)# Blog</title>
			    <link>http://#arguments.domain#/</link>
			    <description>#xmlformat(mySiteData.SITEDESCRIPTION)#</description>
			    <language>en-us</language></cfoutput>
			    <cfoutput query="myRSSfeed">   
				<cfinvoke component="#objAb#" method="searchContacts" contactdsn="deltasystem" userid="#authorid#" returnvariable="Author">				
				  <item>
			      	<title><cfif Trim(title) NEQ "">#title#<cfelse>#name#</cfif></title>
			      	<cfif comparenocase(arguments.domain,"quantumdelta.com") EQ 0>
						<link>http://#arguments.domain#/blog/index.cfm?entryID=#blogEntryid#</link>
					<cfelseif hasSubdomain OR arguments.domain EQ "918moms.com" OR arguments.domain EQ "405moms.com">
						<cfquery name="gettheblog" datasource="#arguments.domain#">
							SELECT URLNAME FROM qdcmsBLOG WHERE BLOGID=(SELECT TOP 1 BLOGID FROM qdcmsBLOGENTRYTOBLOG WHERE BLOGENTRYID=<cfqueryparam value="#blogentryid#">)
						</cfquery>
						<link>http://#arguments.domain#/blogs/#gettheblog.urlname#/entry/#myRSSfeed.urlname#</link>
					<cfelse>
			      	<link>http://#arguments.domain#/blog/entry/#blogentryid#</link>
			      	</cfif>
			      	<description>#xmlformat(description)#</description>
			      	<dc:creator>#Author.firstname# #Author.lastname#</dc:creator>
			      	<dc:date>#Left(POSTDATE,4)#-#Mid(POSTDATE,5,2)#-#Mid(POSTDATE,7,2)#</dc:date>    
			      </item>
				</cfoutput>
			  </channel>
			</rss>
		</cfsavecontent>
		<cfoutput>
			<cfif listlen(arguments.domain,'.') EQ 3>
				<cfset parentsite="#listgetAt(arguments.domain,2,'.')#.#listgetAt(arguments.domain,3,'.')#">
				<cfset sitefolder=listfirst(arguments.domain,'.')>
				<cfset fullpath="#arguments.basepath#/#parentsite#/public_html/#sitefolder#/xml/blog.rss">
			<cfelse>
				<cfset fullpath="#arguments.basepath#/#arguments.domain#/public_html/xml/blog.rss">
			</cfif>
			<cffile action="write" mode="775" addnewline="no" file="#fullpath#" output="#rssfeed#">
		</cfoutput>
	</cffunction>
	
	<cffunction name="createRSSForBlogs" access="public" returntype="void" hint="I publish the RSS feed to the site">
		<cfargument name="domain" type="string" required="true" hint="domain to write this rss feed to">
		<cfset var getblogs=0>
		<cfobject component="addressbook" name="objAB">
		<cfset basepath="/home/drew/domains/">
		<cfquery name="getblogs" datasource="#arguments.domain#">
			SELECT BLOGID, URLNAME, NAME FROM qdcmsBLOG WHERE STATUS='Published'
		</cfquery>
		<cfloop query="getblogs">
			<cfinvoke method="getBlogEntries" ds="#arguments.domain#" noofentries="20" blogid="#getblogs.blogid#" entryStatus="Published" returnvariable="myRSSfeed">
			<cfif myRSSfeed.recordcount GT 0>
				<cfinvoke component="site" method="getSiteInfo" siteurl="#arguments.domain#" returnvariable="mySiteData">
				
				<cfsavecontent variable="rssfeed"><?xml version="1.0" encoding="utf-8"?>
					<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
					  <channel>
					    <cfoutput>
						    <title>#domain# #getblogs.NAME#</title>
						    <link>http://#arguments.domain#/</link>
						    <description>#Xmlformat(mySiteData.SITEDESCRIPTION)#</description>
						    <language>en-us</language>
						</cfoutput>
						<cfoutput query="myRSSfeed">
							<cfinvoke component="#objAB#" method="searchContacts" contactdsn="deltasystem" userid="#authorid#" returnvariable="Author">				
							<item>
						      	<title><cfif Trim(title) NEQ "">#Xmlformat(title)#<cfelse>#Xmlformat(name)#</cfif></title>
						      	<cfif comparenocase(arguments.domain,"quantumdelta.com") EQ 0>
									<link>http://#arguments.domain#/blog/index.cfm?entryID=#blogEntryid#</link>
								<cfelseif arguments.domain EQ "918moms.com" OR arguments.domain EQ "405moms.com">
									<link>http://#arguments.domain#/blogs/#getblogs.urlname#/entry/#myRSSfeed.urlname#</link>
								<cfelse>
						      		<link>http://#arguments.domain#/blog/entry/#blogentryid#</link>
						      	</cfif>
						      	<description>#xmlformat(description)#</description>
						      	<dc:creator>#Xmlformat(Author.firstname)# #Xmlformat(Author.lastname)#</dc:creator>
						      	<dc:date>#Left(POSTDATE,4)#-#Mid(POSTDATE,5,2)#-#Mid(POSTDATE,7,2)#</dc:date>    
						    </item>
						</cfoutput>
					  </channel>
					</rss>
				</cfsavecontent>
				<cfoutput>
					<cfif listlen(arguments.domain,'.') EQ 3>
						<cfset parentsite="#listgetAt(arguments.domain,2,'.')#.#listgetAt(arguments.domain,3,'.')#">
						<cfset sitefolder=listfirst(arguments.domain,'.')>
						<cfset fullpath="#basepath##parentsite#/public_html/#sitefolder#/xml/#getblogs.blogid#.rss">
					<cfelse>
						<cfset fullpath="#basepath##arguments.domain#/public_html/xml/#getblogs.blogid#.rss">
					</cfif>
					<cffile action="write" mode="775" addnewline="no" file="#fullpath#" output="#rssfeed#">
				</cfoutput>
			</cfif>
		</cfloop>
	</cffunction>
	
	<!---  done, not tested --->
	<cffunction name="getComments" access="public" returnType="query" hint="I get comments for a particular blog entry: I return a recordset: COMMENTID, COMMENTNAME, CREATEDBYID, BLOGENTRYID, COMMENT, STATUS">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="status" type="string" required="false" default="published">	
		<cfargument name="blogentrylist" type="string" required="false" default="0">
		<cfargument name="blogcomment" type="string" required="false" default="0">	
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT 
			COMMENTID,
			COMMENT,
			STATUS,
			BLOGENTRYID,
			BLOGENTRYCOMMENTYOURNAME,
			BLOGENTRYCOMMENTEMAIL,
			CREATEDON
			FROM COMMENT
			WHERE STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			<cfif arguments.blogcomment NEQ "0">
			AND BLOGENTRYID IS NOT NULL
			</cfif>
			<cfif arguments.blogentrylist NEQ "0">
			AND BLOGENTRYID IN (<cfqueryparam value="#arguments.blogentrylist#" cfsqltype="cf_sql_varchar">)
			</cfif>
			ORDER BY COMMENTID DESC
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	
	<cffunction name="getBlogComments" access="public" returnType="query" hint="I get comments for a particular blog entry: I return a recordset: COMMENTID, COMMENTNAME, CREATEDBYID, BLOGENTRYID, COMMENT, STATUS">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="status" type="string" required="false" default="published">	
		<cfargument name="blogentrylist" type="string" required="false" default="0">
		<cfargument name="blogcomment" type="string" required="false" default="0">	
		<cfargument name="noofcomments" type="string" required="false" default="10">
		<cfargument name="currentcount" type="string" required="false" default="1">
		<cfset var get=0>
		<cfset start=currentcount>
		<cfset end=currentcount+noofcomments-1>
		<cfquery name="get" datasource="#arguments.ds#">
		SELECT * FROM (
			SELECT 
				COMMENTID,
				COMMENT,
				STATUS,
				BLOGENTRYID,
				BLOGENTRYCOMMENTYOURNAME,
				BLOGENTRYCOMMENTEMAIL,
				CREATEDON,
				ROW_NUMBER() OVER (ORDER BY COMMENTID) AS ROW
			FROM COMMENT
			WHERE STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			<cfif arguments.blogcomment NEQ "0">
			AND BLOGENTRYID IS NOT NULL
			</cfif>
			<cfif arguments.blogentrylist NEQ "0">
			AND BLOGENTRYID IN (<cfqueryparam value="#arguments.blogentrylist#" cfsqltype="cf_sql_varchar">)
			</cfif>
			) BC WHERE ROW BETWEEN <cfqueryparam value="#start#"> AND <cfqueryparam value="#end#">
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getBlogCommentsCount" access="public" returnType="string" hint="I get comments for a particular blog entry: I return a recordset: COMMENTID, COMMENTNAME, CREATEDBYID, BLOGENTRYID, COMMENT, STATUS">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="status" type="string" required="false" default="published">	
		<cfargument name="blogentrylist" type="string" required="false" default="0">
		<cfargument name="blogcomment" type="string" required="false" default="0">	
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS COMMENTCOUNT FROM COMMENT
			WHERE STATUS=<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			<cfif arguments.blogcomment NEQ "0">
			AND BLOGENTRYID IS NOT NULL
			</cfif>
			<cfif arguments.blogentrylist NEQ "0">
			AND BLOGENTRYID IN (<cfqueryparam value="#arguments.blogentrylist#" cfsqltype="cf_sql_varchar">)
			</cfif>
		</cfquery>
		<cfreturn get.COMMENTCOUNT>
	</cffunction>
	
	<cffunction name="getBlogentryList" access="public" returntype="string" hint="I get the list of blog entries for a user">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="authorid" type="string" required="true" hint="id of the author">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT BLOGENTRYID FROM qdcmsBLOGENTRY
			WHERE AUTHORID=<cfqueryparam value="#arguments.authorid#" cfsqltype="cf_sql_varchar">
			AND ENTRYSTATUS=<cfqueryparam value="Published" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset entrylist=ValueList(get.BLOGENTRYID)>
		<cfreturn entrylist>		
	</cffunction>
	
	<cffunction name="getBlogentryName" access="public" returntype="string" hint="I get the list of blog entries for a user">
		<cfargument name="ds" type="string" required="true" hint="Datasource">
		<cfargument name="blogentryid" type="string" required="true" hint="id of the author">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT NAME FROM qdcmsBLOGENTRY
			WHERE BLOGENTRYID=<cfqueryparam value="#arguments.blogentryid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get.name>		
	</cffunction>
	
	<cffunction name="getPendingCommentsCount" access="public" returntype="string" hint="I get number of pending comments">
		<cfargument name="ds" type="string" required="true" hint="Datasource">	
		<cfargument name="blogentrylist" type="string" required="true" hint="list of blog entries">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.ds#">
			SELECT COUNT(*) AS COMMENTCOUNT FROM COMMENT
			WHERE STATUS=<cfqueryparam value="Private" cfsqltype="cf_sql_varchar">
			<cfif blogentrylist NEQ 0>
			AND BLOGENTRYID IN (<cfqueryparam value="#arguments.blogentrylist#" cfsqltype="cf_sql_varchar">)
			</cfif>
		</cfquery>
		<cfreturn get.commentcount>
	</cffunction>
	
</cfcomponent>