require 'rspec'
require 'rspec/autoswagger/doc_parts'

RSpec.configuration.after(:each, autoswagger: true) do |example|
  Rspec::Autoswagger.doc_parts.add(self, example)
end

RSpec.configuration.after(:suite) do
  Rspec::Autoswagger.doc_parts.aggregate
  Rspec::Autoswagger.doc_parts.to_yaml
end
