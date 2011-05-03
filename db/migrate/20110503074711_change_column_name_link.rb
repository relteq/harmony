class ChangeColumnNameLink < ActiveRecord::Migration
  def self.up
    change_column :links, :name, :text
  end

  def self.down
    change_column :links, :name, :string
  end
end
