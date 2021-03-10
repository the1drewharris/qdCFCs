<?
/*
Plugin Name: KTML4
Plugin URI: http://www.interaktonline.com/KTML4/
Description: Replaces the editing textarea with a WYSIWYG editor
Version: 1.0
Author: InterAKT Online
Author URI: http://www.interaktonline.com/
*/

function wp_ktml_insert_head() {
$siteurl = get_settings('siteurl');
$ktml_plugin_path = $siteurl . '/wp-content/plugins/ktml/';
echo '
<link href="'.$ktml_plugin_path.'includes/ktm/styles/KT_styles.css" rel="stylesheet"
type="text/css">
';
}

function admin_ktml_insert_head() {
$siteurl = get_settings('siteurl');
$ktml_plugin_path = $siteurl . '/wp-content/plugins/ktml/';
echo '
<script src="'.$ktml_plugin_path.'includes/common/js/base.js" type="text/javascript"></script>
<script src="'.$ktml_plugin_path.'includes/common/js/utility.js" type="text/javascript"></script>
<script src="'.$ktml_plugin_path.'includes/ktm/core/ktml.js" type="text/javascript"></script>
<script src="'.$ktml_plugin_path.'includes/resources/ktml.js" type="text/javascript"></script>
<script src="'.$ktml_plugin_path.'includes/ktm/core/modules.js" type="text/javascript"></script>
<link href="'.$ktml_plugin_path.'includes/ktm/core/styles/ktml.css" rel="stylesheet"
type="text/css">

<script>
ktml_init_object = {
"debugger_params": false,
"path": "../wp-content/plugins/ktml/includes/ktm/",
"server": "php"
};
</script>

<script>
// removes quicktags
function remove_quicktags() {
var el = document.getElementById("quicktags");
if (el) {
el.innerHTML = "";
el.style.display = "none";
}
}
</script>
';
}

function ktml_insert() {
$siteurl = get_settings('siteurl');
$ktml_plugin_path = $siteurl . '/wp-content/plugins/ktml/';
$field = 'content';
echo ' <script>'.$field.'_config = {
width: 680,
height: 500,
show_toolbar: "load",
show_pi: true,
background_color: "#ffffff",
strip_server_location: true,
auto_focus: true,
module_props: { }, 
buttons: [
[1, "standard", ["cut", "copy", "paste", "undo", "redo", "find_replace", "toggle_visible", "spellcheck", "toggle_editmode", "toggle_fullscreen", "help"]],
            [1, "formatting", ["bold", "italic", "underline", "align_left", "align_center", "align_right", "align_justify", "numbered_list", "bulleted_list", "outdent", "indent", "clean_menu", "foreground_color", "background_color", "superscript", "subscript"]],
            [2, "styles", ["heading_list", "style_list", "fonttype_list", "fontsize_list"]],
            [2, "insert", ["insert_link", "insert_anchor", "insert_table", "insert_image", "insert_file", "insert_template", "horizontal_rule", "insert_character"]],
            [3, "form", ["insert_form", "insert_textfield", "insert_hiddenfield", "insert_textarea", "insert_checkbox", "insert_radiobutton", "insert_listmenu", "insert_filefield", "insert_button", "insert_label", "insert_fieldset"]]
		]
};';
require_once(ABSPATH . 'wp-content/plugins/ktml/includes/ktm/ktml4.php');
$ktml_obj1 = new ktml4($field, "../wp-content/plugins/ktml/", dirname(realpath(__FILE__)));
$ktml_obj1->setModuleProperty("filebrowser", "AllowedModule", "true", false);
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

echo '</script>';
echo ' <script> ktml_'.$field.' = new ktml("'.$field.'"); remove_quicktags();</script>';
}

add_action('simple_edit_form', 'ktml_insert');
add_action('edit_form_advanced', 'ktml_insert');
add_action('edit_page_form', 'ktml_insert');
add_action('wp_head', 'wp_ktml_insert_head');
add_action('admin_head', 'admin_ktml_insert_head');
?>
