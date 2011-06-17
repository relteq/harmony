class AddColumnUrlToOutputFiles < ActiveRecord::Migration
  def self.up
    add_column :output_files, :url, :string
    remove_column :output_files, :simulation_no
    remove_column :output_files, :data
  end

  def self.down
    remove_column :output_files, :url
    add_column :output_files, :simulation_no, :integer
    add_column :output_files, :data, :binary
  end
end
