class AddDescriptionToMeasurementDatum < ActiveRecord::Migration
  def self.up
    add_column :measurement_data, :description, :string
  end

  def self.down
    remove_column :measurement_data, :description
  end
end
