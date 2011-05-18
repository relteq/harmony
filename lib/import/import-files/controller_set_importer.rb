module Aurora
  class ControllerSetImporter < ControllerSet
    include Aurora
    
    def self.create_from_xml ctrl_set_xml, ctx
      AuroraModelClassMethods::create_with_id(ctrl_set_xml["id"],self) do |ctrl_set|
         import_xml ctrl_set_xml, ctx,ctrl_set
         ctrl_set.network = ctx.scenario.network
         #save it to get id before loading controllers
         ctrl_set.save!
         ctrl_set
          # since we are creating a new ctrl set, let's assume the user wants
          # to edit it using the network in this scenario; that can be
          # changed later by the user.
       end

    end

    def self.import_xml ctrl_set_xml, ctx,ctrl_set
      Aurora::set_name_from ctrl_set_xml["name"], ctx, ctrl_set
      
      descs = ctrl_set_xml.xpath("description").map {|desc_xml| desc_xml.text}
      ctrl_set.description = descs.join("\n")
            
      ctrl_set_xml.xpath("controller").each do |ctrl_xml|
        #ctx.defer do
          ctrl_set.controllers.push(ControllerImporter.create_from_xml ctrl_xml, ctx)
        #end
      end
    end
  end
end
