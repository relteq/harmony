class CapacityProfileGroup < ActiveRecord::Base
  belongs_to:network
  
  has_many:capacity_profiles
  has_many:scenarios
  
end
