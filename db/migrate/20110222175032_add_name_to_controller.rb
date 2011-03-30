class AddNameToController < ActiveRecord::Migration
  def self.up
    add_column :controllers, :name, :string
    add_column :controllers, :project_id, :integer
  end

  def self.down
    remove_column :controllers, :project_id
    remove_column :controllers, :name
  end
end
