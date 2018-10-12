require "rspec/autoswagger/version"
require "rspec/autoswagger/rspec" if ENV["AUTOSWAGGER"]
require "rspec/autoswagger/doc_parts"

module Rspec
  module Autoswagger

    API_BASE_PATH = '/api/v1'

    def self.doc_parts
      @doc_parts ||= DocParts.new
    end
  end
end
