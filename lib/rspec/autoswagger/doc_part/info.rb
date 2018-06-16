module Rspec
  module Autoswagger
    module DocPart
      class Info

        DEFAULT_INFO = YAML.load('./config/default_info.yml')

        def initialize
        end

        def generate_hash
          DEFAULT_INFO
        end
      end
    end
  end
end
