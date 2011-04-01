class CreateControllerGroups < ActiveRecord::Migration
  def self.up
    create_table :controller_groups do |t|
      t.string :description
      t.integer :network_id

      t.timestamps
    end
  end

  def self.down
    drop_table :controller_groups
  end
end
