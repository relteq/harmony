class ReNameGroupsToSetsScenarios < ActiveRecord::Migration
  def self.up
    rename_column :scenarios, :split_ratio_profile_group_id, :split_ratio_profile_set_id
    rename_column :scenarios, :demand_profile_group_id, :demand_profile_set_id
    rename_column :scenarios, :capacity_profile_group_id, :capacity_profile_set_id
    add_column :scenarios, :event_set_id, :integer    
  end

  def self.down
    rename_column :scenarios, :split_ratio_profile_set_id, :split_ratio_profile_group_id
    rename_column :scenarios, :demand_profile_set_id, :demand_profile_group_id
    rename_column :scenarios, :capacity_profile_set_id, :capacity_profile_group_id
    remove_column :scenarios, :event_set_id
  end
end
