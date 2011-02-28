class ControllerGroupsController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  before_filter do |controller|
    controller.authorize(:configurations)
  end
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

      @controller_group_count = ControllerGroup.count(:conditions => "project_id = " + @project.id.to_s);
      @project_id = params[:project_id]
      @controller_groups_pages = Paginator.new self, @controller_group_count, @limit, params['page']
      @offset ||= @controller_groups_pages.current.offset
      @controller_groups_show = ControllerGroup.find     :all,
                                   :conditions => "project_id = " + @project.id.to_s,
                                   :order => sort_clause,
                                   :limit  =>  @limit,
                                   :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml => @networks }
      end
  end

  def edit
    @cgroup = ControllerGroup.find(params[:controller_group_id])
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
    @network = @cgroup.network_id == nil ? nil : Network.find(@cgroup.network_id) 
 
    #set up controllers table with controller groups network
    get_controllers(@network == nil ? "-1" : @network.id.to_s)
    
          
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @cgroup }
    end
    
  end

  def update
    @cgroup = ControllerGroup.find(params[:controller_group_id])
    @network = params[:controller_group][:network_id] == nil ? nil : Network.find(params[:controller_group][:network_id]) 
    respond_to do |format|
      if(@cgroup.update_attributes(params[:controller_group]))
        flash[:notice] = l(:notice_successful_update)
      else
        flash[:error] = "The network, " + @cgroup.name + ", was not not saved. See errors."
      end
      format.html { redirect_to  :controller => 'controller_groups', :action => 'edit',:project_id =>@project, :controller_group_id => @cgroup }
      format.xml  { render :xml => @cgroup, :status => :created, :location => @cgroup }
      
    end
  end

  def create  
       @cgroup = ControllerGroup.new(params[:controller_group])
 
      respond_to do |format|
        if(@cgroup.save)
          flash[:notice] = l(:notice_successful_create)
        else
          flash[:error] = "The network, " + @cgroup.name + ", was not not saved. See errors."
        end
        format.html { redirect_to  :controller => 'controller_groups', :action => 'edit',:project_id =>@project, :controller_group_id => @cgroup }
        format.xml  { render :xml => @cgroup, :status => :created, :location => @cgroup }
        
      end
    
  end

  # GET /controller_groups/new
  # GET /controller_groups/new.xml
  def new
    @cgroup = ControllerGroup.new
    @cgroup.name = params[:controller_group][:name] ||= ''
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
   
    #set up controllers table to be empty until network selected
    get_controllers("-1")
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cgroup }
    end
  end

  def populate_controls_table
    #I populate cgroup so we can make sure to set checkboxes selected -- if there is no controller group id then 
    #you are creating a new controller_group 
    @cgroup = params[:controller_group_id].to_s == '' ? ControllerGroup.new : ControllerGroup.find(params[:controller_group_id])
    @sid = params[:controller_group][:network_id].to_s == '' ? "-1" : params[:controller_group][:network_id].to_s
    get_controllers(@sid)
  end
  
  
  def get_controllers(sid)
    sort_init 'name', 'asc'
    sort_update %w(name)
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end
    
    @network = nil
    @controller_count = Controller.count(:conditions => "network_id = " + sid);
    @controllers_pages = Paginator.new self, @controller_count, @limit, params['page']
   
    @offset ||= @controllers_pages.current.offset
  
    @controllers = Controller.find :all,
                                 :conditions => "network_id = " +sid,
                                 :order => sort_clause,
                                 :limit  =>  @limit,
                                 :offset =>  @offset
  end
end
