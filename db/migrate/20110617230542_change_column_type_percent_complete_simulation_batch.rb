class ChangeColumnTypePercentCompleteSimulationBatch < ActiveRecord::Migration
  def self.up
    change_column :simulation_batches,:percent_complete,:decimal
  end

  def self.down
    change_column :simulation_batches,:percent_complete,:integer
  end
end
