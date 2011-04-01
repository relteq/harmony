class CreateSensors < ActiveRecord::Migration
  def self.up
    create_table :sensors do |t|
      t.string :type_sensor
      t.string :link_type
      t.boolean :measurement
      t.boolean :virtual
      t.decimal :geo_x
      t.decimal :geo_y
      t.decimal :geo_z

      t.timestamps
    end
  end

  def self.down
    drop_table :sensors
  end
end
