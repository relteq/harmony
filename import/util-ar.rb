def create_table? t, db = DB, &bl
  db.table_exists? t or db.create_table t, &bl
end

module Aurora
  module_function
  
  UNITS             = %w{ US Metric }
  NODE_TYPES        = %w{ F H S P O T }
  LINK_TYPES        = %w{ FW HW HOV HOT HV ETC OR FR IC ST D }
  SENSOR_TYPES      = %w{ loop radar camera sensys }
  SENSOR_LINK_TYPES = %w{ ML HV OR FR }
  EVENT_TYPES       = %w{ FD DEMAND QLIM SRM WFM SCONTROL NCONTROL CCONTROL
                          TCONTROL MONITOR }
  CONTROLLER_TYPES  = %w{ ALINEA TOD TR VSLTOD SIMPLESIGNAL PRETIMED ACTUADED
                          SYNCHRONIZED SWARM HERO SLAVE }
  QCONTROLLER_TYPES = %w{ QUEUEOVERRIDE PROPORTIONAL PI }
  DYNAMICS          = %w{ CTM }

  # Convert length in xml file to length for insertion in database. 
   def import_length len
    len = Float(len)
    case units
    when "US"
      len
    when "Metric"
      len * 0.62137119 # km to miles
    else
      raise "Bad units: #{units}"
    end
  end

  # Convert speed in xml file to speed for insertion in database.
  def import_speed spd
    spd = Float(spd)
    case units
    when "US"
      spd
    when "Metric"
      spd * 0.62137119 # kph to mph
    else
      raise "Bad units: #{units}"
    end
  end

  # Convert density in xml file to density for insertion in database.
  def import_density den
    den = Float(den)
    case units
    when "US"
      den
    when "Metric"
      den * 1.609344 # v/km to v/mile
    else
      raise "Bad units: #{units}"
    end
  end
  
  def import_boolean s, *default
    case s
    when "true"; true
    when "false"; false
    when nil
      if default.empty?
        raise "Bad boolean: #{s.inspect}"
      else
        default.first
      end
    else raise "Bad boolean: #{s.inspect}"
    end
  end
  
  # If string is not a valid name, defers setting the name from the id
  # until after the first pass through the importer.
  def set_name_from s, ctx, model
    case s
    when /\S/
      model.name = s
    else
#      ctx.defer do
        cl_name = model.class.name[/\w+$/]
        model.name = "#{cl_name} #{model.id}"
#      end
    end
  end
  
  def included m
    #if m < Sequel::Model
      m.extend AuroraModelClassMethods
    #end
  end
end

module AuroraModelClassMethods
  attr_reader :treat_as_new
  
  def self.import_id s
    s && !(s =~ /[a-zA-Z]/)  && Integer(s) rescue nil
  end
  
  def self.set_treat_as_new(flag)
    @treat_as_new = flag
  end
  
  def self.record_exists
    @record_exists
  end
  
   # Creates and return an instance with ID parsed from s. If s is not
   # parsable as an integer, the instance will be assigned a new id.
   # Yields model to block in the context of create, after id assigned:
   #
   #  create_with_id s do |model|
   #    model.name = "foo_#{model.id}"
   #  end
   #
   # network is only passed when needed to identify unique record - links, nodes, sensors, routes
   def self.create_with_id s, model, network = nil
     id = nil
     model_obj = nil
     @record_exists = false
    
     #if the file we are importing has come via upload from the relteq web app, we will treat every
    #record as a new record in the system @treat_as_new is set just before the import begins
    
     if(!@treat_as_new)
       id = import_id(s)       
     end
     
     #if we are not treating as new, we should see if this record exists already.
     #if it does we grab it and return it for updating
     if(id != nil)
       begin
         #Nodes, links, sensors and routes are identified by composite key -- network and their own id
         #You must have the network in order to identify a unique record.
         #
        
         if(network.nil?)
           model_obj = model.find(id)
           @record_exists = true
         else
           model_obj = model.find(:first, :conditions => ["id = ? and network_id = ?",id,network.id])
         end
             
       rescue ActiveRecord::ActiveRecordError ## didn't find it even though not new
          #do nothing
       end
     end #id != nil
      
      if(model_obj == nil)
        begin
         model_obj = model.new do |m|
           m.id = id if id
         end
         #this allows us to obtain an id for the record without breaking validation rules.
         #the record will be validated and saved again once all the attributes are filled     
         model_obj.save_without_validation
         
        rescue ActiveRecord::ActiveRecordError ## or should we just assume transaction?
          # if(new_model.id == id) ### :network_id too?
          #   raise "#{new_model} already exists" ### delete and insert
          # else
             raise
          # end
        end
      end #if model_obj == nil
      
     # give it back
     yield model_obj if block_given?      

   end

end
