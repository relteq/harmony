class SimulationBatch < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  
  belongs_to :scenario
  
  has_many :output_files
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
  
    
end
