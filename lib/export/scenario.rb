module Export
  module Scenario
    module InstanceMethods 
      def build_xml(xml)
        attrs = { :id => id, :schemaVersion => '1.0.2' }
        attrs[:name] = name
        xml.scenario(attrs) {
          xml.description description unless !description || description.empty?
          xml.settings {
            xml.units length_units
            xml.display_(:dt => dt,
                         :timeInitial => begin_time,
                         :timeMax => begin_time + duration)
            xml.VehicleTypes {
              vehicle_types.each do |v|
                xml.vtype(:name => v.name, :weight => v.weight)
              end
            }
          }

          parts = [controller_set, event_set, split_ratio_profile_set,
                   capacity_profile_set, initial_condition_set]
          parts.each do |part|
            part.build_xml(xml) if part
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
