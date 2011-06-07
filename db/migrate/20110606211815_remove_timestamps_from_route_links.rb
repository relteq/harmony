class RemoveTimestampsFromRouteLinks < ActiveRecord::Migration
  def self.up
    remove_column :route_links, :created_at
    remove_column :route_links, :updated_at
  end

  def self.down
    change_table :route_links do |t| t.timestamps end
  end
end
