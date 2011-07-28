class RenameMeasurementDatasToMeasurementData < ActiveRecord::Migration
  def self.up
      rename_table :measurement_datas, :measurement_data
  end 
  def self.down
      rename_table :measurement_data, :measurement_datas
  end

end
