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
			s=""
			do{
				if(folder.is('ol')){
					var label = folder.prev().prev()
				}else{
					var label = folder
				}
				s = "/"+label.attr('filename') + s;
				folder = folder.parent().parent();
				//console.log("parent");
				//console.log(folder);
				//console.log(s);
				
			}while( !folder.hasClass('tree'));
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
			file.attr('checked', false);
			alert("sorry i forget");
		}else{
			file.addClass('checked');
			file.attr('checked', true);
			var subfolder = file.next().next();
			s=""
			do{
				if(file.is('ol')){
					var label = file.prev().prev()
				}else{
					var label = file
				}
				s = "/"+label.attr('filename') + s;
				file = file.parent().parent();
				
			}while( !file.hasClass('tree'));
			$.post("/getfile"+s,function(data){
				console.log(data);
				//alert("a");
				swapEditor(label_for,data["code"],data["type"]);

			});
		}
	});
}

