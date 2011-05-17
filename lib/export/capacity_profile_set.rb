module Export
  module CapacityProfileSet 
    module InstanceMethods
      def build_xml(xml)
        attrs = { :id => id }
        attrs[:name] = name unless !name or name.empty?
      
        xml.CapacityProfileSet(attrs) {
          xml.description description unless !description or description.empty?
        
          capacity_profiles.each do |cp|
            cp.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
