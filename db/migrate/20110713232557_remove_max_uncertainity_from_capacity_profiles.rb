class RemoveMaxUncertainityFromCapacityProfiles < ActiveRecord::Migration
  def self.up
    remove_column :capacity_profiles, :max_uncertainty
  end

  def self.down
    add_column :capacity_profiles, :max_uncertainty, :decimal
  end
end
