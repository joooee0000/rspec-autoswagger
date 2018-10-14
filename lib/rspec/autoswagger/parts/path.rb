require 'rspec/autoswagger/util'

module Rspec
  module Autoswagger
    module Parts
      class Path
        attr_reader :response, :request, :description, :example, :path, :response_name

        def initialize(rspec_core_obj, example, response_name)
          @response = rspec_core_obj.response
          @request = rspec_core_obj.request
          begin
            @description = rspec_core_obj.description
          rescue RSpec::Core::ExampleGroup::WrongScopeError
            @description = ''
          end
          @example = example
          @response_name = response_name
        end

        def path
          path = example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
          if path.blank?
            path = request.path.gsub(Rspec::Autoswagger::API_BASE_PATH, '')
            get_converted_path(path)
          else
            path.split("/").map { |name| name.include?(":") ? "{" + name.gsub(":", "") + "}" : name }.join("/")
          end
        end

        def get_converted_path(path)
          path.split("/").map do |path_element|
            if Util.detect_uuid(path_element)
              "{id}"
            elsif Util.detect_uuid(path_element)
              "{id}"
            else
              path_element
            end
          end.join("/")
        end

        def tags
          tag = request.parameters['controller']
          base_path = Info.generate_hash['basePath']
          tag = ('/' + tag).gsub(base_path.to_s, '')
          [tag]
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

        def param_model_name
          (response_name + '_' + method + '_request_parameter').camelize
        end

        def params
          return @params if @params.present?
          @params = request.parameters.dup
          @params.delete('controller')
          @params.delete('action')
          @params
        end

        def generate_parameters
          schema = {}
          params_arr = []
          params.each do |name, value|
            type = convert_value_to_type(value)
            param_type = predict_param_type(name)
            if param_type == 'body'
              if type == 'array'
                value = value.map { |v| v.to_h } if value.first.class.to_s == 'ActiveSupport::HashWithIndifferentAccess'
                type_hash = SwaggerModel::SwaggerV2.parse_array(value, "dummy", "dummy")
                type_hash.delete('example')
                schema.merge!({ name => { 'type' => type, 'items' => type_hash } })
              else
                schema.merge!({ name => { 'type' => type } })
              end
            else
              if type == 'array'
                value = value.map { |v| v.to_h } if value.first.class.to_s == 'ActiveSupport::HashWithIndifferentAccess'
                type_hash = SwaggerModel::SwaggerV2.parse_array(value, "dummy", "dummy")
                type_hash.delete('example')
                param_hash = {
                  'name' => name,
                  'in' => param_type,
                  'type' => type,
                  'items' => type_hash
                }
              else
                param_hash = {
                  'name' => name,
                  'in' => param_type,
                  'type' => type
                }
              end
              param_hash['required'] = true if param_type == 'path'
              params_arr << param_hash
            end
          end
          param_definitions = {}
          unless schema.empty?
            params_arr << {
                             'name' => 'body',
                             'in' => 'body',
                             'schema' => { "$ref" => "#/definitions/#{param_model_name}" }
                           }
            param_definitions = { param_model_name => { 'type' => 'object', 'properties' => schema } }
          end

          [params_arr, param_definitions]
        end

        def generate_hash
          hash = {}
          path_sym = path
          hash[path] = {}
          hash[path][method] = {}

          hash[path][method] = {}
          hash[path][method]["tags"] = tags
          hash[path][method]["summary"] = ''
          hash[path][method]["description"] = description

          params, param_definitions = generate_parameters
          hash[path][method]["parameters"] = params

          hash[path][method]["produces"] = ['application/json']
          hash[path][method]["responses"] = {}
          hash[path][method]["responses"][status] = {}
          hash[path][method]["responses"][status]["description"] = response_description
          hash[path][method]["responses"][status]["schema"] = { "$ref" => "#/definitions/#{response_name}" }
          [hash, param_definitions]
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
          method == 'get' ? 'query' : 'body'
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
