class OutputFile < ActiveRecord::Base
  belongs_to :simulation_batch

  def url
    AWS::S3::S3Object.url_for(key, s3_bucket)
  end
end
