# Rspec::Autoswagger

Generate Swagger Specification file automatically by running your rspec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-autoswagger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-autoswagger

## Usage
Set the location path where the result files to output.

Example of Rails below.

```ruby
# config/initializers/rspec_autoswagger.rb
Rspec::Autoswagger.doc_parts.output_path = Rails.root.to_s + '/tmp/autoswagger'
```

Write Rspec as an example below.

```ruby
# spec/requests/book_spec.rb
describe "Books" do
  describe "POST /books", autoswagger: true do
    let(:description) { 'Create New Book' }
    it "create a new book" do
      post "/books", name: "little bear", type: 1
      expect(response.status).to eq 200
    end
  end
end
```

Execute the command, then the result files will be generated at the location you specified.
When you execute rspec without AUTOSWAGGER=1, this gem doesn't do anything.

```
# shell-command
AUTOSWAGGER=1 rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-autoswagger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
