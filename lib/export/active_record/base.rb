require 'nokogiri'

module Export
  module ActiveRecord
    module Base
      module InstanceMethods 
        def to_xml
          builder = Nokogiri::XML::Builder.new do |xml|
            build_xml(xml)
          end
          builder.to_xml
        end
      end
    end
  end
end
