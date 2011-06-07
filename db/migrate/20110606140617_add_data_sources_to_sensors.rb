class AddDataSourcesToSensors < ActiveRecord::Migration
  def self.up
    add_column :sensors, :data_sources, :text
  end

  def self.down
    remove_column :sensors, :data_sources
  end
end
