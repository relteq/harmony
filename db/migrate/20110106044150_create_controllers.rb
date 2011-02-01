class CreateControllers < ActiveRecord::Migration
  def self.up
    create_table :controllers do |t|
      t.string :type
      t.string :controller_type
      t.decimal :dt
      t.binary :parameters
      t.integer :controller_group_id
      t.integer :network_id
      t.integer :link_id
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :controllers
  end
end
