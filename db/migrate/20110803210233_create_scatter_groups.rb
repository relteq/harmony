class CreateScatterGroups < ActiveRecord::Migration
  def self.up
    create_table :scatter_groups do |t|
      t.integer :simulation_batch_id
      t.integer :simulation_batch_report_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :scatter_groups
  end
end
