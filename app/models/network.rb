class Network < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
  
  belongs_to :project

  has_many :controller_sets, :dependent => :destroy
  has_many :split_ratio_profile_sets, :dependent => :destroy
  has_many :capacity_profile_sets, :dependent => :destroy
  has_many :demand_profile_sets, :dependent => :destroy
  has_many :initial_condition_sets, :dependent => :destroy
  has_many :event_sets, :dependent => :destroy

  has_many :events
  has_many :controllers

  has_many :scenarios, :dependent => :destroy
  
  has_many :network_lists, :foreign_key => "network_id", :class_name => "NetworkList"
  has_many :children, :through => :network_lists

  has_many :route_links, :dependent => :destroy
  has_many :routes, :dependent => :destroy
  has_many :nodes, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :sensors, :dependent => :destroy
  
  relteq_time_attr :dt

  def before_destroy
    ActiveRecord::Base.connection.execute "DELETE FROM route_links WHERE network_id=#{self.id}"
  end

  def remove_from_scenario
    @scen = Scenario.find_by_network_id(id)
    if(@scen != nil)
      @scen.network_id = nil
      @scen.save
    end
  end
end
