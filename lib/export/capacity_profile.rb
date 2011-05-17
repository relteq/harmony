module Export
  module CapacityProfile 
    module InstanceMethods
      def build_xml(xml)
        attrs = {
          :link_id => link_id,
          :dt => dt
        }
      
        attrs[:start_time] = start_time if start_time > 0
        
        xml.event(attrs) do
          xml.text profile
        end
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
