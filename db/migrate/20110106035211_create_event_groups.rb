class CreateEventGroups < ActiveRecord::Migration
  def self.up
    create_table :event_groups do |t|
      t.integer :network_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :event_groups
  end
end
