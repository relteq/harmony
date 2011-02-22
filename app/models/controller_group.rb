class ControllerGroup < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many:controllers
end
