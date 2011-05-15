class ModifyColumnsLinksNetworks < ActiveRecord::Migration
  def self.up
    remove_column :links,:geo_cache
    add_column :networks,:intersection_cache,:binary
    add_column :networks,:directions_cache,:binary
  end

  def self.down
    add_column :links,:geo_cache,:binary
    remove_column :networks,:intersection_cache
    remove_column :networks,:directions_cache
  end
end
