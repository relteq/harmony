class AddBucketToOutputFileAndSimBatchReport < ActiveRecord::Migration
  def self.up
    add_column :output_files, :s3_bucket, :string
    add_column :simulation_batch_reports, :s3_bucket, :string
  end

  def self.down
    remove_column :output_files, :s3_bucket
    remove_column :simulation_batch_reports, :s3_bucket
  end
end
