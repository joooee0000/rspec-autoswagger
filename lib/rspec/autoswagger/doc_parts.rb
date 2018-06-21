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
        path = doc_part.create_path
        if paths.keys.include?(path.keys.first)
          paths[path.keys.first].merge!(path.values.first)
        else
          paths.merge!(doc_part.create_path)
        end
        definitions.merge!(doc_part.create_definition)
      end

      def aggregate
        specification.merge!(info)
        specification.merge!({ 'paths' => paths })
        specification.merge!({ 'definitions' => definitions })

        specification
      end

      def to_yaml
        aggregate if specification.empty?

        FileUtils::mkdir_p(Rails.root.to_s + '/tmp/')
        YAML.dump(specification, File.open(Rails.root.to_s + '/tmp/swagger.yml', 'w'))
      end
    end
  end
end
