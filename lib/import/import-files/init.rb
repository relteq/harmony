topdir = File.expand_path("../../..", File.dirname(__FILE__))
modeldir = File.join(topdir, "app/models")
$LOAD_PATH.unshift modeldir

libdir = File.join(topdir, "lib")
$LOAD_PATH.unshift libdir

importdir = File.join(libdir, "import")
$LOAD_PATH.unshift importdir

importfilesdir = File.join(importdir, "import-files")
$LOAD_PATH.unshift importfilesdir



require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'nokogiri'
require 'open-uri'

Dir.glob(libdir + '/export/*') {|file| 
  if(!FileTest.directory?(file))
    require file
  end
}

require 'util-ar'
require 'relteq_time'
require 'scenario'
require 'initial_condition_set'
require 'initial_condition'
require 'demand_profile_set'
require 'demand_profile'
require 'capacity_profile_set'
require 'capacity_profile'
require 'split_ratio_profile_set'
require 'split_ratio_profile'
require 'controller_set'
require 'controller'
require 'link_controller'
require 'network_controller'
require 'node_controller'
require 'event_set'
require 'event'
require 'link_event'
require 'node_event'
require 'network_event'
require 'network'
require 'node'
require 'link'
require 'route'
require 'sensor'
require 'vehicle_type'
require 'route_link'

Dir.glob(importfilesdir + '/*') {|file| 
  if(!FileTest.directory?(file))
    require file
  end
}

################### HELPERS
def verify_import_tests(project_id,t)
  sum = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

  n = Network.find_all_by_project_id(project_id)
  t["networks"] = n.count.to_s
 
  n.each do |elem| 
    sum[0] = sum[0] + elem.nodes.count 
    sum[1] = sum[1] + elem.links.count 
    sum[2] = sum[2] + elem.sensors.count 
    sum[3] = sum[3] + elem.routes.count 
    elem.routes.each {|r| sum[4] = sum[4] + r.route_links.count }
    sum[5] = sum[5] + elem.demand_profile_sets.count
    sum[6] = sum[6] + elem.capacity_profile_sets.count
    sum[7] = sum[7] + elem.split_ratio_profile_sets.count
    sum[8] = sum[8] + elem.initial_condition_sets.count
    sum[9] = sum[9] + elem.controller_sets.count
    sum[10] = sum[10] + elem.event_sets.count
    elem.controller_sets.each {|cs| sum[11] = sum[11] + cs.controllers.count}
    elem.event_sets.each {|e| sum[12] = sum[12] + e.events.count}
    elem.demand_profile_sets.each { |s| sum[13] = sum[13] + s.demand_profiles.count}
    elem.capacity_profile_sets.each{ |s| sum[14] = sum[14] + s.capacity_profiles.count}
    elem.split_ratio_profile_sets.each{ |s| sum[15] = sum[15] + s.split_ratio_profiles.count}
    elem.initial_condition_sets.each{ |s| sum[16] = sum[16] + s.initial_conditions.count}      
  end 
  
  s = Scenario.find_all_by_project_id(project_id)
  t["scenario"] = s.count.to_s
  s.each {|scen| sum[17] = sum[17] + scen.vehicle_types.count}

  t["nodes"] = sum[0].to_s
  t["links"] = sum[1].to_s
  t["sensors"] = sum[2].to_s
  t["routes"] = sum[3].to_s    
  t["routelinks"] = sum[4].to_s
  t["demand_profile_sets"] = sum[5].to_s
  t["capacity_profile_sets"] = sum[6].to_s 
  t["split_ratio_profile_sets"] = sum[7].to_s
  t["initial_condition_sets"] = sum[8].to_s
  t["controller_sets"] = sum[9].to_s
  t["event_sets"] = sum[10].to_s
  t["controllers"] = sum[11].to_s
  t["events"] = sum[12].to_s
  t["demand_profiles"] = sum[13].to_s
  t["capacity_profiles"] = sum[14].to_s
  t["split_ratio_profiles"] = sum[15].to_s
  t["initial_conditions"] = sum[16].to_s
  
  t["vehicle types"] = sum[17]
  t   
end

def remove_dev_data
  Scenario.find(:all).each {|e| e.destroy}
  InitialConditionSet.find(:all).each {|e| e.destroy}
  InitialCondition.find(:all).each {|e| e.destroy}
  DemandProfileSet.find(:all).each {|e| e.destroy}
  DemandProfile.find(:all).each {|e| e.destroy}
  CapacityProfileSet.find(:all).each {|e| e.destroy}
  CapacityProfile.find(:all).each {|e| e.destroy}
  SplitRatioProfileSet.find(:all).each {|e| e.destroy}
  SplitRatioProfile.find(:all).each {|e| e.destroy}
  ControllerSet.find(:all).each {|e| e.destroy}
  LinkController.find(:all).each {|e| e.destroy}
  NetworkController.find(:all).each {|e| e.destroy}
  NodeController.find(:all).each {|e| e.destroy}
  EventSet.find(:all).each {|e| e.destroy}
  Event.find(:all).each {|e| e.destroy}
  Network.find(:all).each {|e| e.destroy}
  Node.find(:all).each {|e| e.destroy}
  Link.find(:all).each {|e| e.destroy}
  Route.find(:all).each {|e| e.destroy}
  Sensor.find(:all).each {|e| e.destroy}
  VehicleType.find(:all).each {|e| e.destroy}
  RouteLink.find(:all).each {|e| e.destroy}
end






