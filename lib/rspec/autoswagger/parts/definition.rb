require 'swagger_model'

module Rspec
  module Autoswagger
    module Parts
      class Definition
        attr_reader :json, :response_name

        DEFAULT_PATH = './tmp/specifications'

        def initialize(json, response_name)
          @json = json
          @response_name = response_name
        end

        def tmp_file_path
          DEFAULT_PATH
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
            tmp_file_path: tmp_file_path,
            response_name: response_name
          )
        end
      end
    end
  end
end
