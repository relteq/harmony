class CapacityProfileSetsController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  #before_filter do |controller|
  #  controller.authorize(:configurations)
  #end
  helper :sort
  helper :configurations
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

   @capacity_profile_set_count = CapacityProfileSet.count(:conditions => "project_id = " + @project.id.to_s);
   @project_id = params[:project_id]
   @capacity_profile_sets_pages = Paginator.new self, @capacity_profile_set_count, @limit, params['page']
   @offset ||= @capacity_profile_sets_pages.current.offset
   @capacity_profile_sets_show = CapacityProfileSet.find     :all,
                                :conditions => "project_id = " + @project.id.to_s,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

   respond_to do |format|
     format.html { render :layout => !request.xhr? } # index.html.erb
     format.xml  { render :xml => @cprofilesets }
   end

  end

  # GET /capacity_profile_sets/new
  # GET /capacity_profile_sets/new.xml
  def new
   @cpset = CapacityProfileSet.new
   @cpset.name = params[:capacity_profile_set] != nil ? params[:capacity_profile_set][:name] ||= '' : '' 
   @prompt_network = {:prompt =>  @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}

   #set up capacity profiles table to be empty until network selected
   get_capacityprofiles("-1")

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @cpset }
   end
  end

  def edit
   @cpset = CapacityProfileSet.find(params[:capacity_profile_set_id])
   @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
   @network = @cpset.network_id == nil ? nil : Network.find(@cpset.network_id) 
   rescue ActiveRecord::RecordNotFound
     @network = nil
   #set up capacitys table with capacity profile set network
   get_capacityprofiles(@network == nil ? "-1" : @network.id.to_s)


   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @cpset }
   end
  end

  def create
   @cpset = CapacityProfileSet.new(params[:capacity_profile_set])

   respond_to do |format|
     if(@cpset.save)
       save_capacityprofiles
       flash[:notice] = l(:notice_successful_create)
     else
       flash[:error] = "The capacity profile set, " + @cpset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'capacity_profile_sets', :action => 'edit',:project_id =>@project, :capacity_profile_set_id => @cpset }
     format.xml  { render :xml => @cpset, :status => :created, :location => @cpset }

   end
  end

  def update
   @cpset = CapacityProfileSet.find(params[:capacity_profile_set_id])
   @network = params[:capacity_profile_set][:network_id] == nil ? nil : Network.find(params[:capacity_profile_set][:network_id]) 
   respond_to do |format|
     if(@cpset.update_attributes(params[:capacity_profile_set]))
      save_capacityprofiles
      flash[:notice] = l(:notice_successful_update)
     else
       flash[:error] = "The capacity profile set, " + @cpset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'capacity_profile_sets', :action => 'edit',:project_id =>@project, :capacity_profile_set_id => @cpset }
     format.xml  { render :xml => @cpset, :status => :created, :location => @cpset }

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
   @sid = params[:capacity_profile_set][:network_id].to_s == '' ? "-1" : params[:capacity_profile_set][:network_id].to_s
   get_capacityprofiles(@sid)
  end

  def get_capacityprofiles(sid)
   sort_init 'name', 'asc'
   sort_update %w(name)
   case params[:format]
   when 'xml', 'json'
     @offset, @limit = api_offset_and_limit      
   else
     @limit = per_page_option
   end

   @network = nil
   @item_count = CapacityProfile.count(:conditions => "network_id = " + sid);
   @items_pages = Paginator.new self, @item_count, @limit, params['page']

   @offset ||= @items_pages.current.offset

   @items = CapacityProfile.find :all,
                                :conditions => "network_id = " +sid,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset
  end
  
  def save_capacityprofiles
    if( params[:capacity_profile_set][:capacity_profile_ids] != nil)
      params[:capacity_profile_set][:capacity_profile_ids].each do |id|
        @cprofile = CapacityProfile.find(id)
        @cprofile.profile = params[id]
        if(!@cprofile.save)
          flash[:error] = "The Capacity Profile Set," + @cpset.name + "is updated BUT the capacity profile, " + @cprofile.name + ", was not not saved. See errors."     
        end
      end
    end
  end
end
