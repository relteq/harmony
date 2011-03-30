class AddNameToSimulationBatchList < ActiveRecord::Migration
  def self.up
    add_column :simulation_batch_lists, :name, :string
  end

  def self.down
    remove_column :simulation_batch_lists, :name
  end
end