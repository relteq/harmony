class NetworksController < ApplicationController
   menu_item :configurations  
   before_filter :populate_menu
   before_filter do |controller|
     controller.authorize(:configurations)
   end
   helper :sort
   include SortHelper
 
 
    # GET /networks
    # GET /networks.xml
    def index
      sort_init 'name', 'asc'
      sort_update %w(name updated_at)

      case params[:format]
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit      
      else
        @limit = per_page_option
      end

      @network_count = Network.count(:conditions => "project_id = " + @project.id.to_s);
      @project_id = params[:project_id]
      @networks_pages = Paginator.new self, @network_count, @limit, params['page']
      @offset ||= @networks_pages.current.offset
      @networks = Network.find     :all,
                                   :conditions => "project_id = " + @project.id.to_s,
                                   :order => sort_clause,
                                   :limit  =>  @limit,
                                   :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
    #    format.xml  { render :xml => @networks }
      end
    end

   # GET /networks/new
   # GET /networks/new.xml
   def new
     @network = Network.new
     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @network }
     end
   end

  def edit
     @network = Network.find(params[:network_id])

     respond_to do |format|
       format.html # edit.html.erb
       format.xml  { render :xml => @network }
     end
      
  end
  
  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    @network = Network.find(params[:network_id])

    respond_to do |format|
      if(@network.update_attributes(params[:network]))
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to  :controller => 'networks', :action => 'edit',:project_id =>@project, :network_id => @network  }
        format.xml  { head :ok }
      else
        format.html { redirect_to :controller => 'networks', :action => 'edit',:project_id =>@project, :network_id => @network }
        format.api  { render_validation_errors(@network) }
      end
    end
  end
  
  # POST /networks
  # POST /networks.xml
  def create
    @network = Network.new(params[:network])

    respond_to do |format|
      if(@network.save)
        flash[:notice] = l(:notice_successful_create)
        format.html { redirect_to  :controller => 'networks', :action => 'edit',:project_id =>@project, :network_id => @network }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else
        flash[:error] = "The network, " + @network.name + ", was not not saved. See errors."
        format.html { redirect_to  :controller => 'networks', :action => 'new', :project_id => @project, :network_id => @network }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
  
      end
    end
  end
  
end