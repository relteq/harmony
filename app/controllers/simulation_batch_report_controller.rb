class SimulationBatchReportController < ApplicationController
  helper :sort
  include SortHelper
  
  def index
      sort_init 'name', 'asc'
      sort_update %w(name created_at user_id_creator)

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
                    
      @item_count = SimulationBatchReport.count( :conditions => {:simulation_batch_list_id => SimulationBatchReport.get_simuation_batch_lists(@project),
                                                                 :percent_complete => 1,
                                                                 :succeeded => true});
      @item_pages = Paginator.new self, @item_count, @limit, params['page']
      @offset ||= @item_pages.current.offset
      @items_show = SimulationBatchReport.find  :all,
                                :conditions => {
                                   :simulation_batch_list_id => SimulationBatchReport.get_simuation_batch_lists(@project),
                                   :percent_complete => 1, 
                                   :succeeded => true},
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
       @simulation_report.link_to_simulation_batches(params[:sim_ids])
     
       Runweb.report @simulation_report
       
       flash[:notice] = 'Job started successfully.'  
       format.html { redirect_to  :my_page}
       format.xml  { head :ok }
     else
       format.html { render simulation_batch_index_path(params[:project_id])}
       format.api  { render_validation_errors(@simulation_report) }
     end
   end
 end
end
