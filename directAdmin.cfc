<cfcomponent hint="I have functions for directadmin">
	<cffunction name="init" access="public" returntype="void" hint="I should be invoked when this object is instantiated">
		<cfset variables.user="drew">
		<cfset variables.password="B3791zHkH">
		<cfset variables.useragent="Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2">
	</cffunction>
	
	<cffunction name="addDomain" access="public" returntype="any" hint="I add a domain">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="bandwidth" required="false" default="0" hint="bandwidth for the site">
		<cfargument name="quota" required="false" default="0" hint="quota">
		<cfargument name="ssl" required="false" default="OFF" hint="enable or disable ssl for the site">
		<cfargument name="cgi" required="false" default="ON" hint="enable or disable CGI">
		<cfargument name="php" required="false" default="ON" hint="enable or disable PHP">
		
		<cfset site="http://host1.web-host.net/CMD_API_DOMAIN">
		<cfif arguments.bandwidth EQ 0>
			<cfset arguments.bandwidth="unlimited">
			<cfset bandwidthname="ubandwidth">
		<cfelse>
			<cfset bandwidthname="bandwidth">
		</cfif>
		<cfif arguments.quota EQ 0>
			<cfset arguments.quota="unlimited">
			<cfset quotaname="uquota">
		<cfelse>
			<cfset quotaname="quota">
		</cfif>
		
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			<cfhttpparam type="formfield" name="action" value="create">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="#bandwidthname#" value="#arguments.bandwidth#">
			<cfhttpparam type="formfield" name="#quotaname#" value="#arguments.quota#">
			<cfhttpparam type="formfield" name="ssl" value="#arguments.ssl#">
			<cfhttpparam type="formfield" name="cgi" value="#arguments.cgi#">
			<cfhttpparam type="formfield" name="php" value="#arguments.php#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<cffunction name="addSubDomain" access="public" returntype="void" hint="I add subdomain.">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="subDomain" required="true" type="string" hint="name of the sub domain">
		<cfset site="http://host1.web-host.net/CMD_API_SUBDOMAINS">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#">
			<cfhttpparam type="formfield" name="action" value="create">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="subdomain" value="#arguments.subDomain#">
		</cfhttp>
	</cffunction>
	
	<cffunction name="deleteSubDomain" access="public" returntype="void" hint="I add subdomain">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="subDomain" required="true" type="string" hint="name of the sub domain">
		<cfset site="http://host1.web-host.net/CMD_API_SUBDOMAINS">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="">
			<cfhttpparam type="formfield" name="action" value="delete">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="select0" value="#arguments.subDomain#">
			<cfhttpparam type="formfield" name="contents" value="yes">
		</cfhttp>
	</cffunction>
	
	<cffunction name="deleteDomain" access="public" returntype="any" hint="I delete domain">
		<cfargument name="domain" required="true" type="string" hint="name of the domain to delete">	
		<cfset site="http://host1.web-host.net/CMD_API_DOMAIN">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			<cfhttpparam type="url" name="user" value="#variables.user#">
			<cfhttpparam type="formfield" name="delete" value="anything">
			<cfhttpparam type="formfield" name="confirmed" value="Confirm">
			<cfhttpparam type="formfield" name="select0" value="#arguments.domain#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<!--- not tested --->
	<cffunction name="suspendDomain" access="public" returntype="any" hint="I suspend domain">
		<cfargument name="domain" required="true" type="String" hint="name of the domain">
		<cfset site="http://host1.web-host.net/CMD_API_DOMAIN">
		<cfhttp username="#variables.username#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			 <cfhttpparam type="formfield" name="action" value="suspend">
			 <cfhttpparam type="formfield" name="confirmed" value="Confirm">
			 <cfhttpparam type="formfield" name="select0" value="#arguments.domain#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<cffunction name="listallemails" access="public" returntype="any" hint="I list all email addresses">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfset site="http://host1.web-host.net/CMD_API_POP">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			<cfhttpparam type="formfield" name="action" value="list">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<cffunction name="emailExists" access="public" returntype="boolean" hint="I return true if email exists and false otherwise">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="email" required="true" type="string" hint="email to create">
		<cfinvoke method="listallemails" domain="quantumdelta.com" returnvariable="myresult">
		<cfset emaillist=REReplace(myresult.filecontent,"list\[]=","","all")>
		<cfif listfindNocase(emaillist,arguments.email,"&") GT 0>
			<cfreturn TRUE>
		</cfif>
		<cfreturn FALSE>
	</cffunction>
	
	<cffunction name="addEmail" access="public" returntype="any" hint="I add email">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="email" required="true" type="string" hint="email to create">
		<cfargument name="pw" required="true" type="string" hint="Password to create">
		<cfargument name="quota" required="false" type="string" default="0" hint="Space to use in MB for this email account">	
		<cfset site="http://host1.web-host.net/CMD_API_POP">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			<cfhttpparam type="formfield" name="action" value="create">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="user" value="#arguments.email#">
			<cfhttpparam type="formfield" name="passwd" value="#arguments.pw#">
			<cfhttpparam type="formfield" name="quota" value="#arguments.quota#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<cffunction name="changeEmailPassword" access="public" returntype="any" hint="I change password of the email">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="email" required="true" type="string" hint="full email address">
		<cfargument name="oldpassword" required="true" type="string" hint="old password">
		<cfargument name="newpassword" required="true" type="string" hint="new password">
		<cfset site="http://host1.web-host.net/CMD_CHANGE_EMAIL_PASSWORD">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="myresult">
			<cfhttpparam type="formfield" name="action" value="create">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="email" value="#arguments.email#">
			<cfhttpparam type="formfield" name="oldpassword" value="#arguments.oldpassword#">
			<cfhttpparam type="formfield" name="password1" value="#arguments.newpassword#">
			<cfhttpparam type="formfield" name="password2" value="#arguments.newpassword#">
		</cfhttp>
		<cfreturn myresult>
	</cffunction>
	
	<cffunction name="deleteEmail" access="public" returntype="any" hint="I delete email from the system">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="email" required="true" type="string" hint="email to create">
		<cfset site="http://host1.web-host.net/CMD_API_POP">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#" result="returncode">
			<cfhttpparam type="formfield" name="action" value="delete">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="user" value="#arguments.email#">
		</cfhttp>
		<cfreturn returncode>
	</cffunction>
	
	<cffunction name="addARecord" access="public" returntype="void" hint="I add DNS records">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="recordname" required="true" type="string" hint="name of the record;ftp,localhost,mail,pop,domain.com.,smtp,www etc">
		<cfargument name="ip" required="false" default="208.65.113.146" type="string" hint="IP Address of the record">
		<cfset site="http://host1.web-host.net/CMD_DNS_CONTROL?domain=#arguments.domain#">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#">
			<cfhttpparam type="formfield" name="action" value="add">
			<cfhttpparam type="formfield" name="type" value="A">
			<cfhttpparam type="formfield" name="name" value="#arguments.recordname#">
			<cfhttpparam type="formfield" name="value" value="#arguments.ip#">
		</cfhttp>
	</cffunction>

	<cffunction name="deleteARecord" access="public" returntype="void" hint="I delete DNS record">
		<cfargument name="domain" required="true" type="string" hint="name of the domain">
		<cfargument name="recordname" required="true" type="string" hint="name of the record;ftp,localhost,mail,pop,domain.com.,smtp,www etc">
		<cfargument name="ip" required="false" default="208.65.113.148" type="string" hint="IP Address of the record">
		<cfswitch expression="#arguments.recordname#">
			<cfcase value="ftp">
				<cfset encoded="arecs0">
			</cfcase>
			<cfcase value="localhost">
				<cfset encoded="arecs1">
			</cfcase>
			<cfcase value="mail">
				<cfset encoded="arecs2">
			</cfcase>
			<cfcase value="pop">
				<cfset encoded="arecs3">
			</cfcase>
			<cfcase value="smtp">
				<cfset encoded="arecs5">
			</cfcase>
			<cfcase value="www">
				<cfset encoded="arecs6">
			</cfcase>
			<cfdefaultcase>
				<cfset encoded="arecs4">
			</cfdefaultcase>>
		</cfswitch>
		<cfset site="http://host1.web-host.net/CMD_DNS_CONTROL?domain=#arguments.domain#">
		<cfhttp username="#variables.user#" password="#variables.password#" useragent="#variables.useragent#" port="2222" method="post" url="#site#">
			<cfhttpparam type="formfield" name="domain" value="#arguments.domain#">
			<cfhttpparam type="formfield" name="#encoded#" value="name=#arguments.recordname#&value=#arguments.ip#">
			<cfhttpparam type="formfield" name="delete" value="Delete+Selected">
			<cfhttpparam type="formfield" name="action" value="select">
		</cfhttp>
	</cffunction>
</cfcomponent>