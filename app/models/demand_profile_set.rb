class DemandProfileSet < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many:demand_profiles
  has_many:scenarios
  
end
