class AddControllerSetIdToScenario < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :controller_set_id, :integer
  end

  def self.down
    remove_column :scenarios, :controller_set_id
  end
end
