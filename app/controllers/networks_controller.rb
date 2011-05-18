class NetworksController <  ConfigurationsApplicationController
  before_filter :require_network, :only => [:edit, :update, :destroy]

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
    @items = @project.networks.all

    @items.each do | i |
      i.remove_from_scenario
      i.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All networks have been successfully deleted.'  
      format.html { redirect_to project_configuration_networks_path(@project) }
      format.xml  { head :ok }
    end
  end
    
  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new
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
  
  # PUT /networks/1
  # PUT /networks/1.xml
  def update
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
    
    result = `#{Rails.root}/lib/import/bin/import #{file_url} #{@project.id}`
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
