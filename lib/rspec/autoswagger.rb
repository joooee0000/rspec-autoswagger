require "rspec/autoswagger/version"
require "rspec/autoswagger/rspec"
require "rspec/autoswagger/doc_parts"

module Rspec
  module Autoswagger

    def self.doc_parts
      @doc_parts ||= DocParts.new
    end
  end
end
