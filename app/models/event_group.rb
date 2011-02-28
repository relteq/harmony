class EventGroup < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many :events
end
