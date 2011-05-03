class AddLatLongElevToNetwork < ActiveRecord::Migration
  def self.up
    add_column :networks, :latitude, :decimal
    add_column :networks, :longitude, :decimal
    add_column :networks, :elevation, :decimal
  end

  def self.down
    remove_column :networks, :latitude
    remove_column :networks, :longitude
    remove_column :networks, :elevation
  end
end
