class Controller < ActiveRecord::Base
  belongs_to:controller_group
  belongs_to:project
end
