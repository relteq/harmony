class AddUserIdToSimulationBatches < ActiveRecord::Migration
  def self.up
    add_column :simulation_batches, :user_id_creator, :integer
    add_column :simulation_batches, :user_id_modifier, :integer
  end

  def self.down
    remove_column :simulation_batches, :user_id_modifier
    remove_column :simulation_batches, :user_id_creator
  end
end
