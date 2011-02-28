class AddProjectIdToControllerGroup < ActiveRecord::Migration
  def self.up
    add_column :controller_groups, :project_id, :integer
  end

  def self.down
    remove_column :controller_groups, :project_id
  end
end
