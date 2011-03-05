class AddNameToSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profiles, :name, :string
  end

  def self.down
    remove_column :split_ratio_profiles, :name
  end
end
