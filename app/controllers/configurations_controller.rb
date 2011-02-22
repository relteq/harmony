class ConfigurationsController < ApplicationController
  before_filter :populate_menu
 
 
  def show
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
  end

 
end
