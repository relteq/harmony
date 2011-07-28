class AddRoadNameLaneOffsetToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :road_name, :string, :default => ""
    add_column :links, :lane_offset, :decimal, :default => 0
  end

  def self.down
    remove_column :links, :road_name
    remove_column :links, :lane_offset
  end
end
