class SimulationBatch < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  
  belongs_to :scenario
  
  has_many :output_files
  
  has_many :reported_batches
  has_many :simulation_batch_lists, :through => :reported_batches
  
  named_scope :incomplete, :conditions => ['percent_complete < 1 OR (NOT succeeded)']
  named_scope :complete, :conditions => ['percent_complete = 1 AND succeeded']

    
  def self.save_batch(params)
    s = SimulationBatch.new
    s.name = params[:name]
    s.duration = RelteqTime.parse_time_to_seconds(params[:duration])
    s.b_time = RelteqTime.parse_time_to_seconds(params[:begin_time])
    s.control = params[:control]
    s.qcontrol = params[:qcontrol]
    s.events = params[:events]
    s.scenario_id = params[:scenario_id]
    s.mode = params[:mode]
    s.number_of_runs = params[:n_runs].to_i
    s.save  
  end
  
  def project
    scenario.project
  end
end
