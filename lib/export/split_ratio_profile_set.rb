module Export
  module SplitRatioProfileSet 
    module InstanceMethods
      def build_xml(xml)
        attrs = { :id => id }
        attrs[:name] = name unless !name or name.empty?
      
        xml.SplitRatioProfileSet(attrs) {
          xml.description description unless !description or description.empty?
        
          split_ratio_profiles.each do |srp|
            srp.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
