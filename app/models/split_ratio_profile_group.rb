class SplitRatioProfileGroup < ActiveRecord::Base
  belongs_to:network
  
  has_many:split_ratio_profiles
  has_many:scenarios
  
end
