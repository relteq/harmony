class Node < ActiveRecord::Base
  has_many :intersections
  has_many :split_ratio_profiles  
  has_many :events
  has_many :controllers
  has_many :links
   
  belongs_to :network

  def input_links
    Link.find_all_by_end_node_id(id)
  end

  def output_links
    Link.find_all_by_begin_node_id(id)
  end
end
