class ControllerSet < ActiveRecord::Base
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
    if(controllers.empty?)
      controls.each do |attributes|
        con = Controller.find(attributes[:id].to_i)
        con.attributes = attributes
      end
    else
      controls.each do |attributes|
        con = controllers.detect { |c| c.id == attributes[:id].to_i }
        con.attributes = attributes
      end
    end
  end
  
  def save_controllers
    controllers.each do |c|
      c.save(false)
    end
  end
 
  def self.delete_set(control)
    con = Controller.find_by_id(control)
    con.destroy
  end 
  
end
