class MeasurementDatum < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :data_type
  validates_presence_of :data_format
  
  
  belongs_to :project
  before_destroy :delete_associated_s3_data

  attr_accessor :valid_url
  
  def validate
    errors.add(:url, l(:measurement_data_one_or_other_url_specified)) if url_user_specified.blank? && url.blank?
  end
  
  def creator
    begin
      User.find(user_id_creator)
    rescue ActiveRecord::RecordNotFound
      nil
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

  def get_appropriate_url
      link = s3_url #s3_url will also set valid url to make sure you were able to locate file in s3
      if(valid_url && url_user_specified.blank?)
         return link
      end
      return url_user_specified
  end

  private
    def delete_associated_s3_data
        msg = AWS::S3::S3Object.find(url, S3SwfUpload::S3Config.bucket).delete
    end
end
