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
    if(events.empty?)
      items.each do |attributes|
        #e = Event.find(attributes[:id].to_i)
        #e.attributes = attributes
      end
    else
      items.each do |attributes|
        e = events.detect { |ev| ev.id == attributes[:id].to_i }
        e.attributes = attributes
      end
    end
  end
  
  def save_events
    events.each do |e|
      e.save(false)
    end
  end
 
  def self.delete_set(event)
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
