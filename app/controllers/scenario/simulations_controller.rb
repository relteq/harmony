class Scenario::SimulationsController < ConfigurationsApplicationController
  include RelteqTime
  before_filter :load_scenario

  def new
    @simulation_modes = Simulation.modes 
  end

  def create
    options = {}
    options[:param] = {}

    # :simple being set means this was called from 'Run Simulation'
    # rather than 'Run Simulation Batch'
    unless params[:simple]
      options[:n_runs] = params[:n_runs].to_i
      options[:param][:b_time] = params[:begin_time]
      options[:param][:duration] = params[:duration]
      options[:param]['control'] = !!params[:control]
      options[:param]['qcontrol'] = !!params[:qcontrol]
      options[:param]['events'] = !!params[:events]
    else
      options = :simple
    end

    name = params[:name] || @scenario.name
    if !flash[:error] && Simulation.launch(params[:scenario_id], name, options)
      flash[:notice] = "Simulation launched successfully."
    elsif flash[:error]
      flash[:error] += "Error launching simulation.<br/>"
    else
      flash[:error] = "Error launching simulation."
    end
    redirect_to :my_page 
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
