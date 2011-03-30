class AddProjectIdToCapacityProfileGroup < ActiveRecord::Migration
  def self.up
    add_column :capacity_profile_groups, :project_id, :integer
  end

  def self.down
    remove_column :capacity_profile_groups, :project_id
  end
end
