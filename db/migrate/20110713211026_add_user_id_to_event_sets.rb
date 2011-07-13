class AddUserIdToEventSets < ActiveRecord::Migration
  def self.up
    add_column :event_sets, :user_id_creator, :integer
    add_column :event_sets, :user_id_modifier, :integer
  end

  def self.down
    remove_column :event_sets, :user_id_modifier
    remove_column :event_sets, :user_id_creator
  end
end
