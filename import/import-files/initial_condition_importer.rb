require 'initial_condition'

module Aurora
  # corresponds to <density> element
  class InitialConditionImporter <InitialCondition
    include Aurora
    
    def self.create_from_xml ic_xml, ctx
       AuroraModelClassMethods::create_with_id(ic_xml["id"],self) do |ic|
         import_xml(ic_xml, ctx, ic)
         ic.initial_condition_set = ctx.scenario.initial_condition_set
         ic
       end
    end
    
    def self.import_xml ic_xml, ctx, ic
      ic.link_id    = ctx.get_link_id(ic_xml["link_id"])
      ic.density    = ic_xml.text
    end
  end
end
