class AddProjectIdToDemandProfileGroup < ActiveRecord::Migration
  def self.up
    add_column :demand_profile_groups, :project_id, :integer
  end

  def self.down
    remove_column :demand_profile_groups, :project_id
  end
end
