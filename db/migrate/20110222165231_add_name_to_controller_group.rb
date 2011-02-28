class AddNameToControllerGroup < ActiveRecord::Migration
  def self.up
    add_column :controller_groups, :name, :string
  end

  def self.down
    remove_column :controller_groups, :name
  end
end
