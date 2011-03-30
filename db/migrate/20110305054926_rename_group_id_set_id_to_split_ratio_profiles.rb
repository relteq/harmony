class RenameGroupIdSetIdToSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profiles, :split_ratio_profile_set_id, :integer
    remove_column :split_ratio_profiles, :split_ratio_profile_group_id

  end

  def self.down
    add_column :split_ratio_profiles, :split_ratio_profile_group_id, :integer
    remove_column :split_ratio_profiles, :split_ratio_profile_set_id
  end
end
