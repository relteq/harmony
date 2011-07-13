module Dbweb
  class << self
    def flash_editor_url(type, id, token)
      ENV['DBWEB_URL_BASE'] + 
        "/editor/#{type}/#{id}.html" +
        "?access_token=#{token}"
    end

    def scenario_editor_url(scenario)
      auth = DbwebAuthorization.create_for(scenario)
      flash_editor_url 'scenario', 
                       scenario.id, 
                       auth.escaped_token
    end

    def network_editor_url(network)
      auth = DbwebAuthorization.create_for(network)
      flash_editor_url 'network', 
                       network.id, 
                       auth.escaped_token
    end

    def ctrl_set_editor_url(cset)
      auth = DbwebAuthorization.create_for(cset)
      flash_editor_url 'controller_set', 
                       cset.id, 
                       auth.escaped_token
    end

    def cp_set_editor_url(cpset)
      auth = DbwebAuthorization.create_for(cpset)
      flash_editor_url 'capacity_profile_set',
                       cpset.id,
                       auth.escaped_token
    end

    def dp_set_editor_url(dpset)
      auth = DbwebAuthorization.create_for(dpset)
      flash_editor_url 'demand_profile_set',
                       dpset.id,
                       auth.escaped_token
    end

    def srp_set_editor_url(srpset)
      auth = DbwebAuthorization.create_for(srpset)
      flash_editor_url 'split_ratio_profile_set',
                       srpset.id,
                       auth.escaped_token
    end
  end
end
