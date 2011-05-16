require 'node_importer'
require 'link_importer'
require 'route_importer'
require 'sensor_importer'
require 'network'

module Aurora
  class NetworkImporter < Network
    include Aurora
    
    def self.create_from_xml network_xml, ctx
       AuroraModelClassMethods::create_with_id(network_xml["id"],self) do |network|    
        import_xml(network_xml, ctx,network)
        network.project_id = ctx.scenario.project_id
        network.save!
        network
      end
    end
    
    def self.import_xml network_xml, ctx, network
      Aurora::set_name_from(network_xml["name"], ctx,network)
      
      ###### TESTING FOR ONE FILE -- REMOVE
      network.name = network.name + rand.to_s
      descs = network_xml.xpath("description").map {|desc| desc.text}
      network.description = descs.join("\n")

      network.dt           = Float(network_xml["dt"])
      network.ml_control   = Aurora::import_boolean(network_xml["ml_control"])
      network.q_control    = Aurora::import_boolean(network_xml["q_control"])

      network_xml.xpath("position/point").each do |point_xml|
        network.latitude = Float(point_xml["lat"])
        network.longitude = Float(point_xml["lng"])
        if point_xml["elevation"]
          network.elevation = Float(point_xml["elevation"])
        end
      end

      network.directions_cache =  network_xml.xpath("DirectionsCache").xpath("*").map {|xml| xml.to_s}.join("\n")
      network.intersection_cache = network_xml.xpath("IntersectionCache").xpath("*").map {|xml| xml.to_s}.join("\n")

      #if this network already exists in the db then before we import the nodes, links, routes,
      #and sensors for the network we need to delete all the current ones
     
      if(AuroraModelClassMethods::record_exists)
        remove_links_nodes_routes_sensors(network)
      end
      # ctx.defer do
            [
              ["NodeList/node", NodeImporter],
              ["LinkList/link", LinkImporter],
              ["NetworkList/network", NetworkImporter],
              ["ODList/od/PathList/path", RouteImporter],
              ["SensorList/sensor", SensorImporter]
            ].
            each do |elt_xpath, elt_class,elt_array|
              network_xml.xpath(elt_xpath).each do |elt_xml|
                elem = elt_class.create_from_xml(elt_xml, ctx)
                elem.network_id = network.id
                elem.save
              end
            end
      #    end
 
    end
    
    def self.remove_links_nodes_routes_sensors(network)
   
      network.nodes.each {|elem| elem.destroy}
      network.sensors.each {|elem| elem.destroy}
      network.routes.each {|elem| elem.destroy}
      network.links.each {|elem| elem.destroy}
    end
    
  end
end
