class AddProjectIdToNetwork < ActiveRecord::Migration
  def self.up
    add_column :networks, :project_id, :integer
  end

  def self.down
    remove_column :networks, :project_id
  end
end
