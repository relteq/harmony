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

function vehicle_delete() {
  event.preventDefault();
  var current_vehicle_option = $$('#scenario_vehicle_types option').detect(
    function(option) { return option.selected; }
  );
  var url = '/projects/' + project_id + 
            '/configuration/scenarios/' + scenario_id + 
            '/vehicle_types/' + current_vehicle_option.value +
            '.json';
  new Ajax.Request(url, {
    method: 'delete',
    onSuccess: function(transport) {
      var result = transport.responseText.evalJSON();
      if(result.success) {
        current_vehicle_option.remove();
      }
      else {
        alert('Error in Delete Vehicle Type: ' + result.error_message);
      }
    }
  }); 
}

function hide_box(div) {
  $(div).hide();
  ol.hide();
}
