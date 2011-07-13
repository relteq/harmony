class RemoveMaxUncertainityFromDemandProfiles < ActiveRecord::Migration
  def self.up
    remove_column :demand_profiles, :max_uncertainty
  end

  def self.down
    add_column :demand_profiles, :max_uncertainty, :decimal
  end
end
