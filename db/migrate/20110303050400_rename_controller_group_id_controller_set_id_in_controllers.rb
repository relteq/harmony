class RenameControllerGroupIdControllerSetIdInControllers < ActiveRecord::Migration
  def self.up
    rename_column :controllers, :controller_group_id, :controller_set_id
  end

  def self.down
    rename_column :controllers, :controller_set_id, :controller_group_id    
  end
end
