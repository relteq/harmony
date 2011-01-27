class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :name
      t.string :description
      t.string :type_node
      t.decimal :geo_x
      t.decimal :geo_y
      t.decimal :geo_z

      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
