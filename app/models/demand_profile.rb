class DemandProfile < ActiveRecord::Base
  belongs_to:demand_profile_set
  belongs_to:link

end
