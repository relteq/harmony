require 'network_importer'
require 'split_ratio_profile_set_importer'
require 'capacity_profile_set_importer'
require 'demand_profile_set_importer'
require 'initial_condition_set_importer'
require 'event_set_importer'
require 'controller_set_importer'
require 'context_importer'
require 'vehicle_type_importer'

require 'scenario'

module Aurora
  class ScenarioImporter < Scenario
    include Aurora
    
    def self.create_from_xml scenario_xml, project_id, ctx = nil
      #check to see if scenario exists
 
      AuroraModelClassMethods::create_with_id(scenario_xml["id"],self) do |scenario|  
       #scenario = Scenario.create do |scenario|
        prev_scenario_state = nil ## not sure this is needed anymore 
        #raise if prev_scenario ## for now, this mode is not handled
        scenario.project_id = project_id
        ctx ||= ImportContext.new scenario, prev_scenario_state
        import_xml scenario_xml, ctx,scenario
        scenario.save!
        scenario
      end
    
    end
    
    def self.import_xml scenario_xml, ctx,scenario
      Aurora::set_name_from scenario_xml["name"], ctx,scenario
      
      ###### TESTING FOR ONE FILE -- REMOVE
      if(AuroraModelClassMethods::am_testing)
        scenario.name = scenario.name + rand.to_s
      end
      
      descs = scenario_xml.xpath("description").map {|desc_xml| desc_xml.text}
      scenario.description = descs.join("\n")
      
      scenario_xml.xpath("settings/VehicleTypes/vtype").each do |vtype_xml|
      #  ctx.defer do
          scenario.vehicle_types.each do |vtype|
            vtype.destroy
          end
          VehicleTypeImporter.create_from_xml vtype_xml, ctx
      #  end
      end
      
      scenario_xml.xpath("settings/units").each do |units_xml|
       scenario.length_units = units_xml.text
      end
      
      scenario_xml.xpath("settings/display").each do |display_xml|
        scenario.dt = Float(display_xml["dt"])
        scenario.begin_time = Float(display_xml["timeInitial"] || 0.0)
        scenario.duration = Float(display_xml["timeMax"] || scenario.begin_time) - scenario.begin_time
      end

      scenario_xml.xpath("network").each do |network_xml|
        scenario.network = NetworkImporter.create_from_xml(network_xml, ctx)
      end
      
      scenario_xml.xpath("SplitRatioProfileSet").each do |srp_set_xml|
        scenario.split_ratio_profile_set = SplitRatioProfileSetImporter.create_from_xml(srp_set_xml, ctx)
      end

      scenario_xml.xpath("CapacityProfileSet").each do |cp_set_xml|
        scenario.capacity_profile_set = CapacityProfileSetImporter.create_from_xml(cp_set_xml, ctx)
      end

      scenario_xml.xpath("DemandProfileSet").each do |dp_set_xml|
        scenario.demand_profile_set = DemandProfileSetImporter.create_from_xml(dp_set_xml, ctx)
      end

      scenario_xml.xpath("InitialDensityProfile").each do |ic_set_xml|
        scenario.initial_condition_set = InitialConditionSetImporter.create_from_xml(ic_set_xml, ctx)
      end

      scenario_xml.xpath("EventSet").each do |event_set_xml|
         scenario.event_set = EventSetImporter.create_from_xml(event_set_xml, ctx)
      end

      scenario_xml.xpath("ControllerSet").each do |ctrl_set_xml|
       scenario.controller_set = ControllerSetImporter.create_from_xml(ctrl_set_xml, ctx)
      end

      ## what do we do if there are existing network, srp_set, vtypes,
      ## etc.? Delete them?
    end
  end
end
