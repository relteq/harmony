class Event < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
    
  belongs_to :event_set
  belongs_to :node
  belongs_to :network
  belongs_to :link
  

  def description
    index_start = parameters.index("<description>")
    index_end = parameters.index("</description>")
    begin
      self.parameters[index_start,index_start+ index_end].sub("<description>","").sub("</description>","")
    rescue 
      return '' 
    end
    
  end
end
