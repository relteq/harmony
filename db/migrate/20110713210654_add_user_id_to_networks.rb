class AddUserIdToNetworks < ActiveRecord::Migration
  def self.up
    add_column :networks, :user_id_creator, :integer
    add_column :networks, :user_id_modifier, :integer
  end

  def self.down
    remove_column :networks, :user_id_modifier
    remove_column :networks, :user_id_creator
  end
end
