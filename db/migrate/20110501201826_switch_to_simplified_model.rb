class SwitchToSimplifiedModel < ActiveRecord::Migration
  def self.up
    drop_table :network_nodes
    drop_table :network_links
    drop_table :network_routes
    drop_table :sensor_locations

    add_column :links, :network_id, :integer
    add_column :nodes, :network_id, :integer
    add_column :routes, :network_id, :integer
    add_column :sensors, :network_id, :integer

  end

  def self.down

  end
end
