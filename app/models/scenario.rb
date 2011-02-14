class Scenario < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
  #validates_format_of :b_time,  :with => /([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]/
  #validates_format_of :e_time,  :with => /([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]/
  #validates_format_of :dt,  :with => /([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]/
  
  belongs_to:project
  belongs_to:network
  belongs_to:demand_profile_group
  belongs_to:capacity_profile_group
  belongs_to:split_ratio_profile_group
  
  #def to_param
  #  "#{name.gsub(/\W/,'-').downcase}"
 # end
  
end
