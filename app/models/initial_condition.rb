class InitialCondition < ActiveRecord::Base
  belongs_to:initial_condition_set
  belongs_to:link
end
