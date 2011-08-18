class SimulationBatch < ActiveRecord::Base
  generator_for :name, :method => :next_name
  generator_for :number_of_runs, 2
  generator_for :mode, 'Simulation'
  generator_for :b_time, "00h 01m 00.1s"
  generator_for :duration, 24
  generator_for :control, true
  generator_for :qcontrol, false
  generator_for :events, true
  generator_for :start_time, Time.now 
  generator_for :execution_time, Time.now + 24
  generator_for :percent_complete, :method => :set_complete
  
  def self.next_name
    @name ||= 'Simulation Batch 0'
    @name.succ!
  end
  
  def self.set_complete
    @percent_complete = rand(2)   
  end
  
end
