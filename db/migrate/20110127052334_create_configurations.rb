class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
