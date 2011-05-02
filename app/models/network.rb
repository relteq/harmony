class Network < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
  
  belongs_to :project

  has_many :controller_sets
  has_many :split_ratio_profile_sets
  has_many :capacity_profile_sets
  has_many :demand_profile_sets
  has_many :event_sets
  has_many :events
  has_many :controllers

  has_many :scenarios
  
  has_many :network_lists, :foreign_key => "network_id", :class_name => "NetworkList"
  has_many :children, :through => :network_lists  

  has_many :routes
  has_many :nodes
  has_many :links
  has_many :sensors
  
  has_many :output_links
  has_many :nodes, :through => :output_links
  has_many :links, :through => :output_links

  has_many :input_links
  has_many :nodes, :through => :input_links
  has_many :links, :through => :input_links


  
  relteq_time_attr :dt
  
  def remove_from_scenario
    #remove this demand profile set from anything it is attached to

    @scen = Scenario.find_by_network_id(id)
    if(@scen != nil)
        @scen.network_id = nil
        @scen.save
    end
  end
end
