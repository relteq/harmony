module Aurora
  # corresponds to <InitialDensityProfile> element
  class InitialConditionSetImporter < InitialConditionSet
    include Aurora
    
    def self.create_from_xml ic_set_xml, ctx
       AuroraModelClassMethods::create_with_id(ic_set_xml["id"],self) do |ic_set|
         import_xml ic_set_xml, ctx, ic_set
         ic_set.network = ctx.scenario.network
         #save it to get id before loading initial conditions
         ic_set.save!
         ic_set
          # since we are creating a new ic set, let's assume the user wants
          # to edit it using the network in this scenario; that can be
          # changed later by the user.
       end
    end

    def self.import_xml ic_set_xml, ctx,ic_set
      Aurora::set_name_from ic_set_xml["name"], ctx,ic_set

      descs = ic_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      ic_set.description = descs.join("\n")
      
      ic_set_xml.xpath("density").each do |ic_xml|
      #  ctx.defer do
          ic_set.initial_conditions.push(InitialConditionImporter.create_from_xml ic_xml, ctx)
      #  end
      end
    end
  end
end
