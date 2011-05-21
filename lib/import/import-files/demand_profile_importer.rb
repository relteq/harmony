module Aurora
  # corresponds to <demand> element
  class DemandProfileImporter < DemandProfile
    include Aurora
    
    def self.create_from_xml dp_xml, ctx
      AuroraModelClassMethods::create_with_id(dp_xml["id"],self) do |dp|
        import_xml dp_xml, ctx, dp
        dp.demand_profile_set = ctx.scenario.demand_profile_set
        dp.save!
        dp
      end
    end
    
    def self.import_xml dp_xml, ctx, dp
      dp.knob       = dp_xml["knob"].to_i || 1
      dp.dt         = Float(dp_xml["dt"])
      dp.start_time = Float(dp_xml["start_time"] || 0)
      dp.link_id    = ctx.get_link_id(dp_xml["link_id"])
      dp.profile    = dp_xml.text
    end
  end
end
