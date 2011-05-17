class CapacityProfile < ActiveRecord::Base  
  include Export::CapacityProfile

  belongs_to :capacity_profile_set
  belongs_to :link
end
