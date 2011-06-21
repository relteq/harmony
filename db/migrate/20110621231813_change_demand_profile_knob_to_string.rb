class ChangeDemandProfileKnobToString < ActiveRecord::Migration
  def self.up
    change_column :demand_profiles, :knob, :string
  end

  def self.down
    change_column :demand_profiles, :knob, :float, :default => 0.0
  end
end
