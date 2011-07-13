class RemoveUserIdModifiedFromSimulationBatches < ActiveRecord::Migration
  def self.up
    remove_column :simulation_batches, :user_id_modifier
  end

  def self.down
    add_column :simulation_batches, :user_id_modifier, :integer
  end
end
