var configSidebarContextMenus = {
  scenariosNode : [
    { name: "<%= l(:scenarios_new) %>", 
      callback: <%= js_callback_redirect :controller => 'scenarios', :action => 'new', :project_id => @project.id %> },
    { name: "<%= l(:scenarios_import) %>",
      callback: <%= js_callback_redirect :controller => 'scenarios', :action => 'import', :project_id => @project.id %> },
    { name: "<%= l(:scenarios_delete_all) %>", className: 'delete', 
      callback: <%= js_callback_redirect :controller => 'scenarios', :action => 'delete_all', :project_id => @project.id %> }
  ],
  networksNode : [ 
    { name: "<%= l(:networks_new) %>",
      callback: <%= js_callback_redirect :controller => 'networks', :action => 'new'%>},
    { name: "<%= l(:networks_import) %>" },
    { name: "<%= l(:networks_delete_all) %>", className: 'delete' }
  ],
  controllerSetsNode : [
    { name: "<%= l(:controller_sets_new) %>",
      callback: <%= js_callback_redirect :controller => 'controller_sets', :action => 'new' %> },
    { name: "<%= l(:controller_sets_delete_all) %>", className: 'delete' }
  ],
  demandProfileSetsNode: [
    { name: "<%= l(:demand_profiles_new) %>",
      callback: <%= js_callback_redirect :controller => 'demand_profile_sets', :action => 'new' %> },
    { name: "<%= l(:demand_profiles_delete_all) %>", className: 'delete' }
  ],
  capacityProfileSetsNode: [
    { name: "<%= l(:capacity_profiles_new) %>",
      callback: <%= js_callback_redirect :controller => 'capacity_profile_sets', :action => 'new' %> },
    { name: "<%= l(:capacity_profiles_delete_all) %>", className: 'delete' }
  ],
  splitRatioProfileSetsNode: [
    { name: "<%= l(:split_ratio_profiles_new) %>",
      callback: <%= js_callback_redirect :controller => 'split_ratio_profile_sets', :action => 'new' %> },
    { name: "<%= l(:split_ratio_profiles_delete_all) %>", className: 'delete' }
  ],
  eventSetsNode: [
    { name: "<%= l(:event_sets_new) %>",
      callback: <%= js_callback_redirect :controller => 'event_sets', :action => 'new' %> },
    { name: "<%= l(:event_sets_delete_all) %>", className: 'delete' }
  ],

  hook: function(sel, ind) {
    new Proto.Menu({ selector: sel, 
      menuItems: this[ind], 
      className: 'menu google',
      fade: true,
      addIcon: true
    });
  },

  hookLeaf: function(sel, items) {
    new Proto.Menu({ selector: sel, 
      menuItems: items, 
      className: 'menu google',
      fade: true,
      addIcon: true
    });
  },
};

configSidebarContextMenus.hook(
  '#config-sidebar-scenarios', 
  'scenariosNode'
);

configSidebarContextMenus.hook(
  '#config-sidebar-networks', 
  'networksNode'
);

configSidebarContextMenus.hook(
  '#config-sidebar-controller-sets', 
  'controllerSetsNode'
);

configSidebarContextMenus.hook(
  '#config-sidebar-demand-profile-sets', 
  'demandProfileSetsNode'
);

configSidebarContextMenus.hook(
  '#config-sidebar-capacity-profile-sets',
  'capacityProfileSetsNode'
);

configSidebarContextMenus.hook(
  '#config-sidebar-split-ratio-profile-sets',
  'splitRatioProfileSetsNode'
);
configSidebarContextMenus.hook(
  '#config-sidebar-event-sets',
  'eventSetsNode'
);

hook_leaf_menus(leaf_menus);

$$('.scenario-overlay-cancel').each(function(el) {
  el.observe('click', function(event) {
    var element = event.element();
    var id = element.id;
    var scenario_id = '';
    id.scan(/\d+/, function(match) { scenario_id = match; });
    $('scenario-launch-' + scenario_id).hide();
    ol.hide();
  });
});

function hook_leaf_menus(menus){
	menus.each(function(pair) {
		    configSidebarContextMenus.hookLeaf(pair.key, pair.value);
	});
}
