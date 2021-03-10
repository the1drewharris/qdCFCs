<cfcomponent hint="YouTube CFC. contains functions that will call the YouTube API">

	<cffunction name="get" hint="I get a video based on on the video ID, passed in." returnType="struct">
		<cfargument name="videoID" required="yes" hint="Video ID of the video to retrieve information for">
		<cfset var video = StructNew()>
		<cfset var ytXML = StructNew()>
		<cfset var media = StructNew()>
		<cfset var ytFeed = "http://gdata.youtube.com/feeds/api/videos/">
		
		<cfhttp url="#ytFeed##arguments.videoID#" charset="utf-8" method="get">
		<cfif isXML(cfhttp.fileContent)>
			<cfset ytXML = XmlParse(cfhttp.fileContent)>
			<cfset media = XmlSearch(ytXML, "//media:content[@yt:format='5']")>
	
			<cfset video['exists'] = 1>
			<cfif arrayLen(media) EQ 0>
				<cfset video['url'] = ytXML.entry['media:group']['media:player'].xmlAttributes.url>
			<cfelse>
				<cfset video['url'] = media[1].xmlAttributes.url>
			</cfif>
			<cfset video['id'] = ytXML.entry.id.xmlText>
			<cfset video['published'] = ytXML.entry.published.xmlText>
			<cfset video['updated'] = ytXML.entry.updated.xmlText>
			<cfset video['title'] = ytXML.entry.title.xmlText>
			<cfset video['content'] = ytXML.entry.content.xmlText>
			<cfset video['author']['username'] = ytXML.entry.author.name.xmlText>
			<cfset video['author']['url'] = ytXML.entry.author.uri.xmlText>
			<cfset video['comments']['count'] = ytXML.entry['gd:comments']['gd:feedlink'].xmlAttributes.countHint>
			<cfset video['comments']['url'] = ytXML.entry['gd:comments']['gd:feedlink'].xmlAttributes.href>
			<cfset video['description'] = ytXML.entry['media:group']['media:description'].xmlText>
			<cfset video['keywords'] = ytXML.entry['media:group']['media:keywords'].xmlText>
			<cfset video['duration'] = ytXML.entry['media:group']['yt:duration'].xmlAttributes.seconds>
			<cfset video['duration'] = ytXML.entry['media:group']['yt:duration'].xmlAttributes.seconds>
			<cfset video['statistics']['favorite'] = ytXML.entry['yt:statistics'].xmlAttributes.favoriteCount>
			<cfset video['statistics']['view'] = ytXML.entry['yt:statistics'].xmlAttributes.viewCount>
			
			<cfloop from="1" to="#arrayLen(ytXML.entry['media:group']['media:content'])#" index="i">
				<cfset video['media'][i]['format'] = ytXML.entry['media:group']['media:content'][i].xmlAttributes['yt:format']>
				<cfset video['media'][i]['url'] = ytXML.entry['media:group']['media:content'][i].xmlAttributes.url>
				<cfset video['media'][i]['type'] = ytXML.entry['media:group']['media:content'][i].xmlAttributes.type>
				<cfset video['media'][i]['duration'] = ytXML.entry['media:group']['media:content'][i].xmlAttributes.duration>
			</cfloop>
			
			<cfloop from="1" to="#arrayLen(ytXML.entry['media:group']['media:thumbnail'])#" index="i">
				<cfset video['thumbnail'][i]['width'] = ytXML.entry['media:group']['media:thumbnail'][i].xmlAttributes['width']>
				<cfset video['thumbnail'][i]['height'] = ytXML.entry['media:group']['media:thumbnail'][i].xmlAttributes['height']>
				<cfset video['thumbnail'][i]['url'] = ytXML.entry['media:group']['media:thumbnail'][i].xmlAttributes['url']>
			</cfloop>
				
			<cfloop from="1" to="#arrayLen(ytXML.entry.category)#" index="i">
				<cfset video['category'][i] = ytXML.entry.category[i].xmlAttributes.term>
			</cfloop>
		
		<cfelse>
			<cfset video['exists'] = 0>	
			<cfset video['reason'] = cfhttp.fileContent>
		</cfif>
		
		<cfreturn video>
	</cffunction>
	<cffunction name="checkURL" hint="I receive in an argument and check if it is a URL of a video or a username.">
		<cfargument name="string" required="true" hint="String to check">
		<cfargument name="videoInfo" retuired="false" default="0" hint="Return information on video if URL is a video? Default: 0 (False), 1 
		(True)">
		<cfset var struct = StructNew()>
		<cfset var structRet = StructNew()>
		
		<cfset struct = parseURL(arguments.string)>
		
		<cfif len(struct.authority)>
		<!--- If struct.authority has a length then it is a URL --->
			<cfif find("youtube",struct.authority)>
			<!--- Making sure the URL is youtube --->
				<cfset flag = 0>
				<cfif len(struct.file) AND struct.directory EQ "/v/">
					<cfset structRet['videoID'] = struct.file>
					<cfset flag = 1>
				<cfelseif isDefined('struct.params.url.v')>
					<cfset structRet['videoID'] = struct.params.url.v>
					<cfset flag = 1>
				</cfif>
				<cfif flag EQ 1>
					<cfif arguments.videoInfo EQ 1><cfset structRet = get(structRet['videoID'])></cfif>
					<cfset structRet['type'] = 1>
					<cfset structRet['info'] = "YouTube Video URL">
				<cfelse>
					<cfset structRet['type'] = 3>
					<cfset structRet['info'] = "YouTube URL, but not a YouTube Video URL">
				</cfif>
			<cfelse>
				<cfset structRet['type'] = 0>
				<cfset structRet['info'] = "Unknown URL">
			</cfif>
		
		<cfelse>
			<cfset structRet['type'] = 2>
			<cfset structRet['info'] = "Not a URL">
		
		</cfif>
		<cfset structRet['string'] = arguments.string>
		
		<cfreturn structRet>
	</cffunction>
	
	<cffunction name="parseURL" hint="I parse a URL string passed in and return information about the URL." access="public">
		<cfargument name="sUrl" required="true" hint="I am the URL to be tested" type="string">
	<cfscript>
		/**
		 * Parses a Url and returns a struct with keys defining the information in the Uri.
		 * 
		 * @param sURL 	 String to parse. (Required)
		 * @return Returns a struct. 
		 * @author Dan G. Switzer, II
		 * @version 1, January 10, 2007 
		 */
			// var to hold the final structure
			var stUrlInfo = structNew();
			// vars for use in the loop, so we don't have to evaluate lists and arrays more than once
			var i = 1;
			var sKeyPair = "";
			var sKey = "";
			var sValue = "";
			var aQSPairs = "";
			var sPath = "";
			/*
				from: http://www.ietf.org/rfc/rfc2396.txt
		
				^((([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*)))?
				 123            4  5          6       7  8        9 A
		
					scheme    = $3
					authority = $5
					path      = $6
					query     = $8
					fragment  = $10 (A)
			*/
			var sUriRegEx = "^(([^:/?##]+):)?(//([^/?##]*))?([^?##]*)(\?([^##]*))?(##(.*))?";
			/*
				separates the authority into user info, domain and port
		
				^((([^@:]+)(:([^@]+))?@)?([^:]*)?(:(.*)))?
				 123       4 5           6       7 8
		
					username  = $3
					password  = $5
					domain    = $6
					port      = $8
			*/
			var sAuthRegEx = "^(([^@:]+)(:([^@]+))?@)?([^:]*)?(:(.*))?";
			/*
				separates the path into segments & parameters
		
				((/?[^;/]+)(;([^/]+))?)
				12         3 4
		
					segment     = $1
					path        = $2
					parameters  = $4
			*/
			var sSegRegEx = "(/?[^;/]+)(;([^/]+))?";
		
			// parse the url looking for info
			var stUriInfo = reFindNoCase(sUriRegEx, sUrl, 1, true);
			// this is for the authority section
			var stAuthInfo = "";
			// this is for the segments in the path
			var stSegInfo = "";
		
			// create empty keys
			stUrlInfo["scheme"] = "";
			stUrlInfo["authority"] = "";
			stUrlInfo["path"] = "";
			stUrlInfo["directory"] = "";
			stUrlInfo["file"] = "";
			stUrlInfo["query"] = "";
			stUrlInfo["fragment"] = "";
			stUrlInfo["domain"] = "";
			stUrlInfo["port"] = "";
			stUrlInfo["username"] = "";
			stUrlInfo["password"] = "";
			stUrlInfo["params"] = structNew();
		
			// get the scheme
			if( stUriInfo.len[3] gt 0 ) stUrlInfo["scheme"] = mid(sUrl, stUriInfo.pos[3], stUriInfo.len[3]);
			// get the authority
			if( stUriInfo.len[5] gt 0 ) stUrlInfo["authority"] = mid(sUrl, stUriInfo.pos[5], stUriInfo.len[5]);
			// get the path
			if( stUriInfo.len[6] gt 0 ) stUrlInfo["path"] = mid(sUrl, stUriInfo.pos[6], stUriInfo.len[6]);
			// get the path
			if( stUriInfo.len[8] gt 0 ) stUrlInfo["query"] = mid(sUrl, stUriInfo.pos[8], stUriInfo.len[8]);
			// get the fragment
			if( stUriInfo.len[10] gt 0 ) stUrlInfo["fragment"] = mid(sUrl, stUriInfo.pos[10], stUriInfo.len[10]);
		
			// break authority into user info, domain and ports
			if( len(stUrlInfo["authority"]) gt 0 ){
				// parse the authority looking for info
				stAuthInfo = reFindNoCase(sAuthRegEx, stUrlInfo["authority"], 1, true);
		
				// get the domain
				if( stAuthInfo.len[6] gt 0 ) stUrlInfo["domain"] = mid(stUrlInfo["authority"], stAuthInfo.pos[6], stAuthInfo.len[6]);
				// get the port
				if( stAuthInfo.len[8] gt 0 ) stUrlInfo["port"] = mid(stUrlInfo["authority"], stAuthInfo.pos[8], stAuthInfo.len[8]);
				// get the username
				if( stAuthInfo.len[3] gt 0 ) stUrlInfo["username"] = mid(stUrlInfo["authority"], stAuthInfo.pos[3], stAuthInfo.len[3]);
				// get the password
				if( stAuthInfo.len[5] gt 0 ) stUrlInfo["password"] = mid(stUrlInfo["authority"], stAuthInfo.pos[5], stAuthInfo.len[5]);
			}
		
			// the query string in struct form
			stUrlInfo["params"]["segment"] = structNew();
		
			// if the path contains any parameters, we need to parse them out
			if( find(";", stUrlInfo["path"]) gt 0 ){
				// this is for the segments in the path
				stSegInfo = reFindNoCase(sSegRegEx, stUrlInfo["path"], 1, true);
		
				// loop through all the segments and build the strings
				while( stSegInfo.pos[1] gt 0 ){
					// build the path, excluding parameters
					sPath = sPath & mid(stUrlInfo["path"], stSegInfo.pos[2], stSegInfo.len[2]);
		
					// if there are some parameters in this segment, add them to the struct
					if( stSegInfo.len[4] gt 0 ){
		
						// put the parameters into an array for easier looping
						aQSPairs = listToArray(mid(stUrlInfo["path"], stSegInfo.pos[4], stSegInfo.len[4]), ";");
		
						// now, loop over the array and build the struct
						for( i=1; i lte arrayLen(aQSPairs); i=i+1 ){
							sKeyPair = aQSPairs[i]; // current pair
							sKey = listFirst(sKeyPair, "="); // current key
							// make sure there are 2 keys
							if( listLen(sKeyPair, "=") gt 1){
								sValue = urlDecode(listLast(sKeyPair, "=")); // current value
							} else {
								sValue = ""; // set blank value
							}
							// check if key already added to struct
							if( structKeyExists(stUrlInfo["params"]["segment"], sKey) ) stUrlInfo["params"]["segment"][sKey] = listAppend(stUrlInfo["params"]["segment"][sKey], sValue); // add value to list
							else structInsert(stUrlInfo["params"]["segment"], sKey, sValue); // add new key/value pair
						}
					}
		
					// get the ending position
					i = stSegInfo.pos[1] + stSegInfo.len[1];
		
					// get the next segment
					stSegInfo = reFindNoCase(sSegRegEx, stUrlInfo["path"], i, true);
				}
		
			} else {
				// set the current path
				sPath = stUrlInfo["path"];
			}
		
			// get the file name
			stUrlInfo["file"] = getFileFromPath(sPath);
			// get the directory path by removing the file name
			if( len(stUrlInfo["file"]) gt 0 ){
				stUrlInfo["directory"] = replace(sPath, stUrlInfo["file"], "", "one");
			} else {
				stUrlInfo["directory"] = sPath;
			}
		
			// the query string in struct form
			stUrlInfo["params"]["url"] = structNew();
		
			// if query info was supplied, break it into a struct
			if( len(stUrlInfo["query"]) gt 0 ){
				// put the query string into an array for easier looping
				aQSPairs = listToArray(stUrlInfo["query"], "&");
		
				// now, loop over the array and build the struct
				for( i=1; i lte arrayLen(aQSPairs); i=i+1 ){
					sKeyPair = aQSPairs[i]; // current pair
					sKey = listFirst(sKeyPair, "="); // current key
					// make sure there are 2 keys
					if( listLen(sKeyPair, "=") gt 1){
						sValue = urlDecode(listLast(sKeyPair, "=")); // current value
					} else {
						sValue = ""; // set blank value
					}
					// check if key already added to struct
					if( structKeyExists(stUrlInfo["params"]["url"], sKey) ) stUrlInfo["params"]["url"][sKey] = listAppend(stUrlInfo["params"]["url"][sKey], sValue); // add value to list
					else structInsert(stUrlInfo["params"]["url"], sKey, sValue); // add new key/value pair
				}
			}
		
			// return the struct
			return stUrlInfo;
		</cfscript>
	</cffunction>
</cfcomponent>