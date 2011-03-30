class CreateSensorLocations < ActiveRecord::Migration
  def self.up
    create_table :sensor_locations do |t|
      t.integer :link_id
      t.integer :network_id
      t.integer :sensor_id
      t.decimal :r_offset

      t.timestamps
    end
  end

  def self.down
    drop_table :sensor_locations
  end
end
