module Export
  module Controller 
    module InstanceMethods 
      def build_xml(xml)
        attrs = { :type => controller_type,
                  :dt => dt,
                  #:usesensors => use_sensors 
                  # Should Controller.use_sensors exist? It currently does not.
        }

        case self.class
        when LinkController
          attrs[:link_id] = link_id
        when NetworkController
          attrs[:controller_id] = controller_id
        when NodeController
          attrs[:node_id] = node_id
        end
        
        xml.controller(attrs) {
          xml << parameters
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
