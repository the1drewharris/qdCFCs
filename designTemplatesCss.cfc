<!--- 
Template 1
	Logo: 200x100
	Center: 540x100
	right: 200x100
	
Template 2
	Logo: 784:165

Template 3
	Logo: 200x100
	
Template 4
	Logo 944x100

Template 5
	Logo: 200x100
	Center: 540x100
	Phone: 200x100

Template 6
	Logo: 180x100
	Phone: 167x100
 --->

<cfcomponent displayname="designTemplatesCSS" hint="I get the correct CSS">
	
	<cffunction name="getClassicColorSchemes" access="public" output="false" returntype="query" hint="I get the color schemes you are searching for and return a recordset: colorschemeID, colorschemeNAME, colorschemeDESCRIPTION, colorschemelinkname, authorid, colorschemekeywords, colorrange, primarycolor, secondary, backgroundcolor,  accent1, accent2">
	<cfargument name="ds" required="false" default="deltasystem" type="string" hint="Datasource to find colorschemes">
	<cfargument name="criteria" required="false" type="String" hint="generic search data" default="0">
	<cfargument name="colorschemeID" required="false" type="String" hint="I am the color scheme id you want me to find" default="0">
	<cfargument name="colorschemename" required="false" type="string" default="0" hint="the name of the color scheme you are looking for">
	<cfargument name="colorschemelinkname" required="false" type="string" default="0" hint="the name of the color scheme link name you are looking for">
	<cfargument name="authorid" required="false" type="string" hint="the id of the author" default="0">
	<cfargument name="colorrange" required="false" type="string" default="0" hint="the color range you are seeking">
	<cfargument name="sortlist" required="false" type="string" default="0" hint="I am the list of how you want to sort the results">
	<cfset var colorschemes=0>
		<cfquery name="colorschemes" datasource="#arguments.ds#">
		SELECT 
			colorschemeID,
			colorschemeNAME,
			colorschemeDESCRIPTION,
			colorschemelinkname,
			authorid,
			colorschemekeywords,
			colorrange,
			primarycolor,
			secondarycolor as secondary,
			backgroundcolor,
			accent1color as accent1,
			accent2color as accent2
		FROM COLORSCHEME
		WHERE 1=1
		<cfif arguments.criteria neq 0>
		AND ((
		<cfloop from="1" to="#listLen(arguments.criteria,' ')#" index="i">
			colorschemeNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR colorschemeDESCRIPTION LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR colorschemelinkname LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR colorschemekeywords LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR colorrange LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR primarycolor LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR secondarycolor LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR backgroundcolor LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR accent1color LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR accent2color LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			<cfif i LT listLen(arguments.criteria,' ')>) AND (</cfif>
		</cfloop>))
		</cfif>
		<cfif arguments.colorschemeid neq 0>
		AND colorschemeID = <cfqueryparam value="#arguments.colorschemeid#">
		</cfif>
		<cfif arguments.colorschemename neq 0>
		AND colorschemename = <cfqueryparam value="#arguments.colorschemename#">
		</cfif>
		<cfif arguments.colorschemelinkname neq 0>
		AND colorschemelinkname = <cfqueryparam value="#arguments.colorschemelinkname#">
		</cfif>
		<cfif arguments.authorid neq 0>
		AND authorid = <cfqueryparam value="#arguments.authorid#">
		</cfif>
		<cfif arguments.colorrange neq 0>
		AND colorrange = <cfqueryparam value="#arguments.colorrange#">
		</cfif>
		<cfif arguments.sortlist neq 0>
		ORDER BY #arguments.sortlist#
		<cfelse>
		ORDER BY colorschemename
		</cfif>
		</cfquery>
	<cfreturn colorschemes>
	</cffunction>
	
	<cffunction name="getFontFamily" access="public" output="false" returntype="query" hint="I get the font families you are searching for and return a recordset: FONTFAMILYID, FONTFAMILYNAME, FONTFAMILYDESCRIPTION, FONTFAMILYLIST">
	<cfargument name="ds" required="false" default="deltasystem" type="string" hint="Datasource to find colorschemes">
	<cfargument name="criteria" required="false" type="String" hint="generic search data" default="0">
	<cfargument name="fontfamilyid" required="false" type="String" hint="I am the font family id you want me to find" default="0">
	<cfargument name="fontfamilyname" required="false" type="string" default="0" hint="the name of the font family you are searching for">
	<cfargument name="fontfamilydescription" required="false" type="string" default="0" hint="the description of the font family you are searching for">
	<cfargument name="fontfamilylist" required="false" type="string" hint="the list of the font family you are searching for" default="0">
	<cfargument name="sortlist" required="false" type="string" default="0" hint="I am the list of how you want to sort the results">
	<cfset var thisFontFamily=0>
		<cfquery name="thisFontFamily" datasource="#arguments.ds#">
		SELECT 
			FONTFAMILYID,
			FONTFAMILYNAME,
			FONTFAMILYDESCRIPTION,
			FONTFAMILYLIST
		FROM FONTFAMILY
		WHERE 1=1
		<cfif arguments.criteria neq 0>
		AND ((
		<cfloop from="1" to="#listLen(arguments.criteria,' ')#" index="i">
			FONTFAMILYNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR FONTFAMILYDESCRIPTION LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR FONTFAMILYLIST LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			<cfif i LT listLen(arguments.criteria,' ')>) AND (</cfif>
		</cfloop>))
		</cfif>
		<cfif arguments.fontfamilyid neq 0>
		AND FONTFAMILYID = <cfqueryparam value="#arguments.fontfamilyid#">
		</cfif>
		<cfif arguments.fontfamilyname neq 0>
		AND FONTFAMILYNAME = <cfqueryparam value="#arguments.fontfamilyname#">
		</cfif>
		<cfif arguments.fontfamilydescription neq 0>
		AND FONTFAMILYDESCRIPTION like <cfqueryparam value="%#arguments.fontfamilydescription#%">
		</cfif>
		<cfif arguments.fontfamilylist neq 0>
		AND FONTFAMILYLIST like <cfqueryparam value="%#arguments.fontfamilylist#%">
		</cfif>
		<cfif arguments.sortlist neq 0>
		ORDER BY #arguments.sortlist#
		<cfelse>
		ORDER BY FONTFAMILYNAME
		</cfif>
		</cfquery>
	<cfreturn thisFontFamily>
	</cffunction>
	
	<cffunction name="getLayouts" access="public" output="false" returntype="query" hint="I get the font families you are searching for and return a recordset: LAYOUTID, TITLE, DESCRIPTION, FILENAME, SCREENSHOTPATH, LAYOUTNAME, LAYOUTDESCRIPTION, LAYOUTLINKNAME, AUTHORID">
	<cfargument name="ds" required="false" default="deltasystem" type="string" hint="Datasource to find colorschemes">
	<cfargument name="criteria" required="false" type="String" hint="generic search data" default="0">
	<cfargument name="layoutid" required="false" type="String" hint="I am the font family id you want me to find" default="0">
	<cfargument name="layoutname" required="false" type="string" hint="the LAYOUTNAME you are searching for" default="0">
	<cfargument name="layoutdescription" required="false" type="string" hint="the LAYOUTDESCRIPTION you are searching for" default="0">
	<cfargument name="layoutlinkname" required="false" type="string" hint="the list of the LAYOUTLINKNAME you are searching for" default="0">
	<cfargument name="sortlist" required="false" type="string" default="0" hint="I am the list of how you want to sort the results">
	<cfset var thisLayout=0>
		<cfquery name="thisLayout" datasource="#arguments.ds#">
		SELECT 
			LAYOUTID,
			LAYOUTNAME,
			LAYOUTDESCRIPTION,
			LAYOUTLINKNAME,
			AUTHORID
		FROM LAYOUT
		WHERE 1=1
		<cfif arguments.criteria neq 0>
		AND ((
		<cfloop from="1" to="#listLen(arguments.criteria,' ')#" index="i">
			LAYOUTNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR LAYOUTDESCRIPTION LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			OR LAYOUTLINKNAME LIKE <cfqueryparam value="%#listGetAt(arguments.criteria,i," ")#%">
			<cfif i LT listLen(arguments.criteria,' ')>) AND (</cfif>
		</cfloop>))
		</cfif>
		<cfif arguments.layoutid neq 0>
		AND LAYOUTID = <cfqueryparam value="#arguments.layoutid#">
		</cfif>
		<cfif arguments.layoutname neq 0>
		AND LAYOUTNAME like <cfqueryparam value="%#arguments.layoutname#%">
		</cfif>
		<cfif arguments.layoutdescription neq 0>
		AND LAYOUTDESCRIPTION like <cfqueryparam value="%#arguments.layoutdescription#%">
		</cfif>
		<cfif arguments.layoutlinkname neq 0>
		AND LAYOUTLINKNAME like <cfqueryparam value="%#arguments.layoutlinkname#%">
		</cfif>
		<cfif arguments.sortlist neq 0>
		ORDER BY #arguments.sortlist#
		<cfelse>
		ORDER BY LAYOUTNAME
		</cfif>
		</cfquery>
	<cfreturn thisLayout>
	</cffunction>
	
	<cffunction name="getClassicCSS" access="public" output="false" returntype="string">
		<cfargument name="templateid" type="string" required="false" default="4" hint="the id of the template you are going to use">
		<cfargument name="fontfamilyid" type="string" required="false" default="6" hint="the id of the fontfamily you are going to use">
		<cfargument name="colorschemeid" type="string" required="false" default="17" hint="the id of the colorscheme you are going to use">
		<cfset var thisClassicCss=0>
		<cfset var thisClassicFontFamily=0>
		<cfset var thisClassicColorScheme=0>
		<cfinvoke method="getFontFamily" fontfamilyid="#arguments.fontfamilyid#" returnvariable="thisClassicFontFamily">
		<cfinvoke method="getClassicColorSchemes" colorschemeID="#arguments.colorschemeID#" returnvariable="thisClassicColorScheme">
		<cfif arguments.templateid gt 6>
			<cfset arguments.templateid = 4>
		</cfif>
		<cfswitch expression="#arguments.templateid#">
			<cfcase value="1">
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">
						body { 
							margin: 5px; 
							font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
							font-size: 12px;
							padding: 0px;
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
						a:hover { text-decoration: none; }
						
						td { vertical-align: top; }
						
						#wrapper { 
							width: 944px; 
							margin: 0px auto;
							/* Border Accent 1 */
							border: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							padding: 2px;
							}
							
						ul li {
							padding-bottom: 3px;
							}
						
						#header {
							width: 944px;
							}
						
						#logo {
							width: 200px;
							float: left;
							font-weight: bold;
							margin-right: 2px;
							text-align: right;
							text-transform: uppercase;
							height: 100px;
							overflow:hidden;
							}
							
							#logo-text
							{
								width: 180px;
								float: left;
								padding:20px 10px 20px 10px;
								font-weight: bold;
								margin-right: 2px;
								text-align: right;
								text-transform: uppercase;
								height: 60px;
								overflow:hidden;
							}
						
						#logo-text h1 { margin: 0px;font-size: 18px; }
						#logo-text h6 { font-size: 10px; margin: 0px; }	
						
						#center { 
							width: 540px; 
							float: left; 
							height: 100px; 
							background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
							overflow:hidden;
							}
							
						#center-text { 
							width: 520px; 
							float: left; 
							padding:20px 10px 20px 10px;
							height: 60px; 
							background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
							overflow:hidden;
							}
						#center a, #center-text a {
							text-decoration:none;
						}
						
						#phone {
							float: right;
							width: 200px;
							text-align: right;
							font-size: 16px;
							height: 100px;
							font-weight: bold;
							overflow:hidden;
							}
							
						#phone-text {
							float: right;
							width: 180px;
							padding:20px 10px 20px 10px;
							text-align: right;
							font-size: 16px;
							height: 60px;
							font-weight: bold;
							overflow:hidden;
							}
							
						#logo, #phone, #logo-text, #phone-text {
							background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						#navigation { 
							clear: both; 
							width: 944px; 
							border-top: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							margin: 0;
							padding: 0px;
							}
						
						#navigation ul {
							list-style: none;
							padding: 0px;
							margin: 0px;
							}
							
						#navigation ul li {
							float: left;
							margin: 0px;
							padding: 0px;
							position: relative;
							}
							
						#navigation ul li a {
							display: block;
							padding: 7px 25px;
							margin: 0px;
							font-size: 12px;
							font-weight: bold;
							text-transform: uppercase;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							text-decoration: none;
							}
						
						#navigation ul li a:hover, #navigation ul li a.active {
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							text-decoration: underline;
							}
							
						#navigation li ul {
									position: absolute; 
									display: none;
									width: 154px;
									left: 0;
									margin: 0 0 0 -10px;
									padding: 0 0 11px 0;
								}
								
								#navigation li ul li {
									width: 154px;
									display: block;
						}
						
						.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
						
						#three-columns {
							margin: 2px 0px 0px 0px;
							padding: 0px;
							width: 944px;
							}
							
						#headlines, #subnav {
							width: 180px;
							vertical-align: top;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							padding: 10px;
							font-size: 12px;
							text-align: left;
							margin-right: 2px;
							overflow:hidden;
							word-wrap:break-word;
							}
							
						#headlines h3 {
							padding: 0px 0px 3px 0px;
							margin: 0px;
							}
							
						#subnav ul {
							margin: 0px;
							padding: 0px 0px 0px 15px;
							}
							
						#content-area {
							padding: 0px 10px 10px 10px;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							border-left: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							border-right: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							line-height: 18px;
							font-size: 12px;
							width: 520px;
							text-align: justify;
							overflow:hidden;
							word-wrap:break-word;
							}
						
						#content-area h1 {
							font-size: 12px;
							padding: 3px 10px;
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							font-weight: bold;
							text-transform: uppercase;
							}
							
						#content-area p img {
							padding: 0px 0px 5px 5px;
							}
						
						#footer {
							text-align: center;
							padding: 10px;
							background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						#footer a {
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							text-decoration: none;
							}
						
						#footer a:hover {
							text-decoration: underline;
							}
							
						#footer p {
							font-size: 11px;
							}
						
						#breadcrumbs {
							text-align: right;
							padding-top: 3px;
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						#footer p a:hover {
							text-decoration:none;
							}
						
						#footer p a {
							text-decoration:none;
							}
							
						#footer ul li a {
							padding: 3px;
						}
						
						#footer ul li {
							display: inline;
							list-style-type:none;
							}
						
						.slider dt {
									margin: 0px;
									padding: 8px 5px 8px 30px;
									background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
									color: #f9f9f9;
									}
									
						#theme .colors ul, #theme .layouts ul, #theme .fonts ul
						{
							list-style:none;
						}
						
						.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration #survey {
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input,  #registration select{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button{
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
							
					</style>
					<!---
					<!--[if lt IE 7]>
					<style type="text/css" media="screen">
					#phone { width: 180px; }
					#logo h1 { font-size: 14px; }
					</style>
					<![endif]--> 
					--->
				</cfsavecontent>
			</cfcase>
			<cfcase value="2">
				<cfsavecontent variable="thisClassicCss">
					 <style media="screen" type="text/css">
						body { 
							margin: 5px; 
							font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
							font-size: 12px;
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
						a:hover { text-decoration: none; }
						
						td { vertical-align: top; }
							
						#wrapper { 
							width: 784px; 
							margin: 0px auto;
							/* Border Accent 1 */
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
						#header {
							width: 784px;
							}
						
						#logo {
							width: 784px;
							float: left;
							font-weight: bold;
							margin-right: 2px;
							text-transform: uppercase;
							height: 165px;
							overflow:hidden;
							}
							
						#logo-text {
							width: 764px;
							padding: 80px 10px 20px 10px;
							float: left;
							font-weight: bold;
							margin-right: 2px;
							text-align: center;
							text-transform: uppercase;
							height: 65px;
							overflow:hidden;
						}
						
						#logo-text h1 { margin: 0px; padding: 0px; font-size: 18px; }
						#logo-text h6 { font-size: 10px; margin: 0px; padding: 0px; }	
							
						#header {
							background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							height: auto;
							}
							
						#navigation { 
							clear: both; 
							width: 784px; 
							border-top: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							}
						
						#navigation ul {
							list-style: none;
							padding: 0px;
							margin: 0px 0px 0px 5px;
							}
							
						#navigation ul li {
							float: left;
							margin: 0px;
							padding: 0px;
							position: relative;
							}
							
						#navigation ul li a {
							display: block;
							padding: 7px 15px;
							font-size: 12px;
							font-weight: bold;
							text-transform: uppercase;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							text-decoration: none;
							}
						
						#navigation ul li a:hover, #navigation ul li a.active {
							background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							text-decoration: underline;
							}
						
						#navigation li ul {
									position: absolute; 
									display: none;
									width: 154px;
									left: 0;
									margin: 0 0 0 -10px;
									padding: 0 0 11px 0;
								}
								
								#navigation li ul li {
									width: 154px;
									display: block;
						}
						
						.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
							
						#three-columns {
							margin-top: 2px;
							}
							
						#subnav {
							width: 200px;
							vertical-align: top;
							background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							margin-right: 2px;
							overflow:hidden;
							}
							
						#subnavlist a {
							color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							text-decoration: none;
							padding-bottom: 3px;
							}
							
						#subnavlist a:hover {
							text-decoration: underline;
							}
								
						.subnavList {
							border-bottom: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							padding: 10px;
							}
							
						.subnavList ul {
							margin: 0px;
							padding: 0px 0px 0px 15px;
							}
							
						.headline {
							float;right;
							padding: 10px 0px 0px 0px;
							word-wrap:break-word;
							}
							
						.headline a {
							font-weight: bold;
							}
							
						.headline h3 {
							margin: 0px;
							padding: 0px 0px 3px 0px;
							text-transform: uppercase;
							}
							
						#content-area {
							padding: 0px 10px;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							border: 1px solid rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							line-height: 18px;
							text-align: justify;
							width: 570px;
							margin: 0px 2px 1px 0px;
							word-wrap:break-word;
							}
						
						#content-area h1 {
							font-size: 18px;
							padding: 3px;
							color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
							font-weight: bold;
							text-transform: uppercase;
							}
							
						#content-area p img {
							padding: 0px 0px 5px 5px;
							}
						
						#footer {
							text-align: center;
							padding: 10px;
							background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							}
							
						#footer a {
							color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
							text-decoration: none;
							}
						
						#footer a:hover {
							text-decoration: underline;
							}
							
						#footer p {
							font-size: 11px;
							}
						
						#footer ul li a {
							padding: 3px;
						}
						
						#footer ul li {
							display: inline;
							list-style-type:none;
							}
						
						#breadcrumbs {
							text-align: right;
							padding-top: 3px;
							}
						
						.slider dt {
									margin: 0px;
									padding: 8px 5px 8px 30px;
									background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
									color: #f9f9f9;
									}
									
						#theme .colors ul, #theme .layouts ul, #theme .fonts ul
						{
							list-style:none;
						}	
						
						.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration, #survey{
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button {
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
					</style>
				</cfsavecontent>
			</cfcase>
			<cfcase value="3">
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">
					body { 
						margin: 15px 5px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						}
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
						
					#wrapper { 
						width: 944px; 
						margin: 0px auto;
						/* Border Accent 1 */
						padding: 2px;
						text-align: left;
						}
					
					#leftCol {
						float: left;
						width: 200px;
						}
						
					#middleCol {
						float: left;
						width: 484px;
						margin: 0px 15px;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 15px;
						text-align: justify;
						line-height: 18px;
						overflow:hidden;
						word-wrap:break-word;
						}
						
					#middleCol img {
						padding: 0px 0px 5px 5px;
						}
						
					#middleCol a img { padding: 0px; }
					
					#rightCol {
						float: left;
						width: 170px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 15px;
						}
						
					#footer {
						clear: both;
						text-align: center;
						padding: 15px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#footer a {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
					
					#logo {
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						margin: 0px;
						width:200px;
						height:100px;
						overflow:hidden;
						}
					
					#logo-text {
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						width:180px;
						height:60px;
						padding:20px 10px 20px 10px;
						overflow:hidden;
					}
					
					
					#logo-text h1 {
						font-size: 16px;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						font-weight: bold;
						text-transform: uppercase;
						margin: 0px;
						}
						
					#logo-text h1 b {
						color: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						}
					
					#logo-text h6 {
						font-size: 11px;
						text-transform: uppercase;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					#navigation {
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						margin: 15px 0px 0px 0px;
						padding: 15px 10px;
						}	
						
					#navigation ul {
						list-style: none;
						margin: 0px;
						padding: 0px 0px 0px 15px;
						}
						
					#navigation li a {
						display: block;
						padding: 2px 0px;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						font-weight: bold;
						text-transform: uppercase;
						font-size: 14px;
						text-decoration: none;
						}
						
					#navigation ul ul a {
						text-transform: none;
						border: 0px;
						font-size: 12px;
						font-weight: normal;
						padding: 5px 0px 5px 20px;
						margin: 0px;
						}
						
					#navigation ul a:hover {
						text-decoration: line-through;
						}
					
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
					
					#middleCol breadcrumbs {
						text-align: right;
						padding-bottom: 10px;
						}
					
					#middleCol h1 {
						font-size: 20px;
						text-transform: uppercase;
						padding: 0px;
						margin: 0px;
						}
						
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
						
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
					
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration #survey{
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button {
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
					</style>
				</cfsavecontent>
			</cfcase>
			<cfcase value="4">
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">
					body { 
						margin: 10px 5px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						}
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
						
					#wrapper { 
						width: 944px; 
						margin: 0px auto;
						padding: 0px;
						}
					
					.clear { clear: both; }
						
					#header {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						width:944px;
						}
					
					td { vertical-align: top; }
						
					#logo {
						width: 944px;
						height:100px;
						overflow:hidden;
						}
						
					#logo-text {
						text-transform: uppercase;
						text-align: center;
						width: 924px;
						height: 30px;
						padding: 10px 10px 30px 10px;
						overflow: hidden;
					}
					
					#logo-text a {
						text-decoration:none;
					}
					
						
					#breadcrumbs {
						text-align: right;
						margin: 0px;
						padding: 0px;
						}
						
					#navigation {
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						border-right: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 30px 20px;
						width: 158px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
						
					#navigation ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
						}
						
					#navigation ul li { margin: 0px; padding: 0px; }
						
					#navigation ul a {
						text-transform: uppercase;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						font-weight: bold;
						font-size: 13px;
						text-decoration: none;
						padding: 3px 15px;
						margin: 0px;
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						display: block;
						}
						
					#navigation ul a:hover {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#navigation ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 12px;
						font-weight: normal;
						padding: 5px 0px 5px 40px;
						margin: 0px;
						}
						
					#navigation ul ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 10px;
						font-weight: normal;
						padding: 5px 0px 5px 50px;
						margin: 0px;
						}
						
					#navigation ul ul a:hover {
						border: 0px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					#navigation ul ul {
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						padding: 4px 0px;
						}
						
					#content-news, #headline-td {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 30px 0px;
						line-height: 20px;
						text-align: justify;
						vertical-align: top;
						}
						
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
					
					#content-area {
						float: left;
						width: 495px;
						padding: 0px 20px;
						font-size: 12px;
						border-right: 1px solid rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						overflow:hidden;
						word-wrap:break-word;
						}
						
					#content-area h1 { color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); font-size: 20px; font-weight: bold;}
					
					#content-area img {
						padding: 0px 0px 5px 10px;
						}
					
					#photoGallery img { padding: 0px; }
					#photoGallery td { text-align: center; }
					
					#headline {
						float: left;
						padding: 0px 20px;
						width: 160px;
						font-size: 11px;
						text-align: left;
						word-wrap:break-word;
						}
						
					#headline ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
					}
					
						
					#headline h3 {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-size: 14px;
						font-weight: bold;
						text-transform: uppercase;
						padding: 0px;
						margin: 0px;
						}
						
					#headline a {
						font-weight: bold;
						text-decoration: none;
						}
					
					#headline a:hover {
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					#footer {
						text-align: center;
						padding: 15px;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
						
					#footer a { color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); }
					#footer a:hover { text-decoration: none; }
					
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
						
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
						
					#breadcrumbs a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration, #survey{
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button{
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
							
					</style>
				</cfsavecontent>
			</cfcase>
			<cfcase value="5">
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">

					body { 
						margin: 0px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
						
					td { vertical-align: top; }
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
						
					#wrapper { 
						width: 784px; 
						margin: 0px auto;
						/* Border Accent 1 */
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 2px;
						}
					#header {
						width: 784px;
						padding-bottom: 2px;
						}
					
					#logo {
						width: 200px;
						float: left;
						height: 100px;
						overflow:hidden;
						}
						
					#logo-text {
						width: 169px;
						float: left;
						font-weight: bold;
						margin-right: 2px;
						padding-right: 31px;
						text-align: right;
						padding-top: 20px;
						text-transform: uppercase;
						height: 80px;
						overflow:hidden;
						}
					
					#logo h1 { margin: 0px; padding: 0px; font-size: 18px; }
					#logo h6 { font-size: 10px; margin: 0px; padding: 0px; }	
					
					#center { width: 540px; float: left; height: 100px; background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>); }
					
					#phone-text {
						float: right;
						width: 180px;
						text-align: right;
						font-size: 16px;
						height: 80px;
						font-weight: bold;
						padding: 20px 20px 0px 0px;
						}
						
					#phone {
						float: right;
						width: 200px;
						height: 100px;
						overflow:hidden;
						}
						
					#header {
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						height: 100px;
						}
						
					#header {
						width: 784px;
						margin: 0px auto;
						}
						
					#navigation { 
						clear: both; 
						background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						}
					
					#navigation ul {
						list-style: none;
						padding: 0px;
						width: 784px;
						margin: 0px auto;
						}
						
					#navigation ul li {
						float: left;
						margin: 0px;
						padding: 0px;
						position: relative;
						}
						
					#navigation ul li a {
						display: block;
						padding: 7px 15px;
						font-size: 12px;
						font-weight: bold;
						text-transform: uppercase;
						background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						text-decoration: none;
						}
					
					#navigation ul li a:hover, #navigation ul li a.active {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						text-decoration: underline;
						}
						
					#navigation li ul {
								position: absolute; 
								display: none;
								width: 154px;
								left: 0;
								margin: 0 0 0 -10px;
								padding: 0 0 11px 0;
							}
							
							#navigation li ul li {
								width: 154px;
								display: block;
					}
					
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
						
					#three-columns {
						margin-top: 2px;
						}
						
					#subnav {
						width: 200px;
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						margin-right: 2px;
						}
						
					#subnav a {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						text-decoration: none;
						padding-bottom: 3px;
						}
						
					#subnav a:hover {
						text-decoration: underline;
						}
							
					.subnavList {
						padding: 10px;
						}
						
					.subnavList ul {
						margin: 0px;
						padding: 0px 0px 0px 15px;
						}
						
					.headline {
						padding: 10px;
						text-align: left;
						}
						
					.headline a {
						font-weight: bold;
						}
						
					.headline h3 {
						margin: 0px;
						padding: 0px 0px 3px 0px;
						text-transform: uppercase;
						}
						
					#main-area {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#three-columns {
						width: 784px;
						margin: 0px auto;
						}
						
					#content-text {
						width: 784px;
						margin: 0px auto;
						}
						
					#subnav {
						border-top: 20px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-bottom: 20px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					table { font-size: 12px; }
						
					#content-area {
						padding: 0px 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						line-height: 18px;
						text-align: justify;
						margin: 0px
						}
					
					#content-area h1 {
						font-size: 18px;
						padding: 3px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-weight: bold;
						text-transform: uppercase;
						}
						
					#content-area p img {
						padding: 0px 0px 5px 5px;
						}
					
					#footer {
						text-align: center;
						padding: 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#footer a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						text-decoration: none;
						}
					
					#footer a:hover {
						text-decoration: underline;
						}
						
					#footer p {
						font-size: 11px;
						}
					
					#breadcrumbs {
						text-align: right;
						padding-top: 3px;
						}
						
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
						
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
					
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration, #survey{
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button{
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
					</style>
				</cfsavecontent>
			</cfcase>
			<cfcase value="6">
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">
					.yui-calendar td.calcell.calcellhover a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
					}
					
					body { 
						margin: 0px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
					
					td { vertical-align: top; }
					
					#wrapper { 
						width: 784px; 
						margin: 0px auto;
						/* Border Accent 1 */
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 2px;
						}
					
					#logo-text {
						width: 180px;
						float: left;
						font-weight: bold;
						margin-right: 2px;
						padding-left: 5px;
						padding-right: 15px;
						text-align: right;
						padding-top: 20px;
						text-transform: uppercase;
						height: 80px;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						margin-top: 10px;
						overflow:hidden;
						}
						
					#logo {
						width: 185px;
						float: left;
						font-weight: bold;
						margin-right: 2px;
						padding-right: 15px;
						text-align: right;
						text-transform: uppercase;
						height: 100px;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						overflow:hidden;
						}
					
					#logo-text h1 { margin: 0px; padding: 0px; font-size: 18px; }
					#logo-text h6 { font-size: 10px; margin: 0px; padding: 0px; }	
					
					#center { width: 540px; float: left; height: 100px; background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>); }
					
					#phone-text {
						float: right;
						width: 180px;
						text-align: right;
						font-size: 16px;
						height: 80px;
						font-weight: bold;
						padding: 20px 20px 0px 0px;
						overflow:hidden;
						}
						
					#phone {
						float: right;
						width: 167px;
						height: 100px;
						overflow:hidden;
						}
						
					#header {
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						height: 100px;
						width: 910px;
						margin: 0px auto;
						overflow:hidden;
						}
						
					#navigation {
						vertical-align: top;
						text-align: left;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						padding: 30px 20px;
						width: 158px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#navigation ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
						}
						
					#navigation ul a {
						text-transform: uppercase;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						font-weight: bold;
						font-size: 14px;
						text-decoration: none;
						padding: 3px 15px;
						border-left: 5px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						display: block;
						}
						
					#navigation ul a:hover {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						border-left: 5px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#navigation ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 12px;
						font-weight: normal;
						padding-left: 40px;
						}
						
						#navigation ul ul ul  a{
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 10px;
						font-weight: normal;
						padding-left: 50px;
						}
						
					#navigation ul ul a:hover {
						border: 0px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					#navigation ul ul {
						padding: 4px 0px;
						}
						
					#three-columns {
						font-size: 12px;
						/*margin-top: 2px;*/
						}
						
					#subnav {
						width: 200px;
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						margin-right: 2px;
						}
					
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
						
					#subnav a {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						text-decoration: none;
						padding-bottom: 3px;
						}
						
					#subnav a:hover {
						text-decoration: underline;
						}
							
					.subnavList {
						padding: 10px;
						}
						
					.subnavList ul {
						margin: 0px;
						padding: 0px 0px 0px 15px;
						}
						
					.headline {
						padding: 20px 10px 10px 20px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						width: 130px;
						text-align: left;
						vertical-align: top;
						font-size: 11px;
						word-wrap:break-word;
						}
						
					.headline a {
						font-weight: bold;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
						
					.headline h3 {
						margin: 0px;
						padding: 0px 0px 3px 0px;
						text-transform: uppercase;
						font-size: 13px;
						font-weight: bold;
						}
						
					#main-area {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						border-bottom: 10px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#three-columns {
						width: 910px;
						margin: 0px auto;
						}
						
					#content-text {
						width: 910px;
						margin: 0px auto;
						}
						
					#subnav {
						border-top: 0px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-bottom: 20px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#content {
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#content-area {
						padding: 10px 0px 10px 20px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						line-height: 18px;
						text-align: justify;
						margin: 0px;
						width: 510px;
						overflow:hidden;
						word-wrap:break-word;
						}
					
					#content-area h1 {
						font-size: 18px;
						padding: 3px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-weight: bold;
						text-transform: uppercase;
						}
						
					#content-area p img {
						padding: 0px 0px 5px 5px;
						}
					
					#footer {
						text-align: center;
						padding: 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#footer a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						text-decoration: none;
						}
					
					#footer a:hover {
						text-decoration: underline;
						}
						
					#footer p {
						font-size: 11px;
						}
					
					#breadcrumbs {
						text-align: right;
						padding-top: 3px;
						}
						
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
						
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
					
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					.form {
							margin:0px;
							padding:14px; 
						}
							#login, #contact, #registration #survey{
								width:400px;
								background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
							}
							
							#login h1, #contact h1, #registration h1{
								font-size:14px;
								font-weight:bold;
								margin-bottom:20px;
								margin-top:20px;
							}
							
							#login p, #contact p, #registration p {
								font-size: 11px;
								margin-bottom:20px;
								border-bottom: solid 1px;
								padding-bottom: 10px;
							}	
							
							#login label, #contact label, #registration label {
								display:block;
								font-weight:bold;
								text-align:right;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:140px;
								float:left;
							}
							
							#login .small, #contact .small, #registration .small {
								display:block;
								font-size:11px;
								font-weight:normal;
								text-align:right;
								width:140px;								
							}
							
							#login input, #contact input, #registration input {
								font-size:12px;
								padding:4px 2px;
								width:200px;
								margin: 2px 0 20px 10px;
							}
							
							#login button, #contact button, #registration button {
								clear:both;
								margin-left:150px;
								width:125px;
								height:31px;
								text-align:center;
							}
							
							#survey button {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#login .foot{
								clear:both;
								text-align:center;
							}
							
							#login .foot a {
								padding-left:20px;
								text-decoration:none;
							}
							
							#contact textarea, #survey textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:200px;
								height:150px;
								margin: 2px 0 20px 10px;
							}
							
							#contact .captcha-info, #registration .captcha-info {
								font-size: 11px;
								margin-bottom:20px;
								padding-bottom: 10px;
							}
							
							#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
							#forward input{
								font-size:12px;
								width:170px;
								padding:4px 2px;
							}
							
							#forward textarea
							{
								font-size:12px;
								padding:4px 2px;
								width:170px;
								height:190px;	
							}
							
							.submit input {
								clear:both;
								margin-left:0px;
								width:125px;
								height:31px;
								text-align:center
							}
							
							#box {
								margin-bottom:10px;
								width: auto;
								padding:10px;
								border:solid 1px #DEDEDE;
								background: #FFFFCC;
								display:none;
							}
					</style>
				</cfsavecontent>
			</cfcase>
			<cfdefaultcase>
				<cfsavecontent variable="thisClassicCss">
					<style media="screen" type="text/css">
					body { 
						margin: 10px 5px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						}
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
						
					#wrapper { 
						width: 944px; 
						margin: 0px auto;
						padding: 0px;
						}
					
					.clear { clear: both; }
						
					#header {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					td { vertical-align: top; }
						
					#header h1 {
						font-size: 20px;
						font-weight: bold;
						margin: 0px;
						padding: 0px;
						}
					
					#header h6 {
						font-size: 10px;
						margin: 0px;
						padding: 0px;
						}
					
					#logo {
						float: left;
						text-transform: uppercase;
						text-align: right;
						width: 180px;
						}
						
					#logo-text {
						float: left;
						text-transform: uppercase;
						text-align: right;
						width: 180px;
						padding: 30px 25px;	
						}
						
					#phone {
						float: right;
						padding: 20px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
					#phone h1 {
						padding-bottom: 20px;
						}
						
					#breadcrumbs {
						text-align: right;
						margin: 0px;
						padding: 0px;
						}
						
					#navigation {
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						border-right: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 30px 20px;
						width: 158px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
												
					#navigation ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
						}
						
					#navigation ul li { margin: 0px; padding: 0px; }
						
					#navigation ul a {
						text-transform: uppercase;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						font-weight: bold;
						font-size: 13px;
						text-decoration: none;
						padding: 3px 15px;
						margin: 0px;
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						display: block;
						}
						
					#navigation ul a:hover {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#navigation ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 12px;
						font-weight: normal;
						padding: 5px 0px 5px 40px;
						}
						
					#navigation ul ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 10px;
						font-weight: normal;
						padding: 5px 0px 5px 50px;
						margin: 0px;
						}
						
					#navigation ul ul a:hover {
						border: 0px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					#navigation ul ul {
						padding: 4px 0px;
						}
					
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
						
					#content-news, #headline-td {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 30px 0px;
						line-height: 20px;
						text-align: justify;
						vertical-align: top;
						}
					
					#content-area {
						float: left;
						width: 495px;
						padding: 0px 20px;
						font-size: 12px;
						border-right: 1px solid rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					#content-area h1 { color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); font-size: 20px; font-weight: bold;}

						
					#content-area img {
						padding: 0px 0px 5px 10px;
						}
					
					#photoGallery img { padding: 0px; }
					#photoGallery td { text-align: center; }
					
					#headline {
						float: left;
						padding: 0px 20px;
						width: 160px;
						font-size: 11px;
						text-align: center;
						}
						
					#headline ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
					}
					
						
					#headline h3 {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-size: 14px;
						font-weight: bold;
						text-transform: uppercase;
						padding: 0px;
						margin: 0px;
						}
						
					#headline a {
						font-weight: bold;
						text-decoration: none;
						}
					
					#headline a:hover {
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					#footer {
						text-align: center;
						padding: 15px;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
						
					#footer a { color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); }
					#footer a:hover { text-decoration: none; }
					
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
					
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
						
					#breadcrumbs a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					#forward label {
								display:block;
								font-weight:bold;
								text-align:left;
								color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
								width:180px;
								float:left;
								margin: 2px 0 20px 10px;
							}
							
					#forward input{
						font-size:12px;
						width:170px;
						padding:4px 2px;
					}
					
					.submit input {
						clear:both;
						margin-left:0px;
						width:125px;
						height:31px;
						text-align:center
					}
					
					#box {
							margin-bottom:10px;
							width: auto;
							padding:10px;
							border:solid 1px #DEDEDE;
							background: #FFFFCC;
							display:none;
						}
					</style>
				</cfsavecontent>
			</cfdefaultcase>
		</cfswitch>
	<cfreturn thisClassicCss>
	</cffunction>
	
	<cffunction name="getCss" access="public" returntype="string" hint="I get css without enclosing style. The output should be written into a file">
		<cfargument name="templateid" type="string" required="false" default="4" hint="the id of the template you are going to use">
		<cfargument name="fontfamilyid" type="string" required="false" default="6" hint="the id of the fontfamily you are going to use">
		<cfargument name="colorschemeid" type="string" required="false" default="17" hint="the id of the colorscheme you are going to use">
		<cfset var thisClassicCss=0>
		<cfset var thisClassicFontFamily=0>
		<cfset var thisClassicColorScheme=0>
		<cfinvoke method="getFontFamily" fontfamilyid="#arguments.fontfamilyid#" returnvariable="thisClassicFontFamily">
		<cfinvoke method="getClassicColorSchemes" colorschemeID="#arguments.colorschemeID#" returnvariable="thisClassicColorScheme">
		<cfif listfindnocase('1,4',arguments.templateid)>
			<cfset arguments.templateid = 4>
		</cfif>
		<cfswitch expression="#arguments.templateid#">
			<cfcase value="1">
				<cfsavecontent variable="thiscss">
					body { 
						margin: 5px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						padding: 0px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
					
					td { vertical-align: top; }
					
					#wrapper { 
						width: 944px; 
						margin: 0px auto;
						/* Border Accent 1 */
						border: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 2px;
						}
						
					ul li {
						padding-bottom: 3px;
						}
					
					#header {
						width: 944px;
						}
					
					#logo {
						width: 200px;
						float: left;
						font-weight: bold;
						margin-right: 2px;
						text-align: right;
						text-transform: uppercase;
						height: 100px;
						overflow:hidden;
						}
						
						#logo-text
						{
							width: 180px;
							float: left;
							padding:20px 10px 20px 10px;
							font-weight: bold;
							margin-right: 2px;
							text-align: right;
							text-transform: uppercase;
							height: 60px;
							overflow:hidden;
						}
					
					#logo-text h1 { margin: 0px;font-size: 18px; }
					#logo-text h6 { font-size: 10px; margin: 0px; }	
					
					#center { 
						width: 540px; 
						float: left; 
						height: 100px; 
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						overflow:hidden;
						}
						
					#center-text { 
						width: 520px; 
						float: left; 
						padding:20px 10px 20px 10px;
						height: 60px; 
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						overflow:hidden;
						}
					#center a, #center-text a {
						text-decoration:none;
					}
					
					#phone {
						float: right;
						width: 200px;
						text-align: right;
						font-size: 16px;
						height: 100px;
						font-weight: bold;
						overflow:hidden;
						}
						
					#phone-text {
						float: right;
						width: 180px;
						padding:20px 10px 20px 10px;
						text-align: right;
						font-size: 16px;
						height: 60px;
						font-weight: bold;
						overflow:hidden;
						}
						
					#logo, #phone, #logo-text, #phone-text {
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#navigation { 
						clear: both; 
						width: 944px; 
						border-top: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						margin: 0;
						padding: 0px;
						}
					
					#navigation ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
						}
						
					#navigation ul li {
						float: left;
						margin: 0px;
						padding: 0px;
						position: relative;
						}
						
					#navigation ul li a {
						display: block;
						padding: 7px 25px;
						margin: 0px;
						font-size: 12px;
						font-weight: bold;
						text-transform: uppercase;
						background: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						text-decoration: none;
						}
					
					#navigation ul li a:hover, #navigation ul li a.active {
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						text-decoration: underline;
						}
						
					#navigation li ul {
								position: absolute; 
								display: none;
								width: 154px;
								left: 0;
								margin: 0 0 0 -10px;
								padding: 0 0 11px 0;
							}
							
							#navigation li ul li {
								width: 154px;
								display: block;
					}
					
					.rss {
						margin: 5px 0px 0px -5px; 
						padding: 5px 25px;
						background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
						}
					
					#three-columns {
						margin: 2px 0px 0px 0px;
						padding: 0px;
						width: 944px;
						}
						
					#headlines, #subnav {
						width: 180px;
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						padding: 10px;
						font-size: 12px;
						text-align: left;
						margin-right: 2px;
						overflow:hidden;
						word-wrap:break-word;
						}
						
					#headlines h3 {
						padding: 0px 0px 3px 0px;
						margin: 0px;
						}
						
					#subnav ul {
						margin: 0px;
						padding: 0px 0px 0px 15px;
						}
						
					#content-area {
						padding: 0px 10px 10px 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						border-left: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						border-right: 2px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						line-height: 18px;
						font-size: 12px;
						width: 520px;
						text-align: justify;
						overflow:hidden;
						word-wrap:break-word;
						}
					
					#content-area h1 {
						font-size: 12px;
						padding: 3px 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-weight: bold;
						text-transform: uppercase;
						}
						
					#content-area p img {
						padding: 0px 0px 5px 5px;
						}
					
					#footer {
						text-align: center;
						padding: 10px;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#footer a {
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						text-decoration: none;
						}
					
					#footer a:hover {
						text-decoration: underline;
						}
						
					#footer p {
						font-size: 11px;
						}
					
					#breadcrumbs {
						text-align: right;
						padding-top: 3px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
						
					#footer ul li a {
						padding: 3px;
					}
					
					#footer ul li {
						display: inline;
						list-style-type:none;
						}
					
					.slider dt {
								margin: 0px;
								padding: 8px 5px 8px 30px;
								background: #ccc url(http://alpha.qdcms.com/siteimages/sliderInactive.gif) no-repeat;
								color: #f9f9f9;
								}
								
					#theme .colors ul, #theme .layouts ul, #theme .fonts ul
					{
						list-style:none;
					}
					
					.form {
						margin:0px;
						padding:14px; 
					}
						#login, #contact, #registration #survey {
							width:400px;
							background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						}
						
						#login h1, #contact h1, #registration h1{
							font-size:14px;
							font-weight:bold;
							margin-bottom:20px;
							margin-top:20px;
						}
						
						#login p, #contact p, #registration p {
							font-size: 11px;
							margin-bottom:20px;
							border-bottom: solid 1px;
							padding-bottom: 10px;
						}	
						
						#login label, #contact label, #registration label {
							display:block;
							font-weight:bold;
							text-align:right;
							color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							width:140px;
							float:left;
						}
						
						#login .small, #contact .small, #registration .small {
							display:block;
							font-size:11px;
							font-weight:normal;
							text-align:right;
							width:140px;								
						}
						
						#login input, #contact input, #registration input,  #registration select{
							font-size:12px;
							padding:4px 2px;
							width:200px;
							margin: 2px 0 20px 10px;
						}
						
						#login button, #contact button, #registration button{
							clear:both;
							margin-left:150px;
							width:125px;
							height:31px;
							text-align:center;
						}
						
						#survey button {
							clear:both;
							margin-left:0px;
							width:125px;
							height:31px;
							text-align:center
						}
						
						
						#login .foot{
							clear:both;
							text-align:center;
						}
						
						#login .foot a {
							padding-left:20px;
							text-decoration:none;
						}
						
						#contact textarea, #survey textarea {
							font-size:12px;
							padding:4px 2px;
							width:200px;
							height:150px;
							margin: 2px 0 20px 10px;
						}
						
						#contact .captcha-info, #registration .captcha-info {
							font-size: 11px;
							margin-bottom:20px;
							padding-bottom: 10px;
						}
						
						#forward label {
							display:block;
							font-weight:bold;
							text-align:left;
							color:rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
							width:180px;
							float:left;
							margin: 2px 0 20px 10px;
						}
						
						#forward input{
							font-size:12px;
							width:170px;
							padding:4px 2px;
						}
						
						#forward textarea
						{
							font-size:12px;
							padding:4px 2px;
							width:170px;
							height:190px;	
						}
						
						.submit input {
							clear:both;
							margin-left:0px;
							width:125px;
							height:31px;
							text-align:center
						}
						
						#box {
							margin-bottom:10px;
							width: auto;
							padding:10px;
							border:solid 1px #DEDEDE;
							background: #FFFFCC;
							display:none;
						}
				</cfsavecontent>
			</cfcase>
		
			<cfcase value="4">
				<cfsavecontent variable="thiscss">
					body { 
						margin: 10px 5px; 
						font-family: <cfoutput>#thisClassicFontFamily.fontfamilylist#</cfoutput>;
						font-size: 12px;
						background: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						}
						
					a { color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>); }
					a:hover { text-decoration: none; }
						
					#wrapper { 
						width: 944px; 
						margin: 0px auto;
						padding: 0px;
						}
					
					.clear { clear: both; }
						
					#header {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						width:944px;
						}
					
					table.page-content tbody tr td {
						margin: 0;
					}	
					
					td { vertical-align: top; }
					
					#header h1 {
					font-size: 20px;
					font-weight: bold;
					margin: 0px;
					padding: 0px;
					}
				
					#header h6 {
						font-size: 10px;
						margin: 0px;
						padding: 0px;
						}
					
					#header-image {
						width:944px;
						text-align:center;
						overflow:hidden;
						}
					
					#header-image img {
						padding: 0px;
						border: 0px;
						}
						
					#logo {
						float:left;
						text-transform: uppercase;
						text-align:right;
						width: 180px;
						padding: 30px 25px;
						}
					
					#phone {
						float: right;
						padding: 20px;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>)
					}
					
					#phone h1 {
						padding-bottom: 20px;
					}
											
					#navigation {
						vertical-align: top;
						background: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						border-right: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 30px 20px;
						width: 158px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
						
					#navigation ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
						}
						
					#navigation ul li { margin: 0px; padding: 0px; }
						
					#navigation ul a {
						text-transform: uppercase;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						font-weight: bold;
						font-size: 13px;
						text-decoration: none;
						padding: 3px 15px;
						margin: 0px;
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						display: block;
						}
						
					#navigation ul a:hover {
						background: rgb(<cfoutput>#thisClassicColorScheme.secondary#</cfoutput>);
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
						
					#navigation ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 12px;
						font-weight: normal;
						padding: 5px 0px 5px 40px;
						margin: 0px;
						}
						
					#navigation ul ul ul a {
						text-transform: none;
						color: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border: 0px;
						font-size: 10px;
						font-weight: normal;
						padding: 5px 0px 5px 50px;
						margin: 0px;
						}
						
					#navigation ul ul a:hover {
						border: 0px;
						color: rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						}
					
					#navigation ul ul {
						border-bottom: 1px solid rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						padding: 4px 0px;
						}
						
					#content-news, #headline-td {
						background: rgb(<cfoutput>#thisClassicColorScheme.accent2#</cfoutput>);
						border-top: 10px solid rgb(<cfoutput>#thisClassicColorScheme.backgroundcolor#</cfoutput>);
						padding: 5px 0px;
						line-height: 20px;
						text-align: justify;
						vertical-align: top;
						}
						
					.rss {
							margin: 5px 0px 0px -5px; 
							padding: 5px 25px;
							background: url(http://quantumdelta.com/siteimages/rss.gif) no-repeat 0px 5px;
							}
					
					#content-area {
						float: left;
						width: 495px;
						padding: 0px 20px;
						font-size: 12px;
						border-right: 1px solid rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						overflow:hidden;
						word-wrap:break-word;
						}
					
					#content-area #breadcrumbs {
						padding-top: 10px;
						text-align: right;
						}
					#content-area #breadcrumbs a {
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}	
					
					#content-area img {
						padding: 0px 0px 5px 10px;
						border: 0px;
						}
					
					#content-area h1 { 
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); 
						font-size: 20px; 
						font-weight: bold;
						}
										
					#headline {
						float: left;
						padding: 10px 20px;
						width: 160px;
						font-size: 11px;
						text-align: left;
						word-wrap:break-word;
						}
						
					#headline ul {
						list-style: none;
						padding: 0px;
						margin: 0px;
					}
					
						
					#headline h3 {
						color: rgb(<cfoutput>#thisClassicColorScheme.accent1#</cfoutput>);
						font-size: 14px;
						font-weight: bold;
						text-transform: uppercase;
						padding: 0px;
						margin: 0px;
						}
						
					#headline a {
						font-weight: bold;
						text-decoration: none;
						}
					
					#headline a:hover {
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
					
					#footer {
						text-align: center;
						padding: 15px;
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>);
						}
						
					#footer a { 
						color: rgb(<cfoutput>#thisClassicColorScheme.primarycolor#</cfoutput>); 
						}
						
					#footer a:hover { text-decoration: none; }
					
					#footer p a:hover {
						text-decoration:none;
						}
					
					#footer p a {
						text-decoration:none;
						}
					
					.photo-container {
						width: 120px;
						height: 100px;
						float: left;
						text-align: center;
						}
						
					.no-border{
						border: none;
						}
						
					.slideshow-container{
						text-align:center;
						width:480px;
						height:580px;
						}
					
					.form-container label {
						float: left;
						width: 135px;
						text-align: right;
						padding-top: 5px;
						padding-right: 10px;
						font-weight: bold;
						margin-bottom: 5px;
						}
						
					.form-container label.checkbox{
						width: 100%;
						text-align: left;
						}
						
					.form-container em {
						color: #880000; 
						width: 10px;
						}
						
					.form-container input, #form-container select {
						margin-bottom: 5px;
						float: left;
						}
						
					.form-container .checkbox-div label.checkbox {
						width: 100px;
						float: left;
						font-weight: normal;
						text-align: right;
						}
						
					.text-box {
						width: 126px;
						float: left;
						}
						
					.checkbox-div {
						float: left;
						}	
					
					.form-container input.checkbox {
						float: none;
						margin: 2px 0px 0px 0px;
						}
					
					.form-container textarea {
						width:280px;
						height:120px;
						float: left;
						}
						
					.form-container br {
						clear: both;
						}
					
					input.submit {
						margin-left: 153px;
						margin-top: 10px;
						}
					
					#forward label {
						width: 180px;
						float: left;
						padding: 10px;
						margin: 2px 0 20px 10px;
						}
					
					#forward input{
						width: 180px;
						padding: 4px 2px;
						}
					
					#forward textarea {
						width: 180px;
						height: 190px;
						padding: 4px 2px;	
						}
					
					.submit input {
						clear: both;
						margin-left: 0px;
						width: 125px;
						height: 31px;
						text-align: center;
						}
				</cfsavecontent>
			</cfcase>
		</cfswitch>
	<cfreturn thiscss>
	</cffunction>
	
	<cffunction name="getImageBackgroundColor" access="public" returntype="string" hint="I return hex value of color that should be background color for image thumbs">
		<cfargument name="colorschemeid" required="true" type="string" hint="Color Scheme Id">
		<cfset var get=0>
		<cfset var r=0>
		<cfset var g=0>
		<cfset var b=0>
		<cfquery name="get" datasource="deltasystem">
			SELECT ACCENT2COLOR
			FROM COLORSCHEME
			WHERE COLORSCHEMEID=<cfqueryparam value="#arguments.colorschemeid#">
		</cfquery>
		<cfset r=formatBaseN(listfirst(get.ACCENT2COLOR),16)>
		<cfset g=formatBaseN(listGetAt(get.ACCENT2COLOR,2),16)>
		<cfset b=formatBaseN(listlast(get.ACCENT2COLOR),16)>
		<cfif len(r) EQ 1>
			<cfset r="#r##r#">
		</cfif>
		<cfif len(g) EQ 1>
			<cfset g="#g##g#">
		</cfif>
		<cfif len(b) EQ 1>
			<cfset b="#b##b#">
		</cfif>
		<cfset imagegbackgroundcolor="#r##g##b#">
		<cfreturn imagegbackgroundcolor>
	</cffunction>
</cfcomponent>