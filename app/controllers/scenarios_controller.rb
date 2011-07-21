class ScenariosController <  ConfigurationsApplicationController
  before_filter :require_scenario, :only => [
    :edit, :update, :destroy, :show, :flash_edit, :copy_to, :copy_form
  ]

  def import
    auth = DbwebAuthorization.create_for(@project)
    @token = auth.access_token
  end
  
  # GET /scenarios
  # GET /scenarios.xml
  def index
    get_index_view(@scenarios)
  end

  # GET /scenarios/new
  # GET /scenarios/new.xml
  def new
    @scenario = Scenario.new
    @scenario.name = params[:scenario] != nil ? params[:scenario][:name] ||= '' : '' 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1.xml
  def show
    redirect_to Dbweb.object_export_url(@scenario)
  end

  # GET /scenarios/1/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1/flash_edit
  def flash_edit
    redirect_to Dbweb.object_editor_url(@scenario)
  end

  # POST /scenarios
  # POST /scenarios.xml
  def create
    params[:scenario].merge!(
      :user_id_creator => User.current.id,
      :user_id_modifier => User.current.id
    )
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
    params[:scenario].merge!(:user_id_modifier => User.current.id)
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
    begin
      Scenario.delete_all(@scenarios)
      flash[:notice] = l(:label_success_all_delete) 
    rescue
      flash[:error] = l(:label_not_success_all_delete)    
    end

    respond_to do |format|
      format.html { redirect_to  :controller => 'scenarios', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end

  def copy_form
    @projects = Project.all.select { |p|
      (p.id != @project.id) && User.current.allowed_to?(:edit_simulation_models, p)
    }
    @projects_select = @projects.map { |p| [p.name, p.id] }
    @dbweb_db_url = Dbweb.object_duplicate_url(@scenario)
  end

  def copy_to
    @target_project = Project.find(params[:to_project])
    if User.current.allowed_to?(:edit_simulation_models, @target_project)
      redirect_to(
        Dbweb.object_duplicate_url(@scenario, 
                                   :to_project => @target_project.id,
                                   :deep => true)
      )
    else
      redirect_to :index
    end
  end

private
  def require_scenario 
    begin
      @scenario = @project.scenarios.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Scenario not found.'
      return false
    end
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
