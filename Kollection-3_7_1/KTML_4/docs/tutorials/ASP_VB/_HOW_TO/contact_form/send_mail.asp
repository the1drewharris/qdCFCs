<%
        SMTP_SERVER = "smtp.server"
        SMTP_SERVER_PORT = "25"
        SMTP_USERNAME = ""
        SMTP_PASSWORD = ""
        
        EMAIL_TO = "nobody@nobody.com"
        EMAIL_FROM = Request.Form("emailAddress")
        EMAIL_SUBJECT = "New message from contact form"
        EMAIL_BODY = "New message from:" & Request.Form("firstName") & " " & Request.Form("lastName") & vbNewLine & "E-mail address:" & Request.Form("emailAddress") & vbNewLine & "Lives in:" & Request.Form("region") & vbNewLine & "Comment type: " & Request.Form("commentType") & vbNewLine & "Message: " & Request.Form("comment")


    	' init mail object
		Dim objMessage
		On Error Resume Next
		Set objMessage = CreateObject("CDO.Message")
		If Err.Number <> 0 Then
			Response.Write ("CDO.Message object is missing")
			Response.End
		End If
		On Error GoTo 0
		
		' config
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2		 
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTP_SERVER
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = SMTP_USERNAME
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = SMTP_PASSWORD
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = SMTP_SERVER_PORT
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False
		'Set the number of seconds to wait for a valid socket to be established with the SMTP service before timing out.
		objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60			
		objMessage.Configuration.Fields.Update
		
		objMessage.Fields.Item("urn:schemas:mailheader:to")    				 =  EMAIL_TO
		objMessage.Fields.Item("urn:schemas:mailheader:from")   			 =  EMAIL_FROM
		objMessage.Fields.Item("urn:schemas:mailheader:subject")			 =  EMAIL_SUBJECT
		objMessage.Fields.Update


        objMessage.TextBody = EMAIL_BODY
        'Set itbp = objMessage.TextBodyPart 	
        'itbp.Charset = encoding
        
		On Error resume next
		objMessage.Send
		If err.number <> 0 Then
			error = err.Description
            Response.Write "Error sending email: " & error
            Response.End()
		End If				
		Set objMessage = nothing	
    
        Response.redirect "index.asp"
%>