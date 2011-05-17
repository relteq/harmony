require 'export/init'

class ActiveRecord::Base
  include Export::ActiveRecord::Base::InstanceMethods
end
