class AddColumnLinkIdToSensors < ActiveRecord::Migration
  def self.up
    add_column :sensors, :link_id, :integer
  end

  def self.down
    remove_column :sensors, :link_id
  end
end
