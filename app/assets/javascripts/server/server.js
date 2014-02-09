function gentree(data){
	var s = "";
	$.each(data, function( index, value ) {
		if (value["permission"][0]=='d' || value["permission"][0]=='l' ){
					s += '<li > '
					s += 		'<label class="folder" filename="'+value["filename"]+'" for="'+value["filename"]+'">'+value["filename"]+'</label> '
					s += 		'<input type="checkbox" id="'+value["filename"]+'" /> '
					s += 		'<ol></ol>' 		
					s += '</li>' 		
				}else{
					s += '<li>'
					s += '<label class="file" filename="'+value["filename"]+' style="color:#535353">'+value["filename"]+'</label>'
					s += '</li>'

				}
			});
			return s
		}
function init_tree(path_init){
	$.get(path_init,function(data){
		$('.tree').html(gentree(data));
	});
	$(".tree").on('click', 'label.folder' ,function(){
		var folder = $(this);
		console.log(folder);
		console.log(folder.hasClass('checked'));
			if (folder.hasClass('checked')){
					folder.attr('checked', false);
				}else{
					folder.addClass('checked');
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
						console.log("parent");
						console.log(folder);
						console.log(s);
						
					}while( !folder.hasClass('tree'));
					$.get("/listfile/"+s,function(data){
						console.log(subfolder);
						subfolder.html(gentree(data));
					});

				}
			});		
}

