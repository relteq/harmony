class EventSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :network
  
  belongs_to:network
  
  has_many :events
  has_many :scenarios
  
  
  def remove_from_scenario
    #remove this event from anything it is attached to
    @scen = Scenario.find_by_event_set_id(id)
    if(@scen != nil)
        @scen.event_set_id = nil
        @scen.save
    end  
  end
  
  
end
