class CreateNetworkFamilies < ActiveRecord::Migration
  def self.up
    create_table :network_families do |t|
      t.integer :network_id
      t.integer :child_id

      t.timestamps
    end
  end

  def self.down
    drop_table :network_families
  end
end
