class MeasurementDatum < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :data_type
  validates_presence_of :data_format
  validates_presence_of :url
  
  belongs_to :project
  before_destroy :delete_associated_s3_data

  attr_accessor :valid_url
  
  def creator
    begin
      User.find(user_id_creator)
    rescue ActiveRecord::RecordNotFound
      ''
    end
  end
  
  
  def s3_url
    begin
      self.valid_url = true
      AWS::S3::S3Object.find(url, S3SwfUpload::S3Config.bucket).url
    rescue AWS::S3::NoSuchKey => exc
      self.valid_url = false
      l(:relteq_s3_no_file_found)
    rescue Exception => exc
      self.valid_url = false
      l(:relteq_s3_no_file_found)       
    end
  end

  private
    def delete_associated_s3_data
        msg = AWS::S3::S3Object.find(url, S3SwfUpload::S3Config.bucket).delete
    end
end
