module Aurora
  class LinkImporter < Link
    include Aurora
    
    def self.create_from_xml link_xml, ctx
      AuroraModelClassMethods::create_with_id(link_xml["id"],self,ctx.scenario.network) do |link|
         import_xml(link_xml, ctx, link)
         link.network = ctx.scenario.network
          #in order to deal with sets that have no idea and can therefore not be named I have to save in create_with_id
          #and then again once the name other relevant fields are set
          link.save!
          link
      end
    end
    
    def self.import_xml link_xml, ctx, link
     Aurora::set_name_from(link_xml["name"], ctx, link)

      descs = link_xml.xpath("description").map {|desc| desc.text}
      link.description = descs.join("\n")
      
      link.lanes = Float(link_xml["lanes"]) # Fractional lanes allowed.s
      link.length = ctx.import_length(link_xml["length"])
      link.type_link = link_xml["type"]
      
      link_xml.xpath("fd").each do |fd_xml|
        # just store the xml in the column for now
        link.fd = fd_xml.to_s
      end
      link_xml.xpath("qmax").each do |qmax_xml|
        link.qmax = Float(qmax_xml.text)
      end

      #SMM -- I don't think these are needed -- it is dealt with below
      #begin_id_xml  = link_xml.xpath("begin").first["node_id"]
      #end_id_xml    = link_xml.xpath("end").first["node_id"]

      link.begin_node = ctx.begin_for_link_xml_id[link_xml["id"]][0]
      link.begin_node_order = ctx.begin_for_link_xml_id[link_xml["id"]][1]
      link.end_node = ctx.end_for_link_xml_id[link_xml["id"]][0]
      link.end_node_order = ctx.end_for_link_xml_id[link_xml["id"]][1]
      link.weaving_factors = ctx.end_for_link_xml_id[link_xml["id"]][2]
  
    end
  end
end
