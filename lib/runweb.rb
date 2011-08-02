module Runweb 
  class << self
    SIMULATION_MODES = ['Simulation', 'Prediction']

    def simulation_modes
      SIMULATION_MODES
    end

    def end_time_types
      END_TIME_TYPES
    end

    def simulate(batch, simulation_spec = :simple)
      options = batch_options({ 
        :user => batch.creator.aurora_user,
        :group => batch.creator.aurora_group,
        :name => batch.name,
        :engine => 'simulator',
        :param => {:update_period => 1}
      })

      # Beware that for the sake of runweb/runq arrays must be specified by strings -
      # a colon prefix will be reflected in the output YAML and make the simulation fail.
      options[:param]['inputs'] = ["@scenario(#{batch.scenario_id})"]
      options[:param]['output_types'] = ['text/plain']
      options[:param][:redmine_simulation_batch_id] = batch.id

      if simulation_spec == :simple
        options[:n_runs] = 1
        options[:param]['inputs'] << time_range_tag
      else
        begin_time = RelteqTime.parse_time_to_seconds(
          simulation_spec[:param].delete(:b_time)
        )
        duration = RelteqTime.parse_time_to_seconds(
          simulation_spec[:param].delete(:duration)
        )
        options[:param]['inputs'] << time_range_tag(options[:param])
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

    def report(sim_report)
      options = batch_options({
        :user => sim_report.creator.aurora_user,
        :group => sim_report.creator.aurora_group,
        :name => sim_report.name, 
        :engine => 'report generator', 
        :n_runs => 1,
        :param => {
          :redmine_batch_report_id => sim_report.id,
          'inputs' => [sim_report.to_xml],
          'output_types' => ['application/xml', 
                             'application/vnd.ms-powerpoint',
                             'application/pdf',
                             'application/vnd.ms-excel']
        }
      })

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
    def time_range_tag(user_opts = {})
      opts = {
        :begin_time => 0.0,
        :duration => 86400.0,
        :qcontrol => false,
        :control => false,
        :events => false
      }
      opts.merge!(user_opts)

      %Q{<time_range begin_time="#{opts[:begin_time]}"
                     duration="#{opts[:duration]}"
                     qcontrol="#{opts[:qcontrol]}"
                     control="#{opts[:control]}"
                     events="#{opts[:events]}" />
      }
    end

    def batch_options(plus)
      options = { 
        :user => ENV['AURORA_WORKER_USER'], 
        :group => ENV['AURORA_WORKER_GROUP']
      }.merge(plus)
    end

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
