class CreateDbwebAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :dbweb_authorizations do |t|
      t.string :object_type
      t.integer :object_id
      t.string :access_token
      t.datetime :expiration
    end
  end

  def self.down
    drop_table :dbweb_authorizations
  end
end
