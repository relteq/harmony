class SplitRatioProfileSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :network
  
  belongs_to :network
  
  has_many :split_ratio_profiles
  has_many :scenarios
  
  def remove_from_scenario
    #remove this split ratio from anything it is attached to
    @scen = Scenario.find_by_split_ratio_profile_set_id(id)
    if(@scen != nil)
      @scen.split_ratio_profile_set_id = nil
      @scen.save
    end
  end
  
  def format_updated_at
    updated_at.strftime("%m/%d/%Y") if !(updated_at.nil?)
  end
end
