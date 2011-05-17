module Export
  module Scenario
    module InstanceMethods 
      def build_xml(xml)
        attrs = { :id => id }
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
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
