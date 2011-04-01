class ScenariosController <  ConfigurationsApplicationController
  before_filter :get_sets, :only => [:new, :edit, :update, :create]
  before_filter :require_scenario, :only => [:edit, :update, :destroy]
  
  # GET /scenarios
  # GET /scenarios.xml
  def index
    get_index_view(Scenario,@scenarios)
  end

  # GET /scenarios/new
  # GET /scenarios/new.xml
  def new
    @scenario = Scenario.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # POST /scenarios
  # POST /scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.project_id = @project.id

    respond_to do |format|
      if(@scenario.save)
        flash[:notice] = @scenario.name + ', was successfully created. You may configure the scenario below.'
        format.html { redirect_to edit_project_configuration_scenario_path(@project, @scenario) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
      else
        clear_fields
        format.html { render :action => :new }
        format.api  { render_validation_errors(@scenario) }  
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    respond_to do |format|
      if(@scenario.update_attributes(params[:scenario]))
        flash[:notice] = 'Scenario was successfully updated.'  
        format.html { redirect_to edit_project_configuration_scenario_path(@project, @scenario) }
        format.xml  { head :ok }
      else
        clear_fields
        format.html { render :action => :edit}
        format.api  { render_validation_errors(@scenario) }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.xml
  def destroy
    @scenario.destroy

    respond_to do |format|
      flash[:notice] = @scenario.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'scenarios', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @scenarios = @project.scenarios.all
    
    @scenarios.each do | s |
      s.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All scenarios have been successfully deleted.'  
      format.html { redirect_to  :controller => 'scenarios', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
private
  def require_scenario 
    begin
      @scenario = Scenario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Scenario not found.'
      return false
    end
  end

  def get_sets
    @units = %w{miles feet kilometers meters}
    
    # All these strings should be localized.
    @prompt_network = (@networks.empty?) ? {:prompt => 'Create a Network'} : {:prompt => 'Please Select'}
     
    @csets = @project.controller_sets.sort_by(&:name)
    @prompt_controller = (@csets.empty?) ? {:prompt => 'Create a Controller Set'} : {:prompt => 'Please Select'}
    
    @dsets = @project.demand_profile_sets.sort_by(&:name)
    @prompt_demand = (@dsets.empty?) ? {:prompt => 'Create a Demand Profile Set'} : {:prompt => 'Please Select'}

    @cpsets = @project.capacity_profile_sets.sort_by(&:name)
    @prompt_capacity = (@cpsets.empty?) ? {:prompt => 'Create a Capacity Profile Set'} : {:prompt => 'Please Select'}
 
    @spsets = @project.split_ratio_profile_sets.sort_by(&:name)
    @prompt_split = (@spsets.empty?) ? {:prompt => 'Create a Split Ratio Profile Set'} : {:prompt => 'Please Select'}

    @esets = @project.event_sets.sort_by(&:name)
    @prompt_event = (@esets.empty?) ? {:prompt => 'Create an Event Set'} : {:prompt => 'Please Select'}
  end
  
  def clear_fields
    #if name or network existed and then removed clear the name/network
    if params[:scenario][:name] == ""
      @scenario.name  = nil
    end
    if params[:scenario][:network_id] == ""
      @scenario.network  = nil 
    end
    if params[:scenario][:b_time] == ""
      @scenario.b_time  = nil 
    end
    if params[:scenario][:e_time] == ""
      @scenario.e_time  = nil 
    end
    if params[:scenario][:dt] == ""
      @scenario.dt  = nil 
    end
  end
end
