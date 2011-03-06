class ScenariosController < ApplicationController
  menu_item :configurations  
  before_filter :populate_menu
  before_filter do |controller|
    controller.authorize(:configurations)
  end
  helper :sort
  include SortHelper
  
  
  # GET /scenarios
  # GET /scenarios.xml
  def index
    sort_init 'name', 'asc'
    sort_update %w(name updated_at)

    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end

    @scenario_count = @scenarios.count;
    @project_id = params[:project_id]
    @scenarios_pages = Paginator.new self, @scenario_count, @limit, params['page']
    @offset ||= @scenarios_pages.current.offset
    @scenarios_show = Scenario.find :all,
                                    :conditions => "project_id = " + @project.id.to_s,
                                    :order => sort_clause,
                                    :limit  =>  @limit,
                                    :offset =>  @offset

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
  #    format.xml  { render :xml => @scenarios }
    end
  end

  # GET /scenarios/1
  # GET /scenarios/1.xml
  def show
    @scenario = Scenario.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/new
  # GET /scenarios/new.xml
  def new
    @scenario = Scenario.new
    getSets()
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
    @scenario = (params[:scenario_id] != nil) ?  Scenario.find(params[:scenario_id]) :  Scenario.new
    getSets()
  
   
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # POST /scenarios
  # POST /scenarios.xml
  def create
    @project = Project.find(params[:project_id])
    @scenario = Scenario.new(params[:scenario])
    @scenario.project_id = @project.id

    respond_to do |format|
      if(@scenario.save)
        flash[:notice] = @scenario.name + ', was successfully created. You may configure the scenario below.'
        format.html { redirect_to  :controller => 'scenarios', :action => 'edit',:project_id =>@project, :scenario_id => @scenario }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
      else
        flash[:error] = "The scenario name, " + @scenario.name + ", already exists for this project. Please pick another."
        format.html { redirect_to  :controller => 'scenarios', :action => 'index', :project_id => @project }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
  
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    @scenario = Scenario.find(params[:scenario_id])

    respond_to do |format|
      if(@scenario.update_attributes(params[:scenario]))
        flash[:notice] = 'Scenario was successfully updated.'
   
        format.html { redirect_to  :controller => 'scenarios', :action => 'edit',:project_id =>@project, :scenario_id => @scenario  }
        format.xml  { head :ok }
      else
        format.html { redirect_to :controller => 'scenarios', :action => 'edit',:project_id =>@project, :scenario_id => @scenario }
        format.api  { render_validation_errors(@scenario) }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @scenario = @project.scenarios.find(params[:scenario_id])
    @scenario.destroy

    respond_to do |format|
      flash[:notice] = @scenario.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'scenarios', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @scenarios = @project.scenarios.all
    
    @scenarios.each do | s |
      s.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All scenarios have been successfully deleted.'  
      format.html { redirect_to  :controller => 'scenarios', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def getSets()
    @units = %w{miles feet kilometers meters}
    
    @prompt_network = (@networks == nil) ? {:prompt => 'Create a Network'} : {:prompt => 'Please Select'}
     
    @csets = Project.find(@project).controller_sets.sort_by(&:name)
    @prompt_controller = (@csets.empty?) ? {:prompt => 'Create a Controller Set'} : {:prompt => 'Please Select'}
    
    @dsets = Project.find(@project).demand_profile_sets.sort_by(&:name)
    @prompt_demand = (@dsets.empty?) ? {:prompt => 'Create a Demand Profile Set'} : {:prompt => 'Please Select'}

    @cpsets = Project.find(@project).capacity_profile_sets.sort_by(&:name)
    @prompt_capacity = (@cpsets.empty?) ? {:prompt => 'Create a Capacity Profile Set'} : {:prompt => 'Please Select'}
 
    @spsets = Project.find(@project).split_ratio_profile_sets.sort_by(&:name)
    @prompt_split = (@spsets.empty?) ? {:prompt => 'Create a Split Ratio Profile Set'} : {:prompt => 'Please Select'}

    @esets = Project.find(@project).event_sets.sort_by(&:name)
    @prompt_event = (@esets.empty?) ? {:prompt => 'Create an Event Set'} : {:prompt => 'Please Select'}
  end
end
