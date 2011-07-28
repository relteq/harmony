class MeasurementDatum < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :data_type
  validates_presence_of :data_format
  validates_presence_of :url
  
  belongs_to :project
  before_destroy :delete_associated_s3_data
  
  def creator
    begin
      u = User.find(user_id_creator)
      u.name
    rescue ActiveRecord::RecordNotFound
      ''
    end
  end
  
  def self.save_rename(id,name) 
    sim_batch =  MeasurementDatum.find(id)
    sim_batch.name = name
    sim_batch.save!
  end
  
  private
    def delete_associated_s3_data
      begin
        AWS::S3::S3Object.find(url, S3SwfUpload::S3Config.bucket).delete
      rescue
        return false
      end
    end
end
