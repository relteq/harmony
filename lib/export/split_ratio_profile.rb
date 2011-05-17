module Export
  module SplitRatioProfile
    module InstanceMethods
      def build_xml(xml)
        attrs = { :node_id => node_id,
                  :dt => dt
        }
        attrs[:start_time] = start_time if start_time > 0
      
        xml.splitratios(attrs) {
          xml << profile
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
