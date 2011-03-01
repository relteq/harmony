class AddNameToDemandProfileGroup < ActiveRecord::Migration
  def self.up
    add_column :demand_profile_groups, :name, :string
  end

  def self.down
    remove_column :demand_profile_groups, :name
  end
end
