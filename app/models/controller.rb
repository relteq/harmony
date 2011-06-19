class Controller < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  relteq_time_attr :dt
  belongs_to :controller_set
end
