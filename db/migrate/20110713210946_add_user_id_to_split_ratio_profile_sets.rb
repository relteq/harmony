class AddUserIdToSplitRatioProfileSets < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profile_sets, :user_id_creator, :integer
    add_column :split_ratio_profile_sets, :user_id_modifier, :integer
  end

  def self.down
    remove_column :split_ratio_profile_sets, :user_id_modifier
    remove_column :split_ratio_profile_sets, :user_id_creator
  end
end
