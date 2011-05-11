class ControllerSetsController <  ConfigurationsApplicationController
  before_filter :require_controller_set, :only => [:edit, :update, :destroy]

  def index
    get_index_view_sets(@csets)
  end

  def edit
    @cset = get_set(@csets,params[:id].to_i)
    set_up_network_select(@cset,Controller)
    get_network_dependent_table_items('controller_sets','controllers',@cset.network_id)   
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @cset }
    end
  end

  def update
    if(@cset.update_attributes(params[:controller_set]))
      redirect_save_success(:controller_set, edit_project_configuration_controller_set_path(@project, @cset))
    else
      redirect_save_error(:controller_set,:new,@cset,ControllerSet)
    end
  end

  def create  
    @cset = ControllerSet.new
    if(@cset.update_attributes(params[:controller_set]))
      redirect_save_success(:controller_set, edit_project_configuration_controller_set_path(@project, @cset))
    else
      redirect_save_error(:controller_set,:new,@cset,ControllerSet)
    end
  end

  # GET /controller_sets/new
  # GET /controller_sets/new.xml
  def new
    @cset = ControllerSet.new
    @cset.name = params[:controller_set] != nil ? params[:controller_set][:name] ||= '' : ''
    set_up_network_select(@cset,Controller)
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cset }
    end
  end

  # DELETE /controller_sets/1
  # DELETE /controller_sets/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @cset.remove_from_scenario
    @cset.destroy

    respond_to do |format|
      flash[:notice] = @cset.name + " successfully deleted."    
      format.html { redirect_to  :controller => 'controller_sets', :action => 'index',:project_id =>@project   }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    @project = Project.find(params[:project_id])
    @csets = @project.controller_sets.all
    
    @csets.each do | c |
      c.remove_from_scenario
      c.destroy
    end

    respond_to do |format|
      flash[:notice] = 'All controller sets have been successfully deleted.'  
      format.html { redirect_to  :controller => 'controller_sets', :action => 'index',:project_id =>@project  }
      format.xml  { head :ok }
    end
  end
  
  def populate_controls_table
    #I populate cset so we can make sure to set checkboxes selected -- if there is no controller set id then 
    #you are creating a new controller_set
    @cset = params[:controller_set_id].to_s == '' ? ControllerSet.new : get_set(@csets,params[:controller_set_id].to_i)
    if(params[:controller_set] != nil)
      @sid = params[:controller_set][:network_id].to_s == '' ? "-1" : params[:controller_set][:network_id].to_s
    else
      @sid = @cset.network_id.to_s
    end

    get_network_dependent_table_items('controller_sets','controllers',@sid)
  end

private
  def require_controller_set
    begin
      @cset = @csets.fetch(@csets.index {|e| e.id = params[:id]})
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, :project_id => @project
      flash[:error] = 'Controller Set not found.'
      return false
    end
  end
end
