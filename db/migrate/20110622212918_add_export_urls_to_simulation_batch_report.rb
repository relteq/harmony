class AddExportUrlsToSimulationBatchReport < ActiveRecord::Migration
  def self.up
    add_column :simulation_batch_reports, :export_ppt_url, :string
    add_column :simulation_batch_reports, :export_pdf_url, :string
    add_column :simulation_batch_reports, :export_xls_url, :string
  end

  def self.down
    drop_column :simulation_batch_reports, :export_ppt_url
    drop_column :simulation_batch_reports, :export_pdf_url
    drop_column :simulation_batch_reports, :export_xls_url
  end
end
