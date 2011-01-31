class CreateInputLinks < ActiveRecord::Migration
  def self.up
    create_table :input_links do |t|
      t.integer :link_id
      t.integer :network_id
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :input_links
  end
end
