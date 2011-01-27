class CreateIntersections < ActiveRecord::Migration
  def self.up
    create_table :intersections do |t|
      t.string :description
      t.integer :node_id
      t.timestamps
    end
  end

  def self.down
    drop_table :intersections
  end
end
