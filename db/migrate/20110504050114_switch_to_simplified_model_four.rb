class SwitchToSimplifiedModelFour < ActiveRecord::Migration
  def self.up
    add_column :links, :begin_node_order, :integer
    add_column :links, :end_node_order, :integer
    add_column :links, :qmax, :decimal
    add_column :links, :fd, :string
    add_column :links, :weaving_factors, :string     # Applies to end node.
    add_column :links, :description, :string
    add_column :sensors, :description, :string
    rename_column :routes, :description, :name
    drop_table :input_links
    drop_table :output_links
  end

  def self.down
    remove_column :links, :begin_node_order
    remove_column :links, :end_node_order
    remove_column :links, :qmax
    remove_column :links, :fd
    remove_column :links, :description
    remove_column :links, :weaving_factors
    remove_column :sensors, :description
    rename_column :routes, :name, :description
  end
end

