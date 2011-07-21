class NetworksController <  ConfigurationsApplicationController
  before_filter :require_network, :only => [
    :edit, :update, :destroy, :show, :flash_edit, :copy_to, :copy_form
  ]

  # GET /networks
  # GET /networks.xml
  def index
    get_index_view(@networks)
  end

  # DELETE /networks/1
  # DELETE /networks/1.xml
  def destroy
    @network.remove_from_scenario
    @network.destroy

    respond_to do |format|
      flash[:notice] = @network.name + " successfully deleted."    
      format.html { redirect_to project_configuration_networks_path(@project) }
      format.xml  { head :ok }
    end
  end
    
  def delete_all
    begin
      Network.delete_all(@networks)
      flash[:notice] = l(:label_success_all_delete) 
    rescue
      flash[:error] = l(:label_not_success_all_delete)    
    end

    respond_to do |format|
      format.html { redirect_to project_configuration_networks_path(@project) }
      format.xml  { head :ok }
    end
  end
    
  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new
    @network.name = params[:network] != nil ? params[:network][:name] ||= '' : '' 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @network }
    end   
  end

  def show
    redirect_to Dbweb.object_export_url(@network)
  end
  
  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    params[:network].merge!(:modifier => User.current)
    if(@network.update_attributes(params[:network]))
      flash[:notice] = l(:notice_successful_update)
    end
    respond_to do |format|
      format.html { redirect_to edit_project_configuration_network_path(@project, @network) }
      format.xml  { head :ok }
      format.api  { render_validation_errors(@network) }
    end
  end
  
  # POST /networks
  # POST /networks.xml
  def create
    params[:network].merge!(
      :creator => User.current,
      :modifier => User.current
    )
    @network = Network.new(params[:network])
    respond_to do |format|
      if(@network.save)
        flash[:notice] = l(:notice_successful_create)
        format.html { redirect_to edit_project_configuration_network_path(@project, @network) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else
        flash[:error] = "The network, " + @network.name + ", was not not saved. See errors."
        format.html { redirect_to new_project_configuration_network_path(@project) }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  def import
    file_url = params[:furl] if params[:furl] 
    
    result = %x["#{Rails.root}/lib/import/bin/import #{file_url} #{@project.id}"]
    respond_to do |format|
      if(true)
        flash[:notice] = "Import successful: " + result   
        format.html { redirect_to project_configuration_networks_path(@project) }
        format.xml  { head :ok }
      else
        flash[:error] = "Import NOT successful."  
        format.html { redirect_to project_configuration_networks_path(@project) }
        format.xml  { head :ok }      
      end
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@network)
  end

  def copy_form
    @projects = Project.all.select { |p|
      (p.id != @project.id) && User.current.allowed_to?(:edit_simulation_models, p)
    }
    @projects_select = @projects.map { |p| [p.name, p.id] }
    @dbweb_db_url = Dbweb.object_duplicate_url(@network)
  end

  def copy_to
    @target_project = Project.find(params[:to_project])
    if User.current.allowed_to?(:edit_simulation_models, @target_project)
      redirect_to(
        Dbweb.object_duplicate_url(@network, 
                                   :to_project => @target_project.id,
                                   :deep => true)
      )
    else
      redirect_to :index
    end
  end

private
  def require_network
    begin
      @network = @project.networks.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Network not found.'
      return false
    end
  end
end
