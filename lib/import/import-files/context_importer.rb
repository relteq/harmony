module Aurora
  # Exists during one scenario import operation.
  class ImportContext
    include Aurora

    # The scenario being imported.
    attr_reader :scenario
    
    # Hash of values from existing scenario before import started, or nil.
    attr_reader :prev_scenario_state
        
    # Keep track of begin and end nodes, ordinals, and weaving_factors
    # for each link listed (as an xml id) under the node.
    attr_reader :begin_for_link_xml_id
    attr_reader :end_for_link_xml_id
    

    def initialize scenario, prev_scenario_state
      @scenario = scenario
      @prev_scenario_state = prev_scenario_state
      
      
      @begin_for_link_xml_id        = {}
      @end_for_link_xml_id          = {}
      
      @deferred = []
    end
    
    # # Returns the network family ID (not Tln ID) for the network specified in
    #  # the given string. If the string is not a decimal integer, look up the
    #  # string in the hash of local IDs defined in the imported xml.
    #  def get_network_id network_xml_id
    #    network_xml_id or raise ArgumentError
    #    network_family_id_for_xml_id[network_xml_id] || Integer(network_xml_id)
    #  rescue ArgumentError
    #    raise "invalid network id: #{network_xml_id.inspect}"
    #  end
    #  
     # Returns the node family ID for the node specified in the given
     # string. If the string is not a decimal integer, look up the string
     # in the hash of local IDs defined in the imported xml.
     def get_node_id node_xml_id
       node_xml_id or raise ArgumentError
       Integer(node_xml_id)
     rescue ArgumentError
       raise "invalid node id: #{node_xml_id.inspect}"
     end
     
     # Returns the link family ID for the link specified in the given
     # string. If the string is not a decimal integer, look up the string
     # in the hash of local IDs defined in the imported xml.
     def get_link_id link_xml_id
       link_xml_id or raise ArgumentError
       Integer(link_xml_id)
     rescue ArgumentError
       raise "invalid link id: #{link_xml_id.inspect}"
     end
    
    def defer &action
      @deferred << action
    end
    
    def do_deferred
      while action = @deferred.shift
        action.call
      end
    end
    
    # define this so that import_length and similar methods will work
    def units
      @units ||= scenario.length_units
    end
    
   public :import_length

  end
end
