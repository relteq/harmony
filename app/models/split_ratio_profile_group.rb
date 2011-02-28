class SplitRatioProfileGroup < ActiveRecord::Base
  belongs_to:network
  belongs_to:project
  
  has_many:split_ratio_profiles
  has_many:scenarios
  
end
