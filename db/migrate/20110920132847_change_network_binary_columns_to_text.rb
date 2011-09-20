class ChangeNetworkBinaryColumnsToText < ActiveRecord::Migration
  def self.up
    change_column :networks,:intersection_cache, :text
    change_column :networks,:directions_cache, :text
  end

  def self.down
    change_column :networks,:intersection_cache, :binary
    change_column :networks,:directions_cache, :binary
  end
end
