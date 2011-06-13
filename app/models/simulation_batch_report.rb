class SimulationBatchReport < ActiveRecord::Base
  has_many :simulation_batch_lists
  
  belongs_to :scatter_plot
  belongs_to :color_pallette
  
  def format_creation_time
     creation_time.strftime("%m/%d/%Y at %I:%M%p") if !(creation_time.nil?)
  end
end
