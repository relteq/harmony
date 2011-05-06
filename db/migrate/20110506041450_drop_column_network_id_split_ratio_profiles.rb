class DropColumnNetworkIdSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    remove_column :split_ratio_profiles, :network_id
  end

  def self.down
    add_column :split_ratio_profiles, :network_id, :integer
  end
end
