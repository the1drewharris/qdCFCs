<cfcomponent hint="Money Saving Queen RSS Feed Formatter">

	<cffunction name="readRSS">
		<cfargument name="feed" type="string" required="true" hint="The RSS feed">
		<cfset var msqXml=0>
		<cfset var newsXML=0>
		<cfset var newsItems=0>
		<cfset var newsPureTitle=0>
		<cfset var newsTitle=0>
		<cfset var myNewsFeed=0>
		<cfset var loopLen=0>
		<cfoutput>
		<cfset myFeed=XmlParse("#arguments.feed#")>
		<cfset newsXML=xmlsearch(myFeed, "/rss/channel")>
		<cfset newsItems=xmlsearch(myFeed, "/rss/channel/item")>
		<cfset newsPureTitle="#newsXML[1].title.XmlText#">
		<cfset newsTitle=ListLast('#newsPureTitle#',"-")>
		
		<cfif ArrayLen(newsItems) lt 10>
			<cfset loopLen=ArrayLen(newsItems)>
		<cfelse>
			<cfset loopLen=10>
		</cfif>
		
		<cfsavecontent variable="myNewsFeed">
		<cfset feedid=listLast(arguments.feed, "=")>
		<cfif arguments.feed eq "http://kotv.com/api/getFeed.aspx?id=43">
			<h2>Deals of the Day</h2>
		<cfelse>
			<h2>#newsTitle#</h2>
		</cfif>
		<ul>
		<cfloop index="i" from="1" to="#loopLen#">
			<cfset thisArticleTitle=listLast(newsItems[i].link.XmlText, "/")>
			<li><a href="/pages/msq/#feedid#/#thisArticleTitle#">#newsItems[i].title.XmlText#</a><!-- /#feedid#/#thisArticleTitle# --></li>
		</cfloop>
		</ul>
		</cfsavecontent>
		</cfoutput>
		<cfreturn myNewsFeed>
	</cffunction>
	
	<cffunction name="readRSSContent">
		<cfargument name="feed" type="string" required="true" hint="The RSS feed">
		<cfargument name="title" type="string" required="true" hint="The Article Title">
		<cfset var msqXml=0>
		<cfset var newsXML=0>
		<cfset var newsItems=0>
		<cfset var newsPureTitle=0>
		<cfset var newsContent=0>
		<cfset var myNewsFeed=0>
		<cfset var loopLen=0>
		<cfset var myItem=0>
		<cfoutput>
		<cfset myFeed=XmlParse("#arguments.feed#")>
		<cfset newsXML=xmlsearch(myFeed, "/rss/channel")>
		<cfset newsItems=xmlsearch(myFeed, "/rss/channel/item")>
		<cfset newsPureTitle="#newsXML[1].title.XmlText#">
		<cfset newsTitle=ListLast('#newsPureTitle#',"-")>		
		
		<cfset loopLen=ArrayLen(newsItems)>
		
		<cfloop index="i" from="1" to="#loopLen#">
			<cfset thisArticleTitle=listLast(newsItems[i].link.XmlText, "/")>
			<cfif thisArticleTitle eq arguments.title>
				<cfsavecontent variable="myNewsFeed">
					#newsItems[i]#
				</cfsavecontent>
			</cfif>
		</cfloop>
		
	
		</cfoutput>
		<cfreturn myNewsFeed>
	</cffunction>

</cfcomponent>