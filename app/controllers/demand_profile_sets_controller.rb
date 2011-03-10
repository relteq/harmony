class DemandProfileSetsController < ApplicationController
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

    @demand_profile_set_count = DemandProfileSet.count(:conditions => "project_id = " + @project.id.to_s);
    @project_id = params[:project_id]
    @demand_profile_sets_pages = Paginator.new self, @demand_profile_set_count, @limit, params['page']
    @offset ||= @demand_profile_sets_pages.current.offset
    @demand_profile_sets_show = DemandProfileSet.find     :all,
                                 :conditions => "project_id = " + @project.id.to_s,
                                 :order => sort_clause,
                                 :limit  =>  @limit,
                                 :offset =>  @offset

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => @dprofilesets }
    end
    
  end

  # GET /demand_profile_sets/new
  # GET /demand_profile_sets/new.xml
  def new
    @dpset = DemandProfileSet.new
    @dpset.name = params[:demand_profile_set] != nil ? params[:demand_profile_set][:name] ||= '' : '' 
    @prompt_network = {:prompt =>  @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
   
    #set up demand profiles table to be empty until network selected
    get_demandprofiles("-1")
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dpset }
    end
  end

  def edit
    @dpset = DemandProfileSet.find(params[:demand_profile_set_id])
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
    @network = @dpset.network_id == nil ? nil : Network.find(@dpset.network_id) 
    rescue ActiveRecord::RecordNotFound
      @network = nil
    
    #set up demands table with demand profile set network
    get_demandprofiles(@network == nil ? "-1" : @network.id.to_s)
    
          
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @dpset }
    end
  end

  def create
    @dpset = DemandProfileSet.new(params[:demand_profile_set])

    respond_to do |format|
      if(@dpset.save)
        save_demandprofiles
        flash[:notice] = l(:notice_successful_create)
      else
        flash[:error] = "The demand profile set, " + @dpset.name + ", was not not saved. See errors."
      end
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'edit',:project_id =>@project, :demand_profile_set_id => @dpset }
      format.xml  { render :xml => @dpset, :status => :created, :location => @dpset }
      
    end
  end

  def update
    @dpset = DemandProfileSet.find(params[:demand_profile_set_id])
    respond_to do |format|
      if(@dpset.update_attributes(params[:demand_profile_set]))
        save_demandprofiles
        flash[:notice] = l(:notice_successful_update)
      else
        flash[:error] = "The demand profile set, " + @dpset.name + ", was not not saved. See errors."
      end
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'edit',:project_id =>@project, :demand_profile_set_id => @dpset }
      format.xml  { render :xml => @dpset, :status => :created, :location => @dpset }    
    end
  end
 
  # DELETE /demand_profile_sets/1
  # DELETE /demand_profile_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @dset = @project.demand_profile_sets.find(params[:demand_profile_set_id])
    @dset.destroy

    respond_to do |format|
      flash[:notice] = @dset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @dsets = @project.demand_profile_sets.all
    
    @dsets.each do | d |
      d.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All demand profile sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'demand_profile_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_demands_table
    #I populate dpset so we can make sure to set checkboxes selected -- if there is no demand profile set id then 
    #you are creating a new demand profile set 
    @dpset = params[:demand_profile_set_id].to_s == '' ? DemandProfileSet.new : DemandProfileSet.find(params[:demand_profile_set_id])
    @sid = params[:demand_profile_set][:network_id].to_s == '' ? "-1" : params[:demand_profile_set][:network_id].to_s
    get_demandprofiles(@sid)
  end

  def get_demandprofiles(sid)
    sort_init 'name', 'asc'
    sort_update %w(name)
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end
    
    @network = nil
    @item_count = DemandProfile.count(:conditions => "network_id = " + sid);
    @items_pages = Paginator.new self, @item_count, @limit, params['page']
   
    @offset ||= @items_pages.current.offset
  
    @items = DemandProfile.find :all,
                                 :conditions => "network_id = " +sid,
                                 :order => sort_clause,
                                 :limit  =>  @limit,
                                 :offset =>  @offset
  end
  
  def save_demandprofiles
    if(params[:demand_profile_set][:demand_profile_ids] != nil)
      params[:demand_profile_set][:demand_profile_ids].each do |id|
        @dprofile = DemandProfile.find(id)
        @dprofile.profile = params[id]
        if(!@dprofile.save)
          flash[:error] = "The Demand Profile Set," + @dpset.name + "is updated BUT the demand profile, " + @dprofile.name + ", was not not saved. See errors."     
        end
      end
    end
  end
end
