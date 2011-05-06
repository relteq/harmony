class ControllerSet < ActiveRecord::Base
  
  validates_presence_of :network
  
  belongs_to :network
  
  has_many :controllers
  has_many :scenarios

  def remove_from_scenario
    #remove this controller set from anything it is attached to
    @scen = Scenario.find_by_controller_set_id(id)
    if(@scen != nil)
        @scen.controller_set_id = nil
        @scen.save
    end
  end
end
