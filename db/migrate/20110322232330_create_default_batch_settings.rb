class CreateDefaultBatchSettings < ActiveRecord::Migration
  def self.up
    create_table :default_batch_settings do |t|
      t.integer :scenaro_id
      t.string :name
      t.integer :number_of_runs
      t.string :mode
      t.decimal :b_time
      t.decimal :duration
      t.boolean :control
      t.boolean :qcontrol
      t.boolean :events

      t.timestamps
    end
  end

  def self.down
    drop_table :default_batch_settings
  end
end
