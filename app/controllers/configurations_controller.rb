class ConfigurationsController < ApplicationController
  def show
    @scenarios = Scenario.all
    @project_id = params[:project_id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
  end

  before_filter :populate_menu

end
