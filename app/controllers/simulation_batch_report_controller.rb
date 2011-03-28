class SimulationBatchReportController < ApplicationController
  
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
      @actions =  {'Share' => 'share','Export XML' => 'export','Export PDF' => 'pdf','Rename' => 'rename','Delete' => 'delete'}
      
      @project = Project.find_by_id(@project_id)
      @item_count = SimulationBatchReport.count(:all);
      @item_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @item_pages.current.offset
      @items_show = SimulationBatchReport.find  :all,
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml =>  @items_show}
      end
 end
end
