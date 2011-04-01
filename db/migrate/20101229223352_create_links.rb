class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :type_link
      t.string :name
      t.decimal :length
      t.decimal :lanes
      t.decimal :capacity
      t.decimal :v
      t.decimal :w
      t.decimal :jam_den
      t.decimal :cap_drop
      t.binary :geo_cache

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
