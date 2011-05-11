class SplitRatioProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_srpset, :only => [:edit, :update, :destroy]
 
  def index
    get_index_view_sets(@sprofilesets)
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
   set_up_network_select(@srpset,SplitRatioProfile)
   get_network_dependent_table_items('split_ratio_profile_sets','split_ratio_profiles',@srpset.network_id)   
   
   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @srpset }
   end
  end

  def create
   @srpset = SplitRatioProfileSet.new(params[:split_ratio_profile_set])
   if(@srpset.update_attributes(params[:split_ratio_profile_set]))
     redirect_save_success(:split_ratio_profile_set,
      edit_project_configuration_split_ratio_profile_set_path(@project, @srpset))
   else
     redirect_save_error(:split_ratio_profile_set,:new,@srpset,SplitRatioProfile)
   end
  end

  def update
   if(@srpset.update_attributes(params[:split_ratio_profile_set]))
     redirect_save_success(:split_ratio_profile_set,
      edit_project_configuration_split_ratio_profile_set_path(@project, @srpset))
   else
     redirect_save_error(:split_ratio_profile_set,:edit,@srpset,SplitRatioProfile)
   end
  end
  
  # DELETE /split_ratio_profile_sets/1
  # DELETE /split_ratio_profile_sets/1.xml
  def destroy
    @srpset.remove_from_scenario
    @srpset.destroy

    respond_to do |format|
      flash[:notice] = @srpset.name + " successfully deleted."    
      format.html { redirect_to  project_configuration_split_ratio_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @srpsets = @project.split_ratio_profile_sets.all
    
    @srpsets.each do | s |
      s.remove_from_scenario 
      s.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All split ratio profile sets have been successfully deleted.'  
      format.html { redirect_to project_configuration_split_ratio_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def populate_splits_table
    #I populate srpset so we can make sure to set checkboxes selected -- if there is no split ratio profile set id then 
    #you are creating a new split ratio profile set 
    @srpset = params[:split_ratio_profile_set_id].to_s == '' ? SplitRatioProfileSet.new : get_set(@sprofilesets,params[:split_ratio_profile_set_id].to_i)
    if(params[:split_ratio_profile_set] != nil)
      @sid = params[:split_ratio_profile_set][:network_id].to_s == '' ? "-1" : params[:split_ratio_profile_set][:network_id].to_s
    else
      @sid = @srpset.network_id.to_s
    end
    get_network_dependent_table_items('split_ratio_profile_sets','split_ratio_profiles',@sid)
  end
private
  def require_srpset
    begin
      @srpset = @sprofilesets.fetch(@sprofilesets.index {|e| e = params[:id]})
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Split Ratio Profile Set not found.'
      return false
    end
  end
end
