class AddNameToCapacityProfile < ActiveRecord::Migration
  def self.up
    add_column :capacity_profiles, :name, :string
  end

  def self.down
    remove_column :capacity_profiles, :name
  end
end
