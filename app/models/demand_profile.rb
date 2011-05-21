class DemandProfile < ActiveRecord::Base
  include Export::DemandProfile

  belongs_to :demand_profile_set
  belongs_to :link
end
