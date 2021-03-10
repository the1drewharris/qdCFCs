<?php

class NP_ktml extends NucleusPlugin {

	function NP_ktml() {
		$available = array('english');
		$this->language = getLanguageName();
		if (!in_array($this->language,$available)) {
			 $this->language = 'english';
		}
	}

	function getName() {
		return 'KTML 4';
	}
	
	function getAuthor() {
		return 'InterAKT Online';
	}
	
	function getURL()  {
		return 'http://www.interaktonline.com/';
	}
	
	function getDescription() {
		return $this->I18N('description');
	}

	function getVersion() {
		return '0.2';
	}
	
	function getMinNucleusVersion() {
		return '300';
	}
	
	function supportsFeature($what) {
		switch($what) {
			case 'SqlTablePrefix':
				return 1;
			default:
				return 0;
		}
	}

	function install() {
		// create plugin options (per-blog options)
		$this->createMemberOption('editormode',$this->I18N('editormode'),'select','yes',$this->I18N('opt_editormode'));
		
		// standard textmode settings
		$this->createOption('enable_br', $this->I18N('enable_br'), "yesno", "yes");
		
		$this->setLinebreakConversion(0); // disable auto-linebreak conversions
		// no javascript editbar
		mysql_query("UPDATE ".sql_table('config')." SET value='1' WHERE name='DisableJSTools'");
	}

	function setLinebreakConversion($mode) {
	  $res = mysql_fetch_object(sql_query("SELECT bconvertbreaks FROM ".sql_table('blog')));
		if ($res->bconvertbreaks != $mode) {
			mysql_query("UPDATE ".sql_table('blog')." SET bconvertbreaks=".$mode);
		}
	}

   // restore to standard settings
	function unInstall() {
		$this->setLinebreakConversion(1);
		mysql_query("UPDATE ".sql_table('config')." SET value='2' WHERE name='DisableJSTools'");
	}

	function getEventList() {
		return array(
			'AdminPrePageHead',      // include javascript on admin add/edit pages
			'BookmarkletExtraHead',  // include javascript on bookmarklet pages
			'PreSendContentType',    // we need to force text/html instead of application/xhtml+xml
			'AddItemFormExtras',
			'EditItemFormExtras'
		);
	}


	function event_BookmarkletExtraHead(&$data) {
		$this->_getHeadContent($data['extrahead']);
	}

	function event_AdminPrePageHead(&$data) {
		$action = $data['action'];
		if (($action != 'createitem') && ($action != 'itemedit')) {
			return;
		}
		$this->_getHeadContent($data['extrahead']);
	}

	function _getHeadContent(&$extrahead) {
		global $CONF, $memberid, $memberadmin, $member;
		
		if (empty($memberid)) {
			$memberid = $member->id;
		}
		
		if (empty($memberadmin)) {
			$memberadmin = $member->admin;
		}
		$media_path = '';
		if ($memberadmin != '1') {
			$media_path = $memberid . '/';
		}
		// get member settings
		$editorMode = $this->getMemberOption($memberid, 'editormode');
		
		$baseUrl = $this->getAdminURL();
		$basePath = $this->getDirectory();
		$ediCode = '';
		if ($editorMode != 'no') {
			// To avoid conflicts if a other user use only textmode we must set this on all calls
			$CONF['DisableJsTools'] = 1; // overrule simple global settings
			$this->setLinebreakConversion(0);
			
			$ediCode .= '
                <script src="'.$baseUrl.'includes/common/js/base.js" type="text/javascript"></script>
                <script src="'.$baseUrl.'includes/common/js/utility.js" type="text/javascript"></script>
                <script src="'.$baseUrl.'includes/ktm/core/ktml.js" type="text/javascript"></script>
                <script src="'.$baseUrl.'includes/resources/ktml.js" type="text/javascript"></script>
                <script src="'.$baseUrl.'includes/ktm/core/modules.js" type="text/javascript"></script>
                <link href="'.$baseUrl.'includes/ktm/core/styles/ktml.css" rel="stylesheet" type="text/css">
				<script type="text/javascript">
					ktml_init_object = {
						"debugger_params": false,
						"path": "plugins/ktml/includes/ktm/",
						"server": "php"
					};
				</script>
				<script type="text/javascript">
					inputbody_config = {
						width: 700,
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
                            [3, "form", ["insert_form", "insert_textfield", "insert_hiddenfield", "insert_textarea", "insert_checkbox", "insert_radiobutton", "insert_listmenu", "insert_filefield", "insert_button", "insert_label", "insert_fieldset"]] "insert_filefield", "insert_hiddenfield", "insert_fieldset", "insert_label"]]
						]
					}
			';
			require_once($basePath . 'includes/ktm/ktml4.php');
			ob_start();
				$ktml_obj1 = new ktml4("inputbody", "plugins/ktml/", dirname(realpath(__FILE__)));
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
				$ktml4_obj1->Execute();
			$ediCode .= ob_get_contents();
			ob_end_clean();
			$ediCode .= '
				</script>
			';
		} else  {
			$CONF['DisableJsTools'] = 2;
			$linebreak_conversion = $this->getOption('enable_br') == 'yes' ? 1 : 0;
			$this->setLinebreakConversion($linebreak_conversion);
		}
		$extrahead .= $ediCode;
	}

	function event_AddItemFormExtras(&$data) {
		$this->_startKTMLinstance();
	}

	function event_EditItemFormExtras(&$data) {
		$this->_startKTMLinstance();
	}

	function _startKTMLinstance() {
		echo '
			<script type="text/javascript">
				ktml_inputbody = new ktml("inputbody");
			</script>
		';
	}

	function event_PreSendContentType(&$data) {
		$pageType = $data['pageType'];
		if ($pageType == 'skin') {
			return;
		}
		if ( ($pageType != 'bookmarklet-add') && ($pageType != 'bookmarklet-edit')	&& ($pageType != 'admin-createitem')	&& ($pageType != 'admin-itemedit') ) {
			return;
		}
		if ($data['contentType'] == 'application/xhtml+xml') {
			$data['contentType'] = 'text/html';
		}
	}

	// I18N -> short form for getLanguageTranslation
	// Feel free to translate this in your language and send it to me. mailto:alfmiti@gmx.at
	function I18N($key) {
		$lng['opt_editormode']['english'] = 'No WYSIWIG Editor|no|KTML Editor|yes';
		$lng['enable_br']['english']     = 'Enable automatic linebreak conversion in standard textmode';
		$lng['description']['english']   = 'HTML-WYSIWIG editor interface. Upon install, this plugin '.
																			 'disables the default javascript toolbar and linebreak conversion ';
		return $lng[$key][$this->language];
	}

}
?>