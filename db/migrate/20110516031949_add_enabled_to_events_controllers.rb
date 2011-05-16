class AddEnabledToEventsControllers < ActiveRecord::Migration
  def self.up
    add_column :events, :enabled, :boolean
    add_column :controllers, :enabled, :boolean
    add_column :sensors, :display_lat, :decimal
    add_column :sensors, :display_lng, :decimal
    add_column :sensors, :display_elev, :decimal
  end

  def self.down
    remove_column :events, :enabled
    remove_column :controllers, :enabled
  end
end
