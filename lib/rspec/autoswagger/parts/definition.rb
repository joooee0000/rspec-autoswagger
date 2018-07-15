require 'swagger_model'

module Rspec
  module Autoswagger
    module Parts
      class Definition

        attr_reader :json, :response_name, :output_path
        DEFAULT_OUTPUT_PATH = './tmp'

        def initialize(json, response_name, output_path)
          @json = json
          @response_name = response_name
          @output_path = output_path
        end

        def generate_model_definitions
          model_definition_hash = {}
          generate_hash_and_file['models'].each do |key, value|
            model_definition_hash.merge!(value)
          end
          model_definition_hash
        end

        def generate_response_definitions
          generate_hash_and_file['responses']
        end

        def generate_definitions
          model_hash = generate_model_definitions
          response_hash = generate_response_definitions
          response_hash.merge!(model_hash)
          response_hash
        end

        def generate_hash_and_file
          @definition_hash ||= SwaggerModel::SwaggerV2.create_from_json(
            json_string: json,
            output_path: (output_path || DEFAULT_OUTPUT_PATH),
            response_name: response_name
          )
        end
      end
    end
  end
end
