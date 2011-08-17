class ControllerSet < ActiveRecord::Base
  include RelteqUserStamps
  validates_presence_of :network
  
  belongs_to :network
  
  has_many :controllers
  has_many :scenarios

  after_update :save_controllers
  
  def remove_from_scenario
    #remove this controller set from anything it is attached to
    @scen = Scenario.find_by_controller_set_id(id)
    if(@scen != nil)
        @scen.controller_set_id = nil
        @scen.save
    end
  end
  
  def controllers=(controls)
    controllers.drop(controllers.count)
    controls.each do |attributes|
      con = Controller.find(attributes[:id].to_i)
      attributes.delete :id  #won't do mass assignment with id present
      con.attributes = attributes
      con.controller_set_id = id
      controllers.push(con)
    end
  end
  
  def save_controllers
    controllers.each do |c|
      c.save(false)
    end
  end
 
  def self.delete_controller(control)
    con = Controller.find_by_id(control)
    con.destroy
  end 
  
  def self.delete_all(collection)
    collection.each do | item |
      item.remove_from_scenario
      item.destroy
    end
  end
  
  def delete_set
    remove_from_scenario
    destroy
  end
end
