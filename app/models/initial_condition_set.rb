class InitialConditionSet < ActiveRecord::Base
  belongs_to:network
  
  has_many:initial_conditions
  has_many:scenarios
end
