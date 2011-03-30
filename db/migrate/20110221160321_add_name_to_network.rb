class AddNameToNetwork < ActiveRecord::Migration
  def self.up
    add_column :networks, :name, :string
  end

  def self.down
    remove_column :networks, :name
  end
end
