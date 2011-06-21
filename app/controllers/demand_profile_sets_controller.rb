class DemandProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_dpset, :only => [:edit, :update, :destroy]
  
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
    @dpset = DemandProfileSet.new
    if(@dpset.update_attributes(params[:demand_profile_set]))
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
      flash[:notice] = @dpset.name + " successfully deleted."    
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
      flash[:notice] = 'All demand profile sets have been successfully deleted.'  
      format.html { redirect_to project_configuration_demand_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def populate_demands_table
    #I populate dpset so we can make sure to set checkboxes selected -- if there is no demand profile set id then 
    #you are creating a new demand profile set 
    @dpset = params[:demand_profile_set_id].to_s == '' ? DemandProfileSet.new : get_set(@dprofilesets,params[:demand_profile_set_id].to_i)
    if(params[:demand_profile_set] != nil)
        @sid = params[:demand_profile_set][:network_id].to_s == '' ? "-1" : params[:demand_profile_set][:network_id].to_s 
    else
        @sid = @dpset.network_id.to_s
    end
    get_network_dependent_table_items('demand_profile_sets','demand_profiles','link.type_link',@sid)   
  end
private
  def not_found_redirect_to_index
    redirect_to :action => :index, :project_id => @project
    flash[:error] = 'Demand Profile Set not found.'
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
end
