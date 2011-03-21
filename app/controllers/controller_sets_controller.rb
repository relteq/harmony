class ControllerSetsController < ConfigurationsController

  
  def index
    get_index_view(ControllerSet,@controller_sets)
  end

  def edit
    @cset = ControllerSet.find(params[:controller_set_id])
    set_up_network_select(@cset,Controller)
          
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @cset }
    end
    
  end

  def update
    @cset = ControllerSet.find(params[:controller_set_id])
    if(@cset.update_attributes(params[:controller_set]))
      redirect_save_success(:controller_set,{:controller => 'controller_sets', :action => 'edit',:project_id =>@project, :controller_set_id => @cset})
    else
      redirect_save_error(:controller_set,:new,@cset,ControllerSet)
    end
  end

  def create  
       @cset = ControllerSet.new(params[:controller_set])
       if(@cset.update_attributes(params[:controller_set]))
         redirect_save_success(:controller_set,{:controller => 'controller_sets', :action => 'edit',:project_id =>@project, :controller_set_id => @cset})
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
    @cset = @project.controller_sets.find(params[:controller_set_id])
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
    #I populate cset so we can make sure to set checkboxes selected -- if there is no controller group id then 
    #you are creating a new controller_set 
    @cset = params[:controller_set_id].to_s == '' ? ControllerSet.new : ControllerSet.find(params[:controller_set_id])
    if(params[:controller_set] != nil)
      @sid = params[:controller_set][:network_id].to_s == '' ? "-1" : params[:controller_set][:network_id].to_s
    else
      @sid = @cset.network_id.to_s
    end
    get_network_dependent_table_items(Controller,@sid)

  end
  
end
