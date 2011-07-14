class EventSetsController <  ConfigurationsApplicationController
  before_filter :require_event_set, :only => [:edit, :update, :destroy, :flash_edit,:delete_event]

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
    get_network_dependent_table_items('event_sets','events','event_type',@eset.network_id) 
    respond_to do |format|
      format.html { render :layout => !request.xhr? } 
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
        edit_project_configuration_event_set_path(@project, @eset))
    else
      redirect_save_error(:event_set,:edit,@eset,Event)
    end

  end
  
  # DELETE /event_sets/1
  # DELETE /event_sets/1.xml
  def destroy
    @eset.remove_from_scenario
    @eset.destroy

    respond_to do |format|
      flash[:notice] = @eset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'event_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_event
    if(@eset.delete_event(params[:event]))
      flash[:notice] = "Event successfully deleted."    
    else
      flash[:error] =  "Event NOT successfully deleted."          
    end
    
    respond_to do |format|
       format.js
       format.html { redirect_to  edit_project_configuration_event_set_path(params[:project_id], params[:id])   }
       format.xml  { head :ok }
     end
  end
  
  def delete_all
    @eventsets.each do | e |
      e.remove_from_scenario
      e.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All event sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'event_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end

  def flash_edit
    redirect_to Dbweb.object_editor_url(@eset)
  end
  
  def populate_events_table
    #I populate eset so we can make sure to set checkboxes selected -- if there is no event set id then 
    #you are creating a new split ratio profile set 
    @eset = params[:event_set_id].to_s == '' ? EventSet.new : get_set(@eventsets,params[:event_set_id].to_i)
    if(params[:event_set] != nil)
      @sid = params[:event_set][:network_id].to_s == '' ? "-1" : params[:event_set][:network_id].to_s
    else
      @sid = @eset.network_id.to_s
    end
     get_network_dependent_table_items('event_sets','events','event_type',@sid)   
  end
private
  def not_found_redirect_to_index
    redirect_to :action => :index, :project_id => @project
    flash[:error] = 'Event Set not found.'
    return false
  end

  def require_event_set
    begin
      @eset = get_set(@eventsets,params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      return not_found_redirect_to_index 
    end
    if !@eset
      return not_found_redirect_to_index
    end
  end
end
