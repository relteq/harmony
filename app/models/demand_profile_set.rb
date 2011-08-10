class DemandProfileSet < ActiveRecord::Base
  include RelteqUserStamps
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :network
  
  belongs_to :network
  
  has_many :demand_profiles
  has_many :scenarios
  
  after_update :save_demands

  def remove_from_scenario
    #remove this demand profile set from anything it is attached to
    @scen = Scenario.find_by_demand_profile_set_id(id)
    if(@scen != nil)
        @scen.demand_profile_set_id = nil
        @scen.save
    end
  end
  
  def demand_profiles=(demands)
    demand_profiles.drop(demand_profiles.count)
    demands.each do |attributes|
        dp = DemandProfile.find(attributes[:id].to_i)
        attributes.delete :id  #won't do mass assignment with id present
        dp.attributes = attributes
        dp.demand_profile_set_id = id
        demand_profiles.push(dp)
    end
  end
  
  def save_demands
    demand_profiles.each do |d|
      d.save(false)
    end
  end
 
  def self.delete_profile(demand)
    dp = DemandProfile.find_by_id(demand)
    dp.destroy
  end 
  
  def self.delete_all(collection)
    collection.each do | item |
      item.remove_from_scenario
      item.destroy
    end
  end
  
end
