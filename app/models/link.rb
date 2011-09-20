class Link < ActiveRecord::Base
  belongs_to :network

  belongs_to :begin, :class_name => "Node"
  belongs_to :end, :class_name => "Node"

  has_many :capacity_profiles
  has_many :demand_profiles
  has_many :events
  has_many :controllers
  
  has_many :route_links
  has_many :routes, :through => :route_links
  
  has_many :sensors
end
