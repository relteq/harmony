class AddNameToMeasurementDatum < ActiveRecord::Migration
  def self.up
    add_column :measurement_data, :name, :string
  end

  def self.down
    remove_column :measurement_data, :name
  end
end
