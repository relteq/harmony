class CapacityProfileSet < ActiveRecord::Base
  include RelteqUserStamps
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :network
  
  belongs_to :network

  has_many :capacity_profiles
  has_many :scenarios
  
  after_update :save_capacities
  
  def remove_from_scenario
    #remove this capacity profile set from anything it is attached to
    @scen = Scenario.find_by_capacity_profile_set_id(id)
    if(@scen != nil)
      @scen.capacity_profile_set_id = nil
      @scen.save
    end
  end
  
  def capacity_profiles=(capacities)
     if(capacity_profiles.empty?)
       capacities.each do |attributes|
         cp = CapacityProfile.find(attributes[:id].to_i)
         cp.attributes = attributes
       end
     else
       capacities.each do |attributes|
         cp = capacity_profiles.detect { |c| c.id == attributes[:id].to_i }
         cp.attributes = attributes
       end
     end
   end

   def save_capacities
     capacity_profiles.each do |c|
       c.save(false)
     end
   end

   def self.delete_profile(capacity)
     cp = CapacityProfile.find_by_id(capacity)
     cp.destroy
   end
   
   
   def self.delete_all(collection)
     collection.each do | item |
       item.remove_from_scenario
       item.destroy
     end
   end
end
