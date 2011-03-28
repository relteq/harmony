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
     
      @project_id = params[:project_id]
      @actions =  {'Generate Report' => 'report','Share' => 'share','Export XML' => 'export','Rename' => 'rename',' Delete' => 'delete'}
      
      @project = Project.find(@project_id)
      @item_count = SimulationBatch.count(:all );
      @item_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @item_pages.current.offset
      @items_show = SimulationBatch.find  :all,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml =>  @items_show}
      end
  end

  def show
    @item_show = SimulationBatch.find_by_id(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_show }
    end
  end
  

  
end
