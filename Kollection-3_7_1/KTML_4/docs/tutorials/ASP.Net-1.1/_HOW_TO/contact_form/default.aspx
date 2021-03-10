<%@ Page Language="C#" ContentType="text/html" ValidateRequest="False" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Configuration" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    public string content;
    protected void Page_Load(object sender, EventArgs e)
    {
        string filePath = Server.MapPath("out.htm");
        StreamReader sr = File.OpenText(filePath);
        try
        {
            content = sr.ReadToEnd();
        }
        catch (Exception) { }
        sr.Close();
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>
<body>
<form name="form1" runat="server" IsPostBack = "No">
<% Response.Write(content); %>
<p><a href="edit.aspx">Edit content</a></p>
</form>
</body>
</html>