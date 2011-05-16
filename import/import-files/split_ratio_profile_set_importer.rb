require 'split_ratio_profile_importer'
require 'split_ratio_profile_set'

module Aurora
  class SplitRatioProfileSetImporter < SplitRatioProfileSet
    include Aurora
    
    def self.create_from_xml srp_set_xml, ctx
      AuroraModelClassMethods::create_with_id(srp_set_xml["id"],self) do |srp_set|
               import_xml srp_set_xml, ctx,srp_set
               srp_set.network = ctx.scenario.network
               srp_set.save!
               srp_set
               # since we are creating a new srp set, let's assume the user wants
               # to edit it using the network in this scenario; that can be
               # changed later by the user.
           end
    end

    def self.import_xml srp_set_xml, ctx,srp_set
      Aurora::set_name_from srp_set_xml["name"], ctx,srp_set

      descs = srp_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      srp_set.description = descs.join("\n")
      
      srp_set_xml.xpath("splitratios").each do |srp_xml|
        #ctx.defer do
          srp_set.split_ratio_profiles.push(SplitRatioProfileImporter.create_from_xml srp_xml, ctx)
        #end
      end
    end
  end
end
