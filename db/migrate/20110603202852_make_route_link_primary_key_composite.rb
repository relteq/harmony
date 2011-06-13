class MakeRouteLinkPrimaryKeyComposite < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TEMPORARY TABLE route_links_backup (
        id integer, route_id integer,
        link_id integer, ordinal integer,
        created_at timestamp, updated_at timestamp,
        network_id integer
      )
    }

    execute 'INSERT INTO route_links_backup SELECT * FROM route_links'
    execute 'DROP TABLE route_links'
    execute %Q{
      CREATE TABLE route_links (
        network_id integer,
        id integer, route_id integer, 
        link_id integer, ordinal integer, 
        created_at timestamp, updated_at timestamp,
        PRIMARY KEY(network_id, route_id, link_id),
        FOREIGN KEY(network_id, route_id) REFERENCES routes (network_id, id) ON DELETE CASCADE,
        FOREIGN KEY(network_id, link_id) REFERENCES links (network_id, id) ON DELETE CASCADE
      )
    }
  end

  def self.down
    throw ActiveRecord::Migration::Irreversible
  end
end
