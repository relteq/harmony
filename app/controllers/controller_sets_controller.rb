class ControllerSetsController <  ConfigurationsApplicationController
  before_filter :require_controller_set, :only => [:edit, :update, :destroy, :flash_edit,:delete_item,:populate_table]
  before_filter :set_creator_params, :only => [:create]
  before_filter :set_modifier_params, :only => [:create, :update]
  before_filter :set_no_sort, :only => [:update,:delete_item]

  def index
    get_index_view(@csets)
  end

  def edit
    set_up_network_select(@cset,Controller)
    @items = @cset.controllers
    set_up_sort('controller_type')
    set_up_pagination

    respond_to do |format|
      format.html { render :layout => !request.xhr? } 
      format.js   
      format.xml  { render :xml => @cset }
    end
  end

  def update
    if(@cset.update_attributes(params[:controller_set]))
      redirect_save_success(:controller_set, edit_project_configuration_controller_set_path(@project, @cset,@sort_params))
    else
      redirect_save_error(:controller_set,:new,@cset,ControllerSet)
    end
  end

  def create  
    @cset = ControllerSet.new
    if(@cset.update_attributes(params[:controller_set]))
      redirect_save_success(:controller_set, edit_project_configuration_controller_set_path(@project, @cset))
    else
      redirect_save_error(:controller_set,:new,@cset,ControllerSet)
    end
  end

  # GET /controller_sets/new
  # GET /controller_sets/new.xml
  def new
    @cset = ControllerSet.new
    @cset.name = params[:controller_set] != nil ? params[:controller_set][:name] ||= '' : ''
    set_up_network_select(@cset,Controller)
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cset }
    end
  end

  # DELETE /controller_sets/1
  # DELETE /controller_sets/1.xml
  def destroy
    @cset.delete_set

    respond_to do |format|
      flash[:notice] = @cset.name + l(:label_success_delete)     
      format.html { redirect_to project_configuration_controller_sets_path(@project)  }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    begin
      ControllerSet.delete_all(@csets)
      flash[:notice] = l(:label_success_all_delete) 
    rescue
      flash[:error] = l(:label_not_success_all_delete)    
    end

    respond_to do |format|  
      format.html { redirect_to project_configuration_controller_sets_path(@project) }
      format.xml  { head :ok }
    end
  end
  

  def delete_item
    status = 200
    begin
      ControllerSet.delete_controller(params[:controller_id].to_i)
      flash[:notice] = l(:label_controller_deleted)  
    rescue
      flash[:error] = l(:label_controller_not_deleted)
      status = 403
    end
    @items = @cset.controllers
    set_up_sort('controller_type')
    set_up_pagination
     
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@cset)
  end

  def populate_table
    @items = @cset.controllers
    set_up_sort('controller_type')
    set_up_pagination
    
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

  def require_controller_set
    begin
      @cset = get_set(@csets,params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index(l(:controller_set_not_found)) 
    end
    if !@cset
      return not_found_redirect_to_index(l(:controller_set_not_found))
    end
  end
  
 
  
  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :controller_set
  end
end
