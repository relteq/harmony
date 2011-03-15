class Scenario < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
    
  belongs_to :project
  belongs_to :network
  belongs_to :demand_profile_set
  belongs_to :capacity_profile_set
  belongs_to :split_ratio_profile_set
  belongs_to :controller_set
  belongs_to :event_set
  
  def milliseconds_since_midnight(time)
    elems = time.split(":")
    seconds = elems[0].to_i * 3600 + elems[1].to_i * 60 + elems[2].to_f
  end
  
  def milliseconds_to_string_time(mil)
     hours = (mil / 3600).to_i
     minutes = ((mil - (hours * 3600)) / 60).to_i
     seconds = (mil - (hours * 3600) - (minutes * 60))  
     "%02d:%02d:%04.1f" % [hours, minutes, seconds]
  end
   
  def b_time
      milliseconds_to_string_time(read_attribute("b_time") || 0.0)
  end
  
  def b_time=(b_time)
     write_attribute("b_time",milliseconds_since_midnight(b_time))  
     rescue ArgumentError
       @b_time_invalid = true
  end
  
  def e_time
    milliseconds_to_string_time(read_attribute("e_time") || 0.0)
  end
  
  def e_time=(e_time)
     write_attribute("e_time",milliseconds_since_midnight(e_time))
     rescue ArgumentError
       @e_time_invalid = true
  end
  
  def dt
    milliseconds_to_string_time(read_attribute("dt") || 0.0)
  end
  
  def dt=(dt)
     write_attribute("dt",milliseconds_since_midnight(dt)) 
     rescue ArgumentError
       @dt_invalid = true
  end

  #def to_param
  #  "#{name.gsub(/\W/,'-').downcase}"
  #end
end
