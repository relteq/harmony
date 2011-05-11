class ConfigurationsApplicationController < ApplicationController
  before_filter :populate_menu
  menu_item :configurations  
#  before_filter do |controller|
#    controller.authorize(:configurations)
#  end
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
    @networks = @project.networks
    
    if(@csets == nil)
      @csets = Array.new
      @dprofilesets = Array.new
      @cprofilesets = Array.new
      @sprofilesets = Array.new
      @eventsets = Array.new
    end
    
    @networks.each { |n|
      n.controller_sets.each {|e| @csets.push(e)}
      n.demand_profile_sets.each {|e| @dprofilesets.push(e)} 
      n.capacity_profile_sets.each { |e| @cprofilesets.push(e)} 
      n.split_ratio_profile_sets.each { |e| @sprofilesets.push(e)} 
      n.event_sets.each { |e| @eventsets.push(e)  }
    }
 
    @csets.sort_by(&:name)  
    @dprofilesets.sort_by(&:name)  
    @cprofilesets.sort_by(&:name)  
    @sprofilesets.sort_by(&:name)  
    @eventsets.sort_by(&:name)  

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
  

  
  def get_network_dependent_table_items(sets,subitems,sid)
      sort_init 'name', 'asc'
      sort_update %w(name)
      case params[:format]
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit      
      else
        @limit = per_page_option
      end

      @items = Array.new
      Network.find(sid).send(sets).each { |cs|
         cs.send(subitems).each { |c|
           @items.push(c) 
         }   
      }
      @item_count = @items.length
      @items_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @items_pages.current.offset
      @items =  @items[@offset,@offset + @limit ]
     
      #@items = model.find  :all, :conditions => {:network_id => sid},
      #                          :order => sort_clause,
      #                           :limit  =>  @limit,
      #                           :offset =>  @offset
  end
  
  def get_set(sets,id)
    sets.each {|item| 
      if(item.id  == id)        
       return item 
      end
    }
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
  
  def get_index_view_sets(records)
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
    
    sort = sort_clause.split(' ')

    if(sort.length <= 1)
      records.sort_by{|item| sort[0]}
    else
      if(sort[1] == 'DESC')
        records.sort_by{|item| sort[0]}.reverse!
      end
    end
    
    @items_show = records[@offset,@offset + @limit ]

 
    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => records }
    end
  end
end
