module Export
  module InitialConditionSet 
    module InstanceMethods
      def build_xml(xml)
        attrs = { :id => id }
        attrs[:name] = name unless !name or name.empty?
      
        xml.InitialDensityProfile(attrs) {
          xml.description description unless !description or description.empty?
        
          initial_conditions.each do |ic|
            ic.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
