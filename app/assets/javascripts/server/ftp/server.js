function gentree(data,is_root,label_for){
	var s = "";
	$.each(data, function( index, value ) {
		if(is_root || (value["filename"]!="." && value["filename"]!=".."))
			if (value["permission"][0]=='d' || value["permission"][0]=='l' ){
						s += '<li > '
						s += 		'<label class="folder" filename="'+value["filename"]+'" for="'+label_for+"_"+value["filename"]+'">'+value["filename"]+'</label> '
						s += 		'<input type="checkbox" id="'+label_for+"_"+value["filename"]+'" /> '
						s += 		'<ol></ol>' 		
						s += '</li>' 		
			}else{
						s += '<li>'
						s += '<label class="file" for="'+label_for+"_"+value["filename"]+'" filename="'+value["filename"]+'" style="color:#535353">'+value["filename"]+'</label>'
						s += '</li>'

			}
	});
	return s
}

function get_dir(file){
	var s="";
	do{
		if(file.is('ol')){
			var label = file.prev().prev()
		}else{
			var label = file
		}
		s = "/"+label.attr('filename') + s;
		file = file.parent().parent();		
	
	}while( !file.hasClass('tree'));
	return s;

}

function init_tree(path_init){
	$.get(path_init,function(data){
		$('.tree').html(gentree(data,true,""));
	});

	$(".tree").on('click', 'label.folder' ,function(){
		var folder = $(this);
		//console.log(folder);
		if (folder.hasClass('checked')){
			folder.attr('checked', false);
		}else{
			folder.addClass('checked');
			folder.attr('checked', true);
			var label_for = folder.attr('for');
			var subfolder = folder.next().next();
			var s = get_dir(folder);
			$.get("/listfile"+s,function(data){
				//console.log(subfolder);
				subfolder.html(gentree(data,false,label_for));
			});
		}
	});

	$(".tree").on("click","label.file",function(){
		var file = $(this);
		//console.log(file);
		var label_for = file.attr('for');

		if (file.hasClass('checked')){
			//alert("sorry i forget");
			swapEditor(label_for);
		}else{
			file.addClass('checked');
			var s = get_dir(file);
			$(".edited").removeClass("edited");
			file.parent().addClass("edited");
			setnotEdit();
			$.post("/getfile"+s,function(data){
				setEdit();
				console.log(data);
				//alert("a");
				swapEditor(label_for,data["code"],data["type"]);
			});
		}
	});
	$("#createfile").click(function(){

	});

	$("#createfolder").click(function(){


	});	
	$("#savecode").click(function(){
		var file = $($(".edited > label")[0]);
		if(file != undefined && file.is("label")){	
			console.log("run save");
			var s = get_dir(file);
			var doc = getEditorText();
			$.post("/putfile"+s,{"doc":doc },function(data){
				console.log("already save");
				if(data=="accept"){
					var alert_ = ''
					alert_ += '<div class="alert alert-success">';
					alert_ += '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>';
					alert_ += '<span>Already save this file</span>';
					alert_ += '</div>'
					$("#code").before(alert_);
				}else{
					var alert_ = ''
					alert_ += '<div class="alert alert-error">';
					alert_ += '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>';
					alert_ += '<span>Fail to save file</span>';
					alert_ += '</div>'
					$("#code").before(alert_);
				}
				$(".alert").show();
			
				console.log(data)
			});
		}else{
			alert("sorry it not file");
		}
	});
	
}



