class ControllerSetsController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  #before_filter do |controller|
  #  controller.authorize(:configurations)
  #end
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

      @controller_set_count = ControllerSet.count(:conditions => "project_id = " + @project.id.to_s);
      @project_id = params[:project_id]
      @controller_sets_pages = Paginator.new self, @controller_set_count, @limit, params['page']
      @offset ||= @controller_sets_pages.current.offset
      @controller_sets_show = ControllerSet.find     :all,
                                   :conditions => "project_id = " + @project.id.to_s,
                                   :order => sort_clause,
                                   :limit  =>  @limit,
                                   :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml => @controller_sets }
      end
  end

  def edit
    @cset = ControllerSet.find(params[:controller_set_id])
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
    @network = @cset.network_id == nil ? nil : Network.find(@cset.network_id) 
 
    #set up controllers table with controller groups network
    get_controllers(@network == nil ? "-1" : @network.id.to_s)
    
          
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @cset }
    end
    
  end

  def update
    @cset = ControllerSet.find(params[:controller_set_id])
    @network = params[:controller_set][:network_id] == nil ? nil : Network.find(params[:controller_set][:network_id]) 
    respond_to do |format|
      if(@cset.update_attributes(params[:controller_set]))
        flash[:notice] = l(:notice_successful_update)
      else
        flash[:error] = "The Controller Group, " + @cset.name + ", was not not saved. See errors."
      end
      format.html { redirect_to  :controller => 'controller_sets', :action => 'edit',:project_id =>@project, :controller_set_id => @cset }
      format.xml  { render :xml => @cset, :status => :created, :location => @cset }
      
    end
  end

  def create  
       @cset = ControllerSet.new(params[:controller_set])
 
      respond_to do |format|
        if(@cset.save)
          flash[:notice] = l(:notice_successful_create)
        else
          flash[:error] = "The Controller Group, " + @cset.name + ", was not not saved. See errors."
        end
        format.html { redirect_to  :controller => 'controller_sets', :action => 'edit',:project_id =>@project, :controller_set_id => @cset }
        format.xml  { render :xml => @cset, :status => :created, :location => @cset }
        
      end
    
  end

  # GET /controller_sets/new
  # GET /controller_sets/new.xml
  def new
    @cset = ControllerSet.new
    @cset.name = params[:controller_set] != nil ? params[:controller_set][:name] ||= '' : ''
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_sets_configured) : l(:label_please_select)}
   
    #set up controllers table to be empty until network selected
    get_controllers("-1")
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cset }
    end
  end

  def populate_controls_table
    #I populate cset so we can make sure to set checkboxes selected -- if there is no controller group id then 
    #you are creating a new controller_set 
    @cset = params[:controller_set_id].to_s == '' ? ControllerSet.new : ControllerSet.find(params[:controller_set_id])
    @sid = params[:controller_set][:network_id].to_s == '' ? "-1" : params[:controller_set][:network_id].to_s
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
