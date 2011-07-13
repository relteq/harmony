class AddUserIdToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :user_id_creator, :integer
    add_column :scenarios, :user_id_modifier, :integer
  end

  def self.down
    remove_column :scenarios, :user_id_modifier
    remove_column :scenarios, :user_id_creator
  end
end
