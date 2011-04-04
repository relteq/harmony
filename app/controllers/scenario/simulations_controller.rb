class Scenario::SimulationsController < ConfigurationsApplicationController
  before_filter :load_scenario

  def new
    @simulation_modes = Simulation.modes 
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
      if params[:begin_time] =~ /(\d\d)h (\d\d)m (\d\d\.\d)s/
        options[:param][:b_time] = hours_from_hms($1,$2,$3)
      else
        Rails.logger.error "Problem with begin time input #{params[:begin_time]}"
      end

      if params[:duration] =~ /(\d\d)h (\d\d)m (\d\d\.\d)s/
        options[:param][:duration] = hours_from_hms($1,$2,$3)

        if options[:param][:duration] < 0
           flash[:error] = "Simulation duration less than zero.<br/>"
        end
      else
        Rails.logger.error "Problem with duration input #{params[:duration]}."
      end

      options[:name] = params[:name]
      options[:n_runs] = params[:n_runs]
      options[:mode] = params[:mode]
      options[:param][:control] = !!params[:control]
      options[:param][:qcontrol] = !!params[:qcontrol]
      options[:param][:events] = !!params[:events]
    end
    options[:user] = User.current.id

    if !flash[:error] && Simulation.launch(options)
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

  def hours_from_hms(h,m,s)
    h.to_f + m.to_f/60.0 + s.to_f/3600.0
  end
end
