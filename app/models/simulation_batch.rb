class SimulationBatch < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  
  belongs_to :scenario
  
  has_many :output_files
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
  named_scope :incomplete, :conditions => ['percent_complete < 1']
  named_scope :complete, :conditions => ['percent_complete = 1']
 
  def mode
    'Run Simulation'
  end
end
