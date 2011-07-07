require 'digest/md5'

class Scenario < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  US_UNITS = "US"
  METRIC_UNITS = "Metric"
  UNITS = [US_UNITS, METRIC_UNITS] 
   
  # TODO give imported scenarios unique names in import, re-add restriction
  #validates_presence_of :name
  #validates_uniqueness_of :name, :scope => :project_id
  validates_presence_of :network
  relteq_time_attr :begin_time
  relteq_time_attr :duration
  relteq_time_attr :dt
 
  belongs_to :project
  belongs_to :network
  belongs_to :initial_condition_set
  belongs_to :demand_profile_set
  belongs_to :capacity_profile_set
  belongs_to :split_ratio_profile_set
  belongs_to :controller_set
  belongs_to :event_set
  
  has_many :simulation_batches
  has_one :default_batch_setting

  has_many :vehicle_types

  after_create :add_default_vehicle_type
 
  
  def add_default_vehicle_type
    self.vehicle_types.create(:name => 'General', :weight => 1.0)
  end
  
  def get_default_batch_setting
    default_batch_setting != nil ? default_batch_setting : DefaultBatchSetting.new
  end
  
  
end
