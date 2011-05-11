class DemandProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_dpset, :only => [:edit, :update, :destroy]
  
  def index
    get_index_view_sets(@dprofilesets)
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
    get_network_dependent_table_items('demand_profile_sets','demand_profiles',@dpset.network_id)   
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @dpset }
    end
  end

  def create
    @dpset = DemandProfileSet.new(params[:demand_profile_set])
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
    @dsets = @project.demand_profile_sets.all
    
    @dsets.each do | d |
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
    get_network_dependent_table_items('demand_profile_sets','demand_profiles',@sid)   
  end
private
  def require_dpset
    begin
      @dpset = @dprofilesets.fetch(@dprofilesets.index {|e| e = params[:id]})
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Demand Profile Set not found.'
      return false
    end
  end
end
