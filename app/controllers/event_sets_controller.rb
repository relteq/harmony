class EventSetsController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  #before_filter do |controller|
  #  controller.authorize(:configurations)
  #end
  helper :configurations
  helper :sort
  include SortHelper

  def index
    sort_init 'name', 'asc'
    sort_update %w(name updated_at)

    case params[:format]
    when 'xml', 'json'
    @offset, @limit = api_offset_and_limit      
    else
    @limit = per_page_option
    end

    @event_set_count = EventSet.count(:conditions => "project_id = " + @project.id.to_s);
    @project_id = params[:project_id]
    @event_sets_pages = Paginator.new self, @event_set_count, @limit, params['page']
    @offset ||= @event_sets_pages.current.offset
    @event_sets_show = EventSet.find     :all,
                              :conditions => "project_id = " + @project.id.to_s,
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => @esets }
    end

  end
  
  # GET /event_sets/new
  # GET /event_sets/new.xml
  def new
   @eset = EventSet.new
   @eset.name = params[:event_set] != nil ? params[:event_set][:name] ||= '' : '' 
   @prompt_network = {:prompt =>  @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}

   #set up events table to be empty until network selected
   get_events("-1")

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @eset }
   end
  end

  def edit
   @eset = EventSet.find(params[:event_set_id])
   @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
   @network = @eset.network_id == nil ? nil : Network.find(@eset.network_id) 
   rescue ActiveRecord::RecordNotFound
     @network = nil
   
   #set up events table with split_ratio profile set network
   get_events(@network == nil ? "-1" : @network.id.to_s)


   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @eset }
   end
  end

  def create
   @eset = EventSet.new(params[:event_set])

   respond_to do |format|
     if(@eset.save)
       save_events
       flash[:notice] = l(:notice_successful_create)
     else
       flash[:error] = "The event set, " + @eset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'event_sets', :action => 'edit',:project_id =>@project, :event_set_id => @eset }
     format.xml  { render :xml => @eset, :status => :created, :location => @eset }

   end
  end

  def update
   @eset = EventSet.find(params[:event_set_id])
   @network = params[:event_set][:network_id] == nil ? nil : Network.find(params[:event_set][:network_id]) 
   respond_to do |format|
     if(@eset.update_attributes(params[:event_set]))
       save_events
       flash[:notice] = l(:notice_successful_update)
     else
       flash[:error] = "The event set, " + @eset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'event_sets', :action => 'edit',:project_id =>@project, :event_set_id => @eset }
     format.xml  { render :xml => @eset, :status => :created, :location => @eset }

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
    @sid = params[:event_set][:network_id].to_s == '' ? "-1" : params[:event_set][:network_id].to_s
    get_events(@sid)
  end

  def get_events(sid)
    sort_init 'name', 'asc'
    sort_update %w(name)
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

    @network = nil
    @item_count = Event.count(:conditions => "network_id = " + sid);
    @items_pages = Paginator.new self, @item_count, @limit, params['page']

    @offset ||= @items_pages.current.offset

    @items = Event.find :all,
                                :conditions => "network_id = " +sid,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset
  end
  
  def save_events
    if(params[:event_set][:event_ids] != nil)
      params[:event_set][:event_ids].each do |id|
        @event = Event.find(id)
        @event.profile = params[id]
        if(!@event.save)
          flash[:error] = "The Event Set," + @eset.name + "is updated BUT the event, " + @event.name + ", was not not saved. See errors."     
        end
      end
    end
  end
end
