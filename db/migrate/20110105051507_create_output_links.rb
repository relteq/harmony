class CreateOutputLinks < ActiveRecord::Migration
  def self.up
    create_table :output_links do |t|
      t.integer :link_id
      t.integer :network_id
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :output_links
  end
end
