class AddUrlUserSpecifiedToMeasurementDatum < ActiveRecord::Migration
  def self.up
    add_column :measurement_data, :url_user_specified, :string
  end

  def self.down
    remove_column :measurement_data, :url_user_specified
  end
end
