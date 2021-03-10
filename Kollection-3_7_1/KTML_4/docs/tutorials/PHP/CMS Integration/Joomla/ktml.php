<?php

/** ensure this file is being included by a parent file */
defined( '_VALID_MOS' ) or die( 'Direct Access to this location is not allowed.' );

$_MAMBOTS->registerFunction( 'onInitEditor', 'botKTMLInit' );
$_MAMBOTS->registerFunction( 'onGetEditorContents', 'botKTMLGetContents' );
$_MAMBOTS->registerFunction( 'onEditorArea', 'botKTMLEditorArea' );

function botKTMLInit() {
	global $mosConfig_live_site, $database, $mosConfig_absolute_path;

	// load KTML info
	$query = "SELECT id FROM #__mambots WHERE element = 'ktml' AND folder = 'editors'";
	$database->setQuery( $query );
	$database->loadObject($mambot);

	return <<<EOD
<script src="$mosConfig_live_site/mambots/editors/ktml/includes/common/js/base.js" type="text/javascript"></script>
<script src="$mosConfig_live_site/mambots/editors/ktml/includes/common/js/utility.js" type="text/javascript"></script>
<script src="$mosConfig_live_site/mambots/editors/ktml/includes/ktm/core/ktml.js" type="text/javascript"></script>
<script src="$mosConfig_live_site/mambots/editors/ktml/includes/resources/ktml.js" type="text/javascript"></script>
<script src="$mosConfig_live_site/mambots/editors/ktml/includes/ktm/core/modules.js" type="text/javascript"></script>
<link href="$mosConfig_live_site/mambots/editors/ktml/includes/ktm/core/styles/ktml.css" rel="stylesheet" type="text/css" media="all" />
<script>
	ktml_init_object = {
		debugger_params: false,
		path: '../mambots/editors/ktml/includes/ktm/',
		server: 'php'
	};
</script>
EOD;
}

function botKTMLGetContents( $editorArea, $hiddenField ) {
  return <<<EOD
EOD;
}

function botKTMLEditorArea( $name, $content, $hiddenField, $width, $height, $col, $row ) {
	global $mosConfig_absolute_path, $mosConfig_live_site, $_MAMBOTS;

	require_once($mosConfig_absolute_path . '/mambots/editors/ktml/includes/ktm/ktml4.php');
	ob_start();
		$ktml_obj1 = new ktml4($hiddenField);
		$ktml_obj1->setModuleProperty('filebrowser', 'AllowedModule', 'true', false);
		$ktml_obj1->setModuleProperty("filebrowser", "MaxFileSize", "2000", true);
		$ktml_obj1->setModuleProperty("filebrowser", "RejectedFolders", ".svn,.thumbnails", false);
		$ktml_obj1->setModuleProperty("file", "UploadFolder", "uploads/files/", false);
		$ktml_obj1->setModuleProperty("file", "UploadFolderUrl", "uploads/files/", true);
		$ktml_obj1->setModuleProperty("file", "AllowedFileTypes", "doc,pdf,txt", true);
		$ktml_obj1->setModuleProperty("media", "UploadFolder", "uploads/media/", false);
		$ktml_obj1->setModuleProperty("media", "UploadFolderUrl", "uploads/media/", true);
		$ktml_obj1->setModuleProperty("media", "AllowedFileTypes", "bmp,mov,mpg,avi,mpeg,swf,wmv,jpg,jpeg,gif,png", true);        
		$ktml_obj1->setModuleProperty("templates", "AllowedModule", "true", false);
		$ktml_obj1->setModuleProperty("templates", "UploadFolder", "uploads/templates/", false);
		$ktml_obj1->setModuleProperty("xhtml", "AllowedModule", "true", false);
		$ktml_obj1->setModuleProperty("xhtml", "xhtml_view_source", "true", true);
		$ktml_obj1->setModuleProperty("xhtml", "xhtml_save", "true", true);
		$ktml_obj1->setModuleProperty("spellchecker", "AllowedModule", "true", false);
		$ktml_obj1->setModuleProperty("css", "PathToStyle", "includes/ktm/styles/KT_styles.css", true);
		$ktml_obj1->setModuleProperty("hyperlink_browser", "ServiceProvider", "includes/ktm/hyperlink_service.php", true);
		$ktml_obj1->setModuleProperty("date", "AllowedModule", "true", false);

$ktml_obj1->Execute();

	$res = ob_get_contents();
	ob_end_clean();

	return <<<EOD
<script>
	{$hiddenField}_config = {
		width: '700',
		height: '500',
		show_toolbar: 'load',
		show_pi: true,
		background_color: '#FFFFFF',
		strip_server_location: true,
		auto_focus: true,
		module_props: { },
		buttons: [
            [1, 'standard', ["cut", "copy", "paste", "undo", "redo", "find_replace", "toggle_visible", "spellcheck", "toggle_editmode", "toggle_fullscreen", "help"]],
            [1, 'formatting', ["bold", "italic", "underline", "align_left", "align_center", "align_right", "align_justify", "numbered_list", "bulleted_list", "outdent", "indent", "clean_menu", "foreground_color", "background_color", "superscript", "subscript"]],
            [2, 'styles', ["heading_list", "style_list", "fonttype_list", "fontsize_list"]],
            [2, 'insert', ["insert_link", "insert_anchor", "insert_table", "insert_image", "insert_file", "insert_template", "horizontal_rule", "insert_character"]],
            [3, 'form', ["insert_form", "insert_textfield", "insert_hiddenfield", "insert_textarea", "insert_checkbox", "insert_radiobutton", "insert_listmenu", "insert_filefield", "insert_button", "insert_label", "insert_fieldset"]]
		]
	}
	$res
</script>
<input type="hidden" id="$hiddenField" name="$hiddenField" value="$content" />
<script>
	ktml_$hiddenField = new ktml('$hiddenField');
</script>
EOD;
}
?>