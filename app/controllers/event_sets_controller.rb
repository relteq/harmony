class EventSetsController <  ConfigurationsApplicationController
  before_filter :require_event_set, :only => [:edit, :update, :destroy, :flash_edit,:delete_item,:populate_table]
  before_filter :set_creator_params, :only => [:create]
  before_filter :set_modifier_params, :only => [:create, :update]
  before_filter :set_no_sort, :only => [:update,:delete_item]
  
  def index
    get_index_view(@eventsets)
  end
  
  # GET /event_sets/new
  # GET /event_sets/new.xml
  def new
    @eset = EventSet.new
    @eset.name = params[:event_set] != nil ? params[:event_set][:name] ||= '' : '' 
    set_up_network_select(@eset,Event)
 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eset }
    end
  end

  def edit
    set_up_network_select(@eset,Event)
    @items = @eset.events
    set_up_sort_pagination('event_type')
  
    respond_to do |format|
      format.html { render :layout => !request.xhr? } 
      format.js  
      format.xml  { render :xml => @eset }
    end
  end

  def create
    @eset = EventSet.new(params[:event_set])
    if(@eset.save)
      redirect_save_success(:event_set,
         edit_project_configuration_event_set_path(@project, @eset))
    else
      redirect_save_error(:event_set,:new,@eset,Event)
    end
  end

  def update
    if(@eset.update_attributes(params[:event_set]))
      redirect_save_success(:event_set,
        edit_project_configuration_event_set_path(@project, @eset,@sort_params))
    else
      redirect_save_error(:event_set,:edit,@eset,Event)
    end

  end
  
  # DELETE /event_sets/1
  # DELETE /event_sets/1.xml
  def destroy
    @eset.delete_set

    respond_to do |format|
      flash[:notice] = @eset.name + l(:label_success_delete)    
      format.html { redirect_to project_configuration_event_sets_path(@project)  }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
     begin
       EventSet.delete_all(@eventsets)
       flash[:notice] = l(:label_success_all_delete) 
     rescue
       flash[:error] = l(:label_not_success_all_delete)    
     end
     
     respond_to do |format|
       format.html { redirect_to project_configuration_event_sets_path(@project)  }
       format.xml  { head :ok }
     end
  end
   
  def delete_item
    status = 200
    begin
      EventSet.delete_event(params[:event_id].to_i)
      flash[:notice] = l(:label_event_deleted)  
    rescue
      flash[:error] = l(:label_event_not_deleted)
      status = 403
    end
    @items = @eset.events
    set_up_sort_pagination('event_type')
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@eset)
  end

  def populate_table
    
    @items = @eset.events
    set_up_sort_pagination('event_type')
    
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

  def require_event_set
    begin
      if(params[:event_set_id] == nil)
        eid = params[:id].to_i
      else
        eid = params[:event_set_id].to_i
      end
      
      @eset = get_set(@eventsets,eid )
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index(l(:event_set_not_found))
    end
    if !@eset
      return not_found_redirect_to_index(l(:event_set_not_found))
    end
  end
    
  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :event_set
  end
end
