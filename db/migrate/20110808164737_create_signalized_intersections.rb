class CreateSignalizedIntersections < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TABLE signalized_intersections (
        node_id INTEGER NOT NULL,
        input_link_id INTEGER NOT NULL,
        phase INTEGER NOT NULL,
        FOREIGN KEY(node_id) 
          REFERENCES node_families(id) 
          ON DELETE CASCADE,
        FOREIGN KEY(input_link_id)
          REFERENCES link_families(id)
          ON DELETE CASCADE
      )
    }
  end

  def self.down
    execute "DROP TABLE signalized_intersections"
  end
end
