class CapacityProfileSetsController < ConfigurationsController

  def index
    get_index_view(CapacityProfileSet,@cprofilesets)
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
   @cpset = CapacityProfileSet.find(params[:capacity_profile_set_id])
   set_up_network_select(@cpset,CapacityProfile)

   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @cpset }
   end
  end

  def create
   @cpset = CapacityProfileSet.new(params[:capacity_profile_set])
   if(@cpset.update_attributes(params[:capacity_profile_set]))
     redirect_save_success(:capacity_profile_set,{:controller => 'capacity_profile_sets', :action => 'edit',:project_id =>@project, :capacity_profile_set_id => @cpset})
   else
     redirect_save_error(:capacity_profile_set,:new,@cpset,CapacityProfile)
   end
  end

  def update
   @cpset = CapacityProfileSet.find(params[:capacity_profile_set_id])
   if(@cpset.update_attributes(params[:capacity_profile_set]))
     redirect_save_success(:capacity_profile_set,{:controller => 'capacity_profile_sets', :action => 'edit',:project_id =>@project, :capacity_profile_set_id => @cpset})
   else
     redirect_save_error(:capacity_profile_set,:edit,@cpset,CapacityProfile)
   end
  end
  
  # DELETE /capacity_profile_sets/1
  # DELETE /capacity_profile_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @cpset = @project.capacity_profile_sets.find(params[:capacity_profile_set_id])
    @cpset.remove_from_scenario
    @cpset.destroy

    respond_to do |format|
      flash[:notice] = @cpset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'capacity_profile_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @cpsets = @project.capacity_profile_sets.all
    
    @cpsets.each do | cp |
      cp.remove_from_scenario
      cp.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All capacity profile sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'capacity_profile_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_capacities_table
   #I populate cpset so we can make sure to set checkboxes selected -- if there is no capacity profile set id then 
   #you are creating a new capacity profile set 
   @cpset = params[:capacity_profile_set_id].to_s == '' ? CapacityProfileSet.new : CapacityProfileSet.find(params[:capacity_profile_set_id])
   if(params[:capacity_profile_set] != nil)
       @sid = params[:capacity_profile_set][:network_id].to_s == '' ? "-1" : params[:capacity_profile_set][:network_id].to_s
   else
       @sid = @cpset.network_id.to_s
   end
  
    get_network_dependent_table_items(CapacityProfile,@sid)
  end

end
