class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios do |t|
      t.string :name
      t.string :description
      t.decimal :dt
      t.decimal :b_time
      t.decimal :e_time
      t.string :length_units
      t.string :v_types
      t.integer :project_id
      t.integer :network_id
      t.integer :demand_profile_group_id
      t.integer :capacity_profile_group_id
      t.integer :split_ratio_profile_group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scenarios
  end
end
