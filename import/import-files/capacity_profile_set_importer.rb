require 'capacity_profile_importer'
require 'capacity_profile_set'

module Aurora
  class CapacityProfileSetImporter < CapacityProfileSet
    include Aurora
    
    def self.create_from_xml cp_set_xml, ctx
       AuroraModelClassMethods::create_with_id(cp_set_xml["id"],self) do |cp_set|
         import_xml(cp_set_xml, ctx,cp_set)
         cp_set.network = ctx.scenario.network
         cp_set.save!
         cp_set

          # since we are creating a new cp set, let's assume the user wants
          # to edit it using the network in this scenario; that can be
          # changed later by the user.
       end
    end

    def self.import_xml cp_set_xml, ctx,cp_set
      Aurora::set_name_from cp_set_xml["name"], ctx,cp_set

      descs = cp_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      cp_set.description = descs.join("\n")
    
      cp_set_xml.xpath("capacity").each do |cp_xml|
        #ctx.defer do    
          cp_set.capacity_profiles.push(CapacityProfileImporter.create_from_xml cp_xml, ctx)
        #end
      end
    end
  end
end
