class Route < ActiveRecord::Base
  belongs_to :network
    
  has_many :route_links
  has_many :links, :through => :route_links

  def begin_and_end_node_ids
    links_local = ordered_links
    return [links_local.first.begin_node.id, links_local.last.end_node.id]
  end

  def ordered_links
    RouteLink.find(:all, 
                   :conditions => { :route_id => id },
                   :order => '"order" desc').map(&:link)
  end
end
