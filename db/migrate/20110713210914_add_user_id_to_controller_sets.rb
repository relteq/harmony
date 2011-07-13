class AddUserIdToControllerSets < ActiveRecord::Migration
  def self.up
    add_column :controller_sets, :user_id_creator, :integer
    add_column :controller_sets, :user_id_modifier, :integer
  end

  def self.down
    remove_column :controller_sets, :user_id_modifier
    remove_column :controller_sets, :user_id_creator
  end
end
