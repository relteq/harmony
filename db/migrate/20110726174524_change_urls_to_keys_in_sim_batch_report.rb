class ChangeUrlsToKeysInSimBatchReport < ActiveRecord::Migration
  def self.up
    change_table :simulation_batch_reports do |t|
      t.rename :url, :xml_key
      t.rename :export_ppt_url, :ppt_key
      t.rename :export_pdf_url, :pdf_key
      t.rename :export_xls_url, :xls_key
    end
  end

  def self.down
    change_table :simulation_batch_reports do |t|
      t.rename :xml_key, :url
      t.rename :ppt_key, :export_ppt_url
      t.rename :pdf_key, :export_pdf_url
      t.rename :xls_key, :export_xls_url
    end
  end
end
