class MakeNodePrimaryKeyNetworkDependent < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TEMPORARY TABLE nodes_backup (
        id INTEGER, name varchar(255), description varchar(255), 
        type_node varchar(255), lat decimal, lng decimal, 
        elevation decimal, created_at timestamp, 
        updated_at timestamp, network_id integer
      )
    }
    
    execute 'INSERT INTO nodes_backup SELECT * FROM nodes'
    execute 'DROP TABLE nodes'
    execute %Q{
      CREATE TABLE nodes (
        network_id integer NOT NULL REFERENCES networks,
        id INTEGER NOT NULL REFERENCES node_families, 
        name varchar(255), description varchar(255), 
        type_node varchar(255), lat float(32), lng float(32),
        elevation decimal, created_at timestamp, updated_at timestamp, 
        PRIMARY KEY(network_id,id)
      )
    }
    # Can't use * because we're switching column order
    execute %Q{
      INSERT INTO nodes (SELECT network_id, id, 
        name, description, type_node, lat, 
        lng, elevation, created_at, updated_at FROM nodes_backup)
    }
  end

  def self.down
    throw ActiveRecord::Migration::Irreversible
  end
end
