<!-- #include file="../includes/ktm/ktml4.asp" -->
<% 
'#################################################################################
'## Copyright (C) 2004 Rick Eastes
'##
'## This program is free software; you can redistribute it and/or
'## modify it under the terms of the GNU General Public License.
'##
'## The "powered by" text/logo with a link back to
'## http://www.nukedit.com in the footer of the pages MUST
'## remain visible when the pages are viewed on the internet or intranet.
'## Donations made to nukedit may waiver this requirement.
'## Speak to rick eastes via the nukedit contact form
'##
'## All copyright notices regarding nukedit
'## must remain intact in the scripts and in the outputted HTML
'##
'## Support can be obtained from support forums at:
'## http://www.nukedit.com/forum
'##
'#################################################################################

setup_ServerName = Request.ServerVariables("SERVER_NAME")
setup_SiteLocation = replace(site,"/","")
'dim codeonly

if(len(setup_SiteLocation)>0)then 
	setup_SiteLocation = setup_SiteLocation & "\/"
end if

if(not setup_ContentWidth>0)then
	setup_ContentWidth = 600
end if
if(not setup_EditorHeight>0)then
	setup_EditorHeight = 500
end if

closingTag = "</div>"

function InitEdit
'	response.Write "<table width=" & setup_ContentWidth & " cellpadding=0 cellspacing=0><tr><td>"
	if(isAllowed(permissions)>=3)then
			WriteToolbar("admin")
	elseif(isAllowed(permissions)>=2)then
			WriteToolbar("edit")
	end if
end function

function WriteToolbar(editversion)
	toolbarx = request.Cookies("toolbarx")
	toolbary = request.Cookies("toolbary")

	if(toolbarx = "")then
		toolbarx = setup_ToolBarX
		toolbary = setup_ToolBarY
	end if
    
    relPathToRoot = ""
    if(len(request("edit"))>0) then 
        relPathToRoot = RelPath(site & pagename, site)
    end if
%>

<script language="javascript">
function editMode(){
	<% if(len(request("edit"))>0)then %>
		alert("You are already in edit mode.");
	<% else %>
		window.status = 'Loading Editor... Please Wait';
		location.href = location.pathname + '?edit=true'; 
	<% end if %>
}
</script>
<script language="javascript" src="<%=site%>InplaceEditor/toolbar.js"></script>
<% if(len(request("edit"))>0)then %>

<script language=javascript>

function cancel(){
//	if(editor!=null)
		location.href=location.pathname;
}


function Save() 
{
    window.status = 'Saving... Please Wait';
    var sReturn = "";
    sReturn = getObj("idKtmlArea").value;
    document.frmSavePage.pagetext.value = sReturn;	
    document.frmSavePage.submit();			
}
</script>

<!-- KTML scripts here -->
<script src="<%=relPathToRoot%>includes/common/js/base.js" type="text/javascript"></script>
<script src="<%=relPathToRoot%>includes/common/js/utility.js" type="text/javascript"></script>
<script src="<%=relPathToRoot%>includes/ktm/core/ktml.js" type="text/javascript"></script>
<script src="<%=relPathToRoot%>includes/resources/ktml.js" type="text/javascript"></script>

<script type="text/javascript">
<!--
document.write('<link href="<%=relPathToRoot%>includes/ktm/core/styles/ktml.css" rel="stylesheet" type="text/css"/>');
// -->
</script>

<script type="text/javascript">
<!--
	ktml_init_object = {
			'debugger_params': false,
			'path': "<%=relPathToRoot%>includes/ktm/",
			'server': "asp"
		};
// -->
</script>

<script type="text/javascript">
<!--
	idKtmlArea_config = {
			width: 600, 
			height: 600, 
			show_toolbar: 'load',  //load, focus, manual
			show_pi: true, //false
			background_color: '#ffffff',  // could be ''
			strip_server_location: false, //false
			auto_focus: true,
			module_props: { }, 
			buttons: [
				//row : [rowIndex, toolbarName, [buttons_list]]
				//{
				//	row: 1,
				//	toolbarName: "",
				//  buttons: []
				//}
                [1, "standard", ["cut", "copy", "paste", "undo", "redo", "find_replace", "toggle_visible", "spellcheck", "toggle_editmode", "toggle_fullscreen", "help"]],
                [1, "formatting", ["bold", "italic", "underline", "align_left", "align_center", "align_right", "align_justify", "numbered_list", "bulleted_list", "outdent", "indent", "clean_menu", "foreground_color", "background_color", "superscript", "subscript"]],
                [2, "styles", ["heading_list", "style_list", "fonttype_list", "fontsize_list"]],
                [2, "insert", ["insert_link", "insert_anchor", "insert_table", "insert_image", "insert_file", "insert_template", "horizontal_rule", "insert_character"]],
                [3, "form", ["insert_form", "insert_textfield", "insert_hiddenfield", "insert_textarea", "insert_checkbox", "insert_radiobutton", "insert_listmenu", "insert_filefield", "insert_button", "insert_label", "insert_fieldset"]]
			]
		}
// -->
</script>


<script type="text/javascript">
<!--
<%
			Dim ktml_obj1: Set ktml_obj1 = new ktml4
			ktml_obj1.Init "ktml1"
			ktml_obj1.setModuleProperty "filebrowser", "AllowedModule", "true", false 			
			ktml_obj1.setModuleProperty "filebrowser", "MaxFileSize", "2000", true 
			ktml_obj1.setModuleProperty "filebrowser", "RejectedFolders", ".svn", false 
			ktml_obj1.setModuleProperty "file", "UploadFolder", "uploads/files/", true 
			ktml_obj1.setModuleProperty "file", "UploadFolderUrl", "uploads/files/", true 			
			ktml_obj1.setModuleProperty "file", "AllowedFileTypes", "doc,pdf,txt", true 
			ktml_obj1.setModuleProperty "media", "UploadFolder", "uploads/media/", true 
			ktml_obj1.setModuleProperty "media", "UploadFolderUrl", "uploads/media/", true 			
			ktml_obj1.setModuleProperty "media", "AllowedFileTypes", "bmp,mov,mpg,avi,mpeg,swf,wmv,jpg,jpeg,gif,png", true 
			ktml_obj1.setModuleProperty "templates", "AllowedModule", "true", false
			ktml_obj1.setModuleProperty "templates", "UploadFolder", "uploads/templates/", true 
			ktml_obj1.setModuleProperty "xhtml", "AllowedModule", "true", false 					
			ktml_obj1.setModuleProperty "xhtml", "xhtml_view_source", "true", true 
			ktml_obj1.setModuleProperty "xhtml", "xhtml_save", "true", true 
			ktml_obj1.setModuleProperty "spellchecker", "AllowedModule", "true", false 
			ktml_obj1.setModuleProperty "css", "PathToStyle", "includes/ktm/styles/KT_styles.css", true 
			ktml_obj1.setModuleProperty "hyperlink_browser", "ServiceProvider", "includes/ktm/hyperlink_service.asp", true 
			ktml_obj1.setModuleProperty "date", "AllowedModule", "true", false	
			ktml_obj1.Execute
		%>
// -->
</script>
<!-- end KTML scripts -->

<form name=frmSavePage action="<%=site%>utilities/SaveExistingPage.asp" method="post" ID="Form2"> 

<!-- this example uses an asp page "SavePage.asp" to handle the data but you may use cfm, cgi, php etc
	to do somthing with the following form element "pagetext" -->
<input type=hidden name=pagetext ID="Hidden1" size=100>
<input type=hidden name=menuid value="<%=rsPage("menuid")%>" ID="Hidden2">
<input type=hidden name=keywords value="<%=rsPage("keywords")%>" ID="Hidden6">
<input type=hidden name=description value="<%=rsPage("description")%>" ID="Hidden7">
<input type=hidden name=contentid value="<%=rsPage("menuid")%>" ID="Hidden3">
<input type=hidden name=permissions value="<%=rsPage("permissions")%>" ID="Hidden9">
<input type=hidden name=name value="<%=rsPage("data")%>" ID="Hidden4">
<input type=hidden name="skin" value="<%=rsPage("template")%>" ID="Hidden5">
<input type=hidden name="pagetype" value="<%=pagetype%>" ID="Hidden8">
</form>

<% end if %>

<style>
/* Save Edit Toolbar */
div.savetoolbar{
	width:80;
	width:39;
	left:<%=toolbarx%>;
	top:<%=toolbary%>;
	position:absolute;
	z-index:4;
}

/* Save Edit Toolbar */
.seperator{
	cursor:move;
}
</style>



<div id=divEditSave class=savetoolbar onMouseUp="if(curElement!=null){SaveToolbarPos();}curElement=null;">
<table cellspacing=0 cellpadding=0 ID="Table1"><tr>
<td><div class=seperator onMouseDown=DoMouseDown(getObj('divEditSave'));><img src="<%=site & "gfx/toolbar-seperator.gif"%>" border=0 alt="Move Toolbar"></div></td>
<td>
<a href="javascript:editMode()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('edit','','<%=site & "gfx/toolbar-edit-over.gif"%>',0)"><img src="<%=site & "gfx/toolbar-edit.gif"%>" name=edit border=0 alt="Edit Code (Ctrl+E)"></a></td>
<%if(len(request("edit"))>0)then%>
<td><a href="javascript:Save();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save','','<%=site & "gfx/toolbar-save-over.gif"%>',0)"><img src="<%=site & "gfx/toolbar-save.gif"%>" name=save border=0 alt="Save Page (Ctrl+S)"></a></td>
<%end if %>
<%if(editversion="admin")then%>
	<td><a href="javascript:location.href='<%=site%>utilities/menumanager.asp?action=edit&menuid=<%=myid%>'" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('properties','','<%=site & "gfx/toolbar-properties-over.gif"%>',0)"><img src="<%=site & "gfx/toolbar-properties.gif"%>" name=properties border=0 alt="Edit Page Properties"></a></td>
<%end if %>
<%if(len(request("edit"))>0)then%>
<td><a href="javascript:cancel();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','<%=site & "gfx/toolbar-cancel-over.gif"%>',0)"><img src="<%=site & "gfx/toolbar-cancel.gif"%>" name=cancel border=0 alt="Cancel"></a></td>
<%end if %>
<td><img src="<%=site & "gfx/toolbar-end.gif"%>"></td>
</tr></table>
</div>
<%
	if(len(request("edit"))>0)then	
	response.Write "<textarea id=""idKtmlArea"" name=""idKtmlArea"" cols=""60"" rows=""20"" style=""display: none;"">"	
	else
	response.Write "<div id=""divContent"" style=""visibility:visible"">"
	end if
end function 

function CloseEdit
	if(len(request("edit"))>0)then	
		response.write "</textarea>"
		response.write "<script type=""text/javascript"" id=""idKtmlArea_defscript"">" & vbNewLine & _
			   "ktml_idKtmlArea = new ktml('idKtmlArea');" & vbNewLine & _
			"</script>"	
	else
		response.write "</div>"
	end if
	
end function

%>