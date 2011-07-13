class RemoveUserIdModifiedFromSimulationBatchReports < ActiveRecord::Migration
  def self.up
    remove_column :simulation_batch_reports, :user_id_modifier
  end

  def self.down
    add_column :simulation_batch_reports, :user_id_modifier, :integer
  end
end
