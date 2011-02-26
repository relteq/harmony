class Scenario::SimulationsController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  before_filter do |controller|
    controller.authorize(:configurations)
  end
  before_filter :load_scenario

  def new
    @simulation_modes = ['Simulation', 'Prediction']
    @end_time_types = [['End Time', 'end_time'], ['Duration', 'duration']]
  end

  def create
    options = {}
    # :simple being set means this was called from 'Run Simulation'
    # rather than 'Run Simulation Batch'
    if params[:simple]
      options[:name] = @scenario.name
      options[:n_runs] = 1
      options[:mode] = 'simulation'
      options[:b_time] = 0.0
      options[:duration] = 0.0
      options[:control] = true
      options[:qcontrol] = true
      options[:events] = true
      options[:engine] = 'dummy'
    else
    end
    options[:user] = User.current.id
    Simulation.launch(options)
    redirect_to :home
  end

private
  def load_scenario
    @scenario = Scenario.find(params[:scenario_id])
    if !@scenario 
      flash[:error] = 'Error: scenario does not exist.'
      redirect_to :root
    end
  end
end
