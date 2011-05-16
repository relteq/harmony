require 'demand_profile_importer'
require 'demand_profile_set'

module Aurora
  class DemandProfileSetImporter < DemandProfileSet
    include Aurora
    
    def self.create_from_xml dp_set_xml, ctx
      AuroraModelClassMethods::create_with_id(dp_set_xml["id"], self) do |dp_set|
         import_xml(dp_set_xml, ctx, dp_set)
         dp_set.network = ctx.scenario.network
         #in order to deal with sets that have no idea and can therefore not be named I have to save in create_with_id
         #and then again once the name other relevant fields are set
         dp_set.save!
         dp_set  
         # since we are creating a new dp set, let's assume the user wants
         # to edit it using the network in this scenario; that can be
         # changed later by the user.
       end
 
       
       
      
    end

    def self.import_xml(dp_set_xml, ctx, dp_set)
    
      Aurora::set_name_from(dp_set_xml["name"], ctx, dp_set)

      descs = dp_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      dp_set.description = descs.join("\n")
      
      dp_set_xml.xpath("demand").each do |dp_xml|
        #ctx.defer do
          dp_set.demand_profiles.push(DemandProfileImporter.create_from_xml dp_xml, ctx)
        #end
      end
    end
  end
end
