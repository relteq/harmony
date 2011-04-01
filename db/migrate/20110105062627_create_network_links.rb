class CreateNetworkLinks < ActiveRecord::Migration
  def self.up
    create_table :network_links do |t|
      t.integer :link_id
      t.integer :network_id

      t.timestamps
    end
  end

  def self.down
    drop_table :network_links
  end
end
