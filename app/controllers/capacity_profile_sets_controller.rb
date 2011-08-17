class CapacityProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_cp_set, :only => [:edit, :update, :destroy, :flash_edit,:delete_item,:populate_table]
  before_filter :set_creator_params, :only => [:create]
  before_filter :set_modifier_params, :only => [:create, :update]
  before_filter :set_no_sort, :only => [:update,:delete_item]

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
    @items = @cpset.capacity_profiles
    set_up_sort_pagination('link.name')
    
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
        edit_project_configuration_capacity_profile_set_path(@project, @cpset,@sort_params))
    else
      redirect_save_error(:capacity_profile_set,:edit,@cpset,CapacityProfile)
    end
  end
  
  # DELETE /capacity_profile_sets/1
  # DELETE /capacity_profile_sets/1.xml
  def destroy
    @cpset.delete_set

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
    @items = @cpset.capacity_profiles
    set_up_sort_pagination('link.name')
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@cpset)
  end

  def populate_table
    @items = @cpset.capacity_profiles
    set_up_sort_pagination('link.name')
      
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
  
  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :capacity_profile_set
  end
end
