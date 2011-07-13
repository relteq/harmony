module Dbweb
  class << self
    TYPE_TRANSLATOR = {
      Scenario => 'scenario',
      Network => 'network',
      CapacityProfileSet => 'capacity_profile_set',
      DemandProfileSet => 'demand_profile_set',
      SplitRatioProfileSet => 'split_ratio_profile_set',
      ControllerSet => 'controller_set'
    }

    def flash_editor_url(type, id, token)
      ENV['DBWEB_URL_BASE'] + 
        "/editor/#{type}/#{id}.html" +
        "?access_token=#{token}"
    end

    def object_editor_url(object)
      auth = DbwebAuthorization.create_for(object)
      flash_editor_url TYPE_TRANSLATOR[object.class], 
                       object.id, 
                       auth.escaped_token
    end

    def scenario_export_url(scenario)
      auth = DbwebAuthorization.create_for(scenario)
      ENV['DBWEB_URL_BASE'] + 
        "/model/scenario/#{scenario.id}.xml" +
        "?access_token=#{auth.escaped_token}"
    end
  end
end
