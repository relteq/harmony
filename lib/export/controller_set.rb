module Export
  module ControllerSet 
    module InstanceMethods 
      def build_xml(xml)
        attrs = { :id => id }
        attrs[:name] = name unless !name or name.empty?
  
        xml.ControllerSet(attrs) {
          xml.description description unless !description || description.empty?
          
          controllers.each do |c|
            c.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
