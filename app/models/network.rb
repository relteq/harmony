class Network < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  include RelteqUserStamps
  before_destroy :destroy_dependents_ordered

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

  has_many :routes
  has_many :nodes
  has_many :links
  has_many :sensors
  
  relteq_time_attr :dt

  def destroy_dependents_ordered 
    # Rails determination of how to do this can cause DB errors
    transaction do
      ActiveRecord::Base.connection.execute "DELETE FROM route_links WHERE network_id=#{self.id}"
      ActiveRecord::Base.connection.execute "DELETE FROM routes WHERE network_id=#{self.id}"
      ActiveRecord::Base.connection.execute "DELETE FROM links WHERE network_id=#{self.id}"
      ActiveRecord::Base.connection.execute "DELETE FROM nodes WHERE network_id=#{self.id}"
      ActiveRecord::Base.connection.execute "DELETE FROM sensors WHERE network_id=#{self.id}"
    end
  end

  def remove_from_scenario
    @scen = Scenario.find_by_network_id(id)
    if(@scen != nil)
      @scen.network_id = nil
      @scen.save
    end
  end
  
  
  def self.delete_all(collection)
    collection.each do | item |
      item.remove_from_scenario
      item.destroy
    end
  end

  def ordered_nodes 
    ordered_rls = routes.first.route_links.sort_by {|rl| rl.ordinal }
    ordered_rls.map {|rl| rl.link.begin } 
  end
end
