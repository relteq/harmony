class Node < ActiveRecord::Base
  has_many:intersections
  has_many:split_ratio_profiles  
  has_many:events
  has_many:controllers
    
  belongs_to:network
   
  has_many:output_links
  has_many:networks, :through => :output_links
  has_many:links, :through => :output_links

  has_many:input_links
  has_many:networks, :through => :input_links
  has_many:links, :through => :input_links
  
end
