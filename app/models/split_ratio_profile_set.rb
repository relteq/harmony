class SplitRatioProfileSet < ActiveRecord::Base
  include RelteqUserStamps
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :network
  
  belongs_to :network
  
  has_many :split_ratio_profiles
  has_many :scenarios
  after_update :save_splits
  
  def remove_from_scenario
    #remove this split ratio from anything it is attached to
    @scen = Scenario.find_by_split_ratio_profile_set_id(id)
    if(@scen != nil)
      @scen.split_ratio_profile_set_id = nil
      @scen.save
    end
  end
  
  def split_ratio_profiles=(splits)
    split_ratio_profiles.drop(split_ratio_profiles.count) # you need to drop them all in case network changed on update
    splits.each do |attributes|
        srp = SplitRatioProfile.find(attributes[:id].to_i)
        attributes.delete :id  #won't do mass assignment with id present
        srp.attributes = attributes
        srp.profile =  to_xml(srp.profile)
        srp.split_ratio_profile_set_id = id
        split_ratio_profiles.push(srp)
    end
  end
  
  def save_splits
    split_ratio_profiles.each do |sr|
      sr.save(false)
    end
  end
 
  def self.delete_profile(split)
    srp = SplitRatioProfile.find_by_id(split)
    srp.destroy
  end
  
  
  def self.delete_all(collection)
    collection.each do | item |
      item.remove_from_scenario
      item.destroy
    end
  end
  
  def to_xml(profile)
    items = Array.new
    profile.split("\n").each do |entry|
      entry.insert(0,"<srm>")
      entry = entry + "</srm>"
      items.push(entry)
    end
    return items.to_s
  end
end
