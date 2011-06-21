class AddUrlToSimulationBatchReport < ActiveRecord::Migration
  def self.up
    add_column :simulation_batch_reports, :url, :string
  end

  def self.down
    drop_column :simulation_batch_reports, :url
  end
end
