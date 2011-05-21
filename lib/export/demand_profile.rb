module Export
  module DemandProfile
    module InstanceMethods
      def build_xml(xml)
        attrs = { :link_id => link_id, 
                  :dt => dt,
        }
        attrs[:knob] = knob if knob
      
        xml.demand(attrs) {
          xml.text profile
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
