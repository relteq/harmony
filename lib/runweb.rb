module Runweb 
  class << self
    SIMULATION_MODES = ['Simulation', 'Prediction']

    def simulation_modes
      SIMULATION_MODES
    end

    def end_time_types
      END_TIME_TYPES
    end

    def simulate(scenario_id, name, simulation_spec = :simple)
      options = { :engine => 'simulator' }
      options[:param] = {}
      # TODO once workers are instantiated dynamically, these should be
      # the correct user and group IDs
      options[:name] = name
      options[:user] = ENV['AURORA_WORKER_USER']
      options[:group] = ENV['AURORA_WORKER_GROUP']
      options[:param][:update_period] = 1

      # Beware that for the sake of runweb/runq arrays must be specified by strings -
      # a colon prefix will be reflected in the output YAML and make the simulation fail.
      options[:param]['inputs'] = ["@scenario(#{scenario_id})"] 
      options[:param]['output_types'] = ['text/plain']

      if simulation_spec == :simple
        options[:n_runs] = 1
        options[:param][:control] = true
        options[:param][:qcontrol] = true
        options[:param][:events] = true
        options[:param]['inputs'] << '<time_range begin_time="0.0" duration="0.0" />'
      else
        begin_time = RelteqTime.parse_time_to_seconds(simulation_spec[:param].delete(:b_time))
        duration = RelteqTime.parse_time_to_seconds(simulation_spec[:param].delete(:duration))
        options[:param]['inputs'] << %Q{<time_range begin_time="#{begin_time}" duration="#{duration}" />}
        simulation_spec[:param].merge!(options[:param])
        options.merge!(simulation_spec)
      end

      begin
        http_post_runweb(options)
      rescue Exception => e
        Rails.logger.error "Error launching simulation, spec = #{simulation_spec}"
        Rails.logger.error "error text: #{e.message}"
        Rails.logger.error "backtrace: #{e.backtrace.inspect}"
        return false
      end
    end

    def report(name, request_xml)
      options = {:name => name, :engine => 'report generator', :n_runs => 1}
      options[:user] = ENV['AURORA_WORKER_USER']
      options[:group] = ENV['AURORA_WORKER_GROUP']
      options[:param] = {
        'inputs' => [request_xml],
        'output_types' => ['application/xml']
      }

      begin
        http_post_runweb(options)
      rescue Exception => e
        Rails.logger.error "Error launching report generator, spec = #{options}"
        Rails.logger.error "error text: #{e.message}"
        Rails.logger.error "backtrace: #{e.backtrace.inspect}"
        return false
      end
    end
  private
    def http_post_runweb(options)
      uri = URI.parse(ENV['RUNWEB_URL_BASE'])
      host, port = uri.host, uri.port
      Net::HTTP.start(host, port) do |http|
        http.post('/batch/new', options.to_yaml)
        Rails.logger.info options.to_yaml
      end
    end
  end
end
