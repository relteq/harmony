class CreateReportedBatches < ActiveRecord::Migration
  def self.up
    create_table :reported_batches do |t|
      t.integer :simulation_batch_id
      t.integer :simulation_batch_list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reported_batches
  end
end
