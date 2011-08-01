class MeasurementDatum < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :data_type
  validates_presence_of :data_format
  validates_presence_of :url
  
  belongs_to :project
  before_destroy :delete_associated_s3_data
  
  def creator
    begin
      User.find(user_id_creator)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
  
  def self.save_rename(id,name) 
    sim_batch =  MeasurementDatum.find(id)
    sim_batch.name = name
    sim_batch.save!
  end
  
  private
    def delete_associated_s3_data
        msg = AWS::S3::S3Object.find(url, S3SwfUpload::S3Config.bucket).delete
    end
end
