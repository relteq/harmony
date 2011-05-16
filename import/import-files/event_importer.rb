require 'event'
require 'link_event'
require 'network_event'
require 'node_event'


module Aurora
  class EventImporter < Event
    include Aurora
    
    def self.create_from_xml event_xml, ctx
      AuroraModelClassMethods::create_with_id(event_xml["id"],self) do |event|
        import_xml(event_xml, ctx, event)
        event.event_set = ctx.scenario.event_set
        event.save!
        event
      end
    end
    
    def self.import_xml event_xml, ctx,event
      
      if /\S/ === event_xml["network_id"]
        #ctx.defer do
          event.type = "NetworkEvent"
          event.network_id = event_xml["network_id"]
        #end
      end

      if /\S/ === event_xml["node_id"]
        # ctx.defer do
          event.type = "NodeEvent"
          event.node_id = event_xml["node_id"]
        #end
      end

      if /\S/ === event_xml["link_id"]
        # ctx.defer do
          event.type = "LinkEvent"
          event.link_id = event_xml["link_id"]
        # end
        
      end
      event.event_type     = event_xml["type"]
      event.time     = Float(event_xml["tstamp"])
      event.enabled  = Aurora::import_boolean(event_xml["enabled"])
      
      ## should we pull some of this out, like description, so it can be
      ## seen in rails?
      event.parameters = event_xml.xpath("*").map {|xml| xml.to_s}.join("\n")
      event
    end
  end
end
