class MakeScenarioBeginEndTimesDecimal < ActiveRecord::Migration
  def self.up
    change_table :scenarios do |t|
      t.change :begin_time, :decimal, :precision => 8, :scale => 1
      t.change :duration, :decimal, :precision => 8, :scale => 1
      t.change :dt, :decimal, :precision => 8, :scale => 1
    end
  end

  def self.down
    change_table :scenarios do |t|
      t.change_column :begin_time, :decimal
      t.change_column :duration, :decimal
      t.change_column :dt, :decimal
    end
  end
end
