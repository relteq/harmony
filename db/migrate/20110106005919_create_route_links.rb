class CreateRouteLinks < ActiveRecord::Migration
  def self.up
    create_table :route_links do |t|
      t.integer :route_id
      t.integer :link_id
      t.integer :order

      t.timestamps
    end
  end

  def self.down
    drop_table :route_links
  end
end
