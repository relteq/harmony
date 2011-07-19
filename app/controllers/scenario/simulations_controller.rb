class Scenario::SimulationsController < ConfigurationsApplicationController
  include RelteqTime
  before_filter :load_scenario

  def new
    @simulation_modes = Runweb.simulation_modes 
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
      
      if(params[:save_defaults])
        DefaultBatchSetting.save_default_batch_settings(params)
      end
      
    else
      options = :simple
    end

    name = params[:name] || @scenario.name
    if !flash[:error] && Runweb.simulate(@scenario, name, options)
      flash[:notice] = "Job started successfully."
      SimulationBatch.save_batch(params)
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
