module Export
  module EventSet
    module InstanceMethods
      def build_xml(xml)
        attrs = { :id => id }
        attrs[:name] = name unless !name or name.empty?
      
        xml.EventSet(attrs) {
          xml.description description unless !description or description.empty?
        
          events.each do |event|
            event.build_xml(xml)
          end
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
