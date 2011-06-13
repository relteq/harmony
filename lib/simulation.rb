module Simulation
  class << self
    MODES = ['Simulation', 'Prediction']

    def modes
      MODES
    end

    def end_time_types
      END_TIME_TYPES
    end

    def all_for_user(user_id)
      begin
        response = http_get_batches(user_id)
        if response["status"] == "ok"
          response["batches"].map{|s| s[:progress] = s[:n_complete] / s[:n_runs] if s[:n_runs] }
          return response["batches"]
        else
          response = :failure 
        end
      rescue Exception => e
        Rails.logger.error "Error loading Simulation data for user ID #{user_id}"
        Rails.logger.error "error text: #{e.message}"
        Rails.logger.error "backtrace: #{e.backtrace.inspect}"
        response = []
      end
    end

    def launch(simulation_spec)
      begin
        http_post_simulation(simulation_spec)
      rescue Exception => e
        Rails.logger.error "Error launching simulation for user ID #{simulation_spec[:user]}"
        Rails.logger.error "error text: #{e.message}"
        Rails.logger.error "backtrace: #{e.backtrace.inspect}"
        return false
      end
    end

  private
    def http_get_batches(user)
      YAML.load(
        Net::HTTP.get URI.parse(ENV['RUNWEB_URL_BASE'] + "/user/#{user}")
      )
    end

    def http_get_batch(batch_id)
      YAML.load( 
        Net::HTTP.get URI.parse(ENV['RUNWEB_URL_BASE'] + "/batch/#{batch_id}")
      )
    end

    def http_post_simulation(options)
      uri = URI.parse(ENV['RUNWEB_URL_BASE'])
      host, port = uri.host, uri.port
      Net::HTTP.start(host, port) do |http|
        http.post('/batch/new', options.to_yaml)
        Rails.logger.info options.to_yaml
      end
    end
  end
end
