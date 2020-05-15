# Forme::Bs4

Bootstrap 4 extension for [Forme](https://github.com/jeremyevans/forme), based on `forme/bs3`.

![image](https://user-images.githubusercontent.com/6506296/82103711-c3518700-971c-11ea-971e-d50d91a077ba.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'forme-bs4'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install forme-bs4
```

## Usage

As global `Forme` config:

```ruby
require 'forme'
require 'forme/bs4'

Forme.default_config = :bs4
```

For a single form:

```ruby
require 'forme'
require 'forme/bs4'

Forme.form(action: '...', config: :bs4)
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/v-kolesnikov/forme-bs4.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/forme-bs4/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Forme::Bs4 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/v-kolesnikov/forme-bs4/blob/master/CODE_OF_CONDUCT.md).
