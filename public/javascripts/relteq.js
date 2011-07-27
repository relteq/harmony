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

function vehicle_create() {
  event.preventDefault();
  var url = '/projects/' + project_id + 
            '/configuration/scenarios/' + scenario_id + 
            '/vehicle_types.json';
  new Ajax.Request(url, {
    method: 'post',
    parameters: { 'vehicle_type[name]' : $('vehicle_type_name').getValue(),
                  'vehicle_type[weight]': $('vehicle_type_weight').getValue() },
    onSuccess: function(transport) {
      var result = transport.responseText.evalJSON();
      if(result.success) {
        var e = new Element('option', { 'value': result.id }).update(result.display);
        $('scenario_vehicle_types').appendChild(e); 
      }
      else {
        alert('Error in Create Vehicle Type: ' + result.errors);
      }
    }
  }); 
}

function hide_box(div) {
  $(div).hide();
  ol.hide();
}

function onItemDeleteComplete(request){
  var flash_notice = request.getHeader('x-flash-notice');
  var flash_error = request.getHeader('x-flash-error');

	if (flash_notice) {
		jQuery('#content').prepend("<div id='profile-notice' class='flash notice'>" + flash_notice + "</div>");
		jQuery('#profile-notice').delay(2000).slideUp(500,function() { jQuery(this).remove(); });	
	}

	if (flash_error){
		jQuery('#content').prepend("<div  id='profile-error' class='flash error'>" + flash_error + "</div>");
		jQuery('#profile-error').delay(2000).slideUp(500,function() { jQuery(this).remove(); });	
	} 
}


