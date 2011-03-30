class AddMaxUncertaintyToCapacityProfile < ActiveRecord::Migration
  def self.up
    add_column :capacity_profiles, :max_uncertainty, :decimal
  end

  def self.down
    remove_column :capacity_profiles, :max_uncertainty
  end
end
