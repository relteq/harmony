module Aurora
  class ControllerImporter < Controller
    include Aurora
    
    def self.create_from_xml ctrl_xml, ctx
      AuroraModelClassMethods::create_with_id(ctrl_xml["id"],self) do |ctrl|
        import_xml(ctrl_xml, ctx, ctrl)
        ctrl.controller_set = ctx.scenario.controller_set
        ctrl.save!
        ctrl
      end
    end
    
    def self.import_xml(ctrl_xml, ctx,ctrl)

      if /\S/ === ctrl_xml["network_id"]
        #@ctx.defer do
          ctrl.type = "NetworkController"
          ctrl.network_id = ctrl_xml["network_id"]
        #end        
      end

      if /\S/ === ctrl_xml["node_id"]
        # ctx.defer do
          ctrl.type = "NodeController"
          ctrl.node_id = ctrl_xml["node_id"]
        # end
      end

      if /\S/ === ctrl_xml["link_id"]
        # ctx.defer do
          ctrl.type = "LinkController"
          ctrl.link_id = ctrl_xml["link_id"]
        #  end
      end
      ctrl.controller_type = ctrl_xml["type"]
      ctrl.dt           = Float(ctrl_xml["dt"])
      ctrl.enabled  = Aurora::import_boolean(ctrl_xml["usesensors"], false)
      
      ## should we pull some of this out so it can be seen in rails?
      ctrl.parameters = ctrl_xml.xpath("*").map {|xml| xml.to_s}.join("\n")
      ctrl
    end
  end
end
