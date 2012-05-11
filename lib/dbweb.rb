require 'net/http'
require 'uri'

module Dbweb
  class << self
    TYPE_TRANSLATOR = {
      Scenario => 'scenario',
      Network => 'network',
      CapacityProfileSet => 'capacity_profile_set',
      DemandProfileSet => 'demand_profile_set',
      SplitRatioProfileSet => 'split_ratio_profile_set',
      ControllerSet => 'controller_set',
      EventSet => 'event_set'
    }

    def flash_editor_url(type, id, token)
      ENV['DBWEB_URL_BASE'] + 
        "/editor/#{type}/#{id}.html" +
        "?access_token=#{token}"
    end

    def object_editor_url(object)
      auth = ApiAuthorization.get_for(object)
      flash_editor_url TYPE_TRANSLATOR[object.class], 
                       object.id, 
                       auth.escaped_token
    end

    def report_xml_url(report)
      auth = ApiAuthorization.get_for(
        report, 
        :expiration => Time.now.utc + 3.days
      )
      ENV['DBWEB_URL_BASE'] +
        "/reports/#{report.id}/report_xml" +
        "?access_token=#{auth.escaped_token}&jsoncallback=?"
    end

    def object_duplicate_url(object, options = {})
      # Needs longer expiration because it is created
      # on an unrelated page load
      auth = ApiAuthorization.get_for(
        object,
        :expiration => Time.now.utc + 8.hours
      )
      http_options = options.map do |k,v|
        "&#{k}=#{v}"
      end.join
      ENV['DBWEB_URL_BASE'] +
        "/duplicate/#{TYPE_TRANSLATOR[object.class]}/#{object.id}" +
        "?access_token=#{auth.escaped_token}#{http_options}"
    end

    def object_export_url(object)
      auth = ApiAuthorization.get_for(object)
      ENV['DBWEB_URL_BASE'] +
        "/model/#{TYPE_TRANSLATOR[object.class]}/#{object.id}.xml" +
        "?access_token=#{auth.escaped_token}"
    end

    def dbweb_file_url(output_file)
      auth = ApiAuthorization.get_for(output_file)
      ENV['DBWEB_URL_BASE'] +
        "#{output_file.key}?access_token=#{auth.escaped_token}"
    end

    def dbweb_report_file_url(report, type)
      auth = ApiAuthorization.get_for(report)
      key = case type
              when :xls then report.xls_key
              when :pdf then report.pdf_key
              when :xml then report.xml_key
              when :ppt then report.ppt_key
            end
      ENV['DBWEB_URL_BASE'] +
        "#{key}?access_token=#{auth.escaped_token}"
    end
  end
end
