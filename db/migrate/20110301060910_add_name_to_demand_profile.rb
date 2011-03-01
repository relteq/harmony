class AddNameToDemandProfile < ActiveRecord::Migration
  def self.up
    add_column :demand_profiles, :name, :string
    add_column :demand_profiles, :network_id, :integer
  end

  def self.down
    remove_column :demand_profiles, :network_id
    remove_column :demand_profiles, :name
  end
end
