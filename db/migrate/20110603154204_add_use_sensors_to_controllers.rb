class AddUseSensorsToControllers < ActiveRecord::Migration
  def self.up
    add_column :controllers, :use_sensors, :boolean
  end

  def self.down
    remove_column :controllers, :use_sensors
  end
end
