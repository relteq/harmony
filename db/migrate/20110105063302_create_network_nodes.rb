class CreateNetworkNodes < ActiveRecord::Migration
  def self.up
    create_table :network_nodes do |t|
      t.integer :node_id
      t.integer :network_id

      t.timestamps
    end
  end

  def self.down
    drop_table :network_nodes
  end
end
