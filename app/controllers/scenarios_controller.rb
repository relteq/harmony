class ScenariosController < ApplicationController
  # GET /scenarios
  # GET /scenarios.xml
  def index
    @scenarios = Scenario.all
    @project_id = params[:project_id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
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
    @project = Project.find(params[:project_id])
    @scenario = Scenario.new
    @scenario.project_id = params[:project_id]
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

  # POST /scenarios
  # POST /scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.project_id = params[:project_id]
    respond_to do |format|
      if @scenario.save
        flash[:notice] = @scenario.name + ', was successfully created.'
        format.html { redirect_to project_scenarios_path(:project_id => params[:project_id]) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      if @scenario.update_attributes(params[:scenario])
        flash[:notice] = 'Scenario was successfully updated.'
        format.html { redirect_to project_scenarios_path(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @scenarios = @project.scenarios.find(params[:id])
   # @scenario.destroy

    respond_to do |format|
      flash[:notice] = 'Scenario successfully deleted.'    
      format.html {  redirect_to project_scenarios_path(@project)  }
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
      format.html { redirect_to project_scenarios_path(@project) }
      format.xml  { head :ok }
    end
  end
  
end
