class DropTimestampsFromNodesLinksRoutesSensors < ActiveRecord::Migration
  def self.up
    remove_column :nodes, :created_at
    remove_column :links, :created_at
    remove_column :routes, :created_at
    remove_column :sensors, :created_at

    remove_column :nodes, :updated_at
    remove_column :links, :updated_at
    remove_column :routes, :updated_at
    remove_column :sensors, :updated_at
  end

  def self.down
    [:nodes,:links,:routes,:sensors].each do |t|
      change_table do |table|
        table.timestamps
      end
    end
  end
end
