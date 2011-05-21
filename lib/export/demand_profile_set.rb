module Export
  module DemandProfileSet
    module InstanceMethods
      def build_xml(xml)
        attrs = { :id => id }
        
        xml.DemandProfileSet(attrs) {
          xml.description description unless !description or description.empty?
        
          demand_profiles.each do |profile|
            profile.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
