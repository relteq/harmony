class Scenario < ActiveRecord::Base
  validates_presence_of :name,:description
  
  belongs_to:project
  belongs_to:network
  belongs_to:demand_profile_group
  belongs_to:capacity_profile_group
  belongs_to:split_ratio_profile_group
  
end
