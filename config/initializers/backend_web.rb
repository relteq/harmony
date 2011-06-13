# In production, this should be set with Heroku environment vars
ENV['RUNWEB_URL_BASE'] ||= 'http://localhost:9097'
ENV['DBWEB_URL_BASE'] ||= 'http://localhost:9098'
