class CreateCapacityProfileGroups < ActiveRecord::Migration
  def self.up
    create_table :capacity_profile_groups do |t|
      t.integer :network_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :capacity_profile_groups
  end
end
