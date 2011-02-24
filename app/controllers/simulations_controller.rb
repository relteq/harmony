class SimulationsController < ApplicationController
  menu_item :simulation_data
  before_filter :populate_menu
  before_filter do |controller|
    controller.authorize(:simulation_data)
  end
  
  def index
    @simulations = Simulation.all_for_user(User.current.id)
  end
end
