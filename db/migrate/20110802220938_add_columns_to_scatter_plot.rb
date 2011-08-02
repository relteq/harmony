class AddColumnsToScatterPlot < ActiveRecord::Migration
  def self.up
    add_column :scatter_plots, :x_axis_type, :string
    add_column :scatter_plots, :x_axis_scope, :string
    add_column :scatter_plots, :y_axis_type, :string
    add_column :scatter_plots, :y_axis_scope, :string
    add_column :scatter_plots, :box_plot, :boolean
  end

  def self.down
    remove_column :scatter_plots, :box_plot
    remove_column :scatter_plots, :y_axis_scope
    remove_column :scatter_plots, :y_axis_type
    remove_column :scatter_plots, :x_axis_scope
    remove_column :scatter_plots, :x_axis_type
  end
end
