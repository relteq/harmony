class DemandProfileSet < ActiveRecord::Base
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
    if(demand_profiles.empty?)
      demands.each do |attributes|
        dp = DemandProfile.find(attributes[:id].to_i)
        dp.attributes = attributes
      end
    else
      demands.each do |attributes|
        dp = demand_profiles.detect { |d| d.id == attributes[:id].to_i }
        dp.attributes = attributes
      end
    end
  end
  
  def save_demands
    demand_profiles.each do |d|
      d.save(false)
    end
  end
  
end
