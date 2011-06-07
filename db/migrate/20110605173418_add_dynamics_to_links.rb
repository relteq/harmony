class AddDynamicsToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :dynamics, :string
  end

  def self.down
    remove_column :links, :dynamics, :string
  end
end
