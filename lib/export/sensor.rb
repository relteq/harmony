module Export
  module Sensor
    module InstanceMethods
      def build_xml(xml)
        attrs = { :type => type_sensor,
                  :link_type => link_type,
                  :id => id
        }
        xml.sensor(attrs) {
          xml.description description if description
          xml.links link_id
          xml << parameters
          xml.display_position {
            xml.point(:lat => display_lat, 
              :lng => display_lng, 
              :elevation => elevation
            )
          }
          xml.position {
            xml.point(:lat => latitude,
              :lng => longitude,
              :elevation => elevation
            )
          }
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end 
