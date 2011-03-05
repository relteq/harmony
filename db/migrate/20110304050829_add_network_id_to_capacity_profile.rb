class AddNetworkIdToCapacityProfile < ActiveRecord::Migration
  def self.up
    add_column :capacity_profiles, :network_id, :integer
  end

  def self.down
    remove_column :capacity_profiles, :network_id
  end
end
