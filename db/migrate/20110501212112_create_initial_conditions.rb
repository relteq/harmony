class CreateInitialConditions < ActiveRecord::Migration
  def self.up
    create_table :initial_conditions do |t|
      t.integer :initial_condition_set_id
      t.integer :link_id
      t.string :density

      t.timestamps
    end
  end

  def self.down
    drop_table :initial_conditions
  end
end
