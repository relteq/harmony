require 'redmine'

Redmine::Plugin.register :redmine_relteq_hooks do
  name 'Redmine Relteq Hooks plugin'
  author 'Relteq Systems'
  description 'Integrate Relteq UI into Redmine project system'
  version '0.0.1'
  url 'http://relteqsystems.com/'

  permission :view_simulation_models, :scenarios => [:index, :show]
  permission :edit_simulation_models, :scenarios => [:edit, :update, :destroy, :delete_all]
  permission :create_simulation_models, :scenarios => [:new, :create]
  menu :project_menu, :scenarios, {:controller => 'scenarios', :action => 'index'}, :caption => 'Models', :param => :project_id, :after => :overview

  permission :view_simulation_data, :simulation_data => [:index, :show]
  permission :delete_simulation_data, :simulation_data => [:destroy]
  menu :project_menu, :simulation_data, {:controller => 'simulation_data', :action => 'index'}, :caption => 'Simulation Data', :param => :project_id, :after => :scenarios

  permission :create_reports, :reports => [:new, :create]
  permission :view_reports, :reports => [:index, :show]
  permission :edit_reports, :reports => [:edit, :update, :destroy]
  menu :project_menu, :reports, {:controller => 'reports', :action => 'index'}, :caption => 'Reports', :param => :project_id, :after => :simulation_data

  permission :create_measurement_data, :measurement_data => [:new, :create]
  permission :view_measurement_data, :measurement_data => [:show, :index]
  permission :edit_measurement_data, :measurement_data => [:edit, :update, :destroy, :delete_all]
  menu :project_menu, :measurement_data, {:controller => 'measurement_data', :action => 'index'}, :caption => 'Measurement Data', :param => :project_id, :after => :reports
end
