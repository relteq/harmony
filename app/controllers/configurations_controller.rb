class ConfigurationsController < ConfigurationsApplicationController
  def show
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
  end
end
