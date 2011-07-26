class ChangeUrlToKeyInOutputFile < ActiveRecord::Migration
  def self.up
    rename_column :output_files, :url, :key
  end

  def self.down
    rename_column :output_files, :key, :url
  end
end
