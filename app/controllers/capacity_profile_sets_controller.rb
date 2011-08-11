class CapacityProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_cp_set, :only => [:edit, :update, :destroy, :flash_edit]
  before_filter :set_creator_params, :only => [:create]
  before_filter :set_modifier_params, :only => [:create, :update]

  def index
    get_index_view(@cprofilesets)
  end

  # GET /capacity_profile_sets/new
  # GET /capacity_profile_sets/new.xml
  def new
    @cpset = CapacityProfileSet.new
    @cpset.name = params[:capacity_profile_set] != nil ? params[:capacity_profile_set][:name] ||= '' : '' 
    set_up_network_select(@cpset,CapacityProfile)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cpset }
    end
  end

  def edit
    set_up_network_select(@cpset,CapacityProfile)
    get_network_dependent_table_items('capacity_profile_sets','capacity_profiles','links','link.name',@cpset.network_id) 
    respond_to do |format|
      format.html { render :layout => !request.xhr? } 
      format.js
      format.xml  { render :xml => @cpset }
    end
  end

  def create
    @cpset = CapacityProfileSet.new
    if(@cpset.update_attributes(params[:capacity_profile_set]))
      redirect_save_success(:capacity_profile_set, 
        edit_project_configuration_capacity_profile_set_path(@project, @cpset))
    else
      redirect_save_error(:capacity_profile_set,:new,@cpset,CapacityProfile)
    end
  end

  def update
    if(@cpset.update_attributes(params[:capacity_profile_set]))
      redirect_save_success(:capacity_profile_set,
        edit_project_configuration_capacity_profile_set_path(@project, @cpset,:sort_update=> params[:sort_update])))
    else
      redirect_save_error(:capacity_profile_set,:edit,@cpset,CapacityProfile)
    end
  end
  
  # DELETE /capacity_profile_sets/1
  # DELETE /capacity_profile_sets/1.xml
  def destroy
    @cpset.remove_from_scenario
    @cpset.destroy

    respond_to do |format|
      flash[:notice] = @cpset.name + l(:label_success_delete)    
      format.html { redirect_to project_configuration_capacity_profile_sets_path(@project) } 
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    begin
      CapacityProfileSet.delete_all(@cprofilesets)
      flash[:notice] = l(:label_success_all_delete) 
    rescue
      flash[:error] = l(:label_not_success_all_delete)    
    end
    
    respond_to do |format|
      format.html { redirect_to project_configuration_capacity_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end

  def delete_item
    status = 200
    begin
      CapacityProfileSet.delete_profile(params[:capacity_profile_id].to_i)
      flash[:notice] = l(:label_profile_deleted)  
    rescue
      flash[:error] = l(:label_profile_not_deleted)
      status = 403
    end
    @nid = require_network_id
    get_network_dependent_table_items('capacity_profile_sets','capacity_profiles','links','link.name',@nid)
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@cpset)
  end

  def populate_table
    @nid = require_network_id
    get_network_dependent_table_items('capacity_profile_sets','capacity_profiles','links','link.name',@nid)
  
    respond_to do |format|
      format.js
    end
  end


  

private
  def not_found_redirect_to_index(error)
    redirect_to :action => :index, :project_id => @project
    flash[:error] = error
    return false
  end

  def require_cp_set
    begin
      @cpset = get_set(@cprofilesets,params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index(l(:capacity_profile_set_not_found))
    end
    if !@cpset
      return not_found_redirect_to_index(l(:capacity_profile_set_not_found))
    end
  end
  
  def require_network_id
    network_id = nil
    if(params[:capacity_profile_set] != nil) #coming from edit/new page onchange for network select
      network_id = params[:capacity_profile_set][:network_id]
    elsif(params[:network_id] != nil) #coming from sort header for either new/edit
      network_id = params[:network_id]
    end

    if(network_id == nil)
      return not_found_redirect_to_index(l(:label_no_network_id))
    end
    return network_id
  end  

  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :capacity_profile_set
  end
end
