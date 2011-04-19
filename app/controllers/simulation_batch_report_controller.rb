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
     

      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render :file => "#{Rails.root}/public/404.html", :status => 404
        return false
      end      
        
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
 
 def report_gen
   @simulation_report = SimulationBatchReport.new
   @simulation_batches = Array.new
   @scenarios = Array.new
   begin
     params[:sim_ids].each do |s|
       sb = SimulationBatch.find_by_id(s)
       @simulation_batches.push(sb)
       @scenarios.push(Scenario.find_by_id(sb.scenario_id))
     end
   rescue NoMethodError
     
   end
   
   respond_to do |format|
     format.html # report_gen.html.erb
   end
 
 end
end
