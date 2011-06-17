class AddColumnReportTypeToSimulationBatchReport < ActiveRecord::Migration
  def self.up
    add_column :simulation_batch_reports, :report_type, :string
  end

  def self.down
    remove_column :simulation_batch_reports, :report_type
  end
end
