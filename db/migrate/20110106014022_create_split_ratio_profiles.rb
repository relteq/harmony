class CreateSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    create_table :split_ratio_profiles do |t|
      t.integer :split_ratio_profile_group_id
      t.integer :node_id
      t.decimal :dt
      t.string :profile

      t.timestamps
    end
  end

  def self.down
    drop_table :split_ratio_profiles
  end
end
