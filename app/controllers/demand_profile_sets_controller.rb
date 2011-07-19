class DemandProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_dpset, :only => [:edit, :update, :destroy, :flash_edit]

  def index
    get_index_view(@dprofilesets)
  end

  # GET /demand_profile_sets/new
  # GET /demand_profile_sets/new.xml
  def new
    @dpset = DemandProfileSet.new
    @dpset.name = params[:demand_profile_set] != nil ? params[:demand_profile_set][:name] ||= '' : '' 
    set_up_network_select(@dpset,DemandProfile)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dpset }
    end
  end

  def edit
    set_up_network_select(@dpset,DemandProfile)
    get_network_dependent_table_items('demand_profile_sets','demand_profiles','link.type_link',@dpset.network_id)   


    respond_to do |format|
      format.html { render :layout => !request.xhr? } 
      format.xml  { render :xml => @dpset }
    end
  end

  def create
    @dpset = DemandProfileSet.new(params[:demand_profile_set])
    if(@dpset.save)
      redirect_save_success(:demand_profile_set,
        edit_project_configuration_demand_profile_set_path(@project,@dpset))
    else
      redirect_save_error(:demand_profile_set,:new,@dpset,DemandProfile)
    end
  end

  def update
    if(@dpset.update_attributes(params[:demand_profile_set]))
      redirect_save_success(:demand_profile_set,
        edit_project_configuration_demand_profile_set_path(@project,@dpset))
    else
      redirect_save_error(:demand_profile_set,:edit,@dpset,DemandProfile)
    end
  end
 
  # DELETE /demand_profile_sets/1
  # DELETE /demand_profile_sets/1.xml
  def destroy
    @dpset.remove_from_scenario
    @dpset.destroy

    respond_to do |format|
      flash[:notice] = @dpset.name + l(:label_success_delete)    
      format.html { redirect_to project_configuration_demand_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @dprofilesets.each do | d |
      d.remove_from_scenario
      d.destroy
    end

    respond_to do |format|
      flash[:notice] = l(:label_success_all_delete) 
      format.html { redirect_to project_configuration_demand_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def delete_item
    status = 200
    begin
      DemandProfileSet.delete_profile(params[:demand_profile_id].to_i)
      flash[:notice] = l(:label_profile_deleted)  
    rescue
      flash[:error] = l(:label_profile_not_deleted)
      status = 403
    end
    @nid = get_network_id
    get_network_dependent_table_items('demand_profile_sets','demand_profiles','link.type_link',@nid)
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@dpset)
  end

  def populate_table
    @nid = get_network_id
    get_network_dependent_table_items('demand_profile_sets','demand_profiles','link.type_link',@nid)   
  
    respond_to do |format|
      format.js
    end
  end
  
private
  def not_found_redirect_to_index
    redirect_to :action => :index, :project_id => @project
    flash[:error] = l(:demand_profile_set_not_found)
    return false
  end

  def require_dpset
    begin
      @dpset = get_set(@dprofilesets,params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index
    end
    if !@dpset
      return not_found_redirect_to_index
    end
  end
  
private
  def get_network_id
    if(params[:demand_profile_set] != nil) #coming from edit/new page onchange for network select
        params[:demand_profile_set][:network_id]
    elsif(params[:network_id] != nil) #coming from sort header for either new/edit
        params[:network_id]
    end
  end

end
