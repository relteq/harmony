class CapacityProfile < ActiveRecord::Base
  belongs_to:capacity_profile_group
  belongs_to:link
end
