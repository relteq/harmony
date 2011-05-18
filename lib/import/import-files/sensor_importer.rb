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
    
    def self.import_xml sensor_xml, ctx, sensor
      descs = sensor_xml.xpath("description").map {|desc| desc.text}
      sensor.description = descs.join("\n")
      sensor.type_sensor = sensor_xml["type"]
      sensor.link_type  = sensor_xml["link_type"]
      sensor.parameters = sensor_xml.xpath("parameters").xpath("*").map {|xml| xml.to_s}.join("\n")
      sensor.parameters += sensor_xml.xpath("data_sources").xpath("*").map {|xml| xml.to_s}.join("\n")

      
      link_xml_ids = sensor_xml.xpath("links").text.split(",").map{|s|s.strip}
      link_xml_ids.each do |link_xml_id|
       # if link
      #    raise "sensor table doesn't support multiple links per sensor"     
       # end
        sensor.link_id = ctx.get_link_id(link_xml_id)
      end
      
      sensor_xml.xpath("display_position/point").each do |display_point_xml|
        sensor.display_lat = Float(display_point_xml["lat"])
        sensor.display_lng = Float(display_point_xml["lng"])
        if(display_point_xml["elevation"] &&  display_point_xml["elevation"] != "")
          sensor.display_elev = Float(display_point_xml["elevation"])
        end
      end
      
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

