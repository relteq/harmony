class InitialConditionSet < ActiveRecord::Base
  include Export::InitialConditionSet

  belongs_to :network
  
  has_many :initial_conditions
  has_many :scenarios
end
