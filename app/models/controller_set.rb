class ControllerSet < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many:controllers
  has_many:scenarios
end
