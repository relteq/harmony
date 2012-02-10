class ApiAuthorization < ActiveRecord::Base
  named_scope :expired, :conditions => ['expiration < ?', Time.now.utc]

  def self.create_for(obj, user_options = {})
    options = {
      :object_type => obj.class.to_s,
      :object_id => obj.id,
      :expiration => Time.now.utc + 5.minutes,
      :access_token => ActiveSupport::SecureRandom.base64(50)
    }.merge!(user_options)
    ApiAuthorization.create!(options)
  end

  def self.get_for(obj, user_options = {})
    existing_auth = ApiAuthorization.find(:first,
      :conditions => { 
        :object_type => obj.class.to_s, 
        :object_id => obj.id
      }
    )
    if existing_auth && !existing_auth.expired?
      auth = existing_auth
      auth.update_attributes(user_options)
    else
      auth = create_for(obj, user_options)
    end

    return auth
  end

  def escaped_token
    CGI.escape(access_token)
  end

  def expired?
    expiration < Time.now.utc
  end
end
