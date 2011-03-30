module SimulationBatchHelper
  def js_callback_redirect(url_options)
     %Q{function() {
           window.location = "#{url_for(url_options)}";
       }}
   end
   
   def not_implemented_callback
     %Q{function() { 
          alert("This function has not yet been implemented"); 
       }}
   end
   
   # Most common form of callback, because 2 lines/item makes it take
   # forever to scroll through a menu's definition. Note the comma at the end.
   def simple_callback_template(sym, callback)
     %Q{{ name: '#{l(sym)}',
          callback: #{callback} },}
   end
   alias :sct :simple_callback_template
   
  def simulation_batch_menu_items(project)
  
    delete_callback = js_callback_redirect :controller => 'simulation_batch',
                                           :action => 'delete_selected',
                                           :project_id => project.id
  
    generate_report_callback = not_implemented_callback
    share_callback = not_implemented_callback
    export_callback = not_implemented_callback
    rename_callback = not_implemented_callback

    %Q{
        #{sct(:relteq_report, generate_report_callback)}
         #{sct(:relteq_share, share_callback)}
         #{sct(:relteq_export, export_callback)}
         #{sct(:relteq_rename, rename_callback)}
         { name: "#{l(:relteq_delete)}", 
           callback: #{delete_callback},
           className: 'delete' }
    }


  end
end
