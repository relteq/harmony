class OutputFile < ActiveRecord::Base
  has_many :simulation_batch
end
