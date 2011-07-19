module ConfigurationsHelper
  def js_callback_redirect(url_options)
    %Q{function() {
          window.location = "#{url_for(url_options)}";
      }}
  end

  def js_callback_delete(url_options)
    url_options.merge!({:format => :xml}) # to avoid bad redirects
    %Q{function() {
          $('ajax-indicator').show();
          $j.post("#{url_for(url_options)}",
                  { '_method': 'delete' },
                  function() {
                    $('ajax-indicator').hide();
                    location.reload();
                  });
    }}
  end

  def js_callback_duplicate(url, redirect_base, url_params = {})
    %Q{function() {
          var redirect_url = '#{redirect_base}';
          $('ajax-indicator').show();
          $j.getJSON("#{url}&jsoncallback=?",
                     #{url_params.to_json},
                     function(data) {
                        if(data.success) {
                          var edit_url = redirect_url.replace('**ID**',data.success);
                          window.location = edit_url;
                        }
                        $('ajax-indicator').hide();
                     });
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

  def scenario_specific_menu_items(project, scenario, where)
    run_simulation_callback = js_callback_redirect(
       :controller => 'scenario/simulations',
       :action => 'create',
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

    edit_callback = js_callback_new_window(
      :controller => 'scenarios',
      :action => 'flash_edit',
      :project_id => project.id,
      :id => scenario.id
    )

    export_callback = js_callback_redirect(
      :controller => 'scenarios',
      :action => 'show',
      :format => 'xml',
      :project_id => project.id,
      :id => scenario.id
    )

    delete_callback = js_callback_delete(
       :controller => 'scenarios',
       :action => 'destroy',
       :project_id => project.id,
       :id => scenario.id
    )

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(scenario),
      edit_project_configuration_scenario_path(project, '**ID**'),
      :deep => true
    )

    shallow_dup_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(scenario),
      edit_project_configuration_scenario_path(project, '**ID**')
    )

    copy_to_callback = js_callback_redirect(
      :controller => 'scenarios',
      :action => 'copy_form',
      :project_id => project,
      :id => scenario.id
    )

    %Q{'#config-#{where}-scenario-#{scenario.id}': 
          [#{sct(:relteq_edit, edit_callback)}
           #{sct(:scenario_run_simulation, run_simulation_callback)}
           #{sct(:scenario_run_simulation_batch, run_batch_callback)}
           #{sct(:relteq_copy_to, copy_to_callback)}
           #{sct(:relteq_duplicate, duplicate_callback)}
           #{sct(:relteq_shallow_duplicate, shallow_dup_callback)}
           #{sct(:relteq_export, export_callback)}
           { name: '#{l(:relteq_delete)}',
             callback: #{delete_callback},
             className: 'delete'}]
    }
    
  end

  def network_specific_menu_items(project, network,where)
    edit_callback = js_callback_new_window :controller => 'networks', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => network.id

    delete_callback = js_callback_delete   :controller => 'networks',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => network.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(network),
      edit_project_configuration_network_path(project, '**ID**')
    )

    copy_to_callback = js_callback_redirect(
      :controller => 'networks',
      :action => 'copy_form',
      :project_id => project,
      :id => network.id
    )

    export_callback = js_callback_redirect(
      :controller => 'networks',
      :action => 'show',
      :format => 'xml',
      :project_id => project.id,
      :id => network.id
    )
  
    %Q{'#config-#{where}-network-#{network.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         #{sct(:relteq_copy_to, copy_to_callback)}
         #{sct(:relteq_export, export_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }

    
  end

  def controller_set_specific_menu_items(project, cs,where)
    edit_callback = js_callback_new_window :controller => 'controller_sets', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => cs.id

    delete_callback = js_callback_delete   :controller => 'controller_sets',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => cs.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(cs),
      edit_project_configuration_controller_set_path(project, '**ID**')
    )

    %Q{'#config-#{where}-controller-set-#{cs.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def demand_profile_set_specific_menu_items(project, ds, where)
    edit_callback = js_callback_new_window :controller => 'demand_profile_sets', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => ds.id

    delete_callback = js_callback_delete   :controller => 'demand_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => ds.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(ds),
      edit_project_configuration_demand_profile_set_path(project, '**ID**')
    )

    %Q{'#config-#{where}-demand-profile-set-#{ds.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def split_ratio_profile_set_specific_menu_items(project, srp, where)
    edit_callback = js_callback_new_window :controller => 'split_ratio_profile_sets', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => srp.id

    delete_callback = js_callback_delete   :controller => 'split_ratio_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => srp.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(srp),
      edit_project_configuration_split_ratio_profile_set_path(project, '**ID**')
    )

    %Q{'#config-#{where}-split-ratio-profile-set-#{srp.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  def capacity_profile_set_specific_menu_items(project, cs, where)
    edit_callback = js_callback_new_window :controller => 'capacity_profile_sets', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => cs.id

    delete_callback = js_callback_delete   :controller => 'capacity_profile_sets',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => cs.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(cs),
      edit_project_configuration_capacity_profile_set_path(project, '**ID**')
    )

    %Q{'#config-#{where}-capacity-profile-set-#{cs.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end
  
  def event_set_specific_menu_items(project, es, where)
    edit_callback = js_callback_new_window :controller => 'event_sets', 
                                         :action => 'flash_edit',
                                         :project_id => project,
                                         :id => es.id

    delete_callback = js_callback_delete   :controller => 'event_sets',
                                           :action => 'destroy',
                                           :project_id => project,
                                           :id => es.id 

    duplicate_callback = js_callback_duplicate(
      Dbweb.object_duplicate_url(es),
      edit_project_configuration_event_set_path(project, '**ID**')
    )

    %Q{'#config-#{where}-event-set-#{es.id}':
        [#{sct(:relteq_edit, edit_callback)}
         #{sct(:relteq_duplicate, duplicate_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }]
    }
  end

  
  def all_leaf_menu_items(project,where,items = {})
    networks = items[:networks] == nil ? [] : items[:networks].map do |n|
      network_specific_menu_items(project, n,where)
    end
    scenarios =  items[:scenarios] == nil ? [] : items[:scenarios].map do |s|
      scenario_specific_menu_items(project, s,where)
    end
    controller_sets = items[:controller_sets] == nil ? [] : items[:controller_sets].map do |c|
      controller_set_specific_menu_items(project, c,where)
    end
    demand_profile_sets = items[:demand_profile_sets] == nil ? [] : items[:demand_profile_sets].map do |d|
      demand_profile_set_specific_menu_items(project, d,where)
    end
    split_ratio_profile_sets = items[:split_ratio_profile_sets] == nil ? [] : items[:split_ratio_profile_sets].map do |s|
      split_ratio_profile_set_specific_menu_items(project, s,where)
    end
    capacity_profile_sets = items[:capacity_profile_sets] == nil ? [] : items[:capacity_profile_sets].map do |c|
      capacity_profile_set_specific_menu_items(project, c,where)
    end
    event_sets = items[:event_sets] == nil ? [] : items[:event_sets].map do |e|
      event_set_specific_menu_items(project, e,where)
    end


    elements = (networks + scenarios + 
                controller_sets + demand_profile_sets +
                split_ratio_profile_sets + capacity_profile_sets +
                event_sets).join(",")
    
    # $H() casts to hash to use prototype hash enumeration
    "$H({#{elements}})"
    
  end
   
  def sort_header_tag_relteq(column,options = {})
   caption = options.delete(:caption) || column.to_s.humanize
   default_order = options.delete(:default_order) || 'asc'
   options[:title] = l(:label_sort_by, "\"#{caption}\"") unless options[:title]
   content_tag('th', sort_link_relteq(column,caption, default_order,options[:url]), options)
  end

  def sort_link_relteq(column,caption, default_order,url)
   css, order = nil, default_order

   if column.to_s == @sort_criteria.first_key
     if @sort_criteria.first_asc?
       css = 'sort asc'
       order = 'desc'
     else
       css = 'sort desc'
       order = 'asc'
     end
   end

   caption = column.to_s.humanize unless caption

   sort_options = { :sort => @sort_criteria.add(column.to_s, order).to_param }
   # don't reuse params if filters are present
   url_options = params.has_key?(:set_filter) ? sort_options : params.merge(sort_options)


    link_to_remote(caption,
                  { :url => url.merge(url_options), :method => :get},
                  { :href => url_for(url_options),
                   :class => css})               
  end

  def display_menu_item(s)
    s.length < 16 ? s : s[0,15] + "..." if s
  end
  

  
end
