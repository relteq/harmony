class RenameDbwebAuthorizationToApiAuthorization < ActiveRecord::Migration
  def self.up
    rename_table :dbweb_authorizations, :api_authorizations
  end

  def self.down
    rename_table :api_authorizations, :dbweb_authorizations
  end
end
