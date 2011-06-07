class MakeSensorPrimaryKeyNetworkDependent < ActiveRecord::Migration
  def self.up
    execute %Q{ 
      CREATE TEMPORARY TABLE sensor_backup (
        id INTEGER, type_sensor varchar(255), 
        link_type varchar(255), measurement boolean, 
        lat decimal, lng decimal, elevation decimal, 
        created_at timestamp, updated_at timestamp, 
        network_id integer, link_id integer, 
        parameters blob, description varchar(255), 
        display_lat decimal, display_lng decimal, 
        display_elev decimal
      )
    }
    
    execute 'INSERT INTO sensor_backup SELECT * FROM sensors'
    execute 'DROP TABLE sensors'
    execute %Q{  
      CREATE TABLE sensors (
          id INTEGER NOT NULL, type_sensor varchar(255), 
          link_type varchar(255), measurement boolean, lat float(32), 
          lng float(32), elevation decimal, created_at timestamp, 
          updated_at timestamp, network_id integer NOT NULL, link_id integer,
          parameters text, description varchar(255), display_lat float(32), 
          display_lng float(32), display_elev decimal,
          PRIMARY KEY(network_id, id)
      );
    }

    execute 'INSERT INTO sensors SELECT * FROM sensor_backup'
  end

  def self.down
    throw ActiveRecord::Migration::Irreversible
  end
end
