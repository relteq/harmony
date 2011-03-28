class CreateOutputFiles < ActiveRecord::Migration
  def self.up
    create_table :output_files do |t|
      t.integer :batch_id
      t.integer :simulation_no
      t.enum :type
      t.binary :data

      t.timestamps
    end
  end

  def self.down
    drop_table :output_files
  end
end
