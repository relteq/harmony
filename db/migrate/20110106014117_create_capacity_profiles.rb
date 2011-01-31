class CreateCapacityProfiles < ActiveRecord::Migration
  def self.up
    create_table :capacity_profiles do |t|
      t.integer :capacity_profile_group_id
      t.integer :link_id
      t.decimal :dt
      t.string :profile

      t.timestamps
    end
  end

  def self.down
    drop_table :capacity_profiles
  end
end
