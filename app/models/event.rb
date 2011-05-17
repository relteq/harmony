class Event < ActiveRecord::Base
  include Export::Event
  belongs_to :event_set
end
