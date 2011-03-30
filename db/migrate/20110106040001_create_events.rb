class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :type
      t.string :event_type
      t.decimal :time
      t.binary :parameters
      t.integer :event_group_id
      t.integer :network_id
      t.integer :link_id
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
