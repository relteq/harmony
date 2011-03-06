class SplitRatioProfileSetsController < ApplicationController
 
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

    @split_ratio_profile_set_count = SplitRatioProfileSet.count(:conditions => "project_id = " + @project.id.to_s);
    @project_id = params[:project_id]
    @split_ratio_profile_sets_pages = Paginator.new self, @split_ratio_profile_set_count, @limit, params['page']
    @offset ||= @split_ratio_profile_sets_pages.current.offset
    @split_ratio_profile_sets_show = SplitRatioProfileSet.find     :all,
                              :conditions => "project_id = " + @project.id.to_s,
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml => @srprofilesets }
    end

  end
  
  # GET /split_ratio_profile_sets/new
  # GET /split_ratio_profile_sets/new.xml
  def new
   @srpset = SplitRatioProfileSet.new
   @srpset.name = params[:split_ratio_profile_set] != nil ? params[:split_ratio_profile_set][:name] ||= '' : '' 
   @prompt_network = {:prompt =>  @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}

   #set up split ratio profiles table to be empty until network selected
   get_splitratioprofiles("-1")

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @srpset }
   end
  end

  def edit
   @srpset = SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
   @prompt_network = {:prompt => @networks.empty? ?  l(:label_no_networks_configured) : l(:label_please_select)}
   @network = @srpset.network_id == nil ? nil : Network.find(@srpset.network_id) 

   #set up split_ratios table with split_ratio profile set network
   get_splitratioprofiles(@network == nil ? "-1" : @network.id.to_s)


   respond_to do |format|
     format.html # edit.html.erb
     format.xml  { render :xml => @srpset }
   end
  end

  def create
   @srpset = SplitRatioProfileSet.new(params[:split_ratio_profile_set])

   respond_to do |format|
     if(@srpset.save)
       save_splitratioprofiles
       flash[:notice] = l(:notice_successful_create)
     else
       flash[:error] = "The split ratio profile set, " + @srpset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'split_ratio_profile_sets', :action => 'edit',:project_id =>@project, :split_ratio_profile_set_id => @srpset }
     format.xml  { render :xml => @srpset, :status => :created, :location => @srpset }

   end
  end

  def update
   @srpset = SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
   @network = params[:split_ratio_profile_set][:network_id] == nil ? nil : Network.find(params[:split_ratio_profile_set][:network_id]) 
   respond_to do |format|
     if(@srpset.update_attributes(params[:split_ratio_profile_set]))
       save_splitratioprofiles
       flash[:notice] = l(:notice_successful_update)
     else
       flash[:error] = "The split ratio profile set, " + @srpset.name + ", was not not saved. See errors."
     end
     format.html { redirect_to  :controller => 'split_ratio_profile_sets', :action => 'edit',:project_id =>@project, :split_ratio_profile_set_id => @srpset }
     format.xml  { render :xml => @srpset, :status => :created, :location => @srpset }

   end
  end
  
  def populate_splits_table
    #I populate srpset so we can make sure to set checkboxes selected -- if there is no split ratio profile set id then 
    #you are creating a new split ratio profile set 
    @srpset = params[:split_ratio_profile_set_id].to_s == '' ? SplitRatioProfileSet.new : SplitRatioProfileSet.find(params[:split_ratio_profile_set_id])
    @sid = params[:split_ratio_profile_set][:network_id].to_s == '' ? "-1" : params[:split_ratio_profile_set][:network_id].to_s
    get_splitratioprofiles(@sid)
  end

  def get_splitratioprofiles(sid)
    sort_init 'name', 'asc'
    sort_update %w(name)
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

    @network = nil
    @item_count = SplitRatioProfile.count(:conditions => "network_id = " + sid);
    @items_pages = Paginator.new self, @item_count, @limit, params['page']

    @offset ||= @items_pages.current.offset

    @items = SplitRatioProfile.find :all,
                                :conditions => "network_id = " +sid,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset
  end

  def save_splitratioprofiles
    if( params[:split_ratio_profile_set][:split_ratio_profile_ids] != nil)
      params[:split_ratio_profile_set][:split_ratio_profile_ids].each do |id|
        @srprofile = SplitRaioProfile.find(id)
        @srprofile.profile = params[id]
        if(!@srprofile.save)
          flash[:error] = "The Split Ratio Profile Set," + @srpset.name + "is updated BUT the split ratio profile, " + @srprofile.name + ", was not not saved. See errors."     
        end
      end
    end
  end
end
