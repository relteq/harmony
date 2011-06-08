class SplitRatioProfile < ActiveRecord::Base
  belongs_to :split_ratio_profile_set
  belongs_to :node
end
