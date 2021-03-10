<cfif isDefined("FORM.Submit")>
<cfmail
   from="#Form.emailAddress#"
   to="nobody@nobody.com"
   subject="New message from contact form">
        New message from: #Form.firstname# #Form.lastname# 
        E-mail address:  #Form.emailAddress#
        Lives in: #Form.region
        Comment type: #Form.commentType#
        Comment: #Form.comment#
</cfmail>
Thanks for contacting us!
<p><a href='index.php'>Back to main page</a></p>
<cfelse>
    <cflocation url='index.cfm'>
</cfif>
