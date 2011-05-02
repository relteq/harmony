class Sensor < ActiveRecord::Base
  belongs_to:network
  belongs_to:link
end
