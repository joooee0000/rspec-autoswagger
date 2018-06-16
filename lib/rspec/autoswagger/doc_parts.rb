require 'rspec/autoswagger/doc_part'
module Rspec module Autoswagger
    class DocParts

      attr_reader :specification, :info, :paths, :definitions
      def initialize
        @info = Parts::Info.new.generate_hash
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
        model_file_names = Dir.glob(Parts::Definition::DEFAULT_PATH + "/Models/*")
        response_file_names = Dir.glob(Parts::Definition::DEFAULT_PATH + "/Responses/*")
        model_file_names.each do |file_name|
          model_hash = YAML.load_file(file_name).to_h
          definitions.merge!(model_hash)
        end

        responses = response_file_names.map do |file_name|
          response_hash = YAML.load_file(file_name).to_h
          definitions.merge!(response_hash)
        end

        specification['definitions'] = definitions
        definitions
      end
    end
  end
end
