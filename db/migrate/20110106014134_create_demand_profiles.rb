class CreateDemandProfiles < ActiveRecord::Migration
  def self.up
    create_table :demand_profiles do |t|
      t.integer :demand_profile_group_id
      t.integer :link_id
      t.decimal :dt
      t.string :profile

      t.timestamps
    end
  end

  def self.down
    drop_table :demand_profiles
  end
end
