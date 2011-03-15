module ConfigurationsHelper
  def js_callback_redirect(url_options)
    %Q{function() {
          window.location = "#{url_for(url_options)}";
      }}
  end

  def js_callback_new_window(url_options)
    %Q{function() {
          window.open("#{url_for(url_options)}");  
       }}
  end

  def js_popup_show(div_id)
    %Q{function() {
         $('#{div_id}').show();
         ol.show($('#{div_id}'), {click_hide: false,
                          position: 'center', 
                          auto_hide: false, 
                          modal: true,
                          bckg_opacity: 0.9});
      }}
  end

  def not_implemented_callback
    %Q{function() { 
         alert("This function has not yet been implemented"); 
      }}
  end

  def highlight_if(bool)
    'highlight' if bool
  end

  # Need a method to return nil if there is no highlighted item,
  # so that comparisons won't crash config_sidebar rendering
  def highlighted_item
  end

  # Most common form of callback, because 2 lines/item makes it take
  # forever to scroll through a menu's definition. Note the comma at the end.
  def simple_callback_template(sym, callback)
    %Q{{ name: '#{l(sym)}',
         callback: #{callback} },}
  end
  alias :sct :simple_callback_template

  def scenario_specific_menu_items(project, scenario)
    run_simulation_callback = js_callback_redirect(
       :controller => 'scenario/simulations',
       :action => 'new',
       :project_id => project.id,
       :scenario_id => scenario.id,
       :simple => true
    )

    run_batch_callback = js_callback_redirect(
       :controller => 'scenario/simulations',
       :action => 'new',
       :project_id => project.id,
       :scenario_id => scenario.id
    )

    run_batch_callback = js_popup_show "scenario-launch-#{scenario.id}"

    delete_callback = js_callback_redirect(
       :controller => 'scenarios',
       :action => 'destroy',
       :project_id => project.id,
       :scenario_id => scenario.id
    )

    duplicate_callback = not_implemented_callback 
    shallow_dup_callback = not_implemented_callback 
    share_callback = not_implemented_callback 
    export_callback = not_implemented_callback 

    %Q{'#config-sidebar-scenario-#{scenario.id}': 
          [#{sct(:scenario_run_simulation, run_simulation_callback)}
           #{sct(:scenario_run_simulation_batch, run_batch_callback)}
           #{sct(:relteq_duplicate, duplicate_callback)}
           #{sct(:relteq_shallow_duplicate, shallow_dup_callback)}
           #{sct(:relteq_share, share_callback)}
           #{sct(:relteq_export, export_callback)}
           { name: '#{l(:relteq_delete)}',
             callback: #{delete_callback},
             className: 'delete'}]
    }
  end

  def network_specific_menu_items(project, network)
    edit_callback = js_callback_new_window :controller => 'networks', 
                                         :action => 'flash_edit',
                                         :project_id => project.id,
                                         :network_id => network.id

    delete_callback = js_callback_redirect :controller => 'networks',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :network_id => network.id 

    duplicate_callback = not_implemented_callback
    share_callback = not_implemented_callback
    export_callback = not_implemented_callback

    %Q{'#config-sidebar-network-#{network.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         #{sct(:relteq_share, share_callback)}
         #{sct(:relteq_export, export_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def controller_set_specific_menu_items(project, cs)
    edit_callback = js_callback_redirect :controller => 'controller_sets', 
                                         :action => 'edit',
                                         :project_id => project.id,
                                         :controller_set_id => cs.id

    delete_callback = js_callback_redirect :controller => 'controller_sets',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :controller_set_id => cs.id 

    duplicate_callback = not_implemented_callback

    %Q{'#config-sidebar-controller-set-#{cs.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def demand_profile_set_specific_menu_items(project, ds)
    edit_callback = js_callback_redirect :controller => 'demand_profile_sets', 
                                         :action => 'edit',
                                         :project_id => project.id,
                                         :demand_profile_set_id => ds.id

    delete_callback = js_callback_redirect :controller => 'demand_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :demand_profile_set_id => ds.id 

    duplicate_callback = not_implemented_callback

    %Q{'#config-sidebar-demand-profile-set-#{ds.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def split_ratio_profile_set_specific_menu_items(project, srp)
    edit_callback = js_callback_redirect :controller => 'split_ratio_profile_sets', 
                                         :action => 'edit',
                                         :project_id => project.id,
                                         :split_ratio_profile_set_id => srp.id

    delete_callback = js_callback_redirect :controller => 'split_ratio_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :split_ratio_profile_set_id => srp.id 

    duplicate_callback = not_implemented_callback

    %Q{'#config-sidebar-split-ratio-profile-set-#{srp.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def capacity_profile_set_specific_menu_items(project, cs)
    edit_callback = js_callback_redirect :controller => 'capacity_profile_sets', 
                                         :action => 'edit',
                                         :project_id => project.id,
                                         :capacity_profile_set_id => cs.id

    delete_callback = js_callback_redirect :controller => 'capacity_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :capacity_profile_set_id => cs.id 

    duplicate_callback = not_implemented_callback

    %Q{'#config-sidebar-capacity-profile-set-#{cs.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end
  
  def event_set_specific_menu_items(project, es)
    edit_callback = js_callback_redirect :controller => 'event_sets', 
                                         :action => 'edit',
                                         :project_id => project.id,
                                         :event_set_id => es.id

    delete_callback = js_callback_redirect :controller => 'event_sets',
                                           :action => 'destroy',
                                           :project_id => project.id,
                                           :event_set_id => es.id 

    duplicate_callback = not_implemented_callback

    %Q{'#config-sidebar-event-set-#{es.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def all_leaf_menu_items(project, items = {})
    networks = items[:networks].map do |n|
      network_specific_menu_items(project, n)
    end
    scenarios = items[:scenarios].map do |s|
      scenario_specific_menu_items(project, s)
    end
    controller_sets = items[:controller_sets].map do |c|
      controller_set_specific_menu_items(project, c)
    end
    demand_profile_sets = items[:demand_profile_sets].map do |d|
      demand_profile_set_specific_menu_items(project, d)
    end
    split_ratio_profile_sets = items[:split_ratio_profile_sets].map do |s|
      split_ratio_profile_set_specific_menu_items(project, s)
    end
    capacity_profile_sets = items[:capacity_profile_sets].map do |c|
      capacity_profile_set_specific_menu_items(project, c)
    end
    event_sets = items[:event_sets].map do |e|
      event_set_specific_menu_items(project, e)
    end


    elements = (networks + scenarios + 
                controller_sets + demand_profile_sets +
                split_ratio_profile_sets + capacity_profile_sets +
                event_sets).join(",")

    # $H() casts to hash to use prototype hash enumeration
    "$H({#{elements}})"
  end
end
