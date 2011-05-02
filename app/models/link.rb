class Link < ActiveRecord::Base
  belongs_to:network

  belongs_to:begin_node_id, :class_name => "Node"
  belongs_to:end_node_id, :class_name => "Node"

  has_many:capacity_profiles
  has_many:demand_profiles
  has_many:events
  has_many:controllers
  
  has_many:route_links
  has_many:routes, :through => :route_links
    
  has_many:output_links
  has_many:nodes, :through => :output_links
  has_many:networks, :through => :output_links

  has_many:input_links
  has_many:nodes, :through => :input_links
  has_many:networks, :through => :input_links
  
  has_many:sensors
  
end
