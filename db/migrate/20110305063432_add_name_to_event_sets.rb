class AddNameToEventSets < ActiveRecord::Migration
  def self.up
    add_column :event_sets, :name, :string
  end

  def self.down
    remove_column :event_sets, :name
  end
end
