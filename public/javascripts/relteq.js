function toggleIssuesSelection(el) {
	var boxes = el.getElementsBySelector('input[type=checkbox]');
	var all_checked = true;
	for (i = 0; i < boxes.length; i++) { if (boxes[i].checked == false) { all_checked = false; } }
	for (i = 0; i < boxes.length; i++) {
		if (all_checked) {
			boxes[i].checked = false;
			boxes[i].up('tr').removeClassName('context-menu-selection');
		} else if (boxes[i].checked == false) {
			boxes[i].checked = true;
			boxes[i].up('tr').addClassName('context-menu-selection');
		}
	}
}

function clearTextFieldDefault(id,value) {
  if(id.value == value){
		id.value = "";
		id.style.color = "black";
		id.style.fontStyle = "normal";
  }		
}

function show_box(div) {
     $(div).show();
     ol.show($(div), {click_hide: false,
                      position: 'center', 
                      auto_hide: false, 
                      modal: true,
                      bckg_opacity: 0.9});
  }

function hide_box(div) {
	    $(div).hide();
	    ol.hide();
	  }