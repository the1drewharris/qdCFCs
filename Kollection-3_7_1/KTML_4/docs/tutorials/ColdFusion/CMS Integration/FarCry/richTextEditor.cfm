<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2003, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$ 

|| VERSION CONTROL ||
$Header: /cvs/farcry/farcry_core/tags/widgets/richTextEditor.cfm,v 1.7 2005/10/06 23:37:30 daniela Exp $
$Author: daniela $
$Date: 2005/10/06 23:37:30 $
$Name: milestone_3-0-0 $
$Revision: 1.7 $

|| DESCRIPTION || 
$Description: Displays an editor for long text input. Based on config settings unless in toggle mode which will display a basic html text area$


|| DEVELOPER ||
$Developer: Brendan Sisson (brendan@daemon.com.au)$

|| ATTRIBUTES ||
$in: $
$out:$
--->
<cfsetting enablecfoutputonly="yes">

<cfimport taglib="/farcry/farcry_core/tags/farcry" prefix="tags">
<cfinclude template="/farcry/farcry_core/admin/includes/utilityFunctions.cfm">
<cfparam name="attributes.textareaname" default="body">
<cfparam name="attributes.fieldLabel" default="">

<cfif isDefined('caller.output.#attributes.textareaname#') AND not isDefined('attribute.value')>
	<cfset attributes.value = caller.output[attributes.textareaname]>
</cfif>

<cfif attributes.fieldLabel NEQ ""><cfoutput><b>#attributes.fieldLabel#</b></cfoutput></cfif>
<!--- check if toggled to text area otherwise use config defined editor --->
<cfif isdefined("session.toggleTextArea") and session.toggleTextArea eq 1>
	<!--- javascript for inserting images etc --->
	<cfoutput>
		<script language="JavaScript">
		function insertHTML(html,field)
		{
			document.editform.#attributes.textareaname#.value = document.editform.#attributes.textareaname#.value + (html);
		}
		</script>
	</cfoutput>
	<!--- display text area --->
	<cfoutput><textarea name="#attributes.textareaname#" id="#attributes.textareaname#" cols="60" rows="20">#htmlEditFormat(attributes.value)#</textarea></cfoutput>

<cfelse>

	<!--- work out which editor to display --->
	<cfswitch expression="#application.config.general.richTextEditor#">

        <cfcase value="ktml">
	<cfsavecontent variable="ktml_content">
		<cfoutput>
		<style type="text/css">
		#plp-content .ktml_skin table {
			width: auto;
			float: none;
		}
		#plp-content .ktml_skin table td {
			padding: inherit;
			border: auto;
		}
		.ktml_bg tr {
			background: none;
		}
		</style>
        <script src="#application.url.farcry#/includes/lib/ktml/includes/common/js/base.js" type="text/javascript"></script>
        <script src="#application.url.farcry#/includes/lib/ktml/includes/common/js/utility.js" type="text/javascript"></script>
        <script src="#application.url.farcry#/includes/lib/ktml/includes/ktm/core/ktml.js" type="text/javascript"></script>
        <script src="#application.url.farcry#/includes/lib/ktml/includes/resources/ktml.js" type="text/javascript"></script>
        <script src="#application.url.farcry#/includes/lib/ktml/includes/ktm/core/modules.js" type="text/javascript"></script>
        <link href="#application.url.farcry#/includes/lib/ktml/includes/ktm/core/styles/ktml.css" rel="stylesheet" type="text/css" media="all" />

		<script type="text/javascript">
			ktml_init_object = {
				'debugger_params': false,
				'path': "../includes/lib/ktml/includes/ktm/",
				'server': "cfm"
			};
		</script>
		<script type="text/javascript">
			#attributes.textareaname#_config = {
				width: 700,
				height: 500,
				show_toolbar: "load",
				show_pi: true,
				background_color: '##ffffff',
				strip_server_location: false,
				auto_focus: true,
				module_props: { }, 
				buttons: [
            [1, "standard", ["cut", "copy", "paste", "undo", "redo", "find_replace", "toggle_visible", "spellcheck", "toggle_editmode", "toggle_fullscreen", "help"]],
            [1, "formatting", ["bold", "italic", "underline", "align_left", "align_center", "align_right", "align_justify", "numbered_list", "bulleted_list", "outdent", "indent", "clean_menu", "foreground_color", "background_color", "superscript", "subscript"]],
            [2, "styles", ["heading_list", "style_list", "fonttype_list", "fontsize_list"]],
            [2, "insert", ["insert_link", "insert_anchor", "insert_table", "insert_image", "insert_file", "insert_template", "horizontal_rule", "insert_character"]],
            [3, "form", ["insert_form", "insert_textfield", "insert_hiddenfield", "insert_textarea", "insert_checkbox", "insert_radiobutton", "insert_listmenu", "insert_filefield", "insert_button", "insert_label", "insert_fieldset"]]
				]
			};
			<cfinclude template="/farcry/farcry_core/admin/includes/lib/ktml/includes/ktm/ktml4.cfm">
			<cfscript>
            ktml4_obj1 = Request.KTML4_CreateObject("ktml4");
            ktml4_obj1.init("ktml1");
            ktml4_obj1.setModuleProperty("filebrowser", "AllowedModule", "true", false);
            ktml4_obj1.setModuleProperty("filebrowser", "MaxFileSize", "2000", true);
            ktml4_obj1.setModuleProperty("filebrowser", "RejectedFolders", ".svn,.thumbnails", false);
            ktml4_obj1.setModuleProperty("file", "UploadFolder", "uploads/files/", false);
            ktml4_obj1.setModuleProperty("file", "UploadFolderUrl", "uploads/files/", true);
            ktml4_obj1.setModuleProperty("file", "AllowedFileTypes", "doc, pdf, txt", true);
            ktml4_obj1.setModuleProperty("media", "UploadFolder", "uploads/media/", false);
            ktml4_obj1.setModuleProperty("media", "UploadFolderUrl", "uploads/media/", true);
            ktml4_obj1.setModuleProperty("media", "AllowedFileTypes", "bmp,mov,mpg,avi,mpeg,swf,wmv,jpg,jpeg,gif,png", true);
            ktml4_obj1.setModuleProperty("templates", "AllowedModule", "true", false);
            ktml4_obj1.setModuleProperty("templates", "UploadFolder", "uploads/templates/", false);
            ktml4_obj1.setModuleProperty("xhtml", "AllowedModule", "true", false);
            ktml4_obj1.setModuleProperty("xhtml", "xhtml_view_source", "true", true);
            ktml4_obj1.setModuleProperty("xhtml", "xhtml_save", "true", true);
            ktml4_obj1.setModuleProperty("spellchecker", "AllowedModule", "true", false);
            ktml4_obj1.setModuleProperty("css", "PathToStyle", "includes/ktm/styles/KT_styles.css", true);
            ktml4_obj1.setModuleProperty("hyperlink_browser", "ServiceProvider", "includes/ktm/hyperlink_service.cfm", true);
            ktml4_obj1.Execute();
			</cfscript>
		</script>
		</cfoutput>
	</cfsavecontent>
	<cfhtmlhead text="#ktml_content#">
	<cfoutput>
		<input type="hidden" id="#attributes.textareaname#" name="#attributes.textareaname#" value="#Request.KT_escapeAttribute(attributes.value)#" />
		<script>
			ktml_#attributes.textareaname# = new ktml('#attributes.textareaname#');
		</script>
	</cfoutput>
</cfcase>
		<cfcase value="soEditorPro">
			<!--- javascript for inserting images etc --->
			<cfoutput>
			<script type="text/javascript">
			function insertHTML(html)
			{<cfif fBrowserDetect() EQ "Microsoft IE">
				soEditorbody.insertText(html, '', true,true);<cfelse>
				document.editform.#attributes.textareaname#.value = document.editform.#attributes.textareaname#.value + html;</cfif>
			}
			</script>
			</cfoutput>

			<!--- display tag --->
			<tags:soEditor_pro
				form="editform"
				field="#attributes.textareaname#"
				id="#attributes.textareaname#"
				scriptpath="#application.url.farcry#/siteobjects/soeditor/pro/"
				html="#attributes.value#"
				width="#application.config.soEditorPro.width#"
				height="#application.config.soEditorPro.height#"
				cols="#application.config.soEditorPro.cols#"
				rows="#application.config.soEditorPro.rows#"
				pageedit="#application.config.soEditorPro.pageedit#"
				singlespaced="#application.config.soEditorPro.singlespaced#"
				wordcount="#application.config.soEditorPro.wordcount#"
				baseurl="#application.config.soEditorPro.baseurl#"
				basefont="#application.config.soEditorPro.basefont#"
				basefontsize="#application.config.soEditorPro.basefontsize#"
				basefontcolor="#application.config.soEditorPro.basefontcolor#"
				basebgcolor="#application.config.soEditorPro.basebgcolor#"
				validateonsave="#application.config.soEditorPro.validateonsave#"
				validationmessage="#application.config.soEditorPro.validationmessage#"
				showborders="#application.config.soEditorPro.showborders#"
				initialfocus="#application.config.soEditorPro.initialfocus#"
				new="#application.config.soEditorPro.new#"
				save="#application.config.soEditorPro.save#"
				cut="#application.config.soEditorPro.cut#"
				copy="#application.config.soEditorPro.copy#"
				paste="#application.config.soEditorPro.paste#"
				delete="#application.config.soEditorPro.delete#"
				find="#application.config.soEditorPro.find#"
				undo="#application.config.soEditorPro.undo#"
				redo="#application.config.soEditorPro.redo#"
				hr="#application.config.soEditorPro.hr#"
				image="#application.config.soEditorPro.image#"
				link="#application.config.soEditorPro.link#"
				unlink="#application.config.soEditorPro.unlink#"
				spellcheck="#application.config.soEditorPro.spellcheck#"
				help="#application.config.soEditorPro.help#"
				align="#application.config.soEditorPro.align#"
				list="#application.config.soEditorPro.list#"
				unindent="#application.config.soEditorPro.unindent#"
				indent="#application.config.soEditorPro.indent#"
				fontdialog="#application.config.soEditorPro.fontdialog#"
				format="#application.config.soEditorPro.format#"
				formatlist="#application.config.soEditorPro.formatlist#"
				formatlistlabels="#application.config.soEditorPro.formatlistlabels#"
				font="#application.config.soEditorPro.font#"
				fontlist="#application.config.soEditorPro.fontlist#"
				fontlistlabels="#application.config.soEditorPro.fontlistlabels#"
				size="#application.config.soEditorPro.size#"
				sizelist="#application.config.soEditorPro.sizelist#"
				sizelistlabels="#application.config.soEditorPro.sizelistlabels#"
				bold="#application.config.soEditorPro.bold#"
				italic="#application.config.soEditorPro.italic#"
				underline="#application.config.soEditorPro.underline#"
				superscript="#application.config.soEditorPro.superscript#"
				fgcolor="#application.config.soEditorPro.fgcolor#"
				bgcolor="#application.config.soEditorPro.bgcolor#"
				tables="#application.config.soEditorPro.tables#"
				insertcell="#application.config.soEditorPro.insertcell#"
				deletecell="#application.config.soEditorPro.deletecell#"
				insertrow="#application.config.soEditorPro.insertrow#"
				deleterow="#application.config.soEditorPro.deleterow#"
				insertcolumn="#application.config.soEditorPro.insertcolumn#"
				deletecolumn="#application.config.soEditorPro.deletecolumn#"
				splitcell="#application.config.soEditorPro.splitcell#"
				mergecell="#application.config.soEditorPro.mergecell#"
				cellprop="#application.config.soEditorPro.cellprop#"
				htmledit="#application.config.soEditorPro.htmledit#"
				borders="#application.config.soEditorPro.borders#"
				details="#application.config.soEditorPro.details#"
				anchor = "#application.config.soEditorPro.details#"
				specialCharacter = "#application.config.soEditorPro.specialCharacter#"
				allowFolderCreation = "#application.config.soEditorPro.allowFolderCreation#"
				allowUpload = "#application.config.soEditorPro.allowUpload#"
				autoSweep = "#application.config.soEditorPro.autoSweep#"
				baseCSS = "#application.config.soEditorPro.baseCSS#"
				codeSweeper = "#application.config.soEditorPro.codeSweeper#"
				cssList = "#application.config.soEditorPro.cssList#"
				cssListLabels = "#application.config.soEditorPro.cssListLabels#"
				cssField = "#application.config.soEditorPro.cssField#"
				formButton = "#application.config.soEditorPro.formButton#"
				genericForm = "#application.config.soEditorPro.genericForm#"
				hiddenBox = "#application.config.soEditorPro.hiddenBox#"
				mailForm  = "#application.config.soEditorPro.mailForm#"
				radioBox = "#application.config.soEditorPro.radioBox#"
				resetButton = "#application.config.soEditorPro.resetButton#"
				selectBox = "#application.config.soEditorPro.selectBox#"
				styleList = "#application.config.soEditorPro.styleList#"
				styleListLabels = "#application.config.soEditorPro.styleListLabels#"
				submitButton = "#application.config.soEditorPro.submitButton#"
				textArea = "#application.config.soEditorPro.textArea#"
				textBox = "#application.config.soEditorPro.textBox#">
		</cfcase>

		<cfcase value="soEditor">

			<!--- javascript for inserting images etc --->
			<cfoutput>
			<script type="text/javascript">
			function insertHTML(html)
			{<cfif fBrowserDetect() EQ "Microsoft IE">
				soEditorbody.insertText(html, '', true,true);<cfelse>
				document.editform.#attributes.textareaname#.value = document.editform.#attributes.textareaname#.value + html;</cfif>
			}
			</script>
			</cfoutput>

			<!--- display tag --->
			<tags:soEditor_lite
				form="editform"
				field="#attributes.textareaname#"
				id = "#attributes.textareaname#"
				scriptpath="#application.url.farcry#/siteobjects/soeditor/lite/"
				html="#attributes.value#"
				width="#application.config.soEditor.width#"
				height="#application.config.soEditor.height#"
				cols="#application.config.soEditor.cols#"
				rows="#application.config.soEditor.rows#"
				pageedit="#application.config.soEditor.pageedit#"
				singlespaced="#application.config.soEditor.singlespaced#"
				wordcount="#application.config.soEditor.wordcount#"
				baseurl="#application.config.soEditor.baseurl#"
				basefont="#application.config.soEditor.basefont#"
				basefontsize="#application.config.soEditor.basefontsize#"
				basefontcolor="#application.config.soEditor.basefontcolor#"
				basebgcolor="#application.config.soEditor.basebgcolor#"
				validateonsave="#application.config.soEditor.validateonsave#"
				validationmessage="#application.config.soEditor.validationmessage#"
				showborders="#application.config.soEditor.showborders#"
				initialfocus="#application.config.soEditor.initialfocus#"
				new="#application.config.soEditor.new#"
				save="#application.config.soEditor.save#"
				cut="#application.config.soEditor.cut#"
				copy="#application.config.soEditor.copy#"
				paste="#application.config.soEditor.paste#"
				delete="#application.config.soEditor.delete#"
				find="#application.config.soEditor.find#"
				undo="#application.config.soEditor.undo#"
				redo="#application.config.soEditor.redo#"
				hr="#application.config.soEditor.hr#"
				image="#application.config.soEditor.image#"
				link="#application.config.soEditor.link#"
				unlink="#application.config.soEditor.unlink#"
				spellcheck="#application.config.soEditor.spellcheck#"
				help="#application.config.soEditor.help#"
				align="#application.config.soEditor.align#"
				list="#application.config.soEditor.list#"
				unindent="#application.config.soEditor.unindent#"
				indent="#application.config.soEditor.indent#"
				fontdialog="#application.config.soEditor.fontdialog#"
				format="#application.config.soEditor.format#"
				formatlist="#application.config.soEditor.formatlist#"
				formatlistlabels="#application.config.soEditor.formatlistlabels#"
				font="#application.config.soEditor.font#"
				fontlist="#application.config.soEditor.fontlist#"
				fontlistlabels="#application.config.soEditor.fontlistlabels#"
				size="#application.config.soEditor.size#"
				sizelist="#application.config.soEditor.sizelist#"
				sizelistlabels="#application.config.soEditor.sizelistlabels#"
				bold="#application.config.soEditor.bold#"
				italic="#application.config.soEditor.italic#"
				underline="#application.config.soEditor.underline#"
				superscript="#application.config.soEditor.superscript#"
				fgcolor="#application.config.soEditor.fgcolor#"
				bgcolor="#application.config.soEditor.bgcolor#"
				tables="#application.config.soEditor.tables#"
				insertcell="#application.config.soEditor.insertcell#"
				deletecell="#application.config.soEditor.deletecell#"
				insertrow="#application.config.soEditor.insertrow#"
				deleterow="#application.config.soEditor.deleterow#"
				insertcolumn="#application.config.soEditor.insertcolumn#"
				deletecolumn="#application.config.soEditor.deletecolumn#"
				splitcell="#application.config.soEditor.splitcell#"
				mergecell="#application.config.soEditor.mergecell#"
				cellprop="#application.config.soEditor.cellprop#"
				htmledit="#application.config.soEditor.htmledit#"
				borders="#application.config.soEditor.borders#"
				details="#application.config.soEditor.details#"
				anchor="false">
		</cfcase>

		<cfcase value="eWebEditPro">
			<!--- javascript for inserting images etc --->
			<cfoutput>
				<script language="JavaScript">
				function insertHTML( html )
				{
					eWebEditPro.#application.config.eWebEditPro.editorName#.pasteHTML(html);
				}
				</script>
			</cfoutput>
			<!---display tag--->
			<tags:eWebEditPro3
				path="#application.config.eWebEditPro.path#"
				maxContentSize="#application.config.eWebEditPro.maxContentSize#"
				name="#application.config.eWebEditPro.editorName#"
				editorName="#application.config.eWebEditPro.alternativeEditorName#"
				width="#application.config.eWebEditPro.width#"
				height="#application.config.eWebEditPro.height#"
				value="#attributes.value#"
				license="#application.config.eWebEditPro.license#"
				locale="#application.config.eWebEditPro.locale#"
				config="#application.config.eWebEditPro.config#"
				styleSheet="#application.config.eWebEditPro.styleSheet#"
				bodyStyle="#application.config.eWebEditPro.bodyStyle#"
				hideAboutButton="#application.config.eWebEditPro.hideAboutButton#"
				onDblClickElement="#application.config.eWebEditPro.onDblClickElement#"
				onExecCommand="#application.config.eWebEditPro.onExecCommand#"
				onFocus="#application.config.eWebEditPro.onFocus#"
				onBlur="#application.config.eWebEditPro.onBlur#">
		</cfcase>

		<cfcase value="textArea">

			<!--- javascript for inserting images etc --->
			<cfoutput>
				<script type="text/javascript">
				function insertHTML(html,field )
				{
					document.editform.#attributes.textareaname#.value = document.editform.#attributes.textareaname#.value + (html);
				}
				</script>
			</cfoutput>
			<!--- display text area --->
			<cfoutput><textarea name="#attributes.textareaname#" id="#attributes.textareaname#" cols="60" rows="20">#attributes.value#</textarea></cfoutput>
		</cfcase>

		<cfcase value="htmlArea">
			<!--- load HTMLArea --->
			<cfsavecontent variable="htmlAreaScript">
				<cfoutput>
				<!-- // Load the HTMLEditor and set the preferences // -->
				<script type="text/javascript">
				   _editor_url = "#application.url.farcry#/includes/lib/htmlarea/";
				   _editor_lang = "en";
				</script>
				<script type="text/javascript" src="#application.url.farcry#/includes/lib/htmlarea/htmlarea.js"></script>
				<script type="text/javascript" src="#application.url.farcry#/includes/lib/htmlarea/dialog.js"></script>
				<script type="text/javascript" src="#application.url.farcry#/includes/lib/htmlarea/lang/en.js"></script>
			
				<script type="text/javascript">
					var config = new HTMLArea.Config();
					config.toolbar = [
						#application.config.htmlarea.Toolbar1#
						,#application.config.htmlarea.Toolbar2#
					];	
				</script>
			
				<script type="text/javascript">
				<cfif isBoolean(application.config.htmlArea.useContextMenu) AND application.config.htmlArea.useContextMenu>
					HTMLArea.loadPlugin("ContextMenu");	          
				</cfif>
				 //HTMLArea.loadPlugin("CSS");
				 <cfif isBoolean(application.config.htmlArea.useTableOperations) AND application.config.htmlArea.useTableOperations>
					 HTMLArea.loadPlugin("TableOperations");
				 </cfif>
					HTMLArea.loadPlugin("CharacterMap");
					
					window.onload = function()
					{
						HTMLArea.init();
					}
					
				</script>
				<!-- // Finished loading HTMLEditor //-->
				</cfoutput>
			</cfsavecontent>
			<cfhtmlhead text="#htmlAreaScript#">			
			
			<cfset uniqueId = replace(createUUID(),'-','','all')>
			<!--- display text area --->
			<cfoutput><div id="htmlareawrapper"><textarea id="#attributes.textareaname#" name="#attributes.textareaname#" id="#uniqueID#">#attributes.value#</textarea></div></cfoutput>


			<!--- javascript for inserting images etc --->
			<cfoutput>
				<script language="JavaScript">
				
				/*
				var config = new HTMLArea.Config();
				config.toolbar = [
					#application.config.htmlarea.Toolbar1#
					,#application.config.htmlarea.Toolbar2#
					];
				*/
				
				config.height = "#application.config.htmlArea.height#";
				config.width = "#application.config.htmlArea.width#";
			
				 initEditor = function()
				 {
					editor#attributes.textareaname# = new HTMLArea("#uniqueid#",config);
			      	
			     	<cfif len(application.config.htmlArea.pageStyle)>
        		  	editor#attributes.textareaname#.config.pageStyle = "@import url(#application.config.htmlArea.pageStyle#);";
        		  	</cfif>
			      	// editor.registerPlugin(CSS);
			      	<cfif isBoolean(application.config.htmlArea.useContextMenu) AND application.config.htmlArea.useContextMenu>
				  	editor#attributes.textareaname#.registerPlugin(ContextMenu);
				  	</cfif>
				  	<cfif isBoolean(application.config.htmlArea.useTableOperations) AND application.config.htmlArea.useTableOperations>
				  	editor#attributes.textareaname#.registerPlugin(TableOperations);
				  	</cfif>
				  	editor#attributes.textareaname#.registerPlugin(CharacterMap);
        		  	editor#attributes.textareaname#.generate();
      			 }
				 
				 HTMLArea.onload = initEditor;
				 				
				 function insertHTML( html )
				 {	//TODO this focuse editor produces the undesirable side effect that images are inserted
					//at the top of the page. However this is better than when inserting from the tree having them inserted at the top of the tree frame. 
					//Will have to devote some more time to sussing this later.
					editor#attributes.textareaname#.focusEditor();
					editor#attributes.textareaname#.insertHTML(html);
				 } 
				</script>
			</cfoutput>

		</cfcase>
		
		<cfcase value="fckEditor">
			<!--- load FCKEditor --->
			<cfsavecontent variable="fckEditorScript">
				<cfoutput>
				<!-- // load FCKEditor and set preferences // -->
				<script type="text/javascript" src="#application.url.farcry#/includes/lib/fckeditor/fckeditor.js"></script>
				<!-- // finished loading FCKEditor //-->	
				<script type="text/javascript">
					function insertHTML( html )
					 {	
					 	 	 var fck = FCKeditorAPI.GetInstance("#attributes.textareaname#");
							 fck.InsertHtml(html,true) ; 
							 
					 } 
				</script>
				</cfoutput>
			</cfsavecontent>				
			<cfhtmlhead text="#fckeditorscript#">	
			<cfscript>
 	 			fckEditor = createObject("component", "/farcry/includes/lib/fckeditor/fckeditor");
				fckEditor.toolBarSet="#application.config.fckEditor.toolBarSet#";
	 			fckEditor.instanceName="#attributes.textareaname#";
	 			fckEditor.basePath="#application.url.farcry#/includes/lib/fckeditor/";
	 			fckEditor.value="#attributes.value#";
 	 			fckEditor.width="#application.config.fckEditor.width#";
	 			fckEditor.height="#application.config.fckEditor.height#";
		 		fckEditor.create(); // create instance now.
			</cfscript>		
		</cfcase>

		<cfcase value="eopro">
			<cfoutput>
			<script language="javascript">
			<!--
	
				function scriptForm_onsubmit()
				{
					document.editform.#attributes.textareaname#.value = document.MyEditor.getHTMLData("http://");
					document.editform.submit();
	
				}
	
			   //-------------------------------------------------------------------------//
			   //The CSS-Data can not be loaded before HTMLData is completely loaded.
			   //Thats why "ONEDITORLOADED" and "ONDATALOADED" is used below
			   //-------------------------------------------------------------------------//
			   //This function is called when the applet has finished loading
	
				function loadData()
				{
				   document.MyEditor.setHTMLData("http://", document.editform.#attributes.textareaname#.value)
	
				}
	
			   //This function is called when the editor has finished the loading of HTMLData
				function setstyle()
				{
					document.MyEditor.setStyleSheet( document.editform.CSSText.value)
				}
	
				function insertHTML( html,field )
				{
					document.MyEditor.insertHTMLData("http://", html);
					//editform.#attributes.textareaname#.value = editform.#attributes.textareaname#.value + (html);
				}
	
	
	
			//-->
			</script>
	
	
			<applet code="com.realobjects.eop.applet.EditorApplet" height="#application.config.eoPro.height#" id="editor" codebase="#application.config.eoPro.codebase#" name="MyEditor" width="#application.config.eoPro.width#" archive="edit-on-pro-signed.jar,tidy.jar,ssce.jar" mayscript>
	        <param name="cabbase" value="#application.config.eoPro.cabbase#">
	        <param name="locale" value="#application.config.eoPro.locale#">
	        <param name="help"   value="#application.config.eoPro.help#">
	        <param name="configurl"  value="#application.config.eoPro.configURL#">
	        <param name="toolbarurl" value="#application.config.eoPro.toolbarurl#">
	        <param name="sourceview" value="#application.config.eoPro.sourceview#">
	        <param name="sourceviewwordwrap" value="#application.config.eoPro.sourceviewwordwrap#">
	        <param name="bodyonly"  value="#application.config.eoPro.bodyonly#">
	        <param name="smartindent" value="#application.config.eoPro.smartindent#">
	        <param name="multipleundoredo" value="#application.config.eoPro.multipleundoredo#">
	        <param name="oldfontstylemode" value="#application.config.eoPro.oldfontstylemode#">
	        <param name="nbspfill" value="#application.config.eoPro.nbspfill#">
	        <param name="customcolorsenabled" value="#application.config.eoPro.customcolorsenabled#">
	        <param name="tablenbspfill" value="#application.config.eoPro.tablenbspfill#">
	        <param name="inserttext_html" value="#application.config.eoPro.inserttext_html#">
	        <param name="oneditorloaded" value="#application.config.eoPro.oneditorloaded#">
	        <param name="ondataloaded" value="#application.config.eoPro.ondataloaded#">
	        <!-- Applet Layout params -->
	        <param name="windowfacecolor" value="#application.config.eoPro.windowfacecolor#">
	        <param name="tabpaneactivecolor" value="#application.config.eoPro.tabpaneactivecolor#">
	        <param name="windowhighlightcolor" value="#application.config.eoPro.windowhighlightcolor#">
	        <param name="lightedgecolor" value="#application.config.eoPro.lightedgecolor#">
	        <param name="darkedgecolor" value="#application.config.eoPro.darkedgecolor#">
	        <param name="innertextcolor" value="#application.config.eoPro.innertextcolor#">
	        <param name="startupscreenbackgroundcolor" value="#application.config.eoPro.startupscreenbackgroundcolor#">
	        <param name="startupscreentextcolor" value="#application.config.eoPro.startupscreentextcolor#">
	        <!-- End - Applet Layout params -->
			</applet>
			<textarea name="#attributes.textareaname#" id="#attributes.textareaname#" cols="1" rows="1" style="visibility:hidden;">#attributes.value#</textarea>
			</cfoutput>
			<cfif application.config.general.richTextEditor IS "eoPro">
	
	    			<!--This hidden textarea field will receive the CSSData on submitting the form. Needed by RealObjects eoPro-->
					<cfset cssText = "">
	
					<cfif fileExists(expandPath(application.config.eoPro.defaultcss))>
						<cffile action="read" file="#expandPath(application.config.eoPro.defaultcss)#" variable="cssText">
					</cfif>
					<!--- <cfset cssText = "h1{color:red}"> --->
					<cfoutput>
			    	<textarea name="CSSText" cols="1" rows="1" style="visibility:hidden;">#CSSText#</textarea>
					</cfoutput>
	
	
			</cfif>
		</cfcase>
		
		<cfcase value="eoPro4">
			<cfoutput>
				<script type="text/javascript" src="#application.config.eoPro4.codebase#/editonpro.js"></script>
				<script type="text/javascript">
					eop = new editOnPro(#application.config.eoPro4.width#, #application.config.eoPro4.height#, "myEditor", "myId", "eop");
					eop.setCodebase("#application.config.eoPro4.codebase#");
	   				eop.setConfigURL("#application.config.eoPro4.configURL#")
	   				eop.setUIConfigURL("#application.config.eoPro4.UIConfigURL#");
	   				eop.setStartUpScreenTextColor("#application.config.eoPro4.StartUpScreenTextColor#");
	   				eop.setStartUpScreenBackgroundColor("#application.config.eoPro4.StartUpScreenBackgroundColor#");
	   				/*eop.setImageBase(document.URL);*/
	   				eop.setLookAndFeel("#application.config.eoPro4.LookAndFeel#");
					
					function scriptForm_onsubmit()
	   				{
				       document.editform.#attributes.textareaname#.value = eop.getHTMLData();
				       document.editform.submit();
				    }  
					
					function insertHTML(html,field)
					{
						eop.insertHTMLData(html);
	    			    eop.pumpEvents();
					}
					
					eop.loadEditor();
				</script>
				 <textarea name="#attributes.textareaname#" cols="1" rows="1" style="visibility:hidden;"><cfoutput>#HtmlEditFormat(attributes.value)#</cfoutput></textarea>
		    	 <!--This hidden textarea field will receive the CSSData on submitting the form.-->
				 <cfset cssText = "">
				 <cfif fileExists(expandPath(application.config.eoPro4.defaultcss))>
					<cffile action="read" file="#expandPath(application.config.eoPro4.defaultcss)#" variable="cssText">
				 </cfif>
		    	 <textarea name="CSSText" cols="1" rows="1" style="visibility:hidden;"><cfoutput>#HtmlEditFormat(CSSText)#</cfoutput></textarea>
				 <script>
				 	eop.setHTMLData(document.editform.#attributes.textareaname#.value);
		          	eop.setStyleSheet(document.editform.CSSText.value);
	    	      	eop.pumpEvents();
				 </script>
				 <!--onClickEvent used through farcry type edit plps. --->
				 <cfif isDefined("caller.onClickEvent")>
				 	<cfset caller.onClickEvent =  "scriptForm_onsubmit();">
				 </cfif>
				 
			 </cfoutput>
		</cfcase>
		<cfcase value="tinymce">
			<!--- load TinyMCE --->
			<cfsavecontent variable="tinyMCEjs">
				<cfoutput>
				<!-- // load tinyMCE and set preferences // -->
				<script type="text/javascript" src="#application.url.farcry#/includes/lib/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
				<script type="text/javascript">
				tinyMCE.init({
					mode : "exact",
					elements : "#attributes.textareaname#",
					insertimage_callback : "showWindowdmImage",
					file_browser_callback : "showWindowdmFile",
					#application.config.tinyMCE.tinyMCE_config#
				});
				</script>
				
				<script type="text/javascript">
					//returns the selected text from the editor
					function TinyMCE_getSelectedText(){
					     var inst = tinyMCE.selectedInstance;
					   
					     if (tinyMCE.isMSIE) {
					    var doc = inst.getDoc();
					    var rng = doc.selection.createRange();
					    selectedText = rng.text;
					     } else {
					    var sel = inst.contentWindow.getSelection();
					   
					    if (sel && sel.toString){
					                    selectedText = sel.toString();
					    }else{
					       selectedText = '';
					    }
					    }
					    return selectedText;
					} 					
					
					function insertHTML( html ) {	
					 	//Are we inserting an image or anchor?
					 	if(html.indexOf('<img') == -1) {
					 		//Is there selected text in the editor?
					 		if(TinyMCE_getSelectedText().length != 0) {
								var Pattern = />[\S\s]+<\/a>$/i;
								var match = Pattern.exec(html);
								//Did we get a pattern match?					 		
								if(match != null) {
									//Replace the original anchor with the selection
									html = html.replace(Pattern, '>{$selection}</a>');
									//Replace rather than insert
								 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceReplaceContent',false,html);
								}
								else
								 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
					 	 	}
					 	 	else
							 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
						}
					 	else
						 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
					}
				</script>
				</cfoutput>
			</cfsavecontent>				
			<cfhtmlhead text="#tinyMCEjs#">
			<cfoutput><textarea id="#attributes.textareaname#" name="#attributes.textareaname#" cols="50" rows="15">#attributes.value#</textarea></cfoutput>
		</cfcase>
		
		<!--- Default Editor --->
		<cfdefaultcase>
			<!--- load TinyMCE --->
			<cfsavecontent variable="tinyMCEjs">
				<cfoutput>
					<!-- // load tinyMCE and set preferences // -->
					<script type="text/javascript" src="#application.url.farcry#/includes/lib/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
					<script type="text/javascript">
					tinyMCE.init({
						mode : "exact",
						elements : "#attributes.textareaname#",
						insertimage_callback : "showWindowdmImage",
						file_browser_callback : "showWindowdmFile"
					});
					</script>
					<script type="text/javascript">
						//returns the selected text from the editor
						function TinyMCE_getSelectedText(){
						     var inst = tinyMCE.selectedInstance;
						   
						     if (tinyMCE.isMSIE) {
						    var doc = inst.getDoc();
						    var rng = doc.selection.createRange();
						    selectedText = rng.text;
						     } else {
						    var sel = inst.contentWindow.getSelection();
						   
						    if (sel && sel.toString){
						                    selectedText = sel.toString();
						    }else{
						       selectedText = '';
						    }
						    }
						    return selectedText;
						} 					
						
						function insertHTML( html ) {	
						 	//Are we inserting an image or anchor?
						 	if(html.indexOf('<img') == -1) {
						 		//Is there selected text in the editor?
						 		if(TinyMCE_getSelectedText().length != 0) {
									var Pattern = />[\S\s]+<\/a>$/i;
									var match = Pattern.exec(html);
									//Did we get a pattern match?					 		
									if(match != null) {
										//Replace the original anchor with the selection
										html = html.replace(Pattern, '>{$selection}</a>');
										//Replace rather than insert
									 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceReplaceContent',false,html);
									}
									else
									 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
						 	 	}
						 	 	else
								 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
							}
						 	else
							 	tinyMCE.execInstanceCommand('#attributes.textareaname#','mceInsertContent',false,html);
						}
					</script>
				</cfoutput>
			</cfsavecontent>				
			<cfhtmlhead text="#tinyMCEjs#">
			<cfoutput><textarea id="#attributes.textareaname#" name="#attributes.textareaname#" cols="50" rows="15">#attributes.value#</textarea></cfoutput>
		</cfdefaultcase>>

	</cfswitch>
</cfif>
<cfsetting enablecfoutputonly="no">
