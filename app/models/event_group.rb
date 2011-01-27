class EventGroup < ActiveRecord::Base
  belongs_to :network
  
  has_many :events
end
