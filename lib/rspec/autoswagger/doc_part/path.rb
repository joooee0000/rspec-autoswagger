module Rspec
  module Autoswagger
    module DocPart
      class Path
        attr_reader :response, :request, :description, :example, :path, :response_name

        def initialize(rspec_core, example, response_name)
          @response = rspec_core.response
          @request = rspec_core.request
          @description = rspec_core.description
          @example = example
          @response_name = response_name
        end

        def path
          example.full_description[%r<(GET|POST|PATCH|PUT|DELETE) ([^ ]+)>, 2]
        end

        def statsu
          response.status
        end

        def method
          request.method
        end

        def params
          request.parameters
        end

        def generate_hash
          hash = {}
          hash[path] = {}
          hash[path][method] = {}
          hash[path][method] = {}
          hash[path][method]["tags"] = []
          hash[path][method]["summary"] = []
          hash[path][method]["description"] = description
          hash[path][method]["parameters"] = []
          hash[path][method]["parameters"] << { 'name' => 'hoge', 'in' => 'hoge', 'required' => true, 'type' => 'hoge'}
          hash[path][method]["produces"] = ['application/json']
          hash[path][method]["responses"] = {}
          hash[path][method]["responses"][status] = {}
          hash[path][method]["responses"][status]["description"] = "successful operation"
          hash[path][method]["responses"][status]["schema"] = { "$ref" => "#/definitions/#{response_name}" }
          hash
        end
      end
    end
  end
end
