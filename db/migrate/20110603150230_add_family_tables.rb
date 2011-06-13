class AddFamilyTables < ActiveRecord::Migration
  def self.up
    create_table :link_families do |t| end
    create_table :node_families do |t| end
    create_table :network_families do |t| end
    create_table :route_families do |t| end
    create_table :sensor_families do |t| end
  end

  def self.down
    drop_table :link_families
    drop_table :node_families
    drop_table :network_families
    drop_table :route_families
    drop_table :sensor_families
  end
end
