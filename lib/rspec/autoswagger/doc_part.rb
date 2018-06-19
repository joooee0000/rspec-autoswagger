require 'rspec/autoswagger/parts/path'
require 'rspec/autoswagger/parts/info'
require 'rspec/autoswagger/parts/definition'

module Rspec
  module Autoswagger
    class DocPart

      attr_reader :rspec_core_obj, :example

      def initialize(rspec_core_obj, example)
        @rspec_core_obj = rspec_core_obj
        @example = example
      end

      def response_name
        example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2].gsub(/\/|:/, '')
      end

      def create_path
        path = Parts::Path.new(rspec_core_obj, example, response_name)
        path.generate_hash
      end

      def create_definition
        definition = Parts::Definition.new(rspec_core_obj.response.body, response_name)
        definition.generate_definitions
      end
    end
  end
end
