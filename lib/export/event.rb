module Export
  module Event
    module InstanceMethods
      def build_xml(xml)
        attrs = {
          :type => self[:type],
          :enabled => enabled,
          :tstamp => time
        }
        
        case self.class
        when NetworkEvent 
          attrs[:network_id] = network_id
        when NodeEvent
          attrs[:node_id] = node_id
        when LinkEvent
          attrs[:link_id] = link_id
        end
        
        xml.event(attrs) do
          xml << parameters
        end
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
