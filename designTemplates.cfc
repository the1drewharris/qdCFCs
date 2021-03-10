<cfcomponent hint="I have template designs">
	<cffunction name="getTemplate" access="public" returntype="string" output="false" hint="I return design templates">
		<cfargument name="name" type="string" required="true" hint="Usually, name of the site">
		<cfargument name="phone" type="string" required="false" default="123-456-7890" hint="Phone number of the company">
		<cfargument name="templateid" type="string" required="false" default="4" hint="Id of the template">
		<cfargument name="fontfamilyid" type="string" required="false" hint="font family id">
		<cfargument name="colorschemeid" type="string" required="false" hint="color scheme id">
		
		<cfif arguments.templateid GT 6>
			<cfset arguments.templateid=4>
		</cfif>
		
		<cfinvoke component="designTemplatesCss" method="getClassicCSS" returnvariable="mycss" argumentcollection="#arguments#">
		
		<cfswitch expression="#arguments.templateid#">
			<cfcase value="1">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
						<html xmlns="http://www.w3.org/1999/xhtml">
						<head>
						<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
							<script type="text/javascript" src="http://quantumdelta.com/js/autoclear.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2.1-core.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2-more.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/lib/simpleDropDown.js"></script>
						<title><cfoutput><cf_pagetitle> - #arguments.name#</cfoutput></title>
						<!--- <cfinclude template="/css/template1.cfm">
						<cfinclude template="/css/calendar.cfm">
						<cfinclude template="themepicker.cfm"> --->
						<cfoutput>#mycss#</cfoutput>
						<center>
						<div id="wrapper">
							<div id="header">
								<div id="logo">
									<!--- <h1><cf_sitename></h1>
									<h6><cf_sitetitle></h6> --->
								</div>
								<div id="center">
								
								</div>
								<div id="phone">
									<cfoutput>#arguments.phone#</cfoutput>
								</div>
							</div>
							<div id="navigation">
								<cf_navigation id="nav" excludeList="site map">
								<div style="clear: both;margin: 0px; padding: 0px;"></div>
							</div>
							<table cellspacing="0" cellpadding="0" id="three-columns">
							<tr>
								<td id="headlines">
									<!--- <cfinclude template="calendar-event.cfm"> --->
								</td>
								<td id="content-area">
								<div id="breadcrumbs">
									<cf_breadcrumbs>
								</div>
									<!--- <cfinclude template="content-include.cfm">	 --->
									<cf_content>
								</td>
								<td id="subnav">
								<!--- <p><cf_subnavigation></p> --->
								<!--- <p><cfinclude template="/blog/layout/simple-listing.cfm"></p> --->
								</td>
							</tr>
							</table>
							<div id="footer">
								<cf_navigation display="delim" delim="|" id="footerNav">
								<p><a href="http://quantumdelta.com" target="_blank" >Powered by QuantumDelta</a> <cf_copyright></p>
							</div>
						  </div>
						</div>
						</center>
						</body>
						</html>
				</cfsavecontent>
			</cfcase>
			<cfcase value="2">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
					<script type="text/javascript" src="http://quantumdelta.com/js/autoclear.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2.1-core.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2-more.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/lib/simpleDropDown.js"></script>
					<title><cfoutput><cf_pagetitle> - #arguments.name#</cfoutput></title>
					<!--- <cfinclude template="/css/template2.cfm">
					<cfinclude template="/css/calendar.cfm">
					<cfinclude template="themepicker.cfm"> --->
					<cfoutput>#mycss#</cfoutput>
					<center>
					<div id="wrapper">
						<div id="header">
							<div id="logo">
								<!--- <h1><cf_sitename></h1>
								<h6><cf_sitetitle></h6> --->
							</div>
					
							<div id="phone">
								<cfoutput>#arguments.phone#</cfoutput>
							</div>
							<div style='clear: both;'></div>
						</div>
						<div id="navigation">
							<cf_navigation id="nav" excludeList="site map">
							<div style="clear: both;"></div>
						</div>
						<table cellspacing="0" cellpadding="0" id="three-columns">
						<tr>
							<td id="content-area">
							<div id="breadcrumbs">
							<!--- <cfinclude template="breadcrumbs-include.cfm"> --->
							<cf_breadcrumbs>
							</div>
							<!--- <cfinclude template="content-include.cfm"> --->
							<cf_content>
							</td>
							<td style="width: 2px;"> </td>
							<td id="subnav">
								<div class="subnavList">
								<!--- <cf_subnavigation> --->
								</div>
								<div class="headline">
									<!--- <cfinclude template="calendar-event.cfm"> --->
								</div>
							</td>
						</tr>
						<tr><td colspan="3" height="1"></td></tr>
						</table>
						<div id="footer">
							<cf_navigation display="delim" delim="|" id="footerNav">
						<p>
						Powered by Quantum Delta <cf_copyright>
						</p>
						</div>
						</div>
					</div>
					</center>
					<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
					</script>
					<script type="text/javascript">
					_uacct = "UA-2623947-11";
					urchinTracker();
					</script>
					</body>
					</html>
				</cfsavecontent>
			</cfcase>
			<cfcase value="3">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
					
					<title><cfoutput><cf_pagetitle> - #arguments.name#</cfoutput></title>
					<!--- <cfinclude template="/css/template3.cfm">
					<cfinclude template="/css/calendar.cfm">
					<cfinclude template="themepicker.cfm"> --->
					<cfoutput>#mycss#</cfoutput>
					<center>
					<div id="wrapper">
						<div id="leftCol">
							<div id="logo">
								<!--- <h1><cf_sitename></h1>
								<h6><cf_sitetitle></h6> --->
								<h6><cfoutput>#arguments.phone#</cfoutput></h6>
							</div>
							<div id="navigation">
								<!--- <cfinclude template="/navigation/sitemap.cfm"> --->
								<cf_navigation id="nav"  excludeList="site map">
							</div>
						</div>
						<div id="middleCol">
							<div id="content-area">
							<div id="breadcrumbs">
								<!--- <cfinclude template="breadcrumbs-include.cfm"> --->
								<cf_breadcrumbs>
							</div>
							<!--- <cfinclude template="content-include.cfm"> --->
							<cf_content>
							</div>
						</div>
						<div id="rightCol">
							<div class="headline">
								<!--- <cfinclude template="calendar-event.cfm"> --->
							</div>
						</div>
						<div id="footer">
							<cf_navigation display="delim" delim="|" id="footerNav">
						<p>
						<a href="http://quantumdelta.com" target="_blank">Powered by QuantumDelta</a> <cf_copyright>
						</p>
						</div>
						</div>
					</div>
					</center>
					</body>
					</html>
				</cfsavecontent>
			</cfcase>
			<cfcase value="4">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
					<title><cfoutput><cf_pagetitle> - #arguments.name#</cfoutput></title>
					<!--- <cfinclude template="/css/template4.cfm">
					<cfinclude template="/css/calendar.cfm">
					<cfinclude template="themepicker.cfm"> --->
					<cfoutput>#mycss#</cfoutput>
					<center>
					<div id="wrapper">
						<div id="header">
							<div id="logo">
								<!---  <h1><cf_sitename></h1>
								<h6><cf_sitetitle></h6> --->
								<h1><a href="/"><cfoutput>#arguments.name#</cfoutput></a></h1>
							</div>
							<div id="phone">
								<h1><cfoutput>#arguments.phone#</cfoutput></h1>
								<div id="breadcrumbs">
									<!--- <cfinclude template="breadcrumbs-include.cfm"> --->
									<!--- <cf_breadcrumbs> --->
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<table border="0" cellspacing="0" cellpadding="0">
						<tr>
						<td id="navigation">
							<!--- <cfinclude template="/navigation/sitemap.cfm"> --->
							<cf_navigation id="nav"  excludeList="site map">
						</td>
						<td id="content-news">
							<div id="content-area">
									<!--- <cfinclude template="content-include.cfm"> --->
									 <cf_content>
							</div>
						</td>
						<td id="headline-td">
							<div id="headline">
								<!--- <cfinclude template="calendar-event.cfm"> --->
								<!--- Mrs raj and her daughter anu lived near garden school in a white house with blue windows. One day Anu said to her doll, "tiny you are sleepy. Lie down here on this chair", and she went out into the garden. --->
								<!--- <h2>Archives</h2>
								<ul class="archives">
								<cf_blog_archives>
									<li><cf_blog_archive_linkedName>mmmm yyyy</cf_blog_archive_linkedName> (<cf_blog_archive_count>)</li>
								</cf_blog_archives>
								</ul>
								<a href="/xml/rss.xml.txt" class="rss">RSS Feed</a> --->
							</div>
						</td>
						</tr>
						</table>
						<div id="footer">
							<!--- <cf_navigation display="delim" delim="|"> --->
						<p>
						<a href="http://quantumdelta.com" target="_blank">Powered by QuantumDelta</a> <cf_copyright>
						</p>
						</div>
					</div>
					</center>
					</body>
					</html>
				</cfsavecontent>
			</cfcase>
			<cfcase value="5">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
					<script type="text/javascript" src="http://quantumdelta.com/js/autoclear.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2.1-core.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/mootools-1.2-more.js"></script>
							<script type="text/javascript" src="http://quantumdelta.com/js/lib/simpleDropDown.js"></script>
					<title><cfoutput><cf_pagetitle> - #arguments.name#</cfoutput></title>
					<!--- <cfinclude template="/css/template5.cfm">
					<cfinclude template="/css/calendar.cfm">
					<cfinclude template="themepicker.cfm"> --->
					<cfoutput>#mycss#</cfoutput>
					
					<center>
						<div id="header">
						<div id="header-text">
							<div id="logo">
								<!--- <h1><cf_sitename></h1>
								<h6><cf_sitetitle></h6> --->
							</div>
					
							<div id="phone">
								<cfoutput>#arguments.phone#</cfoutput>
							</div>
						</div>
						</div>
						<div id="navigation">
							<cf_navigation id="nav"  excludeList="site map">
							<div style="clear: both;"></div>
						</div>
						<div id="main-area">
						<table cellspacing="0" cellpadding="0" id="three-columns">
						<tr id="content-text">
							<td>
							<div id="content-area">
							<div id="breadcrumbs">
								<!--- <cfinclude template="breadcrumbs-include.cfm"> --->
								<cf_breadcrumbs>
							</div>
								<!--- <cfinclude template="content-include.cfm"> --->
								<cf_content>
							</div>
							</td>
							<td id="subnav">
								<div class="subnavList">
								<!--- <cf_subnavigation> --->
								</div>
								<div class="headline">
									<!--- <center><cfinclude template="calendar-event.cfm"></center> --->
								</div>
							</td>
						</tr>
						</table>
						</div>
						<div id="footer">
							<cf_navigation display="delim" delim="|" id="footerNav">
						<p>
						<a href="http://quantumdelta.com" target="_blank">Powered by QuantumDelta</a> <cf_copyright>
						</p>
						</div>
						</div>
					</center>
					</body>
					</html>
				</cfsavecontent>
			</cfcase>
			<cfcase value="6">
				<cfsavecontent variable="template">
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
					
					<title><cfoutput>#arguments.name# - <cf_pagetitle></cfoutput></title>
					<!--- <cfinclude template="/css/template6.cfm">
					<cfinclude template="/css/calendar.cfm">
					<cfinclude template="themepicker.cfm"> --->
					<cfoutput>#mycss#</cfoutput>
					
					<center>
						<div id="header">
						<div id="header-text">
							<div id="logo">
								<!--- <h1><cf_sitename></h1>
								<h6><cf_sitetitle></h6> --->
							</div>
							<div id="phone">
								<cfoutput>#arguments.phone#</cfoutput>
							</div>
						</div>
						</div>
						
						<div id="main-area">
						<table cellspacing="0" cellpadding="0" id="three-columns">
						<tr id="content-text">
							<td id="navigation">
								<!--- <cfinclude template="/navigation/sitemap.cfm"> --->
								<cf_navigation id="nav"  excludeList="site map">
							</td>
							<td id="content">
								<div id="content-area">
									<div id="breadcrumbs">
										<!--- <cfinclude template="breadcrumbs-include.cfm"> --->
										<cf_breadcrumbs>
									</div>
									<!--- <cfinclude template="content-include.cfm"> --->
									<cf_content>
							</div>
							</td>
							<td valign="top">
								<div id="headline" class="headline">
									<!--- <cfinclude template="calendar-event.cfm"> --->
								</div>
							</td>
						</tr>
						</table>
						</div>
						<div id="footer">
							<cf_navigation display="delim" delim="|" id="footerNav">
						<p>
						<a href="http://quantumdelta.com" target="_blank">Powered by QuantumDelta</a> <cf_copyright>
						</p>
						</div>
						</div>
					</center>
					</body>
					</html>
				</cfsavecontent>
			</cfcase>
		</cfswitch>
		<cfreturn template>
	</cffunction>

</cfcomponent>