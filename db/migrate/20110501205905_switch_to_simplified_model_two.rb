class SwitchToSimplifiedModelTwo < ActiveRecord::Migration
  def self.up
    remove_column :event_sets,:project_id
    remove_column :demand_profile_sets,:project_id
    remove_column :capacity_profile_sets,:project_id
    remove_column :split_ratio_profile_sets,:project_id
    remove_column :controller_sets,:project_id
  end

  def self.down
    add_column :event_sets,:project_id,:integer
    add_column :demand_profile_sets,:project_id,:integer
    add_column :capacity_profile_sets,:project_id,:integer
    add_column :split_ratio_profile_sets,:project_id,:integer
    add_column :controller_sets,:project_id,:integer
  end
end
