class ControllerGroup < ActiveRecord::Base
  belongs_to:network
  
  has_many:controllers
end
