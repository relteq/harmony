class AddProjectIdToSplitRatioProfileGroup < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profile_groups, :project_id, :integer
  end

  def self.down
    remove_column :split_ratio_profile_groups, :project_id
  end
end
