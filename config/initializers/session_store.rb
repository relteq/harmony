# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_relteq-main_session',
  :secret      => 'e9f03716e3e811aefe7067b5de47bebb7965802ab2f5276de9d857024bc89c498912fc8610da6c782bf1296803846d34b8fbc9c6e7e387311c86842707472887'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
