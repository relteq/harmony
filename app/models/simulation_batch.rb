class SimulationBatch < ActiveRecord::Base
  belongs_to :scenarios
  
  belongs_to :output_file
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
end
