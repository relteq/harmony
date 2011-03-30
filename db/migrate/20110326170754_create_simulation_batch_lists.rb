class CreateSimulationBatchLists < ActiveRecord::Migration
  def self.up
    create_table :simulation_batch_lists do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :simulation_batch_lists
  end
end
