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
end
