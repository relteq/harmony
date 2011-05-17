class SplitRatioProfile < ActiveRecord::Base
  include Export::SplitRatioProfile

  belongs_to :split_ratio_profile_set
  belongs_to :node
end
