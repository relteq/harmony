class CreateMeasurementDatas < ActiveRecord::Migration
  def self.up
    create_table :measurement_datas do |t|
      t.integer :project_id
      t.integer :user_id_creator
      t.string :url
      t.string :data_type
      t.string :data_format

      t.timestamps
    end
  end

  def self.down
    drop_table :measurement_datas
  end
end
