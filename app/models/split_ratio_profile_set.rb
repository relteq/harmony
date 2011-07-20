class SplitRatioProfileSet < ActiveRecord::Base
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
    if(split_ratio_profiles.empty?)
      splits.each do |attributes|
        srp = SplitRatioProfile.find(attributes[:id].to_i)
        srp.attributes = attributes
      end
    else
      splits.each do |attributes|
        srp = split_ratio_profiles.detect { |s| s.id == attributes[:id].to_i }
        srp.attributes = attributes
      end
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
  
end
