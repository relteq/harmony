class SimulationBatchController < ApplicationController
  #before_filter do |controller|
  #  controller.authorize(:configurations)
  #end
  helper :sort
  include SortHelper
  
  def index
      sort_init 'name', 'asc'
      sort_update %w(name)

      case params[:format]
      when 'xml', 'json'
        @offset, @limit = api_offset_and_limit      
      else
        @limit = per_page_option
      end
     
     
      @actions =  {'Generate Report' => 'report','Share' => 'share','Export XML' => 'export','Rename' => 'rename',' Delete' => 'delete'}
      
      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render :file => "#{Rails.root}/public/404.html", :status => 404
        return false
      end
   
      @item_count = SimulationBatch.count( :conditions => {:scenario_id => @project.scenarios});
      @item_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @item_pages.current.offset
      @items_show = SimulationBatch.find  :all,
                                :conditions => {:scenario_id => @project.scenarios},
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml =>  @items_show}
      end
  end
  
  
end
