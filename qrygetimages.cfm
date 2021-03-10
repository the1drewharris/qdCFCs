<!--- -->
<xmp>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fusedoc SYSTEM "http://fusebox.org/fd4.dtd">
<fusedoc fuse="qrygetimages.cfm">
	<responsibilities>
		I look up the list of available images that go with the user who is logged in.
	</responsibilities>
	<properties>
		<history author="Paul Blanchard" email="paul.blanchard@telus.net" date="24/Sep/2002" role="architect" type="create"/>
		<property name="" value="" comments=""/>
	</properties>
   <io>
      <in>
         <string name="dsn" scope="request" optional="no" />
         <string name="dbusername" scope="request" optional="yes" />
         <string name="dbpassword" scope="request" optional="yes" />
      </in>
      <out>
<recordset name="getlistofimages" >
<string name="imageid" optional="no" comments="" />
<string name="imagename" optional="no" comments="" />
<string name="imagepath" optional="no" comments="" />
</recordset>

      </out>
   </io>
</fusedoc>
---> 

<cfquery name="getlistofimages" datasource="#request.dsn#" username="#request.dbusername#" password="#request.dbpassword#">
SELECT 
IMAGE.IMAGEID, 
IMAGE.IMAGEALT,
IMAGE.IMAGEPATH,
IMAGE.IMAGEVSPACE,
IMAGE.IMAGEHSPACE,
IMAGE.IMAGEHEIGHT,
IMAGE.IMAGEWIDTH,
IMAGE.IMAGECLASS
FROM [IMAGE]
ORDER BY IMAGEALT
</cfquery> 

<!--- Number of records across to display --->
<cfset numberofcolumns = 4>
<!--- Number of rows to display per Next/Back page  --->
<CFSET RowsPerPage = 16>
<!--- What row to start at? Assume first by default --->
<CFPARAM NAME="attributes.StartRow" DEFAULT="1" TYPE="numeric">
<!--- Allow for Show All parameter in the URL --->
<CFPARAM NAME="attributes.ShowAll" TYPE="boolean" DEFAULT="No">

<!--- We know the total number of rows from query   --->
<CFSET TotalRows = getlistofimages.RecordCount>
<!--- Show all on page if ShowAll passed in URL   --->
<CFIF attributes.ShowAll>
  <CFSET RowsPerPage = TotalRows>
</CFIF>
<!--- Last row is 10 rows past the starting row, or --->
<!--- total number of query rows, whichever is less --->
<CFSET EndRow = Min(attributes.StartRow + RowsPerPage - 1, TotalRows)>
<!--- Next button goes to 1 past current end row  --->
<CFSET StartRowNext = EndRow + 1>
<!--- Back button goes back N rows from start row --->
<CFSET StartRowBack = attributes.StartRow - RowsPerPage>