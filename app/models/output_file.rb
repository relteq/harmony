class OutputFile < ActiveRecord::Base
  belongs_to :simulation_batch

  before_destroy :delete_associated_s3_data

  def url(options = {})
#    AWS::S3::S3Object.url_for(key, s3_bucket, options)
    Dbweb.dbweb_file_url(self)
  end

private
  def delete_associated_s3_data
#    AWS::S3::S3Object.delete(key, s3_bucket)
  end
end
