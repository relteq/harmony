class CreateInitialConditionSets < ActiveRecord::Migration
  def self.up
    create_table :initial_condition_sets do |t|
      t.integer :network_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :initial_condition_sets
  end
end
