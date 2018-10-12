require 'rspec/autoswagger/parts/path'
require 'rspec/autoswagger/parts/info'
require 'rspec/autoswagger/parts/definition'
require 'rspec/autoswagger/util'

module Rspec
  module Autoswagger
    class DocPart

      attr_reader :rspec_core_obj, :example, :request

      def initialize(rspec_core_obj, example)
        @rspec_core_obj = rspec_core_obj
        @request = rspec_core_obj.request
        @example = example
      end

      def response_name
        status = rspec_core_obj.response.status.to_s
        if status == '200'
          path = example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
          path = if path.blank?
                   path = request.path.gsub(Rspec::Autoswagger::API_BASE_PATH, '')
                   get_converted_path(path)
                 end
          path.gsub(/\/|:/, '').camelize
        else
          path = example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
          path = if path.blank?
                   path = request.path.gsub(Rspec::Autoswagger::API_BASE_PATH, '')
                   get_converted_path(path)
                 end
          path.gsub(/\/|:/, '').camelize + '_' + status
        end
      end

      def get_converted_path(path)
        path.split("/").map do |path_element|
          if Util.detect_uuid(path_element)
            ":id"
          elsif Util.detect_uuid(path_element)
            ":id"
          else
            path_element
          end
        end.join("/")
      end

      def create_path
        path = Parts::Path.new(rspec_core_obj, example, response_name)
        path.generate_hash
      end

      def create_definition(output_path = nil)
        definition = Parts::Definition.new(rspec_core_obj.response.body, response_name, output_path)
        definition.generate_definitions
      end
    end
  end
end
