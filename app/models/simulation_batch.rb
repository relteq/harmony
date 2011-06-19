class SimulationBatch < ActiveRecord::Base
  belongs_to :scenario
  
  has_many :output_files
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
  def format_start_time
    start_time.strftime("%m/%d/%Y at %I:%M%p") if !(start_time.nil?)
  end
end
