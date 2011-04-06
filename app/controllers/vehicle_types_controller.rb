class VehicleTypesController < ConfigurationsApplicationController 
  before_filter :require_scenario

  def new
    @vehicle_type = @scenario.vehicle_types.build
  end

  def create
    @vehicle_type = @scenario.vehicle_types.create(params[:vehicle_type])

    if @vehicle_type.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Vehicle Type created successfully.'
          redirect_to edit_project_configuration_scenario_path(@project, @scenario)
        end
        format.json { render :json => {:success => true, 
                                       :display => @vehicle_type.short_display, 
                                       :id => @vehicle_type.id}}
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => {:success => false,
                                       :errors => @vehicle_type.errors.full_messages}}
      end
    end
  end

  def destroy
    @vehicle_type = @scenario.vehicle_types.find(params[:id])
    if @scenario.vehicle_types.count > 1
      @success = !!@vehicle_type.destroy
    else
      @error_message = 'Cannot delete only vehicle type from scenario.'
    end
    respond_to do |format|
      format.html do 
        flash[:error] = @error_message
        redirect_to edit_project_configuration_scenario_path(@project, @scenario) 
      end
      format.json { render :json => {:success => @success,
                                     :error_message => @error_message}}
    end
  end

private
  def require_scenario
    begin
      @scenario = @project.scenarios.find(params[:scenario_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Scenario not found.'
      return false
    end
  end
end
