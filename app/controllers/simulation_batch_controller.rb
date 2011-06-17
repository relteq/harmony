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
                                :conditions => {:scenario_id => @project.scenarios, :percent_complete => 1},
                                :order => sort_clause,
                                :limit  =>  @limit,
                                :offset =>  @offset

       @items_show[1] = SimulationBatch.all[0]
       @items_show[1].id=   @items_show[1].id + 1
      #sets up objects for report_generator
      set_up_report_gen
      
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
      logger.debug redir_path
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
  

  private 
    def get_simulation_batch_action(str,sims)
      if(str == 'generate') 
        return report_gen_simulation_batch_report_path(@project,{:sim_ids => sims})
      else
        return ''
      end
    end
    
  private
    def set_up_report_gen
      @simulation_report = SimulationBatchReport.new

      #set up default values
      @simulation_report.network_perf = true
      @simulation_report.network_perf = true
      @simulation_report.route_perf_t = true
      @simulation_report.route_tt_t = true
      @simulation_report.route_perf_c = true
      @simulation_report.route_tt_c  = true

      #@simulation_batches = Array.new
      #@scenarios = Array.new
      # begin
      #    params[:sim_ids].each do |s|
      #      sb = SimulationBatch.find_by_id(s)
      #      @simulation_batches.push(sb)
      #      @scenarios.push(Scenario.find_by_id(sb.scenario_id))
      #    end
      #  rescue NoMethodError
      # 
      #  end

    end
  
end
