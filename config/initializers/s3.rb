require 'aws/s3'

filename = File.join(File.dirname(__FILE__), '..', 's3.yml')
if File.exists?(filename)
  s3config = YAML::load_file(filename)
  env_vars = s3config[Rails.env]

  if env_vars
    ENV['S3_Bucket'] = env_vars['bucket']
    ENV['S3_Access_Key'] = env_vars['access_key_id']
    ENV['S3_Secret'] = env_vars['secret_access_key']

    AWS::S3::Base.establish_connection!(
      :access_key_id => env_vars['access_key_id'],
      :secret_access_key => env_vars['secret_access_key']
    )
  else
    raise "Error connecting to S3, export will fail." unless Rails.env == 'test'
  end
end

if ENV['AMAZON_ACCESS_KEY_ID'] && ENV['AMAZON_SECRET_ACCESS_KEY']
  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
  )
end
