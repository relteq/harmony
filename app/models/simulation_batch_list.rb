class SimulationBatchList < ActiveRecord::Base
  has_many :simulation_batch_reports
  
  has_many :reported_batches
  has_many :simulation_batches, :through => :reported_batches
  
end
