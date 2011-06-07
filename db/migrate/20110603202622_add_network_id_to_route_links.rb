class AddNetworkIdToRouteLinks < ActiveRecord::Migration
  def self.up
    add_column :route_links, :network_id, :integer
  end

  def self.down
    drop_column :route_links, :network_id, :integer
  end
end
