class CapacityProfileSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :network
  
  belongs_to:network

  
  has_many:capacity_profiles
  has_many:scenarios
  
  def remove_from_scenario
    #remove this capacity profile set from anything it is attached to
    @scen = Scenario.find_by_capacity_profile_set_id(id)
    if(@scen != nil)
      @scen.capacity_profile_set_id = nil
      @scen.save
    end
  end
end
