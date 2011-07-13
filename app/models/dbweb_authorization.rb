class DbwebAuthorization < ActiveRecord::Base
  def self.create_for(obj, user_options = {})
    options = {
      :object_type => obj.class.to_s,
      :object_id => obj.id,
      :expiration => Time.now.utc + 5.minutes,
      :access_token => ActiveSupport::SecureRandom.base64(50)
    }.merge!(user_options)
    DbwebAuthorization.create!(options)
  end

  def escaped_token
    CGI.escape(access_token)
  end
end
