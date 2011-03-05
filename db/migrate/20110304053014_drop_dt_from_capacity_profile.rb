class DropDtFromCapacityProfile < ActiveRecord::Migration
  def self.up
    remove_column :capacity_profiles, :dt
  end

  def self.down
    add_column :capacity_profiles, :dt, :decimal
  end
end
