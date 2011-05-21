class Sensor < ActiveRecord::Base
  include Export::Sensor

  belongs_to :network
  belongs_to :link
end
