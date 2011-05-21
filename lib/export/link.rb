module Export
  module Link 
    module InstanceMethods 
      def build_xml(xml)
        attrs = { 
          :id => id,
          :type => type_link,
          :name => name,
          :length => length,
          :lanes => lanes
        }

        xml.link(attrs) {
          xml.begin(:node_id => begin_node_id)
          xml.end(:node_id => end_node_id)
          xml.qmax { xml.text qmax }
          xml.dynamics(:type => 'CTM')
          xml << fd
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
