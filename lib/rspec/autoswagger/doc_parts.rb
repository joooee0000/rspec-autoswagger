require 'rspec/autoswagger/doc_part'

module Rspec
  module Autoswagger
    class DocParts
      DEFAULT_INFO = default_info.yml
      OUTPUT_PATH = './'

      attr_reader :specification, :info, :paths, :definitions
      def initialize
        @info = DocPart::Info.new.generate_hash
        @paths = {}
        @definitions = {}
        @specification = {}
      end

      def add(rspec_core_obj, example)
        doc_part = DocPart.new(rspec_core_obj, example)
        paths.merge!(doc_part.create_path)
        doc_part.create_definition
      end

      def aggregate
        specification.merge!(info)
        specification.merge!({ paths: paths })
        specification.merge!({ definitions: aggregate_definitions })

        specification
      end

      def to_yaml
        aggregate if specification.empty?
        YAML.dump(specification, File.open(Rails.root.to_s + '/swagger/swagger.yml', 'w'))
      end

      private

      def aggregate_definitions
        model_file_names = Dir.glob(Rails.root.to_s + "/tmp/specifications/Models/*")
        response_file_names = Dir.glob(Rails.root.to_s + "/tmp/specifications/Responses/*")
        model_file_names.each do |file_name|
          model_hash = YAML.load_file(file_name).to_h
          definitions.merge!(model_hash)
        end

        responses = response_file_names.map do |file_name|
          response_hash = YAML.load_file(file_name).to_h
          definitions.merge!(response_hash)
        end

        swagger_specification['definitions'] = definitions
        definitions
      end
    end
  end
end
