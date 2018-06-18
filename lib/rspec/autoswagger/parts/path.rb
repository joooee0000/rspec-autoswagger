module Rspec
  module Autoswagger
    module Parts
      class Path
        attr_reader :response, :request, :description, :example, :path, :response_name

        def initialize(rspec_core_obj, example, response_name)
          @response = rspec_core_obj.response
          @request = rspec_core_obj.request
          @description = rspec_core_obj.description
          @example = example
          @response_name = response_name
        end

        def path
          example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
        end

        def tags
          [request.parameters['controller']]
        end

        def status
          response.status
        end

        def method
          request.method.downcase
        end

        def params
          params = request.parameters
          params.delete('controller')
          params.delete('action')
          params
        end

        def generate_parameters
          params.map do |name, value|
            {
              'name' => name,
              'in' => 'path',
              'type' => convert_value_to_type(value)
            }
          end
        end

        def generate_hash
          hash = {}
          hash[path] = {}
          hash[path][method] = {}
          hash[path][method] = {}
          hash[path][method]["tags"] = tags
          hash[path][method]["summary"] = []
          hash[path][method]["description"] = description

          hash[path][method]["parameters"] = generate_parameters

          hash[path][method]["produces"] = ['application/json']
          hash[path][method]["responses"] = {}
          hash[path][method]["responses"][status] = {}
          hash[path][method]["responses"][status]["description"] = "successful operation"
          hash[path][method]["responses"][status]["schema"] = { "$ref" => "#/definitions/#{response_name}" }
          hash
        end

        private

        def convert_value_to_type(value)
          if value.to_s == 'true' || value.to_s == 'false'
            'boolean'
          elsif value.is_a?(String)
            'string'
          elsif value.is_a?(Integer)
            'integer'
          else
            'string'
          end
        end
      end
    end
  end
end
