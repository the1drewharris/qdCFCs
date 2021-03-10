<cfcomponent hint="I have functions that can manipulate excel files.">

<cffunction name="init" output="true" access="public" returntype="void" hint="I initialize the object. Invoke me as soon as an object is created">
	<cfdirectory action="list" directory="/home/drew/domains/qdcms.com/public_html/poi-3.5-beta5/" name="getJarFiles" recurse="true" filter="*.jar">
	
	<!--- construct the full file paths for all jar files --->
	<cfquery name="getFilePaths" dbtype="query">
	    SELECT    Directory +'/'+ Name AS FilePath
	    FROM    getJarFiles
	</cfquery>
	
	<cfset filePathList = replace( valueList(getFilePaths.FilePath, "|"), "\", "/", "all")>
	<cfset paths = listToArray(filePathList, "|")>
	<cfset javaLoader = createObject("component", "javaloader.JavaLoader").init(paths)>
	<cfset Variables.WorkbookFactory = javaLoader.create("org.apache.poi.ss.usermodel.WorkbookFactory")>
</cffunction>

<cffunction name="getColumns" access="public" returntype="any" output="false" hint="I return an xml document with column names in excel file">
	<cfargument name="filepath" type="String" required="true" hint="I am the full path of the excel file">
	<cfset inp = createObject("java", "java.io.FileInputStream").init(filepath)>
	<cfset wb = Variables.WorkbookFactory.create(inp)>
	<cfset sheet=wb.getSheetAt(0)>
	<cfset firstrow=sheet.getFirstRowNum()>
	<cfset row=sheet.getRow(firstrow)>
	<cfset i=row.getFirstCellNum()>
	<cfset n=row.getLastCellNum()-1>
	<cfoutput>
	<cfxml variable="columns">
		<Columns>
			<cfloop index="j" from="#i#" to="#n#">
				<cfset cell=Trim(row.getcell(javaCast("int",j)))>
				<cfif Trim(cell) EQ "">
					<cfset cell="Column">
				<cfelse> <!--- if there is an error, this is the part where we need to change, probably add one or more line for each special character not considered here, same should be done for function excel to xml --->
					<cfset cell=Replace(cell," ","_","all")>
					<cfset cell=Replace(cell,".","_","all")>
					<cfset cell=Replace(cell,"-","_","all")>
					<cfset cell=Replace(cell,"/","_","all")>
					<cfset cell=Replace(cell,"\","_","all")>
				</cfif>
				<Column>#cell#</Column>
			</cfloop>
			<NoOfColumns>#n+1#</NoOfColumns>
		</Columns>
	</cfxml>
	</cfoutput>
	<cfreturn columns>
</cffunction>

<cffunction name="getColumnsAsArray" access="public" returntype="any" output="false" hint="I return an xml document with column names in excel file">
	<cfargument name="filepath" type="String" required="true" hint="I am the full path of the excel file">
	<cfset var inp = createObject("java", "java.io.FileInputStream").init(filepath)>
	<cfset var wb = Variables.WorkbookFactory.create(inp)>
	<cfset var sheet=wb.getSheetAt(0)>
	<cfset var firstrow=sheet.getFirstRowNum()>
	<cfset var row=sheet.getRow(firstrow)>
	<cfset var i=row.getFirstCellNum()>
	<cfset var n=row.getLastCellNum()-1>
	<cfset var columns=ArrayNew(1)>
	<cfset var c=1>
	<cfloop index="j" from="#i#" to="#n#">
		<cfset cell=Trim(row.getcell(javaCast("int",j)))>
		<cfif Trim(cell) EQ "">
			<cfset cell="Column_#c#">
		<cfelse>
			<cfset cell=Replace(cell," ","_","all")>
			<cfset cell=Replace(cell,".","_","all")>
			<cfset cell=Replace(cell,"-","_","all")>
			<cfset cell=Replace(cell,"/","_","all")>
			<cfset cell=Replace(cell,"\","_","all")>
		</cfif>
		<cfset columns[c]=cell>
		<cfset c=c+1>
	</cfloop>
	<cfreturn columns>
</cffunction>

<cffunction name="excelToXml" access="public" returntype="any" output="false" hint="I return an xml version of a excel document">
	<cfargument name="filepath" type="String" required="true" hint="I am the full path of the excel file">
	<cfset inp = createObject("java", "java.io.FileInputStream").init(filepath)>
	<cfset wb = Variables.WorkbookFactory.create(inp)>
	<cfset sheet=wb.getSheetAt(0)>
	<cfset firstrow=sheet.getFirstRowNum()>
	<cfset secondrow=firstrow+1>
	<cfset lastrow=sheet.getLastRowNum()>
	<cfset row=sheet.getRow(firstrow)>
	<cfset i=row.getFirstCellNum()>
	<cfset n=row.getLastCellNum()-1>
	<cfset cell=ArrayNew(1)>
	<cfset noofrows=0>
	
	<cfoutput>
		<cfif lastrow EQ 0><cfreturn></cfif>
		<cfxml variable="exceldocument">
			<ExcelDocument>Sheet 1
				<Columns> Column Names
					<cfloop index="j" from="#i#" to="#n#">
						<cfset cell[j+1]=Trim(row.getcell(javaCast("int",j)))>
						<cfif Trim(cell[j+1]) EQ "">
							<cfset cell[j+1]="Column">
						<cfelse>
							<cfset cell[j+1]=Replace(cell[j+1]," ","_","all")>
							<cfset cell[j+1]=Replace(cell[j+1],".","_","all")>
							<cfset cell[j+1]=Replace(cell[j+1],"-","_","all")>
							<cfset cell[j+1]=Replace(cell[j+1],"/","_","all")>
							<cfset cell[j+1]=Replace(cell[j+1],"\","_","all")>
						</cfif>
						<Column>#cell[j+1]#</Column>
					</cfloop>
				</Columns>
				
				<cfloop from="1" to="#lastrow#" index="k">
					<cfset row=sheet.getRow(k)>
					<cfif isDefined('row')>
						<Data>Row #k#
							<cfloop index="j" from="0" to="#n#">
								<cfset value=row.getCell(javaCast("int",j))>
								<#cell[j+1]#><cfif isDefined('value')>#Xmlformat(value)#</cfif></#cell[j+1]#>
							</cfloop>
						</Data>
						<cfset noofrows=noofrows+1>
					</cfif>
				</cfloop>
				<NoOfRows>#noofrows#</NoOfRows>
			</ExcelDocument>
		</cfxml>
	</cfoutput>
	
	<cfreturn exceldocument>
</cffunction>

<cffunction name="excelToArray" access="public" returntype="array" output="false" hint="I return an xml version of a excel document">
	<cfargument name="filepath" type="String" required="true" hint="I am the full path of the excel file">
	<cfset var inp = createObject("java", "java.io.FileInputStream").init(filepath)>
	<cfset var wb = Variables.WorkbookFactory.create(inp)>
	<cfset var sheet=wb.getSheetAt(0)>
	<cfset var firstrow=sheet.getFirstRowNum()>
	<cfset var secondrow=firstrow+1>
	<cfset var lastrow=sheet.getLastRowNum()>
	<cfset var row=sheet.getRow(firstrow)>
	<cfset var i=row.getFirstCellNum()>
	<cfset var n=row.getLastCellNum()-1>
	<cfset var cell=ArrayNew(1)>
	<cfset var noofrows=0>
	<cfset var data=ArrayNew(2)>
	
	<cfloop from="1" to="#lastrow#" index="i">
		<cfset row=sheet.getRow(i)>
		<cfif isDefined('row')>
			<cfloop index="j" from="0" to="#n#">
				<cfset data[i][j+1]=XmlFormat(row.getCell(javaCast("int",j)))>
			</cfloop>
			<cfset noofrows=noofrows+1>
		</cfif>
	</cfloop>
	<cfreturn data>
</cffunction>

</cfcomponent>