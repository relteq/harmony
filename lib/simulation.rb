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
          response = []
        end
      rescue
        Rails.logger.error "Error loading Simulation data for user ID #{user_id}"
        response = []
      end
    end

    def launch(simulation_spec)
      begin
        http_post_simulation(simulation_spec)
      rescue
        Rails.logger.error "Error launching simulation for user ID #{simulation_spec[:user]}"
        return false
      end
    end

  private
    DEFAULT_HOST = ENV['RUNWEB_HOST'] || 'localhost'
    DEFAULT_PORT = ENV['RUNWEB_PORT'] || 8097 
    
    def http_get_batches(user, host = DEFAULT_HOST, port = DEFAULT_PORT)
      YAML.load Net::HTTP.get(host, "/user/#{user}", port)
    end

    def http_get_batch(batch_id, host = DEFAULT_HOST, port = DEFAULT_PORT)
      YAML.load Net::HTTP.get(host, "/batch/#{batch_id}", port)
    end

    def http_post_simulation(options, host = DEFAULT_HOST, port = DEFAULT_PORT)
      res = Net::HTTP.start(host, port) do |http|
        http.post('/batch/new', options.to_yaml)
        Rails.logger.info options.to_yaml
      end
    end
  end
end
