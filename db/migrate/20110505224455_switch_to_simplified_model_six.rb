class SwitchToSimplifiedModelSix < ActiveRecord::Migration
  def self.up
    rename_column :scenarios, :b_time, :begin_time
  end

  def self.down
    rename_column :scenarios, :begin_time, :b_time
  end
end
