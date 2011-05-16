require 'capacity_profile'

module Aurora
  # corresponds to <capacity> element
  class CapacityProfileImporter < CapacityProfile
    include Aurora
    
    def self.create_from_xml cp_xml, ctx
      AuroraModelClassMethods::create_with_id(cp_xml["id"],self) do |cp|
        import_xml(cp_xml, ctx, cp)
        cp.capacity_profile_set = ctx.scenario.capacity_profile_set
        cp.save!
        cp
      end
    end
    
    def self.import_xml cp_xml, ctx, cp
      cp.dt         = Float(cp_xml["dt"])
      cp.start_time = Float(cp_xml["start_time"] || 0)
      cp.link_id    = ctx.get_link_id(cp_xml["link_id"])
      cp.profile    = cp_xml.text
    end
  end
end
