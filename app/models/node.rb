class Node < ActiveRecord::Base
  has_many:intersections
  has_many:split_ratio_profiles  
  has_many:events
  has_many:controllers
    
  belongs_to:network
   
  
end
