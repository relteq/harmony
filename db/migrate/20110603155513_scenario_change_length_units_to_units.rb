class ScenarioChangeLengthUnitsToUnits < ActiveRecord::Migration
  def self.up
    rename_column :scenarios, :length_units, :units
  end

  def self.down
    rename_column :scenarios, :units, :length_units
  end
end
