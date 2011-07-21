class SimulationBatchesController < ApplicationController
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
 
      @item_count = SimulationBatch.count( :conditions => {:scenario_id => @project.scenarios,
                                                           :percent_complete => 1,
                                                           :succeeded => true});
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
  
  def process_choices
   
      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render :file => "#{Rails.root}/public/404.html", :status => 404
        return false
      end
 
      redir_path =  get_simulation_batch_action(params[:simulation_batch_action],params[:sim_ids])

      respond_to do |format|
        if(redir_path != '' && (params[:sim_ids] != nil))
            #render redir_path
         format.html { redirect_to  redir_path}
        else
          if(redir_path == '')
            flash[:error] = "There was a problem processing your action, please try again."
          else 
            flash[:error] = "Please check a simulation batch below before requesting an action."
          end
          format.html { redirect_to  simulation_batch_index_path(@project) } # index.html.erb         
        end
      end
    
  end
  
  def delete_report
    begin
      sim_batch =  SimulationBatch.find(params[:id])
      sim_batch.destroy
      flash[:notice] = l(:similation_batch) + ", '" + sim_batch.name + "' " + l(:label_success_delete)  
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:similation_batch_not_found)
    rescue
      flash[:error] = l(:similation_batch_delete_not_success)
    end

    respond_to do |format|
      format.html { redirect_to project_simulation_batches_path(params[:project_id]) }
    end 
  end

  private 
    def get_simulation_batch_action(str,sims)
      if(str == 'generate') 
        return report_gen_simulation_batch_report_path(@project,{:sim_ids => sims})
      else
        return ''
      end
    end
    
  
end
