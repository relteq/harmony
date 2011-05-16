require 'split_ratio_profile'

module Aurora
  # corresponds to <splitratios> element, plus children <srm> elements
  class SplitRatioProfileImporter < SplitRatioProfile
    include Aurora
    
    def self.create_from_xml srp_xml, ctx
      AuroraModelClassMethods::create_with_id(srp_xml["id"],self) do |srp|
        import_xml(srp_xml, ctx, srp)
        srp.split_ratio_profile_set = ctx.scenario.split_ratio_profile_set
        srp.save!
        srp
      end
  
    end
    
    def self.import_xml(srp_xml, ctx, srp)
      srp.dt         = Float(srp_xml["dt"])
      srp.start_time = Float(srp_xml["start_time"] || 0)
      srp.node_id    = ctx.get_node_id(srp_xml["node_id"])
      
      srp.profile =
        srp_xml.xpath("srm").map {|srm_xml| srm_xml.to_s}.join("\n")
    end
  end
end
