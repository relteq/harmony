class Controller < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  relteq_time_attr :dt
  belongs_to :controller_set
  belongs_to :node
  belongs_to :network
  belongs_to :link
  
  def controller_name
    if(type.to_s.index("Link") > -1)
      "Link " + self.link.name
    elsif(type.to_s.index("Node") > -1)
      "Node " + self.node.name
    else
      "Network " + self.network.name
    end  
  end
  

end
