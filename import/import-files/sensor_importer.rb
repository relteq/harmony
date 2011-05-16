require 'sensor'


module Aurora
  class SensorImporter < Sensor
    include Aurora
    
    def self.create_from_xml sensor_xml, ctx
      AuroraModelClassMethods::create_with_id(sensor_xml["id"],self,ctx.scenario.network) do |sensor|
        import_xml(sensor_xml, ctx, sensor)
        sensor.save!
        sensor
      end
    end
    
    def self.import_xml sensor_xml, ctx
      descs = sensor_xml.xpath("description").map {|desc| desc.text}
      sensor.description = descs.join("\n")
      
      #sensor.offset     = ctx.import_length(sensor_xml["offset_in_link"] || 0)
      #sensor.length     = ctx.import_length(sensor_xml["length"] || 0)
      
      #if sensor_xml["postmile"]
     #    sensor.postmile = ctx.import_length(sensor_xml["postmile"])
    #  end
      
      sensor.type_sensor = sensor_xml["type"]
      sensor.link_type  = sensor_xml["link_type"]
   #   @sensor.data_id    = sensor_xml["data_id"]
      sensor.parameters = sensor_xml["parameters"]
  #    @sensor.vds        = sensor_xml["vds"]
   #   @sensor.hwy_name   = sensor_xml["hwy_name"]
   #   @sensor.hwy_dir    = sensor_xml["hwy_dir"]
  #    @sensor.lanes      = sensor_xml["lanes"]
      
      link_xml_ids = sensor_xml.xpath("links").text.split(",").map{|s|s.strip}
      link_xml_ids.each do |link_xml_id|
        if link
          raise "sensor table doesn't support multiple links per sensor"     
        end
        sensor.link_id = ctx.get_link_id(link_xml_id)
      end
      
      sensor.display_lat = Float(sensor_xml["display_lat"])
      sensor.display_lng = Float(sensor_xml["display_lng"])
      sensor.display_elev = Float(sensor_xml["display_elev"])

      sensor_xml.xpath("position/point").each do |point_xml|
        sensor.latitude = Float(point_xml["lat"])
        sensor.longitude = Float(point_xml["lng"])
        if point_xml["elevation"]
          sensor.elevation = Float(point_xml["elevation"])
        end
      end
    end
  end
end

