class EventSetsController <  ConfigurationsApplicationController
  before_filter :require_event_set, :only => [:edit, :update, :destroy, :flash_edit]
  before_filter :populate_event_set_if_exists, :only => [:delete_item, :populate_table]
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
    @items = get_events(@eset.network_id)
    set_up_sort('event_type')
    set_up_pagination
    
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
    @eset.remove_from_scenario
    @eset.destroy

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
    
    @nid = require_network_id
    @items = get_events(@nid)   
    set_up_sort('event_type')
    set_up_pagination
    
    respond_to do |format|  
      format.js {render :status => status}    
    end
  end
  
  def flash_edit
    redirect_to Dbweb.object_editor_url(@eset)
  end

  def populate_table
    
    @nid = require_network_id
    @items = get_events(@nid)   
    set_up_sort('event_type')
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

  def populate_event_set_if_exists
    #for delete_item and populate table you'll be refrmatting the sub table. We want to select the current
    #events chosen if you are on the edit page but none should be checked for the new page. If event_set_id exists you came from 
    #the edit page and will need the event set object
    begin
      if(params[:event_set_id] != nil)
        eid = params[:event_set_id].to_i
        @eset = get_set(@eventsets,eid )
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:event_set_not_found_no_events_selected) 
    end
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
  
  def require_network_id
    network_id = nil
    if(params[:event_set] != nil) #coming from edit/new page onchange for network select
      network_id = params[:event_set][:network_id]
    elsif(params[:network_id] != nil) #coming from sort header for either new/edit
      network_id = params[:network_id]
    end

    if(network_id == nil)
      return not_found_redirect_to_index(l(:label_no_network_id))
    end
    return network_id
  end

  #The subitems table is determined differently than other sets because you are about to have network, node and link events, as well as change 
  #what event is assigned to what event set
  def get_events(nid)
    items = Array.new
    Network.find(nid).events.each do |e| 
      items.push(e) 
    end
    
    Network.find(nid).nodes.each do |n| 
      n.events.each do |e| 
        items.push(e) 
      end
    end
    
    Network.find(nid).links.each do |l| 
      l.events.each do |e| 
        items.push(e) 
      end
    end
    
    items
  end
  
  # Used by ConfigAppController to populate creator/modifier ID 
  def object_sym
    :event_set
  end
end
