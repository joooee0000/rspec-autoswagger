module Rspec
  module Autoswagger
    module Parts
      class Info

        DEFAULT_INFO = YAML.load_file(File.expand_path("../config/default_info.yml", __FILE__))

        def self.generate_hash
          DEFAULT_INFO
        end
      end
    end
  end
end
