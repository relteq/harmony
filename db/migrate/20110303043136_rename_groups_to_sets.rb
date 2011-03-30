class RenameGroupsToSets < ActiveRecord::Migration
  def self.up
     rename_table :controller_groups, :controller_sets
     rename_table :capacity_profile_groups, :capacity_profile_sets
     rename_table :split_ratio_profile_groups, :split_ratio_profile_sets
     rename_table :event_groups, :event_sets

  end

  def self.down
    rename_table :controller_sets, :controller_groups
    rename_table :capacity_profile_sets, :capacity_profile_groups
    rename_table :split_ratio_profile_sets, :split_ratio_profile_groups
    rename_table :event_sets, :event_groups
  end
end
