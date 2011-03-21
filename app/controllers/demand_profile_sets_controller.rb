class DemandProfileSetsController < ConfigurationsController
  
  def index
    get_index_view(DemandProfileSet,@dprofilesets)
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
    @dpset = DemandProfileSet.find(params[:demand_profile_set_id])
    set_up_network_select(@dpset,DemandProfile)
          
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @dpset }
    end
  end

  def create
    @dpset = DemandProfileSet.new(params[:demand_profile_set])
    if(@dpset.update_attributes(params[:demand_profile_set]))
      redirect_save_success(:demand_profile_set,{:controller => 'demand_profile_sets', :action => 'edit',:project_id =>@project, :demand_profile_set_id => @dpset})
    else
      redirect_save_error(:demand_profile_set,:new,@dpset,DemandProfile)
    end
  end

  def update
    @dpset = DemandProfileSet.find(params[:demand_profile_set_id])
     if(@dpset.update_attributes(params[:demand_profile_set]))
       redirect_save_success(:demand_profile_set,{:controller => 'demand_profile_sets', :action => 'edit',:project_id =>@project, :demand_profile_set_id => @dpset})
     else
       redirect_save_error(:demand_profile_set,:edit,@dpset,DemandProfile)
     end

  end
 
  # DELETE /demand_profile_sets/1
  # DELETE /demand_profile_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @dset = @project.demand_profile_sets.find(params[:demand_profile_set_id])
    @dset.remove_from_scenario
    @dset.destroy

    respond_to do |format|
      flash[:notice] = @dset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @dsets = @project.demand_profile_sets.all
    
    @dsets.each do | d |
      d.remove_from_scenario
      d.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All demand profile sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_demands_table
    #I populate dpset so we can make sure to set checkboxes selected -- if there is no demand profile set id then 
    #you are creating a new demand profile set 
    @dpset = params[:demand_profile_set_id].to_s == '' ? DemandProfileSet.new : DemandProfileSet.find(params[:demand_profile_set_id])
    if(params[:demand_profile_set] != nil)
        @sid = params[:demand_profile_set][:network_id].to_s == '' ? "-1" : params[:demand_profile_set][:network_id].to_s 
    else
        @sid = @dpset.network_id.to_s
    end

    get_network_dependent_table_items(DemandProfile,@sid)
   
  end
  

end
