class CapacityProfileGroup < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many:capacity_profiles
  has_many:scenarios
  
end
