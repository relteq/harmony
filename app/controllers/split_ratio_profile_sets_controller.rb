class SplitRatioProfileSetsController <  ConfigurationsApplicationController
  before_filter :require_srpset, :only => [:edit, :update, :destroy, :flash_edit,:delete_item,:populate_table]
  before_filter :set_creator_params, :only => [:create]
  before_filter :set_modifier_params, :only => [:create, :update]
  before_filter :set_no_sort, :only => [:update,:delete_item]
 
  def index
    get_index_view(@sprofilesets)
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
    @items = @srpset.split_ratio_profiles
    set_up_sort_pagination('node.name')
    
    respond_to do |format|
     format.html { render :layout => !request.xhr? } 
     format.js
     format.xml  { render :xml => @srpset }
    end
  end

  def create
    @srpset = SplitRatioProfileSet.new
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
      edit_project_configuration_split_ratio_profile_set_path(@project, @srpset,@sort_params))
    else
     redirect_save_error(:split_ratio_profile_set,:edit,@srpset,SplitRatioProfile)
    end
  end
  
  # DELETE /split_ratio_profile_sets/1
  # DELETE /split_ratio_profile_sets/1.xml
  def destroy
    @srpset.delete_set

    respond_to do |format|
      flash[:notice] = @srpset.name + l(:label_success_delete) 
      format.html { redirect_to  project_configuration_split_ratio_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    begin
      SplitRatioProfileSet.delete_all(@sprofilesets)
      flash[:notice] = l(:label_success_all_delete) 
    rescue
      flash[:error] = l(:label_not_success_all_delete)    
    end
    
    respond_to do |format|    
      format.html { redirect_to project_configuration_split_ratio_profile_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  
  def delete_item
    status = 200
    begin
      SplitRatioProfileSet.delete_profile(params[:split_ratio_profile_id].to_i)
      flash[:notice] = l(:label_profile_deleted)  
    rescue
      flash[:error] = l(:label_profile_not_deleted)
      status = 403
    end
    @items = @srpset.split_ratio_profiles
    set_up_sort_pagination('node.name')
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
 
  def flash_edit
    redirect_to Dbweb.object_editor_url(@srpset)
  end
 
  def populate_table
    @items = @srpset.split_ratio_profiles
    set_up_sort_pagination('node.name')
     
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

  def require_srpset
    begin
      @srpset = get_set(@sprofilesets,params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index(l(:split_ratio_profile_set_not_found))
    end
    if !@srpset
      return not_found_redirect_to_index(l(:split_ratio_profile_set_not_found))
    end
  end
  
  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :split_ratio_profile_set
  end
end
