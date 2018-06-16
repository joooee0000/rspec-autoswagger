require 'swagger_model'

module Rspec
  module Autoswagger
    module DocPart
      class Definition
        attr_reader :json, :response_name

        DEFAULT_PATH = '/tmp/specifications'

        def initialize(json, response_name)
          @json = json
          @response_name = response_name
        end

        def tmp_file_path
          Rails.root.to_s + DEFAULT_PATH
        end

        def generate_file
          SwaggerModel::SwaggerV2.create_from_json(
            json_string: json,
            tmp_file_path: tmp_file_path,
            response_name: response_model_name
          )
        end
      end
    end
  end
end
