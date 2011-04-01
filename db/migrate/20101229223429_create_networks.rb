class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.string :description
      t.decimal :dt
      t.boolean :ml_control
      t.boolean :q_control

      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
