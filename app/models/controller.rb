class Controller < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  relteq_time_attr :dt
  belongs_to :controller_set
  
  def controller_name
    if(type.to_s.index("Link") > -1)
      "Link " + self.link.name
    elsif(type.to_s.index("Node") > -1)
      "Node " + self.node.name
    else
      "Network " + self.network.name
    end  
  end
  
  def dt_to_time_format
    display_time_from_string(dt)
  end
end
