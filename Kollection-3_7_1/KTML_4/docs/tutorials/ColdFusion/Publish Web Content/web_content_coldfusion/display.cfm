<cfquery name="rsPresentation" datasource="conn_web_content">
SELECT *
FROM product_prd
WHERE id_prd = 1
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Product Overview</title>
<link href="includes/ktm/styles/KT_styles.css" rel="stylesheet" type="text/css" />
</head>

<body>
<h2><cfoutput>#rsPresentation.name_prd#</cfoutput> Overview</h2>
<p><cfoutput>#rsPresentation.presentation_prd#</cfoutput></p>
<p><a href="edit.cfm?id_prd=1">Edit content</a></p>
</body>
</html>
