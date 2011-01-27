class ConfigurationsController < ApplicationController
  def index
    @project = Project.find(:first).name
    @scenarios = Scenario.find(:all)
    @networks = Network.find(:all)
    @cgroups = ControllerGroup.find(:all)
    @dprofiles = DemandProfile.find(:all)
    @cprofiles = CapacityProfile.find(:all)
    @events = Event.find(:all)
  end

end
