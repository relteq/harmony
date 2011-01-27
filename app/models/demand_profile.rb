class DemandProfile < ActiveRecord::Base
  belongs_to:demand_profile_group
  belongs_to:link
end
