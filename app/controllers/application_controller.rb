# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :populate_menu
  
  def populate_menu
    @project = Project.find(params[:project_id])
    @scenarios = @project.scenarios.all
    @networks = Network.find(:all)
    @cgroups = ControllerGroup.find(:all)
    @dprofiles = DemandProfile.find(:all)
    @cprofiles = CapacityProfile.find(:all)
    @events = Event.find(:all)
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
