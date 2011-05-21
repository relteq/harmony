require 'aws/s3'

filename = File.join(File.dirname(__FILE__), '..', 's3.yml')
if File.exists?(filename)
  s3config = YAML::load_file(filename)
  env_vars = s3config[Rails.env]

  if env_vars
    ENV['S3_Bucket'] = env_vars['bucket']

    AWS::S3::Base.establish_connection!(
      :access_key_id => env_vars['access_key_id'],
      :secret_access_key => env_vars['secret_access_key']
    )
  else
    raise "Error connecting to S3, export will fail." unless Rails.env == 'test'
  end
end
