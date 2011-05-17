module Export
  module InitialCondition
    module InstanceMethods
      def build_xml(xml)
        xml.density(:link_id => link_id) do
          xml.text density
        end
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
