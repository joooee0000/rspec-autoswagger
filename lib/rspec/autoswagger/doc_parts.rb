require 'rspec/autoswagger/doc_part'
module Rspec
  module Autoswagger
    class DocParts

      attr_reader :specification, :info, :paths, :definitions
      attr_accessor :output_path

      DEFAULT_OUTPUT_PATH = './tmp'

      def initialize
        @info = Parts::Info.generate_hash
        @paths = {}
        @definitions = {}
        @specification = {}
      end

      def output_path
        @output_path || DEFAULT_OUTPUT_PATH
      end

      def add(rspec_core_obj, example)
        doc_part = DocPart.new(rspec_core_obj, example)
        path, param_definitions = doc_part.create_path
        if paths.keys.include?(path.keys.first)
          paths[path.keys.first].merge!(path.values.first)
        else
          paths.merge!(path)
        end
        definitions.merge!(doc_part.create_definition(output_path))
        definitions.merge!(param_definitions) unless param_definitions.empty?
      end

      def aggregate
        specification.merge!(info)
        specification.merge!({ 'paths' => paths })
        specification.merge!({ 'definitions' => definitions })

        specification
      end

      def to_yaml
        aggregate if specification.empty?
        FileUtils::mkdir_p(output_path)
        YAML.dump(specification, File.open(output_path + '/swagger.yml', 'w'))
      end

    end
  end
end
