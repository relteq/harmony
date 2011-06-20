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
                                :conditions => {:percent_complete => 1},
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

      respond_to do |format|
        format.html { render :layout => !request.xhr? } # index.html.erb
        format.xml  { render :xml =>  @items_show}
      end
 end
 
 def update
   respond_to do |format|
     @simulation_report = SimulationBatchReport.new
 
     if(@simulation_report.update_attributes(params[:simulation_batch]))
       sbl = SimulationBatchList.new
       sbl.save!
       @simulation_report.simulation_batch_list_id = sbl.id
       @simulation_report.save!
       params[:sim_ids].each do |s|
         rb = ReportedBatch.new
         rb.simulation_batch_id = s
         rb.simulation_batch_list_id =  @simulation_report.simulation_batch_list_id
         rb.save!
       end
     
       Runweb.report @simulation_report.name, @simulation_report.to_xml
       
       flash[:notice] = 'Simulation Report was successfully sent. You should see updates as they become available.'  
       format.html { redirect_to  :my_page}
       format.xml  { head :ok }
     else
       format.html { render simulation_batch_index_path(params[:project_id])}
       format.api  { render_validation_errors(@simulation_report) }
     end
   end
 end
end
