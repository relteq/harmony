class AddNetworkIdToSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    add_column :split_ratio_profiles, :network_id, :integer
  end

  def self.down
    remove_column :split_ratio_profiles, :network_id
  end
end
