class ConfigurationsController < ApplicationController
  def show
    @scenarios = Scenario.all
    @project_id = params[:project_id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
  end

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
end
