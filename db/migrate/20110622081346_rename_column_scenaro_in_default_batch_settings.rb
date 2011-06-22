class RenameColumnScenaroInDefaultBatchSettings < ActiveRecord::Migration
  def self.up
    rename_column :default_batch_settings, :scenaro_id, :scenario_id
  end

  def self.down
    rename_column :default_batch_settings, :scenaro_id, :scenario_id
  end
end
