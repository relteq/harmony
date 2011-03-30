class RenameDemandProfileGroupToDemandProfileSet < ActiveRecord::Migration
  def self.up
    rename_table :demand_profile_groups, :demand_profile_sets
  end 
  def self.down
    rename_table :demand_profile_sets, :demand_profile_groups
  end
end
