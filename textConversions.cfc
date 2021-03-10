<cfcomponent hint="I have text conversion functions">
	<cfscript>
	/**
	* Shortens a string without cutting words in half.
	* Modified by Raymond Camden on July 30, 2001
	*
	* @param str      The string to modify.
	* @param words      The number of words to display.
	* @author David Grant (david@insite.net)
	* @version 2, July 30, 2001
	*/
	function getWords(str,words) {
	    var numWords = 0;
	    var oldPos = 1;
	    var i = 1;
	    var strPos = 0;

	    str = trim(str);
	    str = REReplace(str,"[[:space:]]{2,}"," ","ALL");
	    numWords = listLen(str," ");
	    if (words gte numWords) return str;
	    for (i = 1; i lte words; i=i+1) {
	        strPos = find(" ",str,oldPos);
	        oldPos = strPos + 1;
	    }
	    if (len(str) lte strPos) return left(str,strPos-1);
	    return left(str,strPos-1) & "...";
	}
	</cfscript>
	<cfscript>
	tempName = -1;
	count = '';
	function cycle(cycleName) {
		var modNum = arrayLen(Arguments);

		if(cycleName != tempName OR count == '') {
			count = -1;
			tempName = cycleName;
		}

		count = count + 1;
		return Arguments[(count mod modNum ) + 1];
	}
	</cfscript>
	<cfscript>
	/**
	* Case-insensitive function for removing duplicate entries in a list.
	* Based on dedupe by Raymond Camden
	*
	* @param list      List to be modified. (Required)
	* @return Returns a list.
	* @author Jeff Howden (cflib@jeffhowden.com)
	* @version 1, July 2, 2008
	*/
	function ListDeleteDuplicatesNoCase(list) {
	var i = 1;
	var delimiter = ',';
	var returnValue = '';
	if(ArrayLen(arguments) GTE 2)
	delimiter = arguments[2];
	list = ListToArray(list, delimiter);
	for(i = 1; i LTE ArrayLen(list); i = i + 1)
	if(NOT ListFindNoCase(returnValue, list[i], delimiter))
	returnValue = ListAppend(returnValue, list[i], delimiter);
	return returnValue;
	}
	</cfscript>

	<cfscript>
	/**
	 * Strips all characters from a string except the ones that you want to keep.
	 *
	 * @param strSource 	 The string to strip. (Required)
	 * @param strKeep 	 List of  characters to keep. (Required)
	 * @param beCS 	 Boolean that determines if the match should be case sensitive. Default is true. (Optional)
	 * @return Returns a string.
	 * @author Scott Jibben (scott@jibben.com)
	 * @version 1, July 2, 2002
	 */
	function stripAllBut(str,strip) {
		var badList = "\";
		var okList = "\\";
		var bCS = true;

		if(arrayLen(arguments) gte 3) bCS = arguments[3];

		strip = replaceList(strip,badList,okList);

		if(bCS) return rereplace(str,"[^#strip#]","","all");
		else return rereplaceNoCase(str,"[^#strip#]","","all");
	}
	</cfscript>


	<cfscript>
	/**
	 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
	 * Update by David Kearns to support '
	 * &#83;&#66;&#114;&#111;&#119;&#110;&#64;&#120;&#97;&#99;&#116;&#105;&#110;&#103;&#46;&#99;&#111;&#109; pointing out regex still wasn't accepting ' correctly.
	 * More TLDs
	 * Version 4 by P Farrel, supports limits on u/h
	 *
	 * @param str 	 The string to check. (Required)
	 * @return Returns a boolean.
	 * @author Jeff Guillaume (&#83;&#66;&#114;&#111;&#119;&#110;&#64;&#120;&#97;&#99;&#116;&#105;&#110;&#103;&#46;&#99;&#111;&#109;&#106;&#101;&#102;&#102;&#64;&#107;&#97;&#122;&#111;&#111;&#109;&#105;&#115;&#46;&#99;&#111;&#109;)
	 * @version 4, December 30, 2005
	 */
	function isEmail(str) {
	    return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel))$",
	arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
	len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
	}
	</cfscript>

	<cfscript>
	/**
	 * Simple Validation for Phone Number syntax.
	 * version 2 by Ray Camden - added 7 digit support
	 * version 3 by Tony Petruzzi &#84;&#111;&#110;&#121;&#95;&#80;&#101;&#116;&#114;&#117;&#122;&#122;&#105;&#64;&#115;&#104;&#101;&#114;&#105;&#102;&#102;&#46;&#111;&#114;&#103;
	 *
	 * @param valueIn 	 String to check. (Required)
	 * @return Returns a boolean.
	 * @author Alberto Genty (&#84;&#111;&#110;&#121;&#95;&#80;&#101;&#116;&#114;&#117;&#122;&#122;&#105;&#64;&#115;&#104;&#101;&#114;&#105;&#102;&#102;&#46;&#111;&#114;&#103;&#97;&#103;&#101;&#110;&#116;&#121;&#64;&#104;&#111;&#117;&#115;&#116;&#111;&#110;&#46;&#114;&#114;&#46;&#99;&#111;&#109;)
	 * @version 3, September 24, 2002
	 */
	function IsValidPhone(valueIn) {
	 	/*var re = "^(([0-9]{3}-)|\([0-9]{3}\) ?)?[0-9]{3}-[0-9]{4}$";*/
	 	var re = "^(([0-9]{3}[-.]?)|\([0-9]{3}\) ?)?[0-9]{3}[.-]?[0-9]{4}$";
	 	return	ReFindNoCase(re, valueIn);
	}
	</cfscript>

	<cfscript>
	/**
	 * Tests passed value to see if it is a properly formatted U.S. zip code.
	 *
	 * @param str 	 String to be checked. (Required)
	 * @return Returns a boolean.
	 * @author Jeff Guillaume (&#106;&#101;&#102;&#102;&#64;&#107;&#97;&#122;&#111;&#111;&#109;&#105;&#115;&#46;&#99;&#111;&#109;)
	 * @version 1, May 8, 2002
	 */
	function isZipUS(str) {
		return REFind('^[[:digit:]]{5}(( |-)?[[:digit:]]{4})?$', str);
	}
	</cfscript>

	<cfscript>
	/**
	* Removes HTML from the string.
	* v2 - Mod by Steve Bryant to find trailing, half done HTML.
	*
	* @param string      String to be modified. (Required)
	* @return Returns a string.
	* @author Raymond Camden (ray@camdenfamily.com)
	* @version 3, July 9, 2008
	*/
	function stripHTML(str) {
	str = reReplaceNoCase(str, "<.*?>","","all");
	//get partial html in front
	str = reReplaceNoCase(str, "^.*?>","");
	//get partial html at end
	str = reReplaceNoCase(str, "<.*$","");
	return str;
	}
	</cfscript>

	<cfscript>
	/**
	* Removes BBCODE from the string
	* @param string String to be modified (Required)
	* @return Returns a string
	* version 1, August 7, 2009
	*/
	function stripBBCODE(str){
		str= REReplace(str,"\[(.*?)\]","","ALL");
		return str;
	}
	</cfscript>

	<cfscript>
	/**
	* Removes potentially nasty HTML text.
	* Version 2 by Lena Aleksandrova - changes include fixing a bug w/ arguments and use of REreplace where REreplaceNoCase should have been used.
	* version 4 fix by Javier Julio - when a bad event is removed, remove the arg too, ie, remove onclick=&quot;foo&quot;, not just onclick.
	*
	* @param text      String to be modified. (Required)
	* @param strip      Boolean value (defaults to false) that determines if HTML should be stripped or just escaped out. (Optional)
	* @param badTags      A list of bad tags. Has a long default list. Consult source. (Optional)
	* @param badEvents      A list of bad HTML events. Has a long default list. Consult source. (Optional)
	* @return Returns a string.
	* @author Nathan Dintenfass (nathan@changemedia.com)
	* @version 4, October 16, 2006
	*/
	function safetext(text) {
	    //default mode is "escape"
	    var mode = "escape";
	    //the things to strip out (badTags are HTML tags to strip and badEvents are intra-tag stuff to kill)
	    //you can change this list to suit your needs
	    var badTags = "SCRIPT,OBJECT,APPLET,EMBED,FORM,LAYER,ILAYER,FRAME,IFRAME,FRAMESET,PARAM,META";
	    var badEvents = "onClick,onDblClick,onKeyDown,onKeyPress,onKeyUp,onMouseDown,onMouseOut,onMouseUp,onMouseOver,onBlur,onChange,onFocus,onSelect,javascript:";
	    var stripperRE = "";

	    //set up variable to parse and while we're at it trim white space
	    var theText = trim(text);
	    //find the first open bracket to start parsing
	    var obracket = find("<",theText);
	    //var for badTag
	    var badTag = "";
	    //var for the next start in the parse loop
	    var nextStart = "";
	    //if there is more than one argument and the second argument is boolean TRUE, we are stripping
	    if(arraylen(arguments) GT 1 AND isBoolean(arguments[2]) AND arguments[2]) mode = "strip";
	    if(arraylen(arguments) GT 2 and len(arguments[3])) badTags = arguments[3];
	    if(arraylen(arguments) GT 3 and len(arguments[4])) badEvents = arguments[4];
	    //the regular expression used to stip tags
	    stripperRE = "</?(" & listChangeDelims(badTags,"|") & ")[^>]*>";
	    //Deal with "smart quotes" and other "special" chars from MS Word
	    theText = replaceList(theText,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,...");
	    //if escaping, run through the code bracket by bracket and escape the bad tags.
	    if(mode is "escape"){
	        //go until no more open brackets to find
	        while(obracket){
	            //find the next instance of one of the bad tags
	            badTag = REFindNoCase(stripperRE,theText,obracket,1);
	            //if a bad tag is found, escape it
	            if(badTag.pos[1]){
	                theText = replace(theText,mid(TheText,badtag.pos[1],badtag.len[1]),HTMLEditFormat(mid(TheText,badtag.pos[1],badtag.len[1])),"ALL");
	                nextStart = badTag.pos[1] + badTag.len[1];
	            }
	            //if no bad tag is found, move on
	            else{
	                nextStart = obracket + 1;
	            }
	            //find the next open bracket
	            obracket = find("<",theText,nextStart);
	        }
	    }
	    //if not escaping, assume stripping
	    else{
	        theText = REReplaceNoCase(theText,stripperRE,"","ALL");
	    }
	    //now kill the bad "events" (intra tag text)
	    theText = REReplaceNoCase(theText,'(#ListChangeDelims(badEvents,"|")#)[^ >]*',"","ALL");
	    //return theText
	    return theText;
	}
	</cfscript>

	<cfscript>
		/**
		* Gets first alpha numeric word from a string. Meant to get the layout from standard url.
		* @param text, string to look into
		* @returns the word found
		* @author: binod@quantumdelta.com
		* @version 1, August 12, 2009
		*/
		function getlayout(text)
		{
			var result=structnew();
			var theword="";
			if(text=="/") return "home";
			result=refind("[A-Za-z0-9]+",text,1,true);
			theword=mid(text,result.pos[1],result.len[1]);
			return theword;
		}
	</cfscript>

	<cfscript>
		/**
		* Gets second alpha numeric word from a string. Meant to get id from standard url
		* @param text, string to look into
		* @returns the word found
		* @author: binod@quantumdelta.com
		* version 1, August 13, 2009
		*/
		function getId(text)
		{
			var temp=refind("[A-Za-z0-9]+",text,1,true);
			var start=temp.pos[1] + temp.len[1];
			var result=refind("[A-Za-z0-9]+",text,start,true);
			var theword=mid(text,result.pos[1],result.len[1]);
			return theword;
		}
	</cfscript>

	<cffunction name="givenewname" >
	<cfargument name="name" required="yes" type="string">
	<cfargument name="size" required="false" type="string" default="10">
	<!--- I am used to strip page names down to fit. --->
	<cfset lowername = "#lcase(arguments.name)#">
	<cfset newname = "#StripAllBut(lowername, "1234567890abcdefghijklmnopqrstuvwxyz_ ")#">
	<cfif FindNoCase(" ", "#newname#")>
		<cfset newname = "#ReplaceNoCase(newname, " ", "_", "ALL")#">
	</cfif>
	<cfif len(#newname#) gt arguments.size>
		<cfif mid(#newname#, arguments.size, 1) eq "_">
			<cfset newname = "#left(newname, 10)#">
		<cfelse>
			<cfset newname = "#left(newname, 11)#">
		</cfif>
	</cfif>
	<cfreturn newname>
	</cffunction>
	<cfscript>
	/**
	* Allows you to specify the mask you want added to your phone number.
	* v2 - code optimized by Ray Camden
	* v3.01
	* v3.02 added code for single digit phone numbers from John Whish
	*
	* @param varInput      Phone number to be formatted. (Required)
	* @param varMask      Mask to use for formatting. x represents a digit. (Required)
	* @return Returns a string.
	* @author Derrick Rapley (adrapley@rapleyzone.com)
	* @version 3, May 9, 2009
	*/
	function phoneFormat(varInput, varMask) {
		var curPosition = "";
		var i = "";
		var newFormat = "";
		var startpattern = "";

		if(IsValidPhone(varInput)) {
			newFormat = trim(ReReplace(varInput, "[^[:digit:]]", "", "all"));
			startpattern = ReReplace(ListFirst(varMask, "- "), "[^x]", "", "all");

			if (Len(newFormat) gte Len(startpattern)) {
				varInput = trim(varInput);
				newFormat = " " & reReplace(varInput,"[^[:digit:]]","","all");
				newFormat = reverse(newFormat);
				varmask = reverse(varmask);
				for (i=1; i lte len(trim(varmask)); i=i+1) {
					curPosition = mid(varMask,i,1);
					if(curPosition neq "x") newFormat = insert(curPosition,newFormat, i-1) & " ";
				}
				newFormat = reverse(newFormat);
				varmask = reverse(varmask);
			}
		} else {
			newFormat = varInput;
		}
		return trim(newFormat);
	}
	</cfscript>

	<cffunction name="setFormValue" access="public" output="false" returntype="string" hint="I return value of the form field passed to me">
		<cfargument name="fieldname" required="true" type="string" hint="name of the form field">
		<cfset str="">
		<cfif isDefined("Session.formValues.#arguments.fieldname#")>
			<cfset str=Evaluate("Session.formValues['#arguments.fieldname#']")>
			<cfset structDelete(session.formvalues,"#arguments.fieldname#",false)>
		</cfif>
		<cfreturn str>
	</cffunction>

	<cffunction name="getRandomtext" access="public" returntype="String" Hint="I generate a random text">
		<cfset var ststring=structNew()>
		<cfloop index="i" from="1" to="10" step="1">

		    <cfset a = randrange(48,122)>

		    <cfif (#a# gt 57 and #a# lt 65) or (#a# gt 90 and #a# lt 97)>
		        <cfset ststring["#i#"]="E">
		    <cfelse>
		        <cfset ststring["#i#"]="#chr(a)#">
		    </cfif>

		</cfloop>
		<cfset randomtxt ="#ststring[1]##ststring[2]##ststring[3]##ststring[4]##ststring[5]##ststring[6]##ststring[7]##ststring[8]##ststring[9]##ststring[10]#">
		<cfreturn randomtxt>
	</cffunction>

	<cffunction name="getUniqueUrlName" access="public" returntype="String" hint="I return unique url friendly name for a table column">
		<cfargument name="ds" required="true" type="string" hint="I am the datasource">
		<cfargument name="tablename" required="true" type="string" hint="I am the name of the table on which unique urlname should be stored">
		<cfargument name="columnname" required="true" type="string" hint="I am the name of the column in the table where unique urlname should be stored">
		<cfargument name="name" required="true" type="string" hint="I am the name of the entry row. The name will be modified into url friendly name">
		<cfargument name="exceptioncolumn" required="false" type="string" default="0" hint="I am exception column, usually primary key or identity column">
		<cfargument name="exceptionvalue" required="false" type="string" default="0" hint="I am the exception value, usually the value of primary key or identity column">
		<cfset var urlname=givenewname(name,10)>
		<cfset var get=0>
		<cfset var doloop=TRUE>
		<cfset var count=1>
		<cfloop condition="#doloop#">
			<cfquery name="get" datasource="#arguments.ds#">
				SELECT #arguments.columnname# FROM #arguments.tablename#
				WHERE #arguments.columnname#=<cfqueryparam value="#urlname#" cfsqltype="cf_sql_varchar">
				<cfif arguments.exceptioncolumn NEQ 0>
					AND #arguments.exceptioncolumn# <> <cfqueryparam value="#arguments.exceptionvalue#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfquery>
			<cfif get.recordcount EQ 0>
				<cfset doloop=FALSE>
			<cfelse>
				<cfset urlname=urlname & count>
				<cfset count=count+1>
			</cfif>
		</cfloop>
		<cfreturn urlname>
	</cffunction>

	<cffunction name="getListDifference" access="public" returntype="struct" hint="I compare two lists and return difference in a structure. retList.a=list of elements in first but not in second, retList.b=list of element in second and but not in first">
		<cfargument name="list1" required="true" type="string" hint="first list under comparision">
		<cfargument name="list2" required="true" type="string" hint="second list under comparision">
		<cfset var listDiff=StructNew()>
		<cfset listDiff.a="">
		<cfset listDiff.b="">
		<cfloop list="#arguments.list1#" index="item">
			<cfif ListContains(arguments.list2,item) EQ 0>
				<cfset listDiff.a=ListAppend(listDiff.a,item)>
			</cfif>
		</cfloop>
		<cfloop list="#arguments.list2#" index="item">
			<cfif listContains(arguments.list1,item) EQ 0>
				<cfset listDiff.b=ListAppend(listDiff.b,item)>
			</cfif>
		</cfloop>
		<cfreturn listDiff>
	</cffunction>

	<cffunction name="UcaseFirstLetter" access="public" returntype="string" hint="I capitalize first letter of a word">
		<cfargument name="input" required="true" type="string" hint="input string">
		<cfset var output="">
		<cfset lenminus1=len(arguments.input)-1>
		<cfif lenminus1 GT 0>
			<cfset output=Ucase(left(arguments.input,1)) & right(arguments.input,len(arguments.input)-1)>
		<cfelse>
			<cfset output=Ucase(arguments.input)>
		</cfif>
		<cfreturn output>
	</cffunction>

	<cffunction name="UcaseAllFirstLetter" access="public" returntype="string" hint="I capitalize first letter of a word">
		<cfargument name="input" required="true" type="string" hint="input string">
		<cfset var output="">
		<cfloop list="#arguments.input#" index="word" delimiters=" ">
			<cfset lenminus1=len(word)-1>
			<cfif lenminus1 GT 0>
				<cfset o=Ucase(left(word,1)) & right(word,lenminus1)>
			<cfelse>
				<cfset o=Ucase(word)>
			</cfif>
			<cfset output=listappend(output,o,' ')>
		</cfloop>
		<cfreturn output>
	</cffunction>

	<cffunction name="convertNumberToSortCode" access="public" returntype="string" hint="I convert a number to sort code">
		<cfargument name="number" required="true" type="string">
		<cfif arguments.number LTE 0>
			<cfset so=0>
		<cfelse>
			<cfset n=Int(log10(arguments.number))>
			<cfif n GT 0>
				<cfset char=chr(64+n)>
				<cfset so="#char##arguments.number#">
			<cfelse>
				<cfset so=arguments.number>
			</cfif>
		</cfif>
		<cfreturn so>
	</cffunction>

	<cffunction name="shortenText" access="public" output="false" returntype="string" hint="I shorten text">
		<cfargument name="inputtext" required="true" type="string" hint="A word or sentence">
		<cfargument name="noofcharacters" required="false" type="string" default="18" hint="no of characters to return">
		<cfset var outputtext="">
		<cfif len(arguments.inputtext) GT arguments.noofcharacters>
			<cfset outputtext=Left(arguments.inputtext,arguments.noofcharacters-3) & "...">
		<cfelse>
			<cfset outputtext=arguments.inputtext>
		</cfif>
		<cfreturn outputtext>
	</cffunction>
</cfcomponent>
