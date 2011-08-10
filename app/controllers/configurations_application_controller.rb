class ConfigurationsApplicationController < ApplicationController
  before_filter :populate_menu
  after_filter :flash_headers
  menu_item :configurations  
  before_filter do |controller|
    controller.authorize(:configurations)
  end
  helper :sort
  helper :configurations
  include SortHelper
  
protected
  def set_creator_params
    params[object_sym].merge!(:creator => User.current)
  end

  def set_modifier_params
    params[object_sym].merge!(:modifier => User.current)
  end

  # Populates the Models Tabs menu
  def populate_menu
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
      return false
    end

    @scenarios = @project.scenarios
    @networks = @project.networks
    
    @csets = @project.controller_sets.sort_by(&:name)
    @dprofilesets = @project.demand_profile_sets.sort_by(&:name)
    @cprofilesets = @project.capacity_profile_sets.sort_by(&:name)
    @sprofilesets = @project.split_ratio_profile_sets.sort_by(&:name)
    @eventsets = @project.event_sets.sort_by(&:name)
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
  
  end
  
  
  def get_network_dependent_table_items(sets,subitems,profiles,sort_attribute,sid)
    get_items(sid,profiles,subitems)
    set_up_sort(sort_attribute)
    set_up_pagination
  end

  def get_index_view(records)
    sort_init 'name', 'asc'
    sort_update %w(name updated_at)
     
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

    @item_count = records.length
    @item_pages = Paginator.new self, @item_count, @limit, params['page']
    @offset ||= @item_pages.current.offset
    @items = Array.new
    
    sort = sort_clause.split(/,* /)
    records.sort! { |a,b|  a.send(sort[0]) <=> b.send(sort[0]) } 
    if(sort[1] == 'DESC')
      records.reverse!
    end
    
    @items_show = records[@offset,@offset + @limit ]
 
    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => records }
    end
  end
  
  def get_set(sets,id)
    sets.select{|e| e.id == id}.first
  end
  
  
  def flash_headers
    # This will discontinue execution if Rails detects that the request is not
    # from an AJAX request, i.e. the header wont be added for normal requests
    return unless request.xhr?

    response.headers['x-flash-error'] = flash[:error]  unless flash[:error].blank?
    response.headers['x-flash-notice'] = flash[:notice]  unless flash[:notice].blank?
    response.headers['x-flash-warning'] = flash[:warning]  unless flash[:warning].blank?

    # Stops the flash appearing when you next refresh the page
    flash.discard
  end
  
  private
    def set_up_pagination
      case params[:format]
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit      
      else
        @limit = per_page_option
      end
      
      @item_count = @items.length
      @items_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @items_pages.current.offset
      @items =  @items[@offset,@offset + @limit ]
      
    end
  
  def set_up_sort(sort_attribute)
    sort_init sort_attribute, 'asc'
    sort_update [sort_attribute]
    sort = sort_clause.split(/,* /)
    subs = sort[0].split('.')

    if(subs.length == 2)
      @items.sort! { |a,b|  a.send(subs[0]).send("name") <=> b.send(subs[0]).send("name") } 
    else
      @items.sort! { |a,b|  a.send(sort[0]) <=> b.send(sort[0]) } 
    end
    
    if(sort[1] == 'DESC' || (params[:sort_update] != nil && params[:sort_update] == 'desc'))
      @items.reverse!
    end
  
  end
  
  def get_items(sid,profiles,subitems)
    @items = Array.new
    Network.find(sid).send(profiles).each { |cs|
       cs.send(subitems).each { |c|
         @items.push(c) 
       }   
    }
  end
end
