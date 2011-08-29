require 'redmine'

Redmine::Plugin.register :redmine_relteq_hooks do
  name 'Redmine Relteq Hooks plugin'
  author 'Relteq Systems'
  description 'Integrate Relteq UI into Redmine project system'
  version '0.0.1'
  url 'http://relteqsystems.com/'
  
  project_module :models do
    permission :view_simulation_models, :configurations => [:index, :show, :copy_to, :copy_form]
    permission :edit_simulation_models, :configurations => [:edit, :update, :destroy, :delete_all, :flash_edit, :import,:populate_table,:delete_item]
    permission :create_simulation_models, :configurations => [:new, :create]
    menu :project_menu, :configurations,{:controller => 'configurations', :action => 'show'}, :caption => 'Models', :param => :project_id, :after => :overview
  end

  project_module :simulation_data do
    permission :view_simulation_batch, :simulation_batches => [:index, :show]
    permission :edit_simulation_batch, :simulation_batches => [:update]
    permission :delete_simulation_batch, :simulation_batches => [:destroy]
    menu :project_menu, :simulation_batches, {:controller => 'simulation_batches', :action => 'index'}, :caption => 'Simulation Data', :param => :project_id, :after => :configurations
  end

  project_module :reports do
    permission :create_reports, :simulation_batch_reports => [:new, :create]
    permission :view_reports, :simulation_batch_reports => [:index, :show]
    permission :edit_reports, :simulation_batch_reports => [:edit, :update, :destroy]
    menu :project_menu, :simulation_batch_reports, {:controller => 'simulation_batch_reports', :action => 'index'}, :caption => 'Reports', :param => :project_id, :after => :simulation_batches
  end
  
  project_module :measurement_data do
    permission :create_measurement_data, :measurement_data => [:new, :create]
    permission :view_measurement_data, :measurement_data => [:show, :index]
    permission :edit_measurement_data, :measurement_data => [:update, :destroy]
    menu :project_menu, :measurement_data, {:controller => 'measurement_data', :action => 'index'}, :caption => 'Measurement Data', :param => :project_id, :after => :simulation_batch_reports
  end
end
