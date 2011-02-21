class Network < ActiveRecord::Base
  has_many:controller_groups
  has_many:split_ratio_profile_groups
  has_many:capacity_profile_groups
  has_many:demand_profile_groups
  has_many:event_groups
  has_many:events
  has_many:controllers
  has_many:scenarios
  
  has_many:network_families, :foreign_key => "network_id", :class_name => "NetworkFamily"
  has_many:children, :through => :network_families  
  
  has_many:network_routes
  has_many:routes, :through => :network_routes
 
  has_many:network_nodes
  has_many:nodes, :through => :network_nodes
 
  has_many:network_links
  has_many:links, :through => :network_links
  
  has_many:output_links
  has_many:nodes, :through => :output_links
  has_many:links, :through => :output_links

  has_many:input_links
  has_many:nodes, :through => :input_links
  has_many:links, :through => :input_links

  has_many:sensor_locations
  has_many:sensors, :through => :sensor_locations
  has_many:links, :through => :sensor_locations
  
  def dt
    if(read_attribute("dt") != nil)
      Time.at(Time.gm(2000,1,1) + (read_attribute("dt") * 3600)).utc.strftime("%H:%M:%S").to_s
    else
      Time.at(Time.gm(2000,1,1) + (0.0 * 3600)).utc.strftime("%H:%M:%S").to_s
    end
  end
  
  def dt=(dt)
     write_attribute("dt",(Time.parse(dt).seconds_since_midnight.to_i / 3600.00))
     rescue ArgumentError
       @dt_invalid = true
  end
end
