<cfcomponent hint="PaypalExpressCheckout Functions">
	<cfset username="">
	<cfset password="">
	<cfset signature="">
	<cfset paymentaction="">
	<cfset amount="">
	<cfset returnurl="">
	<cfset cancelurl="">
	<cfset token="">
<cffunction name="init" access="public" returntype="void"> 
	<cfargument name="un" required="true" hint="Paypal business account username">
	<cfargument name="pwd" required="true" hint="Paypal business account password">
	<cfargument name="sign" required="true" hint="Paypal business account signature">
	<cfargument name="payact" required="true" hint="Paypal payment action">
	<cfargument name="amt" required="true" hint="Total amount to charge to buyer">
	<cfargument name="returl" required="true" hint="URL to return to when paypal authorization is complete">
	<cfargument name="canurl" required="true" hint="URL to return to if the buyer cancels">
	<cfset username=un>
	<cfset password=pwd>
	<cfset signature=sign>
	<cfset paymentaction=payact>
	<cfset amount=amt>
	<cfset returnurl=returl>
	<cfset cancelurl=canurl>
</cffunction>

<cffunction name="SetExpressCheckout" access="public" returntype="void">
	<cfhttp url="https://api-3t.paypal.com/nvp" method="POST">
		<cfhttpparam type="FORMFIELD" name="USER" value="#username#">
		<cfhttpparam type="FORMFIELD" name="PWD" value="#password#">
		<cfhttpparam type="FORMFIELD" name="SIGNATURE" value="#signature#">
		<cfhttpparam type="FORMFIELD" name="VERSION" value="2.3">
		<cfhttpparam type="FORMFIELD" name="PAYMENTACTION" value="#paymentaction#">
		<cfhttpparam type="FORMFIELD" name="AMT" value="#amount#">
		<cfhttpparam type="FORMFIELD" name="RETURNURL" value="#returnurl#">
		<cfhttpparam type="FORMFIELD" name="CANCELURL" value="#cancelurl#">
		<cfhttpparam type="FORMFIELD" name="METHOD" value="SetExpressCheckout">
	</cfhttp>
	
	<cfset token=right(cfhttp.filecontent,22)>
	<cfset token=Replace(token,"%2d","-",1)>
	<cflocation url="https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#token#" addtoken="false">
</cffunction>

<cffunction name="MakePayment" access="public" returntype="String">
<cfhttp url="https://api-3t.paypal.com/nvp" method="POST">
<cfhttpparam type="FORMFIELD" name="USER" value="#username#">
<cfhttpparam type="FORMFIELD" name="PWD" value="#password#">
<cfhttpparam type="FORMFIELD" name="SIGNATURE" value="#signature#">
<cfhttpparam type="FORMFIELD" name="VERSION" value="2.3">
<cfhttpparam type="FORMFIELD" name="TOKEN" value="#token#">
<cfhttpparam type="FORMFIELD" name="METHOD" value="GetExpressCheckoutDetails">
</cfhttp>


<cfset mylist=cfhttp.FileContent>
<cfset payerid=ListGetAt(mylist,8, "&")>
<cfset payerid=ListGetAt(payerid,2,"=")>


<cfhttp url="https://api-3t.sandbox.paypal.com/nvp" method="POST">
<cfhttpparam type="FORMFIELD" name="USER" value="#username#">
<cfhttpparam type="FORMFIELD" name="PWD" value="#password#">
<cfhttpparam type="FORMFIELD" name="SIGNATURE" value="#signature#">
<cfhttpparam type="FORMFIELD" name="VERSION" value="2.3">
<cfhttpparam type="FORMFIELD" name="PAYMENTACTION" value="#paymentaction#">
<cfhttpparam type="FORMFIELD" name="PAYERID" value="#payerid#">
<cfhttpparam type="FORMFIELD" name="TOKEN" value="#token#">
<cfhttpparam type="FORMFIELD" name="AMT" value="#amount#">
<cfhttpparam type="FORMFIELD" name="METHOD" value="DoExpressCheckoutPayment">
</cfhttp>
<cfreturn cfhttp.FileContent>

</cffunction>
</cfcomponent>

