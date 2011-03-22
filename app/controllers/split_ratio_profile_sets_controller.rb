class SplitRatioProfileSetsController <  ConfigurationsApplicationController
 
  def index
    get_index_view(SplitRatioProfileSet,@sprofilesets)
  end
  
  # GET /split_ratio_profile_sets/new
  # GET /split_ratio_profile_sets/new.xml
  def new
   @srpset = SplitRatioProfileSet.new
   @srpset.name = params[:split_ratio_profile_set] != nil ? params[:split_ratio_profile_set][:name] ||= '' : '' 
   set_up_network_select(@srpset,SplitRatioProfile)
 
   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @srpset }
   end
  end

  def edit
   @srpset = SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
   set_up_network_select(@srpset,SplitRatioProfile)

   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @srpset }
   end
  end

  def create
   @srpset = SplitRatioProfileSet.new(params[:split_ratio_profile_set])
   if(@srpset.update_attributes(params[:split_ratio_profile_set]))
     redirect_save_success(:split_ratio_profile_set,{:controller => 'split_ratio_profile_sets', :action => 'edit',:project_id =>@project, :split_ratio_profile_set_id => @srpset})
   else
     redirect_save_error(:split_ratio_profile_set,:new,@srpset,SplitRatioProfile)
   end
  end

  def update
   @srpset = SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
   if(@srpset.update_attributes(params[:split_ratio_profile_set]))
     redirect_save_success(:split_ratio_profile_set,{:controller => 'split_ratio_profile_sets', :action => 'edit',:project_id =>@project, :split_ratio_profile_set_id => @srpset})
   else
     redirect_save_error(:split_ratio_profile_set,:edit,@srpset,SplitRatioProfile)
   end
  end
  
  # DELETE /split_ratio_profile_sets/1
  # DELETE /split_ratio_profile_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @srpset = @project.split_ratio_profile_sets.find(params[:split_ratio_profile_set_id])
    @srpset.remove_from_scenario
    @srpset.destroy

    respond_to do |format|
      flash[:notice] = @srpset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'split_ratio_profile_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @srpsets = @project.split_ratio_profile_sets.all
    
    @srpsets.each do | s |
      s.remove_from_scenario 
      s.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All split ratio profile sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'split_ratio_profile_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_splits_table
    #I populate srpset so we can make sure to set checkboxes selected -- if there is no split ratio profile set id then 
    #you are creating a new split ratio profile set 
    @srpset = params[:split_ratio_profile_set_id].to_s == '' ? SplitRatioProfileSet.new : SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
    if(params[:split_ratio_profile_set] != nil)
      @sid = params[:split_ratio_profile_set][:network_id].to_s == '' ? "-1" : params[:split_ratio_profile_set][:network_id].to_s
    else
      @sid = @srpset.network_id.to_s
    end
     get_network_dependent_table_items(SplitRatioProfile,@sid)
  end




end
