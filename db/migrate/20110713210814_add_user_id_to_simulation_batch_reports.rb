class AddUserIdToSimulationBatchReports < ActiveRecord::Migration
  def self.up
    add_column :simulation_batch_reports, :user_id_creator, :integer
    add_column :simulation_batch_reports, :user_id_modifier, :integer
  end

  def self.down
    remove_column :simulation_batch_reports, :user_id_modifier
    remove_column :simulation_batch_reports, :user_id_creator
  end
end
