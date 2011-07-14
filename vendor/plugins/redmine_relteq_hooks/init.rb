require 'redmine'

Redmine::Plugin.register :redmine_relteq_hooks do
  name 'Redmine Relteq Hooks plugin'
  author 'Relteq Systems'
  description 'Integrate Relteq UI into Redmine project system'
  version '0.0.1'
  url 'http://relteqsystems.com/'

  permission :view_simulation_models, :configurations => [:index, :show]
  permission :edit_simulation_models, :configurations => [:edit, :update, :destroy, :delete_all, :flash_edit, :import, :delete_event]
  permission :create_simulation_models, :configurations => [:new, :create]
  menu :project_menu, :configurations,{:controller => 'configurations', :action => 'show'}, :caption => 'Models', :param => :project_id, :after => :overview

  permission :view_simulation_batch, :simulation_batch => [:index, :show]
  permission :delete_simulation_batch, :simulation_batch => [:destroy]
  menu :project_menu, :simulation_batch, {:controller => 'simulation_batch', :action => 'index'}, :caption => 'Simulation Data', :param => :project_id, :after => :configurations

  permission :create_reports, :simulation_batch_report => [:new, :create]
  permission :view_reports, :simulation_batch_report => [:index, :show]
  permission :edit_reports, :simulation_batch_report => [:edit, :update, :destroy]
  menu :project_menu, :simulation_batch_report, {:controller => 'simulation_batch_report', :action => 'index'}, :caption => 'Reports', :param => :project_id, :after => :simulation_batch

  permission :create_measurement_data, :measurement_data => [:new, :create]
  permission :view_measurement_data, :measurement_data => [:show, :index]
  permission :edit_measurement_data, :measurement_data => [:edit, :update, :destroy, :delete_all]
  menu :project_menu, :measurement_data, {:controller => 'measurement_data', :action => 'index'}, :caption => 'Measurement Data', :param => :project_id, :after => :simulation_batch_report
end
