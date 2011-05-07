class ConfigurationsApplicationController < ApplicationController
  before_filter :populate_menu
  menu_item :configurations  
  before_filter do |controller|
    controller.authorize(:configurations)
  end
  helper :sort
  helper :configurations
  include SortHelper
  
protected
  # Populates the Models Tabs menu
  def populate_menu
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render :file => "#{Rails.root}/public/404.html", :status => 404
      return false
    end

    @scenarios = @project.scenarios

    @networks = Array.new
    @scenarios.each {|e| @networks.push(e.network)} 
    
    @networks.each { |n|
      @csets =  (n.controller_sets ||= Array.new).sort_by(&:name) 
      @dprofilesets = (n.demand_profile_sets ||= Array.new).sort_by(&:name) 
      @cprofilesets = (n.capacity_profile_sets ||= Array.new).sort_by(&:name) 
      @sprofilesets = (n.split_ratio_profile_sets ||= Array.new).sort_by(&:name) 
      @eventsets =  (n.event_sets ||= Array.new).sort_by(&:name)  
    }

  end

  def redirect_save_success(set,url)
    @network = params[set][:network_id] == nil ? nil : Network.find(params[set][:network_id]) 
    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_update)
        redirect_to url
      }
      format.api  { head :ok }
    end
  end
  
  def redirect_save_error(set,action,record,model)
    set_up_network_select(record,model)
    #if name or network existed and then removed clear the name/network
    if params[set][:name] == ""
     record.name  = nil
    end
    if params[set][:network_id] == ""
     record.network  = nil 
    end

    respond_to do |format|
     format.html { render :action => action}
     format.api  { render_validation_errors(record) }
    end
  end
  
  def set_up_network_select(record,model)
    @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
    
    @network = record.network == nil ? nil : record.network
  
    #set up events table with split_ratio profile set network
    #get_network_dependent_table_items(record,model,@network == nil ? "-1" : @network.id.to_s)
  end
  
  def set_up_elements_table(model_elements)
    sort_init 'name', 'asc'
    sort_update %w(name)
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

#   @network = nil
#   @item_count = model.count(:conditions => {:network_id =>  sid});
    @item_count = model_elements.count
 
    @items_pages = Paginator.new self, @item_count, @limit, params['page']

    @offset ||= @items_pages.current.offset
 
    @items = model_elements[@offset,@offset + @limit ]
 
    # @items = model.find :all, :conditions => {:network_id => sid},
    #                           :order => sort_clause,
    #                           :limit  =>  @limit,
    #                           :offset =>  @offset
  end
  
  def get_index_view(model,records)
    sort_init 'name', 'asc'
    sort_update %w(name updated_at)

    case params[:format]
    when 'xml', 'json'
    @offset, @limit = api_offset_and_limit      
    else
    @limit = per_page_option
    end

    @item_count = model.count(:conditions => {:project_id => @project.id});
    @project_id = params[:project_id]
    @item_pages = Paginator.new self, @item_count, @limit, params['page']
    @offset ||= @item_pages.current.offset
    @items_show = model.find  :all,
                              :conditions => {:project_id => @project.id},
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => records }
    end
  end
end
