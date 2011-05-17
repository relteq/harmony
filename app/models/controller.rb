class Controller < ActiveRecord::Base
  include Export::Controller
  belongs_to :controller_set
end
