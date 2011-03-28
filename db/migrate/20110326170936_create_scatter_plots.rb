class CreateScatterPlots < ActiveRecord::Migration
  def self.up
    create_table :scatter_plots do |t|
      t.integer :simulation_batch_report_id
      t.enum :x_axis_type
      t.enum :x_axis_scope
      t.enum :y_axis_type
      t.enum :y_axis_scope

      t.timestamps
    end
  end

  def self.down
    drop_table :scatter_plots
  end
end
