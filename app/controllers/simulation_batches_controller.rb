class SimulationBatchesController < ApplicationController
  helper :sort
  include SortHelper
  
  before_filter :require_project, :only => [:index,:create,:update]
  
  def index
    sort_init 'name', 'asc'
    sort_update %w(name created_at user_id_creator)

    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

    @item_count = SimulationBatch.count(:conditions => {
      :scenario_id => @project.scenarios,
      :percent_complete => 1,
      :succeeded => true
    })

    @item_pages = Paginator.new self, @item_count, @limit, params['page']
    @offset ||= @item_pages.current.offset
    @items_show = SimulationBatch.find  :all,
                              :conditions => {:scenario_id => @project.scenarios, 
                                              :percent_complete => 1,
                                              :succeeded => true},
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

    #sets up objects for report_generator
    @simulation_report = SimulationBatchReport.new
    @simulation_report.default_report_settings!
    
    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml =>  @items_show}
    end
  end

  def show
    @simulation_batch = SimulationBatch.find(params[:id])

    respond_to do |format|
      format.api { render :show }
    end
  end
    
  def destroy
    begin
      sim_batch =  SimulationBatch.find(params[:id])
      sim_batch.destroy
      flash[:notice] = l(:simulation_batch) + ", '" + sim_batch.name + "' " + l(:label_success_delete)  
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:simulation_batch_not_found)
    rescue
      flash[:error] = l(:simulation_batch_delete_not_success)
    end

    respond_to do |format|
      format.html { redirect_to (params[:redirect] || project_simulation_batches_path(params[:project_id])) }
    end 
  end

  def update
    begin
      SimulationBatch.find(params[:id]).update_attributes(params[:simulation_batch])
      flash[:notice] = l(:notice_successful_update) 
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:simulation_batch_not_found)  
    rescue
      flash[:error] = l(:notice_update_not_successful)
    end
    
    respond_to do |format|
     format.html { redirect_to  project_simulation_batches_path(params[:project_id]) } # index.html.erb     
    end
  end
  
    
  private
    def require_project
      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render_404
        return false
      end
    end
end
