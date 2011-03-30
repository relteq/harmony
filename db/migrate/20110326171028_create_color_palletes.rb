class CreateColorPalletes < ActiveRecord::Migration
  def self.up
    create_table :color_palletes do |t|
      t.integer :simulation_batch_report_id
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :color_palletes
  end
end
