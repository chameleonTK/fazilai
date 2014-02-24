var editor;
var buffer =[];
var edit=true;
function init_editor(te){
  	te.value = "<html>\n\t<head>\n\t\t<title> WELCOME to Fazilai </title>\n\t</head>\n\t<body>\n\t\t<!-- code hear -->\n\t</body>\n</html>\n";

  	//document.documentElement.innerHTML;
  	editor = CodeMirror.fromTextArea(te, {
    	mode: "application/x-httpd-php",
    	lineNumbers: true,
    	lineWrapping: true,
    	extraKeys: {"Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
    	foldGutter: true,
   	gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
	});
	//console.log(editor);

  //editor.foldCode(CodeMirror.Pos(11, 0));
  //var buffers = [editor,editor_html];
}
$(function(){
	var te = document.getElementById("code");
	init_editor(te);
});
function selectBuffer(name,code,mode){
	if(!buffer.hasOwnProperty(name))
		buffer[name] = CodeMirror.Doc(code,mode);
	return buffer[name];
}

function setnotEdit(){
	//alert(edit);
	edit=false;
}
function setEdit(){
	edit=true;
}
function  swapEditor(name,code,mode){
	if(!edit){
		console.log("unable");
		alert("please wait.");
		return false;
	}else{
		code = typeof code !== 'undefined' ? code : "";	
		mode = typeof mode !== 'undefined' ? mode : "";
		var buf = selectBuffer(name,code,mode);
		//console.log(buffer)
		if (buf.getEditor()) buf = buf.linkedDoc({sharedHist: true});
  		//var old = editor_html.swapDoc(buf);
	  	editor.swapDoc(buf);
		console.log("swap");
	}
}

function getEditorText(){
	return editor.getValue();
}


