module Aurora
  class EventSetImporter < EventSet
    include Aurora
    
    def self.create_from_xml event_set_xml, ctx
      AuroraModelClassMethods::create_with_id(event_set_xml["id"],self) do |event_set|
         import_xml event_set_xml, ctx, event_set
         event_set.network = ctx.scenario.network
         event_set.save!
         event_set
          # since we are creating a new event set, let's assume the user wants
          # to edit it using the network in this scenario; that can be
          # changed later by the user.
      end
    end

    def self.import_xml event_set_xml, ctx,event_set
      Aurora::set_name_from event_set_xml["name"], ctx,event_set

      descs = event_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      event_set.description = descs.join("\n")
      
      event_set_xml.xpath("event").each do |event_xml|
        #ctx.defer do
         event_set.events.push(EventImporter.create_from_xml event_xml, ctx)
        #end
      end
    end
  end
end
