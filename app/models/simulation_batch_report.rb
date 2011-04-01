class SimulationBatchReport < ActiveRecord::Base
  has_many :simulation_batch_lists
  
  belongs_to :scatter_plot
  belongs_to :color_pallette
  
end
