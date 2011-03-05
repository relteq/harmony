class AddNameToInCapacityProfileSet < ActiveRecord::Migration
  def self.up
    add_column :capacity_profile_sets, :name, :string
  end

  def self.down
    remove_column :capacity_profile_sets, :name
  end
end
