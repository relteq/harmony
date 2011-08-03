class ScatterGroup < ActiveRecord::Base
  belongs_to :simulation_batch_report
  belongs_to :simulation_batch
end
