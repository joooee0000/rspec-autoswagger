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
          path = example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
          path.split("/").map { |name| name.include?(":") ? "{" + name.gsub(":", "") + "}" : name }.join("/")
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

        def operation_id
          (method + path.gsub('/', '_').gsub(/{|}/, '')).camelize
        end

        def params
          return @params if @params.present?
          @params = request.parameters.dup
          @params.delete('controller')
          @params.delete('action')
          @params
        end

        def generate_parameters
          params.map do |name, value|
            type = convert_value_to_type(value)
            if type == 'array'
              type_hash = SwaggerModel::SwaggerV2.parse_array(value, "dummy", "dummy")
              type_hash.delete('example')
              {
                'name' => name,
                'in' => predict_param_type(name),
                'type' => type,
                'items' => type_hash
              }
            else
              {
                'name' => name,
                'in' => predict_param_type(name),
                'type' => type
              }
            end
          end
        end

        def generate_hash
          hash = {}
          path_sym = path
          hash[path] = {}
          hash[path][method] = {}

          hash[path][method] = {}
          hash[path][method]["tags"] = tags
          hash[path][method]["summary"] = []
          hash[path][method]["description"] = description
          hash[path][method]["operationId"] = operation_id

          hash[path][method]["parameters"] = generate_parameters

          hash[path][method]["produces"] = ['application/json']
          hash[path][method]["responses"] = {}
          hash[path][method]["responses"][status] = {}
          hash[path][method]["responses"][status]["description"] = response_description
          hash[path][method]["responses"][status]["schema"] = { "$ref" => "#/definitions/#{response_name}" }
          hash
        end

        private

        def response_description
          case status.to_i
          when 200
            'successful operation'
          else
            'error operation'
          end
        end

        def predict_param_type(param_name)
          candidates = path.split("/").map { |name| name.gsub(/{|}/, "") }
          return 'path' if candidates.include?(param_name.to_s)
          method == 'get' ? 'query' : 'formData'
        end

        def convert_value_to_type(value)
          if value.to_s == 'true' || value.to_s == 'false'
            'boolean'
          elsif value.is_a?(String)
            'string'
          elsif value.is_a?(Integer)
            'integer'
          elsif value.is_a?(Array)
            'array'
          else
            'string'
          end
        end
      end
    end
  end
end
