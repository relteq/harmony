class SwitchToSimplifiedModelThree < ActiveRecord::Migration
  def self.up
    remove_column :capacity_profiles, :name
    remove_column :capacity_profiles, :network_id
    add_column :capacity_profiles, :start_time, :decimal
    add_column :capacity_profiles, :dt, :decimal

    remove_column :controllers, :name
    remove_column :controllers, :project_id
    
    remove_column :demand_profiles, :name
    remove_column :demand_profiles, :network_id
    add_column :demand_profiles, :start_time, :decimal
    add_column :demand_profiles, :dt, :decimal
    
    remove_column :events, :name
    
    add_column :input_links, :weaving_factors, :string
    add_column :input_links, :order, :integer
    
    add_column :links, :begin_node_id, :integer
    add_column :links, :end_node_id, :integer
    remove_column :links, :capacity
    remove_column :links, :v
    remove_column :links, :w
    remove_column :links, :jam_den
    remove_column :links, :cap_drop

    rename_table  :network_families, :network_lists
    
    rename_column :nodes, :geo_x, :latitude
    rename_column :nodes, :geo_y, :longitude
    rename_column :nodes, :geo_z, :elevation

    add_column :output_links, :order, :integer
    
    rename_column :scenarios, :e_time, :duration
    add_column :scenarios, :initial_condition_set_id, :integer
    remove_column :scenarios, :v_types
    
    rename_column :sensors, :geo_x, :latitude
    rename_column :sensors, :geo_y, :longitude
    rename_column :sensors, :geo_z, :elevation
    remove_column :sensors, :virtual
    add_column :sensors, :parameters, :binary
    
    remove_column :split_ratio_profiles, :name
    add_column :split_ratio_profiles, :start_time, :decimal
    
    
  end

  def self.down
    remove_column :capacity_profiles, :start_time
    remove_column :capacity_profiles, :dt
    add_column :capacity_profiles, :name, :string
    add_column :capacity_profiles, :network_id, :integer
    
    add_column :controllers, :name, :string
    add_column :controllers, :project_id, :integer
    
    add_column :demand_profiles, :name, :string
    add_column :demand_profiles, :network_id, :integer
    remove_column :demand_profiles, :start_time
    remove_column :demand_profiles, :dt
    
    add_column :events, :name, :string
    
    remove_column :input_links, :weaving_factors
    remove_column :input_links, :order
    
    remove_column :links, :begin_node_id
    remove_column :links, :end_node_id
    add_column :links, :capacity, :decimal
    add_column :links, :v, :decimal
    add_column :links, :w, :decimal
    add_column :links, :jam_den, :decimal
    add_column :links, :cap_drop, :decimal
    
    rename_table  :network_lists, :network_families
    
    rename_column :nodes, :latitude, :geo_x
    rename_column :nodes, :longitude, :geo_y
    rename_column :nodes, :elevation, :geo_z
    
    remove_column :output_links, :order
    
    rename_column :scenarios, :duration, :e_time
    remove_column :scenarios, :initial_condition_set_id
    add_column :scenarios, :v_types, :string
    
    add_column :split_ratio_profiles, :name, :string
    remove_column :split_ratio_profiles, :start_time
  end
end
