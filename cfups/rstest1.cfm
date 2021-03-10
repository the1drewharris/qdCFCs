<cfset application.key="AC882AED3A845A50">
<cfset application.username="the1drewharris">
<cfset application.password="spidey01">

<cfset st = createObject("component", "org.camden.ups.rateservice").init(application.key, application.username, application.password)>

<!--- Use this to show package types--->
<cfdump var="#st.getValidPackageTypes()#">


<cfset packages = arrayNew(1)>

<!--- <cfset arrayAppend(packages, st.getPackageStruct(weight=.25,width=5.5,length=7.5,height=.5,packagetype="03"))>
<cfset arrayAppend(packages, st.getPackageStruct(weight=.25,width=5.5,length=7.5,height=.5,packagetype="02"))> --->
<!--- <cfset arrayAppend(packages, st.getPackageStruct(weight=.25,width=5.5,length=7.5,height=.5,packagetype="65"))> --->

<cfset arrayAppend(packages, st.getPackageStruct(weight=.25,packagetype="02"))>
<!--- <cfset arrayAppend(packages, st.getPackageStruct(weight=.25,packagetype="11"))> --->

<cfset rates = st.getRateInformation(shipperpostalcode=74146-6828,packages=packages,shiptopostalcode=90210)>
<cfdump var="#rates#" label="Rates">