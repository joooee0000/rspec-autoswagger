require 'rspec/autoswagger/doc_part/path'
require 'rspec/autoswagger/doc_part/info'
require 'rspec/autoswagger/doc_part/definition'

module Rspec
  module Autoswagger
    class DocPart

      attr_reader :rspec_core_obj, :example

      def initialize(rspec_core_obj, example)
        @rspec_core_obj = rspec_core_obj
        @example = example
      end

      def response_name
        example.full_description
      end

      def create_path
        path = Path.new(rspec_core_obj, example, response_name)
        path.generate_hash
      end

      def create_definition
        definition = Definition.new(rspec_core.response.body, response_name)
        definition.generate_file
      end
    end
  end
end
