class ChangeProfileColumnTypeSplitRatioProfiles < ActiveRecord::Migration
  def self.up
    change_column :split_ratio_profiles,:profile, :text
  end

  def self.down
    change_column :split_ratio_profiles,:profile, :string
  end
end
