class InitialCondition < ActiveRecord::Base
  include Export::InitialCondition

  belongs_to :initial_condition_set
  belongs_to :link
end
