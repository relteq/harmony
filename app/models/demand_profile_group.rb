class DemandProfileGroup < ActiveRecord::Base
  belongs_to:network
  
  has_many:demand_profiles
  has_many:scenarios
  
end
