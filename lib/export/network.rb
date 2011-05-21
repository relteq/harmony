module Export
  module Network 
    module InstanceMethods 
      def build_xml(xml)
        attrs = { :id => id,
                  :name => name, 
                  :ml_control => ml_control,
                  :q_control => q_control,
                  :dt => dt
        }
        xml.network(attrs) {
          xml.description description unless !description || description.empty?
          xml.position {
            point_attrs = { :lat => latitude, :lng => longitude }
            point_attrs[:elevation] = elevation if elevation > 0
            xml.point(point_attrs)
          }
          lists = [ 
            ["NodeList", nodes],
            ["LinkList", links],
            #["NetworkList", subnetworks],
            ["SensorList", sensors]
          ]
  
          lists.each do |elt_name, models|
            if not models.empty?
              xml.send(elt_name) {
                models.each do |model|
                  model.build_xml(xml)
                end
              }     
            end
          end

          if not routes.empty?
            od_routes = Hash.new { |h,k| h[k] = [] }
            
            routes.each do |route|
              links_local = route.ordered_links
              od_routes[route.begin_and_end_node_ids] << [route, links_local]
            end

            xml.ODList {
              od_routes.each do |(begin_node_id, end_node_id), routes_with_links|
                xml.od(:begin => begin_node_id, :end => end_node_id) {
                  xml.PathList {
                    routes_with_links.each do |route, links_local|
                      xml.path(:name => route.name) {
                        xml.text links_local.map(&:id).join "," 
                      } 
                    end
                  }
                }
              end
            }
          end

          xml << intersection_cache
          xml << directions_cache 
        }
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
