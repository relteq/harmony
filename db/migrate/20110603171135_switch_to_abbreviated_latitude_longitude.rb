class SwitchToAbbreviatedLatitudeLongitude < ActiveRecord::Migration
  def self.up
    rename_column :networks, :latitude, :lat
    rename_column :networks, :longitude, :lng
    rename_column :nodes, :latitude, :lat
    rename_column :nodes, :longitude, :lng
    rename_column :sensors, :latitude, :lat
    rename_column :sensors, :longitude, :lng
  end

  def self.down
    rename_column :networks, :lat, :latitude
    rename_column :networks, :lng, :longitude
    rename_column :nodes, :lat, :latitude
    rename_column :nodes, :lng, :longitude
    rename_column :sensors, :lat, :latitude
    rename_column :sensors, :lng, :longitude
  end
end
