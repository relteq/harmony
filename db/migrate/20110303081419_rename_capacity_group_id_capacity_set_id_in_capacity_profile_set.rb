class RenameCapacityGroupIdCapacitySetIdInCapacityProfileSet < ActiveRecord::Migration
  def self.up
    rename_column :capacity_profiles, :capacity_profile_group_id, :capacity_profile_set_id
  end

  def self.down
    rename_column :capacity_profiles, :capacity_profile_set_id, :capacity_profile_group_id
  end

end
