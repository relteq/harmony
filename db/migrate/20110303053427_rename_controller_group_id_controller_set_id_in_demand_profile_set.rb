class RenameControllerGroupIdControllerSetIdInDemandProfileSet < ActiveRecord::Migration
  def self.up
    rename_column :demand_profiles, :demand_profile_group_id, :demand_profile_set_id
  end

  def self.down
    rename_column :demand_profiles, :demand_profile_set_id, :demand_profile_group_id
  end
end
