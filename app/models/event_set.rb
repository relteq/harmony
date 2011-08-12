class EventSet < ActiveRecord::Base
  include RelteqUserStamps
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :network
  
  belongs_to :network
  
  has_many :events
  has_many :scenarios

  after_update :save_events

  def remove_from_scenario
    #remove this event from anything it is attached to
    @scen = Scenario.find_by_event_set_id(id)
    if(@scen != nil)
        @scen.event_set_id = nil
        @scen.save
    end  
  end
  
  def events=(items)
    events.drop(events.count)
    items.each do |attributes|
      events.push(attributes)
    end
  end
  
  def save_events
    events.each do |e|
      e.save(false)
    end
  end
 
  def self.delete_event(event)
    e = Event.find_by_id(event)
    e.destroy
  end 
  
  def self.delete_all(collection)
    collection.each do | item |
      item.remove_from_scenario
      item.destroy
    end
  end
   
end
