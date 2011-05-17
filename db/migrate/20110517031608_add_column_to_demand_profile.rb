class AddColumnToDemandProfile < ActiveRecord::Migration
  def self.up
    add_column :demand_profiles, :knob, :decimal
  end

  def self.down
    remove_column :demand_profiles, :knob
  end
end
