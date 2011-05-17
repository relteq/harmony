require 'relteq_time'
require 'scenario_importer'
require 'util-ar'
module Aurora
  module Parser
    # +src+ can be io, string, etc.
    def parse src
      ## optionally validate
      Nokogiri.XML(src).xpath("/scenario")[0]

    end
  end
  extend Parser
  
  class Importer
    include Parser
    
    attr_reader :src
    attr_reader :scenario_xml
    attr_reader :scenario
    attr_reader :treat_as_new
    attr_reader :am_testing
    attr_reader :project_id
    
    
    def initialize src, project_id, opts = {}
      @src = src
      @opts = opts
      @project_id = project_id
    end
    
    def validate_project_id
      #p = Project.find(@project_id)
      p = 8
      if(p == nil)
        raise "The project id," + @project_id + " is not valid. You must pass a valid project id."
      end
    end
    
    # +src+ can be io, string, etc.
    # Returns the ID of the imported scenario.
    def import
      validate_project_id
      
      am_testing =  @opts[:am_testing] || false
      AuroraModelClassMethods::set_am_testing(am_testing)
  
      treat_as_new = @opts[:is_new] || false
      AuroraModelClassMethods::set_treat_as_new(treat_as_new)
  
      scenario_xml = parse(src)
      ActiveRecord::Base.transaction do
         scenario = ScenarioImporter.create_from_xml(scenario_xml,project_id)
      end
      
      return scenario
    end
    
  end
  

  
  def self.import src, project_id,opts = {}
    Importer.new(src,project_id,opts).import
  end
  

end