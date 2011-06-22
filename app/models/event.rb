class Event < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
    
  belongs_to :event_set
  

  def description
    index_start = parameters.index("<description>")
    index_end = parameters.index("</description>")
    self.parameters[index_start,index_start+ index_end].sub("<description>","").sub("</description>","")
  end
end
