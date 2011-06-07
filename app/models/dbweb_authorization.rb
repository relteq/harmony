class DbwebAuthorization < ActiveRecord::Base
  def self.create_for(obj, options = {})
    DbwebAuthorization.create!(
      :object_type => obj.class.to_s,
      :object_id => obj.id,
      :expiration => Time.now + 5.minutes,
      :access_token => ActiveSupport::SecureRandom.base64(50)
    )
  end
end
