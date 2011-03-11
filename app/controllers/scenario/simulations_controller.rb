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
    options = { :engine => 'aurora' }
    options[:param] = {}
    # :simple being set means this was called from 'Run Simulation'
    # rather than 'Run Simulation Batch'
    if params[:simple]
      options[:name] = @scenario.name
      options[:n_runs] = 1
      options[:mode] = 'simulation'
      options[:param][:b_time] = 0.0
      options[:param][:duration] = 0.0
      options[:param][:control] = true
      options[:param][:qcontrol] = true
      options[:param][:events] = true
    else
      options[:name] = params[:name]
      options[:n_runs] = params[:n_runs]
      options[:mode] = params[:mode]
      options[:param][:b_time] = params[:begin_time_h].to_f + 
                         params[:begin_time_m].to_f / 60.0 + 
                         params[:begin_time_s].to_f / 3600.0
      if params[:end_time_type] == 'duration'
        options[:param][:duration] = params[:end_time_h].to_f + 
                           params[:end_time_m].to_f / 60.0 + 
                           params[:end_time_s].to_f / 3600.0
      elsif params[:end_time_type] == 'end_time'
        options[:param][:duration] = params[:end_time_h].to_f + 
                           params[:end_time_m].to_f / 60.0 + 
                           params[:end_time_s].to_f / 3600.0 -
                           options[:param][:b_time]

      end
      options[:param][:control] = !!params[:control]
      options[:param][:qcontrol] = !!params[:qcontrol]
      options[:param][:events] = !!params[:events]
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
