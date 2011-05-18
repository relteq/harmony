module Aurora
  class VehicleTypeImporter < VehicleType
    def self.create_from_xml vtype_xml, ctx
      self.create do |vtype|
        vtype.scenario = ctx.scenario
        import_xml vtype_xml, ctx,vtype
      end
    end

    def self.import_xml vtype_xml, ctx, vtype
      vtype.name   = vtype_xml["name"]
      vtype.weight = Float(vtype_xml["weight"])
    end
  end
end
