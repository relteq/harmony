class CreateSimulationBatches < ActiveRecord::Migration
  def self.up
    create_table :simulation_batches do |t|
      t.integer :scenario_id
      t.string :name
      t.integer :number_of_runs
      t.string :mode
      t.decimal :b_time
      t.decimal :duration
      t.boolean :control
      t.boolean :qcontrol
      t.boolean :events
      t.datetime :start_time
      t.decimal :execution_time
      t.integer :percent_complete
      t.binary  :cpu_instance

      t.timestamps
    end
  end

  def self.down
    drop_table :simulation_batches
  end
end

