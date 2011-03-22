class EventSetsController <  ConfigurationsApplicationController

  def index
    get_index_view(EventSet,@esets)
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
   @eset = EventSet.find(params[:event_set_id])
   set_up_network_select(@eset,Event)
  
   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @eset }
   end
  end

  def create
    @eset = EventSet.new(params[:event_set])
    if(@eset.save)
         redirect_save_success(:event_set,{:controller => 'event_sets', :action => 'edit',:project_id =>@project, :event_set_id => @eset})
    else
         redirect_save_error(:event_set,:new,@eset,Event)
    end
  
  end

  def update
   @eset = EventSet.find(params[:event_set_id])
   if(@eset.update_attributes(params[:event_set]))
     redirect_save_success(:event_set,{:controller => 'event_sets', :action => 'edit',:project_id =>@project, :event_set_id => @eset})
   else
     redirect_save_error(:event_set,:edit,@eset,Event)
   end

  end
  
  # DELETE /event_sets/1
  # DELETE /event_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @eset = @project.event_sets.find(params[:event_set_id])

    @eset.remove_from_scenario
    @eset.destroy

    respond_to do |format|
      flash[:notice] = @eset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'event_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @esets = @project.event_sets.all
    
    @esets.each do | e |
      e.remove_from_scenario
      e.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All event sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'event_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_events_table
    #I populate srpset so we can make sure to set checkboxes selected -- if there is no event set id then 
    #you are creating a new split ratio profile set 
    @eset = params[:event_set_id].to_s == '' ? EventSet.new : EventSet.find(params[:event_set_id])
    if(params[:event_set] != nil)
      @sid = params[:event_set][:network_id].to_s == '' ? "-1" : params[:event_set][:network_id].to_s
    else
      @sid = @eset.network_id.to_s
    end
    get_network_dependent_table_items(Event,@sid)
  end


  

  

end
