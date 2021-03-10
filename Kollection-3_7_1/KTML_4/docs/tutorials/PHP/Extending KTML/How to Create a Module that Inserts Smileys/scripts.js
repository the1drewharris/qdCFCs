// Copyright 2001-2005 Interakt Online. All rights reserved.

//we define smiles & description
var Smileys = [
 				'smiling',
 				'sad',
 				'winking',
				'big grin',
				'confused',
				'love struck',
				'blushing',
				'tongue',
				'kiss',
				'broken heart'
			  ];

//we set the main HTML outline of the picker:
var SmileysPaletteDivHead =
'<table border="0" style="border: solid 1px #000000" class="ktml_bg"'+
'	id="ktml_@@ktml@@_mousecapture"'+
'	onmouseover="window[\'ktml_@@ktml@@\'].smileyspalette.mOver(event)"'+
'	onmouseout="window[\'ktml_@@ktml@@\'].smileyspalette.mOut(event)"'+
'	onclick="window[\'ktml_@@ktml@@\'].smileyspalette.mClick(event)"'+
'>'+
'  <tr class="ktml_bg">'+
'    <td valign="top"><fieldset class="ktml_fieldset" style="height: ;">'+
'<legend class="ktml_legend">||Smileys Picker||</legend>'+
'<center>'+
'			<table style="margin-top: 5px" cellspacing="4" cellpadding="1px" border="0">';
var SmileysPaletteDivFooter =
'			</table>'+
'</center>'+
'</fieldset>'+
'</td>'+
' </tr>'+
'</table>';

function SmileyPalette(obj, cols) {
	var d;
	this.owner = obj;
	this.cols =  cols;
	this.smilyesContainer = document.createElement("DIV");
	if(is.mozilla && is.mac){
		this.smilyesContainer.style.overflow = "auto";
		this.smilyesContainer.style.width = "200px";
		this.smilyesContainer.style.height = "85px";
	}
	this.smilyesContainer = this.owner.toolbar.base.appendChild(this.smilyesContainer);
	this.smilyesContainer.style.position = 'absolute';
	this.smilyesContainer.style.zIndex = 1000;
	this.original = "";
	this.preview = 'ktml_' + this.owner.name + '_smiley_preview';
	this.isVisible = false;
	this.isDrawn = false;
};

SmileyPalette.prototype.writeColBtn = function(smileIndex) {
	var imagesSrc = KtmlRoot + 'modules/smileys/img/';
	var imgFileName = utility.math.zeroPad(smileIndex, Smileys.length.toString().length) + '.gif';
	var toolTipText = Smileys[smileIndex];
	var HTMLstring = '<td style="border:0px solid #08246B; width:12px;height:14px;cursor:default"><img style="margin:3px" smiley="'+toolTipText+'" src="'+imagesSrc+imgFileName+'" title="'+toolTipText+'" alt="'+toolTipText+'" border="0" width="16" height="16"></td>';
	return HTMLstring;
};

SmileyPalette.prototype.initializeUI = function() {
	this.drawPicker();
	var oname = this.owner.name;
	this.isDrawn = true;
};

SmileyPalette.prototype.drawTable = function() {
	var text = '';
	var reminder = Smileys.length % this.cols;
	var rows = parseInt(Smileys.length / this.cols, 10);
	for (var i = 0; i<= rows; i++) {
		text+="<tr>\n";
		for ( var j=i*this.cols; j < Math.min((i+1)*this.cols, Smileys.length); j++ ) {
			text += this.writeColBtn(j);
		}
		if (i==rows && ( (i+1)*this.cols > Smileys.length) ) {
			text += '<td colspan="'+((i+1)*this.cols - Smileys.length) +'"></td>'
		}
		text+="</tr>\n";
	}
	return text;
};

SmileyPalette.prototype.drawPicker = function() {
	var text = '';
	var header = lang_translatepage(SmileysPaletteDivHead, this.owner.config.UILanguage, window);
	header = header.replace(/@@ktml@@/g, this.owner.name);
	var footer = SmileysPaletteDivFooter.replace(/@@ktml@@/g, this.owner.name);
	footer = lang_translatepage(footer, this.owner.config.UILanguage, window);
	text+=header;
	text+=this.drawTable();
	text+=footer;
	this.smilyesContainer.innerHTML = text;
};


SmileyPalette.prototype.mOver = function(e) {
	var o = is.ie ? e.srcElement : e.target;
	var current = o.getAttribute("smiley");
	if(o.tagName.toLowerCase()=="img" && current){
		o.parentNode.style.borderWidth = "1px";
		o.parentNode.style.backgroundColor = "#D1D0E6";
		o.style.margin = "2px";
		
	}
};

SmileyPalette.prototype.mOut = function(e){
	var o = is.ie ? e.srcElement : e.target;
	var current = o.getAttribute("smiley");
	if(o.tagName.toLowerCase() == "img" && current){
		o.parentNode.style.borderWidth = "0px";
		o.parentNode.style.backgroundColor = "transparent";
		o.style.margin = "3px";
	}
};

SmileyPalette.prototype.mClick = function(e) {
	utility.dom.stopEvent(is.ie ? event : e);
	var o = is.ie ? e.srcElement : e.target;
	var current = o.getAttribute("smiley");
	var htmlToInsert = '<img src="'+o.src+'" border="0" width="16" height="16" alt="'+current+'" />';
	if (!this.smilyesContainer.contains(o)) {
		this.owner.util_restoreSelection();
	}
	if(o.tagName.toLowerCase() == "img" && current){
		o.parentNode.style.borderColor = "buttonface";
		this.setVisible(false);
		this.pickColor(htmlToInsert);
	}
};

SmileyPalette.prototype.pickColor = function(selectedColor) {
	this.onSelect(selectedColor);
};


SmileyPalette.prototype.setVisible = function(par) {
	if (this.isVisible == par) {
		return;
	}
	if (par) {
		if (!this.original) {
			this.original = "";
		}
		this.smilyesContainer.style.display = 'block';
		var cp = this;
		this.smilyesContainer.style.zIndex = 20;
		utility.popup.makeModal(function() {
			cp.setVisible(false);
		}, this.smilyesContainer);
	} else {
		this.original = "";
		this.smilyesContainer.style.display= 'none';
	}
	this.isVisible = par;
};

SmileyPalette.prototype.showAt = function(x, y) {
	if (!this.isDrawn) {
		this.initializeUI();
	}
	var d;
	d = utility.dom.getPositionRelativeTo00(x,y,200,85);
	utility.dom.put(this.smilyesContainer, d.x, d.y);
};

SmileyPalette.prototype.showAtElement = function(el) {
	if (!this.isDrawn) {
		this.initializeUI();
	}
	this.smilyesContainer.style.top = '-20000px';
	this.smilyesContainer.style.display = 'block';
	this.smilyesContainer.style.width = this.smilyesContainer.scrollWidth + "px";
	this.smilyesContainer.style.height = this.smilyesContainer.scrollHeight + "px";
	utility.dom.putElementAt(this.smilyesContainer, el, '03');
	this.setVisible(true);
};

SmileyPalette.prototype.dispose = function() {
	this.smilyesContainer.innerHTML = '';
	this.smilyesContainer = null;
};



//insert smileys module, added 15.11.05
function insert_smiley_command(new_value) {
	var tlb = KTStorage.get(this.toolbar_button);
	tlb.ktml.insertHTML(new_value, is.mozilla?"after":"");
};

function insert_smiley_open() {
	var tlb = KTStorage.get(this.toolbar_button);
	var cb = KTStorage.get(this.id);
	if (typeof(tlb.ktml.smileyspalette) == "undefined") {
		tlb.ktml.smileyspalette = new SmileyPalette(tlb.ktml, 5);
	}
	tlb.ktml.smileyspalette.onSelect = function (new_value) {
		cb.setValue(new_value);
		tlb.params.command.call(cb, cb.value);
	};
	tlb.ktml.logic_openSmileysPalette(cb.getElement("table"));
};

function insert_smiley_paint() {
	var el = this.getElement("cell");
	var tlb = KTStorage.get(this.toolbar_button);
	//since there's no generated "ktml1_config['module_props']['smileys']"
	//declaration within the page, i used some little hacks to get the path to smileys folder:
	var imgSrc = KtmlRoot + 'modules/smileys/img/';
	el.innerHTML = this.value.match(/^\<img/)? this.value: '<img width="16" height="16" src="' + imgSrc + this.value + '" border="0" align="center" />';
};

function smileys_runonce() {
};

function smileys_runeach(k) {
	//smileys insert module, added 15.11.05
	var imgSrc = KtmlRoot + 'modules/smileys/img/';
	var btn = new ToolbarButton({
		'group': 'insert', 
		'command_type': $KT_JS_STRING, 
		'name': 'insert_smiley', 
		'help': 'insert_smiley', 
		'button_type': "combo", 
		'default_value': '<img width="16" height="16" src="' + imgSrc + '00.gif" border="0" align="center" />'
	}, {
		'command': insert_smiley_command, 
		'open': insert_smiley_open, 
		'paint': insert_smiley_paint
	});
	k.toolbar.insertButtonAfter(btn, '', 2);
};
