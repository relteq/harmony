class CreateSignalPhases < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TABLE signal_phases (
        node_id INTEGER NOT NULL,
        phase INTEGER NOT NULL,
        protected_flag BOOLEAN,
        permissive_flag BOOLEAN,
        yellow_time DECIMAL,
        red_clear_time DECIMAL,
        FOREIGN KEY(node_id) 
          REFERENCES node_families(id) 
          ON DELETE CASCADE,
        PRIMARY KEY(node_id, phase)
      )
    }
  end

  def self.down
    execute "DROP TABLE signal_phases"
  end
end
