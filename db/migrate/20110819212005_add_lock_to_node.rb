class AddLockToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :lock, :boolean
  end

  def self.down
    remove_column :nodes, :lock, :boolean
  end
end
