module Export
  module Node
    module InstanceMethods
      def build_xml(xml)
        xml.node(:id => id, :name => name, :type => type_node) {
          xml.description description unless !description or description.empty?

          xml.outputs {
            output_links.each { |link| xml.output(:link_id => link.id) }
          }

          xml.inputs {
            input_links.each do |link| 
              xml.input(:link_id => link.id) {
                xml.weavingfactors link.weaving_factors if link.weaving_factors
              }
            end
          }

          xml.position {
            xml.point(:lat => latitude, 
                      :lng => longitude, 
                      :elevation => elevation
            )
          }
        } 
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
