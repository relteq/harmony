class AddNameToSplitRatioProfileSets < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profile_sets, :name, :string
  end

  def self.down
    remove_column :split_ratio_profile_sets, :name
  end
end
