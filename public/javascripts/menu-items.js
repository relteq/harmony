//  ******************* tree menu right click

   Element.addMethods({
      getNumStyle: function(element, style) {
        var value = $(element).getStyle(style);
        return value === null ? null : parseInt(value);
      }
    });
    document.observe('dom:loaded', function(){
    	//Scenarios=====================
  		var myMenuItems = [
        {
          name: 'New Scenario',
          callback: function(e) {
          		window.location = "scenarios/new"
          }
        },{
          name: 'Import Scenario',
          className: 'copy', 
          callback: function() {
            alert('Copy function called');
          }
        },{
          name: 'Share All Scenarios', 
          className: 'delete'
        },
		{
          name: 'Delete All',
		  className: 'red',
          callback: function() {
			if (confirm("Are you sure you want to delete all your scenarios?")) {
			  	window.location = "scenarios/dall"
			}
      	}
        }
      ]
     
      new Proto.Menu({
        selector: '#scmenu',
        className: 'menu google',
        menuItems: myMenuItems
      })

	  //Scenarios - sub ================================
      var myMenuItems = [
        {
          name: 'Run Simulation',
          callback: function(e) {
			       alert('Not implemented');
         
 			}
        },
		{
          name: 'Run Simulation Batch',
          callback: function() {
			       alert('Not implemented');

      	}
        },{
          name: 'Duplicate',
          callback: function() {
            alert('Not implemented');
          }
        },{
          name: 'Shallow Duplicate',
          callback: function() {
            alert('Not implemented');
          }
        },{
          name: 'Share',
          callback: function() {
            alert('Not implemented');
          }
        },{
          name: 'Export',
          callback: function() {
            alert('Not implemented');
          }
        },{
          name: 'Rename',
          callback: function() {
            alert('Not implemented');
          }
        },{
          name: 'Delete',
		  className: 'red',
          callback: function() {
			if (confirm("Are you sure you want to delete this scenario?")) {
             window.location = "scenarios/:id/delete"
			}	
          }
        }
      ]
     
      new Proto.Menu({
        selector: '#scmenu-sub',
        className: 'menu google',
        menuItems: myMenuItems
      })



    });

