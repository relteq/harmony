class CreateVehicleTypes < ActiveRecord::Migration
  def self.up
    create_table :vehicle_types do |t|
      t.integer :scenario_id
      t.string :name
      t.float :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_types
  end
end
