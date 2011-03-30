class ChangeEventGroupIdToEventSetIdInEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :event_group_id, :event_set_id
  end

  def self.down
    rename_column :events, :event_group_id, :event_set_id
  end
end
