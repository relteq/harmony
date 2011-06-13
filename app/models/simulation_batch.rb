class SimulationBatch < ActiveRecord::Base
  belongs_to :scenarios
  
  belongs_to :output_file
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
  def format_start_time
     start_time.strftime("%m/%d/%Y at %I:%M%p") if !(start_time.nil?)
  end
  
end
