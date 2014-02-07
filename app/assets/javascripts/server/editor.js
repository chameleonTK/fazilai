window.onload = function() {
  var te = document.getElementById("code");
  te.value = document.documentElement.innerHTML;
  window.editor = CodeMirror.fromTextArea(te, {
    mode: "application/x-httpd-php",
    lineNumbers: true,
    lineWrapping: true,
    extraKeys: {"Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
    foldGutter: true,
    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
  });

	console.log(editor);
  //editor.foldCode(CodeMirror.Pos(11, 0));
  //var buffers = [editor,editor_html];
	/*setInterval(function(){
		var buf = editor.doc;
		console.log(buf)
		if (buf.getEditor()) buf = buf.linkedDoc({sharedHist: true});
  		var old = editor_html.swapDoc(buf);
  		editor.swapDoc(old);
		console.log("swap");
	},2000);*/

};
