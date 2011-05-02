class Route < ActiveRecord::Base
  belongs_to:network
    
  has_many:route_links
  has_many:links, :through => :route_links
  
end
