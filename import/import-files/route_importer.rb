require 'route'
require 'route_link'


module Aurora
  class RouteImporter < Route
    include Aurora
    
    def self.create_from_xml route_xml, ctx
      AuroraModelClassMethods::create_with_id(route_xml["id"],self,ctx.scenario.network)  do |route|
        import_xml(route_xml, ctx, route)
        route.network = ctx.scenario.network
        route.save!
        route
      end

    end
    
    def self.import_xml route_xml, ctx, route
      Aurora::set_name_from(route_xml["name"], ctx, route)
    
      # ctx.defer do # the route doesn't exist yet
         link_xml_ids = route_xml.text.split(",").map{|s|s.strip}
         link_xml_ids.each_with_index do |link_xml_id, order|

             route_link = RouteLink.new
             route_link.route_id = route.id
             route_link.link_id = ctx.get_link_id(link_xml_id)
             route_link.order = order
             route_link.save!
         end
      # end      
    end
  end
end
