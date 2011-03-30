class AddSimulationBatchIdToOutputFile < ActiveRecord::Migration
  def self.up
    add_column :output_files, :simulation_batch_id, :integer
    remove_column :output_files, :batch_id

  end

  def self.down
    remove_column :output_files, :simulation_batch_id
    add_column :output_files, :batch_id, :integer

  end
end
