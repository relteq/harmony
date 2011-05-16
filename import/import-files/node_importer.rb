require 'node'


module Aurora
  class NodeImporter < Node
    include Aurora
    
    def self.create_from_xml node_xml, ctx
      AuroraModelClassMethods::create_with_id(node_xml["id"],self,ctx.scenario.network) do |node|
        import_xml node_xml, ctx, node
        node.network = ctx.scenario.network
        node.save!
        node
      end
      
    
    end
    
    def self.import_xml node_xml, ctx, node
      Aurora::set_name_from node_xml["name"], ctx, node
      node.type_node = node_xml["type"]
      
      descs = node_xml.xpath("description").map {|desc| desc.text}
      node.description = descs.join("\n")
      
      node_xml.xpath("position/point").each do |point_xml|
        node.latitude = Float(point_xml["lat"])
        node.longitude = Float(point_xml["lng"])
        if point_xml["elevation"]
          node.elevation = Float(point_xml["elevation"])
        end
      end
      
      # Note: we scan the NodeList section before the LinkList section,
      # so store these here for Link#import_xml to use later.
      node_xml.xpath("outputs/output").each_with_index do |xml, ord|
         ctx.begin_for_link_xml_id[ xml["link_id"] ] = [node, ord]
      end
      
      node_xml.xpath("inputs/input").each_with_index do |xml, ord|
        wf = xml.xpath("weavingfactors").map {|desc| desc.text}
        ctx.end_for_link_xml_id[ xml["link_id"] ] = [node, ord, wf[0]]
      end
    end
  end
end
