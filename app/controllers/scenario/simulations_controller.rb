class Scenario::SimulationsController < ConfigurationsController
  before_filter :populate_menu
  menu_item :configurations  
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
      if params[:begin_time] =~ /(\d\d)H (\d\d)m (\d\d\.\d)s/
        options[:param][:b_time] = hours_from_hms($1,$2,$3)
      else
        Rails.logger.error "Problem with begin time input #{params[:begin_time]}"
      end

      if params[:end_time] =~ /(\d\d)H (\d\d)m (\d\d\.\d)s/
        if params[:end_time_type] == 'duration'
          options[:param][:duration] = hours_from_hms($1,$2,$3) 
        elsif params[:end_time_type] == 'end_time'
          options[:param][:duration] = options[:param][:b_time] - 
            hours_from_hms($1,$2,$3)
        end
      else
        Rails.logger.error "Problem with end time input #{params[:end_time]}"
      end

      options[:name] = params[:name]
      options[:n_runs] = params[:n_runs]
      options[:mode] = params[:mode]
      options[:param][:control] = !!params[:control]
      options[:param][:qcontrol] = !!params[:qcontrol]
      options[:param][:events] = !!params[:events]
    end
    options[:user] = User.current.id
    if Simulation.launch(options)
      flash[:notice] = "Simulation launched successfully."
    else
      flash[:error] = "Error launching simulation."
    end
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

  def hours_from_hms(h,m,s)
    h.to_f + m.to_f/60.0 + s.to_f/3600.0
  end
end
