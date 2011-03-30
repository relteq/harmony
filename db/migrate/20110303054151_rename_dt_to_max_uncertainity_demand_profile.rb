class RenameDtToMaxUncertainityDemandProfile < ActiveRecord::Migration
  def self.up
    rename_column :demand_profiles, :dt, :max_uncertainty
  end

  def self.down
    rename_column :demand_profiles, :max_uncertainty, :dt
  end
end
