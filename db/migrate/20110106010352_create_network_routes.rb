class CreateNetworkRoutes < ActiveRecord::Migration
  def self.up
    create_table :network_routes do |t|
      t.integer :route_id
      t.integer :network_id

      t.timestamps
    end
  end

  def self.down
    drop_table :network_routes
  end
end
