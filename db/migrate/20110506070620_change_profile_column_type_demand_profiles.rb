class ChangeProfileColumnTypeDemandProfiles < ActiveRecord::Migration
  def self.up
    change_column :demand_profiles,:profile, :text
  end

  def self.down
    change_column :demand_profiles,:profile, :string
  end
end
