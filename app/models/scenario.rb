class Scenario < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
    
  belongs_to:project
  belongs_to:network
  belongs_to:demand_profile_set
  belongs_to:capacity_profile_set
  belongs_to:split_ratio_profile_set
  belongs_to:controller_set
  belongs_to:event_set
  
  def b_time
      Time.at(Time.gm(2000,1,1) + (read_attribute("b_time") || 0.0 * 3600)).utc.strftime("%H:%M:%S").to_s
      
  end
  
  def b_time=(b_time)
     
     write_attribute("b_time",(Time.parse(b_time).seconds_since_midnight.to_i) * 1000)
     rescue ArgumentError
       @b_time_invalid = true
  end
  
  def e_time
    Time.at(Time.gm(2000,1,1) + (read_attribute("e_time") || 0.0  * 3600)).utc.strftime("%H:%M:%S").to_s
  end
  
  def e_time=(e_time)
     write_attribute("e_time",(Time.parse(e_time).seconds_since_midnight.to_i))
     rescue ArgumentError
       @e_time_invalid = true
  end
  
  def dt
    Time.at(Time.gm(2000,1,1) + (read_attribute("dt") || 0.0  * 3600)).utc.strftime("%H:%M:%S").to_s
  end
  
  def dt=(dt)
     write_attribute("dt",(Time.parse(dt).seconds_since_midnight.to_i))
     rescue ArgumentError
       @dt_invalid = true
  end


  #def validate
  #  errors.add(:dt, "is invalid") if @dt_invalid
  #  errors.add(:b_time, "is invalid") if @b_time_invalid
  #  errors.add(:e_time, "is invalid") if @e_time_invalid
  #end
  #def to_param
  #  "#{name.gsub(/\W/,'-').downcase}"
  #end
    
  
end
